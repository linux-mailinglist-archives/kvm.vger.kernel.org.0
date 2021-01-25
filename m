Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697DC30343C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbhAZFUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbhAYQyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 11:54:50 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB402C061786
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 08:54:10 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i7so9296916pgc.8
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 08:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=98KsfeJcSNeAq7D2e2LH4xgYP6akBDNIEzkaVdZ+rkw=;
        b=Oo5uK1YsHdQRSpOXYXzGBJe7lmxs/p9bDTq7nTmzYXI9uNvfHic+t5VRutNPjN++q2
         U8ZR3mhcRILkM0mwPhAulKTYGYWvlGwFLc3F+xJ21Mv17yZpr//tLixrwZatM+SytvDq
         dPaXSFXeju/kawr/26rmzasqgx8/8szaIVHwTE0qe6T+yoowpSbYBgTqN7zucSkz/AJG
         U5wCXO8ejI5WlYZKAm6QvX59xg8yvcmLF+BYG5XgdmJC6bVZ2+vgoNdB+fTesFsR+h/i
         TiFEPgH/fzLAennBnxoFTvJmRIm/4zMCRn35kfGkLa4l/EKeqtg80piU6RAQIE+1Cbhp
         Fxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=98KsfeJcSNeAq7D2e2LH4xgYP6akBDNIEzkaVdZ+rkw=;
        b=NssM1+9kNh92HLpRoACRMBp4vxKC+jnEUXeEjgCAkjoDGdo6X880q+CT3uypu9I6cM
         nPoGJ3nHzCWXU3/Nm0flcQq5j8SC1XBlTalpKwf5dIG1ZtJVEjEG6PDpfSruKN74Bn9/
         8i53PCJrR3cmSQED7TzypZ2pT18wqp+3I5CWLqpgbn76hjj3nVyx/yDMhn828pMxFgrd
         3OJozk0Tmjhzt8TMS01jRa+8j/iaLpiZPl+fCAPhF2njRZznQQRrKtWE+kA0EC2RAiUL
         toTW0MT3N8AUNo/bdCar/qooMeijLKtuG9BF6zsV8uaEfmBzwS+d878bIBHVMJkK6p5o
         fLqg==
X-Gm-Message-State: AOAM532nK4zgsAoviK+IcNsngjISi4nVP5GDxwKDwrtmSAiepj0QnvIA
        r+kQ0jTWXUmzZNefZScxK+Bw9Q==
X-Google-Smtp-Source: ABdhPJww3ALlC+Iz60JCj51ZcFCuikckWRJvHg478hZXeCENQgqzuZS7QTUpTXKDAJCTuOpGwe1/XQ==
X-Received: by 2002:a63:ef14:: with SMTP id u20mr1438952pgh.93.1611593650110;
        Mon, 25 Jan 2021 08:54:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 130sm17428435pfb.92.2021.01.25.08.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:54:09 -0800 (PST)
Date:   Mon, 25 Jan 2021 08:54:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86/mmu: improve robustness of some functions
Message-ID: <YA73qq1tTLxTEGKV@google.com>
References: <1611314323-2770-1-git-send-email-stephenzhangzsd@gmail.com>
 <87a6sx4a0l.fsf@vitty.brq.redhat.com>
 <99258705-ff9e-aa0c-ba58-da87df760655@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99258705-ff9e-aa0c-ba58-da87df760655@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Paolo Bonzini wrote:
> On 25/01/21 10:54, Vitaly Kuznetsov wrote:
> > 
> > What if we do something like (completely untested):
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index bfc6389edc28..5ec15e4160b1 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -12,7 +12,7 @@
> >  extern bool dbg;
> >  #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> > -#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> > +#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
> >  #define MMU_WARN_ON(x) WARN_ON(x)
> >  #else
> >  #define pgprintk(x...) do { } while (0)
> > 
> > and eliminate the need to pass '__func__,' explicitly? We can probably
> > do the same to pgprintk().
> 
> Nice indeed.  Though I wonder if anybody has ever used these.

I've used the ones in pte_list_add() and __pte_list_remove().  I had to add more
info to track down the bug I introduced, but their initial existence was helpful.

That being said, I definitely did not build with MMU_DEBUG defined, I simply
changed a handful of rmap_printks to pr_warn.  Blindly enabling MMU_DEBUG
activates far too much output to be useful.  That may not have been the case
when the core parts of the MMU were under heavy development, but it does feel
like the time has come to excise the bulk of the pgprintk and rmap_printk hooks.
Ditto for mmu_audit.c.

> For those that I actually needed in the past I created tracepoints instead.

Ya.  There are times where I prefer using the kernel log over tracepoints, but
it's easy enough to copy-paste the tracepoint into a pr_* when desired.

I'd be ok with converting a few select rmap_printks to tracepoints, but I vote
to completely remove the bulk of the existing code.  Tracepoints always make me
a bit wary, it's easy to forget/overlook that the inputs to the tracepoint are
still generated even if the tracepoint itself is disabled.  E.g. being too
liberal with tracepoints could theoretically degrade performance.

If we do yank them, I think it makes sense to git rid of mmu_audit.c in the same
commit.  In theory, that would make it easier for someone to restore the hooks
if they need the hooks to debug something in the future.
