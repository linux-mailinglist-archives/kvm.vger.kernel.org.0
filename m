Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E575136D2
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbiD1O2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbiD1O2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68597B7C5F
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651155895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63r8rWhR8oABNQdnk8OaypleiW++wyFQSOhF8gotzVY=;
        b=ArF9v7Hbh/Y1sp4D0zxS8a0Fj4yLLw0jm4q6gasP1zAyT8/1dU87f9utTiM08ZAaV/oEP4
        sBSSJstWXDJZt7O9M6EVXw4ny/kiOSq6F7dBCfHN3wJphQ+4jnhEgwvTZgh+tWut6QlhLO
        kozf7Yxfg+eEjh2tK+z0Fmkl1IsMJMY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-XY80sOJ6Ofmq2mJkWmf9lA-1; Thu, 28 Apr 2022 10:24:51 -0400
X-MC-Unique: XY80sOJ6Ofmq2mJkWmf9lA-1
Received: by mail-io1-f70.google.com with SMTP id q5-20020a0566022f0500b00654a56b1dfbso4573285iow.8
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=63r8rWhR8oABNQdnk8OaypleiW++wyFQSOhF8gotzVY=;
        b=xQ6bVtrlpKB4OurdUgZsrD0GfI5kXJH+qZPX+3r7C7x7asVgTfNygbUw1Dt45rGcgM
         A7kcFOSSqXKqaEGQd2DcVBIb0Ria88EWiRk/M8PqLwxpdIGnRH4rMEH/zdMWpoI27q3j
         ivnR1hUWkZ3X0ZTwA/a4N6Gq4EY9C11h/8s79Rmw1xw2viMOVg1C4s2Y+Pjy7eWeJ5XV
         i1TLjZJb+xV6r8o0xSU21lUGOHKg7yDJa6h2DCVtaaQyAchJnHGMc/7uyVKatRNxF6B2
         2q7i2DEgXnN1f/sR0SjOW7rctwMYlu9194kTzWq4AowcMrBQ9B4fXNET+eXhUNfALulF
         cb2g==
X-Gm-Message-State: AOAM530aCVM0VL+mPNiYm6KVcj3GYFlh8fpMG//QBYpio5AnXH5bvAac
        Oy8b2BF+lvDtgbOANhuAo+xfmJ4SK0hPEqOUMkTqYHGnkHHMJrp1LVHSt7WuYuz+3zkx1BPCjCh
        fB9RvPyg/a7c9
X-Received: by 2002:a5d:8b8f:0:b0:649:ec6d:98e9 with SMTP id p15-20020a5d8b8f000000b00649ec6d98e9mr14028114iol.30.1651155890674;
        Thu, 28 Apr 2022 07:24:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2U1d0fyvz8Pa/Eh29/m4hiXQ+rLKTZwJ9R/ROlmhzHrrR87J6y6aBkBIOBBO7Fy6bjKArnw==
X-Received: by 2002:a5d:8b8f:0:b0:649:ec6d:98e9 with SMTP id p15-20020a5d8b8f000000b00649ec6d98e9mr14028093iol.30.1651155890410;
        Thu, 28 Apr 2022 07:24:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v1-20020a6bac01000000b006575e6d99c7sm12427ioe.29.2022.04.28.07.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:24:50 -0700 (PDT)
Date:   Thu, 28 Apr 2022 08:24:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Laine Stump" <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220428082448.318385ed.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276189A2A8EACFBF75B22238CFD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
        <20220425083748.3465c50f.alex.williamson@redhat.com>
        <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220426102159.5ece8c1f.alex.williamson@redhat.com>
        <BN9PR11MB5276189A2A8EACFBF75B22238CFD9@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Apr 2022 03:21:45 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, April 27, 2022 12:22 AM  
> > > >
> > > > My expectation would be that libvirt uses:
> > > >
> > > >  -object iommufd,id=iommufd0,fd=NNN
> > > >  -device vfio-pci,fd=MMM,iommufd=iommufd0
> > > >
> > > > Whereas simple QEMU command line would be:
> > > >
> > > >  -object iommufd,id=iommufd0
> > > >  -device vfio-pci,iommufd=iommufd0,host=0000:02:00.0
> > > >
> > > > The iommufd object would open /dev/iommufd itself.  Creating an
> > > > implicit iommufd object is someone problematic because one of the
> > > > things I forgot to highlight in my previous description is that the
> > > > iommufd object is meant to be shared across not only various vfio
> > > > devices (platform, ccw, ap, nvme, etc), but also across subsystems, ex.
> > > > vdpa.  
> > >
> > > Out of curiosity - in concept one iommufd is sufficient to support all
> > > ioas requirements across subsystems while having multiple iommufd's
> > > instead lose the benefit of centralized accounting. The latter will also
> > > cause some trouble when we start virtualizing ENQCMD which requires
> > > VM-wide PASID virtualization thus further needs to share that
> > > information across iommufd's. Not unsolvable but really no gain by
> > > adding such complexity. So I'm curious whether Qemu provide
> > > a way to restrict that certain object type can only have one instance
> > > to discourage such multi-iommufd attempt?  
> > 
> > I don't see any reason for QEMU to restrict iommufd objects.  The QEMU
> > philosophy seems to be to let users create whatever configuration they
> > want.  For libvirt though, the assumption would be that a single
> > iommufd object can be used across subsystems, so libvirt would never
> > automatically create multiple objects.  
> 
> I like the flexibility what the objection approach gives in your proposal.
> But with the said complexity in mind (with no foreseen benefit), I wonder

What's the actual complexity?  Front-end/backend splits are very common
in QEMU.  We're making the object connection via name, why is it
significantly more complicated to allow multiple iommufd objects?  On
the contrary, it seems to me that we'd need to go out of our way to add
code to block multiple iommufd objects.

> whether an alternative approach which treats iommufd as a global
> property instead of an object is acceptable in Qemu, i.e.:
> 
> -iommufd on/off
> -device vfio-pci,iommufd,[fd=MMM/host=0000:02:00.0]
> 
> All devices with iommufd specified then implicitly share a single iommufd
> object within Qemu.

QEMU requires key-value pairs AFAIK, so the above doesn't work, then
we're just back to the iommufd=on/off.
 
> This still allows vfio devices to be specified via fd but just requires Libvirt
> to grant file permission on /dev/iommu. Is it a worthwhile tradeoff to be
> considered or just not a typical way in Qemu philosophy e.g. any object
> associated with a device must be explicitly specified?

Avoiding QEMU opening files was a significant focus of my alternate
proposal.  Also note that we must be able to support hotplug, so we
need to be able to dynamically add and remove the iommufd object, I
don't see that a global property allows for that.  Implicit
associations of devices to shared resources doesn't seem particularly
desirable to me.  Thanks,

Alex

