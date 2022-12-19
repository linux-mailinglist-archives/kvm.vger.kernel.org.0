Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C0B650D0B
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiLSOLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 09:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiLSOLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 09:11:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAFF263C;
        Mon, 19 Dec 2022 06:11:01 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJE9qar024346;
        Mon, 19 Dec 2022 14:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WsG0cTuIrpLq5bb90W+sn9UoRt5B39gZfb6nBjj0AFo=;
 b=KTFpsCUioeiUiLJAt10utP/EMqM66zfv6AynTTK7dxuT3HMGncWNf88PuQDvdkN1gcEg
 UWqUxmr/7SQJ4VNVh2SMuzOENUByaiW+YpmAVhFKLJGRm8E/Sa6BLvqK+qHyprtZup8w
 X6HQr0fzx2zlLBORmbgJnHyoC9hStVHanzBL4e4kpoXndJoDh6v28OSAghhN9G0eXYu0
 6XFtjfmZtpzhpu8Hdyu7DhEJPdVIVglNBP7dx0/QvWxFFinaUCKE0YSC9OCUrP5ChtRP
 qf5pijnA7iIMjwnXCHiazJ3U/9xSSPxxu/sdUXDVvN75aWoktZOeESJIiKyHQuV/hc8n ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjs9q8b44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 14:10:58 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BJEA0oF024943;
        Mon, 19 Dec 2022 14:10:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjs9q89ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 14:10:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ3Tm5r019071;
        Mon, 19 Dec 2022 14:10:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw2nb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 14:10:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJEAF7I47579506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 14:10:15 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8977C20049;
        Mon, 19 Dec 2022 14:10:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023732004B;
        Mon, 19 Dec 2022 14:10:11 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.163.79.84])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Mon, 19 Dec 2022 14:10:10 +0000 (GMT)
Date:   Mon, 19 Dec 2022 15:10:07 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Message-ID: <20221219151007.639dff5f.pasic@linux.ibm.com>
In-Reply-To: <20221213154437.15480-8-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
        <20221213154437.15480-8-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dx6qQCLGC91mBXjLDJoUPMme5Nm6oExT
X-Proofpoint-ORIG-GUID: zhJ5gnt1YkpTDPQ4bi-9Odoaft4TXefi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 10:44:37 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an error
> not handled by a case statement.

Why?

I'm afraid this is a step in the wrong direction...

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e80c5a6b91be..2dd8db9ddb39 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1676,7 +1676,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
>  		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>  		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>  		     status.response_code);
> -		return -EIO;
> +		break;
>  	}
>  
>  	vfio_ap_free_aqic_resources(q);

