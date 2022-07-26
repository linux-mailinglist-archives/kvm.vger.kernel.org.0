Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790AD581728
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbiGZQTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 12:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGZQTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 12:19:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E23B1D2;
        Tue, 26 Jul 2022 09:19:19 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QGDqRW024375;
        Tue, 26 Jul 2022 16:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gB3IDpy0n3xs1Gh03yxNIutUqP27KcSpj09v60szIvc=;
 b=hxRHHG5uFyE33K4Dxd8x7O/mmNn/TIz0QZKj2RCj2rqSaWmI3NElsAEBOItPk4FvsfaW
 75tEHqJZJETI8htbDYhu9e4FcUfD0fk3W8pEjr78HfMXCluqLdSy8WhGWZBBltgPLD4Q
 3MB9bjTKBLWTnJRjglEBVpPGK915T5j5pE9G/gNb62Q64FA0u5iZfpaiRpL8RaS15yxd
 yc8CznbDGYstjJZcQd6jysEENim2+J1k68JUimLu7gpBd90+9+kLGa+ik5yMdJ3H5s3M
 7zZSJlKdXPRq70stsZslVVOlhgYBXp5rJWrUrgWLINSI8bMy0mrafnaRVRRuBtQ/Bvoy Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjkks85p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:19:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QGDxbZ024551;
        Tue, 26 Jul 2022 16:19:16 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjkks85ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:19:16 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26QG5lnb023404;
        Tue, 26 Jul 2022 16:19:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3hhfphn64x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:19:15 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QGJEXA36831560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 16:19:14 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E22078063;
        Tue, 26 Jul 2022 16:19:14 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1F5C7805F;
        Tue, 26 Jul 2022 16:19:13 +0000 (GMT)
Received: from [9.211.41.39] (unknown [9.211.41.39])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 16:19:13 +0000 (GMT)
Message-ID: <33bb1e2a-6a31-52d3-4915-937c74fa5c72@linux.ibm.com>
Date:   Tue, 26 Jul 2022 12:19:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] vfio/ccw: Remove FSM Close from remove handlers
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220726150123.2567761-1-farman@linux.ibm.com>
 <20220726150123.2567761-3-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220726150123.2567761-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RAscjF05YRk7rI37A6ZneHFkh0_bQup5
X-Proofpoint-GUID: B8wbKabP4QlxFh2ARGAMandqtG9AvKFt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207260062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 11:01 AM, Eric Farman wrote:
> Now that neither vfio_ccw_sch_probe() nor vfio_ccw_mdev_probe()
> affect the FSM state, it doesn't make sense for their _remove()
> counterparts try to revert things in this way. Since the FSM open
> and close are handled alongside MDEV open/close, these are
> unnecessary.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 1 -
>   drivers/s390/cio/vfio_ccw_ops.c | 2 --
>   2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 4804101ccb0f..86d9e428357b 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -241,7 +241,6 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>   
> -	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
>   	mdev_unregister_device(&sch->dev);
>   
>   	dev_set_drvdata(&sch->dev, NULL);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 3f67fa103c7f..4a806a2273b5 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -130,8 +130,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   
>   	vfio_unregister_group_dev(&private->vdev);
>   
> -	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
> -
>   	vfio_uninit_group_dev(&private->vdev);
>   	atomic_inc(&private->avail);
>   }

