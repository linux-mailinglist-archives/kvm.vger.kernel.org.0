Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67B26C4D7A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCVOWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 10:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjCVOWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 10:22:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56959ED;
        Wed, 22 Mar 2023 07:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679494946; x=1711030946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=StLSUG9jSdG4qzMIdPRlmgOzudWc7UibT0yv+xP5TNI=;
  b=lknA6XlkU4H+l8j21jG53FbM8/Pp292PGvpmqyKXQQA5/FRi5SCOksvP
   zdLlrPQCO2MjnjwE9Cr6UJsMg/tRq2K7t2ojowYqwlIcj7GBb5A5VlHqw
   74VEtHV7GxJxGQI66iBeJfKL3qlfVcYbELxw7CGcM+hwngjUJKV+gft3Z
   kzCIz/kC62l9C2yZNZXksKElMWlobwO+D71hcjLc4nLavp2ZaZFXhh6jo
   pB87uiAT5D10V9fS7UKQYG/mf2/CcB0pkcCgMY/jESIpug1Th5AUOKbco
   xhyMvEI+lBg9B5dBECd7M8giV7SQPNFQT7xp+HDzGFZCe9OUPh/et7ysE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="340760576"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="340760576"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 07:22:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="927846116"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="927846116"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga006.fm.intel.com with ESMTP; 22 Mar 2023 07:22:20 -0700
Date:   Wed, 22 Mar 2023 22:10:55 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com,
        joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v6 05/24] kvm/vfio: Accept vfio device file from userspace
Message-ID: <ZBsMb3L4LmmK5tHW@yilunxu-OptiPlex-7050>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-6-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308132903.465159-6-yi.l.liu@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-08 at 05:28:44 -0800, Yi Liu wrote:
> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 52 +++++++++++++++++--------
>  include/uapi/linux/kvm.h                | 16 ++++++--
>  virt/kvm/vfio.c                         | 16 ++++----
>  3 files changed, 55 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 79b6811bb4f3..5b05b48abaab 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -9,24 +9,37 @@ Device types supported:
>    - KVM_DEV_TYPE_VFIO
>  
>  Only one VFIO instance may be created per VM.  The created device
> -tracks VFIO groups in use by the VM and features of those groups
> -important to the correctness and acceleration of the VM.  As groups
> -are enabled and disabled for use by the VM, KVM should be updated
> -about their presence.  When registered with KVM, a reference to the
> -VFIO-group is held by KVM.
> +tracks VFIO files (group or device) in use by the VM and features
> +of those groups/devices important to the correctness and acceleration
> +of the VM.  As groups/devices are enabled and disabled for use by the
> +VM, KVM should be updated about their presence.  When registered with
> +KVM, a reference to the VFIO file is held by KVM.
>  
>  Groups:
> -  KVM_DEV_VFIO_GROUP
> -
> -KVM_DEV_VFIO_GROUP attributes:
> -  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE table
> +  KVM_DEV_VFIO_FILE
> +	alias: KVM_DEV_VFIO_GROUP
> +
> +KVM_DEV_VFIO_FILE attributes:
> +  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM device
> +	tracking
> +
> +	alias: KVM_DEV_VFIO_GROUP_ADD
> +
> +	kvm_device_attr.addr points to an int32_t file descriptor for the
> +	VFIO file.

A blank line here to be consistent with other attibutes.

> +  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-KVM
> +	device tracking
> +
> +	alias: KVM_DEV_VFIO_GROUP_DEL
> +
> +	kvm_device_attr.addr points to an int32_t file descriptor for the
> +	VFIO file.
> +
> +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
>  	allocated by sPAPR KVM.
> +
> +	alias: KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE
> +
>  	kvm_device_attr.addr points to a struct::
>  
>  		struct kvm_vfio_spapr_tce {
> @@ -40,9 +53,14 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
>  
> +	only accepts vfio group file as SPAPR has no iommufd support
> +
>  ::
>  
> -The GROUP_ADD operation above should be invoked prior to accessing the
> +The FILE/GROUP_ADD operation above should be invoked prior to accessing the
>  device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
>  drivers which require a kvm pointer to be set in their .open_device()
> -callback.
> +callback.  It is the same for device file descriptor via character device
> +open which gets device access via VFIO_DEVICE_BIND_IOMMUFD.  For such file
> +descriptors, FILE_ADD should be invoked before VFIO_DEVICE_BIND_IOMMUFD
> +to support the drivers mentioned in piror sentence as well.

s/piror/prior

Thanks,
Yilun
