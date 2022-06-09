Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C039054417A
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 04:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiFICZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 22:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiFICZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 22:25:48 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A166CF7F
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 19:25:46 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w16so20452987oie.5
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 19:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sT97t32fGuh4Lagfso1CZFM0kPU0D0D1QyfmHoUG+44=;
        b=FlD7+FLEtlusX0WSzAljCqODKnZlDNVX6zv5nuensD+DAQfgYzSt6opmfIlf7wiJj/
         Nt9JN3V9g0iXXJa/8VFnUg/u00F18NaVVn/MlDaslGw9ZyQSz9n9Jt5XaxcOgTLhAdyE
         DtfJvnqM8qBfys3KsSCd8Vj5xAEVnLwqnAArYcaV2t21UcPTX1/crwi7Gesl5rfI/ecS
         Dq6AkM0gHNAl08qSLdpijFziD8wQmuCKIW5Wfk6GvY5s15NhwFOXMn4kABOfofyTFNDQ
         noRLBmIzBnbZGeEzC8txzKPBRXpWlJVBlEZiSn7+qR239uHAf4KFndoAdxxEHGT+6ryS
         at7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sT97t32fGuh4Lagfso1CZFM0kPU0D0D1QyfmHoUG+44=;
        b=KglICD7pFY6wiRee4Ngy/GUHynAzOWYqd1sPZx0DZ5cysua3alYBlleXiM8+VWvN8q
         IIqa0UcF4X6zHPaVrHaGrw8ZTls9wct/33DxsTiyLcRwlgzScAkqY7197oQtl4g0Cl1F
         skBVFA7Pu/+XicpqJItkiccxFE5mbE6AAyhxZqpLvB4Q1uMR+crqmep2pkwArSv70A6q
         EgX83HV+XuaAmnG5KLMo3On+MEYXlZz0y+Zpjn20SAyfAUp29Z2cGYZk1iB2tNCyy6pC
         w8+7n0coCosZMa3U1F/ZwWsft0ZSebTOXCXb1xLBRyPUvKhelSB54denbS/W4Mz6ScdG
         h5Ug==
X-Gm-Message-State: AOAM530/rSpfEXvntX/+dmnjJEvjd395N7MBtaHW7ngH+iwSYjJ2VQuq
        jpOJoMGN+eYa7oam3zPhXnYC9yq0Dlabwbs+pdBaIw==
X-Google-Smtp-Source: ABdhPJx6V/+rGfOAySSbcC5tiNalve3Vr1NpKeuTrCwESzAeUsSTl6Wm6kiZjM4IKoD0l0bTtA9RSQkatNz1vj8mXn0=
X-Received: by 2002:a05:6808:3198:b0:32b:a54:1238 with SMTP id
 cd24-20020a056808319800b0032b0a541238mr508612oib.16.1654741545717; Wed, 08
 Jun 2022 19:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-6-maz@kernel.org>
 <CAAeT=FyruEc5pDhdg0wOtFcV0EFUnhOVyt+o5BMfn5GsooM9Jw@mail.gmail.com> <87mtenzlzh.wl-maz@kernel.org>
In-Reply-To: <87mtenzlzh.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 8 Jun 2022 19:25:30 -0700
Message-ID: <CAAeT=Fwgt9Dv319C_Wr4=UEZJeW+pkSE__B3dB4du-Hq54U=ng@mail.gmail.com>
Subject: Re: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
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

Hi Marc,

> > > +#define vcpu_get_flag(v, ...)  __vcpu_get_flag(v, __VA_ARGS__)
> > > +#define vcpu_set_flag(v, ...)  __vcpu_set_flag(v, __VA_ARGS__)
> > > +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag(v, __VA_ARGS__)
> > > +
> > > +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> > > +
> > > +#define __flag_unpack(_set, _f, _m)    _f
> >
> > Nit: Probably it might be worth adding a comment that explains the
> > above two macros ? (e.g. what is each element of the triplets ?)
>
> How about this?
>
> /*
>  * Each 'flag' is composed of a comma-separated triplet:
>  *
>  * - the flag-set it belongs to in the vcpu->arch structure
>  * - the value for that flag
>  * - the mask for that flag
>  *
>  *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
>  * unpack_vcpu_flag() extract the flag value from the triplet for
>  * direct use outside of the flag accessors.
>  */

Looks good to me, thank you!
Reiji
