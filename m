Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0343EE82E
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbhHQINM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhHQIMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5014C0613CF
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id w19-20020ac87e930000b029025a2609eb04so10638757qtj.17
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GwBibOWYXter2+CeY3r4WjkndBFtBCh1zMuQU5reF9A=;
        b=TaP5HLSckkUY51veXyfP8aLq+lpBiNGYeORdB1m4e2OGEMWyXysqyPJyKmc2EZNCfT
         b+BUDY7wqFaCh1GTw+y3WhaHIuLBAXcejHOZ1kIT1UVJKPD0DTkOR9zpQFlGtSut54Ve
         6FcMYxuttHsA//J8xglMwAWQCdnipLpW9fhs0u+809xR3ZywlmJvTe96+EukUGktBjmr
         aFtP6OzyrKvd1jZCbUsvkpDwUpjW/98ueluGuPPWIjSy046HBebTfZ5xeJ66cDRvQgzH
         /ewp8xIjK8m9eN64A9+NmEsmtIEtg8Wi7yInIrgXAa3JA+Y7iFlP1iATJHT0q5tn9PCG
         RsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GwBibOWYXter2+CeY3r4WjkndBFtBCh1zMuQU5reF9A=;
        b=h7GpIKSL62Qf2R00uC2jsw9I6rs3FQ+r7LQ3PN5tvbbwSLo+xsqi8RrDRXPXTR1iAj
         b5NRIh2epDgCkxSbq7qEgUaQzWl/ThUfEzGOJAWV/DahRbR391nZQNf4PPC2wmP1KW8D
         mlGOM2QQrIj7/Uk6Cp7w7RvHtz5/4ZWlr0gy+eVuhTaXZl0iMEdwDBK9nDz8twu0x1IR
         jQFOuahYjmNQY9gREdJKRFzC+lWsJBqI+0zxmK1b5HS/NbYL3GKGidwBNbvfaq9EZgPt
         D1/gzL5MyhpMbdgal2bGSDcFPVaGUkv7TU2CkxujrbX17MJiNNjrZajzA1884OozOuue
         thag==
X-Gm-Message-State: AOAM533i5BKJvJeium2HuGd9hQCdeFvHsOPj4rwyCjqKfuPfmNguH1w4
        7/Bxt25+rZB58DflOg86V3K6gW8j7Q==
X-Google-Smtp-Source: ABdhPJzdIqbLAYM6kPwUzmsBpGGJcl8EyMI40ZKNefrU0jERoj9lntCdBUE9/mgLqEPe2aj2UczmekLMtQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:902:: with SMTP id
 dj2mr2109786qvb.62.1629187927890; Tue, 17 Aug 2021 01:12:07 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:34 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-16-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 398e62098898..0c24b7f473bf 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,6 +20,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
 		return NULL;
 }
 
+/*
+ * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
+ * check below is based on the one in kvm_arch_vcpu_ioctl_run().
+ * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
+ * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
+ * hypervisor spots a guest in such a state ensure it is handled, and don't
+ * trust the host to spot or fix it.
+ *
+ * Returns true if the check passed and the guest run loop can continue, or
+ * false if the guest should exit to the host.
+ */
+static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+	    vcpu_mode_is_32bit(vcpu) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+					 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
+		ID_AA64PFR0_ELx_32BIT_64BIT) {
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
@@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

