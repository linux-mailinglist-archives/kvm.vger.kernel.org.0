Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BF2622119
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiKIA7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiKIA7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:59:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43F5DEC0
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667955522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iAHYPLXzmvZKn2PzWyCXwAfZsv7nq/9FeOgM42T53go=;
        b=BkKByoq+MuNzKFRqyEuGxh5iEr2W/qDgL6TONDQB/rtrIQ6WR3w+FpeabAb7dra9kbYPj8
        O2FCYp3iKeKd+3VPp0LA/VpStDmlQ+eS1sTVKNpeXedaSyqPXIV4YbhjljnlBbteqBeyaF
        lL7thI5s5/3s+K8UURF3odRkE5640BQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-YngM_vxsMyKUmFmqpDkPWg-1; Tue, 08 Nov 2022 19:58:41 -0500
X-MC-Unique: YngM_vxsMyKUmFmqpDkPWg-1
Received: by mail-io1-f71.google.com with SMTP id g13-20020a056602072d00b006c60d59110fso10278602iox.12
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAHYPLXzmvZKn2PzWyCXwAfZsv7nq/9FeOgM42T53go=;
        b=jKx6f8TEFBv7v1pfpboRFz3Zc1K9/dCH/2klDBxe9wmYQL27rUlwvSaWpUE3iHsLQy
         x+sXRqNUl1ZWbPc6k+j+tTyTYygWUMkCooBPOQqm8bGhYl0w2S22ZyMhLZeGc1R5Aa7j
         JJlzI1dI0uuJb0yx2J+z5femrfA+womlrhWr+pLyoI+Op+73ozdh56mWIsXbsUOiim10
         4Fz3nIzBVBA/mWWBFhbmwgGi0Mol8V9qvpdm1HVERXANlXz+Jiiy7WVqWJNsv5Z3JSO3
         s6eN3euLuaQX70J1KwbFTJlVPd7jdkXjL3MPFP7Ohle3yV9xCB9AIdIlJ5gESE5WElCJ
         kfmw==
X-Gm-Message-State: ACrzQf0mozFoMru69RTm02xUlOm0F9FKebD9+qsiqk3ZoPzFwn0hD4ua
        LHuQSOVKqGcEgNdO4z5o95GqSyxS3Ai4+FBPOELTcUjN8OqlQuZiBqD99iF6kmxg3I+PQvDgeFi
        q0RvygF7gxSwK
X-Received: by 2002:a02:b38c:0:b0:363:6320:4112 with SMTP id p12-20020a02b38c000000b0036363204112mr1245997jan.152.1667955521006;
        Tue, 08 Nov 2022 16:58:41 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7pWXOQ4BvwwwP3FjZWrCHtS7gUJVB49Yz9i/PytieS1opvkt9++SvAtiSRt7m2aqIlg05y0w==
X-Received: by 2002:a02:b38c:0:b0:363:6320:4112 with SMTP id p12-20020a02b38c000000b0036363204112mr1245991jan.152.1667955520816;
        Tue, 08 Nov 2022 16:58:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p16-20020a056e02105000b002f966e3900bsm4280398ilj.80.2022.11.08.16.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:58:40 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:58:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Anthony DeRossi <ajderossi@gmail.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, kevin.tian@intel.com, abhsahu@nvidia.com,
        yishaih@nvidia.com
Subject: Re: [PATCH v4 1/3] vfio: Fix container device registration life
 cycle
Message-ID: <20221108175838.0763c7d6.alex.williamson@redhat.com>
In-Reply-To: <Y2r5n+hVkjpMon3q@ziepe.ca>
References: <20221104195727.4629-1-ajderossi@gmail.com>
        <20221104195727.4629-2-ajderossi@gmail.com>
        <20221104145915.1dcdbc93.alex.williamson@redhat.com>
        <Y2r5n+hVkjpMon3q@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Nov 2022 20:51:43 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Nov 04, 2022 at 02:59:15PM -0600, Alex Williamson wrote:
> > On Fri,  4 Nov 2022 12:57:25 -0700
> > Anthony DeRossi <ajderossi@gmail.com> wrote:
> >   
> > > In vfio_device_open(), vfio_container_device_register() is always called
> > > when open_count == 1. On error, vfio_device_container_unregister() is
> > > only called when open_count == 1 and close_device is set. This leaks a
> > > registration for devices without a close_device implementation.
> > > 
> > > In vfio_device_fops_release(), vfio_device_container_unregister() is
> > > called unconditionally. This can cause a device to be unregistered
> > > multiple times.
> > > 
> > > Treating container device registration/unregistration uniformly (always
> > > when open_count == 1) fixes both issues.  
> > 
> > Good catch, I see that Jason does subtly fix this in "vfio: Move
> > vfio_device driver open/close code to a function", but I'd rather see
> > it more overtly fixed in a discrete patch like this.  All "real"
> > drivers provide a close_device callback, but mdpy and mtty do not.  
> 
> Given it only impacts the samples maybe I should just stick it in the
> iommufd series before that patch?

The series in general though fixes a regression.  Is there any reason
we shouldn't try to push it into 6.1?  Thanks,

Alex

