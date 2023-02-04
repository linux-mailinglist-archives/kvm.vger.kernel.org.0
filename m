Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323AD68AA91
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbjBDO1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjBDO1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:27:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7636B2B2A9
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675520822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPOejpU0s4Yxr4vcE05SB6G59o9oYXhIdjS1qgFOtUM=;
        b=P0LCBu/9/rdNA5iaXMMtIb8fOwZZJbqOeX821mhuODHNZkgeoOd2XjmZX6raTqqiiJ+fbR
        EB7XfLcSdQSHtQ08j2sZ2YxZsA+4i8SFY7bfwrFZUbrGWoBw4j9Lh7c70AN5XTwUbkePgY
        YxFxdM5cJOzCC6I1gcm5h317zZgu0u0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-81-2fuFPE0XN-exv53QuFwW-g-1; Sat, 04 Feb 2023 09:27:01 -0500
X-MC-Unique: 2fuFPE0XN-exv53QuFwW-g-1
Received: by mail-io1-f70.google.com with SMTP id a2-20020a5d89c2000000b00717a8ac548cso4690886iot.9
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 06:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZPOejpU0s4Yxr4vcE05SB6G59o9oYXhIdjS1qgFOtUM=;
        b=pwqKYXEa9wgoTXxRjqmTeYZLemcufgYFAkKw01zh62MdneFN0+8ZIG3ktwOysBd6sG
         G2rSma0YgtUjvgF8QvM/v38sEn+h7QsGg9YKBkiAWXBC55DfifQ2o/0+b/TMlcE2Os7F
         wLh1rzznqGdu0SUFBdkIdkd8whjm3tdtbULqKM8RU/vbibDATDFs3ZIbOv8r3FojOIgo
         K9xC/9uSQ6V/oUs2TK1kD9DwgTztkVA/OOyxOR1EBXnK8F0Uc2tb4VllMsBN+SfyzQMt
         v0nyAfJIzqvA0OS60lfX8YTxF0W1ZH6HIhmx2PUo7NxD97grKf5zdQW6alyDNaNk8Myx
         uyyQ==
X-Gm-Message-State: AO0yUKVE8lGWsEekuhFsbcPZIhv3rW2pbJZNrgAfMxgXbOE3ubu6gY3I
        HsIzEW9sQ2VISB1qyBtv+1fl/Hvxok+YTZbSax3kf2nLp+NLAwBrVaVO4AIsKcYk0XOPc3SS2zu
        XQF3hJISkh6RG
X-Received: by 2002:a6b:da1a:0:b0:6e4:80fc:4885 with SMTP id x26-20020a6bda1a000000b006e480fc4885mr11792749iob.4.1675520819819;
        Sat, 04 Feb 2023 06:26:59 -0800 (PST)
X-Google-Smtp-Source: AK7set8KK8g0R1Rkm6Rss7diY/CTbo32ciCPFGF+6cPruSFuMK8wdPIkhSleZHUM4mon4x/zweRFpA==
X-Received: by 2002:a6b:da1a:0:b0:6e4:80fc:4885 with SMTP id x26-20020a6bda1a000000b006e480fc4885mr11792730iob.4.1675520819597;
        Sat, 04 Feb 2023 06:26:59 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g19-20020a02cd13000000b003b247647f96sm1844400jaq.14.2023.02.04.06.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 06:26:58 -0800 (PST)
Date:   Sat, 4 Feb 2023 07:26:58 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     lkp <lkp@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest
 interfaces
Message-ID: <20230204072658.0790485c.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75299A027633FE16852599CCC3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230203083345.711443-3-yi.l.liu@intel.com>
        <202302041603.N8YkuJks-lkp@intel.com>
        <DS0PR11MB75299A027633FE16852599CCC3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
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

On Sat, 4 Feb 2023 13:09:25 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: lkp <lkp@intel.com>
> > Sent: Saturday, February 4, 2023 4:56 PM
> > 
> > Hi Yi,
> > 
> > Thank you for the patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on awilliam-vfio/for-linus]
> > [also build test WARNING on linus/master v6.2-rc6 next-20230203]
> > [cannot apply to awilliam-vfio/next]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Yi-Liu/vfio-Update-
> > the-kdoc-for-vfio_device_ops/20230203-163612
> > base:   https://github.com/awilliam/linux-vfio.git for-linus
> > patch link:    https://lore.kernel.org/r/20230203083345.711443-3-
> > yi.l.liu%40intel.com
> > patch subject: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest
> > interfaces
> > reproduce:
> >         # https://github.com/intel-lab-
> > lkp/linux/commit/8db2c0d3414387502a6c743d6fa383cec960e3ba
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Yi-Liu/vfio-Update-the-kdoc-for-
> > vfio_device_ops/20230203-163612
> >         git checkout 8db2c0d3414387502a6c743d6fa383cec960e3ba
> >         make menuconfig
> >         # enable CONFIG_COMPILE_TEST,
> > CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
> >         make htmldocs
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> >   
> > >> Documentation/driver-api/vfio.rst:264: WARNING: Inline emphasis start-  
> > string without end-string.  
> > >> Documentation/driver-api/vfio.rst:296: WARNING: Literal block ends  
> > without a blank line; unexpected unindent.  
> > >> Documentation/driver-api/vfio.rst:305: WARNING: Unexpected  
> > indentation.  
> > >> Documentation/driver-api/vfio.rst:306: WARNING: Block quote ends  
> > without a blank line; unexpected unindent.
> >   
> 
> Hi Alex,
> 
> An updated version to address comments in this mail. 

