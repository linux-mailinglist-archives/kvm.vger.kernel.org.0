Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6E228E97
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbgGVD0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgGVD0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0845CC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x186so750261pfd.17
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oNVNzRsXo8GBEdh2OYKjlE6qP3uqga4wUe30+W4OCy0=;
        b=vzoqIkXN8vffiRcYqbRKWqxxLR1kyCbkd1iGVX5pnSsVbuBaqshTFreYLEOpCx4NcJ
         6KwVcSif2TcNlRFAzmBwf9hCw+E2Ah41WqPDvXnAR6Nf72cDoyp+n4JEJGVwnrXvM0/I
         73nb7lis0/jPy8R6TgCk+qpaDofXuR4yR7NHsDwoIQi5aI5SC8nvg3n/dgZWThl3o/ug
         oxNYI1XgUinbf10fFuoGF1kKhhEyNW2NYysCS/5arD6Tdiynf7xzJczqxw/YJr+ucqPr
         EAuayTQWwVsoBz6t+8znjF/wnh7pI5lC9NOSQaK3kP5ILCq4RlVM+18J8pItjKE/clUf
         rRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oNVNzRsXo8GBEdh2OYKjlE6qP3uqga4wUe30+W4OCy0=;
        b=DqJ6oIpqQXZ5tk7JRWt4DA6mMCJKL40N7rWojdi11Fit4gdRyMWLPnefQnqq7gHxHG
         onjFJOebukQHsSPWO9yV8VD40ou1XW0pDzGrlfSuYMDV57iWOjk958hQ91uzlaO+frXU
         HYWUl0zRDpuTQuKEeZ8W9waelkDWDzloeZzVQu4Ez34rFdV2l2a+VriDzDK0L6F0FRX1
         lQZIwAZ3MFb/9uqyR4IDNATI74reZ30CSZ5NUFco1WA/r8QKQb83vVsK3ffMXDC1WZ+u
         HiaOW52fpZ985+NQqyIC8Pn1ipjjjoeRDMxXdTwBs8OA/cPSBpH/s2e5amneOVix8t/l
         7BGA==
X-Gm-Message-State: AOAM5305wVhfoQCFoqJrbbIhcHT9KDL0e5o0dy5BbpZ6kXRA5xPMGKCY
        /vskp2jRU32h/xxEQmli9KJvQMQoJrA5TI8OzPiBtcMFdrpiOKmqUwT7j6li52e/leBVybth2Pf
        5DNvYUn0+fy2BFrBUS1ReoIqppRLZdZRVJJUOfAM5+Jt6ZoduZgpWlEQ1sQ==
X-Google-Smtp-Source: ABdhPJwIvtbQVTtCeoMvCvSxp/05SjtURbOMbRpZbg2wI780raRrKFFmcjoxGUf49LaA6C4U6JRWQrFRXbg=
X-Received: by 2002:a63:7cd:: with SMTP id 196mr24503869pgh.230.1595388405291;
 Tue, 21 Jul 2020 20:26:45 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:26 +0000
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
Message-Id: <20200722032629.3687068-3-oupton@google.com>
Mime-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 2/5] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Hornyack <peterhornyack@google.com>

The KVM_SET_MSR vcpu ioctl has some temporal and value-based heuristics
for determining when userspace is attempting to synchronize TSCs.
Instead of guessing at userspace's intentions in the kernel, directly
expose control of the TSC offset field to userspace such that userspace
may deliberately synchronize the guest TSCs.

Note that TSC offset support is mandatory for KVM on both SVM and VMX.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Peter Hornyack <peterhornyack@google.com>
[oupton - expanded docs, fixed KVM master clock interaction]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  | 31 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 49 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  5 ++++
 4 files changed, 86 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..7ecef103cc7f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4701,6 +4701,37 @@ KVM_PV_VM_VERIFY
   KVM is allowed to start protected VCPUs.
 
 
+4.126 KVM_GET_TSC_OFFSET
+------------------------
+
+:Capability: KVM_CAP_TSC_OFFSET
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: __u64 (out)
+:Returns: 0 on success, < 0 on error
+
+This ioctl gets the TSC offset field. The offset is returned as an
+unsigned value, though it is interpreted as a signed value by hardware.
+
+
+4.127 KVM_SET_TSC_OFFSET
+------------------------
+
+:Capability: KVM_CAP_TSC_OFFSET
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: __u64 (in)
+:Returns: 0 on success, < 0 on error
+
+This ioctl sets the TSC offset field. The offset is represented as an
+unsigned value, though it is interpreted as a signed value by hardware.
+The guest's TSC value will change based on the written offset. A
+userspace VMM may use this ioctl to restore the guest's TSC instead of
+KVM_SET_MSRS, thereby avoiding the in-kernel TSC synchronization
+detection. To that end, a userspace VMM may deliberately synchronize
+TSCs by setting the same offset value for all vCPUs.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5aaef036627f..0d0e3670fffe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -920,6 +920,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u64 last_tsc_offset;
 	u64 cur_tsc_nsec;
 	u64 cur_tsc_write;
 	u64 cur_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a5c88f747da6..98dbe98874de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2026,6 +2026,11 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
+static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.l1_tsc_offset;
+}
+
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
@@ -2063,6 +2068,7 @@ static void kvm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -2160,6 +2166,26 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
+static void kvm_vcpu_ioctl_set_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+{
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long flags;
+	bool matched;
+	u64 tsc, ns;
+
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+
+	matched = (kvm->arch.last_tsc_offset == offset &&
+		   vcpu->arch.virtual_tsc_khz &&
+		   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz);
+
+	tsc = kvm_scale_tsc(vcpu, rdtsc()) + offset;
+	ns = get_kvmclock_base_ns();
+
+	kvm_write_tsc_offset(vcpu, offset, tsc, ns, matched);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+}
+
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 					   s64 adjustment)
 {
@@ -3492,6 +3518,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
+	case KVM_CAP_TSC_OFFSET:
 	case KVM_CAP_DISABLE_QUIRKS:
 	case KVM_CAP_SET_BOOT_CPU_ID:
  	case KVM_CAP_SPLIT_IRQCHIP:
@@ -4744,6 +4771,28 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_TSC_OFFSET: {
+		u64 tsc_offset;
+
+		r = -EFAULT;
+		tsc_offset = kvm_vcpu_read_tsc_offset(vcpu);
+		if (copy_to_user(argp, &tsc_offset, sizeof(tsc_offset)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_TSC_OFFSET: {
+		u64 __user *tsc_offset_arg = argp;
+		u64 tsc_offset;
+
+		r = -EFAULT;
+		if (copy_from_user(&tsc_offset, tsc_offset_arg,
+				   sizeof(tsc_offset)))
+			goto out;
+		kvm_vcpu_ioctl_set_tsc_offset(vcpu, tsc_offset);
+		r = 0;
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ff9b335620d0..41f387ffcd11 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1033,6 +1033,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
 #define KVM_CAP_LAST_CPU 184
+#define KVM_CAP_TSC_OFFSET 185
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1501,6 +1502,10 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_TSC_OFFSET */
+#define KVM_GET_TSC_OFFSET	_IOR(KVMIO, 0xc5, __u64)
+#define KVM_SET_TSC_OFFSET	_IOW(KVMIO, 0xc6, __u64)
+
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
-- 
2.28.0.rc0.142.g3c755180ce-goog

