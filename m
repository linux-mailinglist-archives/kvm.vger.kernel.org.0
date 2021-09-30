Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7851D41DF87
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352301AbhI3QsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 12:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352296AbhI3QsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 12:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633020384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lL2MSBbRKO3rzthSQTrwQ8489lZtpiIJktx5C6l2Wsw=;
        b=OytD/fpixAdP4NbyJT+p+ilQnYRf9j5xyq0kGh6j08jw+sR3wsL6jqyO7WXzwEe83qp5OS
        AxkKoHYYF+Fu/Px1NUtLfTci05X1QpqmL2Ae/9WU0g0HFxJbqNwF+WpzfNBoC+ZstcKCWZ
        iNR9IB2HdbR4vD22RxrArbKRcUJk2lw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-n84swrM4PgaSYKULvNqU9g-1; Thu, 30 Sep 2021 12:46:22 -0400
X-MC-Unique: n84swrM4PgaSYKULvNqU9g-1
Received: by mail-ot1-f70.google.com with SMTP id k102-20020a9d19ef000000b0054dd5fae7ceso49677otk.20
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 09:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lL2MSBbRKO3rzthSQTrwQ8489lZtpiIJktx5C6l2Wsw=;
        b=q8HisLh0tUYul6uu8aGad48ZglOxaMYQlJn+w2uwmDzMGKTJRJbOl4pLcPgxSM0rNs
         7AjLkqCQOgwhug7eCG27rHxwFuJkgPCSnAYs+HsCGnvr9Ep1pqAzOTZEIW3YbYsgMOqM
         9VUGVEQBsTbvJ6J7OkvMRt0sc2saUaTdkg2IHuwuhe43pmZJT0fXaZ0vscCLQlFHjv2I
         d1Vl/uIBCsw1pOgHDJ0ODA0PUWerYwoRtpd3TcgB+XtsSANyWxUfp3knB4556cWLv6PX
         erebBND9PBcBw71k8gTN0rfe1uWbMNZFafqsA12B5VL3ogfZ1Z6G77GXQlJcvq/r+r4W
         gEwg==
X-Gm-Message-State: AOAM533xZatcQgPvrg/oToaebiFvCzDtOIULgaRvWWsC6OPD9AGlBaBk
        cyWPOoqRy/ctCWb59oAeFhTyWwO+itS1b8vHFY/KuCAaONAWTisn7sLN4bQYtEl10FxagJ3hhCZ
        fJrKVaR+32peY
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr6390812otr.162.1633020382064;
        Thu, 30 Sep 2021 09:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6oB6LC3Lj38OQP4p+tzANlvyYhE187YKmuccQxwIaF6fK2COFADSgRLGU/vKlEAQwoKX0tw==
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr6390803otr.162.1633020381885;
        Thu, 30 Sep 2021 09:46:21 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id n4sm647381otr.59.2021.09.30.09.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 09:46:21 -0700 (PDT)
Date:   Thu, 30 Sep 2021 10:46:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210930104620.56a1d3e9.alex.williamson@redhat.com>
In-Reply-To: <20210917125301.GU3544071@ziepe.ca>
References: <20210913071606.2966-1-hch@lst.de>
        <20210913071606.2966-12-hch@lst.de>
        <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
        <20210916221854.GT3544071@ziepe.ca>
        <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210917050543.GA22003@lst.de>
        <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com>
        <20210917125301.GU3544071@ziepe.ca>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Sep 2021 09:53:01 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Sep 17, 2021 at 12:21:07PM +0530, Kirti Wankhede wrote:
> > 
> > 
> > On 9/17/2021 10:35 AM, Christoph Hellwig wrote:  
> > > On Fri, Sep 17, 2021 at 04:49:41AM +0000, Tian, Kevin wrote:  
> > > > > You just use the new style mdev API and directly call
> > > > > vfio_register_group_dev and it will pick up the
> > > > > parent->dev->iommu_group naturally like everything else using physical
> > > > > iommu groups.
> > > > >   
> > > >   
> > 
> > Directly calling vfio_register_group_dev() doesn't work without linking
> > mdev->dev->iommu_group to mdev->type->parent->dev->iommu_group.  
> 
> You pass the PCI device, not the mdev to vfio_register_group_dev().
> 
> > > > For above usage (wrap pdev into mdev), isn't the right way to directly add
> > > > vendor vfio-pci driver since vfio-pci-core has been split out now? It's not
> > > > necessary to fake a mdev just for adding some mediation in the r/w path...  
> > > 
> > > Exactly.  
> > 
> > vfio-pci doesn't provide way to configure the device as mdev framework
> > provide using mdev_types.  
> 
> The linux standard is for a PCI PF driver to configure it's VFs, not a
> mdev or vfio.

Hi Jason,

I'm only aware that the PF driver enables basic SR-IOV configuration of
VFs, ie. the number of enabled VFs.  The mdev interface enables not
only management of the number of child devices, but the flavor of each
child, for example the non-homogeneous slice of resources allocated per
child device.

I think that's the sort of configuration Kirti is asking about here and
I'm not aware of any standard mechanism for a PF driver to apply a
configuration per VF.  A mediated path to a physical device isn't
exclusive to providing features like migration, it can also be used to
create these sorts device flavors.  For example, we might expose NIC VFs
and administrative configuration should restrict VF1 to a 1Gbit
interface while VF2 gets 10Gbit.

Are we left to driver specific sysfs attributes to achieve this or can
we create some form of standardization like mdev provides?  Thanks,

Alex

