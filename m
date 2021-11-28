Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2626C4605D1
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 12:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357272AbhK1LOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 06:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344301AbhK1LME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 06:12:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CC9C061746;
        Sun, 28 Nov 2021 03:08:48 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso11464943pjb.2;
        Sun, 28 Nov 2021 03:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=RLGVormZNrRFWCDJ7jdRt19siDEPnOtSgoMRMWSMPpw=;
        b=JS75cm1kNmau6QTu2rqjTEH1lacCTylUddbQig/MfaOv87fU1R4ixeZwUTvWkojCLe
         FVsH5wJQluo9fnDCJtLxlNsFRugI2zkbabpCQ9VhDSP+vCMkQ9XcDyPUZsKoAN0XUVPp
         aHUTDQx+GNGjfhDN5ufjzO429xe7p71bZ6QrT/eU2apwdj3VV4bcd4Oz9OEiXGFLWmkO
         KTg66HtHflRGYT80QQO1K0h4MxrasFS2dEY2Sip94P5OybBl2LvseRqW7ZJqQswnXYN6
         Cntrs/UrWT/QrCgRauE5NdDXQthF0aHKCC9fzaz2Cb2jdPmYhTY0PX3z2F7VkaSzQTfW
         T9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=RLGVormZNrRFWCDJ7jdRt19siDEPnOtSgoMRMWSMPpw=;
        b=XvQmWbOnY1KJ8efcHdlz8dJ4QUKM6HPeB8t3/uHg8nlPFXkdA40On4Qi1JqcnvSVHb
         te/xmBG/YXk9WzJYfwuSugZqAOjbO6bN61i5qLDpgjc3HSrHIevaXWaVDwNPcaiK43sS
         2ofrv7fH65flVKdAfpi1a186ohuNpGI2SahFcJV0WYYtxqjBgKfrHiAqAcq11njF895q
         yTli+iONG94MAl7QLZXG6Wupa29+RPpNSdJp4i3TCMtQQ+gT2Rq3nP0gATda5NzFn6Bv
         cNxg/lH35P65Ms/vGfHTPVMGffQavin8QvBg8gNHFMIDre1eYQcpaBaaO4pFdHSfIbFA
         b1Pw==
X-Gm-Message-State: AOAM531w1Tg5lfqOzfF/tURJNbNdPfCs2yOh4+DPRWrOp+0cFIsY3qyt
        p+o/H+vzwzcxJCuwEW2bj1k=
X-Google-Smtp-Source: ABdhPJwy0Op9mcVC2NuBsFMopKknqC2dkNsLfr7KDw0piI/fX2AvzDRr44yqwWjkuQxAQyAX4DCrnA==
X-Received: by 2002:a17:902:7fc3:b0:144:e29c:228d with SMTP id t3-20020a1709027fc300b00144e29c228dmr51588052plb.4.1638097728470;
        Sun, 28 Nov 2021 03:08:48 -0800 (PST)
Received: from localhost (115-64-213-93.static.tpgi.com.au. [115.64.213.93])
        by smtp.gmail.com with ESMTPSA id 9sm9412647pgq.57.2021.11.28.03.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 03:08:48 -0800 (PST)
Date:   Sun, 28 Nov 2021 21:08:41 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/9] lib/bitmap: optimize bitmap_weight() usage
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andy Gross <agross@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Alexey Klimov <aklimov@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@fb.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Ian Rogers <irogers@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, kvm@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-perf-users@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        Andy Lutomirski <luto@kernel.org>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marc Zyngier <maz@kernel.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Marcin Wojtas <mw@semihalf.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sunil Goutham <sgoutham@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vineet Gupta <vgupta@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>
References: <20211128035704.270739-1-yury.norov@gmail.com>
In-Reply-To: <20211128035704.270739-1-yury.norov@gmail.com>
MIME-Version: 1.0
Message-Id: <1638096766.3elxdzb8ly.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Yury Norov's message of November 28, 2021 1:56 pm:
> In many cases people use bitmap_weight()-based functions like this:
>=20
> 	if (num_present_cpus() > 1)
> 		do_something();
>=20
> This may take considerable amount of time on many-cpus machines because
> num_present_cpus() will traverse every word of underlying cpumask
> unconditionally.
>=20
> We can significantly improve on it for many real cases if stop traversing
> the mask as soon as we count present cpus to any number greater than 1:
>=20
> 	if (num_present_cpus_gt(1))
> 		do_something();
>=20
> To implement this idea, the series adds bitmap_weight_{eq,gt,le}
> functions together with corresponding wrappers in cpumask and nodemask.

There would be no change to callers if you maintain counters like what
is done for num_online_cpus() today. Maybe some fixes to arch code that
does not use set_cpu_possible() etc APIs required, but AFAIKS it would
be better to fix such cases anyway.

Thanks,
Nick
