Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE262211B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 02:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiKIBAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 20:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiKIBAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 20:00:04 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7180A57B59
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 17:00:03 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id s20so10165961qkg.5
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 17:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+ggkyjqdVCAgPXH8VnxKlV+MnAIChbcR5j8fpo8B2U=;
        b=oKO1O92/2iknSyQvXZIfLyVYKF/Q0lc4IegwEeXeaNOBfAyXzj1RA0ufvN4SFt+Q7x
         BJ/8ggMM0BHdqD9Tpitc/00b2eITblucrH/SD47JtoQI/mmCjPBE4YmTnzhIF4R0VxMI
         Gi0f7sjTjLCemA6ggcTjHOIqiRqKk12WRvIZsq1RIzwazal/5JByGfkFt2pjB5JP+nEL
         OxTt7jNTcvsqTCMQ3zTsvEFKlQ7W+WPpWgX89aQI9d4oCcOjyZsm5R9HMfY1Z7t8lM60
         yCZ/+OVfzUkrljeGAijvXRSK2IKaXjGtI92rbhniinewmDyxcXE4V164KHybBbPUAuXO
         PBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+ggkyjqdVCAgPXH8VnxKlV+MnAIChbcR5j8fpo8B2U=;
        b=L8B61RHLn2gXlPf/cqIZJIaFuYTA4rV4tuUPSGIbseX6X0SjTxkcdPA5RlG4/on7ql
         +deAAl48y9aj6MtfOIjnW3FrrG5xl5dGUOZKAB8elPI9Kf9FWV/cqrCc1H/5qiqLq4ti
         Suw1EOKKJuucvj3UAX6huL3QXPCYmG+AB79m2o2QkTwBdFi5cpJmsiKxGxbTflTjJJ6R
         lKPRuoAyBHakSKAY664/XlGFGlurM58A2gbhynKzWQhlg1cdTWpf16BaFTMfiQNjcdgR
         gUZr5ukM6XtS/TPVb+pDZFuGEMVOvF7yIo8Rr8yVY7m/cETZ3FoJW0xFuh4H43DVilRx
         LKXQ==
X-Gm-Message-State: ACrzQf17SsgikYQksoBWHg5cI/WLgT4FleZh0N9CSVPkSWOLxrWLV5hH
        SwA61P0ncbid4dZdKAysxB0XPw==
X-Google-Smtp-Source: AMsMyM4L8Rw9GaLfPVro23WrCF1VGS0NNy3xz/EFMAesNjypr27fCWdblxrCsBLBbnjJQT0CuBTdkg==
X-Received: by 2002:a05:620a:cc5:b0:6fa:29f2:53df with SMTP id b5-20020a05620a0cc500b006fa29f253dfmr36345889qkj.194.1667955602616;
        Tue, 08 Nov 2022 17:00:02 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id y22-20020a05620a44d600b006ec62032d3dsm10745194qkp.30.2022.11.08.17.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 17:00:02 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1osZRh-00Ha16-IK;
        Tue, 08 Nov 2022 21:00:01 -0400
Date:   Tue, 8 Nov 2022 21:00:01 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Anthony DeRossi <ajderossi@gmail.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, kevin.tian@intel.com, abhsahu@nvidia.com,
        yishaih@nvidia.com
Subject: Re: [PATCH v4 1/3] vfio: Fix container device registration life cycle
Message-ID: <Y2r7kdvcdzHDGF08@ziepe.ca>
References: <20221104195727.4629-1-ajderossi@gmail.com>
 <20221104195727.4629-2-ajderossi@gmail.com>
 <20221104145915.1dcdbc93.alex.williamson@redhat.com>
 <Y2r5n+hVkjpMon3q@ziepe.ca>
 <20221108175838.0763c7d6.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108175838.0763c7d6.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 05:58:38PM -0700, Alex Williamson wrote:
> On Tue, 8 Nov 2022 20:51:43 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, Nov 04, 2022 at 02:59:15PM -0600, Alex Williamson wrote:
> > > On Fri,  4 Nov 2022 12:57:25 -0700
> > > Anthony DeRossi <ajderossi@gmail.com> wrote:
> > >   
> > > > In vfio_device_open(), vfio_container_device_register() is always called
> > > > when open_count == 1. On error, vfio_device_container_unregister() is
> > > > only called when open_count == 1 and close_device is set. This leaks a
> > > > registration for devices without a close_device implementation.
> > > > 
> > > > In vfio_device_fops_release(), vfio_device_container_unregister() is
> > > > called unconditionally. This can cause a device to be unregistered
> > > > multiple times.
> > > > 
> > > > Treating container device registration/unregistration uniformly (always
> > > > when open_count == 1) fixes both issues.  
> > > 
> > > Good catch, I see that Jason does subtly fix this in "vfio: Move
> > > vfio_device driver open/close code to a function", but I'd rather see
> > > it more overtly fixed in a discrete patch like this.  All "real"
> > > drivers provide a close_device callback, but mdpy and mtty do not.  
> > 
> > Given it only impacts the samples maybe I should just stick it in the
> > iommufd series before that patch?
> 
> The series in general though fixes a regression.  Is there any reason
> we shouldn't try to push it into 6.1?  Thanks,

That works for me too.

Jason
