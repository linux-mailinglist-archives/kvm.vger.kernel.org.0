Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830455BB530
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIQBGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIQBGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:06:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2699C74E28
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b18-20020a253412000000b006b0177978eeso8282045yba.21
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=vvtE6TLaYPOCtfXk0O9FalggG3OGcnP88HBgikw4s3s=;
        b=ZS8EsXPJGtNTPDBSTFPeNymnL+eydmn5nRgAQiRgoh63nhdGTzOadgQMU53fsLn7vZ
         wyev2+MfrsanzyzIOq70pt1twN+lQLFEiarxgaLxdPOkrq2OZm1QoR0zbj3KqkoE427Z
         YatrzLJ4U1Qz1IUv2ublq6USSdxp1r0mjww105kH1EY5muqDOo7sBqhVPR0R8MU5Zsyp
         GkGSAk2LHIMqsfqJz8F8TSBUM9hXspKDyQNjs7qt0Gm511ZOS8tdFpf5kTQkQakbc/PE
         kc/0ZRUg2PqahDYAMM2N3CbJ6ZKl5kWN4dbhORr0VvI+EZHCar4hhJBeh2pNgIUdhczW
         Ii5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=vvtE6TLaYPOCtfXk0O9FalggG3OGcnP88HBgikw4s3s=;
        b=PihPkT93e1WT66YNwuhTZr/3wWD4M1P4+JK/OIa/a9qowZ3UYELqwZqiC9By0howRP
         iEUzmxR2iKnMs6ywAWqZKgewF1ANP09SBIppIVJep+40AjOHDGRUsjUGgRDVsTx77Pri
         PLf2onIaf8EUQkvd+C2A917InLP070BbSWbphhktUb1wB9JTs2kQTS8wjtKzq93GRJ6E
         0VPPNTu0LsfpxqPdyrZxyI8pCFxos+IFm5W199lG15v2xchWWgCyPabA/+DZ5DOgVmpo
         +fc1C9+DdhBSRIY1E4DbSnyGne53SLHs/vZ5a8EvFi5WBeh8mG/eJuzjcq/HbwdJMk+h
         okVg==
X-Gm-Message-State: ACrzQf3cVGYnUufEn+3mdyoEkP7a9uOFxqreLtVMmaKY4Z0BTjTTL6SW
        yKjBIBVmlUNTqW0/dOzeDEG67s+di8A=
X-Google-Smtp-Source: AMsMyM5s2RuFF4UFZBuj9Fx+pU9qkLjM1BVQwNejQE34KqLu+nW0MZjqstMEQeQCvo5RW6Lc97Yj1VOZmlQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8704:0:b0:6b1:302c:ad63 with SMTP id
 a4-20020a258704000000b006b1302cad63mr3468976ybl.67.1663376772490; Fri, 16 Sep
 2022 18:06:12 -0700 (PDT)
Date:   Fri, 16 Sep 2022 18:05:57 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-2-reijiw@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Preserve PSTATE.SS for the guest while
 single-step is enabled
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Preserve the PSTATE.SS value for the guest while userspace enables
single-step (i.e. while KVM manipulates the PSTATE.SS) for the vCPU.

Currently, while userspace enables single-step for the vCPU
(with KVM_GUESTDBG_SINGLESTEP), KVM sets PSTATE.SS to 1 on every
guest entry, not saving its original value.
When userspace disables single-step, KVM doesn't restore the original
value for the subsequent guest entry (use the current value instead).
Exception return instructions copy PSTATE.SS from SPSR_ELx.SS
only in certain cases when single-step is enabled (and set it to 0
in other cases). So, the value matters only when the guest enables
single-step (and when the guest's Software step state isn't affected
by single-step enabled by userspace, practically), though.

Fix this by preserving the original PSTATE.SS value while userspace
enables single-step, and restoring the value once it is disabled.

This fix modifies the behavior of GET_ONE_REG/SET_ONE_REG for the
PSTATE.SS while single-step is enabled by userspace.
Presently, GET_ONE_REG/SET_ONE_REG gets/sets the current PSTATE.SS
value, which KVM will override on the next guest entry (i.e. the
value userspace gets/sets is not used for the next guest entry).
With this patch, GET_ONE_REG/SET_ONE_REG will get/set the guest's
preserved value, which KVM will preserve and try to restore after
single-step is disabled.

Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e9c9388ccc02..ccf8a144f009 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -393,6 +393,7 @@ struct kvm_vcpu_arch {
 	 */
 	struct {
 		u32	mdscr_el1;
+		bool	pstate_ss;
 	} guest_debug_preserved;
 
 	/* vcpu power state */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0b28d7db7c76..1bd2a1aee11c 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -32,6 +32,10 @@ static DEFINE_PER_CPU(u64, mdcr_el2);
  *
  * Guest access to MDSCR_EL1 is trapped by the hypervisor and handled
  * after we have restored the preserved value to the main context.
+ *
+ * When single-step is enabled by userspace, we tweak PSTATE.SS on every
+ * guest entry. Preserve PSTATE.SS so we can restore the original value
+ * for the vcpu after the single-step is disabled.
  */
 static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
@@ -41,6 +45,9 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
 				vcpu->arch.guest_debug_preserved.mdscr_el1);
+
+	vcpu->arch.guest_debug_preserved.pstate_ss =
+					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
 }
 
 static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
@@ -51,6 +58,11 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
 				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
+
+	if (vcpu->arch.guest_debug_preserved.pstate_ss)
+		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+	else
+		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
 }
 
 /**
-- 
2.37.3.968.ga6b4b080e4-goog

