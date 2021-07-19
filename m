Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177493CE52A
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbhGSPr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350272AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE50C0ABCA9
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:33 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id h11-20020adffa8b0000b029013a357d7bdcso8961578wrr.18
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5MFwRBbHcTOjBULosBXusPd6HIHHvkQ/SJI8RKQKjoI=;
        b=jwecYIwt/LJzOwWub3fJ11KnBZkZbOZDCJYIxrSMsT9InVRCytbw4EKQI9V+QIHP4Y
         17TLshiYMJRXAhpOLIJxmX+HXYM/QINJMZmzSo2cc6Iuh0ZjSPoz2EfTOyAkL3fcgnj+
         WQqvTGpmZyJzYwlVEySrBWCeKuDA+A8tnzFq2mMjJlSlaOgZtDrgKwSmUaO7LgXVU//J
         VtrqquOz4E5hH4gOzDBavTW15yFsL1lnlNwwhakU7WnVbKt78PIljzwWsWXLPEZXfbD1
         7gyydXK95ogJ5GADzekynsAKOe1Mp15Ygz5kJr4k6Cs7BmWy5HtSOEzhf6APiH4Gendj
         xtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5MFwRBbHcTOjBULosBXusPd6HIHHvkQ/SJI8RKQKjoI=;
        b=rHvs0qviepAO3wo7WZIvNTxbFFtrbUf+EdnSiDisGiXSbiBvan1qFBdD8HjG54AjGy
         GCNdyfCmN54J3O+Wh0GKYBg7xoDW1x5/sUNJwScJMyJmfopeZgzFRxXplT5Alk+eOZ+h
         muvTjIK9GN596EWRerPQVg9A0q/FsUwootdB5MKfnaFZZRV1wPy1/cESVgH97KMIqmaa
         Cshg2x30Jb36F/h/oh5YTd9Kxq6B2MseNMU8KpFlkwdrpC4FXoMYNuj/dj1/sJ2q80mY
         bBX831BiEUJubjPBRJzQF60ZY3luDkTtnRJsdThK7fCzpVupTJUbhSDnQ/LPrsOKByA9
         Bcrw==
X-Gm-Message-State: AOAM532qCm9fEKuW5eczoudjVUP/y2DbilvmRnWqm5nvsiq54+qnvYYo
        tdU2xfuXBxiJ+26yQe00Jxm1BqoAww==
X-Google-Smtp-Source: ABdhPJycnuIWqvfS+c4stsIyFryz3mu2TLJoWq0Tp++RCd92HF5QNKLg7ceI9V02hPZ2AZSXUAk2uAkovA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4108:: with SMTP id
 j8mr32390600wmi.67.1626710655090; Mon, 19 Jul 2021 09:04:15 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:44 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-14-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 13/15] KVM: arm64: Trap access to pVM restricted features
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

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 52 ++++++++++++++++++-------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5a2b89b96c67..8431f1514280 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,6 +33,9 @@
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 36da423006bd..99bbbba90094 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,30 +158,54 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/**
+ * Handle system register accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_sys64(struct kvm_vcpu *vcpu)
+{
+	return kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) ?
+			     kvm_handle_pvm_sys64(vcpu) :
+			     0;
+}
+
+/**
+ * Handle restricted feature accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_restricted(struct kvm_vcpu *vcpu)
+{
+	return kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) ?
+			     kvm_handle_pvm_restricted(vcpu) :
+			     0;
+}
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
 static exit_handle_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= handle_pvm_restricted,
 	[ESR_ELx_EC_WFx]		= NULL,
-	[ESR_ELx_EC_CP15_32]		= NULL,
-	[ESR_ELx_EC_CP15_64]		= NULL,
-	[ESR_ELx_EC_CP14_MR]		= NULL,
-	[ESR_ELx_EC_CP14_LS]		= NULL,
-	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP15_64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_MR]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_LS]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_64]		= handle_pvm_restricted,
 	[ESR_ELx_EC_HVC32]		= NULL,
 	[ESR_ELx_EC_SMC32]		= NULL,
 	[ESR_ELx_EC_HVC64]		= NULL,
 	[ESR_ELx_EC_SMC64]		= NULL,
-	[ESR_ELx_EC_SYS64]		= NULL,
-	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= handle_pvm_restricted,
 	[ESR_ELx_EC_IABT_LOW]		= NULL,
 	[ESR_ELx_EC_DABT_LOW]		= NULL,
-	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
-	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
-	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
-	[ESR_ELx_EC_BKPT32]		= NULL,
-	[ESR_ELx_EC_BRK64]		= NULL,
-	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_WATCHPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BREAKPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BKPT32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_BRK64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= handle_pvm_restricted,
 	[ESR_ELx_EC_PAC]		= NULL,
 };
 
-- 
2.32.0.402.g57bb445576-goog

