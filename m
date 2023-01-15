Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78466B165
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjAOOJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 09:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjAOOJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 09:09:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC37113DA;
        Sun, 15 Jan 2023 06:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C2060C9F;
        Sun, 15 Jan 2023 14:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E1AC433D2;
        Sun, 15 Jan 2023 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673791781;
        bh=zRcvm8EavOwpoEQYu0yKJXbKuP4uobFu5WALEjpcP2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Me+1CzjEHuvOGX9tmzeZvwmy5/Ye7+OtsoY4qhSzsvUluuntBMZ1kbsKyo4DZkpv3
         8LHx+kzUAMUd4Qf9yUJsCRPG4RRXxmVooWzr3jOMA7UMr9lLUMW1PS4dopDMxkqj7+
         3BnGofdmns+q2gJnKMgd2iZXZ1dyoW9UAr2jg1Q2dbcGvNNI928OF+pyKGTt36uH4C
         AngzjQTQ+bFdxQiADUiLXSWnX41/QS4YDGosNavH1BjHb14X8wkAcu2Aubbl2irbVf
         6rwBBW/RzYJPNHDltGMPBlWbutzQHG2jrHhr50PyytTzgwrrC08aejhj3HEDL3XZ/d
         oqcEZFVj7mDWw==
Date:   Sun, 15 Jan 2023 21:59:18 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8QGtlnZKk5rp+fg@xhacker>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
 <20230112092136.f2g43hrhmrqouy4y@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230112092136.f2g43hrhmrqouy4y@orel>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 10:21:36AM +0100, Andrew Jones wrote:
> On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko Stübner wrote:
> > Hi Jisheng.
> > 
> > Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > > riscv_cpufeature_patch_func() currently only scans a limited set of
> > > cpufeatures, explicitly defined with macros. Extend it to probe for all
> > > ISA extensions.
> > > 
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > >  arch/riscv/include/asm/errata_list.h |  9 ++--
> > >  arch/riscv/kernel/cpufeature.c       | 63 ++++------------------------
> > >  2 files changed, 11 insertions(+), 61 deletions(-)
> > 
> > hmmm ... I do see a somewhat big caveat for this.
> > and would like to take back my Reviewed-by for now
> > 
> > 
> > With this change we would limit the patchable cpufeatures to actual
> > riscv extensions. But cpufeatures can also be soft features like
> > how performant the core handles unaligned accesses.
> 
> I agree that this needs to be addressed and Jisheng also raised this
> yesterday here [*]. It seems we need the concept of cpufeatures, which
> may be extensions or non-extensions.
> 
> [*] https://lore.kernel.org/all/Y77xyNPNqnFQUqAx@xhacker/
> 
> > 
> > See Palmer's series [0].
> > 
> > 
> > Also this essentially codifies that each ALTERNATIVE can only ever
> > be attached to exactly one extension.
> > 
> > But contrary to vendor-errata, it is very likely that we will need
> > combinations of different extensions for some alternatives in the future.
> 
> One possible approach may be to combine extensions/non-extensions at boot
> time into pseudo-cpufeatures. Then, alternatives can continue attaching to
> a single "feature". (I'm not saying that's a better approach than the
> bitmap, I'm just suggesting it as something else to consider.)

When swtiching pgtable_l4_enabled to static key for the first time, I
suggested bitmap for cpufeatures which cover both ISA extensions
and non-extensions-but-some-cpu-related-features [1],
but it was rejected at that time, it seems we need to revisit the idea.

[1] https://lore.kernel.org/linux-riscv/20220508160749.984-1-jszhang@kernel.org/

> 
> Thanks,
> drew
> 
> > 
> > In my optimization quest, I found that it's actually pretty neat to
> > convert the errata-id for cpufeatures to a bitfield [1], because then it's
> > possible to just combine extensions into said bitfield [2]:
> > 
> > 	ALTERNATIVE_2("nop",
> > 		      "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> > 		      "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> > 
> > [the additional field there models a "not" component]
> > 
> > So I really feel this would limit us quite a bit.
> > 
> > 
> > Heiko
> > 
> > 
> > 
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git/commit/?h=riscv-hwprobe-v1&id=510c491cb9d87dcbdc91c63558dc704968723240
> > [1] https://github.com/mmind/linux-riscv/commit/f57a896122ee7e666692079320fc35829434cf96
> > [2] https://github.com/mmind/linux-riscv/commit/8cef615dab0c00ad68af2651ee5b93d06be17f27#diff-194cb8a86f9fb9b03683295f21c8f46b456a9f94737f01726ddbcbb9e3aace2cR12
> > 
> > 
