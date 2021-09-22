Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4A41498F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhIVMtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbhIVMtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:49:04 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00FC0613C1
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:32 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h10-20020a05620a284a00b003d30e8c8cb5so10037410qkp.11
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MCg7tHy3/sZ81tGGFXf0NcnSSZrwV+Eij7+P/yRsSfg=;
        b=EiMTA1NnhtOUvnrBFvPdoslDCpEUBRA+f3Q+0xFhUdwNwFKpnE1rIZITIVSG+lZ7m6
         szKsCVt2+byDFfsu8ex+Vl/Em/kSog5HGfVbKv+x1oBqXfC4SJRoN/tdHYG6ZDVYOf9r
         XILDlqXVu0shnC8/4najcsjA+dsJzLGyaEOLHg6Ji3MwioXvsTAJSrifCeZ6J3BqdR8X
         Oai+aUpC/qGou978VV0ybNJafCXFduFfSD1oVPVaiuAwmDEUImb9mq5DRvQ3DuW6Gp9q
         QoIiTJ04JAv6wENM2NmcsF3jpqBjcmdTWpPA297mOqJnHSB91TGUaNbFsobw84DcrTlO
         TLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MCg7tHy3/sZ81tGGFXf0NcnSSZrwV+Eij7+P/yRsSfg=;
        b=r9bNQsWk6NYWVPHm8IHNpeCX3bVzUIbyOHxRb0lwRatkmR6YS6aUYBJG2SxlVpS+nw
         /AieJcvhgtqJ9ChufkYFL/kTW8s34bPyJil7PiSpdImPBWUD46xmbvWz7dhZKgSyRxJ8
         QWa21IqhPpxtmSz7pGr2G7CXJ1V/tfqfThntvzJD0m9H99zyxR325dTWaJusvYTXOlNu
         nYxU3QhPUVGMqH3rY2XydXZzDPOZCS0gAtJnQIOL/4ofoAspq1JywTFpwFHxknMNRLfC
         zxPPCpFKD/bud5qGVoGpRAQslBmZ6JQjGQFLsou+lXcpsFdc1TgmmNKtTaJ7Tkwt9EEM
         2Zaw==
X-Gm-Message-State: AOAM531iT6796U8IHXG57afy6BHZhX204E1/5sq2iHa2RimQ9iSpDbAo
        8KBpFxvHzIRNjzpu7SoeG2eLR8O+Ew==
X-Google-Smtp-Source: ABdhPJxdGqe4Wwg8ftovL0+NfZlJpKCUs8fzSEQy3CdlkWIXsbQJJ1pi4X33SfdQvc0UggyU55QtvD50hg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:46ab:: with SMTP id br11mr36084622qvb.15.1632314851756;
 Wed, 22 Sep 2021 05:47:31 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:47:04 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-13-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 12/12] KVM: arm64: Handle protected guests at 32 bits
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 40 ++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2bf5952f651b..d66226e49013 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -235,6 +235,43 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 	return hyp_exit_handlers;
 }
 
+/*
+ * Some guests (e.g., protected VMs) might not be allowed to run in AArch32.
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
+	struct kvm *kvm = (struct kvm *) kern_hyp_va(vcpu->kvm);
+	bool is_aarch32_allowed =
+		FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+			  get_pvm_id_aa64pfr0(vcpu)) >=
+				ID_AA64PFR0_ELx_32BIT_64BIT;
+
+	if (kvm_vm_is_protected(kvm) &&
+	    vcpu_mode_is_32bit(vcpu) &&
+	    !is_aarch32_allowed) {
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
@@ -297,6 +334,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.464.g1972c5931b-goog

