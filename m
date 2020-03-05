Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CBF17A2C2
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgCEKBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:01:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727176AbgCEKBb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 05:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdo7x8MpejMs3Bq5JO4MC2hL+YdmdvCezwWgTT9glAE=;
        b=O3cdxU2AafE2P7O+Ld9eMDbqe/oH7LltgfqY9isOaT3OSZafstELDhhyDzOmAg9L9bGreD
        GU+6j9D3g5zhqPUc+GBBN+a69/RqpZ96rVwNmLVBADsb9h17aTw3CDPzaOLaGK94DUXcBT
        fKBRcuXxTai73eyKMeUWPl+TMph6Ios=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-6ATMs-9EP7G5RN9cgAtsHw-1; Thu, 05 Mar 2020 05:01:29 -0500
X-MC-Unique: 6ATMs-9EP7G5RN9cgAtsHw-1
Received: by mail-wr1-f72.google.com with SMTP id m13so2102058wrw.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 02:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdo7x8MpejMs3Bq5JO4MC2hL+YdmdvCezwWgTT9glAE=;
        b=uTlB1KiFseErLHIWoYBmJE92aB+uNooToVGri52cUyO+hHYPeV0Iyi++ZNFpAU7s/1
         +8Ayzkz2TnyBitB9pGH4VYRckwYc/7+MeIQMPFNJ+6aLH1mVXPBxO6PUN1SY41kkzP61
         gO35epsu89uYNMj7vizQfMEOyHPHQ3i/RZ7h84z76skZGyb4KszY3SPqCWjiYA/VQLGT
         f0FYTSenmr08Qssgf/bhaWbGi24UE+mxcMo/wJGCJS+wjJt45XXpyYQLRQ53aRwG9BMR
         ejzNTPze7Cwt+nzIwTLTLXPLnzmfvpxpzy/4r3JjNudIiMHcUXXBLTGwUf2SzpsaGawI
         umiw==
X-Gm-Message-State: ANhLgQ1Q9tBWaGqShhNaoly1Kjg2CM4QInz3rvMZ94mbIWN/2EMP7qV/
        ndb6Ld7fJLRbOduyqE5J2mgLaja70/U56uMRSedBt34dtK4K62Mwe8uWFm7cNQYVxtdFXHAwFU3
        pa5IrQXkFywBS
X-Received: by 2002:a1c:7719:: with SMTP id t25mr8256323wmi.7.1583402488286;
        Thu, 05 Mar 2020 02:01:28 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuR36k+H5I0bH9ygje4jHPz2Ku/Ml99/fjX64Va9n4SX7D7Hg8q7BBs/EMdEjurRVCvPvehUw==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr8256297wmi.7.1583402488063;
        Thu, 05 Mar 2020 02:01:28 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f207sm10440025wme.9.2020.03.05.02.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:01:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: VMX: untangle VMXON revision_id setting when using eVMCS
Date:   Thu,  5 Mar 2020 11:01:23 +0100
Message-Id: <20200305100123.1013667-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305100123.1013667-1-vkuznets@redhat.com>
References: <20200305100123.1013667-1-vkuznets@redhat.com>
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
introducing 'enum vmx_area_type' parameter to what is now known as
alloc_vmx_area_cpu().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 31 +++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dab19e4e5f2b..4ee19fb35cde 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2554,7 +2554,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
+struct vmcs *alloc_vmx_area_cpu(enum vmx_area_type type, int cpu, gfp_t flags)
 {
 	int node = cpu_to_node(cpu);
 	struct page *pages;
@@ -2566,13 +2566,21 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
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
+	if (type != VMXON_REGION && static_branch_unlikely(&enable_evmcs))
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
 		vmcs->hdr.revision_id = vmcs_config.revision_id;
 
-	if (shadow)
+	if (type == SHADOW_VMCS_REGION)
 		vmcs->hdr.shadow_vmcs = 1;
 	return vmcs;
 }
@@ -2652,25 +2660,12 @@ static __init int alloc_vmxon_regions(void)
 	for_each_possible_cpu(cpu) {
 		struct vmcs *vmcs;
 
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
+		vmcs = alloc_vmx_area_cpu(VMXON_REGION, cpu, GFP_KERNEL);
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
index e64da06c7009..7bdac5a50432 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -489,7 +489,13 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
+enum vmx_area_type {
+	VMXON_REGION,
+	VMCS_REGION,
+	SHADOW_VMCS_REGION,
+};
+
+struct vmcs *alloc_vmx_area_cpu(enum vmx_area_type type, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
@@ -498,8 +504,8 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
 {
-	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
-			      GFP_KERNEL_ACCOUNT);
+	return alloc_vmx_area_cpu(shadow ? SHADOW_VMCS_REGION : VMCS_REGION,
+				  raw_smp_processor_id(), GFP_KERNEL_ACCOUNT);
 }
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
-- 
2.24.1

