Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1A5362D9
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 14:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352555AbiE0Mnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 08:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352898AbiE0MnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 08:43:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EACC17E23;
        Fri, 27 May 2022 05:40:41 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24RCHxZu017194;
        Fri, 27 May 2022 12:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=x7+rNrqppJOmcQuwjq3loMO1MRTA5ucu5Lqod708gUo=;
 b=lsvVzIcPdgJQPfsL+/VxgfBWqTuh747Pd54pn/r+oDTEmkhzeRVrviSGAquNBg80ZPDa
 HaLx8h0gvLtC4Sap/6QWkjXpjdkUYpGPks5nbDK+vb/5MiXzWkWVXgfa2ewuWF78wOZK
 0G+OMF08lMPHm0Cj8PTfn+dwCiJ1f6y4k5ZyFdwfJVmJr7OSYceTVdOuePToTL5O3PRu
 lf00eYT5Phr71aByrRVy87oJ9OnIeXWDX511UQVDetsxw9Tp7HAIYHjSFKFXwbEzTlDR
 i5G/woqCtSrn50QwfCx9KIQn/gKskCBsG5/esZr7vN+0TiCmZKpUyYXB0nUCYOXD+X46 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxhcgd4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:40:38 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24RCKUZQ021905;
        Fri, 27 May 2022 12:40:38 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxhcgd45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:40:38 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RCbGIX017016;
        Fri, 27 May 2022 12:40:37 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3g93vbvbb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:40:37 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RCeasD31392198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 12:40:36 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6481B78069;
        Fri, 27 May 2022 12:40:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A19F678060;
        Fri, 27 May 2022 12:40:35 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 May 2022 12:40:35 +0000 (GMT)
Message-ID: <2c2d7563-c614-e4f8-7826-73deba6d489b@linux.ibm.com>
Date:   Fri, 27 May 2022 08:40:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 08/20] s390/vfio-ap: introduce new mutex to control
 access to the KVM pointer
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-9-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-9-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RsNefrVn2vSPdcq6izBpkQPhIg6e1QeG
X-Proofpoint-ORIG-GUID: w-XTH8Nx3R0gcqG_z-anZ8MMPiKqoQLo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2205270059
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> The vfio_ap device driver registers for notification when the pointer to
> the KVM object for a guest is set. Recall that the KVM lock (kvm->lock)
> mutex must be taken outside of the matrix_dev->lock mutex to prevent the
> reporting by lockdep of a circular locking dependency (a.k.a., a lockdep
> splat):
> 
> * see commit 0cc00c8d4050 ("Fix circular lockdep when setting/clearing
>    crypto masks")
> 
> * see commit 86956e70761b ("replace open coded locks for
>    VFIO_GROUP_NOTIFY_SET_KVM notification")
> 
> With the introduction of support for hot plugging/unplugging AP devices
> passed through to a KVM guest, a new guests_lock mutex is introduced to
> ensure the proper locking order is maintained:
> 
> struct ap_matrix_dev {
>          ...
>          struct mutex guests_lock;
>         ...
> }
> 
> The matrix_dev->guests_lock controls access to the matrix_mdev instances
> that hold the state for AP devices that have been passed through to a
> KVM guest. This lock must be held to control access to the KVM pointer
> (matrix_mdev->kvm) while the vfio_ap device driver is using it to
> plug/unplug AP devices passed through to the KVM guest.
> 
> Keep in mind, the proper locking order must be maintained whenever
> dynamically updating a KVM guest's APCB to plug/unplug adapters, domains
> and control domains:
> 
>      1. matrix_dev->guests_lock: required to use the KVM pointer - stored in
>         a struct ap_matrix_mdev instance - to update a KVM guest's APCB
> 
>      2. matrix_mdev->kvm->lock: required to update a guest's APCB
> 
>      3. matrix_dev->mdevs_lock: required to access data stored in a
>         struct ap_matrix_mdev instance.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_drv.c     | 1 +
>   drivers/s390/crypto/vfio_ap_private.h | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 0a5acd151a9b..c258e5f7fdfc 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -161,6 +161,7 @@ static int vfio_ap_matrix_dev_create(void)
>   
>   	mutex_init(&matrix_dev->mdevs_lock);
>   	INIT_LIST_HEAD(&matrix_dev->mdev_list);
> +	mutex_init(&matrix_dev->guests_lock);
>   
>   	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
>   	matrix_dev->device.parent = root_device;
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 5262e02192a4..ec926f2f2930 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -39,6 +39,11 @@
>    *		single ap_matrix_mdev device. It's quite coarse but we don't
>    *		expect much contention.
>    * @vfio_ap_drv: the vfio_ap device driver
> + * @guests_lock: mutex for controlling access to a guest that is using AP
> + *		 devices passed through by the vfio_ap device driver. This lock
> + *		 will be taken when the AP devices are plugged into or unplugged
> + *		 from a guest, and when an ap_matrix_mdev device is added to or
> + *		 removed from @mdev_list or the list is iterated.
>    */
>   struct ap_matrix_dev {
>   	struct device device;
> @@ -47,6 +52,7 @@ struct ap_matrix_dev {
>   	struct list_head mdev_list;
>   	struct mutex mdevs_lock;
>   	struct ap_driver  *vfio_ap_drv;
> +	struct mutex guests_lock;
>   };
>   
>   extern struct ap_matrix_dev *matrix_dev;

In isolation... Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
