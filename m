Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C114DE836
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbiCSNvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCSNvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:51:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA2C4092B;
        Sat, 19 Mar 2022 06:50:18 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 509C21EC050D;
        Sat, 19 Mar 2022 14:50:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647697812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jJlfJmykQWJPhBfYoqtgY8oKqPHmS75DxWWyYkiPKaI=;
        b=Zq+cltFjP7JTBzAHcxmTf3R1EKDOifjc3LUyYpXLC8lMo5OTaxE06WsNcqwmAicVwtVpHs
        4KrxUvGzArKDabksCyc3t8lCVuaKnMOfiy0LMbLpckm7fA+T9mcfU/0V5JI3r1K4Fg1OED
        CBpFXZ0NLY/mKMNbIWD/owF/SE9Tih8=
Date:   Sat, 19 Mar 2022 14:50:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Message-ID: <YjXfgsSZpVVdg0lv@zn.tnic>
References: <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic>
 <YjMS8eTOhXBOPFOe@zn.tnic>
 <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
 <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com>
 <YjXcRsR2T8WGnVjl@zn.tnic>
 <ad13632c-127d-ff5a-6530-5282e58521b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad13632c-127d-ff5a-6530-5282e58521b1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 19, 2022 at 02:41:20PM +0100, Paolo Bonzini wrote:
> Nah, don't worry.  I'll take care of it, I'm still not 100% on top of things
> but I can handle one patch. :)

Well, if you take it, then you'll have to give us an immutable branch,
please, to merge it into x86/core so that peterz can do his IBT fix
ontop before he sends the stuff during the merge window.

In any case, here's the final version (did some commit message fixups +
added tags).

Thx.

---
From: Borislav Petkov <bp@suse.de>
Date: Wed, 16 Mar 2022 22:05:52 +0100
Subject: [PATCH] kvm/emulate: Fix SETcc emulation function offsets with SLS

The commit in Fixes started adding INT3 after RETs as a mitigation
against straight-line speculation.

The fastop SETcc implementation in kvm's insn emulator uses macro magic
to generate all possible SETcc functions and to jump to them when
emulating the respective instruction.

However, it hardcodes the size and alignment of those functions to 4: a
three-byte SETcc insn and a single-byte RET. BUT, with SLS, there's an
INT3 that gets slapped after the RET, which brings the whole scheme out
of alignment:

  15:   0f 90 c0                seto   %al
  18:   c3                      ret
  19:   cc                      int3
  1a:   0f 1f 00                nopl   (%rax)
  1d:   0f 91 c0                setno  %al
  20:   c3                      ret
  21:   cc                      int3
  22:   0f 1f 00                nopl   (%rax)
  25:   0f 92 c0                setb   %al
  28:   c3                      ret
  29:   cc                      int3

and this explodes like this:

  int3: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 2435 Comm: qemu-system-x86 Not tainted 5.17.0-rc8-sls #1
  Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
  RIP: 0010:setc+0x5/0x8 [kvm]
  Code: 00 00 0f 1f 00 0f b6 05 43 24 06 00 c3 cc 0f 1f 80 00 00 00 00 0f 90 c0 c3 cc 0f \
	  1f 00 0f 91 c0 c3 cc 0f 1f 00 0f 92 c0 c3 cc <0f> 1f 00 0f 93 c0 c3 cc 0f 1f 00 \
	  0f 94 c0 c3 cc 0f 1f 00 0f 95 c0
  Call Trace:
   <TASK>
   ? x86_emulate_insn [kvm]
   ? x86_emulate_instruction [kvm]
   ? vmx_handle_exit [kvm_intel]
   ? kvm_arch_vcpu_ioctl_run [kvm]
   ? kvm_vcpu_ioctl [kvm]
   ? __x64_sys_ioctl
   ? do_syscall_64
   ? entry_SYSCALL_64_after_hwframe
   </TASK>

Raise the alignment value when SLS is enabled and use a macro for that
instead of hard-coding naked numbers.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jamie Heilman <jamie@audible.transient.net>
Link: https://lore.kernel.org/r/YjGzJwjrvxg5YZ0Z@audible.transient.net
---
 arch/x86/kvm/emulate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5719d8cfdbd9..f321abb9a4a8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -429,8 +429,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	FOP_END
 
 /* Special case for SETcc - 1 instruction per cc */
+
+#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
+
 #define FOP_SETCC(op) \
-	".align 4 \n\t" \
+	".align " __stringify(SETCC_ALIGN) " \n\t" \
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
@@ -1047,7 +1050,7 @@ static int em_bsr_c(struct x86_emulate_ctxt *ctxt)
 static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
 {
 	u8 rc;
-	void (*fop)(void) = (void *)em_setcc + 4 * (condition & 0xf);
+	void (*fop)(void) = (void *)em_setcc + SETCC_ALIGN * (condition & 0xf);
 
 	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
 	asm("push %[flags]; popf; " CALL_NOSPEC
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
