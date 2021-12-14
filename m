Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98246474C2D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 20:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhLNTnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 14:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhLNTnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 14:43:21 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BF7C061574;
        Tue, 14 Dec 2021 11:43:21 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so18701459pfe.7;
        Tue, 14 Dec 2021 11:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LCilH12wWw0seUa3hiJyDy0VxFX2Q3bA7Y0HXIYHhF8=;
        b=mgUrMQhC4/CUdwucboxOLaDGWbb/3r/d8db3O9NgfZYUYEd6Zjz2nbba51SL7zLe8Y
         HoPx+IQ/X0fM2kJmgKk06iLEcvvTYlX2h8Als5lC5pEfulogO+sUqemRF4n6m2Eekf4w
         CtPoyJGaZ6slsRjff5y3xVucnMlyQBZjuB7TsLW/QfR5HbmU2eCSX+iDyn3uJA04puJa
         dF//PJEuj31ulpS82MggltzR4G2RUQnzjtNrp/7HOGpfHVW7cNQpoT3ypqVvpPJEUhsf
         QvGgSrM2kq5yWe5ythTOhC41utztrjpAcYlGjjw1vz9wzYdQhMtOLwSCYyXNwoJoZq7H
         sX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LCilH12wWw0seUa3hiJyDy0VxFX2Q3bA7Y0HXIYHhF8=;
        b=ISs8iGmjulzRcyw/4adfQiamM2bLA3tYj4Sg2mBjKQfJej36Y8qqgtux5H2PY1v+h5
         /LTKC/x9hDeUysiJ1hI9CwdEF9uJoPfLHiQnAriD/yRXKjjBixvEEd5fqtHuoDXraxPd
         leDnrLOZgN75PBWfam6fVjHqDTYwkYybl8zAcm/Kj/nO02nDNMNJ/kyzsr2v1BibIjMI
         SUTALArnDPKadExaDnJrTf6SRRU9n2LE5rwq4E9+Fh9Tm84OtQnCOvU5fzgD6q2eCqQq
         So/LzfxiodAcCTt1rhEOdFkVDE3gscDycnEwAIWqb/fh5vC3EM7ECm0PhWbeTkrcsu2i
         BoLg==
X-Gm-Message-State: AOAM532CzldWSv+XJh+tm5YtzmT/yF/Nl3fs/q48+iMrYW7JfW/ImKjY
        KgRufOPIjMuu4TWK67tTW+TOOaTRRHn+VNa/Nu0=
X-Google-Smtp-Source: ABdhPJx1omsyXEH84uuE4kzYpPBu5v24anF9kQ0616INOFdPlqou2FDes2afxUGAuG2JNukP2+Sny94qEgWXdVVJ7J8=
X-Received: by 2002:a63:3f4e:: with SMTP id m75mr4955451pga.587.1639511000707;
 Tue, 14 Dec 2021 11:43:20 -0800 (PST)
MIME-Version: 1.0
References: <20211128035704.270739-1-yury.norov@gmail.com> <20211128035704.270739-3-yury.norov@gmail.com>
 <YaPGDOvBzhiRFcOP@qmqm.qmqm.pl>
In-Reply-To: <YaPGDOvBzhiRFcOP@qmqm.qmqm.pl>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Tue, 14 Dec 2021 11:43:09 -0800
Message-ID: <CAAH8bW9-dbENFUrwPUQ-uJVVX_s=PWb2zpAJ8BqkV3vJE696mA@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/bitmap: implement bitmap_{empty,full} with bitmap_weight_eq()
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

On Sun, Nov 28, 2021 at 10:10 AM Micha=C5=82 Miros=C5=82aw
<mirq-linux@rere.qmqm.pl> wrote:
>
> On Sat, Nov 27, 2021 at 07:56:57PM -0800, Yury Norov wrote:
> > Now as we have bitmap_weight_eq(), switch bitmap_full() and
> > bitmap_empty() to using it.
> >
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > ---
> >  include/linux/bitmap.h | 26 ++++++++++----------------
> >  1 file changed, 10 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> > index 996041f771c8..2d951e4dc814 100644
> > --- a/include/linux/bitmap.h
> > +++ b/include/linux/bitmap.h
> > @@ -386,22 +386,6 @@ static inline int bitmap_subset(const unsigned lon=
g *src1,
> >               return __bitmap_subset(src1, src2, nbits);
> >  }
> >
> > -static inline bool bitmap_empty(const unsigned long *src, unsigned nbi=
ts)
> > -{
> > -     if (small_const_nbits(nbits))
> > -             return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
> > -
> > -     return find_first_bit(src, nbits) =3D=3D nbits;
> > -}
>
> Since this is supposed to be an optimization, I would go all the way and
> replace this with the trivial implementation instead:
>
> bool bitmap_empty(long *bits, size_t nbits)
> {
>         for (; nbits >=3D BITS_PER_LONG; ++bits, nbits -=3D BITS_PER_LONG=
)
>                 if (*bits)
>                         return false;
>
>         if (nbits && *bits & BITMAP_LAST_WORD_MASK(nbits))
>                 return false;
>
>         return true;
> }

This is what current implementations basically do, based on find_first_bit(=
).

I think that for long bitmaps the most time consuming operation is moving
data to L1, and for short bitmaps the difference between approaches is
barely measurable.

But hweght_long on each iteration can't be more effective than the current
version. So, I'll drop this patch for v2 and keep things unchanged.
