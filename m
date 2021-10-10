Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AAC428218
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhJJO7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhJJO7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:59:02 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8EBC061765
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:57:03 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso11240434wrg.7
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iqD8cN6+ivvU4iBUA/M2YmIiCTZR+r/k27SL/Wa8sLA=;
        b=JkgJ+h41AKcXBuaovTWMlreIJ+wWWz1N/aBu0BO5M72w0oNjaRLkJrDNzotUdn/cAl
         8V0kCzynY0RgN3gUXiAsrXTF12s5FUwCJv61wp5QlFM/7X6VZq/tY1NvR8uoj+9fo9Ym
         7vPCYdWzErC0kuZq5TZIdeJbxbV40zYLjZtiSUy4lypwjGLcGau9crjYDf9BRADzTpTZ
         n+zk2/h+o+mh7FD/bI5uhzB6WIcx2Sc1u1PBsnXUEofKb4LqVZZ/fC+Muxuqk5SAWYL3
         41MZUM3T4o5KzVp3yLBM/1yaS5F2JAy+xsaYDgTmeK6+uPiiOkdClq7fwMb4xh8jUPXb
         q5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iqD8cN6+ivvU4iBUA/M2YmIiCTZR+r/k27SL/Wa8sLA=;
        b=ESVoRgje8r+Mq69GkEKVmTs6v08EjzeHNgoajCHYSNsIVkmYTn4zW1wrgwDHnNmFji
         QYqmzh5w40RhBxEYAfo3zcbkl2xJ6Sq7/hBvRPSatGrduvnWTUfh0+5PAYAQq6bmrO2d
         XuQeAH0HuNuyLp2frCAnjTQ1csbia3HtZHIReOW7JzfHj7XG5zbFoauk7NP3rLcQEjbl
         FqkN+2jiNRcMMFre4+NGhiTHurzkR3xd83z71nvAtA9PVNQgVF5QUMkaEog6qPXayt2p
         cJ4qf9BYgwZ4BGQD+Y2RVExlmHdI7WvvMbM7DDOAn0ux/JuqfHCjTXCUszKK/FshgH2z
         SjJg==
X-Gm-Message-State: AOAM532GqzyRz2CT4uoAcDDmpUfyQ9sPY/Fp7YUVFMbj+jB8KUi6IQRU
        6nPvU1QwBw7MXxHPq98IAeL9yMTjlg==
X-Google-Smtp-Source: ABdhPJzyzsbX9XBEOAzHExe8EnKvXmroPP9Ti8Of4mQOVfNcYEGFyNpZFTG+S7YxvTtrVrz7uUxNbXVbqw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:1941:: with SMTP id 62mr7793689wmz.131.1633877822472;
 Sun, 10 Oct 2021 07:57:02 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:36 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-12-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 11/11] KVM: arm64: Handle protected guests at 32 bits
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

If this were to happen, The VMM can try and fix it by re-
initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
likely not possible for protected VMs.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2c72c31e516e..f25b6353a598 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -232,6 +232,37 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 	return hyp_exit_handlers;
 }
 
+/*
+ * Some guests (e.g., protected VMs) are not be allowed to run in AArch32.
+ * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
+ * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
+ * hypervisor spots a guest in such a state ensure it is handled, and don't
+ * trust the host to spot or fix it.  The check below is based on the one in
+ * kvm_arch_vcpu_ioctl_run().
+ *
+ * Returns false if the guest ran in AArch32 when it shouldn't have, and
+ * thus should exit to the host, or true if a the guest run loop can continue.
+ */
+static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+
+	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid. The VMM
+		 * can try and fix it by re-initializing the vcpu with
+		 * KVM_ARM_VCPU_INIT, however, this is likely not possible for
+		 * protected VMs.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		return false;
+	}
+
+	return true;
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -294,6 +325,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.882.g93a45727a2-goog

