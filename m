Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71343646B
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhJUOi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:38:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOiz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:38:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEC1vd009721;
        Thu, 21 Oct 2021 10:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FBw0vSRO0XUub1pEzFoJmCyGnK71BvE2AT1py786li0=;
 b=csmas6O3QyCfQMgImh6U4A65h9S+rwU8uhKvB7Q1ApOvKaTmKqDIfU8PMm/1lweIxDeH
 SB9ia6teNfvGSH6Uj1Hlx/SzmfLOz1haB6hR0WfNVnlSbtQHuG3XusODqKP7m6P70dEG
 zLXAHVlHXMUbVU6LIgEjeRSuD8fifUvHYQacIayWeGyOKHYjm2tPYyhs3uLhpmydZAcM
 Fb18SKMPPNoTiBC6io2mN1YmowSO5qcrg1ZaRv4nRORzPf77VSpo/dVbkzMygdBIZR5k
 6dAmtfsDT8Dfa0GgtvFlVthznQl1dyKk8jz9qPSvcThAcXajpHEi4Opu8kAX8FMKAWlL NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu8h8aq62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 10:35:27 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LECvkQ014640;
        Thu, 21 Oct 2021 10:35:27 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu8h8aq5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 10:35:27 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LEJewu016580;
        Thu, 21 Oct 2021 14:35:25 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3bqpcdq5js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 14:35:25 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LEZOrO18875014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:35:24 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36E47136053;
        Thu, 21 Oct 2021 14:35:24 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B688D136061;
        Thu, 21 Oct 2021 14:35:21 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.163.26.166])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 14:35:21 +0000 (GMT)
Message-ID: <11390ab81441c8d9cd06802dbcbf7c473a51bd29.camel@linux.ibm.com>
Subject: Re: [PATCH v3 01/10] vfio/ccw: Remove unneeded GFP_DMA
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 21 Oct 2021 10:35:19 -0400
In-Reply-To: <1-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com>
References: <1-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dEwQA06S1dTrkYbcDcVFTeYyJeG3-T5W
X-Proofpoint-ORIG-GUID: uKnpOaemnUNFZPnMnUkjxu1hxCUaNZbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-01 at 14:52 -0300, Jason Gunthorpe wrote:
> Since the ccw_io_region was split out of the private the allocation
> no
> longer needs the GFP_DMA. Remove it.
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Fixes: c98e16b2fa12 ("s390/cio: Convert ccw_io_region to pointer")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> b/drivers/s390/cio/vfio_ccw_drv.c
> index 76099bcb765b45..371558ec92045d 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -161,7 +161,7 @@ static int vfio_ccw_sch_probe(struct subchannel
> *sch)
>  		return -ENODEV;
>  	}
>  
> -	private = kzalloc(sizeof(*private), GFP_KERNEL | GFP_DMA);
> +	private = kzalloc(sizeof(*private), GFP_KERNEL);
>  	if (!private)
>  		return -ENOMEM;
>  

