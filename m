Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AD24E582A
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiCWSLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiCWSLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:11:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFB6C88B16
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648059006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLCjEJMsxD02pVC+ZWBt5x6radALOQJ9jfriiBMEERg=;
        b=gwdax5qn7g775lCnbyAuUQQzf63bkFdEwNLUDgRgz8QTmyMCAgnY+4yov8Ri1w9hjXK5kq
        LyYEZL5ragTwiSt+VCFXhkj77XfMZbqzzIb580wScWSbthxai74j9reyY5vU8RLZnVO7ZN
        W2RRtSK+2yx/s3hhkoOMJWi/LCCSmcE=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-Bk6Ll4taMWyA9_5-QR3rpg-1; Wed, 23 Mar 2022 14:10:05 -0400
X-MC-Unique: Bk6Ll4taMWyA9_5-QR3rpg-1
Received: by mail-oo1-f72.google.com with SMTP id t31-20020a4a96e2000000b00320f7e020c3so1375287ooi.13
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VLCjEJMsxD02pVC+ZWBt5x6radALOQJ9jfriiBMEERg=;
        b=Kt/E+E14GPES5LYbUTq/eBZvZomPF80MjhfM4eDUZ7LoXv+SmbID51QYgQS/HV6j0W
         lb74WXtYno6PXuSYB3bHK6tf/quxaBoQvdrt62NaNOcL/mrHMgBs/ZqxKr8p4qqMQGzL
         EdpOs6ACpHIa6/gPQqnU4C2bIszDg5HKR3djwJiMsJliJNLnmTMYJiH4cbZJ72G+/XJC
         HC8mF3oNbHHhKUXeztTInoHxKkeBlN+EsK8ayBD3hP/qP1qQBFj5L2h4q4kgWRJ1Z+2u
         F4OIOD/mC3jeH2pblB1tTGR51tUSyyC5B4t2vGZpOsjqyNGbyxmlRJ8OU0LbzcdzpYAM
         y5iw==
X-Gm-Message-State: AOAM531zufPE78R5F2LVME6+mSE6MNuHKLruCUdICrzB1Kt8PbSld4n8
        y1dfpuAS7eyWEV28MC8tMCgfunmkgexJWYlkvoLZASl2VybwhM6lo0Q4cIZZm+TJyuxDsk4XscL
        RRyWf6UTLak+i
X-Received: by 2002:a05:6870:610c:b0:de:8b7a:2c1b with SMTP id s12-20020a056870610c00b000de8b7a2c1bmr43592oae.268.1648059004702;
        Wed, 23 Mar 2022 11:10:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrHaHkpxaFJ1Iy7hVsicFX1/wa0wSpP7Cj69xLCpwRuJbeH7W0SJG2cbEcbPVL/3gVNWgelw==
X-Received: by 2002:a05:6870:610c:b0:de:8b7a:2c1b with SMTP id s12-20020a056870610c00b000de8b7a2c1bmr43567oae.268.1648059004457;
        Wed, 23 Mar 2022 11:10:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r23-20020a056830237700b005b2610517c8sm306881oth.56.2022.03.23.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:10:04 -0700 (PDT)
Date:   Wed, 23 Mar 2022 12:10:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 10/12] iommufd: Add kAPI toward external drivers
Message-ID: <20220323121001.5b1c8c5d.alex.williamson@redhat.com>
In-Reply-To: <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 14:27:35 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> +/**
> + * iommufd_bind_pci_device - Bind a physical device to an iommu fd
> + * @fd: iommufd file descriptor.
> + * @pdev: Pointer to a physical PCI device struct
> + * @id: Output ID number to return to userspace for this device
> + *
> + * A successful bind establishes an ownership over the device and returns
> + * struct iommufd_device pointer, otherwise returns error pointer.
> + *
> + * A driver using this API must set driver_managed_dma and must not touch
> + * the device until this routine succeeds and establishes ownership.
> + *
> + * Binding a PCI device places the entire RID under iommufd control.
> + *
> + * The caller must undo this with iommufd_unbind_device()
> + */
> +struct iommufd_device *iommufd_bind_pci_device(int fd, struct pci_dev *pdev,
> +					       u32 *id)
> +{
> +	struct iommufd_device *idev;
> +	struct iommufd_ctx *ictx;
> +	struct iommu_group *group;
> +	int rc;
> +
> +	ictx = iommufd_fget(fd);
> +	if (!ictx)
> +		return ERR_PTR(-EINVAL);
> +
> +	group = iommu_group_get(&pdev->dev);
> +	if (!group) {
> +		rc = -ENODEV;
> +		goto out_file_put;
> +	}
> +
> +	/*
> +	 * FIXME: Use a device-centric iommu api and this won't work with
> +	 * multi-device groups
> +	 */
> +	rc = iommu_group_claim_dma_owner(group, ictx->filp);
> +	if (rc)
> +		goto out_group_put;
> +
> +	idev = iommufd_object_alloc(ictx, idev, IOMMUFD_OBJ_DEVICE);
> +	if (IS_ERR(idev)) {
> +		rc = PTR_ERR(idev);
> +		goto out_release_owner;
> +	}
> +	idev->ictx = ictx;
> +	idev->dev = &pdev->dev;
> +	/* The calling driver is a user until iommufd_unbind_device() */
> +	refcount_inc(&idev->obj.users);
> +	/* group refcount moves into iommufd_device */
> +	idev->group = group;
> +
> +	/*
> +	 * If the caller fails after this success it must call
> +	 * iommufd_unbind_device() which is safe since we hold this refcount.
> +	 * This also means the device is a leaf in the graph and no other object
> +	 * can take a reference on it.
> +	 */
> +	iommufd_object_finalize(ictx, &idev->obj);
> +	*id = idev->obj.id;
> +	return idev;
> +
> +out_release_owner:
> +	iommu_group_release_dma_owner(group);
> +out_group_put:
> +	iommu_group_put(group);
> +out_file_put:
> +	fput(ictx->filp);
> +	return ERR_PTR(rc);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_bind_pci_device);

I'm stumped why this needs to be PCI specific.  Anything beyond the RID
comment?  Please enlighten.  Thanks,

Alex

