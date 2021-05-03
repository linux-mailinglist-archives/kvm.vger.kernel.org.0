Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A671637201D
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhECTGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 15:06:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48974 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECTGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 15:06:24 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620068730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLkve6HXLfgxpJAWW6er1tQK1qnNOtpub3goAX+TdbM=;
        b=r7T+1fS30pNUclSzvMNOId4Jc7ooI632oXoL+wBdH+efvKIyRgBV0QZHYfOBmZnYGuNGcV
        5U7ghgY6ShUSSX3nHIErQsr2UuP7dkwCXL55R4aXlU7ioqtUFsRpa89B63egHbiXRwP0IL
        sMdxQGpp5Xvp+a3O7/M81oE1aTtxmt520+GQS889a8UQhpEFALt5qWyM1/WlcTnEakkjc3
        3BfrS9syoDXogzgl0bBuzQPR8vlDeoWuIrzFrROO3rwKpGRz4JYIc10uCvO3a64e73KTt7
        EkAPlic1cFpwT5pV+b2xkced1EVqatU/4DpvaQlRBQbdRS03ncx6MAizauB9sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620068730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLkve6HXLfgxpJAWW6er1tQK1qnNOtpub3goAX+TdbM=;
        b=uD1KjZuTN8voYLmc+tVb3tu8d2nRizEfGUX5ZzhqdF060ShxUwNwzIyqHVUSEuiKrn0AO5
        2P8oP1s8gcjL/IAw==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Jian Cai <caij2003@gmail.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 1/4] x86/xen/entry: Rename xenpv_exc_nmi to noist_exc_nmi
In-Reply-To: <20210426230949.3561-2-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-2-jiangshanlai@gmail.com>
Date:   Mon, 03 May 2021 21:05:29 +0200
Message-ID: <87r1ind4ee.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> There is no any functionality change intended.  Just rename it and
> move it to arch/x86/kernel/nmi.c so that we can resue it later in
> next patch for early NMI and kvm.

'Reuse it later' is not really a proper explanation why this change it
necessary.

Also this can be simplified by using aliasing which keeps the name
spaces intact.

Thanks,

        tglx
---       

--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -135,6 +135,9 @@ static __always_inline void __##func(str
 #define DEFINE_IDTENTRY_RAW(func)					\
 __visible noinstr void func(struct pt_regs *regs)
 
+#define DEFINE_IDTENTRY_RAW_ALIAS(alias, func)				\
+__visible noinstr void func(struct pt_regs *regs) __alias(alias)
+
 /**
  * DECLARE_IDTENTRY_RAW_ERRORCODE - Declare functions for raw IDT entry points
  *				    Error code pushed by hardware
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -524,6 +524,8 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 		mds_user_clear_cpu_buffers();
 }
 
+DEFINE_IDTENTRY_RAW_ALIAS(exc_nmi, xenpv_exc_nmi);
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -565,12 +565,6 @@ static void xen_write_ldt_entry(struct d
 
 void noist_exc_debug(struct pt_regs *regs);
 
-DEFINE_IDTENTRY_RAW(xenpv_exc_nmi)
-{
-	/* On Xen PV, NMI doesn't use IST.  The C part is the same as native. */
-	exc_nmi(regs);
-}
-
 DEFINE_IDTENTRY_RAW_ERRORCODE(xenpv_exc_double_fault)
 {
 	/* On Xen PV, DF doesn't use IST.  The C part is the same as native. */
