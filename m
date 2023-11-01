Return-Path: <kvm+bounces-330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 005207DE5FD
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 19:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E3E2819B6
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 18:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7CF6ABB;
	Wed,  1 Nov 2023 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="EDvoaTDk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6719BB9;
	Wed,  1 Nov 2023 18:31:18 +0000 (UTC)
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD2102;
	Wed,  1 Nov 2023 11:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=yudA2//70ZOKAq+8SLUXpoi/kPg8MKMLW5Pf7+MW1eI=; b=EDvoaTDkL
	gdOOY4jiYTfDcrOWIpZGw/kwc9sCepInMbP1cW57hOf0YWejYdMZXwTmNItWllBcJGk2HHvkuFHo4
	2SASFPvECVjCm+s/PWD8BZnDmjVtPxXJmIwsf9+P+gApPCwyIt5z8lhu9+cVxdyI0seVMMMrwxgzz
	n8GcSXyI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qyFzC-0000qn-UN; Wed, 01 Nov 2023 18:30:38 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qyFzC-0001gN-KO; Wed, 01 Nov 2023 18:30:38 +0000
From: Paul Durrant <paul@xen.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
Date: Wed,  1 Nov 2023 18:30:32 +0000
Message-Id: <20231101183032.1498211-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

Unless explicitly told to do so (by passing 'clocksource=tsc' and
'tsc=stable:socket', and then jumping through some hoops concerning
potential CPU hotplug) Xen will never use TSC as its clocksource.
Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
in either the primary or secondary pvclock memory areas. This has
led to bugs in some guest kernels which only become evident if
PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
such guests, give the VMM a new Xen HVM config flag to tell KVM to
forcibly clear the bit in the Xen pvclocks.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---

v4:
 - Re-base.
 - Re-work 'update_pvclock' test as requested.

v3:
 - Moved clearing of PVCLOCK_TSC_STABLE_BIT the right side of the
   memcpy().
 - Added an all-vCPUs KVM_REQ_CLOCK_UPDATE when the HVM config
   flag is changed.
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/x86/kvm/x86.c             | 27 ++++++++++++++++++++++-----
 arch/x86/kvm/xen.c             |  9 ++++++++-
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 67347d827242..880b929a5cb1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8270,6 +8270,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
   #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
   #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -8313,6 +8314,11 @@ behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
 specifically enabled (by the guest making the hypercall, causing the VMM
 to enable the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute).
 
+The KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE flag indicates that KVM supports
+clearing the PVCLOCK_TSC_STABLE_BIT flag in Xen pvclock sources. This will be
+done when the KVM_CAP_XEN_HVM ioctl sets the
+KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE flag.
+
 8.31 KVM_CAP_PPC_MULTITCE
 -------------------------
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..e43449382cba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3104,7 +3104,8 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 
 static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 				    struct gfn_to_pfn_cache *gpc,
-				    unsigned int offset)
+				    unsigned int offset,
+				    bool force_tsc_unstable)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
@@ -3141,6 +3142,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	}
 
 	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+
+	if (force_tsc_unstable)
+		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
+
 	smp_wmb();
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
@@ -3162,6 +3167,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u8 pvclock_flags;
 	bool use_master_clock;
 
+	/*
+	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
+	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
+	 * This default behaviour led to bugs in some guest kernels which cause
+	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
+	 */
+	bool xen_pvclock_tsc_unstable =
+		ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
+
 	kernel_ns = 0;
 	host_tsc = 0;
 
@@ -3239,13 +3253,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.flags = pvclock_flags;
 
 	if (vcpu->pv_time.active)
-		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
-					offsetof(struct compat_vcpu_info, time));
+					offsetof(struct compat_vcpu_info, time),
+					xen_pvclock_tsc_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
+					xen_pvclock_tsc_unstable);
 #endif
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
@@ -4638,7 +4654,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
-		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
+		    KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
 			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e53fad915a62..e43948b87f94 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1162,7 +1162,9 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 {
 	/* Only some feature flags need to be *enabled* by userspace */
 	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
-		KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+		KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
+		KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
+	u32 old_flags;
 
 	if (xhc->flags & ~permitted_flags)
 		return -EINVAL;
@@ -1183,9 +1185,14 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 
+	old_flags = kvm->arch.xen_hvm_config.flags;
 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
 
 	mutex_unlock(&kvm->arch.xen.xen_lock);
+
+	if ((old_flags ^ xhc->flags) & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+
 	return 0;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..e21b53e8358d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1282,6 +1282,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;

base-commit: 35dcbd9e47035f98f3910ae420bf10892c9bdc99
-- 
2.39.2


