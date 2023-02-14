Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED31696A55
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 17:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjBNQve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 11:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbjBNQvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 11:51:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3482CFED;
        Tue, 14 Feb 2023 08:50:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A157AB81E33;
        Tue, 14 Feb 2023 16:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEEBC433EF;
        Tue, 14 Feb 2023 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676393454;
        bh=+9E7Tqas2/JykgI0ScHyuFBVkpuRb5O4ER6iJ0JOtcQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=k5zbhWh3OOZcPt2A0J12+DRrPnyvVAyQta5Ct5b1A2vWRj/6RJRXswQC74ywJpkDu
         T05HTqv22RYv2LHiGis+Rn8+YdWEwvv6pxn/Vlx+iMLv6iiu5QlqNncfF1KP6EVnI+
         SzvvljFmPy6TsUWIcCAdH5esqkuep7zZiSu+EMhLP+6kymCvr2QzoWr7jKEV7p+kb7
         GTrAn+57A+PsT+hA7rBCEe+sRgRKIs+tzfizhYRb0AzDp6fqsuz5bEvbyghXnbZBGO
         xmhjodxoZGYHoYxOzqwUErbfbhILbFzaGW7RgDRHxT4MxnO9mhIHNtiVLWArnV6vXV
         DC0ZMLiE27BLA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     Vineet Gupta <vineetg@rivosinc.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
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
In-Reply-To: <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us>
 <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
 <87sff8ags6.fsf@all.your.base.are.belong.to.us>
 <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
Date:   Tue, 14 Feb 2023 17:50:51 +0100
Message-ID: <873578faxg.fsf@all.your.base.are.belong.to.us>
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

Andy Chiu <andy.chiu@sifive.com> writes:

> Hey Bj=C3=B6rn,
>
> On Tue, Feb 14, 2023 at 2:43 PM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> =
wrote:
>> So, two changes:
>>
>> 1. Disallow V-enablement if the existing altstack does not fit a V-sized
>>    frame.
> This could potentially break old programs (non-V) that load new system
> libraries (with V), If the program sets a small alt stack and takes
> the fault in some libraries that use V. However, existing
> implementation will also kill the process when the signal arrives,
> finding insufficient stack frame in such cases. I'd choose the second
> one if we only have these two options, because there is a chance that
> the signal handler may not even run.

I think we might have different views here. A process has a pre-V, a and
post-V state. Is allowing a process to enter V without the correct
preconditions a good idea? Allow to run with V turned on, but not able
to correctly handle a signal (the stack is too small)?

This was the same argument that the Intel folks had when enabling
AMX. Sure, AMX requires *explicit* enablement, but same rules should
apply, no?

>> 2. Sanitize altstack changes when V is enabled.
> Yes, I'd like to have this. But it may be tricky when it comes to
> deciding whether V is enabled, due to the first-use trap. If V is
> commonly used in system libraries then it is likely that V will be
> enabled before an user set an altstack. Sanitizing this case would be
> easy and straightforward. But what if the user sets an altstack before
> enabling V in the first-use trap? This could happen on a statically
> program that has hand-written V routines. This takes us to the 1st
> question above, should we fail the user program immediately if the
> altstack is set too small?

For me it's obvious to fail (always) "if the altstack is too small to
enable V", because it allows to execute V without proper preconditions.

Personally, I prefer a stricter model. Only enter V if you can, and
after entering it disallow changing the altstack.

Then again, this is *my* opinion and concern. What do other people
think? I don't want to stall the series.

>>
>> Other than the altstack handling, I think the series is a good state! It
>> would great if we could see a v14 land in -next...
> Thanks. I am reforming the v14 patch and hoping the same to happen soon t=
oo!

Thank you for your hard work! It would be awesome to *finally* have
vector support in the kernel!


Bj=C3=B6rn
