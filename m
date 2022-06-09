Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDCA544758
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiFIJZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 05:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiFIJZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 05:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 533AA737B5
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 02:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654766742;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K/wQYmAWiOpvm5EZMlsObV+0ypslbBZr0gqdMgG24ug=;
        b=epDjBgWyJVyqLLoXaNyoKgn3VHylGnJtMDHyiyEZBt3y4U+qk9r7lteZWdXPwPDXUpRqX7
        IOaevVn5Ao6S7ffiaufofWFp6A9yPQtzqd/oEiqwwoSgRZzthVXAMlDqpVkqzygBEWHlXw
        GZeNvdMeRWV3+aHtodEJqt5n81ecl60=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-NkMPsKMvMAKkbMR0ntQ9yw-1; Thu, 09 Jun 2022 05:25:33 -0400
X-MC-Unique: NkMPsKMvMAKkbMR0ntQ9yw-1
Received: by mail-wm1-f72.google.com with SMTP id p18-20020a05600c23d200b0039c40c05687so4946942wmb.2
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 02:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K/wQYmAWiOpvm5EZMlsObV+0ypslbBZr0gqdMgG24ug=;
        b=JIVXxpvOjtmPHOaELWZjeMvp6vmtuuUcmJyN4Mx5ZagVP7S/BnDAnACJvpG1u8bYqF
         0FIzaUw4wJet2qCOOd0Unj8e8zEW0drEAaBuW8HpMYbXRMGQChp7DzLf0D6MLGCejnXe
         SOXyY3zgO0vnCMulsHAWQl3HEFsf4VwcsPaAbVdQubWnx3RQ8U6eo22PUm5LkOhsM+pt
         2UHFUdGHIh4NA8Wrqp7EvaZzSIHHUCAbbX5UjJ7Vtm1eQmUGRsxKH2VVZZqO1ONFckOV
         0L8qTV0/5TY8Ghih3dgiWRWjnQEIShaU9MZeUdnhUrRngY02naIcNMnYzDVHGIck1o4i
         dqqw==
X-Gm-Message-State: AOAM532m0fQhu9l1fQRHjWlqa7IPcSDpG8d5bUkUJ+mG5S6wPHLgJwJP
        UTJZUerLQpiv/mMkM0RURUgdSO9B5y8efyTCugeyoA6HYGO35gTv1xGZ5BmTVOHFSGJsfdl8vMt
        M1ci81mzedac0
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr36828413wro.603.1654766732695;
        Thu, 09 Jun 2022 02:25:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqhxswBCX4/VxY6WvOQqaKE+fn5Ef6iWienYivBxkgLER6Gmgsn6CVv0Wp7/2Fv5LPc1XIrQ==
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr36828379wro.603.1654766732303;
        Thu, 09 Jun 2022 02:25:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h11-20020a5d688b000000b0020e63ab5d78sm23457790wru.26.2022.06.09.02.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 02:25:31 -0700 (PDT)
