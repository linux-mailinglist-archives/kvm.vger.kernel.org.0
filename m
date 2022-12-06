Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628A3643A5B
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 01:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiLFAlR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Dec 2022 19:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiLFAlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 19:41:00 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EF49594;
        Mon,  5 Dec 2022 16:40:00 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1p2Lzz-0007ay-NO; Tue, 06 Dec 2022 01:39:51 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Conor Dooley <conor@kernel.org>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Date:   Tue, 06 Dec 2022 01:39:50 +0100
Message-ID: <12207576.O9o76ZdvQC@diego>
In-Reply-To: <Y45LRu0Gvrurm5Rh@spud>
References: <20221204174632.3677-1-jszhang@kernel.org> <10190559.nUPlyArG6x@diego> <Y45LRu0Gvrurm5Rh@spud>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Montag, 5. Dezember 2022, 20:49:26 CET schrieb Conor Dooley:
> On Mon, Dec 05, 2022 at 07:49:01PM +0100, Heiko Stübner wrote:
> > Am Montag, 5. Dezember 2022, 19:36:45 CET schrieb Conor Dooley:
> > > Heiko, Jisheng,
> > > On Mon, Dec 05, 2022 at 11:40:44PM +0800, Jisheng Zhang wrote:
> > > > Yesterday, I also wanted to unify the two instruction fix into
> > > > one. But that would need to roll back the
> > > > riscv_alternative_fix_auipc_jalr() to your v1 version. And IMHO,
> > > > it's better if you can split the Zbb string optimizations series
> > > > into two: one for alternative improvements, another for Zbb. Then
> > > > we may get the alternative improvements and this inst extension
> > > > series merged in v6.2-rc1.
> > > 
> > > Heiko, perhaps you can correct me here:
> > > 
> > > Last Wednesday you & Palmer agreed that it was too late in the cycle to
> > > apply any of the stuff touching alternatives?
> > > If I do recall correctly, gives plenty of time to sort out any
> > > interdependent changes here.
> > > 
> > > Could easily be misremembering, wouldn't be the first time!
> > 
> > You slightly misremembered, but are still correct with the above ;-) .
> > 
> > I.e. what we talked about was stuff for fixes for 6.1-rc, were Palmers
> > wisely wanted to limit additions to really easy fixes for the remaining
> > last rc, to not upset any existing boards.
> 
> Ahh right. I was 50-50 on whether something like that was said so at
> least I am not going crazy.
> 
> > But you are still correct that we also shouldn't target the 6.2 merge window
> > anymore :-) .
> > 
> > We're after -rc8 now (which is in itself uncommon) and in his -rc7
> > announcement [0], Linus stated
> > 
> > "[...] the usual rule is that things that I get sent for the
> > merge window should have been all ready _before_ the merge window
> > opened. But with the merge window happening largely during the holiday
> > season, I'll just be enforcing that pretty strictly."
> 
> Yah, of all the windows to land patchsets that are being re-spun a few
> days before it opens this probably isn't the best one to pick!
> 
> > That means new stuff should be reviewed and in linux-next _way before_ the
> > merge window opens next weekend. Taking into account that people need
> > to review stuff (and maybe the series needing another round), I really don't
> > see this happening this week and everything else will get us shouted at
> > from atop a christmas tree ;-) .
> > 
> > That's the reason most maintainer-trees stop accepting stuff after -rc7
> 
> Aye, in RISC-V land maybe we will get there one day :)
> 
> For the original question though, breaking them up into 3 or 4 smaller
> bits that could get applied on their own is probably a good idea?
> 
> Between yourselves, Drew and Prabhakar there's a couple series touching
> the same bits. Certainly don't want to seem like I am speaking for the
> Higher Powers here, but some sort of logical ordering would probably be
> a good idea so as not to hold each other up?
> The non-string bit of your series has been fairly well reviewed & would,
> in theory, be mergeable once the tree re-opens? Timing aside, Jisheng's
> idea seems like a good one, no?

yeah, I had that same thought over the weekend - with the generic
part being pretty good in the review and only the string part needing
more work and thus ideally splitting the series [0] .

Jisheng's series just made that even more important to do :-)


Heiko


