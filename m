Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A870617007
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKBVq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 17:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKBVq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 17:46:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FCF9FD2
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 14:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667425531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7OTRxyAcy6wuvaydsoi6ntLwbkNLkQ1zliP5/aKg08=;
        b=a73vuMWaTc2XoJLSt/af1RZtx3a/RNk6qv8dJv+kadwyd4oQ8QD2a4c/KSYBT3sW42kjhF
        Z85qxgShOUf9t5NESGltw9awKbI0I0ZzQJDgn9qx1qHwFcrKPCNTp0lSsCFBawub1Buqot
        o5TQT2b6WcdOVfkAMQtqJspqTVVNTXI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-463-OBdUNMSkPt2NJoUIZ-lBMQ-1; Wed, 02 Nov 2022 17:45:30 -0400
X-MC-Unique: OBdUNMSkPt2NJoUIZ-lBMQ-1
Received: by mail-io1-f69.google.com with SMTP id y26-20020a5d9b1a000000b006bc71505e97so15180401ion.16
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 14:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7OTRxyAcy6wuvaydsoi6ntLwbkNLkQ1zliP5/aKg08=;
        b=vq0mfEKeBnBm2LyIU5DzhBVue3z5gUn3S0BeXtU1wtAvzpfuJLk+pa3S4394Aa9MOa
         WyZc7a+LJo3F6RuE3PbNVW8n6+qBBLcBkZzX5gX+YntbsAW0ejc4FjMig9Vp0t7lAn5Q
         Ai4ovRdBjp6MURlcjSL01oK1TBvvyUTupGT8FSFSA2Z68OChlp4i7xpULgvQDa+uVcfS
         2hj6E8/zNuu5CIzpU9vy8CXxkdiZ2i4vhHBZ1fCWIJFxLl3IRR52CaxSWYJ58vHrD5hH
         2MkMDq7zVk6Q6OeIUzQaDGs5biKjZ6XYBQClWukdBW7c+IURR6LHnh1/yfAG6Pd9a0rV
         jddg==
X-Gm-Message-State: ACrzQf3kSyN7JL4Hg8UhiEI0fN+F0AtPPMb/Y/KUgN2FLSUtuKQDcBq0
        CTRKmshskFoCUjGcVWkYTjYrZvLr/8MDbUrBIcdHJckRTEwap7m/vMmnNJnMREsH9gbX1f7Y56J
        NL5qpxs+DJqzO
X-Received: by 2002:a92:cacd:0:b0:300:9f3b:af12 with SMTP id m13-20020a92cacd000000b003009f3baf12mr13583433ilq.291.1667425529883;
        Wed, 02 Nov 2022 14:45:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM602sIpgtMAsEc3rxccKw32rxaZJct+uaGf/R1wGsa49n17KO8hQYUWqYT+zge0zgiVrdVt1g==
X-Received: by 2002:a92:cacd:0:b0:300:9f3b:af12 with SMTP id m13-20020a92cacd000000b003009f3baf12mr13583424ilq.291.1667425529647;
        Wed, 02 Nov 2022 14:45:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b22-20020a026f56000000b003750f2bc28dsm5271305jae.3.2022.11.02.14.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 14:45:29 -0700 (PDT)
Date:   Wed, 2 Nov 2022 15:45:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Message-ID: <20221102154527.3ad11fe2.alex.williamson@redhat.com>
In-Reply-To: <Y2EFLVYwWumB9JbL@ziepe.ca>
References: <20221026194245.1769-1-ajderossi@gmail.com>
        <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Y2EFLVYwWumB9JbL@ziepe.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Nov 2022 08:38:21 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Nov 01, 2022 at 08:49:28AM +0000, Tian, Kevin wrote:
> > > From: Anthony DeRossi <ajderossi@gmail.com>
> > > Sent: Thursday, October 27, 2022 3:43 AM
> > > 
> > > -static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
> > > +static bool vfio_pci_core_needs_reset(struct vfio_pci_core_device *vdev)
> > >  {
> > > +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> > >  	struct vfio_pci_core_device *cur;
> > >  	bool needs_reset = false;
> > > 
> > > +	if (vdev->vdev.open_count > 1)
> > > +		return false;  
> > 
> > WARN_ON()
> >   
> > > +
> > >  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> > > -		/* No VFIO device in the set can have an open device FD */
> > > -		if (cur->vdev.open_count)
> > > +		/* Only the VFIO device being reset can have an open FD */
> > > +		if (cur != vdev && cur->vdev.open_count)
> > >  			return false;  
> > 
> > not caused by this patch but while at it...
> > 
> > open_count is defined not for driver use:
> > 
> > 	/* Members below here are private, not for driver use */
> > 	unsigned int index;
> > 	struct device device;   /* device.kref covers object life circle */
> > 	refcount_t refcount;    /* user count on registered device*/
> > 	unsigned int open_count;
> > 	struct completion comp;
> > 	struct list_head group_next;
> > 	struct list_head iommu_entry;
> > 
> > prefer to a wrapper or move it to the public section of vfio_device.  
> 
> I've been meaning to take a deeper look, but I'm thinking vfio_pci
> doesn't need open_count at all any more.
> 
> open_count was from before we changed the core code to call
> open_device only once. If we are only a call chain from
> open_device/close_device then we know that the open_count must be 1.

That accounts for the first test, we don't need to test open_count on
the calling device in this path, but the idea here is that we want to
test whether we're the last close_device among the set.  Not sure how
we'd do that w/o some visibility to open_count.  Maybe we need a
vfio_device_set_open_count() that when 1 we know we're the first open
or last close?  Thanks,

Alex

