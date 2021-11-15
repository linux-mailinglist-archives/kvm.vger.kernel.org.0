Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB14450A1C
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhKOQyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E93AC061206
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XWuCiV6KRAzWQHmjQd4TkMvfmrvQ/SeQOO6MC6MoE+E=; b=PUnaHy97pg5c8T8Oo1fHYLyDOR
        w71QFJ3XN6vGX4EzGglKsymJ9a1T6kA5BtS3NOgEO2W6sJxvZakYRjc+jG8wQyF1U8LJv4mGODbzY
        AGbAioSxPk/hEbLh2lrevkDCnxdAkOQR+mbVAprXRNG39gkGQ2zdVx6fLxLzqcgBoAhxW08ypb7pX
        GZ8r0Cfe0w6tcPHNzB/Opc8RqQfY0j1VyC1UGyV5M+2Vh4SUpvzbQmsn7mcg53ChEV92TXi5WKYb5
        I9GWNmyyHw+ZTAWXdCfqftGlJJpY/O8EeAuOhL9r6LdotUOaPF38qlnggfgZfZsEeKRUfQ1Mm4cvt
        tk1efMHw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBf-00GAgD-4B; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wm-PE; Mon, 15 Nov 2021 16:50:30 +0000
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
Subject: [PATCH 06/11] KVM: nVMX: Use kvm_read_guest_offset_cached() for nested VMCS check
Date:   Mon, 15 Nov 2021 16:50:25 +0000
Message-Id: <20211115165030.7422-6-dwmw2@infradead.org>
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

Kill another mostly gratuitous kvm_vcpu_map() which could just use the
userspace HVA for it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7e2a99f435b6..070bf9558b2a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2916,9 +2916,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
-	int r = 0;
-	struct vmcs12 *shadow;
-	struct kvm_host_map map;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
+	struct vmcs_hdr hdr;
 
 	if (vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return 0;
@@ -2926,17 +2926,21 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 	if (CC(!page_address_valid(vcpu, vmcs12->vmcs_link_pointer)))
 		return -EINVAL;
 
-	if (CC(kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->vmcs_link_pointer), &map)))
-		return -EINVAL;
+	if (ghc->gpa != vmcs12->vmcs_link_pointer &&
+	    CC(kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc,
+					 vmcs12->vmcs_link_pointer, VMCS12_SIZE)))
+                return -EINVAL;
 
-	shadow = map.hva;
+	if (CC(kvm_read_guest_offset_cached(vcpu->kvm, ghc, &hdr,
+					    offsetof(struct vmcs12, hdr),
+					    sizeof(hdr))))
+		return -EINVAL;
 
-	if (CC(shadow->hdr.revision_id != VMCS12_REVISION) ||
-	    CC(shadow->hdr.shadow_vmcs != nested_cpu_has_shadow_vmcs(vmcs12)))
-		r = -EINVAL;
+	if (CC(hdr.revision_id != VMCS12_REVISION) ||
+	    CC(hdr.shadow_vmcs != nested_cpu_has_shadow_vmcs(vmcs12)))
+		return -EINVAL;
 
-	kvm_vcpu_unmap(vcpu, &map, false);
-	return r;
+	return 0;
 }
 
 /*
-- 
2.31.1

