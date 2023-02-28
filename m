Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36656A606C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjB1UdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjB1Uc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:32:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4186A72B0;
        Tue, 28 Feb 2023 12:32:58 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677616376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVbhBujVm3EclS3yGgug0dwXP4dkLsKIuUfQtslE/JU=;
        b=A5cuZgw+HY2OsMz9nx1VUlK2Hs0UOK51cSmMzL0Kt1xDzNc1jMv7ShAcYbDZVotlVoh93Q
        S4mg5bSD4x/y4y8VwPVTvDOL/Fdcb1fsY5BDAr+bEQs0j8Wj9MY47mCoFB3tACpxFEhRpr
        5rUdM/rw4qVPwYjB7M3h5rACUyXE2W4O3TPhTdQo970Z1ZJEvAxp/2YGAWhukGDEwZ0y8k
        kESOWBaiI2/0zf36ADd/j+Wtq7VHtCbCyfxbap900dw4k5TFa4nxK3vJTp36ruLu6pVd7H
        zk5rTykGk/bALkLbKtQXhMBMrY9pehOEzABiR7xlu3wLRXJQpt7CyplMNL0iGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677616376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVbhBujVm3EclS3yGgug0dwXP4dkLsKIuUfQtslE/JU=;
        b=sknPopdWaQPYq/vhVEkooozmTNLQUMcVumJpGjjFv7Bu+nqXccITvGl7u+OeAqKb4JYpMr
        CWBl8YFAwVJqlCCQ==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
In-Reply-To: <2776fc04271e5d3697918ce36e7e2893e2a7bc21.camel@infradead.org>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-7-usama.arif@bytedance.com> <87k001n4xo.ffs@tglx>
 <2776fc04271e5d3697918ce36e7e2893e2a7bc21.camel@infradead.org>
Date:   Tue, 28 Feb 2023 21:32:55 +0100
Message-ID: <87bkldmsy0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28 2023 at 16:25, David Woodhouse wrote:
> On Tue, 2023-02-28 at 17:13 +0100, Thomas Gleixner wrote:
>> Folks, really.
>
> Also, while those two lines *happen* to be my addition to Brian's
> commit message, I don't know if you knew that.

I knew because I read Brians patches _and_ I know your quick changelog
style by heart.

> Speak to me how you like; you know I'll still love you. But be nicer
> to Brian and Usama.

Hmm. I was not aware that 'Folks, really.' qualifies as not nice
nowadays.

>> > +#endif /* CONFIG_SMP */
>>=20
>> Sigh, we should finally make CONFIG_SMP def_bool y ...
>
> Not today :)

Right, but it's overdue nevertheless to adjust with reality :)

>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (IS_ENABLED(CONFIG_X86_3=
2)) {
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0initial_stack=C2=A0 =3D idle->thread.sp;
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0smpboot_control =3D cpu;
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>>=20
>> Please remove the pointless brackets.
>
> I pondered that, but they only get added back again in the next patch.
> It just seemed like adding pointless churn.

Fair enough.

Thanks,

        tglx
