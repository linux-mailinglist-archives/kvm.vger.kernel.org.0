Return-Path: <kvm+bounces-14109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 739DE89EF3E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A8A1F21429
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C41159201;
	Wed, 10 Apr 2024 09:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="d22u0LBu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C57156C67;
	Wed, 10 Apr 2024 09:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712742782; cv=none; b=caDQ5NPmjUVB+MvguQo8YX7+l68Q6ppdVYGdnKb22wpQwo5fZaASd53sHDgjeVtyu1meZxwVH5DcFD+KjrxAAZPGAV81reJHmmFJgPpKoRr6cIxsyWUMcWnZusUddpXM/RLd38BbHuDDgON8Re8TjbYfMkw2VXuLyyN92xiUuOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712742782; c=relaxed/simple;
	bh=wHrNwd3EaZsNggNLAuy+4QxmUF6vgCWmsWdwWeeevu4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RuoCksO79NJr4PpQN/eZphouHv71d4Fo+8OMMzS/SZMK6BO2qHFwmgJEsqRU1x/Zy5icqozGi5NGn895Jmak1+1j62+O0QRYKeK9ou7T5xNqZyJQjVy3VlbqfQnQt0tr8/TrDhbnKFttUgcyqSxE/D4b8QIbWBS1OUD3fefpIZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=d22u0LBu; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712742781; x=1744278781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hlN3QKrt70KuarBxVyAiVPfvOZb6rTqkxphz3nauX9Y=;
  b=d22u0LBu4HV95vjTmj6F8JZgXbnKsfsUk32ZBv/RiMBRmGEVz3A3YMj5
   oTY+cpEr2LB9UzWpRoUFTzwTJbiL83Q7NaLE8C7VVyHhFDvD/PBO7gkaq
   N19u1C1K4290BbmVSWSPukZSYPxKgdtK+kBjfafTK/ZtmieXyLxSGv1IU
   M=;
X-IronPort-AV: E=Sophos;i="6.07,190,1708387200"; 
   d="scan'208";a="625562781"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 09:52:58 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:15514]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.56:2525] with esmtp (Farcaster)
 id 27475e37-7f79-4c3a-9661-0bd9182b64d8; Wed, 10 Apr 2024 09:52:56 +0000 (UTC)
