Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18E21BE4C
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGJUHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgGJUHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 16:07:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550C4C08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id t12so4686402pju.8
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=J0bTU87L8QsjBDphnGPI3tqvqXPCIpODhyPeANR5PoI=;
        b=O3+mbm6uPCewPDwc6fCuyXjfnu86dQsncgWA+tpANzL6Lb/vCRG54HYxwCBWfomQAK
         gNNOe3fPNGin42JlGpisTBcxr54nh/8U8SqW3dA+J1AvzrMVr9bhHr+bpUS6Cg39iVkn
         0OmgAxnYHRXbG8wbWhgcyUBnGGnXMzqmW2WgGQv4LEeHTIGQuKSF6frcNIij5PYxfeqb
         vyqBV2Ealq95VRPNRSzENmLpM1WDfdewN+PaAjLaoP5OKVqUVWgIOeFcid51UZ92rooc
         /wxakK3UKLymkpeqn75XLJzeKG2hWU97Jd1Vk57RvdH+tbfkaSHuSznX7vbnp/994V0s
         2aHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=J0bTU87L8QsjBDphnGPI3tqvqXPCIpODhyPeANR5PoI=;
        b=bNPqN5sX7LwY7AqtExIPRDk0ogV46hX4UeEo0MN6WVhEkxz4nVbHlE9wE32EoKEHyz
         EqmzB5bJF7Dw1BJYB4EbkDBB+Nexfi/pZu2fP9YqLprR3tXgbgUe2WmmdBQ4v6QyIDxJ
         ErKHzUh337dyse2dSiL0yhL2csooqEcsuplA3IykeAIm6JKP3DkzT4U6VmBpNNk77Bi9
         UHZ0/l/DcVrFTrCtBirAmOPvAK87DHc2KGBTGxdz/mVRpCjLyIFLmj+dRTzZntWXN+uB
         mu1VJYOrbX4bbeT8toK37WzRtSuMOpA6nocQAzsa2fmIHFrxtYIO2DQgYiN2e0+XHusI
         VXRw==
X-Gm-Message-State: AOAM532STi9ysZ0pX0ivgLyZ/Ccd/XgjqHKLSKnpi/KmZTwVdKbHvLtR
        1nwk+AtnDfOdZ6d+O+kxT+Q2j3lg99OOdvu+yQ9tT4IjRygOtwGj3pSdCUd/IXwyXgUoExNBGYr
        SGj3zm2aNR3cvZeY3YU+qlTW1IaFjnpuiKoZ9Tag4B/vNlvM53kEbzInF9Q==
X-Google-Smtp-Source: ABdhPJwgzBxRsj6W9Kn2DNPB0HOMGjTt45tmjSdTBguSsiq5XDLFTTFXQK2p/8lQngo/XR+hnkkRVwG6raI=
X-Received: by 2002:aa7:934a:: with SMTP id 10mr27356132pfn.302.1594411666413;
 Fri, 10 Jul 2020 13:07:46 -0700 (PDT)
Date:   Fri, 10 Jul 2020 20:07:40 +0000
Message-Id: <20200710200743.3992127-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
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
Signed-off-by: Peter Hornyack <peterhornyack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c             | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  5 +++++
 3 files changed, 60 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..ef1fc109b901 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4701,6 +4701,33 @@ KVM_PV_VM_VERIFY
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
+The guest's TSC value will change based on the written offset.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e27d3db7e43f..563256ce5ade 100644
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
@@ -3482,6 +3487,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
+	case KVM_CAP_TSC_OFFSET:
 	case KVM_CAP_DISABLE_QUIRKS:
 	case KVM_CAP_SET_BOOT_CPU_ID:
  	case KVM_CAP_SPLIT_IRQCHIP:
@@ -4734,6 +4740,28 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
+		kvm_vcpu_write_tsc_offset(vcpu, tsc_offset);
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
2.27.0.383.g050319c2ae-goog

