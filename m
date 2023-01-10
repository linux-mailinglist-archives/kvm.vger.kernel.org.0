Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB46643AE
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbjAJOwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 09:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbjAJOwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 09:52:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730595FCE;
        Tue, 10 Jan 2023 06:51:59 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AECXZd013300;
        Tue, 10 Jan 2023 14:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TwsoLVAKzdOIHlkFgZxjTzs1Pxf1GfPE5CXt2HDPja8=;
 b=HTim++QTzLbxwlfc4jYJcvup98vKXF8+p7rn5ByTr6qyclwazsNqH9CmvEpjhJK+wvoE
 A6rwEVqqJL2hgbRXT15IaJZpnhsw2UL23Z66dqGcjP8DmMzUE2/wDWGeshqu/cldb8ng
 CV1WcvCAV0we628eNEoKFSF4xGZoPrSqzqq3iVVoNAdjcMgpjRZQmB5qqSODjLZS72e6
 LR+F6eCyWAHbRHMn7akuLjBZ5W6CF6vgPrD7TMvJJ1XbvzJRSZtXdsPwc8aemt8VuQ9f
 zxY3owzf/CmOGnOZVkkdLQARftzjlKXEY2oQJr/RP1MPIUOlwIgm39KQvP0Zp+jDC9vW gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19jt93sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:51:48 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AEEsVP020363;
        Tue, 10 Jan 2023 14:51:47 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19jt93s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:51:47 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30AC7eUb002835;
        Tue, 10 Jan 2023 14:51:46 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7a9pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:51:46 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AEpj4s24773338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 14:51:45 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FEE15805E;
        Tue, 10 Jan 2023 14:51:45 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0427658050;
        Tue, 10 Jan 2023 14:51:44 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 14:51:43 +0000 (GMT)
Message-ID: <363dac80-e16d-e766-2c73-f67e79dce224@linux.ibm.com>
Date:   Tue, 10 Jan 2023 09:51:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/4] vfio-mdev: turn VFIO_MDEV into a selectable symbol
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-3-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230110091009.474427-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 33DLQQ7z0c4wVM0X9uVuLl-w60ZBFgAc
X-Proofpoint-ORIG-GUID: xaU9iNafgtTBVdD4XsYtGCrd3bypkYAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 1/10/23 4:10 AM, Christoph Hellwig wrote:
> VFIO_MDEV is just a library with helpers for the drivers.  Stop making
> it a user choice and just select it by the drivers that use the helpers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/s390/vfio-ap.rst    | 1 -
>   arch/s390/Kconfig                 | 6 ++++--
>   arch/s390/configs/debug_defconfig | 1 -
>   arch/s390/configs/defconfig       | 1 -
>   drivers/gpu/drm/i915/Kconfig      | 2 +-
>   drivers/vfio/mdev/Kconfig         | 8 +-------
>   samples/Kconfig                   | 6 +++---
>   7 files changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
> index 00f4a04f6d4c6a..d46e98c7c1ec6c 100644
> --- a/Documentation/s390/vfio-ap.rst
> +++ b/Documentation/s390/vfio-ap.rst
> @@ -553,7 +553,6 @@ These are the steps:
>      * ZCRYPT
>      * S390_AP_IOMMU
>      * VFIO
> -   * VFIO_MDEV
>      * KVM
>   
>      If using make menuconfig select the following to build the vfio_ap module::
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 318fce77601d35..60fddcdad495e6 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -705,7 +705,8 @@ config EADM_SCH
>   config VFIO_CCW
>   	def_tristate n
>   	prompt "Support for VFIO-CCW subchannels"
> -	depends on S390_CCW_IOMMU && VFIO_MDEV
> +	depends on S390_CCW_IOMMU
> +	select VFIO_MDEV
>   	help
>   	  This driver allows usage of I/O subchannels via VFIO-CCW.
>   
> @@ -715,7 +716,8 @@ config VFIO_CCW
>   config VFIO_AP
>   	def_tristate n
>   	prompt "VFIO support for AP devices"
> -	depends on S390_AP_IOMMU && VFIO_MDEV && KVM
> +	depends on S390_AP_IOMMU && KVM
> +	select VFIO_MDEV
>   	depends on ZCRYPT
>   	help
>   	  This driver grants access to Adjunct Processor (AP) devices
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 2a827002934bc6..e78fc3ba7d442a 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -596,7 +596,6 @@ CONFIG_SYNC_FILE=y
>   CONFIG_VFIO=m
>   CONFIG_VFIO_PCI=m
>   CONFIG_MLX5_VFIO_PCI=m
> -CONFIG_VFIO_MDEV=m
>   CONFIG_VIRTIO_PCI=m
>   CONFIG_VIRTIO_BALLOON=m
>   CONFIG_VIRTIO_INPUT=y
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index fb780e80e4c8f7..f7eb2e527b6e65 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -585,7 +585,6 @@ CONFIG_SYNC_FILE=y
>   CONFIG_VFIO=m
>   CONFIG_VFIO_PCI=m
>   CONFIG_MLX5_VFIO_PCI=m
> -CONFIG_VFIO_MDEV=m
>   CONFIG_VIRTIO_PCI=m
>   CONFIG_VIRTIO_BALLOON=m
>   CONFIG_VIRTIO_INPUT=y
> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
> index 3efce05d7b57ca..d06da455253cdb 100644
> --- a/drivers/gpu/drm/i915/Kconfig
> +++ b/drivers/gpu/drm/i915/Kconfig
> @@ -116,9 +116,9 @@ config DRM_I915_GVT_KVMGT
>   	depends on X86
>   	depends on 64BIT
>   	depends on KVM
> -	depends on VFIO_MDEV
>   	select DRM_I915_GVT
>   	select KVM_EXTERNAL_WRITE_TRACKING
> +	select VFIO_MDEV
>   
>   	help
>   	  Choose this option if you want to enable Intel GVT-g graphics
> diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
> index 646dbed44eb283..e5fb84e0796507 100644
> --- a/drivers/vfio/mdev/Kconfig
> +++ b/drivers/vfio/mdev/Kconfig
> @@ -1,10 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   
>   config VFIO_MDEV
> -	tristate "Mediated device driver framework"
> -	default n
> -	help
> -	  Provides a framework to virtualize devices.
> -	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
> -
> -	  If you don't know what do here, say N.
> +	tristate
> diff --git a/samples/Kconfig b/samples/Kconfig
> index f1b8d4ff123036..56b191d128d88f 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -185,14 +185,14 @@ config SAMPLE_UHID
>   
>   config SAMPLE_VFIO_MDEV_MTTY
>   	tristate "Build VFIO mtty example mediated device sample code"
> -	depends on VFIO_MDEV
> +	select VFIO_MDEV
>   	help
>   	  Build a virtual tty sample driver for use as a VFIO
>   	  mediated device
>   
>   config SAMPLE_VFIO_MDEV_MDPY
>   	tristate "Build VFIO mdpy example mediated device sample code"
> -	depends on VFIO_MDEV
> +	select VFIO_MDEV
>   	help
>   	  Build a virtual display sample driver for use as a VFIO
>   	  mediated device.  It is a simple framebuffer and supports
> @@ -209,7 +209,7 @@ config SAMPLE_VFIO_MDEV_MDPY_FB
>   
>   config SAMPLE_VFIO_MDEV_MBOCHS
>   	tristate "Build VFIO mdpy example mediated device sample code"
> -	depends on VFIO_MDEV
> +	select VFIO_MDEV
>   	select DMA_SHARED_BUFFER
>   	help
>   	  Build a virtual display sample driver for use as a VFIO
