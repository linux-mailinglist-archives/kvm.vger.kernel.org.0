Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33376643A3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 15:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbjAJOuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 09:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjAJOuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 09:50:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3A85015C;
        Tue, 10 Jan 2023 06:49:59 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ADipNe024684;
        Tue, 10 Jan 2023 14:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WPPgsTqVXw3MYWcGCbj/p1qXM+CUpnBLnqM1ocA+3LQ=;
 b=S9lNqo0mPrKZDmiBEfC1yDwHf1DD/vimO1Ta1wWoy46bTFUHoieKCze/h6ba3w0i/M1D
 jP2w4AtdRzxStWeG7jyTkTZLX9tMgXL6TpiAMUt65AOLjRceux7PU4eUd3LVby4cHy+x
 wbwYItggB1Y+ARH/yLmg4IkrNhyUKkqH8NHA4jDmFBpPGGkQXkM1+oqBDiQ2VKAs1Cd6
 rKcZLwLpLtiw/+pcXXAnWi5TaIHBKtaZC2/yaxB+L2uoo5ExcKntcZCoVvjsCLT+OBU/
 7R/V1JpmqRY8KOs2Ks7rN9SxH2ygY42wUil4Py6SW7TFloNiY2FPevflPg/IbXAJEbUb 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19649x3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:49:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AEKGN9018273;
        Tue, 10 Jan 2023 14:49:48 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n19649x2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:49:48 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ACI4pc010657;
        Tue, 10 Jan 2023 14:49:48 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7a96n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 14:49:48 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AEnkcm65732896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 14:49:47 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB27658050;
        Tue, 10 Jan 2023 14:49:46 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 813555805E;
        Tue, 10 Jan 2023 14:49:45 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 14:49:45 +0000 (GMT)
Message-ID: <625de375-562d-3a72-830b-4c4835ab93e6@linux.ibm.com>
Date:   Tue, 10 Jan 2023 09:49:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 4/4] vfio-mdev: remove an non-existing driver from
 vfio-mediated-device
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
 <20230110091009.474427-5-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230110091009.474427-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KanNLKOwomRin1ekOSHGZJTf_TGnxGqB
X-Proofpoint-ORIG-GUID: CeWU-G6IoEbhfJ0tOVAv6T45AV40UWsq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301100090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LGTM

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 1/10/23 4:10 AM, Christoph Hellwig wrote:
> The nvidia mdev driver does not actually exist anywhere in the tree.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/driver-api/vfio-mediated-device.rst | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index d4267243b4f525..bbd548b66b4255 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -60,7 +60,7 @@ devices as examples, as these devices are the first devices to use this module::
>        |   mdev.ko     |
>        | +-----------+ |  mdev_register_parent() +--------------+
>        | |           | +<------------------------+              |
> -     | |           | |                         |  nvidia.ko   |<-> physical
> +     | |           | |                         | ccw_device.ko|<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
>        | | Physical  | |
> @@ -69,12 +69,6 @@ devices as examples, as these devices are the first devices to use this module::
>        | |           | |                         |  i915.ko     |<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
> -     | |           | |
> -     | |           | |  mdev_register_parent() +--------------+
> -     | |           | +<------------------------+              |
> -     | |           | |                         | ccw_device.ko|<-> physical
> -     | |           | +------------------------>+              |    device
> -     | |           | |        callbacks        +--------------+
>        | +-----------+ |
>        +---------------+
>   
