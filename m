Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490B7ADDDD
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjIYRhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjIYRhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:37:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54735101
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695663376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zjs4lEvHaDiAhNxtP1F5A4HCNq/ZOZBqE/yPfKd9nJ0=;
        b=gKlkiFaFzw5X0O+/iuY3B3ET7iV6ujjj/wOyQoiHpxhgkTJwI1jW8PkzFgPopnNA5pzUew
        gjPkFswyFPHF/Ov058UHDKsFbLO/LeKy4nF7XU+FeQWgqCVRtLU8o3gGXr4DcMNZC1Km/T
        WTrEgMsYLDZIo6bU6budkxwnYgiN9h8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-Ek7gIpTJPF2qgPTXY1IuDg-1; Mon, 25 Sep 2023 13:36:15 -0400
X-MC-Unique: Ek7gIpTJPF2qgPTXY1IuDg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7740517a478so1263301085a.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695663374; x=1696268174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjs4lEvHaDiAhNxtP1F5A4HCNq/ZOZBqE/yPfKd9nJ0=;
        b=lIqY29zmebNZxJrNBD6NVRqLTRr9TQRIowyVdRdqBlozZoLBpGzNj4mpueyxankGCU
         TfUa8cPShfqdPLMzMcPe026IlfO3/tyH3m4dwGlrlsWDCRqgCfp0y7KlPU/P3NFhpQt7
         ABCp4vEmQzalVaqhiMNobXGaFllNSMsf0ZQvXiXbuhfpuUveYvyPbPNcjYFS0mqxIKLo
         UhcSXjmL5e/D2owWmEAqF0imYumoeZjgLspFpN/m/5VjeSljtraf6RQGUIuGX1ypwHhi
         QbgUXft3WqvGQIxh1qz2vxnTTHKwMKDdXo8YQXwcOhvfSLMOx7iI6haZ7mRAkXNnR2sz
         r8ag==
X-Gm-Message-State: AOJu0YywcVBjLsXcbTBsKqnL5HYLnQ7fAPlGGHN1yr6aPn069xMCz4AK
        Fyk1jmWd1RzuV+hVdENBszdZkbVLriPRNbgBzjw/96QS5w8H831lWac/j+uyDt7lD+J2hX4bdbW
        3hv72hzwHkKAw
X-Received: by 2002:a05:620a:4105:b0:774:244c:8b2c with SMTP id j5-20020a05620a410500b00774244c8b2cmr7602764qko.14.1695663374573;
        Mon, 25 Sep 2023 10:36:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmpiRCu+wzFPOCrZC1PqOEIb9d+Hn3KxIh66IaQJaLnetrbMNgTOFvL9gDfrNhGFU6c7tCrA==
X-Received: by 2002:a05:620a:4105:b0:774:244c:8b2c with SMTP id j5-20020a05620a410500b00774244c8b2cmr7602741qko.14.1695663374271;
        Mon, 25 Sep 2023 10:36:14 -0700 (PDT)
Received: from redhat.com ([185.184.228.174])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a144f00b00772662b77fesm1268315qkl.99.2023.09.25.10.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 10:36:13 -0700 (PDT)
Date:   Mon, 25 Sep 2023 13:36:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230925060510-mutt-send-email-mst@kernel.org>
References: <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230922111132-mutt-send-email-mst@kernel.org>
 <20230922151534.GR13733@nvidia.com>
 <20230922113941-mutt-send-email-mst@kernel.org>
 <20230922162233.GT13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922162233.GT13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 01:22:33PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 11:40:58AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Sep 22, 2023 at 12:15:34PM -0300, Jason Gunthorpe wrote:
> > > On Fri, Sep 22, 2023 at 11:13:18AM -0400, Michael S. Tsirkin wrote:
> > > > On Fri, Sep 22, 2023 at 12:25:06PM +0000, Parav Pandit wrote:
> > > > > 
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Friday, September 22, 2023 5:53 PM
> > > > > 
> > > > > 
> > > > > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > > > > 
> > > > > > Oh? How? Our team didn't think so.
> > > > > 
> > > > > It does not. It was already discussed.
> > > > > The device reset in legacy is not synchronous.
> > > > > The drivers do not wait for reset to complete; it was written for the sw backend.
> > > > > Hence MMIO BAR0 is not the best option in real implementations.
> > > > 
> > > > Or maybe they made it synchronous in hardware, that's all.
> > > > After all same is true for the IO BAR0 e.g. for the PF: IO writes
> > > > are posted anyway.
> > > 
> > > IO writes are not posted in PCI.
> > 
> > Aha, I was confused. Thanks for the correction. I guess you just buffer
> > subsequent transactions while reset is going on and reset quickly enough
> > for it to be seemless then?
> 
> >From a hardware perspective the CPU issues an non-posted IO write and
> then it stops processing until the far side returns an IO completion.
> 
> Using that you can emulate what the SW virtio model did and delay the
> CPU from restarting until the reset is completed.
> 
> Since MMIO is always posted, this is not possible to emulate directly
> using MMIO.
> 
> Converting IO into non-posted admin commands is a fairly close
> recreation to what actual HW would do.
> 
> Jason

I thought you asked how it is possible for hardware to support reset if
all it does is replace IO BAR with memory BAR. The answer is that since
2011 the reset is followed by read of the status field (which isn't much
older than MSIX support from 2009 - which this code assumes).  If one
uses a Linux driver from 2011 and on then all you need to do is defer
response to this read until after the reset is complete.

If you are using older drivers or other OSes then reset using a posted
write after device has operated for a while might not be safe, so e.g.
you might trigger races if you remove drivers from system or
trigger hot unplug.  For example: 

	static void virtio_pci_remove(struct pci_dev *pci_dev)
	{

	....

		unregister_virtio_device(&vp_dev->vdev);

	^^^^ triggers reset, then releases memory

	....

		pci_disable_device(pci_dev);

	^^^ blocks DMA by clearing bus master

	}

here you could see some DMA into memory that has just been released.


As Jason mentions hardware exists that is used under one of these two
restrictions on the guest (Linux since 2011 or no resets while DMA is
going on), and it works fine with these existing guests.

Given the restrictions, virtio TC didn't elect to standardize this
approach and instead opted for the heavier approach of
converting IO into non-posted admin commands in software.


-- 
MST

