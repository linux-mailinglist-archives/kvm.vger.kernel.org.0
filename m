Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342293A80FB
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhFONnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhFONmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:53 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27807C0611C0
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:19 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id p5-20020a0ccb850000b029025849db65e9so1946488qvk.23
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f7gIb5rbS/9fOLN8dgvWOK7JCBV5aEZAvZ9qj7H9rQE=;
        b=mW9q4ubIKavGOU+Rb7aPnr1hD4mQbtR60amfOLStgdVAzy8G1ZXV0pospZ9jvjhE3P
         ZM6K+Bt7HDuOZq4dbeMHuTGhpfLrIquFHeLX1+dz/TU+bdQm5fUvjEaPt1q4ZpQ0n2eL
         dWZOG+Jo83M+JSERsHd0PSn8UEO8MSFAZMINv8BYrbe9F6IDK1pliRtNkeN4XCAXCrrh
         J18DD94cdm+kNJoqnij5o6QkeogOmDeAqtW8+QKXyf5qo+b30+jFj1fd7WLf8MwND+AI
         L/1YACkCPbMwSz1ymkC1PVqdN9igJDxPbMsBWgYlpiDbO9cG4KFN+wEw95VoReAmUmON
         AJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f7gIb5rbS/9fOLN8dgvWOK7JCBV5aEZAvZ9qj7H9rQE=;
        b=SZhgpCGD6tBKiVg3qP4mTCOv7yLaIy17DoWD4JLJs+4+aM/9t8n/i2roaRnPy5G6jI
         q2WJpq8ez8Z34yMHIXpglQKNDc1B06KXqbw9+lw3SSxN9yJSv1m9daNnTKWVzwTOS4Px
         3ygrTIYy4Q41GLp0/m5LDNhaKbO1POLj4i/iykHwVPArDj9at2vjNz3GI1e3eJtiBTnx
         sMPaNrpTZO9Wkg/HsgKin13O8YuXTzgNTAgYlsvUKSGVq9H0S1p4KepS/8yDw8odn8ZD
         A8bEXTod5kzXS0eroJM7VCuVqI85mK7bgr6MzGWA4IYsfjRUMavVXHfGI3Fh8GyAIGTv
         WrVg==
X-Gm-Message-State: AOAM5312A1Lrk43Ia7KViOnrnZTw8fLtg/LLq7cpj08899iSbWnHhxBf
        6wwTUY7Yp1ntsJNOlNxW3VmceRBryQ==
X-Google-Smtp-Source: ABdhPJwS1qgOTRkDm9mapt/6C5Eyu8aYkJbw3LxewWQRvCB49rvrPnzdxGSqNfaJ1zDu9GfhaXZESn9zRQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:c88:: with SMTP id
 r8mr4489209qvr.58.1623764418202; Tue, 15 Jun 2021 06:40:18 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:49 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-13-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 12/13] KVM: arm64: Handle protected guests at 32 bits
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
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

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d9f087ed6e02..672801f79579 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -447,6 +447,26 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs are not allowed to run in AArch32. The check below is
+	 * based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.272.g935e593368-goog