Message-ID: <c5ba2683-8186-5e97-928e-ecac78fbf049@redhat.com>
Date:   Thu, 9 Jun 2022 11:25:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] vfio: de-extern-ify function prototypes
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kwankhede@nvidia.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, diana.craciun@oss.nxp.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        jgg@nvidia.com, yishaih@nvidia.com, hch@lst.de
References: <165471414407.203056.474032786990662279.stgit@omen>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <165471414407.203056.474032786990662279.stgit@omen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 6/8/22 20:55, Alex Williamson wrote:
> The use of 'extern' in function prototypes has been disrecommended in
> the kernel coding style for several years now, remove them from all vfio
> related files so contributors no longer need to decide between style and
> consistency.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>
> A patch in the same vein was proposed about a year ago, but tied to an ill
> fated series and forgotten.  Now that we're at the beginning of a new
> development cycle, I'd like to propose kicking off the v5.20 vfio next
> branch with this patch and would kindly ask anyone with pending respins or
> significant conflicts to rebase on top of this patch.  Thanks!
>
>  Documentation/driver-api/vfio-mediated-device.rst |   10 ++-
>  drivers/s390/cio/vfio_ccw_cp.h                    |   12 ++--
>  drivers/s390/cio/vfio_ccw_private.h               |    6 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |    2 -
>  drivers/vfio/platform/vfio_platform_private.h     |   21 +++---
>  include/linux/vfio.h                              |   70 ++++++++++-----------
>  include/linux/vfio_pci_core.h                     |   65 ++++++++++----------
>  7 files changed, 91 insertions(+), 95 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index eded8719180f..1c57815619fd 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -114,11 +114,11 @@ to register and unregister itself with the core driver:
>  
>  * Register::
>  
> -    extern int  mdev_register_driver(struct mdev_driver *drv);
> +    int mdev_register_driver(struct mdev_driver *drv);
>  
>  * Unregister::
>  
> -    extern void mdev_unregister_driver(struct mdev_driver *drv);
> +    void mdev_unregister_driver(struct mdev_driver *drv);
>  
>  The mediated bus driver's probe function should create a vfio_device on top of
>  the mdev_device and connect it to an appropriate implementation of
> @@ -127,8 +127,8 @@ vfio_device_ops.
>  When a driver wants to add the GUID creation sysfs to an existing device it has
>  probe'd to then it should call::
>  
> -	extern int  mdev_register_device(struct device *dev,
> -	                                 struct mdev_driver *mdev_driver);
> +    int mdev_register_device(struct device *dev,
> +                             struct mdev_driver *mdev_driver);
>  
>  This will provide the 'mdev_supported_types/XX/create' files which can then be
>  used to trigger the creation of a mdev_device. The created mdev_device will be
> @@ -136,7 +136,7 @@ attached to the specified driver.
>  
>  When the driver needs to remove itself it calls::
>  
> -	extern void mdev_unregister_device(struct device *dev);
> +    void mdev_unregister_device(struct device *dev);
>  
>  Which will unbind and destroy all the created mdevs and remove the sysfs files.
>  
> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
> index e4c436199b4c..3194d887e08e 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.h
> +++ b/drivers/s390/cio/vfio_ccw_cp.h
> @@ -41,11 +41,11 @@ struct channel_program {
>  	struct ccw1 *guest_cp;
>  };
>  
> -extern int cp_init(struct channel_program *cp, union orb *orb);
> -extern void cp_free(struct channel_program *cp);
> -extern int cp_prefetch(struct channel_program *cp);
> -extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
> -extern void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
> -extern bool cp_iova_pinned(struct channel_program *cp, u64 iova);
> +int cp_init(struct channel_program *cp, union orb *orb);
> +void cp_free(struct channel_program *cp);
> +int cp_prefetch(struct channel_program *cp);
> +union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
> +void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
> +bool cp_iova_pinned(struct channel_program *cp, u64 iova);
>  
>  #endif
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 7272eb788612..b7163bac8cc7 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -119,10 +119,10 @@ struct vfio_ccw_private {
>  	struct work_struct	crw_work;
>  } __aligned(8);
>  
> -extern int vfio_ccw_mdev_reg(struct subchannel *sch);
> -extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
> +int vfio_ccw_mdev_reg(struct subchannel *sch);
> +void vfio_ccw_mdev_unreg(struct subchannel *sch);
>  
> -extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
> +int vfio_ccw_sch_quiesce(struct subchannel *sch);
>  
>  extern struct mdev_driver vfio_ccw_mdev_driver;
>  
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 4ad63ececb91..7a29f572f93d 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -39,7 +39,7 @@ struct vfio_fsl_mc_device {
>  	struct vfio_fsl_mc_irq      *mc_irqs;
>  };
>  
> -extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> +int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>  			       u32 flags, unsigned int index,
>  			       unsigned int start, unsigned int count,
>  			       void *data);
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 520d2a8e8375..691b43f4b2b2 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -78,21 +78,20 @@ struct vfio_platform_reset_node {
>  	vfio_platform_reset_fn_t of_reset;
>  };
>  
> -extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> -				      struct device *dev);
> +int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> +			       struct device *dev);
>  void vfio_platform_remove_common(struct vfio_platform_device *vdev);
>  
> -extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
> -extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
> +int vfio_platform_irq_init(struct vfio_platform_device *vdev);
> +void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
>  
> -extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> -					uint32_t flags, unsigned index,
> -					unsigned start, unsigned count,
> -					void *data);
> +int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> +				 uint32_t flags, unsigned index,
> +				 unsigned start, unsigned count, void *data);
>  
> -extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
> -extern void vfio_platform_unregister_reset(const char *compat,
> -					   vfio_platform_reset_fn_t fn);
> +void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
> +void vfio_platform_unregister_reset(const char *compat,
> +				    vfio_platform_reset_fn_t fn);
>  #define vfio_platform_register_reset(__compat, __reset)		\
>  static struct vfio_platform_reset_node __reset ## _node = {	\
>  	.owner = THIS_MODULE,					\
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index aa888cc51757..49580fa2073a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -140,19 +140,19 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>  /*
>   * External user API
>   */
> -extern struct iommu_group *vfio_file_iommu_group(struct file *file);
> -extern bool vfio_file_enforced_coherent(struct file *file);
> -extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> -extern bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> +struct iommu_group *vfio_file_iommu_group(struct file *file);
> +bool vfio_file_enforced_coherent(struct file *file);
> +void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>  
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
>  
> -extern int vfio_pin_pages(struct vfio_device *device, unsigned long *user_pfn,
> -			  int npage, int prot, unsigned long *phys_pfn);
> -extern int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> -			    int npage);
> -extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
> -		       void *data, size_t len, bool write);
> +int vfio_pin_pages(struct vfio_device *device, unsigned long *user_pfn,
> +		   int npage, int prot, unsigned long *phys_pfn);
> +int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> +		     int npage);
> +int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
> +		void *data, size_t len, bool write);
>  
>  /* each type has independent events */
>  enum vfio_notify_type {
> @@ -162,13 +162,13 @@ enum vfio_notify_type {
>  /* events for VFIO_IOMMU_NOTIFY */
>  #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
>  
> -extern int vfio_register_notifier(struct vfio_device *device,
> -				  enum vfio_notify_type type,
> -				  unsigned long *required_events,
> -				  struct notifier_block *nb);
> -extern int vfio_unregister_notifier(struct vfio_device *device,
> -				    enum vfio_notify_type type,
> -				    struct notifier_block *nb);
> +int vfio_register_notifier(struct vfio_device *device,
> +			   enum vfio_notify_type type,
> +			   unsigned long *required_events,
> +			   struct notifier_block *nb);
> +int vfio_unregister_notifier(struct vfio_device *device,
> +			     enum vfio_notify_type type,
> +			     struct notifier_block *nb);
>  
>  
>  /*
> @@ -178,25 +178,24 @@ struct vfio_info_cap {
>  	struct vfio_info_cap_header *buf;
>  	size_t size;
>  };
> -extern struct vfio_info_cap_header *vfio_info_cap_add(
> -		struct vfio_info_cap *caps, size_t size, u16 id, u16 version);
> -extern void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
> +struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
> +					       size_t size, u16 id,
> +					       u16 version);
> +void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
>  
> -extern int vfio_info_add_capability(struct vfio_info_cap *caps,
> -				    struct vfio_info_cap_header *cap,
> -				    size_t size);
> +int vfio_info_add_capability(struct vfio_info_cap *caps,
> +			     struct vfio_info_cap_header *cap, size_t size);
>  
> -extern int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
> -					      int num_irqs, int max_irq_type,
> -					      size_t *data_size);
> +int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
> +				       int num_irqs, int max_irq_type,
> +				       size_t *data_size);
>  
>  struct pci_dev;
>  #if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
> -extern void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
> -extern void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
> -extern long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
> -				       unsigned int cmd,
> -				       unsigned long arg);
> +void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
> +void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
> +long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group, unsigned int cmd,
> +				unsigned long arg);
>  #else
>  static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
>  {
> @@ -230,10 +229,9 @@ struct virqfd {
>  	struct virqfd		**pvirqfd;
>  };
>  
> -extern int vfio_virqfd_enable(void *opaque,
> -			      int (*handler)(void *, void *),
> -			      void (*thread)(void *, void *),
> -			      void *data, struct virqfd **pvirqfd, int fd);
> -extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
> +int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
> +		       void (*thread)(void *, void *), void *data,
> +		       struct virqfd **pvirqfd, int fd);
> +void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  
>  #endif /* VFIO_H */
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 23c176d4b073..22de2bce6394 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -147,23 +147,23 @@ struct vfio_pci_core_device {
>  #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
>  #define irq_is(vdev, type) (vdev->irq_type == type)
>  
> -extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
> -extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
> +void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
> +void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
>  
> -extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
> -				   uint32_t flags, unsigned index,
> -				   unsigned start, unsigned count, void *data);
> +int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
> +			    uint32_t flags, unsigned index,
> +			    unsigned start, unsigned count, void *data);
>  
> -extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
> -				  char __user *buf, size_t count,
> -				  loff_t *ppos, bool iswrite);
> +ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
> +			   char __user *buf, size_t count,
> +			   loff_t *ppos, bool iswrite);
>  
> -extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> -			       size_t count, loff_t *ppos, bool iswrite);
> +ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> +			size_t count, loff_t *ppos, bool iswrite);
>  
>  #ifdef CONFIG_VFIO_PCI_VGA
> -extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> -			       size_t count, loff_t *ppos, bool iswrite);
> +ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> +			size_t count, loff_t *ppos, bool iswrite);
>  #else
>  static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
>  				      char __user *buf, size_t count,
> @@ -173,32 +173,31 @@ static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
>  }
>  #endif
>  
> -extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
> -			       uint64_t data, int count, int fd);
> +long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
> +			uint64_t data, int count, int fd);
>  
> -extern int vfio_pci_init_perm_bits(void);
> -extern void vfio_pci_uninit_perm_bits(void);
> +int vfio_pci_init_perm_bits(void);
> +void vfio_pci_uninit_perm_bits(void);
>  
> -extern int vfio_config_init(struct vfio_pci_core_device *vdev);
> -extern void vfio_config_free(struct vfio_pci_core_device *vdev);
> +int vfio_config_init(struct vfio_pci_core_device *vdev);
> +void vfio_config_free(struct vfio_pci_core_device *vdev);
>  
> -extern int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
> -					unsigned int type, unsigned int subtype,
> -					const struct vfio_pci_regops *ops,
> -					size_t size, u32 flags, void *data);
> +int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
> +				 unsigned int type, unsigned int subtype,
> +				 const struct vfio_pci_regops *ops,
> +				 size_t size, u32 flags, void *data);
>  
> -extern int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
> -				    pci_power_t state);
> +int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
> +			     pci_power_t state);
>  
> -extern bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
> -extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device
> -						    *vdev);
> -extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
> -extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
> -					       u16 cmd);
> +bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
> +void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
> +u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
> +void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
> +					u16 cmd);
>  
>  #ifdef CONFIG_VFIO_PCI_IGD
> -extern int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
> +int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
>  #else
>  static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  {
> @@ -207,8 +206,8 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  #endif
>  
>  #ifdef CONFIG_S390
> -extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
> -				       struct vfio_info_cap *caps);
> +int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
> +				struct vfio_info_cap *caps);
>  #else
>  static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  					      struct vfio_info_cap *caps)
>
>

