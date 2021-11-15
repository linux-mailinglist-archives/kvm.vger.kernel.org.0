Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADAF450A20
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhKOQyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5DFC0613B9
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FGlrcKv+6PnWgwSYWzEFbjgJm9dWdxrZzn3wiX/4PMI=; b=XxaivnWyowOpkVShYGSjsBoh7q
        svB8P1awBr0/B3VX26wJbKQtYQ9aimDtyZGWzj4fnFkNJiB6Jch1kHvOUUrlCJ045uJVQt+CZVnqu
        Ki+F3zKqIMVMrwgbvpj1r61zAMjcBJQfgHNsPX72uhuo5G/JZkVWpCzbDWHg2TJiWmd9S851nqSmC
        LaU7StdMJrAPc40N3fokxswoTsVTSxQya6Xmmg0Frv5/O2kC/DRu0qmBaHHjGF8x6BU1AKLItnxIQ
        aR2oh8/QESi1r73RgS/hT8J2SWGGli4dhGcSWuq7L18PwMEE/LPfQcYEuwMkvNCa14bDUMU4XMc9B
        1itMlmMg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBf-00GAgA-13; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wi-Mr; Mon, 15 Nov 2021 16:50:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 05/11] KVM: nVMX: Use kvm_{read,write}_guest_cached() for shadow_vmcs12
Date:   Mon, 15 Nov 2021 16:50:24 +0000
Message-Id: <20211115165030.7422-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115165030.7422-1-dwmw2@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Using kvm_vcpu_map() for reading from the guest is entirely gratuitous,
when all we do is a single memcpy and unmap it again. Fix it up to use
kvm_read_guest()... but in fact I couldn't bring myself to do that
without also making it use a gfn_to_hva_cache for both that *and* the
copy in the other direction.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 24 +++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b213ca966d41..7e2a99f435b6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -670,33 +670,39 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 static void nested_cache_shadow_vmcs12(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
-	struct kvm_host_map map;
-	struct vmcs12 *shadow;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
 	    vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return;
 
-	shadow = get_shadow_vmcs12(vcpu);
-
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->vmcs_link_pointer), &map))
+	if (ghc->gpa != vmcs12->vmcs_link_pointer &&
+	    kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc,
+				      vmcs12->vmcs_link_pointer, VMCS12_SIZE))
 		return;
 
-	memcpy(shadow, map.hva, VMCS12_SIZE);
-	kvm_vcpu_unmap(vcpu, &map, false);
+	kvm_read_guest_cached(vmx->vcpu.kvm, ghc, get_shadow_vmcs12(vcpu),
+			      VMCS12_SIZE);
 }
 
 static void nested_flush_cached_shadow_vmcs12(struct kvm_vcpu *vcpu,
 					      struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
 	    vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return;
 
-	kvm_write_guest(vmx->vcpu.kvm, vmcs12->vmcs_link_pointer,
-			get_shadow_vmcs12(vcpu), VMCS12_SIZE);
+	if (ghc->gpa != vmcs12->vmcs_link_pointer &&
+	    kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc,
+				      vmcs12->vmcs_link_pointer, VMCS12_SIZE))
+		return;
+
+	kvm_write_guest_cached(vmx->vcpu.kvm, ghc, get_shadow_vmcs12(vcpu),
+			       VMCS12_SIZE);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a4ead6023133..cdadbd5dc0ca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -141,6 +141,11 @@ struct nested_vmx {
 	 */
 	struct vmcs12 *cached_shadow_vmcs12;
 
+	/*
+	 * GPA to HVA cache for accessing vmcs12->vmcs_link_pointer
+	 */
+	struct gfn_to_hva_cache shadow_vmcs12_cache;
+
 	/*
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
-- 
2.31.1

