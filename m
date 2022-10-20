Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B6D605AFD
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJTJUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJTJT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:19:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6115BC08;
        Thu, 20 Oct 2022 02:19:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 566EC22C1E;
        Thu, 20 Oct 2022 09:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666257592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=VJ2I0b15w5fQKvftSzDhG2CzJchK/TE1on9PX4jZ5+M=;
        b=OaBWurY/DESN2JBCxCPIqTSKNsVsxgy/uq68gGTtDZOWhtJ7xsQkjSJlma+CkN1NpQOh5O
        tVfi26Aq1oWCAL5rAaAFX6LfhXiLDoXyeJB1XxKnrcPjTnqrUQECoLJOjAEbT1KLteGJKR
        rnFC6r6RF8gVNTCfsda9EzEp35u/JO4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD8A313494;
        Thu, 20 Oct 2022 09:19:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1UWfNLcSUWMbOAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 20 Oct 2022 09:19:51 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] x86/paravirt: use common macro for creating simple asm paravirt functions
Date:   Thu, 20 Oct 2022 11:19:50 +0200
Message-Id: <20221020091950.6741-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some paravirt assembler functions which are sharing a common
pattern. Introduce a macro DEFINE_PARAVIRT_ASM() for creating them.

The explicit _paravirt_nop() prototype in paravirt.c isn't needed, as
it is included in paravirt_types.h already.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/paravirt.h           | 12 ++++++
 arch/x86/include/asm/qspinlock_paravirt.h | 46 ++++++++++-------------
 arch/x86/kernel/kvm.c                     | 19 +++-------
 arch/x86/kernel/paravirt.c                | 22 ++---------
 4 files changed, 40 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 2a0b8dd4ec33..479bf264b8aa 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -730,6 +730,18 @@ static __always_inline unsigned long arch_local_irq_save(void)
 #undef PVOP_VCALL4
 #undef PVOP_CALL4
 
+#define DEFINE_PARAVIRT_ASM(func, instr, sec)		\
+	asm (".pushsection " #sec ", \"ax\"\n"		\
+	     ".global " #func "\n\t"			\
+	     ".type " #func ", @function\n\t"		\
+	     __ALIGN_STR "\n"				\
+	     #func ":\n\t"				\
+	     ASM_ENDBR					\
+	     instr					\
+	     ASM_RET					\
+	     ".size " #func ", . - " #func "\n\t"	\
+	     ".popsection")
+
 extern void default_banner(void);
 
 #else  /* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/qspinlock_paravirt.h b/arch/x86/include/asm/qspinlock_paravirt.h
index 60ece592b220..c490f5eb9f3e 100644
--- a/arch/x86/include/asm/qspinlock_paravirt.h
+++ b/arch/x86/include/asm/qspinlock_paravirt.h
@@ -14,8 +14,6 @@
 
 __PV_CALLEE_SAVE_REGS_THUNK(__pv_queued_spin_unlock_slowpath, ".spinlock.text");
 #define __pv_queued_spin_unlock	__pv_queued_spin_unlock
-#define PV_UNLOCK		"__raw_callee_save___pv_queued_spin_unlock"
-#define PV_UNLOCK_SLOWPATH	"__raw_callee_save___pv_queued_spin_unlock_slowpath"
 
 /*
  * Optimized assembly version of __raw_callee_save___pv_queued_spin_unlock
@@ -37,32 +35,26 @@ __PV_CALLEE_SAVE_REGS_THUNK(__pv_queued_spin_unlock_slowpath, ".spinlock.text");
  *   rsi = lockval           (second argument)
  *   rdx = internal variable (set to 0)
  */