X-Farcaster-Flow-ID: 27475e37-7f79-4c3a-9661-0bd9182b64d8
Received: from EX19D033EUB004.ant.amazon.com (10.252.61.103) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:53 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUB004.ant.amazon.com (10.252.61.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:52 +0000
Received: from dev-dsk-jalliste-1c-e3349c3e.eu-west-1.amazon.com
 (10.13.244.142) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Wed, 10 Apr 2024 09:52:51 +0000
From: Jack Allister <jalliste@amazon.com>
To: <jalliste@amazon.com>
CC: <bp@alien8.de>, <corbet@lwn.net>, <dave.hansen@linux.intel.com>,
	<dwmw2@infradead.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <paul@xen.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>, Dongli Zhang
	<dongli.zhang@oracle.com>
Subject: [PATCH v2 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate KVM clock migration
Date: Wed, 10 Apr 2024 09:52:43 +0000
Message-ID: <20240410095244.77109-2-jalliste@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240410095244.77109-1-jalliste@amazon.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

In the common case (where kvm->arch.use_master_clock is true), the KVM
clock is defined as a simple arithmetic function of the guest TSC, based on
a reference point stored in kvm->arch.master_kernel_ns and
kvm->arch.master_cycle_now.

The existing KVM_[GS]ET_CLOCK functionality does not allow for this
relationship to be precisely saved and restored by userspace. All it can
currently do is set the KVM clock at a given UTC reference time, which is
necessarily imprecise.

So on live update, the guest TSC can remain cycle accurate at precisely the
same offset from the host TSC, but there is no way for userspace to restore
the KVM clock accurately.

Even on live migration to a new host, where the accuracy of the guest time-
keeping is fundamentally limited by the accuracy of wallclock
synchronization between the source and destination hosts, the clock jump
experienced by the guest's TSC and its KVM clock should at least be
*consistent*. Even when the guest TSC suffers a discontinuity, its KVM
clock should still remain the *same* arithmetic function of the guest TSC,
and not suffer an *additional* discontinuity.

To allow for accurate migration of the KVM clock, add per-vCPU ioctls which
save and restore the actual PV clock info in pvclock_vcpu_time_info.

The restoration in KVM_SET_CLOCK_GUEST works by creating a new reference
point in time just as kvm_update_masterclock() does, and calculating the
corresponding guest TSC value. This guest TSC value is then passed through
the user-provided pvclock structure to generate the *intended* KVM clock
value at that point in time, and through the *actual* KVM clock calculation.
Then kvm->arch.kvmclock_offset is adjusted to eliminate for the difference.

Where kvm->arch.use_master_clock is false (because the host TSC is
unreliable, or the guest TSCs are configured strangely), the KVM clock
is *not* defined as a function of the guest TSC so KVM_GET_CLOCK_GUEST
returns an error. In this case, as documented, userspace shall use the
legacy KVM_GET_CLOCK ioctl. The loss of precision is acceptable in this
case since the clocks are imprecise in this mode anyway.

On *restoration*, if kvm->arch.use_master_clock is false, an error is
returned for similar reasons and userspace shall fall back to using
KVM_SET_CLOCK. This does mean that, as documented, userspace needs to use
*both* KVM_GET_CLOCK_GUEST and KVM_GET_CLOCK and send both results with the
migration data (unless the intent is to refuse to resume on a host with bad
TSC).

(It may have been possible to make KVM_SET_CLOCK_GUEST "good enough" in the
non-masterclock mode, as that mode is necessarily imprecise anyway. The
explicit fallback allows userspace to deliberately fail migration to a host
with misbehaving TSC where master clock mode wouldn't be active.)

Suggested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Jack Allister <jalliste@amazon.com>
CC: Paul Durrant <paul@xen.org>
CC: Dongli Zhang <dongli.zhang@oracle.com>
---
 Documentation/virt/kvm/api.rst |  37 ++++++++++
 arch/x86/kvm/x86.c             | 124 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |   3 +
 3 files changed, 164 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..80fcd93bba1b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,43 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_GET_CLOCK_GUEST
+----------------------------
+
+:Capability: none
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct pvclock_vcpu_time_info (out)
+:Returns: 0 on success, <0 on error
+
+Retrieves the current time information structure used for KVM/PV clocks,
+in precisely the form advertised to the guest vCPU, which gives parameters
+for a direct conversion from a guest TSC value to nanoseconds.
+
+When the KVM clock not is in "master clock" mode, for example because the
+host TSC is unreliable or the guest TSCs are oddly configured, the KVM clock
+is actually defined by the host CLOCK_MONOTONIC_RAW instead of the guest TSC.
+In this case, the KVM_GET_CLOCK_GUEST ioctl returns -EINVAL.
+
+4.144 KVM_SET_CLOCK_GUEST
+----------------------------
+
+:Capability: none
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct pvclock_vcpu_time_info (in)
+:Returns: 0 on success, <0 on error
+
+Sets the KVM clock (for the whole VM) in terms of the vCPU TSC, using the
+pvclock structure as returned by KVM_GET_CLOCK_GUEST. This allows the precise
+arithmetic relationship between guest TSC and KVM clock to be preserved by
+userspace across migration.
+
+When the KVM clock is not in "master clock" mode, and the KVM clock is actually
+defined by the host CLOCK_MONOTONIC_RAW, this ioctl returns -EINVAL. Userspace
+may choose to set the clock using the less precise KVM_SET_CLOCK ioctl, or may
+choose to fail, denying migration to a host whose TSC is misbehaving.
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..d5cae3ead04d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5859,6 +5859,124 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int kvm_vcpu_ioctl_get_clock_guest(struct kvm_vcpu *v, void __user *argp)
+{
+	struct pvclock_vcpu_time_info *vcpu_pvti = &v->arch.hv_clock;
+	struct pvclock_vcpu_time_info local_pvti = { 0 };
+	struct kvm_arch *ka = &v->kvm->arch;
+	uint64_t host_tsc, guest_tsc;
+	bool use_master_clock;
+	uint64_t kernel_ns;
+	unsigned int seq;
+
+	/*
+	 * CLOCK_MONOTONIC_RAW is not suitable for GET/SET API,
+	 * see kvm_vcpu_ioctl_set_clock_guest equivalent comment.
+	 */
+	if (!static_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return -EINVAL;
+
+	/*
+	 * Querying needs to be performed in a seqcount loop as it's possible
+	 * another vCPU has triggered an update of the master clock. If so we
+	 * should store the host TSC & time at this point.
+	 */
+	do {
+		seq = read_seqcount_begin(&ka->pvclock_sc);
+		use_master_clock = ka->use_master_clock;
+		if (use_master_clock) {
+			host_tsc = ka->master_cycle_now;
+			kernel_ns = ka->master_kernel_ns;
+		}
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
+
+	if (!use_master_clock)
+		return -EINVAL;
+
+	/*
+	 * It's possible that this vCPU doesn't have a HVCLOCK configured
+	 * but the other vCPUs may. If this is the case calculate based
+	 * upon the time gathered in the seqcount but do not update the
+	 * vCPU specific PVTI. If we have one, then use that.
+	 */
+	if (!vcpu_pvti->tsc_timestamp && !vcpu_pvti->system_time) {
+		guest_tsc = kvm_read_l1_tsc(v, host_tsc);
+
+		local_pvti.tsc_timestamp = guest_tsc;
+		local_pvti.system_time = kernel_ns + ka->kvmclock_offset;
+	} else {
+		local_pvti = *vcpu_pvti;
+	}
+
+	if (copy_to_user(argp, &local_pvti, sizeof(local_pvti)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vcpu_ioctl_set_clock_guest(struct kvm_vcpu *v, void __user *argp)
+{
+	struct pvclock_vcpu_time_info dummy_pvti;
+	struct pvclock_vcpu_time_info orig_pvti;
+	struct kvm *kvm = v->kvm;
+	struct kvm_arch *ka = &kvm->arch;
+	uint64_t clock_orig, clock_dummy;
+	uint64_t host_tsc, guest_tsc;
+	int64_t kernel_ns;
+	int64_t correction;
+	int rc = 0;
+
+	/*
+	 * If a constant TSC is not provided by the host then KVM will
+	 * be using CLOCK_MONOTONIC_RAW, correction using this is not
+	 * precise and as such we can never sync to the precision we
+	 * are requiring.
+	 */
+	if (!static_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return -EINVAL;
+
+	if (copy_from_user(&orig_pvti, argp, sizeof(orig_pvti)))
+		return -EFAULT;
+
+	kvm_hv_request_tsc_page_update(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+
+	if (!ka->use_master_clock) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Sample the kernel time and host TSC at a singular point.
+	 * We then calculate the guest TSC using this exact point in time.
+	 * From here we can then determine the delta using the
+	 * PV time info requested from the user and what we currently have
+	 * using the fixed point in time. This delta is then used as a
+	 * correction factor to subtract from the clock offset.
+	 */
+	if (!kvm_get_time_and_clockread(&kernel_ns, &host_tsc)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	guest_tsc = kvm_read_l1_tsc(v, host_tsc);
+
+	dummy_pvti = orig_pvti;
+	dummy_pvti.tsc_timestamp = guest_tsc;
+	dummy_pvti.system_time = kernel_ns + ka->kvmclock_offset;
+
+	clock_orig = __pvclock_read_cycles(&orig_pvti, guest_tsc);
+	clock_dummy = __pvclock_read_cycles(&dummy_pvti, guest_tsc);
+
+	correction = clock_orig - clock_dummy;
+	ka->kvmclock_offset += correction;
+
+out:
+	kvm_end_pvclock_update(kvm);
+	return rc;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6239,6 +6357,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
+	case KVM_SET_CLOCK_GUEST:
+		r = kvm_vcpu_ioctl_set_clock_guest(vcpu, argp);
+		break;
+	case KVM_GET_CLOCK_GUEST:
+		r = kvm_vcpu_ioctl_get_clock_guest(vcpu, argp);
+		break;
 #ifdef CONFIG_KVM_HYPERV
 	case KVM_GET_SUPPORTED_HV_CPUID:
 		r = kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
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


