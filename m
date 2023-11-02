Return-Path: <kvm+bounces-411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EB77DF78C
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 731F6B212B1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725C51DDC6;
	Thu,  2 Nov 2023 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="pgSDHfra"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C741DA21;
	Thu,  2 Nov 2023 16:22:01 +0000 (UTC)
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A521212D;
	Thu,  2 Nov 2023 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=ypWhZ+TKbQ7/ZkY7xWEAWru4yXqntW8dv6C3cB3xvx0=; b=pgSDHfrab
	xNkCqsrmw+kXGBJ0a36S9+XoCL1X+N4d5ov15BPOLNqwCYrjuNFMaF4tsOzG13VAcSQ9Sjcfv1COB
	RpwqTiVsrOAS+V6ZDUXIeE1VNSahLSXgBI1O+P5cnYROXM2Kbjw3bH2hOMcPiI559/K8XoE1hc3O0
	cSvYuSLQ=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qyaRs-0001tA-Fv; Thu, 02 Nov 2023 16:21:36 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qyaRs-0000Vf-6Y; Thu, 02 Nov 2023 16:21:36 +0000
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
Subject: [PATCH v5] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
Date: Thu,  2 Nov 2023 16:21:28 +0000
Message-Id: <20231102162128.2353459-1-paul@xen.org>
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

v5:
 - Fix warning reported by kernel test robot.

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
 arch/x86/kvm/x86.c             | 28 +++++++++++++++++++++++-----
 arch/x86/kvm/xen.c             |  9 ++++++++-
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..a9bdd25826d1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8374,6 +8374,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
   #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
   #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -8417,6 +8418,11 @@ behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
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
index 2c924075f6f1..cc8d1ae29be3 100644
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
@@ -3161,6 +3166,16 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u64 tsc_timestamp, host_tsc;
 	u8 pvclock_flags;
 	bool use_master_clock;
+#ifdef CONFIG_KVM_XEN
+	/*
+	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
+	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
+	 * This default behaviour led to bugs in some guest kernels which cause
+	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
+	 */
+	bool xen_pvclock_tsc_unstable =
+		ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
+#endif
 
 	kernel_ns = 0;
 	host_tsc = 0;
@@ -3239,13 +3254,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
@@ -4638,7 +4655,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index 211b86de35ac..ae90294456df 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1291,6 +1291,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;

base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.39.2


