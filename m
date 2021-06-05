Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3127739C526
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 04:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFECdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 22:33:47 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:39780 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFECdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 22:33:46 -0400
Received: by mail-pf1-f171.google.com with SMTP id k15so8748456pfp.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 19:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCgDwGP3NWkuksGukEwuNbb+wnVlbNrdlNLw/0mjpOs=;
        b=YQ2Dd0MIUHrJ1AnafELPsqY1HNVUkQijwvmPT/JARQ6bgXTweL2MEGBSdvGnfdS6Ff
         wENJiUAfsYu8AIRM7Pn9CzqhNQBUOqdGOD5FT33+JYoxc69pfUxLGC1o3rSOYL8X76VY
         tVaX2a9zw1OWKUME95ndiqrK9sQTzjwjL5kus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCgDwGP3NWkuksGukEwuNbb+wnVlbNrdlNLw/0mjpOs=;
        b=gI0AbWcDRma9n9XDjzyO2tpRTw3IbkpY864SrCYN0O/5R30XZa08DrRxWJvDueusnG
         24T7iTpXhdHzrL6YSED5Ps4ifmykTFXcVaYDEE73vSLqOZDUh3i7HKwzc1VkMDczPKF+
         AeFI6d5tdvC0Z30J7ZaVUYl5S62i1LXZVnW4QdbDsXAslgbmfEfhZSAmgkNzXq8S9Kmg
         q9d1l7nbLano3VxSJF5OVph65lDS8JNYMVCI/hbhYDetG8/iKLcnSF/M1Pr0CtjnSGQy
         +PR+XWn4H95OOljj83QQ+OKMO5Tcpc/el8rDZAL+j0RWprMMu7DxKv/bzsOjJb8JqTDa
         G7qQ==
X-Gm-Message-State: AOAM531/bXiuoUPkKcrcyXQwbX1YKUa3+pfSz+2MvrCxADhZQ42Gs6Wa
        s7y1JiExbxkvsgblVW2PhrBm9g==
X-Google-Smtp-Source: ABdhPJydb2kZQgxIFqQSbryHgqqNEbVgivbzwLRp45jeEfvIdH1F0y4fVSJx7UYZU2ezl7PkHwTeQg==
X-Received: by 2002:a65:6a44:: with SMTP id o4mr7742730pgu.145.1622860250794;
        Fri, 04 Jun 2021 19:30:50 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id n23sm2754391pff.93.2021.06.04.19.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 19:30:50 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 1/2] kvm: add PM-notifier
Date:   Sat,  5 Jun 2021 11:30:41 +0900
Message-Id: <20210605023042.543341-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM PM-notifier so that architectures can have arch-specific
VM suspend/resume routines. Such architectures need to select
CONFIG_HAVE_KVM_PM_NOTIFIER and implement kvm_arch_pm_notifier().

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/kvm_host.h |  9 +++++++++
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 76102efbf079..83ae0886db89 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -28,6 +28,7 @@
 #include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
+#include <linux/notifier.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -585,6 +586,10 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+
+#if defined(CONFIG_PM) && defined(CONFIG_HAVE_KVM_PM_NOTIFIER)
+	struct notifier_block pm_notifier;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -998,6 +1003,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+#if defined(CONFIG_PM) && defined(CONFIG_HAVE_KVM_PM_NOTIFIER)
+int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state);
+#endif
+
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1c37ccd5d402..62b39149b8c8 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -63,3 +63,6 @@ config HAVE_KVM_NO_POLL
 
 config KVM_XFER_TO_GUEST_WORK
        bool
+
+config HAVE_KVM_PM_NOTIFIER
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb440eb1225a..c30502a5eeb8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/suspend.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -780,6 +781,38 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
+#if defined(CONFIG_PM) && defined(CONFIG_HAVE_KVM_PM_NOTIFIER)
+static int kvm_pm_notifier_call(struct notifier_block *bl,
+				unsigned long state,
+				void *unused)
+{
+	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
+
+	return kvm_arch_pm_notifier(kvm, state);
+}
+
+static void kvm_init_pm_notifier(struct kvm *kvm)
+{
+	kvm->pm_notifier.notifier_call = kvm_pm_notifier_call;
+	/* Suspend KVM before we suspend ftrace, RCU, etc. */
+	kvm->pm_notifier.priority = INT_MAX;
+	register_pm_notifier(&kvm->pm_notifier);
+}
+
+static void kvm_destroy_pm_notifier(struct kvm *kvm)
+{
+	unregister_pm_notifier(&kvm->pm_notifier);
+}
+#else /* !(CONFIG_PM && CONFIG_HAVE_KVM_PM_NOTIFIER) */
+static void kvm_init_pm_notifier(struct kvm *kvm)
+{
+}
+
+static void kvm_destroy_pm_notifier(struct kvm *kvm)
+{
+}
+#endif /* CONFIG_PM && CONFIG_HAVE_KVM_PM_NOTIFIER */
+
 static struct kvm_memslots *kvm_alloc_memslots(void)
 {
 	int i;
@@ -963,6 +996,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_unlock(&kvm_lock);
 
 	preempt_notifier_inc();
+	kvm_init_pm_notifier(kvm);
 
 	return kvm;
 
@@ -1010,6 +1044,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
-- 
2.32.0.rc1.229.g3e70b5a671-goog

