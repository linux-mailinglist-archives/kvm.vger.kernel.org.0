Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC34FEA8F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiDLX1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiDLX02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E459AE43A4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649802961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JktBogVI4kc1D3+2Z9NnHkWj8Okas5MjF2VrwidxhM=;
        b=gwodl/KjswBmukLjjQQMt5ofnuBgxtNqL/QWHQ5NJP+FRruIaZKsKjPO4IG0KFfK80NwEj
        gI8Rak9keT7VaJR5yXAD8NNxlcyehUeq/Yawu95CotLDz51xL8ANptStF45L4KMH4jFb7z
        EfFc23yk/YfgdjDgMR635O/1WjIvAJE=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-IS7_wL6QOFCMq4CWZCGh5Q-1; Tue, 12 Apr 2022 16:13:46 -0400
X-MC-Unique: IS7_wL6QOFCMq4CWZCGh5Q-1
Received: by mail-ot1-f70.google.com with SMTP id b19-20020a056830105300b005b23d3eb1daso10659348otp.14
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5JktBogVI4kc1D3+2Z9NnHkWj8Okas5MjF2VrwidxhM=;
        b=aIVJRgB3FUpgKYqSQWA3Oz+6lVpHG2Y5CDyqykj9KbZ7FQmXuirE09EBN5uGE57rli
         MXIf+HqwEfuqlbXilOGQPbAMDB7Xgmynx7CKOlm1HqmPHFmah0c6tO+Q+ohpfzt5rIFT
         aKnlQw8AWt/Ju3JrOM9rZG7EdIvl5k4dfnLdgE5rMh0yqRAayr+EUO4y7oYECohtLteh
         Hl9p7N31AAE9lfghn7J3DfF9LPSVB0w7HSaaO3HCHCUyqEX6psJupXlGglfzPoGieggN
         ssiBI5tpghfOhnT7cavATN0P2tf9+v5v9gw7TvYZnuDk4h+rGZqxRNi4TgsD8ut5DmJA
         AmcA==
X-Gm-Message-State: AOAM532YUZf5WeYLotuNL4sKekEii4KfAYeSei8JD5SkYfMpX0icvYA8
        jAXv4/dEJHrYGZqjllNi93AWf4k+j6cDElW7yQj/f29uCZ/x7pRZ5lK1a+BY0nhUvqLCuXHivTU
        qUAzASZZMpGgn
X-Received: by 2002:a4a:e1fb:0:b0:324:6bad:8d1a with SMTP id u27-20020a4ae1fb000000b003246bad8d1amr12368035ood.84.1649794424928;
        Tue, 12 Apr 2022 13:13:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzURPZFWaoxAa/lH8nyppkb9JMaq8+uPXEdMNpwKB0qNSN5IxHYDobSB0S04BsHiCOQ2pv5wg==
X-Received: by 2002:a4a:e1fb:0:b0:324:6bad:8d1a with SMTP id u27-20020a4ae1fb000000b003246bad8d1amr12368027ood.84.1649794424694;
        Tue, 12 Apr 2022 13:13:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q6-20020a056870028600b000d9be0ee766sm13335720oaf.57.2022.04.12.13.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:13:44 -0700 (PDT)
Date:   Tue, 12 Apr 2022 14:13:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Fix vf_token mechanism when
 device-specific VF drivers are used
Message-ID: <20220412141342.72a77d79.alex.williamson@redhat.com>
In-Reply-To: <20220412195244.GK2120790@nvidia.com>
References: <0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com>
        <20220412122544.4a56f20a.alex.williamson@redhat.com>
        <20220412195244.GK2120790@nvidia.com>
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

On Tue, 12 Apr 2022 16:52:44 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 12, 2022 at 12:25:44PM -0600, Alex Williamson wrote:
> > On Mon, 11 Apr 2022 10:56:31 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > @@ -1732,10 +1705,28 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
> > >  static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
> > >  {
> > >  	struct pci_dev *pdev = vdev->pdev;
> > > +	struct vfio_pci_core_device *cur;
> > > +	struct pci_dev *physfn;
> > >  	int ret;
> > >  
> > > -	if (!pdev->is_physfn)
> > > +	if (!pdev->is_physfn) {
> > > +		/*
> > > +		 * If this VF was created by our vfio_pci_core_sriov_configure()
> > > +		 * then we can find the PF vfio_pci_core_device now, and due to
> > > +		 * the locking in pci_disable_sriov() it cannot change until
> > > +		 * this VF device driver is removed.
> > > +		 */
> > > +		physfn = pci_physfn(vdev->pdev);
> > > +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> > > +		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
> > > +			if (cur->pdev == physfn) {
> > > +				vdev->sriov_pf_core_dev = cur;
> > > +				break;
> > > +			}
> > > +		}
> > > +		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> > >  		return 0;
> > > +	}
> > >  
> > >  	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> > >  	if (!vdev->vf_token)  
> > 
> > One more comment on final review; are we equating !is_physfn to
> > is_virtfn above?  This branch was originally meant to kick out both VFs
> > and non-SRIOV PFs.  Calling pci_physfn() on a !is_virtfn device will
> > return itself, so we should never find a list match, but we also don't
> > need to look for a match for !is_virtfn, so it's a bit confusing and
> > slightly inefficient.  Should the new code be added in a separate
> > is_virtfn branch above the existing !is_physfn test?  Thanks,  
> 
> I started at it for a while and came the same conclusion, I
> misunderstood that is_physfn is really trying to be
> is_sriov_physfn.. So not a bug, but not really clear code.
> 
> I added this, I'll repost it.

Looks good.  Thanks,

Alex
 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 8bf0f18e668a32..3c6493957abe19 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1709,7 +1709,7 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
>  	struct pci_dev *physfn;
>  	int ret;
>  
> -	if (!pdev->is_physfn) {
> +	if (pdev->is_virtfn) {
>  		/*
>  		 * If this VF was created by our vfio_pci_core_sriov_configure()
>  		 * then we can find the PF vfio_pci_core_device now, and due to
> @@ -1728,6 +1728,10 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
>  		return 0;
>  	}
>  
> +	/* Not a SRIOV PF */
> +	if (!pdev->is_physfn)
> +		return 0;
> +
>  	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
>  	if (!vdev->vf_token)
>  		return -ENOMEM;
> 
> 
> Thanks,
> Jason
> 

