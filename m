Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A1F45ADBC
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhKWVE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhKWVE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:27 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEEAC06173E
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:18 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id k5-20020a92c245000000b0026d8bebbff7so241765ilo.2
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3r/HSQlSMaGqGuO6qlyByqylj4w37aYh03CWLKihWyE=;
        b=I8o6vjAywpa6ruSUYX/8rdQEeBmRUvrZry6knOs03Fgu95sSJgIAGoEOAm5r52PDyM
         OPUu6j2D962rPDVnZCg/PcPaiRpKDm27kqyLUztlCTLwup2hcjFYHG7RZ4r4CJHzjpjo
         47XmcQns0NFxIW4y+Tam+CSpz0of/dHbWg06/kEztW/6TQd9Jtg184l9TrwZiJG22i8G
         Ya24YTmfCQKVw8J7RVMbFS7QOLYgstBAxVflKJRtxOBJKbsWMs2c3RD6WxijeZUXsOTA
         k0aYjkpMBXtBcwytCiuXiX9UvwE4imWn/KbfC7lMdFNzMHklDMH/bAN/hYO5xQ3AAg4g
         2e2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3r/HSQlSMaGqGuO6qlyByqylj4w37aYh03CWLKihWyE=;
        b=UlVP6KhVMskgcdEZgu/q0cbzn3mkbe4OroMRxj38D1jHKK5XcxzxOTAEZdlIcI8N+7
         wX+aqlVOl7p6Njf56jE7hmsWJYZaFNiJTJ9GgICd5T4ykktjHFzo/TgkAAM1ZixBCPui
         NmTwzFRg9wOAlYYjGfJHMNli9U/nxcxojWZENeKQ30oJJ24jtsYOZMf66UPi7GA0DC/o
         XdXjy91Nt9dp4PrvcEUt9QQZ2wKCFwF7CZBU/13rQCC/TVanIILhxmOFtz0uW3JR2dQI
         biMhI9iSSimiXEymsv5twy8nu7Egam27F+4bDW/zQ1oe8D8UDoouzu0PXt7BLk5sCNK5
         QzqQ==
X-Gm-Message-State: AOAM533XUOg/sXQesZYGfDlRuu0FvnHqkdwRlqLGJNckoGDQmrBjV/n/
        0fi/wp+Lcd7DBNH0ushijHPaVhoeaNA=
X-Google-Smtp-Source: ABdhPJyC0nmrb9p3Fph5PiHQgzCf4XqAVV9qwdGI+BZkjpGMX0GXawApszVLVF40+DN93mTIiNXihq0S8Bg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:2146:: with SMTP id
 d6mr7996051ilv.45.1637701278015; Tue, 23 Nov 2021 13:01:18 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:05 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-3-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
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

An upcoming change to KVM will context switch the OS Lock status between
guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
using the stored value.

Wire up a custom handler for writes from userspace and prevent any of
the invariant bits from changing.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..53fc8a6eaf1c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -172,8 +172,10 @@ enum vcpu_sysreg {
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+	OSLSR_EL1,	/* OS Lock Status Register */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
+
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
 	PMSELR_EL0,	/* Event Counter Selection Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 11b4212c2036..7bf350b3d9cd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,12 +291,28 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
+	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
-	} else {
-		p->regval = (1 << 3);
-		return true;
-	}
+
+	p->regval = __vcpu_sys_reg(vcpu, r->reg);
+	return true;
+}
+
+static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			 const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u64 id = sys_reg_to_index(rd);
+	u64 val;
+	int err;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	if (val != rd->val)
+		return -EINVAL;
+
+	return 0;
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
@@ -1448,7 +1464,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
+		.set_user = set_oslsr_el1, },
 	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
@@ -1923,7 +1940,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
 	DBGBXVR(1),
 	/* DBGOSLSR */
-	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
+	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
 	DBGBXVR(2),
 	DBGBXVR(3),
 	/* DBGOSDLR */
-- 
2.34.0.rc2.393.gf8c9666880-goog

