Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5235A6447CA
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiLFPRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbiLFPQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:16:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CC3891;
        Tue,  6 Dec 2022 07:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30206CE19DD;
        Tue,  6 Dec 2022 15:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBBDC433D6;
        Tue,  6 Dec 2022 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670339554;
        bh=mGtG2UCNLb8zhz3Q6ArNChI7VGb5eTZ5ueFrfVstXD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bo5y7lUSDSXWfZgfW+OZ4O8LIx502DSwi4Fm4epiyqnYf9KRbYyK7MM8P9H999BGY
         6z46l9lxs+KnGbQSjen7JDqvNl4fDQfmIis5sRcSBT2AqRFjWYuGpZ3hSRBwVvmhCG
         VyOsx743ycHsVK/LN54RaXYDyQo98XtoaWghHq8xYcZjS8pXmcGd0g3kJuwu1u/oxw
         cJ7sIn8Xo3AsyiurYG6ZVzMgTNkj3Kw8zRGb6NOAzkwjPKrAIZt4WG/yCZ2DAhnjGy
         FsZ7OMDupxLncDYgSkpRgoBaZOOLI0SD8Z+FQGrIh2FR4tt07STmbuRqCURjK4K53d
         pAlD9Ibdsvxlw==
Date:   Tue, 6 Dec 2022 23:02:35 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc:     Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y49Zi2CNv8pZSAe5@xhacker>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <10190559.nUPlyArG6x@diego>
 <Y45LRu0Gvrurm5Rh@spud>
 <12207576.O9o76ZdvQC@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12207576.O9o76ZdvQC@diego>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:39:50AM +0100, Heiko Stübner wrote:
> Am Montag, 5. Dezember 2022, 20:49:26 CET schrieb Conor Dooley:
> > On Mon, Dec 05, 2022 at 07:49:01PM +0100, Heiko Stübner wrote:
> > > Am Montag, 5. Dezember 2022, 19:36:45 CET schrieb Conor Dooley:
> > > > Heiko, Jisheng,
> > > > On Mon, Dec 05, 2022 at 11:40:44PM +0800, Jisheng Zhang wrote:
> > > > > Yesterday, I also wanted to unify the two instruction fix into
> > > > > one. But that would need to roll back the
> > > > > riscv_alternative_fix_auipc_jalr() to your v1 version. And IMHO,
> > > > > it's better if you can split the Zbb string optimizations series
> > > > > into two: one for alternative improvements, another for Zbb. Then
> > > > > we may get the alternative improvements and this inst extension
> > > > > series merged in v6.2-rc1.
> > > > 
> > > > Heiko, perhaps you can correct me here:
> > > > 
> > > > Last Wednesday you & Palmer agreed that it was too late in the cycle to
> > > > apply any of the stuff touching alternatives?
> > > > If I do recall correctly, gives plenty of time to sort out any
> > > > interdependent changes here.
> > > > 
> > > > Could easily be misremembering, wouldn't be the first time!
> > > 
> > > You slightly misremembered, but are still correct with the above ;-) .
> > > 
> > > I.e. what we talked about was stuff for fixes for 6.1-rc, were Palmers
> > > wisely wanted to limit additions to really easy fixes for the remaining
> > > last rc, to not upset any existing boards.
> > 
> > Ahh right. I was 50-50 on whether something like that was said so at
> > least I am not going crazy.
> > 
> > > But you are still correct that we also shouldn't target the 6.2 merge window
> > > anymore :-) .
> > > 
> > > We're after -rc8 now (which is in itself uncommon) and in his -rc7
> > > announcement [0], Linus stated
> > > 
> > > "[...] the usual rule is that things that I get sent for the
> > > merge window should have been all ready _before_ the merge window
> > > opened. But with the merge window happening largely during the holiday
> > > season, I'll just be enforcing that pretty strictly."
> > 
> > Yah, of all the windows to land patchsets that are being re-spun a few
> > days before it opens this probably isn't the best one to pick!
> > 
> > > That means new stuff should be reviewed and in linux-next _way before_ the
> > > merge window opens next weekend. Taking into account that people need
> > > to review stuff (and maybe the series needing another round), I really don't
> > > see this happening this week and everything else will get us shouted at
> > > from atop a christmas tree ;-) .
> > > 
> > > That's the reason most maintainer-trees stop accepting stuff after -rc7

Thanks for the information, then we have more time to test and review
this series.

> > 
> > Aye, in RISC-V land maybe we will get there one day :)
> > 
> > For the original question though, breaking them up into 3 or 4 smaller
> > bits that could get applied on their own is probably a good idea?
> > 
> > Between yourselves, Drew and Prabhakar there's a couple series touching
> > the same bits. Certainly don't want to seem like I am speaking for the

Because alternative is the best solution to riscv extensions while still
keep one unified kernel Image ;)

> > Higher Powers here, but some sort of logical ordering would probably be
> > a good idea so as not to hold each other up?
> > The non-string bit of your series has been fairly well reviewed & would,
> > in theory, be mergeable once the tree re-opens? Timing aside, Jisheng's
> > idea seems like a good one, no?

IMHO, it will be better if Palmer can merge Heiko's alternative improvements
into riscv-next once well reviewed and the window is reopen. Then Drew,
Prabhakar and I can rebase on that tree.

> 
> yeah, I had that same thought over the weekend - with the generic
> part being pretty good in the review and only the string part needing
> more work and thus ideally splitting the series [0] .
> 
> Jisheng's series just made that even more important to do :-)
> 
> 
> Heiko
> 
> 
