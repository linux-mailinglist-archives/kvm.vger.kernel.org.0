Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B85688502
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 18:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjBBRAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 12:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBBRAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 12:00:37 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80485E3B2
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 09:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1675357236; x=1706893236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KIRwP75tvuNi1yYQFq6op3jGLo9azq84yByTC4LJWCU=;
  b=Er+ynV+hT+OtBrfOxCW0oXXBNg0goJamnXmAg8OosqLM3K1KrG6xiZ4I
   jYDlWGVP1DqUb02WkzaUKuxOZ0XiDxQNAOujVSc3/0lJOAtUWkoq0Jna/
   7XoUMxAJhm9Dxa4lFwNesrsKCuwoWF3bGvNvAEwJBKtBKGlAvVdyxWSAC
   8=;
X-IronPort-AV: E=Sophos;i="5.97,268,1669075200"; 
   d="scan'208";a="294748826"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 17:00:32 +0000
Received: from EX13D39EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 8355C6098E;
        Thu,  2 Feb 2023 17:00:30 +0000 (UTC)
Received: from EX19D018EUC003.ant.amazon.com (10.252.51.231) by
 EX13D39EUC001.ant.amazon.com (10.43.164.85) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 2 Feb 2023 17:00:29 +0000
Received: from u2fd957c5393b54.ant.amazon.com (10.43.160.120) by
 EX19D018EUC003.ant.amazon.com (10.252.51.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Thu, 2 Feb 2023 17:00:24 +0000
From:   Simon Veith <sveith@amazon.de>
To:     <dwmw2@infradead.org>
CC:     <dff@amazon.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <oupton@google.com>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <sveith@amazon.de>, <tglx@linutronix.de>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>
Subject: [PATCH v2] KVM: x86: add KVM_VCPU_TSC_VALUE attribute
Date:   Thu, 2 Feb 2023 17:59:50 +0100
Message-ID: <20230202165950.483430-1-sveith@amazon.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f3a957786a82bdd41fe558c40ec93c3fb9ea2ee2.camel@infradead.org>
References: <f3a957786a82bdd41fe558c40ec93c3fb9ea2ee2.camel@infradead.org>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D42UWB004.ant.amazon.com (10.43.161.99) To
 EX19D018EUC003.ant.amazon.com (10.252.51.231)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Time Stamp Counter (TSC) value register can be set to an absolute
value using the KVM_SET_MSRS ioctl. Since this is a per-vCPU register,
and vCPUs are often managed by separate threads, setting a uniform TSC
value across all vCPUs is challenging: After liveupdate or live
migration, the TSC value may need to be adjusted to account for the
incurred downtime.

Ideally, we want such an adjustment to happen uniformly across all
vCPUs; however, if we compute the offset centrally, the TSC value may
become out of date due to scheduling delays by the time that each vCPU
thread gets around to issuing KVM_SET_MSRS. Such delays can lead to
unaccounted pause time (the guest observes that its system clock has
fallen behind the NTP reference time).

To avoid such inaccuracies from the use of KVM_SET_MSRS, there is an
alternative attribute KVM_VCPU_TSC_OFFSET which, rather than setting an
absolute TSC value, defines it in terms of the offset to be applied
relative to the host's TSC value. Using this attribute, the TSC can be
adjusted reliably by userspace, but only if TSC scaling remains
unchanged, i.e., in the case of liveupdate on the same host, and not
when live migrating an instance between hosts with different TSC scaling
parameters.

In the case of live migration, using the KVM_VCPU_TSC_OFFSET approach to
preserve the TSC value and apply a known offset would require
duplicating the TSC scaling computations in userspace to account for
frequency differences between source and destination TSCs.

Hence, if userspace wants to set the TSC to some known value without
having to deal with TSC scaling, and while also being resilient against
scheduling delays, neither KVM_SET_MSRS nor KVM_VCPU_TSC_VALUE are
suitable options.

Add a new TSC attribute KVM_VCPU_TSC_VALUE that allows for setting the
TSC value in a way that is unaffected by scheduling delays, handling TSC
scaling internally.

Add an optional, KVM clock based time reference argument to
kvm_synchronize_tsc(). This argument, if present, is understood to mean
"the TSC value being written was valid at this corresponding KVM clock
time point".

Userspace provides a struct kvm_vcpu_tsc_value consisting of a matched
pair of ( guest TSC value, KVM clock value ). The TSC value that will
ultimately be written is adjusted to account for the time which has
elapsed since the given KVM clock time point.

In order to allow userspace to retrieve an accurate time reference
atomically, without being affected by scheduling delays between
KVM_GET_CLOCK and KVM_GET_MSRS, the KVM_GET_DEVICE_ATTR implementation
for this attribute uses get_kvmclock() internally and returns a struct
kvm_vcpu_tsc_value with both values in one go. If get_kvmclock()
supports the KVM_CLOCK_HOST_TSC flag, the two will be based on one and
the same host TSC reading.

Co-developed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Simon Veith <sveith@amazon.de>
---
V2:
 - Squashed into a single change
 - Added justification for introducing a new interface
 - Added missing Signed-off-by
 - Re-worded comment

 Documentation/virt/kvm/devices/vcpu.rst | 22 +++++++++
 arch/x86/include/uapi/asm/kvm.h         |  7 +++
 arch/x86/kvm/x86.c                      | 63 +++++++++++++++++++++++--
 tools/arch/x86/include/uapi/asm/kvm.h   |  7 +++
 4 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 31f14ec4a65b..240a3646947c 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -265,3 +265,25 @@ From the destination VMM process:
 
 7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
+
+4.2 ATTRIBUTE: KVM_VCPU_TSC_VALUE
+
+:Parameters: kvm_device_attr.addr points to a struct kvm_vcpu_tsc_value
+
+Returns:
+
+	 ======= ======================================
+	 -EFAULT Error reading/writing the provided
+		 parameter address.
+	 -ENXIO  Attribute not supported
+	 ======= ======================================
+
+Gets or sets a matched pair of guest TSC value and KVM clock time point.
+
+When setting the TSC value through this attribute, a corresponding KVM clock
+reference time point (as retrieved by KVM_GET_CLOCK in the clock field) must be
+provided.
+
+The actual TSC value written will be adjusted based on the time that has
+elapsed since the provided reference time point, taking TSC scaling into
+account.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e48deab8901d..f99bdb959b54 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -528,5 +528,12 @@ struct kvm_pmu_event_filter {
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+#define   KVM_VCPU_TSC_VALUE 1 /* attribute for the TSC value */
+
+/* for KVM_VCPU_TSC_VALUE */
+struct kvm_vcpu_tsc_value {
+	__u64 tsc_val;
+	__u64 kvm_ns;
+};
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..b174200c909b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2655,7 +2655,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, u64 *kvm_ns)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
@@ -2664,12 +2664,24 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	ns = get_kvmclock_base_ns();
+
+	if (kvm_ns) {
+		/*
+		 * kvm_ns is the KVM clock reference time point at which this
+		 * TSC value was correct. Use this time point to compensate for
+		 * any delays that have been incurred since that TSC value was
+		 * valid.
+		 */
+		s64 delta_ns = ns + vcpu->kvm->arch.kvmclock_offset - *kvm_ns;
+		data += nsec_to_cycles(vcpu, (u64)delta_ns);
+	}
+
+	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
-		if (data == 0) {
+		if (data == 0 && !kvm_ns) {
 			/*
 			 * detection of vcpu initialization -- need to sync
 			 * with other vCPUs. This particularly helps to keep
@@ -3672,7 +3684,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, data, NULL);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -5375,6 +5387,7 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
+	case KVM_VCPU_TSC_VALUE:
 		r = 0;
 		break;
 	default:
@@ -5400,6 +5413,32 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 			break;
 		r = 0;
 		break;
+	case KVM_VCPU_TSC_VALUE: {
+		struct kvm_vcpu_tsc_value __user *tsc_value_arg;
+		struct kvm_vcpu_tsc_value tsc_value;
+		struct kvm_clock_data kvm_clock;
+		u64 host_tsc, guest_tsc, ratio, offset;
+
+		get_kvmclock(vcpu->kvm, &kvm_clock);
+		if (kvm_clock.flags & KVM_CLOCK_HOST_TSC)
+			host_tsc = kvm_clock.host_tsc;
+		else
+			host_tsc = rdtsc();
+
+		ratio = vcpu->arch.l1_tsc_scaling_ratio;
+		offset = vcpu->arch.l1_tsc_offset;
+		guest_tsc = kvm_scale_tsc(host_tsc, ratio) + offset;
+
+		tsc_value.kvm_ns = kvm_clock.clock;
+		tsc_value.tsc_val = guest_tsc;
+
+		tsc_value_arg = (struct kvm_vcpu_tsc_value __user *)uaddr;
+		r = -EFAULT;
+		if (copy_to_user(tsc_value_arg, &tsc_value, sizeof(tsc_value)))
+			break;
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENXIO;
 	}
@@ -5442,6 +5481,20 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		r = 0;
 		break;
 	}
+	case KVM_VCPU_TSC_VALUE: {
+		struct kvm_vcpu_tsc_value __user *tsc_value_arg;
+		struct kvm_vcpu_tsc_value tsc_value;
+
+		tsc_value_arg = (struct kvm_vcpu_tsc_value __user *)uaddr;
+		r = -EFAULT;
+		if (copy_from_user(&tsc_value, tsc_value_arg, sizeof(tsc_value)))
+			break;
+
+		kvm_synchronize_tsc(vcpu, tsc_value.tsc_val, &tsc_value.kvm_ns);
+
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENXIO;
 	}
@@ -11668,7 +11721,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, 0, NULL);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index e48deab8901d..f99bdb959b54 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -528,5 +528,12 @@ struct kvm_pmu_event_filter {
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+#define   KVM_VCPU_TSC_VALUE 1 /* attribute for the TSC value */
+
+/* for KVM_VCPU_TSC_VALUE */
+struct kvm_vcpu_tsc_value {
+	__u64 tsc_val;
+	__u64 kvm_ns;
+};
 
 #endif /* _ASM_X86_KVM_H */

base-commit: 9f266ccaa2f5228bfe67ad58a94ca4e0109b954a
-- 
2.34.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



