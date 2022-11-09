Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E709622F9C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 17:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiKIQFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 11:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKIQFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 11:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CE020F53
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 08:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668009879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlkkeMfxV44D/L3s5LRq3WQI02ckK3ct3NFXoV2Fvn8=;
        b=RLA7cgEuy0yD0uO9VWHLJE/q2AF1i8Pg5eLPb7BlhUxvD8BAwHpCzOX98+HudQFEA1AyWW
        Bv5iX190HckT3epr2KuBJF4i2MjY3OQw8gbJ2n/wZvIcATsik1fr3CYmwmlKCvzClhQzGo
        iZHybtl7ZZKZEAxsCe6zaqCknG13BzE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-187-Gr3UCNr6Pk6cLsum7m0XUQ-1; Wed, 09 Nov 2022 11:04:35 -0500
X-MC-Unique: Gr3UCNr6Pk6cLsum7m0XUQ-1
Received: by mail-io1-f72.google.com with SMTP id be26-20020a056602379a00b006dd80a0ba1cso2572224iob.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 08:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlkkeMfxV44D/L3s5LRq3WQI02ckK3ct3NFXoV2Fvn8=;
        b=givNq8ituV3RXWiyeE7BX8DUv5kyhuqFjRwVWxplhdV0QpaR9SjJaHasgvlQeQQvyF
         hh7Ok6ZTzEQ86UALwwnNsVTwsSutG6Kj7HSUYp3oWV33kXrPiCVRnTgew2WzN1+8w6eC
         n+9XChvzm5G8Pe2volwlvpZ3J7aKohKtgW9bluH/+DnFHYb0yNCniR2qpfKNInAarrDv
         esj+CspZJeFs6WIo7l2xdsmoRb5uK6U5TyqS80N3I6ZKx7psU0e+OVioSLRWkEcQAnTl
         qUY1ct77uMDvoeZfNRgQ2jpbfroDZXWzeYmxPqAtiR63VDm3a+sE96ZJjvXbl97b7rXt
         D8Bw==
X-Gm-Message-State: ACrzQf2X/tskp03JAfWImYigtdJb5DWvAVedpgB0GU2Tkbt++X15IPw5
        fnpESDg9rfVQyxBfCE57wAju6aax8iEuUyRFAikUvFJKju8Hzd0OcP3PLfF/JhYCh0a5XaN9uTq
        Zx8HsOtNuUJX9
X-Received: by 2002:a05:6e02:6c9:b0:2ff:a4d3:3ae with SMTP id p9-20020a056e0206c900b002ffa4d303aemr32883876ils.163.1668009874562;
        Wed, 09 Nov 2022 08:04:34 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7cyAN5brN5IYU7iI+TJHnZhix6eZxYlMZL72PBNXbZ/kasSYOws7sdmCYTOvWrRw6luGHkdQ==
X-Received: by 2002:a05:6e02:6c9:b0:2ff:a4d3:3ae with SMTP id p9-20020a056e0206c900b002ffa4d303aemr32883869ils.163.1668009874368;
        Wed, 09 Nov 2022 08:04:34 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h8-20020a926c08000000b002ff54e19cb0sm5022981ilc.36.2022.11.09.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 08:04:33 -0800 (PST)
Date:   Wed, 9 Nov 2022 09:04:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Anthony DeRossi <ajderossi@gmail.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, kevin.tian@intel.com, abhsahu@nvidia.com,
        yishaih@nvidia.com
Subject: Re: [PATCH v5 2/3] vfio: Export the device set open count
Message-ID: <20221109090431.0e07382a.alex.williamson@redhat.com>
In-Reply-To: <Y2r4yHY5re97WA7G@ziepe.ca>
References: <20221105224458.8180-1-ajderossi@gmail.com>
        <20221105224458.8180-3-ajderossi@gmail.com>
        <Y2r4yHY5re97WA7G@ziepe.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Tue, 8 Nov 2022 20:48:08 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Sat, Nov 05, 2022 at 03:44:57PM -0700, Anthony DeRossi wrote:
> > The open count of a device set is the sum of the open counts of all
> > devices in the set. Drivers can use this value to determine whether
> > shared resources are in use without tracking them manually or accessing
> > the private open_count in vfio_device.
> > 
> > Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> > ---
> >  drivers/vfio/vfio_main.c | 11 +++++++++++
> >  include/linux/vfio.h     |  1 +
> >  2 files changed, 12 insertions(+)  
> 
> >  
> > +unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
> > +{
> > +	struct vfio_device *cur;
> > +	unsigned int open_count = 0;  
> 
> I'd probably just make this a bool
> 
> 'vfio_device_set_last_close()'
> 
> And roll in the < 1 logic too
> 
> Nothing will ever need to know the number of fds open across the set.

'last_close' presumes the caller though, which seems bad form.  It's
possible there are use cases for this in a 'first_open' scenario too.
Something along the lines of 'singleton_open', but that's a horrible
name, so we might as well just provide the count since we already have
it.  Thanks,

Alex

> But this is fine as written
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
> 

