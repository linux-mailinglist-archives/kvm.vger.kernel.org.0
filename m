Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC023538FF7
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 13:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiEaLm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 07:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbiEaLmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 07:42:55 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214038217E;
        Tue, 31 May 2022 04:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653997375; x=1685533375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1AvcBprIOSQItFD8cn3+FAqAk16pR3Q+CjOoSzkn5lI=;
  b=TPMFPHA26zEXg8TTMvNSGpKDwAhK4+z4DEFDhzcvYDmnuii6VlnF6DdQ
   e+/BFM5TjiPUAH80bhkdJ8lahiO2UnZfEfeJRP1+3PcAc2qAK6OrJtrqn
   C9Zk8yFLAhi09WU7NwWXUh1eCd1eR/Ny9cYGJ++ljSOcrmYnTAa8i4IB0
   s=;
X-IronPort-AV: E=Sophos;i="5.91,265,1647302400"; 
   d="scan'208";a="93334418"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 31 May 2022 11:17:00 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 14946220F3F;
        Tue, 31 May 2022 11:16:55 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 31 May 2022 11:16:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 31 May 2022 11:16:54 +0000
Received: from dev-dsk-jalliste-1c-387c3ddf.eu-west-1.amazon.com
 (10.13.250.64) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36 via Frontend Transport; Tue, 31 May 2022
 11:16:51 +0000
From:   Jack Allister <jalliste@amazon.com>
To:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC:     <jalliste@amazon.com>, <dwmw@amazon.co.uk>, <diapop@amazon.co.uk>,
        <metikaya@amazon.co.uk>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: VMX: CPU frequency scaling for intel x86_64 KVM guests
Date:   Tue, 31 May 2022 11:16:44 +0000
Message-ID: <20220531111644.41128-1-jalliste@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A VMM can control a vCPU's CPU frequency by interfacing with KVM via
the vCPU file descriptor to enable/set CPU frequency scaling for a
guest. Instead of creating a separate IOCTL to this this, KVM capabil-
ities are extended to include a capability called
KVM_CAP_CPU_FREQ_SCALING.

A generic set_cpu_freq interface is added to kvm_x86_ops
to allow for architecture (AMD/Intel) independent CPU frequency
scaling setting.

For Intel platforms, Hardware-Controlled Performance States (HWP) are
used to implement CPU scaling within the guest. Further information on
this mechanism can be seen in Intel SDM Vol 3B (section 14.4). The CPU
frequency is set as soon as this function is called and is kept running
until explicitly reset or set again.

Currently the AMD frequency setting interface is left unimplemented.

Please note that CPU frequency scaling will have an effect on host
processing in it's current form. To change back to full performance
when running in host context an IOCTL with a frequency value of 0
is needed to run back at uncapped speed.

Signed-off-by: Jack Allister <jalliste@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/vmx/vmx.c          | 91 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 16 ++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 110 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ae220f88f00d..d2efc2ce624f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1169,6 +1169,8 @@ struct kvm_x86_ops {
 	bool (*rdtscp_supported)(void);
 	bool (*invpcid_supported)(void);
 
+	int (*set_cpu_freq_scaling)(struct kvm_vcpu *vcpu, u8 freq_100mhz);
+
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6499f371de58..beee39b57b13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1699,6 +1699,95 @@ static bool vmx_invpcid_supported(void)
 	return cpu_has_vmx_invpcid();
 }
 
