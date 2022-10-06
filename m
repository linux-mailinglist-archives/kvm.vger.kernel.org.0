Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4825F6D56
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 20:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiJFSLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiJFSLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 14:11:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80458D0C9
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 11:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665079869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSF04mLiE9piAEyD/d1ff4/TmCyx3idjNdHJQ0Bspp8=;
        b=QfU3H2SbwTNoE2KpO2MJeR0rQGuaQb0UV9YG/rvfP7UrPhRjWfy9PsJsulC/t9kgUDnNIR
        12slL4oEOzTF+FTm7LWFnMPaha5XNzSE1jyCt4iwuXDI70nylioIxTXHS7tpdVyOCte1XC
        jOLG5cCnw3sF8JZIy91VrIK5DD8qq3w=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-170-vw7H1_JtPMOxCW13-ck13A-1; Thu, 06 Oct 2022 14:11:07 -0400
X-MC-Unique: vw7H1_JtPMOxCW13-ck13A-1
Received: by mail-il1-f200.google.com with SMTP id j1-20020a056e02154100b002f9abf53769so2106905ilu.23
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rSF04mLiE9piAEyD/d1ff4/TmCyx3idjNdHJQ0Bspp8=;
        b=3aEg4vtol8mnNzYISUmq6We4wEZXcDDL7tj98RxbH7CUM2iIx13VmM7/AzUm75C2CL
         LHusvSxtP/Zl1h0ylTxD1pW++muZW3TbyFX6uKOQvMYfi++1Zok9zIwvjOUAsVmyFqg3
         pB8PNS5Gr6dKjL2TCFjK10wziHcQGCoO+Js8NdjhTbTNk9vjt//k8dBZhcyrp1KnUc3O
         INW0oXefFWGYS1ZsuAIzThgEfAvr+oaF46G8VUyV5uwmXkAzsiZ1vmfUeLjfJNjaWchL
         9VMuBvwL2HNTDFkX/ssbzFe4RrNsvpPLFbY2ITmZF+/HJRcks3I1U0sqNIRo6JQJSZxh
         +mDg==
X-Gm-Message-State: ACrzQf03CQqYdl2h/deT0sdhzyl558kB7Jm0W9h0VTaMmq5nfMYe3tV8
        pdZxNHg+lvqCScTWgXa+FAMhXbi9SqO3DxGwaiK3Ayy5EqEDFFGyJ+BUMQTwvK0LEpkEtSQyPqr
        YI9QpFQTcpwDH
X-Received: by 2002:a05:6e02:1a0f:b0:2f9:6dcb:c451 with SMTP id s15-20020a056e021a0f00b002f96dcbc451mr447036ild.290.1665079867081;
        Thu, 06 Oct 2022 11:11:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4YGxAPTA22DwffgR4HgyQrAo6tFgowT4tNe0zrV9NL24qia8r+8UBNDtiwWzZdvK04JriHPg==
X-Received: by 2002:a05:6e02:1a0f:b0:2f9:6dcb:c451 with SMTP id s15-20020a056e021a0f00b002f96dcbc451mr447020ild.290.1665079866822;
        Thu, 06 Oct 2022 11:11:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u185-20020a0223c2000000b0035b818e7ff2sm13417jau.158.2022.10.06.11.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 11:11:06 -0700 (PDT)
Date:   Thu, 6 Oct 2022 12:11:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/3] vfio: Add vfio_file_is_group()
Message-ID: <20221006121104.3cc625d5.alex.williamson@redhat.com>
In-Reply-To: <1-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
        <1-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Oct 2022 09:40:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This replaces uses of vfio_file_iommu_group() which were only detecting if
> the file is a VFIO file with no interest in the actual group.
> 
> The only remaning user of vfio_file_iommu_group() is in KVM for the SPAPR
> stuff. It passes the iommu_group into the arch code through kvm for some
> reason.
> 
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  drivers/vfio/vfio_main.c         | 14 ++++++++++++++
>  include/linux/vfio.h             |  1 +
>  virt/kvm/vfio.c                  | 20 ++++++++++++++++++--
>  4 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 59a28251bb0b97..badc9d828cac20 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1313,7 +1313,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  		}
>  
>  		/* Ensure the FD is a vfio group FD.*/
> -		if (!vfio_file_iommu_group(file)) {
> +		if (!vfio_file_is_group(file)) {
>  			fput(file);
>  			ret = -EINVAL;
>  			break;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 9207e6c0e3cb26..7866849be56ef6 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1553,17 +1553,31 @@ static const struct file_operations vfio_device_fops = {
>   * @file: VFIO group file
>   *
>   * The returned iommu_group is valid as long as a ref is held on the file.
> + * This function is deprecated, only the SPAPR path in kvm should call it.
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file)
>  {
>  	struct vfio_group *group = file->private_data;
>  
> +	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
> +		return NULL;
> +
>  	if (file->f_op != &vfio_group_fops)

Nit, with the function below, shouldn't the line above become:

	if (!vfio_file_is_group(file))

Thanks,
Alex

>  		return NULL;
>  	return group->iommu_group;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>  
> +/**
> + * vfio_file_is_group - True if the file is usable with VFIO aPIS
> + * @file: VFIO group file
> + */
> +bool vfio_file_is_group(struct file *file)
> +{
> +	return file->f_op == &vfio_group_fops;
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_is_group);
> +
>  /**
>   * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
>   *        is always CPU cache coherent
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ee399a768070d0..e7cebeb875dd1a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -199,6 +199,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>   * External user API
>   */
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
> +bool vfio_file_is_group(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index ce1b01d02c5197..54aec3b0559c70 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -61,6 +61,23 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
>  	return ret;
>  }
>  
> +static bool kvm_vfio_file_is_group(struct file *file)
> +{
> +	bool (*fn)(struct file *file);
> +	bool ret;
> +
> +	fn = symbol_get(vfio_file_is_group);
> +	if (!fn)
> +		return false;
> +
> +	ret = fn(file);
> +
> +	symbol_put(vfio_file_is_group);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>  static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  {
>  	struct iommu_group *(*fn)(struct file *file);
> @@ -77,7 +94,6 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  	return ret;
>  }
>  
> -#ifdef CONFIG_SPAPR_TCE_IOMMU
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
>  					     struct kvm_vfio_group *kvg)
>  {
> @@ -136,7 +152,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  		return -EBADF;
>  
>  	/* Ensure the FD is a vfio group FD.*/
> -	if (!kvm_vfio_file_iommu_group(filp)) {
> +	if (!kvm_vfio_file_is_group(filp)) {
>  		ret = -EINVAL;
>  		goto err_fput;
>  	}

