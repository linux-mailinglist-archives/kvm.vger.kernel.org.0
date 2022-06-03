Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F6E53CC07
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiFCPKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiFCPKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEFEF50465
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654269027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iYU3e5m8RF0VXxiD80zMOE9S6+YyYcuvH15YvBlnICE=;
        b=JXmaDpSvFWYLiX55CF/QjgmHwLMrvdxRbl9uL+YDkL16rYwYAUSsE2BnKJjlfnVwU/3xUN
        r0gvN0Vtkq7VxX8lIeb0Pul9vkK93waFh+yAW1rzhm3cgDPKScM8Cjp0KbK3yyrMrYF9oM
        MHRDUsnUYSSquTL8DVVw7LftkKA9mjs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-yD2P7FBVMOythR_TiFXrJQ-1; Fri, 03 Jun 2022 11:10:26 -0400
X-MC-Unique: yD2P7FBVMOythR_TiFXrJQ-1
Received: by mail-ed1-f71.google.com with SMTP id a4-20020a056402168400b0042dc5b94da6so5664655edv.10
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 08:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iYU3e5m8RF0VXxiD80zMOE9S6+YyYcuvH15YvBlnICE=;
        b=gjfLH+AdynhgH4V3j9S/xab630G9dME7VJbEVQoPo40is6YLj5s3jUHXNcyS50qwED
         q0hlcCdI3ZdRn9SOUBg4ZHcorslCwaHZ+w/rYmoMaQbfG6w7DEdOw4mPKvaiA45JUOYC
         5yoqElaYeocimKGxvhyVAO3uFNlLtzGgFLPLnMkzSA8TAwKmBFI/xAY/XD2CGigrcuPH
         s0qtk8iiRtivgS8y2Wqmf8Zfh1pq2Tn81bUlLju8dyx5gKhplpVuXhokc1piJdgHhBAz
         FHjF7NZlqaEDXx1Yv7UTTGhGm8jhn2bDtxwtRTEO6AYzaA/Ssal+mVABYcCsnpi0h1+y
         BbrA==
X-Gm-Message-State: AOAM532C0VkBYPJEcqiQOI3y61tM2P+H4Or755isSu9ya7OvW7FhU2LD
        6y/f1QR9eFJIPSSs6fVz8iWcbnWjWi0DxmBlpano98qEymVmjlj9Cg1iH0fFkcBLuRNlcd1lb1S
        k++D2XROoi/Y/
X-Received: by 2002:a17:907:3ea0:b0:6ff:7d7a:480d with SMTP id hs32-20020a1709073ea000b006ff7d7a480dmr9111901ejc.750.1654269025486;
        Fri, 03 Jun 2022 08:10:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7CdP6/CeRiU5MD92xKXhvRUpbt9WLOWAAcgUKCfg9dc/UPs8q5Vb6UslJUsKEhFtU3O0+ew==
X-Received: by 2002:a17:907:3ea0:b0:6ff:7d7a:480d with SMTP id hs32-20020a1709073ea000b006ff7d7a480dmr9111882ejc.750.1654269025290;
        Fri, 03 Jun 2022 08:10:25 -0700 (PDT)
Received: from gator (cst2-175-76.cust.vodafone.cz. [31.30.175.76])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906694400b00703e09dd2easm2958407ejs.147.2022.06.03.08.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 08:10:24 -0700 (PDT)
Date:   Fri, 3 Jun 2022 17:10:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        alex.bennee@linaro.org
Subject: Re: [PATCH kvm-unit-tests] arm64: TCG: Use max cpu type
Message-ID: <20220603151022.dr4qv4xo2goaaokv@gator>
References: <20220603111356.1480720-1-drjones@redhat.com>
 <87v8ti7xah.fsf@redhat.com>
 <20220603131557.onhq5h5tt4f57vfn@gator>
 <87sfol98an.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfol98an.fsf@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 03:38:08PM +0200, Cornelia Huck wrote:
> On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:
> 
> > On Fri, Jun 03, 2022 at 02:21:10PM +0200, Cornelia Huck wrote:
> >> On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:
> >> 
> >> > The max cpu type is a better default cpu type for running tests
> >> > with TCG as it provides the maximum possible feature set. Also,
> >> > the max cpu type was introduced in QEMU v2.12, so we should be
> >> > safe to switch to it at this point.
> >> >
> >> > There's also a 32-bit arm max cpu type, but we leave the default
> >> > as cortex-a15, because compilation requires we specify for which
> >> > processor we want to compile and there's no such thing as a 'max'.
> >> >
> >> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> >> > ---
> >> >  configure | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/configure b/configure
> >> > index 5b7daac3c6e8..1474dde2c70d 100755
> >> > --- a/configure
> >> > +++ b/configure
> >> > @@ -223,7 +223,7 @@ fi
> >> >  [ -z "$processor" ] && processor="$arch"
> >> >  
> >> >  if [ "$processor" = "arm64" ]; then
> >> > -    processor="cortex-a57"
> >> > +    processor="max"
> >> >  elif [ "$processor" = "arm" ]; then
> >> >      processor="cortex-a15"
> >> >  fi
> >> 
> >> This looks correct, but the "processor" usage is confusing, as it seems
> >> to cover two different things:
> >> 
> >> - what processor to compile for; this is what configure help claims
> >>   "processor" is used for, but it only seems to have that effect on
> >>   32-bit arm
> >> - which cpu model to use for tcg on 32-bit and 64-bit arm (other archs
> >>   don't seem to care)
> >> 
> >> So, I wonder whether it would be less confusing to drop setting
> >> "processor" for arm64, and set the cpu models for tcg in arm/run (if
> >> none have been specified)?
> >>
> >
> > Good observation, Conny. So, I should probably leave configure alone,
> > cortex-a57 is a reasonable processor to compile for, max is based off
> > that.
> 
> Yes, it would be reasonable; however, I only see Makefile.arm put it
> into CFLAGS, not Makefile.arm64, unless I'm missing something here. But
> it doesn't hurt, either.

You're not missing anything, but I'd rather leave it set to something
than nothing.

> 
> > Then, I can select max in arm/run for both arm and arm64 tests
> > instead of using processor there.
> 
> Unless you want to be able to override this via -processor=
> explicitly... although I doubt that this is in common use.
> 

If we want to give users the ability to override the CPU QEMU uses, then
I think I'd rather they do it with an environment variable like they do
the QEMU version and accelerator. While changing to the max cpu in
arm/run I could also start checking a new variable (QEMU_CPU).

Thanks,
drew