+static int vmx_query_cpu_freq_valid_freq(u8 freq)
+{
+#define MASK_PERF 0xFF
+#define CAP_HIGHEST_SHIFT 0
+#define CAP_LOWEST_SHIFT 24
+#define CAP_HIGHEST_MASK (MASK_PERF << CAP_HIGHEST_SHIFT)
+#define CAP_LOWEST_MASK (MASK_PERF << CAP_LOWEST_SHIFT)
+	u64 cap_msr;
+	u8 highest, lowest;
+
+	/* Query highest and lowest supported scaling. */
+	rdmsrl(MSR_HWP_CAPABILITIES, cap_msr);
+	highest = (u8)(cap_msr & CAP_HIGHEST_MASK);
+	lowest = (u8)((cap_msr & CAP_LOWEST_MASK) >> CAP_LOWEST_SHIFT);
+
+	if (freq < lowest || freq > highest)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void vmx_set_cpu_freq_uncapped(void)
+{
+#define SHIFT_DESIRED_PERF 16
+#define SHIFT_MAX_PERF 8
+#define SHIFT_MIN_PERF 0
+
+	u64 cap_msr, req_msr;
+	u8 highest, lowest;
+
+	/* Query the capabilities. */
+	rdmsrl(MSR_HWP_CAPABILITIES, cap_msr);
+	highest = (u8)(cap_msr & CAP_HIGHEST_MASK);
+	lowest = (u8)((cap_msr & CAP_LOWEST_MASK) >> CAP_LOWEST_SHIFT);
+
+	/* Set the desired to highest performance. */
+	req_msr = ((highest & MASK_PERF) << SHIFT_DESIRED_PERF) |
+		((highest & MASK_PERF) << SHIFT_MAX_PERF) |
+		((lowest & MASK_PERF) << SHIFT_MIN_PERF);
+	wrmsrl(MSR_HWP_REQUEST, req_msr);
+}
+
+static void vmx_set_cpu_freq_capped(u8 freq_100mhz)
+{
+	u64 req_msr;
+
+	/* Populate the variable used for setting the HWP request. */
+	req_msr = ((freq_100mhz & MASK_PERF) << SHIFT_DESIRED_PERF) |
+		((freq_100mhz & MASK_PERF) << SHIFT_MAX_PERF) |
+		((freq_100mhz & MASK_PERF) << SHIFT_MIN_PERF);
+
+	wrmsrl(MSR_HWP_REQUEST, req_msr);
+}
+
+static int vmx_set_cpu_freq_scaling(struct kvm_vcpu *vcpu, u8 freq_100mhz)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 pm_before, req_msr;
+	int rc;
+
+	/* Is HWP scaling supported? */
+	if (!this_cpu_has(X86_FEATURE_HWP))
+		return -ENODEV;
+
+	/*
+	 * HWP needs to be enabled to query & use capabilities.
+	 * This bit is W1Once so cannot be cleared after.
+	 */
+	rdmsrl(MSR_PM_ENABLE, pm_before);
+	if ((pm_before & 1) == 0)
+		wrmsrl(MSR_PM_ENABLE, pm_before | 1);
+
+	/*
+	 * Check if setting to a specific value, if being set
+	 * to zero this means return to uncapped frequency.
+	 */
+	if (freq_100mhz) {
+		rc = vmx_query_cpu_freq_valid_freq(freq_100mhz);
+
+		if (rc)
+			return rc;
+
+		vmx_set_cpu_freq_capped(freq_100mhz);
+	} else
+		vmx_set_cpu_freq_uncapped();
+
+	return 0;
+}
+
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -8124,6 +8213,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.rdtscp_supported = vmx_rdtscp_supported,
 	.invpcid_supported = vmx_invpcid_supported,
 
+	.set_cpu_freq_scaling = vmx_set_cpu_freq_scaling,
+
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c33423a1a13d..9ae2ab102e01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3669,6 +3669,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_VAR_MTRR_COUNT:
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
+	case KVM_CAP_CPU_FREQ_SCALING:
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XEN
@@ -4499,6 +4500,19 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static int kvm_cap_set_cpu_freq(struct kvm_vcpu *vcpu,
+				       struct kvm_enable_cap *cap)
+{
+	u8 freq = (u8)cap->args[0];
+
+	/* Query whether this platform (Intel or AMD) support setting. */
+	if (!kvm_x86_ops.set_cpu_freq_scaling)
+		return -ENODEV;
+
+	/* Attempt to set to the frequency specified. */
+	return kvm_x86_ops.set_cpu_freq_scaling(vcpu, freq);
+}
+
 /*
  * kvm_set_guest_paused() indicates to the guest kernel that it has been
  * stopped by the hypervisor.  This function will be called from the host only.
@@ -4553,6 +4567,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
 	case KVM_CAP_SET_VAR_MTRR_COUNT:
 		return kvm_mtrr_set_var_mtrr_count(vcpu, cap->args[0]);
+	case KVM_CAP_CPU_FREQ_SCALING:
+		return kvm_cap_set_cpu_freq(vcpu, cap);
 
 	default:
 		return -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 831be0d2d5e4..273a3ab5590e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -874,6 +874,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_NO_POLL_ON_HLT 100003
 #define KVM_CAP_MMU_USE_VMA_CAPMEM 100004
 #define KVM_CAP_MMU_SUPPORT_DYNAMIC_CAPMEM 100005
+#define KVM_CAP_CPU_FREQ_SCALING 100006
 
 #define KVM_CAP_IRQCHIP	  0
 #define KVM_CAP_HLT	  1
-- 
2.32.0

