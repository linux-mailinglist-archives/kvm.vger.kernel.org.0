Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B266C7445
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 00:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCWXst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 19:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCWXsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 19:48:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4046E187;
        Thu, 23 Mar 2023 16:48:41 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679615318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pfMy1WN4egsBlE9AThbnvQzL8RklY9yBTWSLXY9mvs=;
        b=ote8OolLcDXcpy9s28Dh2PsdN458b3hJGFsqGpPSCxLx7p+Kdk1xjwRog1qduHuxIkTtpF
        ByKy5X5+1FperpsP4ZdhzAAAJMCuV9S8/bOyoVPeaTeION3wB/P5fYUI1HlC5QrgrATvDW
        r9dxE1Q5RQhQOk/vXZEILbqV0bQ7KodBdFCGSGoXbS+csxCjBS/J/IbOsKR2tsfBNrY31q
        XCCboYxvA+q1fbYYb79M8ieWS0tK1vddhEDrxbdcsdZbzy9oRJxclB/ytAU2wOHaSWLOu0
        LWh09hR70huXpA2dPuXY0VtOqAhlZUPAzbTMV020pFE6zdnNjc5B6oI/O7c3OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679615318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pfMy1WN4egsBlE9AThbnvQzL8RklY9yBTWSLXY9mvs=;
        b=t4idkLr/NdbUlRWGI/+iTM913jHQmhGyPmtTNxDJ3m6rwsejkqLVbbvw8CpymWzBxGu8TU
        SG4hx0cx08zjgBAg==
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
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <47150207bfb76bb98aff678cf7c91f245e9f5dd9.camel@infradead.org>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
 <47150207bfb76bb98aff678cf7c91f245e9f5dd9.camel@infradead.org>
Date:   Fri, 24 Mar 2023 00:48:38 +0100
Message-ID: <87y1nn6nc9.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23 2023 at 22:49, David Woodhouse wrote:
> On Thu, 2023-03-23 at 23:36 +0100, Thomas Gleixner wrote:
>> There is no point in special casing this. All architectures can invoke
>> the CPUHP_BP_* states before CPUHP_BRINGUP_CPU for each to be brought up
>> CPU first. So this can be made unconditional and common exercised code.
>>=20
>
> There were three paragraphs in the commit message explaining why I
> didn't want to do that. It didn't work for x86 before I started, and I
> haven't reviewed *every* other architecture to ensure that it will work
> there. It was opt-in for a reason. :)

I noticed myself before reading your reply :)

>> Aside of that this dynamic state range is pretty pointless. There is
>> really nothing dynamic here and there is no real good reason to have
>> four dynamic parallel states just because.
>
> The original patch set did use more than one state; the plan to do
> microcode updates in parallel does involve doing at least one more, I
> believe.

I don't think so. The micro code muck can completely serialize itself
and does not need control CPU assistance if done right. If we go there
we have to fix that mess and not just proliferatng it with moar duct tape.

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Fully per AP serialized br=
ingup from here on. If the
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * architecture does no regis=
ter the CPUHP_BP_PARALLEL_STARTUP
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * state, this step sends the=
 startup IPI first.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>
> Not sure I'd conceded that yet; the APs do their *own* bringup from
> here, and that really ought to be able to run in parallel.

Somewhere in the distance future once we've

  1) sorted the mandatory synchronization points, e.g. TSC sync in the
     early bootup phase.

  2) audited _all_ AP state callbacks that they are able to cope with
     parallel bringup.

     That's a long road as there are tons of assumptions about the
     implicit CPU hotplug serialization in those callbacks.

     Just because it did not explode in your face yet does not mean this
     is safe.

     I just looked at 10 randomly picked AP online callbacks and found 5
     of them being not ready :)

Thanks,

        tglx


