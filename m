Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CFA6643C2
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 15:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbjAJOzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 09:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238819AbjAJOzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 09:55:12 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB521DDD2;
        Tue, 10 Jan 2023 06:55:08 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AEH2WQ032630;
        Tue, 10 Jan 2023 14:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8rRpFagcUrDG39oi0NySaX6L60RGxoRtvw3fFkRTIHs=;
 b=SKvVC3Q2RczX2zZJHsY1+x6zrtAArGMYxzHlUHGE+WwEGwoAgwCIS9/jYuALLkZu3uZo
 haZ7BUdFlWrVBhbl+Ti7NzOzyJvL6NnzHa3zATJer1PsZqfuaqbr6GgbYfXpyN89K0Dv
 SavB0CIy3XXdwph06W/5LY7YQgaczqkSMA39Md6XqKJJezdjAtAAUqTbBSfKxxn5Ri/b
 GDO7EiJzJSJEmjSeSmxH8veVbkCqoy2pDUx2hLunXKEHKsYXQkx19WQbpttEeDp5AIW2
 7NkGUCYh9O/dqQxouVjr2CJL9ljpyfryS9ok9cW0Bzn+36zdad3a9SQub0oEGXPOwlE/ rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19n2s43w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:54:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AEH4fL032719;
        Tue, 10 Jan 2023 14:54:56 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19n2s43q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:54:55 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ABv0g5010169;
        Tue, 10 Jan 2023 14:54:55 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7a9vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:54:55 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AEsrMi56099234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 14:54:53 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B500658045;
        Tue, 10 Jan 2023 14:54:53 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86C4B58052;
        Tue, 10 Jan 2023 14:54:52 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 14:54:52 +0000 (GMT)
Message-ID: <b317380e-26bf-b478-4aea-0355e0de4017@linux.ibm.com>
Date:   Tue, 10 Jan 2023 09:54:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/4] vfio-mdev: allow building the samples into the kernel
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
 <20230110091009.474427-2-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230110091009.474427-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eM4ZKbFUWuZCkdT4oZussBlXFXvLydrI
X-Proofpoint-GUID: 3LZ2Q-1FvI8p116IQXqMi2vlHuWNvdf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_04,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/10/23 4:10 AM, Christoph Hellwig wrote:
> There is nothing in the vfio-mdev sample drivers that requires building
> them as modules, so remove that restriction.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   samples/Kconfig | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 0d81c00289ee36..f1b8d4ff123036 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -184,23 +184,23 @@ config SAMPLE_UHID
>   	  Build UHID sample program.
>   
>   config SAMPLE_VFIO_MDEV_MTTY
> -	tristate "Build VFIO mtty example mediated device sample code -- loadable modules only"
> -	depends on VFIO_MDEV && m
> +	tristate "Build VFIO mtty example mediated device sample code"
> +	depends on VFIO_MDEV


Admittedly, I'm not very fluent with Kconfig, but in patch 2 you stated, 
"VFIO_MDEV is just a library with helpers for the drivers. Stop making 
it a user choice and just select it by the drivers that use the 
helpers". Why are you not selecting it here?


>   	help
>   	  Build a virtual tty sample driver for use as a VFIO
>   	  mediated device
>   
>   config SAMPLE_VFIO_MDEV_MDPY
> -	tristate "Build VFIO mdpy example mediated device sample code -- loadable modules only"
> -	depends on VFIO_MDEV && m
> +	tristate "Build VFIO mdpy example mediated device sample code"
> +	depends on VFIO_MDEV
>   	help
>   	  Build a virtual display sample driver for use as a VFIO
>   	  mediated device.  It is a simple framebuffer and supports
>   	  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
>   
>   config SAMPLE_VFIO_MDEV_MDPY_FB
> -	tristate "Build VFIO mdpy example guest fbdev driver -- loadable module only"
> -	depends on FB && m
> +	tristate "Build VFIO mdpy example guest fbdev driver"
> +	depends on FB
>   	select FB_CFB_FILLRECT
>   	select FB_CFB_COPYAREA
>   	select FB_CFB_IMAGEBLIT
> @@ -208,8 +208,8 @@ config SAMPLE_VFIO_MDEV_MDPY_FB
>   	  Guest fbdev driver for the virtual display sample driver.
>   
>   config SAMPLE_VFIO_MDEV_MBOCHS
> -	tristate "Build VFIO mdpy example mediated device sample code -- loadable modules only"
> -	depends on VFIO_MDEV && m
> +	tristate "Build VFIO mdpy example mediated device sample code"
> +	depends on VFIO_MDEV
>   	select DMA_SHARED_BUFFER
>   	help
>   	  Build a virtual display sample driver for use as a VFIO
