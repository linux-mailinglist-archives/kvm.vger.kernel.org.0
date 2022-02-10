Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D584B0524
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 06:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiBJFdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 00:33:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiBJFdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 00:33:53 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98D810C2
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 21:33:54 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso4459950pjh.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 21:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4S1PGlBITDbPfDHxEWfVav4BYHFT1sybX2IDUqfuWTQ=;
        b=isDaEpKYGvxkxAbKsHb9vCzaGtOkhUtqMKoKEgF+nkKbnZtS8+ac5cIFoVRR23suou
         GVcLttonHw8byyKbCHgqQ0YS8UDZ+WQkPQBf+7svOSZ7NojZkt3+H45Kl7kRIpSoawW2
         hRgvESlJS+kiKrWMJBAracoDlptVNsidTAYCHcsrI8pvYmmg2WLY5MFCmbAnCkBo7uzI
         S1U25BcrPqOG04jupyggHGdQBLvFa05TvdYN8SZ87q3tEgqOhdx4okHKJRZ3g24uFoaJ
         BsmhtRgY0YthsOyByDn65K7Uz879V77+rlGFxz9XCkn116Pnb+3C3ElFjDZrZP0WTz2S
         +FSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4S1PGlBITDbPfDHxEWfVav4BYHFT1sybX2IDUqfuWTQ=;
        b=Vb96tjb5QgpJ60qdE9Ug9l+rdETBnA00Z31n6fCmCJpAx4WGE9Rk0Jr17Mp0EV0epB
         APMAA3iFwFepQtrkVKJ7w9OybwUUsg03+eboIpe5ii38Sf6ECaNMrrTixCmWELgzTi3H
         EmIHU8VHb9OdBbl0v/4Uk7YU04aRhZ6W1bRByrR5KYJl+Nw65pSi4FCDPXkOpaer40dZ
         yrd4e4TVrLsngwc8aeFWM+hW2qIVqCBXh/i0+Sre8g8bU0NmdcGE7ld3l8mjNE0h4NQW
         fZiRQEWxae69xwRVczPCqCe/6vL2cGd6mw3YPP/0+FamZdjMZ8fo9QOzBEA9bhHDgBO0
         cxAA==
X-Gm-Message-State: AOAM533UqnrG4++CyD18NBHmdpgQ2/GJ/CHNAN/025j7i+uYNFfgIV0I
        AdCq5Nyrw2sTfDtdp+IXhCAVNmn8kX79bdBV2CdSIw==
X-Google-Smtp-Source: ABdhPJyOYpAB/1KVlL9BpGn1hBcrVObh/j/ZODwkPJefZgNp7E9L6Xi+YRMLTn6dQNZAMk+w8rpZ0mbxDKUleu0QqeE=
X-Received: by 2002:a17:90b:390a:: with SMTP id ob10mr1074103pjb.110.1644471234298;
 Wed, 09 Feb 2022 21:33:54 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-5-reijiw@google.com>
 <CA+EHjTxCWe2pFNhq+9gRUJ0RnjX4OcuV2WazDbProUaJE2ZTBg@mail.gmail.com>
 <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com> <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
In-Reply-To: <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 9 Feb 2022 21:33:38 -0800
Message-ID: <CAAeT=FyHGY3ypVQt_P-a8Mj8G_FMUtuwgdhos=DWV1SPeemC7A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/26] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
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

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > index 0a06d0648970..28d9bf0e178c 100644
> > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > @@ -116,6 +116,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> > > >         else
> > > >                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
> > > >
> > > > +       if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> > > > +               /* Set ID_AA64PFR0_EL1.GIC to 1 */
> > > > +               (void)kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
> > > > +                                    ID_AA64PFR0_GIC3, ID_AA64PFR0_GIC_SHIFT);
> > > > +
> > >
> > > If this fails wouldn't it be better to return the error?
> >
> > This should never fail because kvm_vgic_create() prevents
> > userspace from running the first KVM_RUN for any vCPUs
> > while it calls kvm_set_id_reg_feature().
> > So, I am thinking of adding WARN_ON_ONCE() for the return value
> > rather than adding an unnecessary error handling.
>
> Consider this to be a nit from my part, as I don't have any strong
> feelings about this, but kvm_vgic_create() already returns an error if
> there's a problem. So I don't think that that would be imposing any
> additional error handling.

That's true.  But, since this failure case cannot be caused by userspace
(but KVM's bug), I would still prefer using WARN_ON_ONCE.

Thanks,
Reiji
