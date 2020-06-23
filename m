Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0149020552C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732862AbgFWOyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732840AbgFWOyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 10:54:16 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A65BC061573;
        Tue, 23 Jun 2020 07:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HULhaI+b5XJqnnihDW5C9Ggk4Cp4Adw7G89+l/htg0I=; b=jJTrms2hoV5Nzz7Wo9AaUII+sw
        2zCeUAXIjhAFqBTeIVysOW8tr+I1cq0WsZ3lg+qYSSCEttqsd40hQ44w4Jb0/b7p9n9EuwLHZUGw9
        VXaPwrIBRTP+ncvgGvke5TZe4297oUsZ6v+pOOO0Xdli7QEUP7NUDDaFIcHbpe3aKKy5VHZ8q8BGB
        gjco2dlW4zQJgFht29uUVdhszPfFQ+nZNew7IQU3vHNhE7hdYxDmswTkGkty6GKA9PgvhWRJu1nlE
        Ct0a2jSe9Ylu4gQVerv+8fbLzvGxE1U8jGZw4hbOwzvQb+kF/q2QDj1OLouPmZ3NaFf7RCMZ16/DE
        iC6FndYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnkIz-00066t-Uk; Tue, 23 Jun 2020 14:53:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 836FC30477A;
        Tue, 23 Jun 2020 16:53:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7108C23CD6142; Tue, 23 Jun 2020 16:53:44 +0200 (CEST)
Date:   Tue, 23 Jun 2020 16:53:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623145344.GA117543@hirez.programming.kicks-ass.net>
References: <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623135916.GI4817@hirez.programming.kicks-ass.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 03:59:16PM +0200, Peter Zijlstra wrote:

> So basically when your exception frame points to your own IST, you die.
> That sounds like something we should have in generic IST code.

Something like this... #DF already dies and NMI is 'magic'

---
 arch/x86/entry/common.c         |  7 +++++++
 arch/x86/include/asm/idtentry.h | 12 +++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index af0d57ed5e69..e38e4f34c90c 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -742,6 +742,13 @@ noinstr void idtentry_exit_nmi(struct pt_regs *regs, bool restore)
 	__nmi_exit();
 }
 
+noinstr void idtentry_validate_ist(struct pt_regs *regs)
+{
+	if ((regs->sp & ~(EXCEPTION_STKSZ-1)) ==
+	    (_RET_IP_ & ~(EXCEPTION_STKSZ-1)))
+		die("IST stack recursion", regs, 0);
+}
+
 #ifdef CONFIG_XEN_PV
 #ifndef CONFIG_PREEMPTION
 /*
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 4e399f120ff8..974c1a4eacbb 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -19,6 +19,8 @@ void idtentry_exit_cond_rcu(struct pt_regs *regs, bool rcu_exit);
 bool idtentry_enter_nmi(struct pt_regs *regs);
 void idtentry_exit_nmi(struct pt_regs *regs, bool irq_state);
 
+void idtentry_validate_ist(struct pt_regs *regs);
+
 /**
  * DECLARE_IDTENTRY - Declare functions for simple IDT entry points
  *		      No error code pushed by hardware
@@ -322,7 +324,15 @@ static __always_inline void __##func(struct pt_regs *regs)
  * Maps to DEFINE_IDTENTRY_RAW
  */
 #define DEFINE_IDTENTRY_IST(func)					\
-	DEFINE_IDTENTRY_RAW(func)
+static __always_inline void __##func(struct pt_regs *regs);		\
+									\
+__visible noinstr void func(struct pt_regs *regs)			\
+{									\
+	idtentry_validate_ist(regs);					\
+	__##func(regs);							\
+}									\
+									\
+static __always_inline void __##func(struct pt_regs *regs)
 
 /**
  * DEFINE_IDTENTRY_NOIST - Emit code for NOIST entry points which
