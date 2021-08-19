Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA103F23D6
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 01:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhHSXtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 19:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbhHSXtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 19:49:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA8FC061764
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:48:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u15so4874675plg.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=peyh3WLA8DgwuaakoXbly04TuP2J4HXY0owEUug9y1c=;
        b=BbFJLtvxbxBG+7picsXObo5Qj8iquJ+C6Q7w5pe27YupZ7+zDXLN540+QU8HPzkPh2
         WwzvQTknLR7mJUL2ZtsslkF86UhNT3PUimzJd1W/xc0YsfWgxj0uNN/X65pRaldPuQy1
         Svz/l9I2+rXfrKEmbGry3ew82Uw0db0pKDxq9ukmqwtSMFXcHcAuMrcqlCqOeGH1V/uC
         AqRS5aTXg3eyxy84gMMrOJhW6Ac+BzpVGDyg6q+eRN+OlPt5iJkRzEHzotLklvgBWCCO
         ThS3AjXFs8AEz4pcXFmbRPSyBU/T0LhtGGlVC0DabZEeUTxAm2SIBNQHSE15qMVZvLr/
         ceIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=peyh3WLA8DgwuaakoXbly04TuP2J4HXY0owEUug9y1c=;
        b=aLdUQNVynzVEoljdheotBAu3jyMyqbfg55GmJlvfMdz/jU9i7RObW+2IPIVTo+tqS8
         fZ5HD6Eq6anae8USmGT0/e7lBfS/lywG5lvwKUmRohJyVxm2DZfjpJ+iMFB3wSQFASfa
         HiPPy8blg5I5I08ODp4ehXscx4DnQAD1Csk/fGSUZHboPkGu+H0Q+DA/IO+A/UuUmlQB
         ODG9TUYXfr9SaY8dBVYdey+REkClTP241pYzXlWg7qpaCVXWCcPpGkxIAAsS8j8BXgsZ
         NDq9Jt5eF1RV7KcEbMJkWG13UVIfBQztkxKcX5lFQ5JWJSBPzzl1ORAnaElz+fBdtdMN
         PblA==
X-Gm-Message-State: AOAM533qdR4kqFn1F+bZrXwG60jkWpiVNZtssxPes01xJDFQ8cGR1G+K
        BjlkZQ2VZ2jMrOdGaafdp4g3Hw==
X-Google-Smtp-Source: ABdhPJwX9PVK0tEzKb91C/ktX1nj3RcgHWNnmrdk1FjTlt3T+0IB78U5SgxuhlVnRMNmyLPH0lN5vw==
X-Received: by 2002:a17:90b:80c:: with SMTP id bk12mr1415764pjb.134.1629416916083;
        Thu, 19 Aug 2021 16:48:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a4sm4880315pfk.0.2021.08.19.16.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 16:48:35 -0700 (PDT)
Date:   Thu, 19 Aug 2021 23:48:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>, gor <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        paulmck <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-csky <linux-csky@vger.kernel.org>,
        linux-mips@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        Peter Foley <pefoley@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/5] KVM: rseq: Update rseq when processing NOTIFY_RESUME
 on xfer to KVM guest
Message-ID: <YR7tzZ98XC6OV2vu@google.com>
References: <20210818001210.4073390-1-seanjc@google.com>
 <20210818001210.4073390-2-seanjc@google.com>
 <1673583543.19718.1629409152244.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1673583543.19718.1629409152244.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Mathieu Desnoyers wrote:
> ----- On Aug 17, 2021, at 8:12 PM, Sean Christopherson seanjc@google.com wrote:
> > @@ -250,7 +250,7 @@ static int rseq_ip_fixup(struct pt_regs *regs)
> > 	 * If not nested over a rseq critical section, restart is useless.
> > 	 * Clear the rseq_cs pointer and return.
> > 	 */
> > -	if (!in_rseq_cs(ip, &rseq_cs))
> > +	if (!regs || !in_rseq_cs(ip, &rseq_cs))
> 
> I think clearing the thread's rseq_cs unconditionally here when regs is NULL
> is not the behavior we want when this is called from xfer_to_guest_mode_work.
> 
> If we have a scenario where userspace ends up calling this ioctl(KVM_RUN)
> from within a rseq c.s., we really want a CONFIG_DEBUG_RSEQ=y kernel to
> kill this application in the rseq_syscall handler when exiting back to usermode
> when the ioctl eventually returns.
> 
> However, clearing the thread's rseq_cs will prevent this from happening.
> 
> So I would favor an approach where we simply do:
> 
> if (!regs)
>      return 0;
> 
> Immediately at the beginning of rseq_ip_fixup, before getting the instruction
> pointer, so effectively skip all side-effects of the ip fixup code. Indeed, it
> is not relevant to do any fixup here, because it is nested in a ioctl system
> call.
> 
> Effectively, this would preserve the SIGSEGV behavior when this ioctl is
> erroneously called by user-space from a rseq critical section.

Ha, that's effectively what I implemented first, but I changed it because of the
comment in clear_rseq_cs() that says:

  The rseq_cs field is set to NULL on preemption or signal delivery ... as well
  as well as on top of code outside of the rseq assembly block.

Which makes it sound like something might rely on clearing rseq_cs?

Ah, or is it the case that rseq_cs is non-NULL if and only if userspace is in an
rseq critical section, and because syscalls in critical sections are illegal, by
definition clearing rseq_cs is a nop unless userspace is misbehaving.

If that's true, what about explicitly checking that at NOTIFY_RESUME?  Or is it
not worth the extra code to detect an error that will likely be caught anyways?

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 35f7bd0fced0..28b8342290b0 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -282,6 +282,13 @@ void __rseq_handle_notify_resume(struct ksignal *ksig, struct pt_regs *regs)

        if (unlikely(t->flags & PF_EXITING))
                return;
+       if (!regs) {
+#ifdef CONFIG_DEBUG_RSEQ
+               if (t->rseq && rseq_get_rseq_cs(t, &rseq_cs))
+                       goto error;
+#endif
+               return;
+       }
        ret = rseq_ip_fixup(regs);
        if (unlikely(ret < 0))
                goto error;

> Thanks for looking into this !
> 
> Mathieu
> 
> > 		return clear_rseq_cs(t);
> > 	ret = rseq_need_restart(t, rseq_cs.flags);
> > 	if (ret <= 0)
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
