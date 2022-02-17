Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1A4B97F1
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 05:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiBQFAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 00:00:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBQFAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 00:00:03 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBA82A5237
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 20:59:48 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id e79so2306196iof.13
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 20:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F7h05wJLlkd5cKPCrzT5cmv+Gs51c7pMwjtMHfEasy8=;
        b=JeRwhXto1AsObhVRUTqwhjiMHOtxzAZCvjPiDir8xsxC01QcimY1dXl70Z5Wao8BVy
         NIaFrKXr6LoAR8WwPkaseSWuc0MTYkFRvLt6jqD7jLAG5wjWFKHaHJZvSqYEXXX4TN/X
         wLstHHhAZIb41vrH4vf4MioIctOJQvHjp8JkOvT6UhVEVUhoTcBhskhQsCmR1gpEXkP6
         JGFDDh115Bov9D32ORFPDVhqfVJdbcaF5U8ptNt2RneMpFE7y4a5egZfR/eepqECcGTK
         tYjMcmuaTg0TkM3iqvWtY6+j9AK3TTbtYnh4EuyLjRt8RcRxXTgBBYW0U168NMCbM0eu
         1ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F7h05wJLlkd5cKPCrzT5cmv+Gs51c7pMwjtMHfEasy8=;
        b=AxC9Kk5bQcjdNSvyFr5wCvSoctTkKVy8MFqjRCMqqs56okLyYmc6PUdXUEN5FOiu31
         6xeWvKmG2UtSqv8JFLTYjgN5oK2B/LzmJE3nMe2XAaR3etY4p3kcKipfuKlVIMw9DaSF
         DE4syNCGkvY12j1LIhvuBO41COnS5D6YFpg3BQU0G8Uz9XEv+aUc2tgxaxGkihYqkglR
         Kh5tlYVBRne4Wt6owvQYKeZdibzfSzj1GpHUgmjk0aCKAHet24JA0Zge1vUUV0rSu3I4
         m73PS1QvZ+nBfX5oiCVhX4lVD0C8ii8TAIKwwgahxQ+ML4Nmvu7AAYF+H8G/JejQ+CB4
         wbuA==
X-Gm-Message-State: AOAM531rwS/Au+iVXKgVXJSKirPb23S6BSNyyKOZT9v5S5iDSdfHUGsk
        EndZSuIEmQVz4VPgpXTYsMHCKg==
X-Google-Smtp-Source: ABdhPJx2e0ngpL2dFp+kkfoL+F8ZeH+ZJbcUKIqGmyMNbZeBoGfK83hrgWHAGj8Qc1/3NWtu4Ct5Wg==
X-Received: by 2002:a05:6638:1315:b0:314:85c1:f99b with SMTP id r21-20020a056638131500b0031485c1f99bmr760926jad.269.1645073987780;
        Wed, 16 Feb 2022 20:59:47 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k2sm1418207iow.7.2022.02.16.20.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 20:59:47 -0800 (PST)
Date:   Thu, 17 Feb 2022 04:59:43 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <Yg3WP5HR9OJJMLj7@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-11-reijiw@google.com>
 <Ygv3q/+arejIWnzs@google.com>
 <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
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

On Tue, Feb 15, 2022 at 06:52:27PM -0800, Reiji Watanabe wrote:
> Hi Oliver,
> 
> Thank you for the review!
> 
> On Tue, Feb 15, 2022 at 10:57 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > expose the value for the guest as it is.  Since KVM doesn't support
> > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > expose 0x0 (PMU is not implemented) instead.
> > >
> > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > to 0x0 when it is 0xf.
> >
> > Definitely agree with the change in this patch. Do we need to tolerate
> > writes of 0xf for ABI compatibility (even if it is nonsensical)?
> > Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.
> 
> Hmm, yes, I think KVM should tolerate writes of 0xf so that we can
> avoid the migration failure.  I will make this change in v6.
> 
> Since ID registers are immutable with the current KVM, I think a live
> migration failure to a newer kernel happens when the newer kernel/KVM
> supports more CPU features (or when an ID register field is newly
> masked or capped by KVM, etc).  So, I would assume such migration
> breakage on KVM/ARM has been introduced from time to time though.
>

Indeed it has, but IMO migration breakage should really be avoided at
all costs. End of the day, its ABI breakage.

Unless folks feel otherwise, I would be in favor of just ignoring the
IMP_DEF write and setting the field value to NI instead. Allows VMs to
migrate onto newer kernels and fixes the KVM bug at the same time.

--
Oliver
