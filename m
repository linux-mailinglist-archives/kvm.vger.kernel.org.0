Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804D866B181
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 15:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjAOOaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 09:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAOO35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 09:29:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC17EB76A;
        Sun, 15 Jan 2023 06:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A4C260CF9;
        Sun, 15 Jan 2023 14:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1688EC433D2;
        Sun, 15 Jan 2023 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673792995;
        bh=6AtmHzTmKwhgZfSkJiaOs9M/vE83edxq/5rI8jWJTDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G9UJrY4MuohrZre8aaAvWuiPtSMtKDoZMZQugcSnhN33c0oVIS2CkMhkPMag0lFfA
         mrne9FkOTKLJvEl5VbFlH0KqL3CV6ZlDK3hKasVUIxs7qE1J7od5a1PNTNFMe8qUdU
         bPD1ul6caPZogks//5UiMuMHNXoeKncnrZzJC938evyfwJpycJ9koF+7d33TX6A3q1
         s/xtQjUMRzSORolZuBW8zDCEQ3AaHLN9OjC6RsxEg026KbrB8GUXWvzSzEUmkZVSvH
         CcQZtStB/G92s5SjEQ63G7vGIkHQrgZTagnz57uP+3Hm6+xr1TpfJ4TOVndH2/UO1V
         VtMKEKArJjMag==
Date:   Sun, 15 Jan 2023 22:19:36 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8QLeEECPqnjCS+2@xhacker>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2398293.3Lj2Plt8kZ@diego>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko Stübner wrote:
> Hi Jisheng.

Hi Heiko,

> 
> Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > riscv_cpufeature_patch_func() currently only scans a limited set of
> > cpufeatures, explicitly defined with macros. Extend it to probe for all
> > ISA extensions.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> >  arch/riscv/include/asm/errata_list.h |  9 ++--
> >  arch/riscv/kernel/cpufeature.c       | 63 ++++------------------------
> >  2 files changed, 11 insertions(+), 61 deletions(-)
> 
> hmmm ... I do see a somewhat big caveat for this.
> and would like to take back my Reviewed-by for now
> 
> 
> With this change we would limit the patchable cpufeatures to actual
> riscv extensions. But cpufeatures can also be soft features like
> how performant the core handles unaligned accesses.

Besides Drew's comments and my reply a few minutes ago, here are
what I thought: I agree with you about "cpufeatures can also be soft
features" which I called cpu related features, but currently we
don't have that case in urgent, the SV48 and SV57 are extensions now
as Jessica pointed out[1], so I planed to send a v7 to apply the
alternative mechanism for SV48/SV57, and I think we still have time to
revisit the "expanding cpufeatures to cover soft features". But that
need to be addressed in another improvement series.

[1] https://lore.kernel.org/linux-riscv/391AFCB9-D314-4243-9E35-6D95B81C9400@jrtc27.com/

> 
> See Palmer's series [0].
> 
> 
> Also this essentially codifies that each ALTERNATIVE can only ever
> be attached to exactly one extension.
> 
> But contrary to vendor-errata, it is very likely that we will need
> combinations of different extensions for some alternatives in the future.
> 
> In my optimization quest, I found that it's actually pretty neat to
> convert the errata-id for cpufeatures to a bitfield [1], because then it's
> possible to just combine extensions into said bitfield [2]:
> 
> 	ALTERNATIVE_2("nop",
> 		      "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> 		      "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> 
> [the additional field there models a "not" component]
> 
> So I really feel this would limit us quite a bit.
> 
> 
> Heiko
> 
> 
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git/commit/?h=riscv-hwprobe-v1&id=510c491cb9d87dcbdc91c63558dc704968723240
> [1] https://github.com/mmind/linux-riscv/commit/f57a896122ee7e666692079320fc35829434cf96
> [2] https://github.com/mmind/linux-riscv/commit/8cef615dab0c00ad68af2651ee5b93d06be17f27#diff-194cb8a86f9fb9b03683295f21c8f46b456a9f94737f01726ddbcbb9e3aace2cR12
> 
> 
