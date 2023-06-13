Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F8D72D66B
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 02:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbjFMA11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 20:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbjFMA1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 20:27:13 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75982171C
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 17:26:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b1b51ec3e9so83985ad.0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686616000; x=1689208000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sG+y868fGGwtVP8PKGF9VF3f/ok7RNLP2cQ05nH3HUE=;
        b=iWHBXILMJIPATpHcRZR4K1vDWcdjC9GrHG/2SCQKB+qQux//FBSWKENP5iHy2ZTKSK
         lexK9lzm24crVVGD/M+6lGwOghCYJPsk6VJGNt6JOJO8Vb85Rziw+Xo17R12cN9bJczB
         Iw20rMMwG6iReqNa6VmAdNg5LOo0KPTgycf9hY+AbaXLHOoZT70xB/lFaWt46aWw8C2f
         sOx+UHc+HxE8tjb8+si1A91i2C+v4VNATOVwsZjf3UEMTWXRnid6hURKa2jwf1PG1TNA
         IRPQLqwoHzdideu67RL8A3Q8sivQ1F5h4Hcy2NSmFagKG7LWbgwYqP/Mgdawax0TPilF
         xDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616000; x=1689208000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sG+y868fGGwtVP8PKGF9VF3f/ok7RNLP2cQ05nH3HUE=;
        b=TTIxx9/nE7cuSrbqYZjrfDSmgjtA+dHKTSbJsHoGDZ7Oi0B3lqz9MvXVxNA1aMor71
         4vNZl4c3ZABWeRBkCZaVWKjqm7FOqvvun5TXpayfGCITdv+N+viEwYuZuHpYUpnUx2+Y
         vACs6dlgnKItePZSsFGjYlSpfvoJF0gBQwWFDGamSX4LsVoyo996har5m2m46pr1PkM6
         tVe0u7w6lYsu2ngP6n4M0yXKhCrgT9tAN5p8W/ZdyFbNYqh+l+Kb3h7bXzoApkyQxpZt
         f45Df37eVlYNtlsDWZzdd8albJSI6xzygPKuFWtFMQrefGRE8m9y8nI+wNMc80PDngtq
         q0fw==
X-Gm-Message-State: AC+VfDzOo01ctdbBDD+gCdBb5RB7FRPrDRrSDqfdftUmHm7NC6A/jdX6
        1Z/7JkR/CHUW/4uGTNACQtFqGw==
X-Google-Smtp-Source: ACHHUZ5JkU/ii+XmIgB87RwAT7Cx/A9282/kfWxND7P1Sgc1Ov+FJ2HY/A4GhuBLgDV2fuWre9y5tQ==
X-Received: by 2002:a17:903:22c6:b0:1b1:b2a9:f256 with SMTP id y6-20020a17090322c600b001b1b2a9f256mr6266plg.1.1686615999648;
        Mon, 12 Jun 2023 17:26:39 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b001af98dcf958sm8841656plg.288.2023.06.12.17.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 17:26:38 -0700 (PDT)
Date:   Mon, 12 Jun 2023 17:26:33 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <20230613002633.gdttlmn5bnkr4l5i@google.com>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
 <ZIdzxmgt8257Kv09@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIdzxmgt8257Kv09@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 09:36:38PM +0200, Oliver Upton wrote:
> On Sun, Jun 11, 2023 at 09:01:05AM -0700, Reiji Watanabe wrote:
> 
> [...]
> 
> > > Suppose KVM is running on a v3p5+ implementation, but userspace has set
> > > ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> > > the preceding line would advertise the STALL_SLOT event, and KVM fails
> > > to mask it due to the ID register value. The fact we do not support the
> > > event is an invariant, in the worst case we wind up clearing a bit
> > > that's already 0.
> > 
> > As far as I checked ArmARM, the STALL_SLOT event can be supported on
> > any PMUv3 version (including on v3p0).  Assuming that is true, I don't
> > see any reason to not expose the event to the guest in this particular
> > example. Or can the STALL_SLOT event only be implemented from certain
> > versions of PMUv3 ?
> 
> Well, users of the event don't get the full picture w/o PMMIR_EL1.SLOTS,
> which is only available on v3p4+. We probably should start exposing the
> register + event (separate from this change).
> 
> > > This is why I'd suggested just unconditionally clearing the bit. While
> > 
> > When the hardware supports the STALL_SLOT event (again, I assume any
> > PMUv3 version hardware can support the event), and the guest's PMUVer
> > is older than v3p4, what is the reason why we want to clear the bit ?
> 
> What's the value of the event w/o PMMIR_EL1? I agree there's no

I agree that the value of the event w/o PMMIR_EL1 is pretty limited.


> fundamental issue with letting it past, but I'd rather we start
> exposing the feature when we provide all the necessary detail.

To confirm, are you suggesting to stop exposing the event even on hosts
w/o PMMIR_EL1 until KVM gets ready to support PMMIR_EL1 ?
(guests on those hosts won't get PMMIR_EL1 in any case though?)
Could you please explain why ?

Perhaps I think I would rather keep the code as it is?
(since I'm simply not sure what would be the benefits of that)

Thank you,
Reiji
