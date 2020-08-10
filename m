Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD124116D
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJULr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHJULr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:11:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46197C061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s4so535058pjq.8
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5oAjokWOZe4cAdJFgfr8j682KuQkIW1okam8n6z5dy8=;
        b=i59gTdRapHyeCjEIgC6k7Z6BefmKEkcLk0+1v8FF7cm2ERlx1uHnIQGWOkDdO2e4j9
         TA6kjushKsVVelS0Gfx/Q7ybyzqloGYVNDLuH4Fc08tQpejJrrbJA59wtIW4OiSLPWH3
         ur+T82okRpFkuz+lPAkddiP8njjUZl3edbZ92bXK2P13p60m1F15aGYNkk6VEk8oBBb3
         Rv680oVKT81RW4hDrYoras8S3pY3YsB/F5AckzuuKDSyCJDyuEdM3XlyvrvsGgNOeKdm
         32pZ3yCJwiJR6UCZqBD5suGRD2DGW85wDrUC9uLipWq0VgV88vEhwKL2chEK0lXmEiWy
         tpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5oAjokWOZe4cAdJFgfr8j682KuQkIW1okam8n6z5dy8=;
        b=PGE32LilIaOowaxX7fqpwXH4S17v3KEIHq3/az7TGog+p99LGhaFzaUExnZCZnynSs
         TIKOzDBTwFa7veheO9ZoX2NLm1cfrsRMxVhS3EgBKfxHquav1eTxrK8Y5gWIbf8LBVhK
         PMTyh+PikhS2sOyrxCSnwzXUbfEmFUDs537MZ0URPRM9Mv40NpCw4qVTh5KEtkk3JZwE
         Q4tyXTSt4g4Twpfjsm3mrngaP9paevo5UEw36Eg6PdqzFPcDTvBdFCLC8mkHNqzgz8+N
         chH8RmgwBBvgqgTIhxWiTIwbdpkn1cBvNYm8Hreho+lBA2aXKDq9D9YrZByZkJQflwAa
         JrGw==
X-Gm-Message-State: AOAM5321fB2McDDHDUyTqfHr1ZK8KzBcPc3TKTuyWq4WEAqY09Olsshf
        xAtg8Nqu3mW35fxvGpjqKFuW00yikRvgFhNE
X-Google-Smtp-Source: ABdhPJwdJ6t5/vb3IuTDPqMyfW341aPpIqq/ytFj+8mB54vEu+1b3PjuQ0LgzRAdIR/5dEZ1HWnMNmT+YELWCvnU
X-Received: by 2002:a17:90a:2110:: with SMTP id a16mr1027012pje.104.1597090306166;
 Mon, 10 Aug 2020 13:11:46 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:27 -0700
In-Reply-To: <20200810201134.2031613-1-aaronlewis@google.com>
Message-Id: <20200810201134.2031613-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200810201134.2031613-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 1/8] KVM: x86: Add ioctl for accepting a userspace provided
 MSR list
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_SET_EXIT_MSRS ioctl to allow userspace to pass in a list of MSRs
that force an exit to userspace when rdmsr or wrmsr are used by the
guest.

KVM_SET_EXIT_MSRS will need to be called before any vCPUs are
created to protect the 'user_exit_msrs' list from being mutated while
vCPUs are running.

Add KVM_CAP_SET_MSR_EXITS to identify the feature exists.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  | 24 +++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 41 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  2 ++
 4 files changed, 69 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 320788f81a05..7d8167c165aa 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1006,6 +1006,30 @@ such as migration.
 :Parameters: struct kvm_vcpu_event (out)
 :Returns: 0 on success, -1 on error
 
+4.32 KVM_SET_EXIT_MSRS
+------------------
+
+:Capability: KVM_CAP_SET_MSR_EXITS
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_msr_list (in)
+:Returns: 0 on success, -1 on error
+
+Sets the userspace MSR list which is used to track which MSRs KVM should send
+to userspace to be serviced when the guest executes rdmsr or wrmsr.
+
+This ioctl needs to be called before vCPUs are setup otherwise the list of MSRs
+will not be accepted and an EINVAL error will be returned.  Also, if a list of
+MSRs has already been supplied, and this ioctl is called again an EEXIST error
+will be returned.
+
+::
+
+  struct kvm_msr_list {
+  __u32 nmsrs;
+  __u32 indices[0];
+};
+
 X86:
 ^^^^
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b21540..510055471dd0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1004,6 +1004,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	struct kvm_msr_list *user_exit_msrs;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..46a0fb9e0869 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3419,6 +3419,42 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static int kvm_vm_ioctl_set_exit_msrs(struct kvm *kvm,
+				      struct kvm_msr_list __user *user_msr_list)
+{
+	struct kvm_msr_list *msr_list, hdr;
+	size_t indices_size;
+
+	if (kvm->arch.user_exit_msrs != NULL)
+		return -EEXIST;
+
+	if (kvm->created_vcpus)
+		return -EINVAL;
+
+	if (copy_from_user(&hdr, user_msr_list, sizeof(hdr)))
+		return -EFAULT;
+
+	if (hdr.nmsrs >= MAX_IO_MSRS)
+		return -E2BIG;
+
+	indices_size = sizeof(hdr.indices[0]) * hdr.nmsrs;
+	msr_list = kvzalloc(sizeof(struct kvm_msr_list) + indices_size,
+			    GFP_KERNEL_ACCOUNT);
+	if (!msr_list)
+		return -ENOMEM;
+	msr_list->nmsrs = hdr.nmsrs;
+
+	if (copy_from_user(msr_list->indices, user_msr_list->indices,
+			   indices_size)) {
+		kvfree(msr_list);
+		return -EFAULT;
+	}
+
+	kvm->arch.user_exit_msrs = msr_list;
+
+	return 0;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -3476,6 +3512,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_SET_MSR_EXITS:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5261,6 +5298,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_SET_EXIT_MSRS: {
+		r = kvm_vm_ioctl_set_exit_msrs(kvm, argp);
+		break;
+	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..de4638c1bd15 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_SET_MSR_EXITS 185
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1371,6 +1372,7 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
+#define KVM_SET_EXIT_MSRS	_IOW(KVMIO, 0xb4, struct kvm_msr_list)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.28.0.236.gb10cc79966-goog

