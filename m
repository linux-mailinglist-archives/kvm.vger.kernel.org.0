Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95E43F3F9
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhJ2AfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 20:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhJ2AfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 20:35:12 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB85C061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:43 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id q65-20020aca5c44000000b0029c0a4d28a5so113477oib.5
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8jHkcukOGs60Vh8sqIk5PEDCEkQaDcCSTeMEW1ZoThU=;
        b=JdhR5KgizbNUUTAjmlYRxJx0EtRpzClBjN8sNGCA4JJO4HHHb6OXPbkGWVWsexwurl
         kRU/OrYOvFTWusWVmdojV2LmmS3eksr37DnFEYydJYDaWiHjFtnAErqEYg97xPlTHxHn
         nLUvfSd9uIXXDeEqhI/d07olbwebG44JjMzSvnmAiFv9ny7vqeJmJcMZCzv9Txyee4A1
         AH50A4MUa8rJlxoiWXiA/FNFIrwGua22jIX3diDsCegQ2R353dFwc0iVF1Ubi2YZ4UDY
         m1tQpzc7VBbKbCWLZcVd52Qs91rPh+JGCvqvxhTGc6bQlM+BZoafUHzt0/wQE/NVWNBr
         1N3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8jHkcukOGs60Vh8sqIk5PEDCEkQaDcCSTeMEW1ZoThU=;
        b=cm4kMnqLsKAz2CEQnA+hAq9y7ybZn9zoy/1Rr4JlO7D7CnV/TzAcxFBj+CjslCjp/I
         tw9YRWIn9B+aHO5CohC/T+I12VZX/tmE4kpDgycIpEl3rWjyeUAUPAC7CRajPHhKDlkm
         HbsB79Ncq+xxnfhtYYPWqMihP3jc/ePF+Y4SgMLOwfEYN1APKQEVdk1mFTYOSlJKMfik
         y0OQgYPZXML2J291DkPkWz8HZJzu+uR49pZkjnNGfMcf3NV50aSoXwhrszhD5dRB1Guq
         TT4/7JTxoIc6fq4mHtuLZ6QMqczNGLIM8N9J0ctJeh2KDHtUJ0qw8fxWqPzAsBKB2Al/
         sBwg==
X-Gm-Message-State: AOAM533frOhon5YjoEH/KcXjQvceTVti1c5nnonnTBZ070BlWTZX8W6o
        wmIgo6fOFjxSrfTh5gUUL0nqtExbPb0=
X-Google-Smtp-Source: ABdhPJyaxDFxxmg122WEeWbg/RrVAHJJLIJnz/MlGJ2fjJIs/pCIhzGPDOjoXFCCGLJwb76Yre8ULKN1ULY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:3e86:: with SMTP id l128mr11380539oia.120.1635467563254;
 Thu, 28 Oct 2021 17:32:43 -0700 (PDT)
Date:   Fri, 29 Oct 2021 00:32:01 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-3-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 2/3] KVM: arm64: Allow the guest to change the OS Lock status
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM diverges from the architecture in the way it handles the OSLAR_EL1
register. While the architecture requires that the register be WO and
that the OSLK bit is 1 out of reset, KVM implements the register as
RAZ/WI.

Align KVM with the architecture by permitting writes to OSLAR_EL1. Since
the register is WO, stash the OS Lock status bit in OSLSR_EL1 and
context switch the status between host/guest. Additionally, change the
reset value of the OSLK bit to 1.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  5 +++++
 arch/arm64/kvm/sys_regs.c                  | 22 +++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index de7e14c862e6..a65dab34f85b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -65,6 +65,8 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
+
+	ctxt_sys_reg(ctxt, OSLSR_EL1)	= read_sysreg(oslsr_el1);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -149,6 +151,9 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
+
+	/* restore OSLSR_EL1 by writing the OSLK bit to OSLAR_EL1 */
+	write_sysreg((ctxt_sys_reg(ctxt, OSLSR_EL1) >> 1) & 1, oslar_el1);
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0eb03e7508fe..0840ae081290 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -298,6 +298,22 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 oslsr;
+
+	if (!p->is_write)
+		return read_zero(vcpu, p);
+
+	/* preserve all but the OSLK bit */
+	oslsr = vcpu_read_sys_reg(vcpu, OSLSR_EL1) & ~0x2ull;
+	vcpu_write_sys_reg(vcpu, OSLSR_EL1, oslsr | ((p->regval & 1) << 1));
+	return true;
+}
+
+
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 				   struct sys_reg_params *p,
 				   const struct sys_reg_desc *r)
@@ -1439,8 +1455,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008 },
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1912,7 +1928,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 
 	DBGBXVR(0),
 	/* DBGOSLAR */
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
 	DBGBXVR(1),
 	/* DBGOSLSR */
 	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
-- 
2.33.0.1079.g6e70778dc9-goog

