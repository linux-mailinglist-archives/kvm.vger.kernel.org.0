Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D08F475F9D
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 18:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbhLORpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 12:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbhLORpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 12:45:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA136C061574;
        Wed, 15 Dec 2021 09:45:42 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so21092777pja.1;
        Wed, 15 Dec 2021 09:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLdWdHoT6O3wLXgWsRx2m2m62hSjV0BcJXlTjn5JUFY=;
        b=fVGVY8wqrxR8Y9FDXFtr4SE6iyR8BVVbZ5vgJ4y8dkqTnryOyAM1f7oIOnezuj4A6J
         xZUPr4yWMlNLYsHQ1fallxSJg8aU00+SwAnq0ijeJb6rpCasKd3VYye0HMu7Rz4Fmzli
         VTY7ooY+g0kHA+TAUoyyLgzX0mSn9ha1KmFllLdg51BzQBC+Mgmo9+XdPBjphX6Y4e34
         aHA3UHFWRC7Btex9u1tZiEFoYFee/G/WGm4rYd3nNUPqV0MpixQGc6Vx0PruHv6wejmQ
         Ow0n2j4fyu9ba9vCZKTh9cTJvx1bERx0Yn7rh5DuRA2QxMZuAeUzJXU06wIQ9Mevfcss
         WI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLdWdHoT6O3wLXgWsRx2m2m62hSjV0BcJXlTjn5JUFY=;
        b=sXa4PcQUXBKlR2VROcfOlrvxsOIi4XVb+mljr5YNYnVds/2Me+M5DI44i8rGe9Rcnk
         UY8yugizTuUUUgzZfMVuh3URcNtM660AB1Gkd67ZcxQTgY24kDF9abv/x9fBJqAeEReX
         7Zhgo7ET0YVC0GzDKs17CDVjYYvF160fhZSSG+SILcsHJRVm1vPoqWcO6rSfwCUaY+lV
         PlbbsWM06gUdehVGBC4896CjSbgZKstoR0VClDQoo6UyaLnWd9E9cshdwORHG/jN/RdJ
         xaV+ctip9qT+NOtVFAFVnv0azE6qDGv3C/xyePJvckwSI/ZKrDcygb4xLSWyNvJ6P6b4
         7aPQ==
X-Gm-Message-State: AOAM531bZh5ia5V0qOR9CYeeK4bH6cqyS2+9ClJCKIRMj41tZ4/JaYmR
        GzI4SXUAq703SpgzI+2TkhJHRYocxravu9zYHsQ=
X-Google-Smtp-Source: ABdhPJxIcVzS1V95pBlMUcYP2k7Lrcyzl/rBNhnf3pbvrkTovj6aQvXpyQPCUffP2FcbLTl6T7AIgJQIhLFRrE2qAuQ=
X-Received: by 2002:a17:90a:4a06:: with SMTP id e6mr968675pjh.228.1639590342342;
 Wed, 15 Dec 2021 09:45:42 -0800 (PST)
MIME-Version: 1.0
References: <20211128035704.270739-1-yury.norov@gmail.com> <20211128035704.270739-3-yury.norov@gmail.com>
 <YaPGDOvBzhiRFcOP@qmqm.qmqm.pl> <CAAH8bW9-dbENFUrwPUQ-uJVVX_s=PWb2zpAJ8BqkV3vJE696mA@mail.gmail.com>
 <0ccb827de1164b2989d652bfb6f1bbab@AcuMS.aculab.com>
In-Reply-To: <0ccb827de1164b2989d652bfb6f1bbab@AcuMS.aculab.com>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Wed, 15 Dec 2021 09:45:30 -0800
Message-ID: <CAAH8bW-u5AsFTXUOJPRkF-6dk1LcL7PE0Tm+dUc9Ctb6JMy=tg@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/bitmap: implement bitmap_{empty,full} with bitmap_weight_eq()
To:     David Laight <David.Laight@aculab.com>
Cc:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021 at 12:41 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Yury Norov
> > Sent: 14 December 2021 19:43
> ...
> >
> > I think that for long bitmaps the most time consuming operation is moving
> > data to L1, and for short bitmaps the difference between approaches is
> > barely measurable.
> >
> > But hweght_long on each iteration can't be more effective than the current
> > version. So, I'll drop this patch for v2 and keep things unchanged.
>
> Actually do bitmap_full/empty() calls make any sense at all?
> The result is stale since bitmaps are designed to do locked operations.
> If you have a lock covering the bitmap then you should be using
> something that uses non-locked accesses.
> Rightly or wrongly that isn't the bitmap api.

Are you talking about __{set,clear}_bit()?
include/asm-generic/bitops/non-atomic.h
