Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E630534673
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 00:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345438AbiEYW01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 18:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345379AbiEYW0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 18:26:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C118276
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:14 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g69-20020a625248000000b00519150d186bso70532pfb.18
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 15:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1K6OM5CVosmRq7VrXJUvnPyF0+jKI5Wt9fyUJ3K2ibY=;
        b=L3C+sxFViTeVKuyVx5ivxoNs7Q6DYSLINTgXeRAUuwL1UVebb8TNStoOpMZyfvPmh7
         VU+hFtXQ2sdfPs465VxYnDTutAK2XRTNQbBz9Ht2PHH4sRve6QgaSf01OMCXm63bwqGN
         TKTmrdaY1EGLCOpSa1LH4g3mL/V1MYdFetwPFYdxNhlDI/DlnnvqFaqX7Rlc/ppN4zPf
         DuaG4mikEbaBkcOsHBWoOcI666PRRP/tDC3SdopDwzkvXYU/pb8XHb5sg7iqFnV+HFHI
         3TFgrrEBIOIymBspGi1iMC95/Q0EQ7VwvHnH9BoFgOlQu0+mPtt4RWu/eB7M/uC2JEsb
         7IYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1K6OM5CVosmRq7VrXJUvnPyF0+jKI5Wt9fyUJ3K2ibY=;
        b=e3LyocV4rXS0jpIZ6MtcqvSSgW4LtSFkcjz+vWSmBtc56dFZybQFqgxoyjrPop7xUK
         pveCup4e5615jF9X6ZCLOAdwZzhVJyKcSwH7tqUY6qldJ2B+QYLX/56tO7Ylf1YGcmoH
         5QeBXrRJK8kJhJpe6x3F9LqhYR2l/Fd2jWh1T33I1/aDWc3zxZrXAp0koqKW+UVjcvUT
         EPHegRZBy7vZAiJMAVD6sIGoo+CKKp8Fx24yQCNun2m19LD3ajQAtk8RLBz8ztEGibIV
         tJhzbnE3f1nLUOgQzOcvGFm5ApaPKFROIpytlo4TMdKvcWoyKBFowsCqfMpMjhV0xi05
         7I8g==
X-Gm-Message-State: AOAM532/T4BByAZHlG1vpRVAiqbtEgi+ftiJUkQiExaCLfiQt6N/5v2y
        tmrF4BG5q+YXadBkbwGbGyFHtGEa4DA=
X-Google-Smtp-Source: ABdhPJy88zKrcNaUS/fJ+z8CMMhWxSLqAWS1xOCdoT7FwuQTGaaLJiJLN6NuKX+u7dqcA6a7HXAciPgJN2E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1192:b0:1e0:63f3:c463 with SMTP id
 gk18-20020a17090b119200b001e063f3c463mr30564pjb.1.1653517573248; Wed, 25 May
 2022 15:26:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 25 May 2022 22:26:03 +0000
In-Reply-To: <20220525222604.2810054-1-seanjc@google.com>
Message-Id: <20220525222604.2810054-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220525222604.2810054-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 3/4] KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs array
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Omit RIP from the emulator's _regs array, which is used only for GPRs,
i.e. registers that can be referenced via ModRM and/or SIB bytes.  The
emulator uses the dedicated _eip field for RIP, and manually reads from
_eip to handle RIP-relative addressing.

Replace all open coded instances of '16' with the new NR_EMULATOR_GPRS.

See also the comments above the read_gpr() and write_gpr() declarations,
and obviously the handling in writeback_registers().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 12 ++++++------
 arch/x86/kvm/kvm_emulate.h | 10 +++++++++-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c58366ae4da2..dd1bf116a9ed 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -247,8 +247,8 @@ enum x86_transfer_type {
 
 static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
-	if (WARN_ON_ONCE(nr >= 16))
-		nr &= 16 - 1;
+	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
+		nr &= NR_EMULATOR_GPRS - 1;
 
 	if (!(ctxt->regs_valid & (1 << nr))) {
 		ctxt->regs_valid |= 1 << nr;
@@ -259,8 +259,8 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
-	if (WARN_ON_ONCE(nr >= 16))
-		nr &= 16 - 1;
+	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
+		nr &= NR_EMULATOR_GPRS - 1;
 
 	ctxt->regs_valid |= 1 << nr;
 	ctxt->regs_dirty |= 1 << nr;
@@ -278,7 +278,7 @@ static void writeback_registers(struct x86_emulate_ctxt *ctxt)
 	unsigned long dirty = ctxt->regs_dirty;
 	unsigned reg;
 
-	for_each_set_bit(reg, &dirty, 16)
+	for_each_set_bit(reg, &dirty, NR_EMULATOR_GPRS)
 		ctxt->ops->write_gpr(ctxt, reg, ctxt->_regs[reg]);
 }
 
@@ -2495,7 +2495,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	u16 selector;
 	int i, r;
 
-	for (i = 0; i < 16; i++)
+	for (i = 0; i < NR_EMULATOR_GPRS; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
 
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 8dff25d267b7..bdd4e9865ca9 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -301,6 +301,14 @@ struct fastop;
 
 typedef void (*fastop_t)(struct fastop *);
 
+/*
+ * The emulator's _regs array tracks only the GPRs, i.e. excludes RIP.  RIP is
+ * tracked/accessed via _eip, and except for RIP relative addressing, which
+ * also uses _eip, RIP cannot be a register operand nor can it be an operand in
+ * a ModRM or SIB byte.
+ */
+#define NR_EMULATOR_GPRS	(VCPU_REGS_R15 + 1)
+
 struct x86_emulate_ctxt {
 	void *vcpu;
 	const struct x86_emulate_ops *ops;
@@ -363,7 +371,7 @@ struct x86_emulate_ctxt {
 	struct operand src2;
 	struct operand dst;
 	struct operand memop;
-	unsigned long _regs[NR_VCPU_REGS];
+	unsigned long _regs[NR_EMULATOR_GPRS];
 	struct operand *memopp;
 	struct fetch_cache fetch;
 	struct read_cache io_read;
-- 
2.36.1.124.g0e6072fb45-goog

