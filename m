Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7585AA818
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 08:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiIBGfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 02:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIBGfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 02:35:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BD9399F4
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662100512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yWS9iyryA8xlkFxtcc+dq5p3p67BtZeQdTh6Cr1MjxQ=;
        b=iJw17uhVtYiSC7KcG6h+EYBPCgv2/b0dTB9aUIH6z9+B869P1iksBHWy/LfOy9IwhmDx86
        tcgFiEbqCjwhQONjhvxhiTol8jcUcCylrfhbwMZEeQJY/hSRSrutiLQmhtc2B99WZL6ib0
        VzhW6CIEFQCt05pKaumWhuJwZqnnbUw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-g3_uUhByO_W9ISDnj2m8XA-1; Fri, 02 Sep 2022 02:35:05 -0400
X-MC-Unique: g3_uUhByO_W9ISDnj2m8XA-1
Received: by mail-ed1-f70.google.com with SMTP id c14-20020a05640227ce00b0043e5df12e2cso740650ede.15
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 23:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yWS9iyryA8xlkFxtcc+dq5p3p67BtZeQdTh6Cr1MjxQ=;
        b=naks4LMQaFfv7bHjqgk1P1Fexdpk2nOngqD/jOyJcnSqy2acchXgFcEHNQJOmZi4M5
         anZ1S2pV5P9jDGe/+AtjemxTn/aJPMlpZuYSfx/cS3JKrUlNxNeKer34Tl6k2IoI2QOc
         nZ+8J08OHnYD+9VWzyeaWoTVPzGI9NiOrSY1SYjFDHU6glPP4FLTArrDyHhr/oO4fhS0
         20rEcK6QNzhtbPggG016jf7EfwkWrkp2dDVIueTi3TKcCYmz+994hzyP6ft/G/W4s2kG
         dszei8CMJHYUXfQZyFQoyk3Ky2OhqUId1wkaddJKfxO49iyAzbRA43APYmtFcHlOR5R1
         +rEA==
X-Gm-Message-State: ACgBeo2ajv1/zIrFibmcxbFt3byoqwsgWr7rgO3oY+gpjH/oMe1c9FAw
        egAF8ZypVVyJJ18tbpwHSKMAtBY/A7kP1414Ucyuo3/W14fqYQFUp3TV79LgHSXvTswVehpJfk7
        1ES5uYkgR+2Ko
X-Received: by 2002:a17:907:6091:b0:731:37fb:bd9 with SMTP id ht17-20020a170907609100b0073137fb0bd9mr25738477ejc.219.1662100504497;
        Thu, 01 Sep 2022 23:35:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5AJH6A2uUVyWoNDSLQKHjWoU495ErlpPJhNeR17h6Wq/l0AmhjwX23XpZLKB+thgkQ1d2r1w==
X-Received: by 2002:a17:907:6091:b0:731:37fb:bd9 with SMTP id ht17-20020a170907609100b0073137fb0bd9mr25738464ejc.219.1662100504224;
        Thu, 01 Sep 2022 23:35:04 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id ds7-20020a0564021cc700b00445c0ab272fsm784424edb.29.2022.09.01.23.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 23:35:03 -0700 (PDT)
Date:   Fri, 2 Sep 2022 02:35:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220902021628-mutt-send-email-mst@kernel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
 <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
 <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 08:07:20AM +0200, Gerd Hoffmann wrote:
> On Fri, Sep 02, 2022 at 08:10:00AM +0800, Xiaoyao Li wrote:
> > On 9/2/2022 12:17 AM, Gerd Hoffmann wrote:
> > > On Thu, Sep 01, 2022 at 10:36:19PM +0800, Xiaoyao Li wrote:
> > > > On 9/1/2022 9:58 PM, Gerd Hoffmann wrote:
> > > > 
> > > > > > Anyway, IMO, guest including guest firmware, should always consult from
> > > > > > CPUID leaf 0x80000008 for physical address length.
> > > > > 
> > > > > It simply can't for the reason outlined above.  Even if we fix qemu
> > > > > today that doesn't solve the problem for the firmware because we want
> > > > > backward compatibility with older qemu versions.  Thats why I want the
> > > > > extra bit which essentially says "CPUID leaf 0x80000008 actually works".
> > > > 
> > > > I don't understand how it backward compatible with older qemu version. Old
> > > > QEMU won't set the extra bit you introduced in this series, and all the
> > > > guest created with old QEMU will become untrusted on CPUID leaf 0x80000008 ?
> > > 
> > > Correct, on old qemu firmware will not trust CPUID leaf 0x80000008.
> > > That is not worse than the situation we have today, currently the
> > > firmware never trusts CPUID leaf 0x80000008.
> > > 
> > > So the patches will improves the situation for new qemu only, but I
> > > don't see a way around that.
> > > 
> > 
> > I see.
> > 
> > But IMHO, I don't think it's good that guest firmware workaround the issue
> > on its own. Instead, it's better to just trust CPUID leaf 0x80000008 and
> > fail if the given physical address length cannot be virtualized/supported.
> > 
> > It's just the bug of VMM to virtualize the physical address length. The
> > correction direction is to fix the bug not the workaround to hide the bug.
> 
> I'm starting to repeat myself. "just trust CPUID leaf 0x80000008"
> doesn't work because you simply can't with current qemu versions.
> 
> I don't like the dance with the new bit very much either, but I don't
> see a better way without massive fallout due to compatibility problems.
> I'm open to suggestions though.
> 
> take care,
>   Gerd


I feel there are three major sources of controversy here

0. the cover letter and subject don't do such a good job
   explaining that what we are doing is just telling guest
   CPUID is not broken. we are not exposing anything new
   and not exposing host capability to guest, for example,
   if cpuid phys address is smaller than host things also
   work fine.

1. really the naming.  We need to be more explicit that it's just a bugfix.

2. down the road we will want to switch the default when no PV. however,
   some hosts might still want conservative firmware for compatibility
   reasons, so I think we need a way to tell firmware
   "ignore phys address width in CPUID like you did in the past".
   let's add a flag for that?
   and if none are set firmware should print a warning, though I
   do not know how many people will see that. Maybe some ;)

along the lines of:

/*
 * Old KVM hosts often reported incorrect phys address width,
 * so firmware had to be very conservative in its use of physical
 * addresses. 
 * One of the two following flags should be set.
 * If none are set firmware is for now conservative, but that will
 * likely change in the future, hosts should not rely on that.
 */
/* 
/* KVM with non broken phys address width should set this flag
 * firmware will be allowed to use all phys address bits
 */
#define KVM_BUG_PHYS_ADDRESS_WIDTH_NONBROKEN 1
/*
 * Force firmware to be very conservative in its use of physical
 * addresses, ignoring phys address width in CPUID.
 * Helpful for migration between hosts with different capabilities.
 */
#define KVM_BUG_PHYS_ADDRESS_WIDTH_BROKEN 2

-- 
MST

