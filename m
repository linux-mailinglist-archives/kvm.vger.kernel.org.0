Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DB1450A19
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKOQyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F849C061202
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JuoSo/G97R5dKFLdH+8BNyyZuYp+lWm9XSTMSBMRzQc=; b=TlHbt3oG2dMA0EQJ27Y1CXY1He
        cil/C35P3aBt9JqpC4a9sUSrDqIi/Zi15Q1TNvUrHWe+LVchkOHk/A5CMyNHOwBrYx17MmgyC0yBr
        90bc32PJDQejZ83aJWWQPXfpIBCNItjwv0zAaQtq+9s+lnBYPUY2DqEVYsatXz4NGMYTMAGJf82LP
        C3sKZM8io+h2rYaIfXNFLuWmSm7U4tWV4qACaJg6gR5IbOmlliQZ3s+rJrGPLbP82r0YYlc3sIrLG
        eCM7IpojJvxw2PFjZ8qbX4gowK0lukAbuQKfwDgXcLfq2/eMW/aGs+iVBlc+4dnOamYD/ZuOKGDXX
        7tnXkQjA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBf-00GAgE-6t; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wq-Sr; Mon, 15 Nov 2021 16:50:30 +0000
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
Subject: [PATCH 07/11] KVM: nVMX: Use a gfn_to_hva_cache for vmptrld
Date:   Mon, 15 Nov 2021 16:50:26 +0000
Message-Id: <20211115165030.7422-7-dwmw2@infradead.org>
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

And thus another call to kvm_vcpu_map() can die.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 070bf9558b2a..280f34ea02c3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5274,10 +5274,11 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return 1;
 
 	if (vmx->nested.current_vmptr != vmptr) {
-		struct kvm_host_map map;
-		struct vmcs12 *new_vmcs12;
+		struct gfn_to_hva_cache *ghc = &vmx->nested.vmcs12_cache;
+		struct vmcs_hdr hdr;
 
-		if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmptr), &map)) {
+		if (ghc->gpa != vmptr &&
+		    kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, vmptr, VMCS12_SIZE)) {
 			/*
 			 * Reads from an unbacked page return all 1s,
 			 * which means that the 32 bits located at the
@@ -5288,12 +5289,16 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
 		}
 
-		new_vmcs12 = map.hva;
+		if (kvm_read_guest_offset_cached(vcpu->kvm, ghc, &hdr,
+						 offsetof(struct vmcs12, hdr),
+						 sizeof(hdr))) {
+			return nested_vmx_fail(vcpu,
+				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
+		}
 
-		if (new_vmcs12->hdr.revision_id != VMCS12_REVISION ||
-		    (new_vmcs12->hdr.shadow_vmcs &&
+		if (hdr.revision_id != VMCS12_REVISION ||
+		    (hdr.shadow_vmcs &&
 		     !nested_cpu_has_vmx_shadow_vmcs(vcpu))) {
-			kvm_vcpu_unmap(vcpu, &map, false);
 			return nested_vmx_fail(vcpu,
 				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
 		}
@@ -5304,8 +5309,11 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		 * Load VMCS12 from guest memory since it is not already
 		 * cached.
 		 */
-		memcpy(vmx->nested.cached_vmcs12, new_vmcs12, VMCS12_SIZE);
-		kvm_vcpu_unmap(vcpu, &map, false);
+		if (kvm_read_guest_cached(vcpu->kvm, ghc, vmx->nested.cached_vmcs12,
+					  VMCS12_SIZE)) {
+			return nested_vmx_fail(vcpu,
+				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
+		}
 
 		set_current_vmptr(vmx, vmptr);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cdadbd5dc0ca..4df2ac24ffc1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -146,6 +146,11 @@ struct nested_vmx {
 	 */
 	struct gfn_to_hva_cache shadow_vmcs12_cache;
 
+	/*
+	 * GPA to HVA cache for VMCS12
+	 */
+	struct gfn_to_hva_cache vmcs12_cache;
+
 	/*
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
-- 
2.31.1

