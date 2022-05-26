Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB9535573
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349139AbiEZVY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348989AbiEZVYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:24 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7E669494
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gn21-20020a17090ac79500b001dc8a800410so3841466pjb.0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PHlgII++2wIvs6hDrvRGyxpTlkYLyG2XZsv/tF8ktec=;
        b=EjR3CvFdD4qmlvt2dipOIuLCgt9cB3TxZLX5sW8gDxj1N8MgeukB2KSfi/Wd5x2+3V
         ltKUp9vKh5QUHtlVZ4NMPI7aQyK2f51a/p7hIlK/d7diGjA53aQbgMavD+zhUrHOO0C1
         Pt9YMGdQFMlHSSwSNmsczu0nbjX2665XijE+VPVJC7Vt2xvRxPs3wGR3Kw0a3t2mxYNV
         lL2QIM1nxqtarHU6Ruu98837OKk+1fSmEaVbICbmvZM6u5uVP8jpu8iMqnnx4Z4Y+Lx8
         HLSvHmSilB4NSH9tWVJDVmWMJoNQUF1qT7JYLFzMHc7ANM2c5oR7ZSB2U9NsuXPbjG2j
         KszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PHlgII++2wIvs6hDrvRGyxpTlkYLyG2XZsv/tF8ktec=;
        b=ejk6Qr6SnyplSFYtT9Q3epQLYmlPYPJIO39pxoLaj+Ikg5zu2K10VMAgFvt7p4nQ6l
         EPN0agSDlfMhgbEV7+eNqPBQCsLdGS0Ry/4raqicbeeS407DGAdrf14RzJu/BZIrYh02
         IDMLt6zu/nR7UcJVqDEvKLVhwG0Q0GH4ursbfMN8xVkrltmp1LsZ4u6k9wJknb4/mT0e
         HBOEuoVFQ7VZxmTCptrA+MYgoJc2SpgTc/SvZF8m4EuP4KgwKgVPlF0L7Opu0z6Tuf+b
         9b5rIpHn/2FfEGw2lgUKGPez9FjrjisfD7gjlIxN13hs2RLVj+xWpTMHspL/vekwZoTp
         oW5g==
X-Gm-Message-State: AOAM531kWtwE+QyYw63TK17oQGYPJ9mQ4y9VjRZ094xsvjZyFfO24tCt
        60jdFyc56BrrsqdxmkAinatAaGO5eX8=
X-Google-Smtp-Source: ABdhPJw/ccwDmeY7jf7RVD+CTb+pd3p8Uic7RhBWSbMGkZIbC9D4edge/H18CR7gVRPN4L8jAPWVcX7Knck=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:86c7:0:b0:3fb:a6ea:b73a with SMTP id
 x190-20020a6386c7000000b003fba6eab73amr367971pgd.510.1653600262128; Thu, 26
 May 2022 14:24:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:12 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 3/8] KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs array
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>
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

To avoid an even bigger, slightly more dangerous change, hardcode the
number of GPRs to 16 for the time being even though 32-bit KVM's emulator
technically should only have 8 GPRs.  Add a TODO to address that in a
future commit.

See also the comments above the read_gpr() and write_gpr() declarations,
and obviously the handling in writeback_registers().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 10 +++++-----
 arch/x86/kvm/kvm_emulate.h | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c58366ae4da2..c74c0fd3b860 100644
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
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 8dff25d267b7..bc3f8295c8c8 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -301,6 +301,17 @@ struct fastop;
 
 typedef void (*fastop_t)(struct fastop *);
 
+/*
+ * The emulator's _regs array tracks only the GPRs, i.e. excludes RIP.  RIP is
+ * tracked/accessed via _eip, and except for RIP relative addressing, which
+ * also uses _eip, RIP cannot be a register operand nor can it be an operand in
+ * a ModRM or SIB byte.
+ *
+ * TODO: this is technically wrong for 32-bit KVM, which only supports 8 GPRs;
+ * R8-R15 don't exist.
+ */
+#define NR_EMULATOR_GPRS	16
+
 struct x86_emulate_ctxt {
 	void *vcpu;
 	const struct x86_emulate_ops *ops;
@@ -363,7 +374,7 @@ struct x86_emulate_ctxt {
 	struct operand src2;
 	struct operand dst;
 	struct operand memop;
-	unsigned long _regs[NR_VCPU_REGS];
+	unsigned long _regs[NR_EMULATOR_GPRS];
 	struct operand *memopp;
 	struct fetch_cache fetch;
 	struct read_cache io_read;
-- 
2.36.1.255.ge46751e96f-goog

