Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7313538F876
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 05:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhEYDFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 23:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhEYDFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 23:05:18 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DDCC061574;
        Mon, 24 May 2021 20:03:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 22so22076812pfv.11;
        Mon, 24 May 2021 20:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cYfiwJ/w2ntWHiGn8Ut2Mv2U+24DNRGZ2IaLNOo55oI=;
        b=B8LrkPwurS60GEzPr6Ae8uMl9/MeFn/h5WNNW40j2dZzw/L7jGMvGWO0297+Q+LrfL
         mypyYwsswSG8gSgRIyHjVg9w6TBG2Gded/wkvypkjCGKKRR72VfzWrgdcVEMDBelIMb9
         kuyLld2iXdt5+nd1PV4rvaTVM6gioIZCNtKeMRnc/xU9GojCAtLILsdzhLxuD8fF4uGX
         1KCZtw5twqM2sInI5AAsqM3U+Wv5N1JC4jbWlHpvHM4pHKDxUU0ArRQg/GSqdFIdTmz3
         6aan6VuEAdJHNfaeIYQtCBQ35p2TT3JJgs0fbq2djWDNd5rm71ojWSIPYMDn6Oa2FiA/
         KKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cYfiwJ/w2ntWHiGn8Ut2Mv2U+24DNRGZ2IaLNOo55oI=;
        b=EAfjIuYoO5svRx4pzAsFrl8I/5+6Olk1KYNX0oIKf0Vxqz6QhJwmghi7CzsHgCmOmC
         mY0aaeid7yORhLItOl7WVBjfvXOklPZdp0Fugf3CxbdVXG2rrzf99FbmNru7YRrgxQBs
         E6ElzoK7GD+sw5nIduEhsWBkSkcTwM04kdw7DOEgZZHCrQJ3owWgcnVygf8LSRO89V+N
         GvSuWYdXxltfXLEVSSoTq0pE+hcwHSn1+jhwzhj4jclLKVD9nbJdTMnmf0n9EGPL1ba8
         ECk+Vt7nu8PxAKdfckeVvIF7zY+Sx47nAyLFOeEdP7T4xUAP5hpN+j8DxK2eyi1GzbGF
         Kjyg==
X-Gm-Message-State: AOAM532pcmmTYPDJSEYHWm/cytK06+1Yel4M53Ydnt260h7LV52RxqUi
        0oAjz/kI+wOqMEQQsjOxWuzUnO2Nviw=
X-Google-Smtp-Source: ABdhPJwZWIf3jK2XH+H7DONmlrr//4efVH4Uf4jivVPJwvAzhkqM3B8hx5McNUNjTVrCXIixvTKVLA==
X-Received: by 2002:a05:6a00:7c5:b029:2e8:d5f5:9677 with SMTP id n5-20020a056a0007c5b02902e8d5f59677mr9769497pfu.68.1621911828796;
        Mon, 24 May 2021 20:03:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id a10sm12506217pfg.173.2021.05.24.20.03.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 May 2021 20:03:48 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] KVM: X86: Kill off ctxt->ud
Date:   Mon, 24 May 2021 20:02:47 -0700
Message-Id: <1621911767-11703-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621911767-11703-1-git-send-email-wanpengli@tencent.com>
References: <1621911767-11703-1-git-send-email-wanpengli@tencent.com>
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
index 3c109d3..7ea9424 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7559,8 +7559,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 
 	init_emulate_ctxt(vcpu);
 
-	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
 	/*
 	 * We will reenter on the same instruction since we do not set
 	 * complete_userspace_io. This does not handle watchpoints yet,
@@ -7570,7 +7568,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	r = x86_decode_insn(ctxt, insn, insn_len);
+	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
 	++vcpu->stat.insn_emulation;
-- 
2.7.4

