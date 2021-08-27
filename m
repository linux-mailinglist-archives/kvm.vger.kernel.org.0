Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0343B3F97FD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244848AbhH0KRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244903AbhH0KRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E0BC061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 131-20020a251489000000b0059bdeb10a84so638521ybu.15
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OOYeyRZ535ASPcJl34CxFAtspma0NaClFfMwCj0zNiM=;
        b=MMJd98j1sjtVGzvY0xoiCe870qLTkNP4IyEZQjgVbqTh/LW07Yma/AMKoEBaiRsBUj
         dYeyIu3MYgqn4+fvSRz06yVW8rA51aG3iAnhHeXZUChsF4s3Q/2HdZxqDE3htmI3Spge
         4rAar8nENLBa+e1WETiUf3djsH0xgXB5IQjIbFL0hRlJ9X2nJM6BPGOYhgul5UDDTeQJ
         48Dh4vIZ6WWqWLpQW4yPpek3U4syFdWh+DNIQdQx3DbPEK0vKCQIchz6vHIAK3r9HGZ2
         /2WSnCl4gskjvR1DCwFmRgraJZmpoPTb8Q+8Xc/vL7iu97iW0K7EcJJ8cj1fc6WItBP5
         Uz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OOYeyRZ535ASPcJl34CxFAtspma0NaClFfMwCj0zNiM=;
        b=tUc/Mof5yLFseHC/NrCYu5CRHTQuYCfVzOROsRcbCBWZgEA5K93WJbeXDjh7ts5RLR
         zpDxR86EOEsQPd9eUWt2sEiA90jwMhB5rw7IpwZdTPFSPB8XKcIIa/fapoctx479oXjM
         0vc7N7gz2hLMp63Uyu1M+zSf5pyHA3Tm5zkNTHehExhIxjoMBIa7ckq2bJ8QFz1Lxt/h
         LiP0bWwLdEVA7w2pNbXIM9OgFmLtzSQdR81Qb+iAWYa/0y6s02QQ4BL3YTiqWoSN2r/9
         cMvTswWSJejDocwAsBTC0CTkusFmH85PTR8wN18qZVtZqm2yqe6M/2a9UWaixA9wVm1S
         26eQ==
X-Gm-Message-State: AOAM531EuF64ZWmUmRYMvoKkeotZ3z+uodGeF0t6oC2mr8gmUzh/iKnL
        ZNsmokSncM5cBr+Zd7NXENxtCzbfxw==
X-Google-Smtp-Source: ABdhPJzT2yWZOSKKQOr1U5pdRkyQythprVXGwwbqFDaS7R+/nXzLrvHZijLvzoQpOLWF/RjJwMsgi571yQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:5b44:: with SMTP id p65mr4363216ybb.336.1630059388598;
 Fri, 27 Aug 2021 03:16:28 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:09 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-9-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 8/8] KVM: arm64: Handle protected guests at 32 bits
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 41 ++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index fe0c3833ec66..8fbb94fb8588 100644
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
@@ -191,6 +192,43 @@ const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
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
+	const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
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
@@ -253,6 +291,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
+		if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
+			break;
+
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-- 
2.33.0.259.gc128427fd7-goog

