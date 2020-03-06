Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1ED17BD76
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCFNCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:02:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726646AbgCFNCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583499744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEYmwO34ejd5Fehx/7gH5NvWBz/ItGWjm6SWsG9bpRU=;
        b=bJk33B0Tex+iaUwj9UzsUTme93xfSZSYb1Ui602YZIW+Gj3ENUMPmQ88JKZl6+CeL7Lz7Z
        QcwJdfWMGYCrT33rGOj31cNL9dUlbs+Hn0QYNg7tQDQh2b/ubgqUau8e/Z82cu/WOTKUM1
        0MRyT/mC1G5BPxuOGcIXz0fYAUJ6XKs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-7as33T5EPfCjUPYM76-Hew-1; Fri, 06 Mar 2020 08:02:22 -0500
X-MC-Unique: 7as33T5EPfCjUPYM76-Hew-1
Received: by mail-wr1-f72.google.com with SMTP id n12so954782wrp.19
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 05:02:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DEYmwO34ejd5Fehx/7gH5NvWBz/ItGWjm6SWsG9bpRU=;
        b=SXx2cy2odorSePBuNn01CV4CnftPDocFUvVujo7P5GFsoirSGNfo/KvCLAGrTitv3y
         GowhKatt72PtaMrJZOOUkyvnrDWaBYtrzsbqOKbdcaBo1/v6/JdaHJKc7GEQbOvBu9/g
         AyXMDiPY0Iu4sZTPqvKpswn7Yu7ClgChwmoVvnFsDAJC1b1R13F3qxwHdm4BdbZHnlo8
         gy5bGWsHy0tOoah+5tnLJAYbdb/13s9IdklWqPDpp4S+j7cPh8JXIuJDobMUKwyTqo/o
         uA2jVHF9Jhmo0MlW8q7yrdTXZaAaQXfwFWpBS6VBT16ifdMtMhInr/AzVYLr4z7eOi9z
         D1rg==
X-Gm-Message-State: ANhLgQ2CHTzi8rIRGuC8b1R7NuYot9uZHWjMt4tOFl8LCS0FzqhTkSZX
        LpVBMrAGA+8pznVonDEs2BUiBQm7g9oWhJex8AA8t6rrw0Ll3xlejqn/C3Se96/vSsJ3Ce/hIGV
        R0eouvL6RPejM
X-Received: by 2002:a5d:4cc6:: with SMTP id c6mr3928183wrt.30.1583499741191;
        Fri, 06 Mar 2020 05:02:21 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvzKd18Q9ZyAetOJWJu+50Kd94+STONaewuv+fP1bA7GRouCbY0I5lzU1pvtQCmm1vExEeYRg==
X-Received: by 2002:a5d:4cc6:: with SMTP id c6mr3928150wrt.30.1583499740818;
        Fri, 06 Mar 2020 05:02:20 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i67sm26613243wri.50.2020.03.06.05.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:02:20 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
Date:   Fri,  6 Mar 2020 14:02:15 +0100
Message-Id: <20200306130215.150686-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306130215.150686-1-vkuznets@redhat.com>
References: <20200306130215.150686-1-vkuznets@redhat.com>
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
index e920d7834d73..8c0ed62b29be 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4566,7 +4566,7 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
 	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
 
 	if (!loaded_vmcs->shadow_vmcs) {
-		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
+		loaded_vmcs->shadow_vmcs = alloc_vmcs(SHADOW_VMCS_REGION);
 		if (loaded_vmcs->shadow_vmcs)
 			vmcs_clear(loaded_vmcs->shadow_vmcs);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dab19e4e5f2b..a45d3721e7d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2554,7 +2554,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
+struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags)
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
@@ -2599,7 +2607,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 {
-	loaded_vmcs->vmcs = alloc_vmcs(false);
+	loaded_vmcs->vmcs = alloc_vmcs(VMCS_REGION);
 	if (!loaded_vmcs->vmcs)
 		return -ENOMEM;
 
@@ -2652,25 +2660,13 @@ static __init int alloc_vmxon_regions(void)
 	for_each_possible_cpu(cpu) {
 		struct vmcs *vmcs;
 
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
+		/* The VMXON region is really just a special type of VMCS. */
+		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
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
index e64da06c7009..a5eb92638ac2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -489,16 +489,22 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
-struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
+enum vmcs_type {
+	VMXON_REGION,
+	VMCS_REGION,
+	SHADOW_VMCS_REGION,
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
2.24.1

