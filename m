Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5C2426E47
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243287AbhJHQA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243261AbhJHQAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:55 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AC1C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:59 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id r21-20020adfa155000000b001608162e16dso7641926wrr.15
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0Epvk7fyUEu9mwVCJWkvWNY079YeUJZah0Cu5fJzAEQ=;
        b=bkkZXWvHXy0SOvqcTVfyEyTMLdSxme3xzkLNnyVMQIKtMfHOw9o7FMlaTNpoQbHd0l
         573fiZ7H6X+7w+Zvl0W1v4/zGGqX39Q83L4+hHRwBUywjjLL+i3JCoXI7V8XbSF1aWhf
         ag8Oow9SDCDz1pgQydp+eSPRLes0FCw9tuQ9WxdZ54V97xvUXFjOMrP2pbEP0LCyDRxq
         9EclHHjs8AVhqZckZsrNoICEACHtA/8MD0Ad5RtMPFZy/jVWZ1VRSxSAGy21y04wS9Ae
         EoOqh7x8+FzLEca90tftm7wz37rkPaI/OSV0/ekAUba4EhWtlctBVWCMPEM1mUNiz8HH
         EwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Epvk7fyUEu9mwVCJWkvWNY079YeUJZah0Cu5fJzAEQ=;
        b=LjQO44KdOvu22Y7g5al5A4e7sTr3TgdY5GbFJopsGuhLo4Y1VaMZwhqhboE7AumioS
         i8DAaQL8TxtXjif/F8h1ljGzDBhw83bsD19NbN75IjCM1kPvs7DwSb+a6Dgd45kKz2/K
         jpYBNZ3vIpUzOgJZJH0v11diBLC8lyiiNtHnUVSKtUsa35ODFDwsoU6pyD05T5BhCt+E
         +QmGSVCWZ7S4jmMJj2N2irGI3UhFfoatl2gBRnV4zVHuy5gc5p1IIgpRPcLg4MzyH01l
         f81Gj097OoFMmNKCvRO9aApZWWa6EnYmqgu+/h2TzHCprlvftVh/n6E9T4KkonI1DFe5
         Gyhg==
X-Gm-Message-State: AOAM530iifERA4Ml+HnhoLCLwoLwocPa3+C2qy9muqWc3OzR5GmweaV0
        sPBGyW9zvzEtN97+NHe9RAE1xklu1w==
X-Google-Smtp-Source: ABdhPJzU2h0ROk8Sq5UVDfvGO63XxvZxMKDO7VXZYWh/Ma9TOAK9WxoCj7FEDSVF/rrNof7KlIJt0t4MTg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:5250:: with SMTP id k16mr5225506wrc.82.1633708738469;
 Fri, 08 Oct 2021 08:58:58 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:32 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-12-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 11/11] KVM: arm64: Handle protected guests at 32 bits
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
index 2c72c31e516e..f97e3012ef60 100644
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
+	const struct kvm *kvm = kern_hyp_va(vcpu->kvm);
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

