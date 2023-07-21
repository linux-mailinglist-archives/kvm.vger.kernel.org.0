Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911AC75D775
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjGUW02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjGUW01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:26:27 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192FC30C0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:26:26 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1b730eb017bso1817759fac.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689978385; x=1690583185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7m+n/4kPcQ8zUcjCN2vOLWnAdBnZrg+UmoOCVsV4n4=;
        b=ujknAHLxN0WsIPlydVQYM+Y/k4oSdBcEbY5Biyl+cStG9d0TG1iIOUg6L/VBFKj2fl
         6Na1RO1xVKISKWvLNF6wQQUAcUeTszfdcg117wdBE79qQXJDv82MhwT450SMOKK3TiXe
         4ivbSf4B+rpMys7iO9cj7uI4XSq9ASLaIC4fN2TCj0txE/HO/XWp+xggHGMvxgeMqn18
         zng0bV+UeNkuWiIrSUl+B+G6lZ1tgLaFCaYoIPLdB/nPnrvcg6KUF9DEuHpq55OOAF7H
         o25cX3kDmymtYZ93XUz6uXtyA4pLI2N2wjmKIPioXNaKjpi4LrQNa0D1ck9uOqS0d+/i
         W59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689978385; x=1690583185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7m+n/4kPcQ8zUcjCN2vOLWnAdBnZrg+UmoOCVsV4n4=;
        b=K0eDHq5tnXkg+0evZhAFiQTEto0hTeS0l4MN5dQ2hf4ep+7yrUjh7QxwSf80uzJVtS
         RCyqF2FtgIhosjuZg3emno52HDY/Wgri1eqsQ0g5xJO5shi5Bam80W16kRYCK5mkIsha
         wGOVrEtaeVOG8G4LvLx/6Z9LGCQAhPpMDYWuHjDulpaRCNfLknAE1KXu6CJkRlxQobZ0
         hXFeEJorRQ/PutnXf4SAv87DjPbZkNPqStriyeeGz4NthdGbwfCWsUWNfcpiruhO4wzZ
         RPzWo5lmlo2efRKxacm9h6pr3guvJmUs0544rQW1VOHK8n0C0fYS+dklhlgv7WM2NSy3
         DLbA==
X-Gm-Message-State: ABy/qLa7CrM32iX/z8OxO+c9GofjYy06KcxVe51xxNGPkFpMbK+AWd4V
        cJ4ATrFoB4DVjLmHd3bNEzaQYT2UiPTOgDKfQMch3w==
X-Google-Smtp-Source: APBJJlHGXhlDsfyG3GBJldjVMGLG+6lRIWw+MxhcGXpiZ6sFJ1r0YYTJK1TuMIK+nAzfqaWJctcNDobBMpDe/hANCAE=
X-Received: by 2002:a05:6870:15c7:b0:1b4:4931:d579 with SMTP id
 k7-20020a05687015c700b001b44931d579mr3579287oad.8.1689978385274; Fri, 21 Jul
 2023 15:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-3-jingzhangos@google.com> <ZLr2GXAgj5Y/fdJw@linux.dev>
In-Reply-To: <ZLr2GXAgj5Y/fdJw@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 21 Jul 2023 15:26:13 -0700
Message-ID: <CAAdAUtjqwv3CDkxgH+rg7x2Qqfk=0SYfdf6037X5AMYU9atbAg@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] KVM: arm64: Reject attempts to set invalid debug
 arch version
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, Jul 21, 2023 at 2:18=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Jul 18, 2023 at 04:45:18PM +0000, Jing Zhang wrote:
> > From: Oliver Upton <oliver.upton@linux.dev>
> >
> > The debug architecture is mandatory in ARMv8, so KVM should not allow
> > userspace to configure a vCPU with less than that. Of course, this isn'=
t
> > handled elegantly by the generic ID register plumbing, as the respectiv=
e
> > ID register fields have a nonzero starting value.
> >
> > Add an explicit check for debug versions less than v8 of the
> > architecture.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> This patch needs to be broken up. You're doing a couple things:
>
>  1) Forcing the behavior of the DebugVer field to be FTR_LOWER_SAFE, and
>    adding the necessary check for a valid version
>
>  2) Changing KVM's value for the field to expose up to Debugv8p8 to the
>    guest.
>
> The latter isn't described in the changelog at all, and worse yet the
> ordering of the series is not bisectable. Changing the default value of
> the field w/o allowing writes breaks migration.
>
> So, please split this patch in two and consider stacking like so:
>
>  - Change #1 above (field sanitization)
>
>  - "KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1"
>
>  - Change #2 above (advertise up to v8p8)
>
> --
> Thanks,
> Oliver
Sure, I'll split it as you suggested.

Thanks,
Jing