Please send a v3 series.  Thanks,

Alex
 
> From 6d9c6f9b3d10da2923b28d8cfbf5fdd39e5fd8aa Mon Sep 17 00:00:00 2001
> From: Yi Liu <yi.l.liu@intel.com>
> Date: Tue, 31 Jan 2023 06:16:50 -0800
> Subject: [PATCH] docs: vfio: Update vfio.rst per latest interfaces
> 
> this imports the latest vfio_device_ops definition to vfio.rst.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst | 79 ++++++++++++++++++++++---------
>  1 file changed, 57 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f97825..0bfa7261f991 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -249,19 +249,21 @@ VFIO bus driver API
>  
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_register_group_dev() and
> -vfio_unregister_group_dev() respectively::
> +Following interfaces are called when devices are bound to and
> +unbound from the driver::
>  
> -	void vfio_init_group_dev(struct vfio_device *device,
> -				struct device *dev,
> -				const struct vfio_device_ops *ops);
> -	void vfio_uninit_group_dev(struct vfio_device *device);
>  	int vfio_register_group_dev(struct vfio_device *device);
> +	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>  	void vfio_unregister_group_dev(struct vfio_device *device);
>  
> -The driver should embed the vfio_device in its own structure and call
> -vfio_init_group_dev() to pre-configure it before going to registration
> -and call vfio_uninit_group_dev() after completing the un-registration.
> +The driver should embed the vfio_device in its own structure and use
> +vfio_alloc_device() to allocate the structure, and can register
> +@init/@release callbacks to manage any private state wrapping the
> +vfio_device::
> +
> +	vfio_alloc_device(dev_struct, member, dev, ops);
> +	void vfio_put_device(struct vfio_device *device);
> +
>  vfio_register_group_dev() indicates to the core to begin tracking the
>  iommu_group of the specified dev and register the dev as owned by a VFIO bus
>  driver. Once vfio_register_group_dev() returns it is possible for userspace to
> @@ -270,28 +272,61 @@ ready before calling it. The driver provides an ops structure for callbacks
>  similar to a file operations structure::
>  
>  	struct vfio_device_ops {
> -		int	(*open)(struct vfio_device *vdev);
> +		char	*name;
> +		int	(*init)(struct vfio_device *vdev);
>  		void	(*release)(struct vfio_device *vdev);
> +		int	(*bind_iommufd)(struct vfio_device *vdev,
> +					struct iommufd_ctx *ictx, u32 *out_device_id);
> +		void	(*unbind_iommufd)(struct vfio_device *vdev);
> +		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
> +		int	(*open_device)(struct vfio_device *vdev);
> +		void	(*close_device)(struct vfio_device *vdev);
>  		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
>  				size_t count, loff_t *ppos);
> -		ssize_t	(*write)(struct vfio_device *vdev,
> -				 const char __user *buf,
> -				 size_t size, loff_t *ppos);
> +		ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
> +			 size_t count, loff_t *size);
>  		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
>  				 unsigned long arg);
> -		int	(*mmap)(struct vfio_device *vdev,
> -				struct vm_area_struct *vma);
> +		int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> +		void	(*request)(struct vfio_device *vdev, unsigned int count);
> +		int	(*match)(struct vfio_device *vdev, char *buf);
> +		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
> +		int	(*device_feature)(struct vfio_device *device, u32 flags,
> +					  void __user *arg, size_t argsz);
>  	};
>  
>  Each function is passed the vdev that was originally registered
> -in the vfio_register_group_dev() call above.  This allows the bus driver
> -to obtain its private data using container_of().  The open/release
> -callbacks are issued when a new file descriptor is created for a
> -device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> -a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
> -interfaces implement the device region access defined by the device's
> -own VFIO_DEVICE_GET_REGION_INFO ioctl.
> +in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
> +call above. This allows the bus driver to obtain its private data using
> +container_of().
> +
> +::
> +
> +	- The init/release callbacks are issued when vfio_device is initialized
> +	  and released.
> +
> +	- The open/close_device callbacks are issued when a new file descriptor
> +	  is created for a device (e.g. via VFIO_GROUP_GET_DEVICE_FD).
> +
> +	- The ioctl callback provides a direct pass through for some VFIO_DEVICE_*
> +	  ioctls.
> +
> +	- The [un]bind_iommufd callbacks are issued when the device is bound to
> +	  and unbound from iommufd.
> +
> +	- The attach_ioas callback is issued when the device is attached to an
> +	  IOAS managed by the bound iommufd. The attached IOAS is automatically
> +	  detached when the device is unbound from iommufd.
> +
> +	- The read/write/mmap callbacks implement the device region access defined
> +	  by the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
> +
> +	- The request callback is issued when device is going to be unregistered.
>  
> +	- The dma_unmap callback is issued when a range of iova's are unmapped
> +	  in the container or IOAS attached by the device. Drivers which care
> +	  about iova unmap can implement this callback and must tolerate receiving
> +	  unmap notifications before the device is opened.
>  
>  PPC64 sPAPR implementation note
>  -------------------------------

