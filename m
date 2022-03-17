Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A44DC2FF
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 10:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiCQJjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 05:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiCQJjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 05:39:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58F141D92;
        Thu, 17 Mar 2022 02:38:06 -0700 (PDT)
Received: from zn.tnic (p200300ea971561b0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61b0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D1F581EC03AD;
        Thu, 17 Mar 2022 10:38:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647509880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Y0yRE4GP/95cPt86v2RYG2q4fNKPJLp7ExzsBY7nICc=;
        b=WdL2QEZ6jXNUe26UHu/Ldn4OsaxPJ58JovqWsilCRZzGVFLMv6ttpJPi4b8bS+uv2bWAE6
        2Y6WlCmLOp8XtyDZ+lzXm+KABH+L/+NgRc5YApCglzn/t+oce/Nw+i2xWWvVLGgya/yWNz
        veu9AtkEKyRQK5ag7FO77q8uhCbumkE=
Date:   Thu, 17 Mar 2022 10:37:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [PATCH -v1.1] kvm/emulate: Fix SETcc emulation function offsets with
 SLS
Message-ID: <YjMBdMlhVMGLG5ws@zn.tnic>
References: <YjGzJwjrvxg5YZ0Z@audible.transient.net>
 <YjHYh3XRbHwrlLbR@zn.tnic>
 <YjIwRR5UsTd3W4Bj@audible.transient.net>
 <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220316220201.GM8939@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 11:02:01PM +0100, Peter Zijlstra wrote:
> I'd suggest writing that like:
> 
> 	#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
> 
> That way people can enjoy smaller text when they don't do the whole SLS
> thing.... Also, it appears to me I added an ENDBR to this in
> tip/x86/core, well, that needs fixing too. Tomorrow tho.

Done.

Jamie, I'd appreciate testing this one too, pls, just in case.

Thx.

---
From: Borislav Petkov <bp@suse.de>

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
  Code: 00 00 0f 1f 00 0f b6 05 43 24 06 00 c3 cc 0f 1f 80 00 00 00 00 0f 90 c0 c3 cc 0f 1f 00 0f 91 c0 c3 cc 0f 1f 00 0f 92 c0 c3 cc <0f> 1f 00 0f 93 c0 c3 cc 0f 1f 00 0f 94 c0 c3 cc 0f 1f 00 0f 95 c0
  Call Trace:
   <TASK>
   ? x86_emulate_insn [kvm]
   ? x86_emulate_instruction [kvm]
   ? vmx_handle_exit [kvm_intel]
   ? kvm_arch_vcpu_ioctl_run [kvm]
   ? kvm_vcpu_ioctl [kvm]
   ? __x64_sys_ioctl
   ? do_syscall_64+0x40/0xa0
   ? entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Raise the alignment value when SLS is enabled and use a macro for that
instead of hard-coding naked numbers.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/YjGzJwjrvxg5YZ0Z@audible.transient.net
---
 arch/x86/kvm/emulate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f667bd8df533..01c0a02f4004 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -430,8 +430,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
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
 	ASM_ENDBR \
@@ -1049,7 +1052,7 @@ static int em_bsr_c(struct x86_emulate_ctxt *ctxt)
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
