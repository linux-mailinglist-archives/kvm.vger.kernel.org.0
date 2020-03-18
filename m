Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8752918A163
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgCRRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:18:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32036 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbgCRRSC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584551881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=osqxPKvRCIWXWuFT/CxaCeJ4py4f1evn1ExGWO1bP8M=;
        b=CxmbcY8zZ5tZI9wwPlcaSorZl+kNNAsnblWlDCBm0PGSccgToiXydPKrZqislQF8R6iYft
        0sww3HU6wyKGP1RkYFzDXctBuv3TSefAlTA9mOQUpl2eB/uOYkknsl6w5xAgCMjGGFOrUg
        rkf17BIOm8o6isjir8BFQ6Sxg3Rd/XY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-BVyGw7TsPCiko2mW5QDl7g-1; Wed, 18 Mar 2020 13:18:00 -0400
X-MC-Unique: BVyGw7TsPCiko2mW5QDl7g-1
Received: by mail-wr1-f70.google.com with SMTP id c6so12587065wrm.18
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osqxPKvRCIWXWuFT/CxaCeJ4py4f1evn1ExGWO1bP8M=;
        b=YAjPeQTHFnrgiscPDbJtLH6E20+0RxTO9zc0IsdUJlAcNmpyqK5/L62gzrEh3pvtxU
         41Gxv6h6ZbWrM4Ge9aX76h3HIguK87rIQOPg9PgfIQWSieKDgHO0yUrRRx26H2vTqx/S
         DWemN8Vqz9OJkjF4EZYIAthzS5wY2x9XF8XLyeyClw2nSfKz1BQnCbMHOvmJM9Y7yHrn
         NtdGWOEom4etMAfHbF4HdOt9EmF08FyTvlslFEEc0mSndkr5DhNkJAUbz+J00NEmWk2+
         HxJnnRMAFB9jepXCUmaD94+J/wwTKzLXAZWDTBFLJoAKKcWwk3G0I2cuCRr3k8JKIfEr
         1u0Q==
X-Gm-Message-State: ANhLgQ36MZiaSFJUloErCoPGOHksOftbCxvqNIh4apkvPSeK8Q+dHiG/
        mcnsPzr4rbdkSWwFsEYDk7dhcMKV17I4gn0gJSEDPrie5NWzP09VeZyYXapzDxHEdVIVpqN94Ov
        IZNQvYgJFuoQ6
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr6613211wru.253.1584551877717;
        Wed, 18 Mar 2020 10:17:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvL0SbgPICsxsmop2pNCAqWqf7Jg1CLWlDmbG7uRzFLFIagUltToENth0Nzi/IRSagEPvFVBw==
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr6613188wru.253.1584551877460;
        Wed, 18 Mar 2020 10:17:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r3sm10531597wrw.76.2020.03.18.10.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 10:17:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
Date:   Wed, 18 Mar 2020 18:17:52 +0100
Message-Id: <20200318171752.173073-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200318171752.173073-1-vkuznets@redhat.com>
References: <20200318171752.173073-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
do so is not very straightforward: first, we set
hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
introducing 'enum vmcs_type' parameter to alloc_vmcs_cpu()/alloc_vmcs().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 34 +++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    | 12 +++++++++---
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8578513907d7..7170c7d8aa1d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4585,7 +4585,7 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
 	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
 
 	if (!loaded_vmcs->shadow_vmcs) {
-		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
+		loaded_vmcs->shadow_vmcs = alloc_vmcs(SHADOW_VMCS);
 		if (loaded_vmcs->shadow_vmcs)
 			vmcs_clear(loaded_vmcs->shadow_vmcs);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f7ee7c31fe8c..534418b58247 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2541,7 +2541,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
 	struct page *pages;
@@ -2553,13 +2553,21 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	vmcs = page_address(pages);
 	memset(vmcs, 0, vmcs_config.size);
 
-	/* KVM supports Enlightened VMCS v1 only */
-	if (static_branch_unlikely(&enable_evmcs))
+	/*
+	 * When eVMCS is enabled, vmcs->revision_id needs to be set to the
+	 * supported eVMCS version (KVM_EVMCS_VERSION) instead of revision_id
+	 * reported by MSR_IA32_VMX_BASIC.
+	 *
+	 * However, even though not explicitly documented by TLFS, VMXArea
+	 * passed as VMXON argument should still be marked with revision_id
+	 * reported by physical CPU.
+	 */
+	if (type != VMXON_VMCS && static_branch_unlikely(&enable_evmcs))
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
 		vmcs->hdr.revision_id = vmcs_config.revision_id;
 
-	if (shadow)
+	if (type == SHADOW_VMCS)
 		vmcs->hdr.shadow_vmcs = 1;
 	return vmcs;
 }
@@ -2586,7 +2594,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 {
-	loaded_vmcs->vmcs = alloc_vmcs(false);
+	loaded_vmcs->vmcs = alloc_vmcs(VMCS);
 	if (!loaded_vmcs->vmcs)
 		return -ENOMEM;
 
@@ -2639,25 +2647,13 @@ static __init int alloc_vmxon_regions(void)
 	for_each_possible_cpu(cpu) {
 		struct vmcs *vmcs;
 
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
+		/* The VMXON region is really just a special type of VMCS. */
+		vmcs = alloc_vmcs_cpu(VMXON_VMCS, cpu, GFP_KERNEL);
 		if (!vmcs) {
 			free_vmxon_regions();
 			return -ENOMEM;
 		}
 
-		/*
-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
-		 * revision_id reported by MSR_IA32_VMX_BASIC.
-		 *
-		 * However, even though not explicitly documented by
-		 * TLFS, VMXArea passed as VMXON argument should
-		 * still be marked with revision_id reported by
-		 * physical CPU.
-		 */
-		if (static_branch_unlikely(&enable_evmcs))
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
-
 		per_cpu(vmxarea, cpu) = vmcs;
 	}
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index be93d597306c..b353e8cc3e7b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -488,16 +488,22 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
+enum vmcs_type {
+	VMXON_VMCS,
+	VMCS,
+	SHADOW_VMCS,
+};
+
+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
-static inline struct vmcs *alloc_vmcs(bool shadow)
+static inline struct vmcs *alloc_vmcs(enum vmcs_type type)
 {
-	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
+	return alloc_vmcs_cpu(type, raw_smp_processor_id(),
 			      GFP_KERNEL_ACCOUNT);
 }
 
-- 
2.25.1

