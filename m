Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5673D6220F6
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiKIAvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKIAvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:51:46 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37783C6E9
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:51:45 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id x18so10157056qki.4
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7IhKazTVLt4F9TtiuQ8YdDSsiBSK5W/7f3IIPSIhgqw=;
        b=h5Lpb54C9g3leB7Tu9HC9eVnf8vBtX2pbuoRjIFcpulfHuC2pSMXpyphCeBjRQMxEd
         ijfkPU4gMYfp3GZOst5PA16T3z0pswHrJYVt/21iRhicHZCWyZ2RGt+jQ2CwmCLhJ9oz
         wpQgTO4e5/6dkdG6q8/FXKVBNbmrGv8Pmrl3is0TMfPzn1IWxGTZDTvLse27/4thGcXo
         inzUQTadC7UYrgf5zsAjFpXRaD6FZqBmtURNXBMA4hCl9O/3Oex/FMt8wrXg7RPnR2uX
         rqX+LhKv8pJ+IzsuoBVDM6BWH7uzkylPYWYmy1a7Bv+hncAHeOGWCLSc3a3+z6Kba5s/
         PWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IhKazTVLt4F9TtiuQ8YdDSsiBSK5W/7f3IIPSIhgqw=;
        b=q3FMu1gPlygNtTRnmgEgggsQf61ZbNeDVqiM7tDB6weVG4lZytTXdJhbtK8ocDbVFQ
         GvXb1fxDsGdovejpWHVGPOGVV7maGD4Ie7lAF8DiLi8kESzPrEm4lJ0APsHXX73d54my
         DUyvCc0PPUef28LBGnY0rFL2NlDb3yYNh0J02XEJgchyXoF8XGO8Yjcbg2m7fWgVTaK7
         cZVtzgqzfRobeUarWUesgsiV+df0lXTYpir8UZf/AeD8H0+7l5tUIGOMn6frUNVxEO9Z
         iIl3ytzidEWhEfjPmGOW6oMit0B4/SVcrONtVwdiGrJTetzlaXTFpP2YZYoCIxTUcKEa
         Wzjg==
X-Gm-Message-State: ANoB5pktNj74ASLrilcvvKbeEk0WYZ5HY35isptFjKaVLIu7WZrKxijh
        ojRsJczL/7qjRGG6ehDVJ6HbBT+V/aZUFA==
X-Google-Smtp-Source: AA0mqf5xTRbq/Ajq4RQBXTE8C0V0GxgW5QOrXqDTrNgg2dGBPGpqqKtK66aPIJKdNzY0UcchyhELPg==
X-Received: by 2002:ae9:ec10:0:b0:6fa:ece5:a4e5 with SMTP id h16-20020ae9ec10000000b006faece5a4e5mr7863572qkg.86.1667955104848;
        Tue, 08 Nov 2022 16:51:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id j19-20020a05620a289300b006b949afa980sm10241227qkp.56.2022.11.08.16.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:51:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1osZJf-00HZtp-R3;
        Tue, 08 Nov 2022 20:51:43 -0400
Date:   Tue, 8 Nov 2022 20:51:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Anthony DeRossi <ajderossi@gmail.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, kevin.tian@intel.com, abhsahu@nvidia.com,
        yishaih@nvidia.com
Subject: Re: [PATCH v4 1/3] vfio: Fix container device registration life cycle
Message-ID: <Y2r5n+hVkjpMon3q@ziepe.ca>
References: <20221104195727.4629-1-ajderossi@gmail.com>
 <20221104195727.4629-2-ajderossi@gmail.com>
 <20221104145915.1dcdbc93.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104145915.1dcdbc93.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 02:59:15PM -0600, Alex Williamson wrote:
> On Fri,  4 Nov 2022 12:57:25 -0700
> Anthony DeRossi <ajderossi@gmail.com> wrote:
> 
> > In vfio_device_open(), vfio_container_device_register() is always called
> > when open_count == 1. On error, vfio_device_container_unregister() is
> > only called when open_count == 1 and close_device is set. This leaks a
> > registration for devices without a close_device implementation.
> > 
> > In vfio_device_fops_release(), vfio_device_container_unregister() is
> > called unconditionally. This can cause a device to be unregistered
> > multiple times.
> > 
> > Treating container device registration/unregistration uniformly (always
> > when open_count == 1) fixes both issues.
> 
> Good catch, I see that Jason does subtly fix this in "vfio: Move
> vfio_device driver open/close code to a function", but I'd rather see
> it more overtly fixed in a discrete patch like this.  All "real"
> drivers provide a close_device callback, but mdpy and mtty do not.

Given it only impacts the samples maybe I should just stick it in the
iommufd series before that patch?

Jason
