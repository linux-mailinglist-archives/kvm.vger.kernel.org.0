Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B3769772F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 08:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjBOHOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 02:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBOHOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 02:14:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC74129E0A;
        Tue, 14 Feb 2023 23:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68663618CD;
        Wed, 15 Feb 2023 07:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52967C433D2;
        Wed, 15 Feb 2023 07:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676445250;
        bh=IFO9sYbIUX6Yq5A71YlDyaYjEk+QPXRW1MBebM0CY24=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ufPV1INsobzI+bbgACjVvUu4CWBA/JUPH1k//GKfsxCrR38knRH1n/PBVdWMtVpgh
         Bf2bs/EaGC4WaxLgbgHx1XxorrV46MDaUNYwqLSKy25BExhNs+uSDm0xl6V0Sz5g9f
         nFp03DiZF11ofiGs82NcVZr3v6PshcZxfS75qmayzoJ16GEMjLlbbg+0d0looZsMmo
         Kaw1VgX/VAKIxvWInXXPC6QIzjOgOmRw63hyIC9leJ36+yEnuReFCc5uzI9a7hm3Pb
         DmI9/xV1+QRuAQfuLS2bdRph9xgujPtcEvvL3jZOHiyIcLw3rPO12uSTi3I7T4WVCt
         bMk7ShxaoM51A==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Vineet Gupta <vineetg@rivosinc.com>,
        Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context
 in the first-use trap
In-Reply-To: <5e440cfa-27c5-f216-5529-350ac19c07ff@rivosinc.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us>
 <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
 <87sff8ags6.fsf@all.your.base.are.belong.to.us>
 <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
 <873578faxg.fsf@all.your.base.are.belong.to.us>
 <5e440cfa-27c5-f216-5529-350ac19c07ff@rivosinc.com>
Date:   Wed, 15 Feb 2023 08:14:08 +0100
Message-ID: <87wn4jjt8f.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineet Gupta <vineetg@rivosinc.com> writes:

> On 2/14/23 08:50, Bj=C3=B6rn T=C3=B6pel wrote:
>> Andy Chiu <andy.chiu@sifive.com> writes:
>>
>>> Hey Bj=C3=B6rn,
>>>
>>> On Tue, Feb 14, 2023 at 2:43 PM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org=
> wrote:
>>>> So, two changes:
>>>>
>>>> 1. Disallow V-enablement if the existing altstack does not fit a V-siz=
ed
>>>>     frame.
>>> This could potentially break old programs (non-V) that load new system
>>> libraries (with V), If the program sets a small alt stack and takes
>>> the fault in some libraries that use V. However, existing
>>> implementation will also kill the process when the signal arrives,
>>> finding insufficient stack frame in such cases. I'd choose the second
>>> one if we only have these two options, because there is a chance that
>>> the signal handler may not even run.
>> I think we might have different views here. A process has a pre-V, a and
>> post-V state. Is allowing a process to enter V without the correct
>> preconditions a good idea? Allow to run with V turned on, but not able
>> to correctly handle a signal (the stack is too small)?
>
> The requirement is sane, but the issue is user experience: User trying=20
> to bring up some V code has no clue that deep in some startup code some=20
> alt stack had been setup and causing his process to be terminated on=20
> first V code.
>
>>
>> This was the same argument that the Intel folks had when enabling
>> AMX. Sure, AMX requires *explicit* enablement, but same rules should
>> apply, no?
>>
>>>> 2. Sanitize altstack changes when V is enabled.
>>> Yes, I'd like to have this. But it may be tricky when it comes to
>>> deciding whether V is enabled, due to the first-use trap. If V is
>>> commonly used in system libraries then it is likely that V will be
>>> enabled before an user set an altstack. Sanitizing this case would be
>>> easy and straightforward.
>
> Good. Lets have this in v14 as it seems reasonably easy to implement.
>
>>> But what if the user sets an altstack before
>>> enabling V in the first-use trap? This could happen on a statically
>>> program that has hand-written V routines. This takes us to the 1st
>>> question above, should we fail the user program immediately if the
>>> altstack is set too small?
>
> Please lets not cross threads. We discussed this already at top. While=20
> ideally required, seems tricky so lets start with post-V alt stack check.
>
>> For me it's obvious to fail (always) "if the altstack is too small to
>> enable V", because it allows to execute V without proper preconditions.
>>
>> Personally, I prefer a stricter model. Only enter V if you can, and
>> after entering it disallow changing the altstack.
>>
>> Then again, this is *my* opinion and concern. What do other people
>> think? I don't want to stall the series.
>
> I concur that the alt stack checking requirements are sensible in the=20
> long run. We can add the obvious check for post-V case and see if there=20
> is a sane way to flag pre-V case to.

Reasonable. @Andy does this resonate with you as well?


Bj=C3=B6rn
