Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500F44848D0
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiADTta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiADTt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:49:29 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4BEC061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:29 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y2-20020a17090a1f4200b001b103d6b6d0so388092pjy.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A6x6Pw7kLwqSVAYV5QWuRkaeBaCvukF54j0t8jOjIWo=;
        b=ptX0vg9YdIJXEIv+bPi9miN6Phs8Gqz7sBU2QWQsUtqw2kQGQwiABtW992ywk4hZ+W
         0Yjxd+YrHiAZDx5j9yYFCFkPbsVaZ0Me2jeZ8/Yp1nLtpTRU3glZ/AFWrivJ3Ne9PxOZ
         wEEkRcAX+0GHmJL3/IL+wNt/VFmeQ8X8mW6bJyPiNxpnLVbR0aLEbdEA2Ze9gi6qqQ3C
         poU1KuO3mU1pkPlTHi2tto1rMBI3uHO8ySMfK3Luj4uIlnnCmLez6qNGPpgKaKGbE9tx
         WkPLsVqsmNEpEEThs9CKJ8Tw+DYsrLXtA1p0adzY5K5eZnk7V3wXfESrD7ST2e9CTHW1
         RFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A6x6Pw7kLwqSVAYV5QWuRkaeBaCvukF54j0t8jOjIWo=;
        b=McL+sVbwqsXLCOzI+e8rnkIoj+LuQr9AjocnT6oyK5B+uPhyMOvASZLJSU7BgwZRMe
         sas/4Amv7aiOekS6aNgxSsTSb6LIib1Woz8Dpdb9BqDjYrxwOJ5qT5u7EZmKk50Au7CQ
         QJxzxIUy6ecrWgdzidLtH4mlsHUH2d/FJmWLz97VjuoI2Gkfn1VN+MosSN6GHfIvW4w8
         HTQJaSVmsdz0GPJXHbrpBorH18/AJLBN4f+H52Tk3dmR+SzXASpoKQv99XwUVkcz3dCg
         +X1B8OuoBVcTIT0Sdj1tHjNcYzOYiuQmbulMHuWke05aGe+srPv7dMsRTOYQu5Pmyttq
         B3Sg==
X-Gm-Message-State: AOAM532LvReLVOpoDkRZGc7kMzjB2OBMuifmd94+dE6q137mgqmBqdtl
        LbPpRlOX1eKLO/IxKvUciv+/V0bCu1uM
X-Google-Smtp-Source: ABdhPJwl3NnGF1TfkZRlci6WjMWULIHIZ/BPa4U45UMKx/oZHTzTtRdYJEOxN/Xl1feLxe+jPtf4xNYvI4PH
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:3809:: with SMTP id
 mq9mr62274740pjb.245.1641325768929; Tue, 04 Jan 2022 11:49:28 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:08 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-2-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 01/11] KVM: Capture VM start
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the start of the KVM VM, which is basically the
start of any vCPU run. This state of the VM is helpful
in the upcoming patches to prevent user-space from
configuring certain VM features after the VM has started
running.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 include/linux/kvm_host.h | 3 +++
 virt/kvm/kvm_main.c      | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..d0bd8f7a026c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -623,6 +623,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+	bool vm_started;
 };
 
 #define kvm_err(fmt, ...) \
@@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 	}
 }
 
+#define kvm_vm_has_started(kvm) (kvm->vm_started)
+
 extern bool kvm_rebooting;
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c4e6b39389..962b91ac2064 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	int r;
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
+	struct kvm *kvm = vcpu->kvm;
 
 	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
 		return -EIO;
@@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			if (oldpid)
 				synchronize_rcu();
 			put_pid(oldpid);
+
+			/*
+			 * Since we land here even on the first vCPU run,
+			 * we can mark that the VM has started running.
+			 */
+			mutex_lock(&kvm->lock);
+			kvm->vm_started = true;
+			mutex_unlock(&kvm->lock);
 		}
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
-- 
2.34.1.448.ga2b2bfdf31-goog

