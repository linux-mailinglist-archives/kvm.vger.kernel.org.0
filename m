Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DA63DAEAC
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 00:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhG2WJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 18:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbhG2WJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 18:09:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C45DC0613D3
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d69-20020a25e6480000b02904f4a117bd74so8160101ybh.17
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
        b=rMkpaQypttkvOTlv0Yu0PJmHWsRFvCYfneyQu7XZAtrdjGpFfNfWqGn18dsvnXx69o
         PZKA+4rEXvIPkfayg+sTbiz/r2c2jFqjggsWxPnHu2UvNAE/TxUYORkliLZz8+Unip/t
         8u26bRuYDYcAGouDHhdj3sGiQeLcyUoht6c3vAIWVzH75s2ci3VOmqFxR/seNYXNYlu8
         /AUeM/FGUiGx2BfOL8T7HKYlAbBrzpWfI02ULYgSN6TnmoTbeZ41S7ebJMuFU2smbXuw
         xnez5Awds1TMNx/arUH4gXwb9PyM5txGUSIjEvN0bYU7LVM0JasjEqcZuf3NxC0uOWP+
         uZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ol+FzPmhNMEWcf/ywMIJRhViVzXRwXAQpsvgYkKHWL8=;
        b=fXDmNAQe50b09gDmnr7SWeD6+gftvt67PicseoWzcSeXPyGEEEwUGfxuzZ9ysB/K5o
         9TQDMnSwLAgpSSGLT2TBCEwS2qDxkTsSY9DShUotQfSS1zlnq9oZmh2jo2rxmwdpEDW/
         8+rQWO3inItAW7jTTXxz7ICp0BYjuHT30TAtTAQ6WbjtuNto0jZCe+eHyvuDbojjunL2
         yacier269eYNjB7xLBZpx942wUPSMmZLuRW5Uy55skLFJgUmwhcHbIFtx80PLQcW00WZ
         bfond47KGz2XS9Zr22Z79s7vNLedqW65FsK6rmz2mjrBEJfJWwt08E2p28yDuscWVitr
         6O+g==
X-Gm-Message-State: AOAM5322YmcAosKMJ5cfqcIDYkVf9nuaAOK8WqAxe6Yq+RZR7apERmuw
        8G8oeApI2VCTv2Jz6o9++3x+6uPMyrY=
X-Google-Smtp-Source: ABdhPJzutKBCdlIcisOY4xmX+bS3I+7VYGny6icfY80fNWnWdBzJeRY3xCP1/YQ+2mjVREH1XV6dtDLEzkk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:e64a:: with SMTP id d71mr9565726ybh.142.1627596568495;
 Thu, 29 Jul 2021 15:09:28 -0700 (PDT)
Date:   Thu, 29 Jul 2021 22:09:16 +0000
In-Reply-To: <20210729220916.1672875-1-oupton@google.com>
Message-Id: <20210729220916.1672875-4-oupton@google.com>
Mime-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work function
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up handling of checks for pending work by switching to the generic
infrastructure to do so.

We pick up handling for TIF_NOTIFY_RESUME from this switch, meaning that
task work will be correctly handled.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/arm.c   | 27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..8bc1fac5fa26 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ menuconfig KVM
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_XFER_TO_GUEST_WORK
 	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 60d0a546d7fd..9762e2129813 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -6,6 +6,7 @@
 
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
+#include <linux/entry-kvm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
@@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 		static_branch_unlikely(&arm64_mismatched_32bit_el0);
 }
 
+static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
+{
+	return kvm_request_pending(vcpu) ||
+			need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
+			xfer_to_guest_mode_work_pending();
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -757,7 +765,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/*
 		 * Check conditions before entering the guest
 		 */
-		cond_resched();
+		if (__xfer_to_guest_mode_work_pending()) {
+			ret = xfer_to_guest_mode_handle_work(vcpu);
+			if (!ret)
+				ret = 1;
+		}
 
 		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
@@ -776,16 +788,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_vgic_flush_hwstate(vcpu);
 
-		/*
-		 * Exit if we have a signal pending so that we can deliver the
-		 * signal to user space.
-		 */
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
-		}
-
 		/*
 		 * If we're using a userspace irqchip, then check if we need
 		 * to tell a userspace irqchip about timer or PMU level
@@ -809,8 +811,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_vcpu_exit_request(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
-- 
2.32.0.554.ge1b32706d8-goog

