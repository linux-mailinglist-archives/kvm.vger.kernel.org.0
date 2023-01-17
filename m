Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D0866E418
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjAQQwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbjAQQvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:51:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8A51E1F6
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673974261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M4our3rLiepemZ3k4+HYbKuv18su20d4pbNBOR9XAVk=;
        b=Vehc89UhUrMxWIA/s1hTkd036RNW+hPlNU4HGVNN9ZhVKQ5VGYIFluzdJ5CkcScw1Hii2B
        xVpBwznMM2SzxL+7XUV3aWH6Hkw+dGEtjkLXDzFnJPw1KQdvY/N0yYeDLIGnOhBDUsBgSQ
        BGn4ujv6y2sGikh86GZknGytIvgSKco=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-458-0ZVwEjdZNO-LNGcjOcDXDg-1; Tue, 17 Jan 2023 11:51:00 -0500
X-MC-Unique: 0ZVwEjdZNO-LNGcjOcDXDg-1
Received: by mail-wm1-f69.google.com with SMTP id p1-20020a05600c1d8100b003daff82f5edso2420911wms.8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 08:50:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4our3rLiepemZ3k4+HYbKuv18su20d4pbNBOR9XAVk=;
        b=jkYu0D3saLBw2tublq4YBSdi54aLr8BQ95uE76K5Gw6m0FCsXFi1cjtFuEgplEudhM
         pZdyep9R02vr3E2ZkS204RFMv3mZE/vNrVGP4r3u6kI4qhKYJizDfS/VAM2MoluNCqA7
         +0JDG43cWUAR8YjGqy2MkUUKHNiAzh7mdtGtzYAB8jvnYNbcnmGbSLHyBHLYQ9yPCtYV
         +OPM+kiPFwK6v2dAIwBOKiCuiDaSShXDkImVKqDgR2Kk8ixK5IzkvtA6L0Be+4V6jMBU
         FXEZu8smiJxDFpi/zRd5KmYLP4RXrk7B4Er/pXSwsEPgRMYOdYttCT7Y0m6KBRjgI3Cz
         EIgw==
X-Gm-Message-State: AFqh2kqPYw9x+nisibAKFtxW4s3xthFalBZvCbfQFdCb+CA6JDY0lcjQ
        lRp0hfUJPhzedxSfqoy9iZ3iUyOCi4cIfHasghlI3lnDCpxSyczB2eRqOuxFpczxdxzvLdpYt7y
        QfPwKw6+AuSz3
X-Received: by 2002:a05:600c:2d05:b0:3d0:85b5:33d3 with SMTP id x5-20020a05600c2d0500b003d085b533d3mr3633589wmf.16.1673974257792;
        Tue, 17 Jan 2023 08:50:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsF4b/WLK+ctZ2I6ik5h/BH6C3iKNHJxEcOMeOdeW5j4eyliVaky6ftIOzaBIhj3X0P/E8XYQ==
X-Received: by 2002:a05:600c:2d05:b0:3d0:85b5:33d3 with SMTP id x5-20020a05600c2d0500b003d085b533d3mr3633577wmf.16.1673974257579;
        Tue, 17 Jan 2023 08:50:57 -0800 (PST)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id p10-20020a1c544a000000b003db0647645fsm2809480wmi.48.2023.01.17.08.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 08:50:57 -0800 (PST)
Date:   Tue, 17 Jan 2023 16:50:55 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
Message-ID: <Y8bR7xrsCMr5z6xI@work-vm>
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Wed, 11 Jan 2023 at 16:13, Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > Introduce a new cpu feature flag to control MTE support. To preserve
> > backwards compatibility for tcg, MTE will continue to be enabled as
> > long as tag memory has been provided.
> >
> > If MTE has been enabled, we need to disable migration, as we do not
> > yet have a way to migrate the tags as well. Therefore, MTE will stay
> > off with KVM unless requested explicitly.
> >
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  docs/system/arm/cpu-features.rst |  21 +++++
> >  hw/arm/virt.c                    |   2 +-
> >  target/arm/cpu.c                 |  18 ++---
> >  target/arm/cpu.h                 |   1 +
> >  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
> >  target/arm/internals.h           |   1 +
> >  target/arm/kvm64.c               |   5 ++
> >  target/arm/kvm_arm.h             |  12 +++
> >  target/arm/monitor.c             |   1 +
> >  9 files changed, 181 insertions(+), 13 deletions(-)
> >
> > diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> > index 00c444042ff5..e278650c837e 100644
> > --- a/docs/system/arm/cpu-features.rst
> > +++ b/docs/system/arm/cpu-features.rst
> > @@ -443,3 +443,24 @@ As with ``sve-default-vector-length``, if the default length is larger
> >  than the maximum vector length enabled, the actual vector length will
> >  be reduced.  If this property is set to ``-1`` then the default vector
> >  length is set to the maximum possible length.
> > +
> > +MTE CPU Property
> > +================
> > +
> > +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> > +presence of tag memory (which can be turned on for the ``virt`` machine via
> > +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> > +proper migration support is implemented, enabling MTE will install a migration
> > +blocker.
> > +
> > +If not specified explicitly via ``on`` or ``off``, MTE will be available
> > +according to the following rules:
> > +
> > +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
> > +  preserves the behaviour prior to introduction of the feature.
> > +
> > +* When KVM is used, MTE will default to off, so that migration will not
> > +  unintentionally be blocked.
> > +
> > +* Other accelerators currently don't support MTE.
> 
> Minor nits for the documentation:
> we should expand out "if and only if" -- not everybody recognizes
> "iff", especially if they're not native English speakers or not
> mathematicians.
> 
> Should we write specifically that in a future QEMU version KVM
> might change to defaulting to "on if available" when migration
> support is implemented?

Please make sure if you do something like that, that the failure
is obious; 'on if available' gets messy for things like libvirt
and higher level tools detecting features that are available and
machines they can migrate to.

Dave

> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

