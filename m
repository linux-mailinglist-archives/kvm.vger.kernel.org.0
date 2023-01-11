Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB91666729
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 00:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbjAKXaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 18:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjAKXaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 18:30:06 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EABB97;
        Wed, 11 Jan 2023 15:30:03 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pFkXe-00019a-Nt; Thu, 12 Jan 2023 00:29:58 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA extensions
Date:   Thu, 12 Jan 2023 00:29:57 +0100
Message-ID: <2398293.3Lj2Plt8kZ@diego>
In-Reply-To: <20230111171027.2392-6-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org> <20230111171027.2392-6-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jisheng.

Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> riscv_cpufeature_patch_func() currently only scans a limited set of
> cpufeatures, explicitly defined with macros. Extend it to probe for all
> ISA extensions.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/riscv/include/asm/errata_list.h |  9 ++--
>  arch/riscv/kernel/cpufeature.c       | 63 ++++------------------------
>  2 files changed, 11 insertions(+), 61 deletions(-)

hmmm ... I do see a somewhat big caveat for this.
and would like to take back my Reviewed-by for now


With this change we would limit the patchable cpufeatures to actual
riscv extensions. But cpufeatures can also be soft features like
how performant the core handles unaligned accesses.

See Palmer's series [0].


Also this essentially codifies that each ALTERNATIVE can only ever
be attached to exactly one extension.

But contrary to vendor-errata, it is very likely that we will need
combinations of different extensions for some alternatives in the future.

In my optimization quest, I found that it's actually pretty neat to
convert the errata-id for cpufeatures to a bitfield [1], because then it's
possible to just combine extensions into said bitfield [2]:

	ALTERNATIVE_2("nop",
		      "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
		      "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)

[the additional field there models a "not" component]

So I really feel this would limit us quite a bit.


Heiko



[0] https://git.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git/commit/?h=riscv-hwprobe-v1&id=510c491cb9d87dcbdc91c63558dc704968723240
[1] https://github.com/mmind/linux-riscv/commit/f57a896122ee7e666692079320fc35829434cf96
[2] https://github.com/mmind/linux-riscv/commit/8cef615dab0c00ad68af2651ee5b93d06be17f27#diff-194cb8a86f9fb9b03683295f21c8f46b456a9f94737f01726ddbcbb9e3aace2cR12