-asm    (".pushsection .spinlock.text;"
-	".globl " PV_UNLOCK ";"
-	".type " PV_UNLOCK ", @function;"
-	".align 4,0x90;"
-	PV_UNLOCK ": "
-	ASM_ENDBR
-	FRAME_BEGIN
-	"push  %rdx;"
-	"mov   $0x1,%eax;"
-	"xor   %edx,%edx;"
-	LOCK_PREFIX "cmpxchg %dl,(%rdi);"
-	"cmp   $0x1,%al;"
-	"jne   .slowpath;"
-	"pop   %rdx;"
+#define PV_UNLOCK_ASM							\
+	FRAME_BEGIN							\
+	"push  %rdx\n\t"						\
+	"mov   $0x1,%eax\n\t"						\
+	"xor   %edx,%edx\n\t"						\
+	LOCK_PREFIX "cmpxchg %dl,(%rdi)\n\t"				\
+	"cmp   $0x1,%al\n\t"						\
+	"jne   .slowpath\n\t"						\
+	"pop   %rdx\n\t"						\
+	FRAME_END							\
+	ASM_RET								\
+	".slowpath:\n\t"						\
+	"push   %rsi\n\t"						\
+	"movzbl %al,%esi\n\t"						\
+	"call __raw_callee_save___pv_queued_spin_unlock_slowpath\n\t"	\
+	"pop    %rsi\n\t"						\
+	"pop    %rdx\n\t"						\
 	FRAME_END
-	ASM_RET
-	".slowpath: "
-	"push   %rsi;"
-	"movzbl %al,%esi;"
-	"call " PV_UNLOCK_SLOWPATH ";"
-	"pop    %rsi;"
-	"pop    %rdx;"
-	FRAME_END
-	ASM_RET
-	".size " PV_UNLOCK ", .-" PV_UNLOCK ";"
-	".popsection");
+DEFINE_PARAVIRT_ASM(__raw_callee_save___pv_queued_spin_unlock, PV_UNLOCK_ASM,
+		    .spinlock.text);
 
 #else /* CONFIG_64BIT */
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d4e48b4a438b..856708cc78e7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -798,19 +798,12 @@ extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
  * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
  * restoring to/from the stack.
  */
-asm(
-".pushsection .text;"
-".global __raw_callee_save___kvm_vcpu_is_preempted;"
-".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
-"__raw_callee_save___kvm_vcpu_is_preempted:"
-ASM_ENDBR
-"movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
-"setne	%al;"
-ASM_RET
-".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
-".popsection");
-
+#define PV_VCPU_PREEMPTED_ASM						     \
+ "movq   __per_cpu_offset(,%rdi,8), %rax\n\t"				     \
+ "cmpb   $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax)\n\t" \
+ "setne  %al\n\t"
+DEFINE_PARAVIRT_ASM(__raw_callee_save___kvm_vcpu_is_preempted,
+		    PV_VCPU_PREEMPTED_ASM, .text);
 #endif
 
 static void __init kvm_guest_init(void)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 7ca2d46c08cc..6f306f885caf 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -37,27 +37,11 @@
  * nop stub, which must not clobber anything *including the stack* to
  * avoid confusing the entry prologues.
  */
-extern void _paravirt_nop(void);
-asm (".pushsection .entry.text, \"ax\"\n"
-     ".global _paravirt_nop\n"
-     "_paravirt_nop:\n\t"
-     ASM_ENDBR
-     ASM_RET
-     ".size _paravirt_nop, . - _paravirt_nop\n\t"
-     ".type _paravirt_nop, @function\n\t"
-     ".popsection");
+DEFINE_PARAVIRT_ASM(_paravirt_nop, "", .entry.text);
 
 /* stub always returning 0. */
-asm (".pushsection .entry.text, \"ax\"\n"
-     ".global paravirt_ret0\n"
-     "paravirt_ret0:\n\t"
-     ASM_ENDBR
-     "xor %" _ASM_AX ", %" _ASM_AX ";\n\t"
-     ASM_RET
-     ".size paravirt_ret0, . - paravirt_ret0\n\t"
-     ".type paravirt_ret0, @function\n\t"
-     ".popsection");
-
+#define PV_RET0_ASM	"xor %" _ASM_AX ", %" _ASM_AX "\n\t"
+DEFINE_PARAVIRT_ASM(paravirt_ret0, PV_RET0_ASM, .entry.text);
 
 void __init default_banner(void)
 {
-- 
2.35.3

