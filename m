Return-Path: <kvm+bounces-13922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FF689CE3D
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:08:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95BDB1C218B1
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4704914A096;
	Mon,  8 Apr 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="WqLuiud/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA5148854;
	Mon,  8 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712614080; cv=none; b=u7jM4PcHZElnJHkWew/ANPFKyq5a4H38Y90+Hp8lQY/8eRHBe/wuCa7sljsb8P3WJFPCanKKCAefH5cPgizBmycjC1nXbMosEkebAPACBvX5SsfRY+YbJXItNrTErAsSggjEVFIkD2UCaBvbnzwv1sSXXLrswsU+vxJ1pHqq/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712614080; c=relaxed/simple;
	bh=JFYjZ4s9HVWCcGug4NDnh8HtF9MZU8LyiNBr7E8NGRw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EA/XEo4nK/PaPjWzkFwWfuBXO+ZDyFG0ohO61HThMuMJ8wKd7WzVuPRdQNjZ4Mr5l7u3dl9Edz7ZKyJFV0/8DOwv9ecwM4kQKbLM1fysAQ3DYUqG6BnE0dw7WzK4DW4PckAxJK+JHEuTuqLnTa6PeAe6yGGtA2qUyrkiwnhcIeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=WqLuiud/; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712614079; x=1744150079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mMHYNSET/OiGHH6NMYDLuJgAcn+i0b2ppUt1xXG1EV0=;
  b=WqLuiud/hd/jL7q5gljl0l+qSKCmE/NC2irqHgeJS+9RJplFAmAQjmAb
   a60SNHKiekUTuKwpOTXSYaBOPg+u10f/LoDa3+Ry3l4GNfJdnlR3qNA0o
   5Vej3oZIxLi8CwO+aQ9jtJXjfrLPGWaRq+T0v6Rq72Z4nEsnZU7iLzjUK
   U=;
X-IronPort-AV: E=Sophos;i="6.07,187,1708387200"; 
   d="scan'208";a="197276305"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 22:07:55 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:64593]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.15.243:2525] with esmtp (Farcaster)
 id d497b1a7-e8e3-4ec9-83b8-6b73edc799b9; Mon, 8 Apr 2024 22:07:54 +0000 (UTC)
