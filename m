Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BB47AB894
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbjIVRyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjIVRy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 13:54:26 -0400
Received: from out-202.mta1.migadu.com (out-202.mta1.migadu.com [IPv6:2001:41d0:203:375::ca])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2AA1BC3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:52:47 -0700 (PDT)
Date:   Fri, 22 Sep 2023 17:52:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695405165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6iWf57e0btlxCO8zs88JHQdmJ0JvNggT2Tp8hV4cPY=;
        b=JKN34yxrMcc59sr+QL6GDOj17uB5G6/J0/7c8MaJCND53PrNKYsnWNEI9iM+QvNA6iUOFV
        flpqdIg+/4qmIGlEdXgFxMmSko++7izrs4IlBuMC6AewOkD8LldjUkYFxZQsPVFeVdrHZq
        j3vebGTmLpkViWfnho5iRMtpsBPE+3U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Kristina Martsenko <kristina.martsenko@arm.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v10 06/12] KVM: arm64: Allow userspace to change
 ID_AA64ISAR{0-2}_EL1
Message-ID: <ZQ3UaYTsZ1lVeShQ@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-7-oliver.upton@linux.dev>
 <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 06:18:37PM +0100, Kristina Martsenko wrote:
> On 20/09/2023 19:33, Oliver Upton wrote:
> > Almost all of the features described by the ISA registers have no KVM
> > involvement. Allow userspace to change the value of these registers with
> > a couple exceptions:
> >
> >  - MOPS is not writable as KVM does not currently virtualize FEAT_MOPS.
> >
> >  - The PAuth fields are not writable as KVM requires both address and
> >    generic authentication be enabled.
> >
> >  - Override the kernel's handling of BC to LOWER_SAFE.
> >
> > Co-developed-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++-----------
> >  1 file changed, 30 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 10e3e6a736dc..71664bec2808 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1225,6 +1225,10 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
> >                       break;
> >               }
> >               break;
> > +     case SYS_ID_AA64ISAR2_EL1:
> > +             if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
> > +                     kvm_ftr.type = FTR_LOWER_SAFE;
> > +             break;
> >       case SYS_ID_DFR0_EL1:
> >               if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
> >                       kvm_ftr.type = FTR_LOWER_SAFE;
> 
> Nit: it shouldn't be necessary to override BC anymore, as it was recently fixed
> in the arm64 code:
>   https://lore.kernel.org/linux-arm-kernel/20230912133429.2606875-1-kristina.martsenko@arm.com/

Perfect, looks like that patch should go in 6.6 too. Thanks for the fix!

-- 
Thanks,
Oliver
