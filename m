Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974E451961D
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiEDDn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEDDnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:43:23 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C390428996
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:39:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id c125so308861iof.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TKFkaOZkalvLFPXwyy85GYdezcn8X//pTVrKI0zHMyM=;
        b=OKeMQH51cvKoQfQVe6saCkxUR73NoKar+XZu/9qav85QUB81nfSHCeoHN5ex2uOb//
         kO1M3kU546nhzKG8drhWWWIUs2t14S730C1HbWkI98KwrAgY1/vgN9VpljYTWsTGpYMT
         n40EgHXpIz0/SkKO51NFcsULQvGXL6ctkwg5DTTIAS2gYvCpejuSQQ4qph7SlokYXt9s
         VUvf8WdkLPYjIyQeFT1pil2GnBWaBey1n1lhrl6pQgJvg7/UckiVZ1X7UNBDOqmR4njo
         LBHY2e3LUD3qHU9CyE4PtJWxl3SB3/EAnWvg4FyKsiXUSQX++UDJY9f7JOtRyg/wBBgS
         UVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TKFkaOZkalvLFPXwyy85GYdezcn8X//pTVrKI0zHMyM=;
        b=SLnERfhrOdhJpD5qsFVwo5VVAY8w9qrrg7sEeQZRwpPmvl5azrEH7TkW8/hbmJ3TFq
         F80NTvIlqdx8hmxtaNgIyEMsjjvycxCdBGzSLT1oELJ7KMpDcX1mIZhrxWe83w7+sdOj
         XNiTnmYlR1+sZjrfgLzGeLjKemOvRIb6kdXDiFXKlAYP4rDifFganwTuiTqQF225sFMs
         tpCVxfLbD2QSZQWQvk5EYXIDG6aZEp/SN5RvqTDOkLEpmjhZXeQ9DJsgSjjJUb5vrLWD
         YHKAVEXyWfFvGBrok/TGjQE6GykG4Y38t/AvZRs/k5Q1IFSayHxUsw2TI1nl78y6AdYe
         Oj6Q==
X-Gm-Message-State: AOAM533Egk0yd5RCy/ZTR6HYLObHPXOD8fUD+Gd0aUOOb3cyQCaUWd87
        7NbCS16ziTUEikfiG7xosWyHuQ==
X-Google-Smtp-Source: ABdhPJwLTXJtAXiJwUCvEWggY3FV+wdRFZMRp+5BJmrk0AvQhZTFxdNQcILItIRCgxyMEkGbhuqhbA==
X-Received: by 2002:a05:6602:2427:b0:657:b2ff:89c5 with SMTP id g7-20020a056602242700b00657b2ff89c5mr7163783iob.26.1651635587956;
        Tue, 03 May 2022 20:39:47 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id x22-20020a029716000000b0032b3a781750sm4388413jai.20.2022.05.03.20.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 20:39:47 -0700 (PDT)
Date:   Wed, 4 May 2022 03:39:43 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services
 selection
Message-ID: <YnH1f2cXcpdKsA3q@google.com>
References: <20220502233853.1233742-1-rananta@google.com>
 <878rri8r78.wl-maz@kernel.org>
 <CAJHc60xp=UQT_CX0zoiSjAmkS8JSe+NB5Gr+F5mmybjJAWkUtQ@mail.gmail.com>
 <878rriicez.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rriicez.wl-maz@kernel.org>
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

On Tue, May 03, 2022 at 09:33:40PM +0100, Marc Zyngier wrote:
> On Tue, 03 May 2022 19:49:13 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Tue, May 3, 2022 at 10:24 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 03 May 2022 00:38:44 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > Continuing the discussion from [1], the series tries to add support
> > > > for the userspace to elect the hypercall services that it wishes
> > > > to expose to the guest, rather than the guest discovering them
> > > > unconditionally. The idea employed by the series was taken from
> > > > [1] as suggested by Marc Z.
> > >
> > > As it took some time to get there, and that there was still a bunch of
> > > things to address, I've taken the liberty to apply my own fixes to the
> > > series.
> > >
> > > Please have a look at [1], and let me know if you're OK with the
> > > result. If you are, I'll merge the series for 5.19.
> > >
> > > Thanks,
> > >
> > >         M.
> > >
> > Thank you for speeding up the process; appreciate it. However, the
> > series's selftest patches have a dependency on Oliver's
> > PSCI_SYSTEM_SUSPEND's selftest patches [1][2]. Can we pull them in
> > too?

Posted, BTW.

http://lore.kernel.org/kvmarm/20220504032446.4133305-1-oupton@google.com

> > 2. Patch-2/9, arm_hypercall.h, clear all the macros in this patch
> > itself instead of doing it in increments (unless there's some reason
> > that I'm missing)?
> 
> Ah, rebasing leftovers, now gone.
> 
> I've pushed an updated branch again, please have a look.

Series looks good with your additions. For the pile:

Reviewed-by: Oliver Upton <oupton@google.com>