X-Farcaster-Flow-ID: d497b1a7-e8e3-4ec9-83b8-6b73edc799b9
Received: from EX19D033EUB003.ant.amazon.com (10.252.61.76) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 8 Apr 2024 22:07:53 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUB003.ant.amazon.com (10.252.61.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 8 Apr 2024 22:07:53 +0000
Received: from dev-dsk-jalliste-1c-e3349c3e.eu-west-1.amazon.com
 (10.13.244.142) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Mon, 8 Apr 2024 22:07:51 +0000
From: Jack Allister <jalliste@amazon.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
CC: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, "Jack
 Allister" <jalliste@amazon.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock drift fixup
Date: Mon, 8 Apr 2024 22:07:03 +0000
Message-ID: <20240408220705.7637-2-jalliste@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240408220705.7637-1-jalliste@amazon.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

There is a potential for drift between the TSC and a KVM/PV clock when the
guest TSC is scaled (as seen previously in [1]). Which fixed drift between
timers over the lifetime of a VM.

However, there is another factor which will cause a drift. In a situation
such as a kexec/live-update of the kernel or a live-migration of a VM the
PV clock information is recalculated by KVM (KVM_REQ_MASTERCLOCK_UPDATE).
This update samples a new system_time & tsc_timestamp to be used in the
structure.

For example, when a guest is running with a TSC frequency of 1.5GHz but the
host frequency is 3.0GHz upon an update of the PV time information a delta
of ~3500ns is observed between the TSC and the KVM/PV clock. There is no
reason why a fixup creating an accuracy of ±1ns cannot be achieved.

Additional interfaces are added to retrieve & fixup the PV time information
when a VMM may believe is appropriate (deserialization after live-update/
migration). KVM_GET_CLOCK_GUEST can be used for the VMM to retrieve the
currently used PV time information and then when the VMM believes a drift
may occur can then instruct KVM to perform a correction via the setter
KVM_SET_CLOCK_GUEST.

The KVM_SET_CLOCK_GUEST ioctl works under the following premise. The host
TSC & kernel timstamp are sampled at a singular point in time. Using the
already known scaling/offset for L1 the guest TSC is then derived from this
information.

From here two PV time information structures are created, one which is the
original time information structure prior to whatever may have caused a PV
clock re-calculation (live-update/migration). The second is then using the
singular point in time sampled just prior. An individual KVM/PV clock for
each of the PV time information structures using the singular guest TSC.

A delta is then determined between the two calculated PV times, which is
then used as a correction offset added onto the kvmclock_offset for the VM.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=451a707813ae

Suggested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Jack Allister <jalliste@amazon.com>
CC: Paul Durrant <paul@xen.org>
---
 Documentation/virt/kvm/api.rst | 43 +++++++++++++++++
 arch/x86/kvm/x86.c             | 87 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  3 ++
 3 files changed, 133 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..5f74d8ac1002 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,49 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_GET_CLOCK_GUEST
+----------------------------
+
+:Capability: none
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct pvclock_vcpu_time_info (out)
+:Returns: 0 on success, <0 on error
+
+Retrieves the current time information structure used for KVM/PV clocks.
+On x86 a PV clock is derived from the current TSC and is then scaled based
+upon the a specified multiplier and shift. The result of this is then added
+to a system time.
+
+The guest needs a way to determine the system time, multiplier and shift. This
+can be done by multiple ways, for KVM guests this can be via an MSR write to
+MSR_KVM_SYSTEM_TIME / MSR_KVM_SYSTEM_TIME_NEW which defines the guest physical
+address KVM shall put the structure. On Xen guests this can be found in the Xen
+vcpu_info.
+
+This is structure is useful information for a VMM to also know when taking into
+account potential timer drift on live-update/migration.
+
+4.144 KVM_SET_CLOCK_GUEST
+----------------------------
+
+:Capability: none
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct pvclock_vcpu_time_info (in)
+:Returns: 0 on success, <0 on error
+
+Triggers KVM to perform a correction of the KVM/PV clock structure based upon a
+known prior PV clock structure (see KVM_GET_CLOCK_GUEST).
+
+If a VM is utilizing TSC scaling there is a potential for a drift between the
+KVM/PV clock and the TSC itself. This is due to the loss of precision when
+performing a multiply and shift rather than divide for the TSC.
+
+To perform the correction a delta is calculated between the original time info
+(which is assumed correct) at a singular point in time X. The KVM clock offset
+is then offset by this delta.
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..5d2e10cd1c30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6988,6 +6988,87 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+static struct kvm_vcpu *kvm_get_bsp_vcpu(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		vcpu = kvm_get_vcpu_by_id(kvm, i);
+		if (!vcpu)
+			continue;
+
+		if (kvm_vcpu_is_reset_bsp(vcpu))
+			break;
+	}
+
+	return vcpu;
+}
+
+static int kvm_vm_ioctl_get_clock_guest(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = kvm_get_bsp_vcpu(kvm);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (!vcpu->arch.hv_clock.tsc_timestamp || !vcpu->arch.hv_clock.system_time)
+		return -EIO;
+
+	if (copy_to_user(argp, &vcpu->arch.hv_clock, sizeof(vcpu->arch.hv_clock)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vm_ioctl_set_clock_guest(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_vcpu *vcpu;
+	struct pvclock_vcpu_time_info orig_pvti;
+	struct pvclock_vcpu_time_info dummy_pvti;
+	int64_t kernel_ns;
+	uint64_t host_tsc, guest_tsc;
+	uint64_t clock_orig, clock_dummy;
+	int64_t correction;
+	unsigned long i;
+
+	vcpu = kvm_get_bsp_vcpu(kvm);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (copy_from_user(&orig_pvti, argp, sizeof(orig_pvti)))
+		return -EFAULT;
+
+	/*
+	 * Sample the kernel time and host TSC at a singular point.
+	 * We then calculate the guest TSC using this exact point in time,
+	 * From here we can then determine the delta using the
+	 * PV time info requested from the user and what we currently have
+	 * using the fixed point in time. This delta is then used as a
+	 * correction factor to fixup the potential drift.
+	 */
+	if (!kvm_get_time_and_clockread(&kernel_ns, &host_tsc))
+		return -EFAULT;
+
+	guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
+
+	dummy_pvti = orig_pvti;
+	dummy_pvti.tsc_timestamp = guest_tsc;
+	dummy_pvti.system_time = kernel_ns + kvm->arch.kvmclock_offset;
+
+	clock_orig = __pvclock_read_cycles(&orig_pvti, guest_tsc);
+	clock_dummy = __pvclock_read_cycles(&dummy_pvti, guest_tsc);
+
+	correction = clock_orig - clock_dummy;
+	kvm->arch.kvmclock_offset += correction;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+
+	return 0;
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
@@ -7246,6 +7327,12 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	case KVM_GET_CLOCK:
 		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
+	case KVM_SET_CLOCK_GUEST:
+		r = kvm_vm_ioctl_set_clock_guest(kvm, argp);
+		break;
+	case KVM_GET_CLOCK_GUEST:
+		r = kvm_vm_ioctl_get_clock_guest(kvm, argp);
+		break;
 	case KVM_SET_TSC_KHZ: {
 		u32 user_tsc_khz;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..0d306311e4d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1548,4 +1548,7 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_SET_CLOCK_GUEST       _IOW(KVMIO,  0xd5, struct pvclock_vcpu_time_info)
+#define KVM_GET_CLOCK_GUEST       _IOR(KVMIO,  0xd6, struct pvclock_vcpu_time_info)
+
 #endif /* __LINUX_KVM_H */
-- 
2.40.1


