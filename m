Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8D68BE77
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 14:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBFNkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 08:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBFNki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 08:40:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23AD30FC
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 05:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C77660EF4
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 13:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF1CC433EF;
        Mon,  6 Feb 2023 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675690836;
        bh=994+xbXQlKHOxMKGinewR4j0+N2ay/bGNWMb3PM/MOw=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=jMojKkSrHJHs4ciaNruZ63LJZteOD4aWFO1pEtos3KC2AG2UZEvhb8cVvbcDr8EpD
         bMY8/U/0T/jZIaHkAAZSx4oWmDDmF87Cai2TX/hT9j5GCL5Oc8//+PtGXf1HVuqTul
         us4Cwto0gL9wRvdJpKHALnA5Ksb0VKKDca+Ps3xXrFwfktUueALSmm/0deSGrCmb5t
         7izIjyspldZffwFStUB0RfM/yyStyJor2cQ2BDKmyDVS9zHIluJ9GNYzaT80ul6nQ8
         pc/zbXwyQDEHbZQe5wN7Qvw+d27iiOok2sivPmRmihNGQZ8r2f+IAIF+jizXFr6kWw
         NzbJpkW7A8WpA==
Date:   Mon, 06 Feb 2023 14:40:16 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
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
        Changbin Du <changbin.du@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_-next_v13_10/19=5D_riscv=3A_Allocate?= =?US-ASCII?Q?_user=27s_vector_context_in_the_first-use_trap?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CABgGipW_3tBbc3G91dqiAZCGeN-PbUvLS3n=bU0nWz0rRX9T8Q@mail.gmail.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-11-andy.chiu@sifive.com> <Y9MIr2iR5rzlIGKQ@spud> <CABgGipW_3tBbc3G91dqiAZCGeN-PbUvLS3n=bU0nWz0rRX9T8Q@mail.gmail.com>
Message-ID: <36A0C855-5EA7-49B5-B92E-B28E684AC3D8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6 February 2023 13:00:00 GMT+01:00, Andy Chiu <andy=2Echiu@sifive=2Ecom=
> wrote:
>On Fri, Jan 27, 2023 at 7:11 AM Conor Dooley <conor@kernel=2Eorg> wrote:

>Changing it to a switch statement for better structuring=2E
>> I would like Heiko to take a look at this function!
>> I know we have the RISCV_INSN_FUNCS stuff that got newly added, but tha=
t's
>> for single, named instructions=2E I'm just curious if there may be a ne=
ater
>> way to go about doing this=2E AFAICT, the widths are all in funct3 - bu=
t it
>> is a shame that 0b100 is Q and 0 is vector, as the macro works for matc=
hes
>> and we can't use the upper bit for that=2E
>> There's prob something you could do with XORing and XNORing bits, but a=
t
>> that point it'd not be adding any clarity at all & it'd not be a
>> RISCV_INSN_FUNCS anymore!
>> The actual opcode checks probably could be extracted though, but would
>> love to know what Heiko thinks, even if that is "leave it as is"=2E
>I've checked the RISCV_INSN_FUNCS part recently=2E It seems good to
>match a single type of instruction, such as vector with OP-V opcode=2E
>However, I did not find an easy way of matching whole instructions
>introduced by RVV, which includes CSR operations on multiple CSRs and
>load/store with different widths=2E Yes, it would be great if we could
>distinguish VL and VS out by the upper bit of the width=2E Or even
>better if we could match CSR numbers for Vector this way=2E But I didn't
>find it=2E

Yup, I didn't see a straight forward way either=2E
I was hoping Heiko might have an idea!


>> > +     /* Sanity check=2E datap should be null by the time of the firs=
t-use trap */
>> > +     WARN_ON(current->thread=2Evstate=2Edatap);
>>
>> Is a WARN_ON sufficient here? If on the first use trap, it's non-null
>> should we return false and trigger the trap error too?
>If we'd run into this warning message then there is a bug in kernel
>space=2E For example, if we did not properly free and clear the datap
>pointer=2E Or if we allocated datap somewhere else and did not set VS
>accordingly=2E Normally, current user space programs would not expect to
>run into this point, so I guess returning false here is not
>meaningful=2E This warning message is intended for kernel debugging
>only=2E Or, should we just strip out this check?

I suppose my question was "is it safe to warn and carry on, rather than di=
sallow use of vector in this situation"=2E

Thanks,
Conor=2E
