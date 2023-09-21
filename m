Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F8C7A9703
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjIURLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbjIURK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:10:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1675C72B7
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eXLjSJIMRxcWvPfwsAym08vPACVukQQjMlk91zESb4A=;
        b=XeXVdGlf4eUYycQgI52BY4t1qZjrQ6NU5FFxdLtXCU8iiaKe4GEXPwnkg0iZYAFjuVd+/7
        cxmoMD5CdfDzxDPkfBbGjdtnfPdZdhTH6i2TBuShkLLziqTJj3x4Ok/J33+kXZdViNXPQd
        tqk+AM75IE8JiqNG4UJQbl70fF8Qv7w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-XPO6b55AM_W2mKRaGCQkHg-1; Thu, 21 Sep 2023 13:01:18 -0400
X-MC-Unique: XPO6b55AM_W2mKRaGCQkHg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3172a94b274so777502f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315677; x=1695920477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXLjSJIMRxcWvPfwsAym08vPACVukQQjMlk91zESb4A=;
        b=CPOzP9HQz1xlINSqmwirI8pw74oqNDEiccZ2f75D7da0nUU+hh4x+EwKIQDrMG44+I
         NTVFNvmot11PN7FzfSNQzIG9p+h3En29IfYgHnqLmeSGg6HvsvhXft+Qg0zRjzRTJAIC
         Q56C8I7+rzOG5y+Q5x+I2NwRzeNaJ0R0ztoLR06DA+o5KLdZiaknP8Ot6knB0R3GL930
         C2jjG3Cb62TypXfCDPm9XGJOrGaQJBQ9kMLR1fJ/seijxLroz5bjIUsvPp7xC+/fTCnk
         KtnxqRKCnS4ixiGZ8sIgu5xWNb+D2zYPOYYFD0QusCbFHXb9Yro7qNYeu1aQEY3MzBac
         bImA==
X-Gm-Message-State: AOJu0YwbHX5ik25bFfNR3zP7Y5UEGlegQISwKkG17NGb4W1yt1pc/g+3
        x0GG0EVNHgT/AKmnCOq9wsqtZSlADSdCNUnEgfJtUwDA8sFU1oUPa3dp/K9Pt8T4yOmKUYm9ImX
        QkaJTjloqD3jK
X-Received: by 2002:a5d:4002:0:b0:31f:fa38:425f with SMTP id n2-20020a5d4002000000b0031ffa38425fmr6223637wrp.9.1695315676888;
        Thu, 21 Sep 2023 10:01:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZwr2zrzHEqGG+dt5nELJ8fK8Zh8B8fa0c6Q4DwZ9VFKGUV6CPz1ZEPZrn4R+cr3pruDWXcQ==
X-Received: by 2002:a5d:4002:0:b0:31f:fa38:425f with SMTP id n2-20020a5d4002000000b0031ffa38425fmr6223610wrp.9.1695315676542;
        Thu, 21 Sep 2023 10:01:16 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id bg1-20020a170906a04100b009adce1c97ccsm1330409ejb.53.2023.09.21.10.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 10:01:15 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:01:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921125348-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921165224.GR13733@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:52:24PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 10:43:50AM -0600, Alex Williamson wrote:
> 
> > > With that code in place a legacy driver in the guest has the look and
> > > feel as if having a transitional device with legacy support for both its
> > > control and data path flows.
> > 
> > Why do we need to enable a "legacy" driver in the guest?  The very name
> > suggests there's an alternative driver that perhaps doesn't require
> > this I/O BAR.  Why don't we just require the non-legacy driver in the
> > guest rather than increase our maintenance burden?  Thanks,
> 
> It was my reaction also.
> 
> Apparently there is a big deployed base of people using old guest VMs
> with old drivers and they do not want to update their VMs. It is the
> same basic reason why qemu supports all those weird old machine types
> and HW emulations. The desire is to support these old devices so that
> old VMs can work unchanged.
> 
> Jason

And you are saying all these very old VMs use such a large number of
legacy devices that over-counting of locked memory due to vdpa not
correctly using iommufd is a problem that urgently needs to be solved
otherwise the solution has no value?

Another question I'm interested in is whether there's actually a
performance benefit to using this as compared to just software
vhost. I note there's a VM exit on each IO access, so ... perhaps?
Would be nice to see some numbers.


-- 
MST

