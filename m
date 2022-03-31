Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969344EDD7E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiCaPk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240262AbiCaPjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:39:12 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF7B1C8867
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:34:11 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id x4so29019630iop.7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R6qVglK0FzawAXT0u5ibNFLRdw4AR1UKBBbJVmhDGmw=;
        b=f12ZZUEl0m4XNN/vangV6Vr6v1IK2xC1y0f78ppu9bR4Qtu/4hbU7bfXFE6KbOoArQ
         +Mm0CuHBUdpXPTNte/WciKsKtHgb6w+Hj+7531DSKyEuvGGCRxUa+JKZv8FYwExwaG5X
         9ZPcXpqz9u1Y1KlPXSrsSFFR/YsngCCQzH9SC6PtB/ojuebV9c6LWk7VuM8qGbezBpM4
         XTv24iderEEW7syCge5Ihsvd+7Yr7pW2qpVV012o84iZ2D70X9Z6Wo/AyI5l13sOBDjP
         U0e0CqEyG8AO+aIRBSEyHHBdDO56V5rtfM9k+VWIAw0Bz+a3GBH18zLypYweYyUrXnrM
         Tq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6qVglK0FzawAXT0u5ibNFLRdw4AR1UKBBbJVmhDGmw=;
        b=AF6FsFz2zia0cJH5iFSngacWabuYXIKvVUT62yM2xRjGLHIGPJfrPa7Cq1T6+JPudj
         rm1H9P9a1GT97oUBhczoZLDEj3nSqvr6cT2dUWibYQuSn1AWm1yh+sU71DJqhiBAt/R8
         OWmOy/Qt6UC0lQ+w6IIGPFRwCkPxvTZodmUK2LV6z/0WQYMtKYreuzGnYRlUJNSNmKr2
         DrX8B3iYs1HYznzYQUpQmeCrtFggX1V374E+3cKE2ah8zpPMNyoFOG19hpZvjDDkK5OD
         GKfaC5GctgweTjgIa65xe97OZG1nw4Mc/Ikz/d+z9zytlyzg9ZLDPmG74gp/ovJVLOe2
         sbPw==
X-Gm-Message-State: AOAM530m706AMgXSz9r2jD4oRMVb+ScNxzP+CWz42YefXDr+fsh4mpyB
        fP1WeBL+LA435OUksjLpY1a2FA==
X-Google-Smtp-Source: ABdhPJyDekBrm8Mb4uDZ8bLm4Yo7RYoSABckPoxXi5s6USil5NnmuontTT10XVUc64Tr+EazrPyeFA==
X-Received: by 2002:a02:aa0b:0:b0:317:c63a:6625 with SMTP id r11-20020a02aa0b000000b00317c63a6625mr3224223jam.222.1648740848931;
        Thu, 31 Mar 2022 08:34:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id j9-20020a926e09000000b002c9f3388cd4sm1732964ilc.21.2022.03.31.08.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:34:08 -0700 (PDT)
Date:   Thu, 31 Mar 2022 15:34:04 +0000
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
Subject: Re: [PATCH 1/3] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
Message-ID: <YkXJ7JyycOZyo+Ry@google.com>
References: <20220329011301.1166265-1-oupton@google.com>
 <20220329011301.1166265-2-oupton@google.com>
 <CAAeT=FwR_hy3kYn2SgHELWb4F9mUmRemXWxOoiF=H23q-gzEjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FwR_hy3kYn2SgHELWb4F9mUmRemXWxOoiF=H23q-gzEjw@mail.gmail.com>
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

On Wed, Mar 30, 2022 at 10:45:35PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
> >
> > KVM currently does not trap ID register accesses from an AArch32 EL1.
> > This is painful for a couple of reasons. Certain unimplemented features
> > are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
> > architecture to v8.0. Additionally, we attempt to paper over
> > heterogeneous systems by using register values that are safe
> > system-wide. All this hard work is completely sidestepped because KVM
> > does not set TID3 for AArch32 guests.
> >
> > Fix up handling of CP15 feature registers by simply rerouting to their
> > AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
> > to fix up the oddball CP10 feature registers still.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 66 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 66 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index dd34b5ab51d4..30771f950027 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2339,6 +2339,65 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
> >         return 1;
> >  }
> >
> > +static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
> > +
> > +/**
> > + * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
> > + *                            CRn=0, which corresponds to the AArch32 feature
> > + *                            registers.
> > + * @vcpu: the vCPU pointer
> > + * @params: the system register access parameters.
> > + *
> > + * Our cp15 system register tables do not enumerate the AArch32 feature
> > + * registers. Conveniently, our AArch64 table does, and the AArch32 system
> > + * register encoding can be trivially remapped into the AArch64 for the feature
> > + * registers: Append op0=3, leaving op1, CRn, CRm, and op2 the same.
> > + *
> > + * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-bit
> > + * System registers with (coproc=0b1111, CRn==c0)", read accesses from this
> > + * range are either UNKNOWN or RES0. Rerouting remains architectural as we
> > + * treat undefined registers in this range as RAZ.
> > + */
> > +static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
> > +                                  struct sys_reg_params *params)
> > +{
> > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > +       int ret = 1;
> > +
> > +       params->Op0 = 3;
> 
> Nit: Shouldn't we restore the original Op0 after emulate_sys_reg() ?
> (unhandled_cp_access() prints Op0. Restoring the original one
>  would be more robust against future changes)
> 
> > +
> > +       /*
> > +        * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
> > +        * Avoid conflicting with future expansion of AArch64 feature registers
> > +        * and simply treat them as RAZ here.
> > +        */
> > +       if (params->CRm > 3)
> > +               params->regval = 0;
> > +       else
> > +               ret = emulate_sys_reg(vcpu, params);
> > +
> > +       /* Treat impossible writes to RO registers as UNDEFINED */
> > +       if (params->is_write)
> 
> This checking can be done even before calling emulate_sys_reg().
> BTW, __access_id_reg() also injects UNDEFINED when p->is_write is true.
> 
> > +               unhandled_cp_access(vcpu, params);
> > +       else
> > +               vcpu_set_reg(vcpu, Rt, params->regval);
> > +
> > +       return ret;
> > +}
> > +
> > +/**
> > + * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
> > + *                       AArch32 ID register.
> > + * @params: the system register access parameters
> > + *
> > + * Note that CP15 ID registers where CRm=0 are excluded from this check, as they
> > + * are already correctly handled in the CP15 register table.
> 
> I don't think this is true for all of the registers:)
> I think at least some of them are not trapped (TCMTR, TLBTR,
> REVIDR, etc), and I don't think they are handled in the CP15
> register table.

Thanks for the review! This patch was a bit sloppy and indeed skipped a
few steps in the comments. I believe the only register in CRm=0 that is
trapped is actually CTR, hence the others are not present in the table.

I'll send out a v2 soon that addresses your feedback and the other
embarrasing omissions on my end :)

--
Thanks,
Oliver
