Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8DB479E27
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 00:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhLRX2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 18:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhLRX2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 18:28:39 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B204BC061574;
        Sat, 18 Dec 2021 15:28:39 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id d11so5761429pgl.1;
        Sat, 18 Dec 2021 15:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pIYxkiGisug+VVJYFtmCG20TylNRXB8zO8kw91s3wyc=;
        b=TIuyQXz6oo8PN+yMbImlC2c2rmmoCdLu5CdlQlReccXapNNMDZyLSkZvnzlgZ9AIdV
         6+qzntuQo5gBX86FaZFlCIaH4FCNC7RUVw367F08QPEjoiFWXa2CV6SAzISHS5RZPpY/
         QbkHqa0fdrihFEuRX0X/GeMy6P75DvnBsKWfABXcb5D5/2zTgkKaV4VEiJSuyy+zBwcd
         zNIVzererH+Fx7ZEOWvTBpmd3THvXh1KHtzsLHvjMiIPuGFGIqMdZbyjf9H7vLYP6+7J
         cQ/P2vAafsI3DEFtzgX9UWRj1ZmCeXy01hG6ih9PN1N9Tz70SEQsg8aJQpCrrbXl1cqP
         QppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pIYxkiGisug+VVJYFtmCG20TylNRXB8zO8kw91s3wyc=;
        b=55CrRinAexYQVLLCAVeuG8I9J21GY3IqcaFC2wR8Ap2MiD9sYKYzust2I4EPxGXnlS
         Pe0dCuc92IRHO1MDoXneWrcsOs3n++GqV+AbWUpP/Vou5TnzYWC1vO6s+RSD0/fctkrP
         PInFYv0lzakRglwYu8kqv8ie8FPD29R5DblmhYAINOWuiKTZW7+80IQ9deoTuWfCqWnT
         HqmOjOvMV9tFtMFrpfSWt3ekPZ74xg1blyPjdcw0tv2jvgo63uA3Es616/CIhgUtYerz
         hBTc4KAVndNYIcaoApCeR6jtlsw4/OwO6twxIBYK2tBHgdyBIgrVer5Lcw5EuOJh5eFk
         4Vow==
X-Gm-Message-State: AOAM531ln7opi6qLxgmfcxBohJ4InyB6hBVL0qNWaopTWH3Rac2lqjtR
        Pm1Msu47bv19vvsytkJ3BktocnLs6bznKqaEF9A=
X-Google-Smtp-Source: ABdhPJxWDXMTWC77oOKCjFiIpES/JejUzoFwUACXrmSW9T47MOn3N7k2dUXoB6NpZZlsfwgvBd+k97C3LkDR7q0l13Y=
X-Received: by 2002:a63:2a0d:: with SMTP id q13mr8815341pgq.513.1639870119035;
 Sat, 18 Dec 2021 15:28:39 -0800 (PST)
MIME-Version: 1.0
References: <20211218212014.1315894-1-yury.norov@gmail.com>
 <20211218212014.1315894-2-yury.norov@gmail.com> <Yb5dmqlYd3owtH29@qmqm.qmqm.pl>
In-Reply-To: <Yb5dmqlYd3owtH29@qmqm.qmqm.pl>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Sat, 18 Dec 2021 15:28:29 -0800
Message-ID: <CAAH8bW9uWW+t5TvkMt_e-sKp71hiLpXhXeuGuSZPK-3kds-GgQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] all: don't use bitmap_weight() where possible
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     linux-kernel@vger.kernel.org,
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
        David Laight <David.Laight@aculab.com>,
        Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
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
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 18, 2021 at 2:16 PM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.=
qmqm.pl> wrote:
>
> On Sat, Dec 18, 2021 at 01:19:57PM -0800, Yury Norov wrote:
> > Don't call bitmap_weight() if the following code can get by
> > without it.
> >
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > ---
> >  drivers/net/dsa/b53/b53_common.c           | 6 +-----
> >  drivers/net/ethernet/broadcom/bcmsysport.c | 6 +-----
> >  drivers/thermal/intel/intel_powerclamp.c   | 9 +++------
> >  3 files changed, 5 insertions(+), 16 deletions(-)
> [...]
>
> Looks good,

Does it mean Acked-by, Reviewed-by, or something else?

> but I think this needs to be split per subsystem.

What you ask breaks rules:

Documentation/process/submitting-patches.rst:

Separate each **logical change** into a separate patch.

For example, if your changes include both bug fixes and performance
enhancements for a single driver, separate those changes into two
or more patches.  If your changes include an API update, and a new
driver which uses that new API, separate those into two patches.

On the other hand, if you make a single change to numerous files,
group those changes into a single patch.  Thus a single logical change
is contained within a single patch.

This is not a dead rule, refer for example the 96d4f267e40f9 ("Remove
'type' argument from access_ok() functioin.")

Or this: https://lkml.org/lkml/2021/6/14/1736

Thanks,
Yury
