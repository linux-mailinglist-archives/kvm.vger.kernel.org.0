Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E19647838
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLHVtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLHVta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:49:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2499D88B
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlSLHZU0UyP1zXnoWLl9wrALkHazYkzcA1gB5b/QBD4=;
        b=h8gJQMxyvGsKoHS5lScHZNQS2cRBg/WEEe6illL3JvtXb8QU1kG7lreELn4yw/hkQInxBq
        v3aASESWuF4iHEQ+zn3lIzLgpt0v2KSvfAJ94F3mpnxDgopE+zPeF2wKRyHrT2Aqqg9w5+
        BDXW5eK7BY+Za/IDjxEha5vcOV7d2YY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-F04sXEp4PIaHUwm31E7IwQ-1; Thu, 08 Dec 2022 16:48:29 -0500
X-MC-Unique: F04sXEp4PIaHUwm31E7IwQ-1
Received: by mail-io1-f70.google.com with SMTP id n8-20020a6b4108000000b006de520dc5c9so1019168ioa.19
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 13:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JlSLHZU0UyP1zXnoWLl9wrALkHazYkzcA1gB5b/QBD4=;
        b=pEtO3o8GcoRMpNrK0V5V5hYf+bO8Y+CI6R5xrJojXJsPuln/hHVagHk8GHIYkxfyby
         flUBBKmh0YdfnzYC4fQp8EgwOZzEM/3UCZ88mcf8e3Ysn77qsRnEyf1Bk8lj8AW8MNp5
         427sPBBVUpO+bKd7DkxrwfX+wle8gd0ieypX/lH4W/8wdwgvsdh9XNakVs2mE3GE53Tn
         J6pH/9zoJrB/c1804Yq4cqP8SZkYX7wUi7NZyUxHD3+wHT7l38mZW+gGAs+YCOvpOJDt
         +qco4Y0PcJJyARid2bqAkNIV6i8ZYegKqYaOvm7hJenO+8Dl9kNsAOw9aBLZq6Qujegw
         uDdw==
X-Gm-Message-State: ANoB5pm2SBdLd38Rs4DKOEXVpAV6HWn37m9Bk4i9UAFyvMO8bvOSk4jg
        WbDKf5y9vo1/dAS0DpQ0Z3/oNnsphK5zqfWbu9fhFBKV+WyhShTBpft6shWPWLtojwKHFbo7Obm
        MqCHuur7FPizt
X-Received: by 2002:a02:caa9:0:b0:38a:4f3e:a8f3 with SMTP id e9-20020a02caa9000000b0038a4f3ea8f3mr7633706jap.118.1670536108938;
        Thu, 08 Dec 2022 13:48:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5z9amCYid4VD2QKF39+LEnq0/gOoAHkRrex2ThE5am1xPidFCUVQZkXXRQS46wsmIHSMDr3g==
X-Received: by 2002:a02:caa9:0:b0:38a:4f3e:a8f3 with SMTP id e9-20020a02caa9000000b0038a4f3ea8f3mr7633686jap.118.1670536108715;
        Thu, 08 Dec 2022 13:48:28 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q18-20020a927512000000b00302bb083c2bsm1115985ilc.21.2022.12.08.13.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 13:48:28 -0800 (PST)
Date:   Thu, 8 Dec 2022 14:48:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 2/9] vfio/type1: Check that every device
 supports IOMMU_CAP_INTR_REMAP
Message-ID: <20221208144825.33823739.alex.williamson@redhat.com>
In-Reply-To: <2-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
        <2-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Dec 2022 16:26:29 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> iommu_group_for_each_dev() exits the loop at the first callback that
> returns 1 - thus returning 1 fails to check the rest of the devices in the
> group.
> 
> msi_remap (aka secure MSI) requires that all the devices in the group
> support it, not just any one. This is only a theoretical problem as no
> current drivers will have different secure MSI properties within a group.

Which is exactly how Robin justified the behavior in the referenced
commit:

  As with domains, any capability must in practice be consistent for
  devices in a given group - and after all it's still the same
  capability which was expected to be consistent across an entire bus!
  - so there's no need for any complicated validation.

That suggests to me that it's intentional that we break if any device
supports the capability and therefore this isn't so much a "Fixes:", as
it is a refactoring expressly to support msi_device_has_secure_msi(),
which cannot make these sort of assumptions as a non-group API.  Thanks,

Alex

> Make vfio_iommu_device_secure_msi() reduce AND across all the devices.
> 
> Fixes: eed20c782aea ("vfio/type1: Simplify bus_type determination")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe98c00d4..3025b4e643c135 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2160,10 +2160,12 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>  	list_splice_tail(iova_copy, iova);
>  }
>  
> -/* Redundantly walks non-present capabilities to simplify caller */
> -static int vfio_iommu_device_capable(struct device *dev, void *data)
> +static int vfio_iommu_device_secure_msi(struct device *dev, void *data)
>  {
> -	return device_iommu_capable(dev, (enum iommu_cap)data);
> +	bool *secure_msi = data;
> +
> +	*secure_msi &= device_iommu_capable(dev, IOMMU_CAP_INTR_REMAP);
> +	return 0;
>  }
>  
>  static int vfio_iommu_domain_alloc(struct device *dev, void *data)
> @@ -2278,9 +2280,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	INIT_LIST_HEAD(&domain->group_list);
>  	list_add(&group->next, &domain->group_list);
>  
> -	msi_remap = irq_domain_check_msi_remap() ||
> -		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
> -					     vfio_iommu_device_capable);
> +	msi_remap = irq_domain_check_msi_remap();
> +	if (!msi_remap) {
> +		msi_remap = true;
> +		iommu_group_for_each_dev(iommu_group, &msi_remap,
> +					 vfio_iommu_device_secure_msi);
> +	}
>  
>  	if (!allow_unsafe_interrupts && !msi_remap) {
>  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",

