Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562753C6578
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 23:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhGLVb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 17:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbhGLVbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 17:31:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57668C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:29:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z2so7052695plg.8
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BkrEyH8mx/bHbUobUw8cYQvGucPnsXvj9PS56zkSVhs=;
        b=i86YDTFrzCB8hKMQLuztVM4IusV7JV7AaSwYHZ+aEweXflP4cc43CdY27Su2zLewUQ
         +U6QNy+rkr4apla529EPqkEN+6fSW4CjZE2ATIBrHN+TYcGXy0oXtmvtyGywGViYO3s9
         8VHlNR4DghsQIqknI4wlrSquEuXpHr6Hu1tdVAnqOZv12yfM0Z7ItkOH+hd69AsCuyr6
         3bJ+BG9pVaiYgwBvvpeFoRZxmeMKeyMHw+Gy6Uf09I+yANMzw+mXxDObIcqbbqbxMHuu
         V6PXQiLcBuQrypfTuLNtaotbtfRrumV9nu8zLWCotFefk9W3p2r0ktYzpEDulg2kKJ63
         sFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BkrEyH8mx/bHbUobUw8cYQvGucPnsXvj9PS56zkSVhs=;
        b=i8h0Dc0p5coNnaV0o630CZNw5lQ1dVybkKGnrnY291JDht/VFaELlkZQAMnjOGe926
         0brEJhTeH0yMWZeiWimrqhK5UG659jExqeuB8ToM29tB4pDoYGx81juRscSB1mTzdmJa
         PmImmmWImUCGeul/XEKv5WOZHsSV2L/upfXzuxQvek/Xb515BRmrwWDdvkXPTtuAA5Y2
         44KaNbTCtjW0qo30DLwIQUE7dA+UMb1D0//woM7vok9H6Ox+LwzEKACBCh+GdBqgFATI
         fGa09cT/ruhUx1N4BkUiqYxSCDoD6QSL1hBUx3+39Ji+NovxjatrmqtEGEVj7BJ8PTL+
         qBaA==
X-Gm-Message-State: AOAM532Ozckfq87C3b+30gpAxtl15zcjwuzto3CXo3sxZh1owSe5EnbR
        ndqhOkxb9CJV694b1zwtBtjr1g==
X-Google-Smtp-Source: ABdhPJzM5mRK5WKvI7tk2x+HHSfWaCY9yOC0KVUP5/4gSTGmva0r7029DXc44BBlofnA+O9mlULWaA==
X-Received: by 2002:a17:902:8c81:b029:129:a9a8:67f9 with SMTP id t1-20020a1709028c81b0290129a9a867f9mr835809plo.79.1626125344703;
        Mon, 12 Jul 2021 14:29:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a6sm15660458pfn.1.2021.07.12.14.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 14:29:04 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:29:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org,
        sedat.dilek@gmail.com, syzkaller-bugs@googlegroups.com,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] general protection fault in try_grab_compound_head
Message-ID: <YOy0HAnhsXJ4W210@google.com>
References: <0000000000009e89e205c63dda94@google.com>
 <87fswpot3i.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fswpot3i.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021, Thomas Gleixner wrote:
> On Sat, Jul 03 2021 at 13:24, syzbot wrote:
> > syzbot has bisected this issue to:
> >
> > commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> > Author: Mark Rutland <mark.rutland@arm.com>
> > Date:   Mon Jan 11 15:37:07 2021 +0000
> >
> >     lockdep: report broken irq restoration
> 
> That's the commit which makes the underlying problem visible:
> 
>        raw_local_irq_restore() called with IRQs enabled
> 
> and is triggered by this call chain:
> 
>  kvm_wait arch/x86/kernel/kvm.c:860 [inline]
>  kvm_wait+0xc3/0xe0 arch/x86/kernel/kvm.c:837

And the bug in kvm_wait() was fixed by commit f4e61f0c9add ("x86/kvm: Fix broken
irq restoration in kvm_wait").  The bisection is bad, syzbot happened into the
kvm_wait() WARN and got distracted.  The original #GP looks stable, if someone
from mm land has bandwidth.
