Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5226F38F7
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 22:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjEAUDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 16:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjEAUDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 16:03:30 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425C30D7
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 13:03:15 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3311833ba3dso27855ab.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 13:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682971394; x=1685563394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncPMFJWjxPt+XbGukABrG3rR4raTB5TkPwvXjaUh97c=;
        b=fC7ZmFxc2EKJlzzMsV56h/dvO6y94huqT2qDLKhJoJjuRtX+/qtvuQ44KIK5VaADUn
         4mSXUr0pi1ML4st+7xGGAebQYKRKXqyMDhIFOlu02Qyt6hcXNIJzzW1Q9aCGIFReMhjA
         A3aa5A6kludMdgiiK+fSszenZxm7e5XV9kOejxTycETkR1gddOv2BTCc7CuavRaTTlDX
         rxKmBTYqZZ750vLY64AIX1y6LJ3ue8zyJCW2fTbBO5QqYQD/yE6Jso26W3mXDbDcaASj
         d5o/Bp0aSquML+CKJBe3x7BpfDNfaqg5FO5laGpPOGKIcU4ivMdUehhEuU52kG6+igf+
         BHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682971394; x=1685563394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncPMFJWjxPt+XbGukABrG3rR4raTB5TkPwvXjaUh97c=;
        b=F9EioZ7pLzS2zG/flc6z9cF91dpmuNQrGdmKMZbitgFirBv3P0BaUUvwBVCcUaADxD
         u+snSGtLEJaIt2EJJBQP66PruMPW/XCGGFI4UeP1OxOm4Z8dN/HhcGNrFGD++iuUINel
         f/mz1Imnmx5YQ+EZu/kEwrlmKd8QG393Bpnozn47QIvd5f5cmDmRDRTjS3Oeanp910At
         9Smeiakp27ru0gf9DA3w1zjwyUScM1nXhJ1AQEbmZjHbuXNiw3WbqP77V51wGMX4oL+9
         ltV5HwrhPBpTXXLKaYtZZtz5CkjjQD6pv8Ql0p+9b1LXnMFbzMLuUI10z0ukJC77QVd3
         GRuQ==
X-Gm-Message-State: AC+VfDypoCs+I9cdm3kqnpqeTa7zJOVR3KAsTy0rftgI8jotgYSciefp
        jE/fumvQ1rcg+NODVMYPPVXv8ivFVSh7psKPEoRs4OwBJ9uKqb9JgF/a9A==
X-Google-Smtp-Source: ACHHUZ4mOqcBol9a7aUL2HJGF7iZNuBowzpznKYi1PO/4N4drhq8I1dQU7FdeKP2s2kAyv8awgW1LE9L/UdnmhHiUsQ=
X-Received: by 2002:a05:6e02:1648:b0:330:eb79:91ad with SMTP id
 v8-20020a056e02164800b00330eb7991admr50231ilu.9.1682971394269; Mon, 01 May
 2023 13:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com> <ZE/R1/hvbuWmD8mw@google.com>
In-Reply-To: <ZE/R1/hvbuWmD8mw@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 1 May 2023 13:03:03 -0700
Message-ID: <CALMp9eTa3OpmMY5_9fezDfBb4gjne2yrHxBnnkD4xG7AzWmw+A@mail.gmail.com>
Subject: Re: Latency issues inside KVM.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>,
        zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 1, 2023 at 7:51=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Sat, Apr 29, 2023, Robert Hoo wrote:
> > On 4/27/2023 8:38 PM, zhuangel570 wrote:
> > > - kvm_vm_create_worker_thread introduce tail latency more than 100ms.
> > >    This function was called when create "kvm-nx-lpage-recovery" kthre=
ad when
> > >    create a new VM, this patch was introduced to recovery large page =
to relief
> > >    performance loss caused by software mitigation of ITLB_MULTIHIT, s=
ee
> > >    b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b=
10
> > >    ("kvm: x86: mmu: Recovery of shattered NX large pages").
> > >
> > Yes, this kthread is for NX-HugePage feature and NX-HugePage in turn is=
 to
> > SW mitigate itlb-multihit issue.
> > However, HW level mitigation has been available for quite a while, you =
can
> > check "/sys/devices/system/cpu/vulnerabilities/itlb_multihit" for your
> > system's mitigation status.
> > I believe most recent Intel CPUs have this HW mitigated (check
> > MSR_ARCH_CAPABILITIES::IF_PSCHANGE_MC_NO), let alone non-Intel CPUs.
> > But, the kvm_vm_create_worker_thread is still created anyway, nonsense =
I
> > think. I previously had a internal patch getting rid of it but didn't g=
et a
> > chance to send out.
>
> For the NX hugepage mitation, I think it makes sense to restart the discu=
ssion
> in the context of this thread: https://lore.kernel.org/all/ZBxf+ewCimtHY2=
XO@google.com
>
> TL;DR: I am open to providng an option to hard disable the mitigation, bu=
t there
> needs to be sufficient justification, e.g. that the above 100ms latency i=
s a
> problem for real world deployments.

Whatever became of
https://lore.kernel.org/kvm/20220613212523.3436117-1-bgardon@google.com/?

> > As more and more old CPUs retires, I think NX-HugePage code will become=
 more
> > and more minority code path/situation, and be refactored out eventually=
 one
> > day.
>
> Heh, yeah, one day.  But "one day" is likely 10+ years away.  Intel disco=
ntinuing
> a CPU has practically zero relevance to KVM removing support a CPU, e.g. =
KVM still
> supports the original Core CPUs from ~2006, which were launched in 2006 a=
nd
> discontinued in 2008.
