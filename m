Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79B6A7199
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCAQ5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCAQ5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:57:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB9E3C79B
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 08:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A5661378
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 16:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3313FC433EF;
        Wed,  1 Mar 2023 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677689849;
        bh=yaPbTuqvzSZPUD5byFXCQgw/KYy/ybMqt50jxgUlau8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=iUta2dxpT4sL7j8io+ssCFItLk++aHVUWwtcZ8cgWBspiWdXgyLyVdnovVWTJhgh4
         lhyfJC4eU4mrcRBL74RKmGiFzDZpNiBfzVk9k+OBCqxD60OPMM0Ut5SOxGuzN6Gj8E
         yAYjFiKH36lK4V0Lvzx3DmKXvgE9Vk4ekhvcUBBqIVss0iZBmHikactTEwwwBTcz1B
         /3iYaKan2tmlZ0i3teeKagQYF/0KK1bIF5Y6hMu+xnoZZH0EjbpmPtkm/p9xsgCgtp
         IkUlORx4Cg6J2TP+hzAAEdKuMv0O+EZDyd9wRCCj6NTSnI7SJbn39lpkeISYHsR7r7
         AbgjVcUA4Q6vA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Conor Dooley <conor@kernel.org>, Andy Chiu <andy.chiu@sifive.com>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Heiko Stuebner <heiko@sntech.de>, kvm@vger.kernel.org,
        atishp@atishpatra.org, Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org,
        Nick Knight <nick.knight@sifive.com>, anup@brainfault.org,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        greentime.hu@sifive.com, Albert Ou <aou@eecs.berkeley.edu>,
        vineetg@rivosinc.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincent Chen <vincent.chen@sifive.com>, palmer@dabbelt.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kvm-riscv@lists.infradead.org
Subject: Re: [PATCH -next v14 09/19] riscv: Add task switch support for vector
In-Reply-To: <Y/+AN0e5netDShxx@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-10-andy.chiu@sifive.com> <Y/+AN0e5netDShxx@spud>
Date:   Wed, 01 Mar 2023 17:57:27 +0100
Message-ID: <87v8jk8l54.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Conor Dooley <conor@kernel.org> writes:

> Hey Andy,
>
> On Fri, Feb 24, 2023 at 05:01:08PM +0000, Andy Chiu wrote:
>> From: Greentime Hu <greentime.hu@sifive.com>
>> 
>> This patch adds task switch support for vector. It also supports all
>> lengths of vlen.
>> 
>> [guoren@linux.alibaba.com: First available porting to support vector
>> context switching]
>> [nick.knight@sifive.com: Rewrite vector.S to support dynamic vlen, xlen and
>> code refine]
>> [vincent.chen@sifive.com: Fix the might_sleep issue in riscv_v_vstate_save,
>> riscv_v_vstate_restore]
>> [andrew@sifive.com: Optimize task switch codes of vector]
>> [ruinland.tsai@sifive.com: Fix the arch_release_task_struct free wrong
>> datap issue]
>> [vineetg: Fixed lkp warning with W=1 build]
>> [andy.chiu: Use inline asm for task switches]
>
> Can we *please* get rid of these silly changelogs in the commit messages?
> Either someone did something worthy of being a co-developer on the
> patch, or this belongs under the --- line.
> It's a bit ridiculous I think to have a 15 word commit message for the
> patch, but have like 8 different bits of per-version changelogs...

Yes, please! And not only for this patch, but for the series in
general. The series needs a respin for various reasons, so now would be
a good opportunity to clean up the changelog.

Simply move it to the cover letter, or below --- as Conor suggests.
