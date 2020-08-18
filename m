Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2B248FF9
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgHRVQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgHRVQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533DDC061344
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y13so12960089plr.1
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YwmMf/yBzrkmlVycCOeLj/aaDGqHXdWIdBdkJ5k661Q=;
        b=EjWh+lIfHVQ76kYQ0k24c4ivL55Tm8aSlaAvF+kgRBN7yuZrZaNAAQe+3oYVSUAS2Z
         ACs6nLBljYbp7CLAVre5wOLwLMQmvYAYOs7/GKUoCkbksFW/Wf9TITk+eCtogr6lZgUD
         JQeveLBgQGCh6mbiSujSH702dhPqMJ1esZ0asn/3l8gwDjZa5EGlqWLONaYRmBWDX1TM
         n8vfmC7hfG65SNAsAnEnmb5ms2tCz8ERqwcF5y6JvnXvD76uFXBkVsnAcFoZ+znchVfu
         1UriXBUUu1eFijVsQegAiqyP0qKCcaK0ZqDI8zJrSEkYxp6xzquXdUNQqbSPz/BiRyOT
         95/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YwmMf/yBzrkmlVycCOeLj/aaDGqHXdWIdBdkJ5k661Q=;
        b=cFPXOrryPdpMlIY9iuLLXvvJd+yKzckSUL0aFqLrY9H6jCKdisl575zwMhH7OQCxqc
         M65lq6sDNr8c9D9Fro6pQF/S92kVM7u+qFMk5rltg0GcjV1Eyaaclpb+Ce0MadpthrP1
         zKguHzFizzNPL1bKMeDYVTvEeBDzslmTmIkThgD1BPpUZ/6DZ6cPxi6/ugAcGWJw1h0s
         rOBnB5GU+IYcHBNLTpVLgCLXLBnh//X9UCKleetqDHEWft2QtSOA55b/+LK/KcDTdw6z
         snpaluGaw3piGeO3cAR4GY/tEdMgvJxRtEbcvfTM+2iEkaapzLex71BVOBNDzPgdtnpK
         mXug==
X-Gm-Message-State: AOAM5338qfOTc9lLqROjwzlKQkTHPPGN5HrxWnEcCeEjefrXI+LPBB4z
        CFat/l3DXutxjnnzzv53GGhhH/9w+cZ5VvGA
X-Google-Smtp-Source: ABdhPJw8FBA22/5N3YyaMMIX8+BV6tb0W/GdwW3yzp7YLtI92PWWClqtwzSza8vMKj3pwLf+sW+tHduMUskq5NqD
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:390d:: with SMTP id
 ob13mr1522560pjb.122.1597785385858; Tue, 18 Aug 2020 14:16:25 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:26 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 04/12] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
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
index 91ce3e4b5b2e..e3cf1e971d0f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1010,6 +1010,30 @@ such as migration.
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
index 1ee8468c913c..6c4c5b972395 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -976,6 +976,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	struct kvm_msr_list *user_exit_msrs;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c46a709be532..e349d51d5d65 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3570,6 +3570,42 @@ static inline bool kvm_can_mwait_in_guest(void)
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
@@ -3630,6 +3666,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_ALLOWLIST:
+	case KVM_CAP_SET_MSR_EXITS:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5532,6 +5569,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 374021dc4e61..7d47d518a5d4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1046,6 +1046,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_X86_USER_SPACE_MSR 187
 #define KVM_CAP_X86_MSR_ALLOWLIST 188
+#define KVM_CAP_SET_MSR_EXITS 189
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1386,6 +1387,7 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
+#define KVM_SET_EXIT_MSRS	_IOW(KVMIO, 0xb4, struct kvm_msr_list)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.28.0.220.ged08abb693-goog

