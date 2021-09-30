Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CFF41DFA3
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352461AbhI3Q6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 12:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344261AbhI3Q6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 12:58:52 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088E0C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 09:57:10 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id x9so6407186qtv.0
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S6YXfpFe2oyoHYDwjh9kH94qHaiTar/66XvSXAnCW4g=;
        b=WRCxUf02fh2bjoA8377P/niAhxpKtgq/8s2Qb65HKtgJaYQcoQSeeKZjluErA9c0QB
         jG6BSuDu4s89o0VhFixYNqHYMGg64pTiDFhhk7zCiyXi3+adD5QKiUBKc3PYL/Ag8EfO
         34eEjhDSvCpPsR63j9HEq5vRjPJTvSyluDBqVL1Sey71waEfI0AU6gvPKnqFkSIqlisy
         GeiTjFUbsSoblRd1+Z9oEuuDvm7oH0rs/Y+lgv65763hMsT5nvyBIyXa7dtSXMFHzrZM
         Bs9Nx8+HQJfnNXp3kz8odCnjGl3a6o1efrypNUgpLKaOnhPheEeEtlwCZoR6WDDYNU6c
         GXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S6YXfpFe2oyoHYDwjh9kH94qHaiTar/66XvSXAnCW4g=;
        b=y6Jgfby4ETSv50p8F3w3kp513V2/gieVeU7LOVVj3chBYE5u7JlF3tvoyfy+jtjCtd
         l2dCNOiIGw3AWxOq/QtgwyRe37r0Ioxsz7K40+ntjy/iGqviyHzFQ3XYdO99VhmWo1pD
         xA3YEQEBBA0giuI1dcutuXIoyCgOaVZPv1Q/5wGZYk+WQCy4zoPWJ3mueLUUi/1DXNDL
         UELG/rBjjtu+XAiNAkoTdGNaUWSEgDgtVvcHtGKzxXImhBILea3LmlZKsbS30GhbJ1Xf
         F0M39v/V/XdwqxSQTYUs/jdrT5nLh9waImfYn9Mp7R1XNWstogu3sE0aL+eTS4BNxSWF
         Z8ZQ==
X-Gm-Message-State: AOAM532xp9cJco9/7HHOTZqWCfFVfR+2kz+bNqz0Oawbwj1D89mx82vT
        f6o3MYyrRJo2ghNlz1uFnUldNw==
X-Google-Smtp-Source: ABdhPJwaVZrb6swbOMWyh5meDFfCVItnxXm0igkU1Y9f/FXaY61x5Pm69s2i65DGkSEkjPO+MY86Sw==
X-Received: by 2002:ac8:435e:: with SMTP id a30mr7696711qtn.227.1633021029181;
        Thu, 30 Sep 2021 09:57:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id h4sm1924023qtb.67.2021.09.30.09.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 09:57:08 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mVzMp-000I1P-TV; Thu, 30 Sep 2021 13:57:07 -0300
Date:   Thu, 30 Sep 2021 13:57:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20210930165707.GA69218@ziepe.ca>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
 <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
 <20210916221854.GT3544071@ziepe.ca>
 <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210917050543.GA22003@lst.de>
 <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com>
 <20210917125301.GU3544071@ziepe.ca>
 <20210930104620.56a1d3e9.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930104620.56a1d3e9.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 10:46:20AM -0600, Alex Williamson wrote:
> I'm only aware that the PF driver enables basic SR-IOV configuration of
> VFs, ie. the number of enabled VFs. 

This is quite common in the netdev world, for instance you use the PF
driver to set the MAC addresses, QOS and other details on the VF
devices.

> only management of the number of child devices, but the flavor of each
> child, for example the non-homogeneous slice of resources allocated per
> child device.

Since the devices are PCI VFs they should be able to be used, with
configuration, any place a PCI VF is usable. EG vfio-pci, a Kernel
driver, etc.

This is why the PF needs to provide the configuration to support all
the use cases.
 
> I'm not aware of any standard mechanism for a PF driver to apply a
> configuration per VF.  

devlink is the standard way these days. It can model the PCI devices
and puts a control point in the PF driver.

I'd defer to Jiri, Leon and others to explain the details of this
though :)

> create these sorts device flavors.  For example, we might expose NIC VFs
> and administrative configuration should restrict VF1 to a 1Gbit
> interface while VF2 gets 10Gbit.

This is all being done already today through the PF driver using
either netink or devlink interfaces

Jason
