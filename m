Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876BA4DC464
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 12:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiCQLFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 07:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiCQLFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 07:05:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAC214598F;
        Thu, 17 Mar 2022 04:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PCEn0p+ryj8IwmQoXfYYKrLO2DRtz//hRKf5O/r8Uro=; b=RllbrkU0Nfaj80jprERUL9GuFq
        Rf9okQ7eJ2ykDseCxxqUBkTcsuacbH7ypXgMqF4v4DxAyK1imY6b9jkqwjVz/72gzDUkXzaLrGK4w
        zGbdBuSkWSbiD86Z8wnue8dxgovdgLowHajymq9XRfynC6OV3vHj2Jojwk2CwM2IP9E8IazvFvoRw
        BKfkiM9kIRiH5lbJXnkveZdLQAk0yiBHBLHOGu0A+iFgU6Q5L26jWrI2qpvBpWyzNYv1/6Lq3jcyW
        Miu89Z/YNR6Q2XZZxemcspV/1rqIMkpTcPuUpIJRAwuxJTf0IrDyCAbUhwgG++mUiup1DWHamd3Fm
        y7iFgTnQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUnvM-006tiP-GG; Thu, 17 Mar 2022 11:04:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9EF9C3001EA;
        Thu, 17 Mar 2022 12:04:05 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 805862CA6FC9A; Thu, 17 Mar 2022 12:04:05 +0100 (CET)
Date:   Thu, 17 Mar 2022 12:04:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Message-ID: <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
References: <YjGzJwjrvxg5YZ0Z@audible.transient.net>
 <YjHYh3XRbHwrlLbR@zn.tnic>
 <YjIwRR5UsTd3W4Bj@audible.transient.net>
 <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic>
 <YjMS8eTOhXBOPFOe@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjMS8eTOhXBOPFOe@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 11:52:33AM +0100, Borislav Petkov wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> The commit in Fixes started adding INT3 after RETs as a mitigation
> against straight-line speculation.
> 
> The fastop SETcc implementation in kvm's insn emulator uses macro magic
> to generate all possible SETcc functions and to jump to them when
> emulating the respective instruction.
> 
> However, it hardcodes the size and alignment of those functions to 4: a
> three-byte SETcc insn and a single-byte RET. BUT, with SLS, there's an
> INT3 that gets slapped after the RET, which brings the whole scheme out
> of alignment:
> 
>   15:   0f 90 c0                seto   %al
>   18:   c3                      ret
>   19:   cc                      int3
>   1a:   0f 1f 00                nopl   (%rax)
>   1d:   0f 91 c0                setno  %al
>   20:   c3                      ret
>   21:   cc                      int3
>   22:   0f 1f 00                nopl   (%rax)
>   25:   0f 92 c0                setb   %al
>   28:   c3                      ret
>   29:   cc                      int3
> 
> and this explodes like this:
> 
>   int3: 0000 [#1] PREEMPT SMP PTI
>   CPU: 0 PID: 2435 Comm: qemu-system-x86 Not tainted 5.17.0-rc8-sls #1
>   Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
>   RIP: 0010:setc+0x5/0x8 [kvm]
>   Code: 00 00 0f 1f 00 0f b6 05 43 24 06 00 c3 cc 0f 1f 80 00 00 00 00 0f 90 c0 c3 cc 0f 1f 00 0f 91 c0 c3 cc 0f 1f 00 0f 92 c0 c3 cc <0f> 1f 00 0f 93 c0 c3 cc 0f 1f 00 0f 94 c0 c3 cc 0f 1f 00 0f 95 c0
>   Call Trace:
>    <TASK>
>    ? x86_emulate_insn [kvm]
>    ? x86_emulate_instruction [kvm]
>    ? vmx_handle_exit [kvm_intel]
>    ? kvm_arch_vcpu_ioctl_run [kvm]
>    ? kvm_vcpu_ioctl [kvm]
>    ? __x64_sys_ioctl
>    ? do_syscall_64+0x40/0xa0
>    ? entry_SYSCALL_64_after_hwframe+0x44/0xae
>    </TASK>
> 
> Raise the alignment value when SLS is enabled and use a macro for that
> instead of hard-coding naked numbers.
> 
> Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
> Reported-by: Jamie Heilman <jamie@audible.transient.net>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lore.kernel.org/r/YjGzJwjrvxg5YZ0Z@audible.transient.net

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Depending on what Paolo wants, it might make sense to merge this into
tip/x86/urgent such that we can then resolve the merge conflict vs
tip/x86/core with something like the below:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 113fd5c1b874..06dfbe9adcdb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -24,6 +24,7 @@
 #include <linux/stringify.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
+#include <asm/ibt.h>
 
 #include "x86.h"
 #include "tss.h"
@@ -431,7 +432,19 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
 /* Special case for SETcc - 1 instruction per cc */
 
-#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))
+/*
+ * Depending on .config the SETcc functions look like:
+ *
+ * setcc:
+ * +0	ENDBR		[CONFIG_X86_KERNEL_IBT]
+ * +4	SETcc	%al
+ * +7	RET
+ * +8	INT3		[CONFIG_SLS]
+ *
+ * Which gives possible sizes: 4, 5, 8, 9 which when rounded up to the
+ * next power-of-two alignment become: 4, 8, 16.
+ */
+#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)) * (1 + HAS_KERNEL_IBT))
 
 #define FOP_SETCC(op) \
 	".align " __stringify(SETCC_ALIGN) " \n\t" \
