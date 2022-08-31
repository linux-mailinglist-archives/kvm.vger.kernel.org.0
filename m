Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F05A84E8
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiHaSCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiHaSCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:02:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6C6DD4F8
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VtEGFqNFaVRi34n1yQf6UqOdBA1xAo4BY3JxpBmhOn8=;
        b=II1b66XDklTjm7hcq3IafrXfYnowOIqa4vuI4rw4aMoQj+YxXxTzOYNqnAnXrh8YVc+MlZ
        QM2DapWzgb7guSEgNU/RjDnh/e9fgayjVt9boXRpDSWctpRKgBgFP4zO9Pn+H6BL8CHRVT
        NngPqMMjFoVR1bNQH4eQrHnvGTiPVBw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-V-8su9dNMTuROTa1Q7T0qQ-1; Wed, 31 Aug 2022 14:02:46 -0400
X-MC-Unique: V-8su9dNMTuROTa1Q7T0qQ-1
Received: by mail-io1-f72.google.com with SMTP id y10-20020a5d914a000000b00688fa7b2252so9130830ioq.0
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=VtEGFqNFaVRi34n1yQf6UqOdBA1xAo4BY3JxpBmhOn8=;
        b=6phA/1p6dLO45AsBeTvjB3BIV82LsY5ai15ZUplcSIOUs4EuIG8Gi8O+NqFrWsH+av
         99NEV8TQ56dsdPA6jHhmSL0e6fH/PcS4vNhwON0CwF4nr07J1KxTcNm81zawbtNLpAqI
         XC6SgrCJ93m3MrHoPpmlUF6HX5j4p6VVr96lMsbMimnqGfCDlWW2T0DTWJO9nuzVE2VK
         6G0a2jJevhDEa2of0Evy9HL9ZenUT1YRbRQ7FPs05g/EQi8fen8d3qWzxNlxQrUw2TZc
         65pVgM0A1GvSdp44UmynpFuxEujpf1CcdMozfHebFRsT8y6nTXhPJwMRedgwsa9GErf8
         e1dg==
X-Gm-Message-State: ACgBeo2Cxb8fGYfYecjefslfniOl7wSgJTUKQg1Bg8eortFDq4Q83XPw
        z3mXDXcfKEkAYTZ3HBGPvhpmYu3tKuVDF/eE9wkiJUOmHjGnG2iDvMpklr8tyR2RbPwNYk5/+HO
        twsvl62VVuo/p
X-Received: by 2002:a05:6638:1485:b0:348:b986:6e62 with SMTP id j5-20020a056638148500b00348b9866e62mr15361847jak.236.1661968965569;
        Wed, 31 Aug 2022 11:02:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Tqb1Qqo/P8+5hrHwTXUEeAqMPb/A74JJkWmlrvjtmbayrmYL0HKLEV1Mw41WyUm6gRAi6ng==
X-Received: by 2002:a05:6638:1485:b0:348:b986:6e62 with SMTP id j5-20020a056638148500b00348b9866e62mr15361837jak.236.1661968965365;
        Wed, 31 Aug 2022 11:02:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d6-20020a0566380d4600b00349e1d53faasm7039651jak.122.2022.08.31.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 11:02:44 -0700 (PDT)
Date:   Wed, 31 Aug 2022 12:02:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Message-ID: <20220831120231.320081f0.alex.williamson@redhat.com>
In-Reply-To: <Yw9/4h3mlN4LuBz8@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Yw9/4h3mlN4LuBz8@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 12:36:02 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Aug 31, 2022 at 08:42:17AM +0000, Tian, Kevin wrote:
> 
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index 503bea6c843d56..093784f1dea7a9 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -3,6 +3,14 @@
> > >   * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> > >   *     Author: Alex Williamson <alex.williamson@redhat.com>
> > >   */
> > > +#ifndef __VFIO_VFIO_H__
> > > +#define __VFIO_VFIO_H__
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/cdev.h>
> > > +#include <linux/module.h>  
> > 
> > Curious what is the criteria for which header inclusions should be
> > placed here. If it is for everything required by the definitions in
> > this file then the list is not complete, e.g. <linux/iommu.h> is
> > obviously missing.  
> 
> It isn't missing:
> 
> $ clang-14 -Wp,-MMD,drivers/vfio/.vfio_main.o.d -nostdinc -I../arch/x86/include -I./arch/x86/include/generated -I../include -I./include -I../arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I../include/uapi -I./include/generated/uapi -include ../include/linux/compiler-version.h -include ../include/linux/kconfig.h -include ../include/linux/compiler_types.h -D__KERNEL__ -Qunused-arguments -fmacro-prefix-map=../= -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Wno-format-security -std=gnu11 --target=x86_64-linux-gnu -fintegrated-as -Werror=unknown-warning-option -Werror=ignored-optimization-argument -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=none -m64 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mstack-alignment=8 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-u
 nwind-tables -fno-delete-null-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 -Wframe-larger-than=2048 -fno-stack-protector -Wimplicit-fallthrough -Wno-gnu -Wno-unused-but-set-variable -Wno-unused-const-variable -fomit-frame-pointer -fno-stack-clash-protection -Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wcast-function-type -fno-strict-overflow -fno-stack-check -Werror=date-time -Werror=incompatible-pointer-types -Wno-initializer-overrides -Wno-format -Wno-sign-compare -Wno-pointer-to-enum-cast -Wno-tautological-constant-out-of-range-compare -Wno-unaligned-access -I ../drivers/vfio -I ./drivers/vfio  -DMODULE  -DKBUILD_BASENAME='"vfio_main"' -DKBUILD_MODNAME='"vfio"' -D__KBUILD_MODNAME=kmod_vfio -c -o /tmp/jnk.o ../drivers/vfio/vfio.h
> [no error]
> 
> The criteria I like to use is if the header is able to compile
> stand-alone.

Is this stream of consciousness or is there some tooling for this? ;)

> > btw while they are moved here the inclusions in vfio_main.c are
> > not removed in patch8.  
> 
> ?  I'm not sure I understand this

I think Kevin is asking why these includes were not also removed from
vfio_main.c when adding them to vfio.h.  Thanks,

Alex

