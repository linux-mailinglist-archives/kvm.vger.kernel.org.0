Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672CD3939F5
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhE1AE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbhE1AEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 20:04:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B426AC061574;
        Thu, 27 May 2021 17:02:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so1489912pjb.2;
        Thu, 27 May 2021 17:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SeFLBMDAzUrHuAE4pyFWQsjz2vLHikZIPIbOi3aXJRY=;
        b=CKb+NO3Gk54mgnmoEzsQL7aKkPTIg5FavdZK4Rhmrcam7EGIbYZ02VyNUZKcky8mu/
         8LWcxxn7++Ts1Dz365SF9DYs4EJL5zTX3ygEH0UPKreOH/8E8tnWl7JgV5e0d2KfFPZX
         oEGoAee0mhY24cijXV6sGzgg80QQOS/orWxYU6yYWvVoChNvhTMFEODrNJ8p7oS5dVaC
         tupWiz08CacShghQOIo39pIRnIwMrW2ZCvX7BiaI6GtHq+DVw0EQOW3oqU29VwK0Is3n
         1SVBxfSGVTgT7vAIh8DpwouKuHIQ30/pYy5vaKObaK+BBVAKTrLj7jJifwUwh6bU15FC
         uMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SeFLBMDAzUrHuAE4pyFWQsjz2vLHikZIPIbOi3aXJRY=;
        b=A7t8nJnk0sHHV0OePpQMy/HrHOGUuF7oditXTSbhPG6DQN7Dq11Pg401PFkRG7WMjU
         rWIeeQCFHcYpBVk+nCJDFobwan1aqUKdjsdotXbkeYm1ibHWe0GKnEHjycaCT4mCo+ir
         lMADctB4LptR2fD4E7PdqF88LQrribRG/PsxEqr+7NUc7QyVVOeBCV3GxBMAOmQnN9Jm
         KiMaAtkK0ihH4+2RvrsNL7wmHmB7eybJRQos84NuMNmvEVRxoXGoizusJT7STwEijl14
         y/5272AYi0jYAxS0Y0wSZrt8/IEGF+1DxczKpuMBDrDFWjJWD/511VPFXusRSWL8RG2Z
         0vpg==
X-Gm-Message-State: AOAM5322D6KHD/N7qAU4sAzXlI6C2uCNXoDx1VfXuHpnGxQ6rl92Ve36
        FL5N/Eeew1Jdx/L8i96R1BhKRmkozgw=
X-Google-Smtp-Source: ABdhPJxdS2H2V1t0rm57l4hxI6q0xWG8U+Cu3Q5eunWX4qMMDDGS228qYrphOmEawfZRP9mM9ZOm8w==
X-Received: by 2002:a17:903:230b:b029:f4:b7cf:44aa with SMTP id d11-20020a170903230bb02900f4b7cf44aamr5404262plh.31.1622160151952;
        Thu, 27 May 2021 17:02:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id l126sm2726245pga.41.2021.05.27.17.02.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 May 2021 17:02:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 2/2] KVM: X86: Kill off ctxt->ud
Date:   Thu, 27 May 2021 17:01:37 -0700
Message-Id: <1622160097-37633-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
References: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

ctxt->ud is consumed only by x86_decode_insn(), we can kill it off by 
passing emulation_type to x86_decode_insn() and dropping ctxt->ud 
altogether. Tracking that info in ctxt for literally one call is silly.

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
index dba8077..d752345 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7566,9 +7566,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
-	r = x86_decode_insn(ctxt, insn, insn_len);
+	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
 	++vcpu->stat.insn_emulation;
-- 
2.7.4

