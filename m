Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD574F0F16
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 07:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbiDDFsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 01:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiDDFsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 01:48:39 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E5832042
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 22:46:44 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e13so2350026ils.8
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 22:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2PyI5wE/9y9aF+w53ak3NL4bdwUIasxuc/+R7nGVlkM=;
        b=PxHyTiTYyZKrMuWxWAtFUKNTUBv0DkB5ESh3olcmowfb91vjP4mIB7ltmXbb2EO4Ie
         Hn0GeRK0D5M7MuTpjuO0c0ZlZ8iZQ/XmZtXmlP99/R0r96jXGsRC9Rg2Z7tyOjohujoK
         Exx+VXoicxCd8wiN4wdqkV57XoUl5gQK7+e9WVsQlGV/2nNKh7iP2ODGiWqdf17NlQWw
         O6YzGl8E4RjpQY1S3mcUEN4b2S/wkpOiqXJVrRFQGo55cLTpbOF4Kvj+c74BP58sbdSr
         CVSYMWo6Z1criwdhMT2FOZSupAaTY8VHQ4PyFm6dsg4GnoiusW8Ooh80FsqNa2CLMHh9
         04qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PyI5wE/9y9aF+w53ak3NL4bdwUIasxuc/+R7nGVlkM=;
        b=6+A0KK/ANb5KhAyQlt3irIjA9EJTRrQ+5DaXieKHUT5Tw3amTwK60sjCrHBeBAZrQk
         x9AbLQV0fF83HNL6PhsBK4V/zEB5xJ4fBKQ4wfksOgh5VTdQP9CUlUHpihhSPGXLk7g8
         ++lAyNSuXha4jssmEdfLzfKfplDVSXoGHts33gCZ7lv9FnZ5t7kxU2acCSjGPTnDN5He
         sr6bI8IBimlrFA0aTkpvmPyRO8nK1D5kRBvFiuaAEeRvy1NVPKF3jzVAyh4gqW4C6jS2
         54EBupUdmdJpbmgZ8aDX3vyN3WMX0QHM9x8iJw/p76T5BtIciQwG9ltYI1Z8jJK2HkkT
         /ycQ==
X-Gm-Message-State: AOAM530LBys2hT/MVEqrxMkbxVHVHQxRKPZdgs3+YVqsgX4+g1LGCDGV
        6gQJF5YQbQ92sdStOcLO7Nt+Yw==
X-Google-Smtp-Source: ABdhPJwk+57GkB2Zn+ajUSVOFh+5njhU0KQCOdF0/4uXoez1/cNjCep9/bJs6lDeVvXeVItIol/I2g==
X-Received: by 2002:a05:6e02:20c4:b0:2c9:a514:6a99 with SMTP id 4-20020a056e0220c400b002c9a5146a99mr5023931ilq.50.1649051203223;
        Sun, 03 Apr 2022 22:46:43 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h24-20020a6bfb18000000b006497692016bsm5828288iog.15.2022.04.03.22.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 22:46:42 -0700 (PDT)
Date:   Mon, 4 Apr 2022 05:46:39 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32
 bit guests
Message-ID: <YkqGP/OaKK7LpKF2@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-4-oupton@google.com>
 <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
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

Hi Reiji,

On Sun, Apr 03, 2022 at 09:45:15PM -0700, Reiji Watanabe wrote:
> On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
> >
> > To date KVM has not trapped ID register accesses from AArch32, meaning
> > that guests get an unconstrained view of what hardware supports. This
> > can be a serious problem because we try to base the guest's feature
> > registers on values that are safe system-wide. Furthermore, KVM does not
> > implement the latest ISA in the PMU and Debug architecture, so we
> > constrain these fields to supported values.
> >
> > Since KVM now correctly handles CP15 and CP10 register traps, we no
> > longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> > emulate reads with their safe values.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
> become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
> but it affects migration.  I'm not sure how much we should care about
> migration of the aarch32 guest though (and it will be resolved once ID
> registers become configurable anyway).

I believe userspace has been accessing the sanitised values of these
feature registers the entire time, so we should be OK on the UAPI side.

From the guest's perspective, I don't believe there is a meaningful
change. Even if the guest were to believe the value it sees in
ID_DFR0.PerfMon, it'll crash and burn on the first attempt to poke a PMU
register as we synthesize an UNDEF, right? At least now we cover our
tracks and ensure the vCPU correctly identifies itself to the guest.

This is, of course, unless I missed something painfully obvious :)

--
Thanks,
Oliver
