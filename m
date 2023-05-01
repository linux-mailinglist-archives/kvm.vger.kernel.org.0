Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA8C6F3991
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 23:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjEAVMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 17:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjEAVL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 17:11:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE14E4E
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 14:11:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b54cd223dso3513965b3a.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 14:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682975517; x=1685567517;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4NYDhcVDTHLb54GnmbrT1cEeobyIv0/mON5sblk9zXo=;
        b=aLuTmJAomhq39XOO8ThaFuZcJVLT6R4H3DtxDoGspBPmJgaPK8YYQWFnm9FMNOhIfK
         LZXcDO3Tq2X++f9p98Wx54Q8x4uLu72EncED6U8r2RXDPvU4MdcgzEEJ1rEPOASravV9
         J6ZFRHjY312N7W/1a7GHoiYeY0sytfb1V48/ziLJvArwg5RGEXhNjlDXg3QsCoVtIz8C
         TCZXHbz+4qtO5dVSqs9j0pZpoYXyRhVNqprtyGI1tv/O7+YjEozIm/N8IryMZar9a3Td
         u7DUIdYzGVhnG0QwAZQLS4qFcabKwKd3V0XzvPJoi6x5P2d2RVFI5qb9NbvR9fvcGBOy
         lffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682975517; x=1685567517;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4NYDhcVDTHLb54GnmbrT1cEeobyIv0/mON5sblk9zXo=;
        b=Ow5YWM+5AqQ6cLCUyCPL9oKs5VBPweR+t6LLBONo34P1gaV+PuQoHDy9I77Jw7vOX/
         opK3mdO60Vx6FqbKJHj+CgGNFLQQEomIaHZ9DC3pWGZpePbp/oZ8lNdKz5V2WebE+J1m
         3xms3QZHLt42tRpVOMqBjQ7P3sXHip+kTzMpzD+wz18S4Dy8M8xoH8+Oep/9/Y+dYCk+
         zpolzxLFXsbfmPzb+2+AxNv/AWbfre8BtW2SS29aMdtc/jMWW4C3eqjYvEDQdUF6pZLZ
         syjSJkpCoDlkN62maORR+3A5bVvdFEDpMn4wC8Hnkul6/dEAG9jg3gp97l6ACgZoWOI0
         m+zw==
X-Gm-Message-State: AC+VfDw1rFZm58RNjVV3dC57pOm5Lx+m+++arBXjXyGlG9GJnmp8r/4A
        h3JfND6Yi3GYv8ibhJUdjg17t8Gw108=
X-Google-Smtp-Source: ACHHUZ7Hd8CMbbRi2Zv713yGh1cWPToaI5AWN4TSrUPlUzd3x920u2wbvO9DboNiqhdUvgtELnzLLc6go2s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2dc:b0:641:31b1:e78b with SMTP id
 b28-20020a056a0002dc00b0064131b1e78bmr2828834pft.6.1682975517090; Mon, 01 May
 2023 14:11:57 -0700 (PDT)
Date:   Mon, 1 May 2023 14:11:55 -0700
In-Reply-To: <CALMp9eTa3OpmMY5_9fezDfBb4gjne2yrHxBnnkD4xG7AzWmw+A@mail.gmail.com>
Mime-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com> <ZE/R1/hvbuWmD8mw@google.com>
 <CALMp9eTa3OpmMY5_9fezDfBb4gjne2yrHxBnnkD4xG7AzWmw+A@mail.gmail.com>
Message-ID: <ZFArG0WsL0e/bM+m@google.com>
Subject: Re: Latency issues inside KVM.
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>,
        zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 01, 2023, Jim Mattson wrote:
> On Mon, May 1, 2023 at 7:51=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Sat, Apr 29, 2023, Robert Hoo wrote:
> > > On 4/27/2023 8:38 PM, zhuangel570 wrote:
> > > > - kvm_vm_create_worker_thread introduce tail latency more than 100m=
s.
> > > >    This function was called when create "kvm-nx-lpage-recovery" kth=
read when
> > > >    create a new VM, this patch was introduced to recovery large pag=
e to relief
> > > >    performance loss caused by software mitigation of ITLB_MULTIHIT,=
 see
> > > >    b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b957=
2b10
> > > >    ("kvm: x86: mmu: Recovery of shattered NX large pages").
> > > >
> > > Yes, this kthread is for NX-HugePage feature and NX-HugePage in turn =
is to
> > > SW mitigate itlb-multihit issue.
> > > However, HW level mitigation has been available for quite a while, yo=
u can
> > > check "/sys/devices/system/cpu/vulnerabilities/itlb_multihit" for you=
r
> > > system's mitigation status.
> > > I believe most recent Intel CPUs have this HW mitigated (check
> > > MSR_ARCH_CAPABILITIES::IF_PSCHANGE_MC_NO), let alone non-Intel CPUs.
> > > But, the kvm_vm_create_worker_thread is still created anyway, nonsens=
e I
> > > think. I previously had a internal patch getting rid of it but didn't=
 get a
> > > chance to send out.
> >
> > For the NX hugepage mitation, I think it makes sense to restart the dis=
cussion
> > in the context of this thread: https://lore.kernel.org/all/ZBxf+ewCimtH=
Y2XO@google.com
> >
> > TL;DR: I am open to providng an option to hard disable the mitigation, =
but there
> > needs to be sufficient justification, e.g. that the above 100ms latency=
 is a
> > problem for real world deployments.
>=20
> Whatever became of
> https://lore.kernel.org/kvm/20220613212523.3436117-1-bgardon@google.com/?

That's merged, but disabling the mitigation for a single VM doesn't stop th=
e
worker thread (arguably that's a bug), let alone prevent creation of the wo=
rker
in the first place as KVM spawns the worker before the VM is exposed to
userspace.  I.e. there's no way for userspace to say "don't spawn workers, =
the
NX hugepage mitigation will *never* be enabled".
