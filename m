Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71868DA86
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjBGOXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBGOW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:22:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2B115C86;
        Tue,  7 Feb 2023 06:22:54 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675779772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yPHwM89WlB9ksDyM5+4x220tQNsF9BYJ5JjFvG3NnA=;
        b=HLJGGT15vgpaLjvpgmwZfhjvsBW+gt8pqgIhwXidTp81MJDht8ARk5zJKTUUKOMV6rKbC5
        z0tbuZz39cwWl6rU6VAypXS4JDigB2GoMZhNrhhnk6S8sMNRK00oINTc8i9/uiLf7982Kz
        GXsaH/Ud43qRG+tnCKK8dhTm5EPPN44t8RSPcI2pTjeIzQzyS4sHbxO4/F6KxZQimIXbTA
        KtPMv6Dw50vBdTlm6M5cTjw+T+qdzATbuTr2zCtTDQYCSekMsRP81RhzNeiyqjaVqXL8Io
        kmsp0NLV2j+MA/60qxpa05i2M6YDAp0ssqm2dEwcnmaU5C1qY4b3lqXj13stVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675779772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yPHwM89WlB9ksDyM5+4x220tQNsF9BYJ5JjFvG3NnA=;
        b=BFDJbgRjxv6R2dl5QNUfFx0gfkUyK3n5Cze1Ilxv1quY+MI8JySPzOq8VP70f9D6Z7KhiD
        lIzToCVXZyTgZGAg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v6 01/11] x86/apic/x2apic: Fix parallel handling of
 cluster_mask
In-Reply-To: <d37f3af69df09ff542024ed93a37865b28dfa86e.camel@infradead.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-2-usama.arif@bytedance.com> <87a61qxtx0.ffs@tglx>
 <d37f3af69df09ff542024ed93a37865b28dfa86e.camel@infradead.org>
Date:   Tue, 07 Feb 2023 15:22:52 +0100
Message-ID: <87y1p9v9kz.ffs@tglx>
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

David!

On Tue, Feb 07 2023 at 10:57, David Woodhouse wrote:
> On Tue, 2023-02-07 at 00:20 +0100, Thomas Gleixner wrote:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * On post boot hotplug itera=
te over the present CPUs to handle the
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * case of partial clusters a=
s they might be presented by
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * virtualization.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for_each_present_cpu(cpu_i) {
>
>
> So... if this CPU was *present* at boot time (and if any other CPU in
> this cluster was present), it will already have a cluster_mask.
>
> Which means we get here in two cases:=20
>
>  =E2=80=A2 This CPU wasn't actually present (was just 'possible') at boot=
 time.
>    (Is that actually a thing that happens?)

It happens on systems which support physical hotplug and AFAIK also
virtualization has support for "physical" hotplug.

The same is true the other way round on phsyical unplug. Then the CPU
is removed from present but is still set in possible.

>  =E2=80=A2 This CPU was present but no other CPU in this cluster was actu=
ally
>    brought up at boot time so the cluster_mask wasn't allocated.

Correct.

> The code looks right, I don't grok the comment about partial clusters
> and virtualization, and would have worded it something along the above
> lines?

My worry was that virtualization might be able to phsyically hotplug
partial clusters. Whether that's possible I don't know, but in context
of virtualization I always assume the worst case.

Thanks,

        tglx
