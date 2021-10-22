Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47454370AC
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 06:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhJVEOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 00:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhJVEOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 00:14:24 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2214C061764;
        Thu, 21 Oct 2021 21:12:07 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z69so3679884iof.9;
        Thu, 21 Oct 2021 21:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2RAf+30VthxJNIntOmbsMzoSO67ZM+hopN1JOMueg6M=;
        b=dg7AN74qs0MPTlN5NHxAgdYGSOPz9HPMqSd0/zLMqy5xUkkCPzNsEYMzq5K4XLiHkn
         5PjBbP+3m+xLktvkqvXbX554XO/nDY+ue6z89QuuSElqQKtML+Sj4l344LNHmrZjrCfY
         Xq9I3v2rxsDuRo0VOcjt6gBD9QN/aKs+pJ1lKJKgGcWnOwTmtiKXtFRSkzGDPpfj7+zk
         C/oJwVHJkvzatohrAasGbVm7jDUxLSqPjdOn6wkC/NHl28fBrhc9pZ0tQLuWhEc9RE94
         X8/tbmrPJfBf1Twq5srCOo6CAXxwUgeT+4XXmRyKnSASO03yRp1eb1FjIoUmCX4uw21E
         ezow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RAf+30VthxJNIntOmbsMzoSO67ZM+hopN1JOMueg6M=;
        b=MpoX2rUfeu0k0cIlPehphkfO/ejEdXY5ffLkoscMSd6kD5sA9ptWSBfL3p8hRVcIT3
         CywlYR24jAQTL4ti6AfIZ+QBRg/RA+ESArwsT92SA/8hMznEfJ/SKLqeVdBbuiTDVdIx
         W0PgDb1AhqpAmJbMFVr0jKx30PwA+k00EjUZ7CIyuLYgZ4oewVfdtPQD2IPivA7qpfTN
         c2ZBp7H76P3pRPgxhXAtQHVD0r6lYr0kKH/fMEwQ78QlVhbtCJWzBRtVG9jN7XbMxaFQ
         HgFA5GEd64Ct6Be1OAfLzmlqq9nDM1V8Dgnk5VxEs3yEBJfATmJ5bk5hcsoNvJH1wg4m
         d6tg==
X-Gm-Message-State: AOAM530nu+FFuw9nevF8+Vs90twHfaxuUer+myXM2pGehPf9i3gtCvoL
        hEIXOGBk1HIPderdIDKqv7a1TGvGMg/cs1TlOwzihHfK1dI=
X-Google-Smtp-Source: ABdhPJwXZN4khyfEwIB2rxXvkrkQnqHr01W0P0smKSy8HucMcMP/weDc0SqY+O2oa3+cHZI4R327tLVfZrOmBZ/y6Nc=
X-Received: by 2002:a05:6602:1594:: with SMTP id e20mr7314773iow.14.1634875927330;
 Thu, 21 Oct 2021 21:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211020110638.797389-1-pbonzini@redhat.com> <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
 <659fbd82-7d18-0e76-6fe4-b311897b4ae0@redhat.com>
In-Reply-To: <659fbd82-7d18-0e76-6fe4-b311897b4ae0@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 22 Oct 2021 12:11:55 +0800
Message-ID: <CAJhGHyALnn2EmPDXS3hyt1sgTH8vu=yeLo+N5meg7PZg7WrFQw@mail.gmail.com>
Subject: Re: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is needed
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 7:39 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/10/21 13:17, Peter Zijlstra wrote:
> > AFAICT, rcu_read_lock() for PREEMPT_RCU is:
> >
> >    WRITE_ONCE(current->rcu_read_lock_nesting, READ_ONCE(current->rcu_read_lock_nesting) + 1);
> >    barrier();
>
> rcu_read_unlock() is the expensive one if you need to go down
> rcu_read_unlock_special().
>

If "actual likelihood of a wakeup is very low." as stated in the changelog,
the likelihood of rcu_read_unlock_special() is also very low.

rcu_read_lock() for PREEMPT_RCU is a function call, is it relevant?

(It is possible to remove the function call if the include-hell can
be resolved or remove the function call via LTO or just remove the
function call in X86 via percpu.)

Thanks
Lai

> Paolo
>
> > Paul?
>
