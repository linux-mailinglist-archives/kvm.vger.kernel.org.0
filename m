Return-Path: <kvm+bounces-301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD0E7DE057
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:30:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D6F31C20DB8
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51821171C;
	Wed,  1 Nov 2023 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="kJ+VQjiu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE5EA6;
	Wed,  1 Nov 2023 11:30:27 +0000 (UTC)
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B39F4;
	Wed,  1 Nov 2023 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:To:From; bh=RYoaWJuvgILigleDCr8z13sgBPRtlyGrLyhz0BgFbBc=; b=kJ+VQjiuo
	lGIc5h8CcE75Qc1/x7cU+XIktI2IkmtwC+EC9IYULMtMB7yLqkmgG/nXahRrb7Ons/TLS2pHywUnx
	z+svJ8NbPeg7GwY1HO7lVAGOgN9XwoEDXylhEdntp5YnvFx2lXwtRIoH5rft/6rAqpMhTBPFBf29S
	AYZhRswI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qy9Q7-0007EQ-4L; Wed, 01 Nov 2023 11:29:59 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1qy9Q6-0004FX-Mk; Wed, 01 Nov 2023 11:29:58 +0000
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
Subject: [PATCH v3] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
Date: Wed,  1 Nov 2023 11:29:33 +0000
Message-Id: <20231101112934.631344-1-paul@xen.org>
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

v3:
 - Moved clearing of PVCLOCK_TSC_STABLE_BIT the right side of the
   memcpy().
 - Added an all-vCPUs KVM_REQ_CLOCK_UPDATE when the HVM config
   flag is changed.
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/x86/kvm/x86.c             | 28 +++++++++++++++++++++++-----
 arch/x86/kvm/xen.c             | 15 ++++++++++++++-
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..9752a01270df 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8252,6 +8252,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
   #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
   #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -8295,6 +8296,11 @@ behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
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
index 41cce5031126..4ad17ad0fc0c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3096,7 +3096,8 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 
 static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 				    struct gfn_to_pfn_cache *gpc,
-				    unsigned int offset)
+				    unsigned int offset,
+				    bool force_tsc_unstable)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
@@ -3133,6 +3134,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	}
 
 	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+
+	if (force_tsc_unstable)
+		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
+
 	smp_wmb();
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
@@ -3154,6 +3159,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
 
@@ -3231,12 +3245,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.flags = pvclock_flags;
 
 	if (vcpu->pv_time.active)
-		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
+
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
-					offsetof(struct compat_vcpu_info, time));
+					offsetof(struct compat_vcpu_info, time),
+					xen_pvclock_tsc_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
+					xen_pvclock_tsc_unstable);
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
@@ -4531,7 +4548,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index 40edf4d1974c..7699d94f190b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1111,9 +1111,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 {
+	bool update_pvclock = false;
+
 	/* Only some feature flags need to be *enabled* by userspace */
 	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
-		KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+		KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
+		KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
 
 	if (xhc->flags & ~permitted_flags)
 		return -EINVAL;
@@ -1134,9 +1137,19 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 
+	if ((kvm->arch.xen_hvm_config.flags &
+	     KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE) !=
+	    (xhc->flags &
+	     KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE))
+		update_pvclock = true;
+
 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
 
 	mutex_unlock(&kvm->arch.xen.xen_lock);
+
+	if (update_pvclock)
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
-- 
2.39.2


