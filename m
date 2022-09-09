Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5315B34FD
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIIKP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiIIKP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:15:56 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D60129C6C;
        Fri,  9 Sep 2022 03:15:55 -0700 (PDT)
Date:   Fri, 9 Sep 2022 11:15:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662718554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UWf75u93hFnHokSkmXHPMg8FKyuqd4msKp/yEz7C7Ao=;
        b=MTo2cIazKhJL+OTHp3ysffg8vodSCAed8X2h3DOACc71oK2aqbBLC8NVrUh6Y96fLISHKg
        RHr3qPWaAmutt9oyx7mVi3or4pcgVp1Ros6ZN4U6x/7bf6jP/xluVrOBnUw1XFK9aJt0ce
        1VVctsUI4WfaWLRjrfom8jZgC+S/zdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
Message-ID: <YxsSU2Rwdc2sO3IJ@google.com>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-7-oliver.upton@linux.dev>
 <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Tue, Sep 06, 2022 at 09:52:53PM -0700, Reiji Watanabe wrote:

[...]

> >         /* CRm=3 */
> > -       ID_SANITISED(MVFR0_EL1),
> > -       ID_SANITISED(MVFR1_EL1),
> > -       ID_SANITISED(MVFR2_EL1),
> > +       AA32_ID_SANITISED(MVFR0_EL1),
> > +       AA32_ID_SANITISED(MVFR1_EL1),
> > +       AA32_ID_SANITISED(MVFR2_EL1),
> >         ID_UNALLOCATED(3,3),
> > -       ID_SANITISED(ID_PFR2_EL1),
> > +       AA32_ID_SANITISED(ID_PFR2_EL1),
> >         ID_HIDDEN(ID_DFR1_EL1),
> 
> Perhaps it might be better to handle ID_AFR0_EL1 and ID_DFR1_EL1
> in the same way as the other AArch32 ID registers for consistency ?
> (i.e. treat them RAZ/USER_WI instead of RAZ if kvm_supports_32bit_el0()
>  is false instead of RAZ)

Thanks for having a look. I stopped short of treating these registers as
RAZ/USER_WI since an attempted nonzero write to either of these
registers is a userspace bug (KVM always advertised 0).

As the ABI isn't busted for these registers I'd prefer to leave it in
place. Having said that, I'm not too strongly motivated in either
direction.

--
Thanks,
Oliver
