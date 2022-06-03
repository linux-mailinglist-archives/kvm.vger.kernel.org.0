Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E353CA88
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244570AbiFCNQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240900AbiFCNQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:16:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED5CB2DABE
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 06:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654262162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MH2scvBBwX2fuow843mcd5jaHPxh8wTpF/D08FcZ/58=;
        b=Ehg/8kGSxcW5joG5Q8HaqYzgmWRk1KlxFmenbuOTt34YjjWOeNluqjJAIZ5Mz16z3rubzB
        zZT7kvcn03dzRpi2ezbOIeoyIj5IGPa6EXM5SfZFNkycoswii17LulC66Vz8Y1rhLqLA0r
        Mij0GSyVrb4sKiQgsAYkX43xzkJF1PM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-eFARp6-rNZCZ_GoXroFwmQ-1; Fri, 03 Jun 2022 09:16:00 -0400
X-MC-Unique: eFARp6-rNZCZ_GoXroFwmQ-1
Received: by mail-ed1-f71.google.com with SMTP id g3-20020a056402320300b0042dc956d80eso5429574eda.14
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 06:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MH2scvBBwX2fuow843mcd5jaHPxh8wTpF/D08FcZ/58=;
        b=aubFzQ4lRA+gWKrutsTfo7mUq8xj45AUjzYmB1Yk3hmuUDu8NDSQ7LsvybO+CNkWih
         JeuBf2eGY/xf4IhX11ZqjaMRkdjbnnWy4gWvGJBlwfh4lQx2LR8cooQQwzYTnSWC2Dew
         x47YTMupejAL4twHTVIXBs9BXNCxGWiPPghGjuTEugeqgIZsXwvxl+DcZVyTu5dl53+H
         jFZPObi+ENFcWz5j0wzjaGuPipTK6o9TUrMiOkPeZYiiqmR/oLhKnfq+7nyh14q3uyT7
         vJJSuQ1eXDRpjQ8uQmMomlaetg3Yam0bmNwRgueBn2qqHgHxYztkeEIiRqa3IRoNEkUD
         dTog==
X-Gm-Message-State: AOAM5319vM5iCuXTqhzpzty3XmfavH/erzucU9zEVLIw1bAYoV9nGRJ6
        O/Uku9j18w3/FPF7zHpxyHRb8Vx954P5dkEAayTrB2KsdfG+mD1v7XN8PqF9mAuSOi1fVxaJ6P6
        20MVGdYj7N/Qw
X-Received: by 2002:a17:906:7309:b0:6f5:ea1:afa with SMTP id di9-20020a170906730900b006f50ea10afamr8534163ejc.170.1654262159837;
        Fri, 03 Jun 2022 06:15:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz79ueKCiWsLFOON/G0BcUne2EIFwbuu9JFxJApJ4p5WvovOxGiq9XIOe53FbkqghLv6bJ7lA==
X-Received: by 2002:a17:906:7309:b0:6f5:ea1:afa with SMTP id di9-20020a170906730900b006f50ea10afamr8534151ejc.170.1654262159651;
        Fri, 03 Jun 2022 06:15:59 -0700 (PDT)
Received: from gator (cst2-175-76.cust.vodafone.cz. [31.30.175.76])
        by smtp.gmail.com with ESMTPSA id g9-20020aa7c849000000b0042a2d9af0f8sm3848539edt.79.2022.06.03.06.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 06:15:59 -0700 (PDT)
Date:   Fri, 3 Jun 2022 15:15:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        alex.bennee@linaro.org
Subject: Re: [PATCH kvm-unit-tests] arm64: TCG: Use max cpu type
Message-ID: <20220603131557.onhq5h5tt4f57vfn@gator>
References: <20220603111356.1480720-1-drjones@redhat.com>
 <87v8ti7xah.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8ti7xah.fsf@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 02:21:10PM +0200, Cornelia Huck wrote:
> On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:
> 
> > The max cpu type is a better default cpu type for running tests
> > with TCG as it provides the maximum possible feature set. Also,
> > the max cpu type was introduced in QEMU v2.12, so we should be
> > safe to switch to it at this point.
> >
> > There's also a 32-bit arm max cpu type, but we leave the default
> > as cortex-a15, because compilation requires we specify for which
> > processor we want to compile and there's no such thing as a 'max'.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  configure | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/configure b/configure
> > index 5b7daac3c6e8..1474dde2c70d 100755
> > --- a/configure
> > +++ b/configure
> > @@ -223,7 +223,7 @@ fi
> >  [ -z "$processor" ] && processor="$arch"
> >  
> >  if [ "$processor" = "arm64" ]; then
> > -    processor="cortex-a57"
> > +    processor="max"
> >  elif [ "$processor" = "arm" ]; then
> >      processor="cortex-a15"
> >  fi
> 
> This looks correct, but the "processor" usage is confusing, as it seems
> to cover two different things:
> 
> - what processor to compile for; this is what configure help claims
>   "processor" is used for, but it only seems to have that effect on
>   32-bit arm
> - which cpu model to use for tcg on 32-bit and 64-bit arm (other archs
>   don't seem to care)
> 
> So, I wonder whether it would be less confusing to drop setting
> "processor" for arm64, and set the cpu models for tcg in arm/run (if
> none have been specified)?
>

Good observation, Conny. So, I should probably leave configure alone,
cortex-a57 is a reasonable processor to compile for, max is based off
that. Then, I can select max in arm/run for both arm and arm64 tests
instead of using processor there.

Thanks,
drew

