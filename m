Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE62C85A8
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgK3Nhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:37:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgK3Nhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKiFS6Lws9oA3rk7NRSCGQgXKIwwrIC+IctjguilsU0=;
        b=Tt1dGVel1RMQ9Q/NF4fRzx7Xs04ZJZRZh/LJTGjFUr2JKcca5Wj6qVudXrPViQhlO6AWe4
        11mTfO3Wb82x9ysV5/SBNHJjEEs0ZqYZ97pVeLrbsGYHzUR8tato/953qub09DGg9oMz7i
        cqAoui1PLQSsblsWqrNCqW7Em9+EVHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-WcSt1KFBNEGqxdl7x2Dpvw-1; Mon, 30 Nov 2020 08:36:21 -0500
X-MC-Unique: WcSt1KFBNEGqxdl7x2Dpvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A98E873116;
        Mon, 30 Nov 2020 13:36:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C136360C4D;
        Mon, 30 Nov 2020 13:36:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list),
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: x86: implement KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
Date:   Mon, 30 Nov 2020 15:35:58 +0200
Message-Id: <20201130133559.233242-2-mlevitsk@redhat.com>
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two new ioctls allow to more precisly capture and
restore guest's TSC state.

Both ioctls are meant to be used to accurately migrate guest TSC
even when there is a significant downtime during the migration.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 Documentation/virt/kvm/api.rst | 56 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c             | 69 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 14 +++++++
 3 files changed, 139 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229f..2f04aa8ecf119 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4826,6 +4826,62 @@ If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
 
+4.127 KVM_GET_TSC_STATE
+----------------------------
+
+:Capability: KVM_CAP_PRECISE_TSC
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_tsc_info
+:Returns: 0 on success, < 0 on error
+
+::
+
+  #define KVM_TSC_INFO_TSC_ADJUST_VALID 1
+  struct kvm_tsc_info {
+	__u32 flags;
+	__u64 nsec;
+	__u64 tsc;
+	__u64 tsc_adjust;
+  };
+
+flags values for ``struct kvm_tsc_info``:
+
+``KVM_TSC_INFO_TSC_ADJUST_VALID``
+
+  ``tsc_adjust`` contains valid IA32_TSC_ADJUST value
+
+This ioctl allows user space to read guest's IA32_TSC, IA32_TSC_ADJUST,
+and the current value of host CLOCK_REALTIME clock in nanoseconds since unix
+epoch.
+
+
+4.128 KVM_SET_TSC_STATE
+----------------------------
+
+:Capability: KVM_CAP_PRECISE_TSC
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_tsc_info
+:Returns: 0 on success, < 0 on error
+
+::
+
+This ioctl allows to reconstruct the guest's IA32_TSC and TSC_ADJUST value
+from the state obtained in the past by KVM_GET_TSC_STATE on the same vCPU.
+
+KVM will adjust the guest TSC value by the time that passed between
+CLOCK_REALTIME timestamp saved in the struct and current value of
+CLOCK_REALTIME, and set guest's TSC to the new value.
+
+TSC_ADJUST is restored as is if KVM_TSC_INFO_TSC_ADJUST_VALID is set.
+
+It is assumed that either both ioctls will be run on the same machine,
+or that source and destination machines have synchronized clocks.
+
+As a special case, it is allowed to leave the timestamp in the struct to zero,
+in which case it will be ignored and the TSC will be restored exactly.
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3fdc16cfd6f3..4f0ae9cb14b8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2438,6 +2438,21 @@ static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
 
 	return gtod_is_based_on_tsc(do_realtime(ts, tsc_timestamp));
 }
+
+
+static void kvm_get_walltime(u64 *walltime_ns, u64 *host_tsc)
+{
+	struct timespec64 ts;
+
+	if (kvm_get_walltime_and_clockread(&ts, host_tsc)) {
+		*walltime_ns = timespec64_to_ns(&ts);
+		return;
+	}
+
+	*host_tsc = rdtsc();
+	*walltime_ns = ktime_get_real_ns();
+}
+
 #endif
 
 /*
@@ -3757,6 +3772,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+#ifdef CONFIG_X86_64
+	case KVM_CAP_PRECISE_TSC:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4999,6 +5017,57 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_SUPPORTED_HV_CPUID:
 		r = kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
 		break;
+#ifdef CONFIG_X86_64
+	case KVM_GET_TSC_STATE: {
+		struct kvm_tsc_state __user *user_tsc_state = argp;
+		struct kvm_tsc_state tsc_state;
+		u64 host_tsc;
+
+		memset(&tsc_state, 0, sizeof(tsc_state));
+
+		kvm_get_walltime(&tsc_state.nsec, &host_tsc);
+		tsc_state.tsc = kvm_read_l1_tsc(vcpu, host_tsc);
+
+		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
+			tsc_state.tsc_adjust = vcpu->arch.ia32_tsc_adjust_msr;
+			tsc_state.flags |= KVM_TSC_STATE_TSC_ADJUST_VALID;
+		}
+
+		r = -EFAULT;
+		if (copy_to_user(user_tsc_state, &tsc_state, sizeof(tsc_state)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_TSC_STATE: {
+		struct kvm_tsc_state __user *user_tsc_state = argp;
+		struct kvm_tsc_state tsc_state;
+
+		u64 host_tsc, wall_nsec;
+		s64 diff;
+		u64 new_guest_tsc, new_guest_tsc_offset;
+
+		r = -EFAULT;
+		if (copy_from_user(&tsc_state, user_tsc_state, sizeof(tsc_state)))
+			goto out;
+
+		kvm_get_walltime(&wall_nsec, &host_tsc);
+		diff = wall_nsec - tsc_state.nsec;
+
+		if (diff < 0 || tsc_state.nsec == 0)
+			diff = 0;
+
+		new_guest_tsc = tsc_state.tsc + nsec_to_cycles(vcpu, diff);
+		new_guest_tsc_offset = new_guest_tsc - kvm_scale_tsc(vcpu, host_tsc);
+		kvm_vcpu_write_tsc_offset(vcpu, new_guest_tsc_offset);
+
+		if (tsc_state.flags & KVM_TSC_STATE_TSC_ADJUST_VALID)
+			if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST))
+				vcpu->arch.ia32_tsc_adjust_msr = tsc_state.tsc_adjust;
+		r = 0;
+		break;
+	}
+#endif
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba3..ee1bd5e7da964 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_PRECISE_TSC 193
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1169,6 +1170,15 @@ struct kvm_clock_data {
 	__u32 pad[9];
 };
 
+
+#define KVM_TSC_STATE_TSC_ADJUST_VALID 1
+struct kvm_tsc_state {
+	__u32 flags;
+	__u64 nsec;
+	__u64 tsc;
+	__u64 tsc_adjust;
+};
+
 /* For KVM_CAP_SW_TLB */
 
 #define KVM_MMU_FSL_BOOKE_NOHV		0
@@ -1563,6 +1573,10 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Available with KVM_CAP_PRECISE_TSC*/
+#define KVM_SET_TSC_STATE          _IOW(KVMIO,  0xc8, struct kvm_tsc_state)
+#define KVM_GET_TSC_STATE          _IOR(KVMIO,  0xc9, struct kvm_tsc_state)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.26.2

