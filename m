Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC023926B8
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 07:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhE0FDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 01:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbhE0FDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 01:03:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71935C061574;
        Wed, 26 May 2021 22:02:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v13so1733552ple.9;
        Wed, 26 May 2021 22:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l7VuWFdCQyNw6QUbl6mT63Xq+VHRKrFG3jQVWST27ZU=;
        b=R4NE0vQyugGc63JoThiZhysQsbp1MdngY/pUndjsX1O8znXI9+cgoU0wDmqRFrMslf
         w0SRPdxuNlfVFMJ4vbtauHOTVG9hTTS7woYwH42qnGRHaBvlexevEUw++3g7i43DDcpq
         gN3uC1Ss3yT+Q3dLLaa0a7RNSZfNtqeMg+8BT/MNAlKRzCxXT/3qVjULmXed+QvNz5tj
         D35W2qJC5OrVN63EbXZwQtuCVc7kf3IWI9MmWAP951gDZUMEAGpavG1oLAc7NC9abPN0
         6P+TDB+mKbLwWVJNqy7KFNZUwE3HArmRF10yCmjOp1GmyB4WAo2Law7tfkoy8JVC+wFb
         QOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l7VuWFdCQyNw6QUbl6mT63Xq+VHRKrFG3jQVWST27ZU=;
        b=oWwkTdxJ6bh6aOTHen3ts7LkZABIZJSybp9cFW72qI98hRGU9bKo0+h7y3YsYaoDrA
         b4oDRBpO9raUmV7zqtx39lnijv+ToHJ+T0ga5hOe7UuFsJu27wqo1TcqWX8z3sVrTn9L
         HOJOZVOAkRrp5XsAVn/jKgg4fFS1+EdfK+TARbMkHzNzUn/jCTw7tlrVm0QfLuOa2Pqb
         hbeu5xKCPYvC9nXi/1cl8CRAZjSEfoiDtcPvKbN6K1M92o3k+AgTAUfvpR/zKC0OPFDz
         UOIkAcJIbP2kl5YDQgjcQaj8ixb9Jn7wmbR8Zvc128tMPV30A6grvU2xvZZQeY6Kxlck
         zMeA==
X-Gm-Message-State: AOAM5336+VXn1AcsXOh+nPG0lk+9XiNO9l9mdI1F4cvGeRLuHr2xuzLK
        ek2+LTBeLiBRoD2jonZh3KBBhclwEyE=
X-Google-Smtp-Source: ABdhPJwZLUsdt3ZlRkWWrKCJIljnp9XhZ5QFo8W/7wIZUECDt4xSMGx9pH6u9xehQ3SnMQuIRKw5Jw==
X-Received: by 2002:a17:902:b594:b029:f8:fb4f:f8d3 with SMTP id a20-20020a170902b594b02900f8fb4ff8d3mr1609343pls.25.1622091733714;
        Wed, 26 May 2021 22:02:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.40])
        by smtp.googlemail.com with ESMTPSA id z7sm668384pgr.28.2021.05.26.22.02.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 May 2021 22:02:13 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 2/2] KVM: X86: Kill off ctxt->ud
Date:   Wed, 26 May 2021 22:01:19 -0700
Message-Id: <1622091679-31683-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622091679-31683-1-git-send-email-wanpengli@tencent.com>
References: <1622091679-31683-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

ctxt->ud is consumed only by x86_decode_insn(), we can kill it off by passing
emulation_type to x86_decode_insn() and dropping ctxt->ud altogether. Tracking 
that info in ctxt for literally one call is silly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/emulate.c     | 5 +++--
 arch/x86/kvm/kvm_emulate.h | 3 +--
 arch/x86/kvm/x86.c         | 4 +---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8a0ccdb..5e5de05 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5111,7 +5111,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	return rc;
 }
 
-int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
+int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
 {
 	int rc = X86EMUL_CONTINUE;
 	int mode = ctxt->mode;
@@ -5322,7 +5322,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 
 	ctxt->execute = opcode.u.execute;
 
-	if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
+	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
+	    likely(!(ctxt->d & EmulateOnUD)))
 		return EMULATION_FAILED;
 
 	if (unlikely(ctxt->d &
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index f016838..3e870bf 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -314,7 +314,6 @@ struct x86_emulate_ctxt {
 	int interruptibility;
 
 	bool perm_ok; /* do not check permissions if true */
-	bool ud;	/* inject an #UD if host doesn't support insn */
 	bool tf;	/* TF value before instruction (after for syscall/sysret) */
 
 	bool have_exception;
@@ -491,7 +490,7 @@ enum x86_intercept {
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT64
 #endif
 
-int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len);
+int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type);
 bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_FAILED -1
 #define EMULATION_OK 0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ae47b19..d752345 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7231,8 +7231,6 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	ctxt->exception.vector = -1;
 	ctxt->perm_ok = false;
 
-	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
 	init_decode_cache(ctxt);
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
@@ -7568,7 +7566,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	r = x86_decode_insn(ctxt, insn, insn_len);
+	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
 	++vcpu->stat.insn_emulation;
-- 
2.7.4

