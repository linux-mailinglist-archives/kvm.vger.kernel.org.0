Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A345BEDFB
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiITTpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiITTpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:45:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1D352DD9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:45:35 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KJU4Qj008693;
        Tue, 20 Sep 2022 19:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lW7HR+1tiBUuM5nltNmJOgFaTO2usDmyXd5n59PGJSw=;
 b=EQN+i8F7JseyEJmn1ZcJsmMgi2EniYF/Ml7FP63r7vuWNLtVMjbsKDh7PGqNhg7yBe2R
 jcXFe+dtaTh98WcJFxLfvJRkyOu+Hr+dt7mEvoEXncxFbrIBgeJRgABtieXCIab8+26N
 tn/f0D36hAlCT91/Nk34/Gvm7swyAAv72Ge5YEjEjsh0quiz0aNXOtI0ybFbSj0onIJV
 d474iAFdzglfZkXcIYiu7J39tCwTLj81tBHJPCjlFdYnApLxpX9lqLdj9dNFvu9GOQGi
 tUHWXgbNC9TNWXj4vELz9WYC8wnOTbbmv72oftviD1NpfSrym541tHVqAV5XP274nF0/ EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkqxgc96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:45:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KJUdxR009750;
        Tue, 20 Sep 2022 19:45:18 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkqxgc8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:45:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KJbE0P022357;
        Tue, 20 Sep 2022 19:45:17 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3jn5v9u4wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:45:17 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KJjFpg52756800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 19:45:15 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEE9F58052;
        Tue, 20 Sep 2022 19:45:15 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C969258056;
        Tue, 20 Sep 2022 19:45:14 +0000 (GMT)
Received: from [9.65.230.56] (unknown [9.65.230.56])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 19:45:14 +0000 (GMT)
Message-ID: <e2da7cc7-1de7-8152-9d7c-970271a6f5b8@linux.ibm.com>
Date:   Tue, 20 Sep 2022 15:45:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/4] vfio: Simplify vfio_create_group()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <1-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <1-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y4Uh_PW2wQXKo-hfwmWnKfIKjAC04faS
X-Proofpoint-ORIG-GUID: -of_5mU2W0ypbSe8qCJvSIrKP7C6E5ZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200117
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/22 2:44 PM, Jason Gunthorpe wrote:
> The vfio.group_lock is now only used to serialize vfio_group creation
> and destruction, we don't need a micro-optimization of searching,
> unlocking, then allocating and searching again. Just hold the lock
> the whole time.
> 
> Rename the function to 'vfio_get_group()' to reflect that it doesn't
> always create something.
> move
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/vfio/vfio_main.c | 48 ++++++++++++++++------------------------
>  1 file changed, 19 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 77264d836d5200..4ab13808b536e1 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -319,17 +319,6 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
>  	return NULL;
>  }
>  
> -static struct vfio_group *
> -vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> -{
> -	struct vfio_group *group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	group = __vfio_group_get_from_iommu(iommu_group);
> -	mutex_unlock(&vfio.group_lock);
> -	return group;
> -}
> -
>  static void vfio_group_release(struct device *dev)
>  {
>  	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
> @@ -376,16 +365,26 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>  	return group;
>  }
>  
> -static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> -		enum vfio_group_type type)
> +/*
> + * Return a struct vfio_group * for the given iommu_group. If no vfio_group
> + * already exists then create a new one.
> + */
> +static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
> +					 enum vfio_group_type type)
>  {
>  	struct vfio_group *group;
>  	struct vfio_group *ret;
>  	int err;
>  
> -	group = vfio_group_alloc(iommu_group, type);
> -	if (IS_ERR(group))
> -		return group;
> +	mutex_lock(&vfio.group_lock);
> +
> +	ret = __vfio_group_get_from_iommu(iommu_group);
> +	if (ret)
> +		goto err_unlock;
> +
> +	group = ret = vfio_group_alloc(iommu_group, type);
> +	if (IS_ERR(ret))
> +		goto err_unlock;
>  
>  	err = dev_set_name(&group->dev, "%s%d",
>  			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
> @@ -395,13 +394,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  		goto err_put;
>  	}
>  
> -	mutex_lock(&vfio.group_lock);
> -
> -	/* Did we race creating this group? */
> -	ret = __vfio_group_get_from_iommu(iommu_group);
> -	if (ret)
> -		goto err_unlock;
> -
>  	err = cdev_device_add(&group->cdev, &group->dev);
>  	if (err) {
>  		ret = ERR_PTR(err);
> @@ -413,10 +405,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  	mutex_unlock(&vfio.group_lock);
>  	return group;
>  
> -err_unlock:
> -	mutex_unlock(&vfio.group_lock);
>  err_put:
>  	put_device(&group->dev);
> +err_unlock:
> +	mutex_unlock(&vfio.group_lock);
>  	return ret;
>  }
>  
> @@ -514,7 +506,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
>  	if (ret)
>  		goto out_put_group;
>  
> -	group = vfio_create_group(iommu_group, type);
> +	group = vfio_get_group(iommu_group, type);
>  	if (IS_ERR(group)) {
>  		ret = PTR_ERR(group);
>  		goto out_remove_device;
> @@ -564,9 +556,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> -	group = vfio_group_get_from_iommu(iommu_group);
> -	if (!group)
> -		group = vfio_create_group(iommu_group, VFIO_IOMMU);
> +	group = vfio_get_group(iommu_group, VFIO_IOMMU);
>  
>  	/* The vfio_group holds a reference to the iommu_group */
>  	iommu_group_put(iommu_group);

