Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FFB4F9B78
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiDHRT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 13:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiDHRT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 13:19:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B1E6DF1F
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 10:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649438271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVG55BznU4nlgxhVE/x0B/rK4tFuulL7ZDq/n+epMnM=;
        b=a7WOAViGYMEMJ4gJvB7SGMmFPhUPwZsLZ3n/ndQ0ru3pIiyAog0lWed2Qema9K8Kw6TZuq
        /cIHtHetdpzfNMLGY8vP59gn3k5ce/HG+K+IHOaR5hpkLJSlKWpPSOugQ88wBP8GUjOd7c
        78xiajpF11pBvbFadQIQ3bCYImHhk+s=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-i-0_RwR5P5azJQUnQBmq9A-1; Fri, 08 Apr 2022 13:17:50 -0400
X-MC-Unique: i-0_RwR5P5azJQUnQBmq9A-1
Received: by mail-io1-f71.google.com with SMTP id z23-20020a6b0a17000000b00649f13ea3a7so6103238ioi.23
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 10:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DVG55BznU4nlgxhVE/x0B/rK4tFuulL7ZDq/n+epMnM=;
        b=UAZN+Rqz3+iejTOhPulpJyHbF9HjiotdLkaMuKRiVfJsJ1IP4f7hwkU9EM/MfhT185
         SoWSd6JeyV8Lu0Za5EihGYUD7S/xTERBagcriqsVQ8D4H8UpONogIYxrB3iTjr0y9e+D
         d+pEnXIMMixk6KUaJj9KZLHCE7QqJqwncDtaEw/nLxPrCqooZMqpAvkIq3MK6ToKaoR2
         36jGunZZeowjttYybgDoJKUeSSMk7s95Vz2Th7nwNGerbYsNctrxsoW1zPm5EolsC0ly
         DjtJ9oJPL1WI9NLgh6sR6D4JNRRYUaeqQmkDIpW7breSpGrYv1BDI2LwPfgaJdgbZtdq
         O48A==
X-Gm-Message-State: AOAM532L0qkmy7JP+VNvIOfnEQp11923y+3iBfg8aR9qnHM4VLQasIRH
        ZPjkl4AE4w77BPZt3Gna857XACzvM2fnCa2GqcKq25GRUcYhqTuEtPCyEbEhCf2dOt4vZUdyvwe
        Mt01tGQIAEHdi
X-Received: by 2002:a05:6638:300b:b0:317:a127:53ac with SMTP id r11-20020a056638300b00b00317a12753acmr9530915jak.77.1649438269870;
        Fri, 08 Apr 2022 10:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrE+UVtdfxBzSGZc0Too2ylUIgfEYbIcjumOCCqN9hKCMg20y84jfEUQGdx5IDQkjY9IODHg==
X-Received: by 2002:a05:6638:300b:b0:317:a127:53ac with SMTP id r11-20020a056638300b00b00317a12753acmr9530904jak.77.1649438269648;
        Fri, 08 Apr 2022 10:17:49 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id o7-20020a92c047000000b002ca30fcc954sm10598964ilf.36.2022.04.08.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:17:49 -0700 (PDT)
Date:   Fri, 8 Apr 2022 11:17:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Fix vf_token mechanism when device-specific
 VF drivers are used
Message-ID: <20220408111747.0bb943d4.alex.williamson@redhat.com>
In-Reply-To: <20220408170839.GA2120790@nvidia.com>
References: <0-v1-466f18ca49f5+26f-vfio_vf_token_jgg@nvidia.com>
        <20220408105305.1ee00b44.alex.williamson@redhat.com>
        <20220408170839.GA2120790@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Apr 2022 14:08:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Apr 08, 2022 at 10:53:05AM -0600, Alex Williamson wrote:
> > On Fri,  8 Apr 2022 12:10:15 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > get_pf_vdev() tries to check if a PF is a VFIO PF by looking at the driver:
> > > 
> > >        if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
> > > 
> > > However now that we have multiple VF and PF drivers this is no longer
> > > reliable.
> > > 
> > > This means that security tests realted to vf_token can be skipped by
> > > mixing and matching different VFIO PCI drivers.
> > > 
> > > Instead of trying to use the driver core to find the PF devices maintain a
> > > linked list of all PF vfio_pci_core_device's that we have called
> > > pci_enable_sriov() on.
> > > 
> > > When registering a VF just search the list to see if the PF is present and
> > > record the match permanently in the struct. PCI core locking prevents a PF
> > > from passing pci_disable_sriov() while VF drivers are attached so the VFIO
> > > owned PF becomes a static property of the VF.
> > > 
> > > In common cases where vfio does not own the PF the global list remains
> > > empty and the VF's pointer is statically NULL.
> > > 
> > > This also fixes a lockdep splat from recursive locking of the
> > > vfio_group::device_lock between vfio_device_get_from_name() and
> > > vfio_device_get_from_dev(). If the VF and PF share the same group this
> > > would deadlock.
> > > 
> > > Fixes: ff53edf6d6ab ("vfio/pci: Split the pci_driver code out of vfio_pci_core.c")
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/pci/vfio_pci_core.c | 109 ++++++++++++++++---------------
> > >  include/linux/vfio_pci_core.h    |   2 +
> > >  2 files changed, 60 insertions(+), 51 deletions(-)
> > > 
> > > This is probably for the rc cycle since it only became a problem when the
> > > migration drivers were merged.  
> > ...    
> > > @@ -1942,14 +1935,28 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> > >  	if (!device)
> > >  		return -ENODEV;
> > >  
> > > -	if (nr_virtfn == 0)
> > > -		pci_disable_sriov(pdev);
> > > -	else
> > > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > > +
> > > +	if (nr_virtfn) {
> > > +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> > > +		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
> > > +		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> > >  		ret = pci_enable_sriov(pdev, nr_virtfn);
> > > +		if (ret)
> > > +			goto out_del;
> > > +		ret = nr_virtfn;
> > > +		goto out_put;
> > > +	}  
> > 
> > If a user were to do:
> > 
> > 	# echo 1 > sriov_numvfs
> > 	# echo 2 > sriov_numvfs
> > 
> > Don't we have a problem that we've botched the list and the PF still
> > exists with 1 VF?  Thanks,  
> 
> Yes, that is a mistake. We need to do the list_add before the
> pci_enable_sriov because the probe() will inspect the
> vfio_pci_sriov_pfs list.
> 
> But since pci_enable_sriov can only be called once we can just gaurd
> directly against that.
> 
> I fixed it like this:
> 
> 		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> 		/*
> 		 * The thread that adds the vdev to the list is the only thread
> 		 * that gets to call pci_enable_sriov() and we will only allow
> 		 * it to be called once without going through
> 		 * pci_disable_sriov()
> 		 */
> 		if (!list_empty(&vdev->sriov_pfs_item)) {
> 			ret = -EINVAL;
> 			goto out_unlock;
> 		}
> 		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
> 		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> 		ret = pci_enable_sriov(pdev, nr_virtfn);
> 		if (ret)
> 			goto out_del;
> 
> Let me know if you have any other notes and I will fix them before
> resending

Nope, that's all I spotted.  Looks like a reasonable fix.  Thanks,

Alex

