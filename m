Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AEB53963E
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347023AbiEaS0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346376AbiEaS0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:26:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD2F7A80B;
        Tue, 31 May 2022 11:26:11 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VHOOei024927;
        Tue, 31 May 2022 18:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JU4EHGVLubemL79Q3kfvk0r0lYuMGhy/CRrixhY0xpw=;
 b=sZ1jy57hlMBAd9ulbLrdjOtdY1XKk07DGOT4gpzqVj8aiOVk8IVTB2EPX0faRjILQSft
 g9fXw6azdxmAfFE50AjA1m63YkQBf/nELpDGTIn8bMDYADuwwa57wFIMBBYQMvLfawWK
 NzMOqtUD81LBkOzRJO8wHTINjyzw6YpKFJQtt9zZVVUCqd3y7VJGP6TptHK/yPaYMbjJ
 zQJ5G1VDoX1JVG/PKTQEoydW8ynZCOs4qb2Mm/t/cTZtfGiTuTyLh9BKssA4+MxTnWu3
 oUhevLSyTd7mRLtA94bswdUqzhakXORHeQfWDr1rSjwTVxFb0CQEhQSJrbK4+85TlDpw Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdnm6bcpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 18:26:09 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24VINB1q022962;
        Tue, 31 May 2022 18:26:09 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdnm6bcpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 18:26:08 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24VILt4i003837;
        Tue, 31 May 2022 18:26:07 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3gcxt5aeqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 18:26:07 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24VIQ5V435127650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 18:26:06 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E49757805C;
        Tue, 31 May 2022 18:26:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D81FB78066;
        Tue, 31 May 2022 18:26:04 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 18:26:04 +0000 (GMT)
Message-ID: <bcdf9615-628a-8696-4a3b-f10a35d7af87@linux.ibm.com>
Date:   Tue, 31 May 2022 14:26:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v19 20/20] MAINTAINERS: pick up all vfio_ap docs for VFIO
 AP maintainers
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-21-akrowiak@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220404221039.1272245-21-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WCN-HclrMjJ6CHbLb9w7JBfLB4degXNs
X-Proofpoint-GUID: vOWFa3Ir4UTxyHDYegB3sMlv2Nqf2LAp
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_07,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=980 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310082
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 6:10 PM, Tony Krowiak wrote:
> A new document, Documentation/s390/vfio-ap-locking.rst was added. Make sure
> the new document is picked up for the VFIO AP maintainers by using a
> wildcard: Documentation/s390/vfio-ap*.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   MAINTAINERS | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fd768d43e048..c8d8637c184c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17239,8 +17239,10 @@ M:	Jason Herne <jjherne@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/
> -F:	Documentation/s390/vfio-ap.rst
> -F:	drivers/s390/crypto/vfio_ap*
> +F:	Documentation/s390/vfio-ap*
> +F:	drivers/s390/crypto/vfio_ap_drv.c
> +F:	drivers/s390/crypto/vfio_ap_ops.c
> +F:	drivers/s390/crypto/vfio_ap_private.h

I think this change was a rebase error, the Documentation change makes 
sense but you should leave drivers/s390/crypto/vfio_ap* alone, so the 
final result looks like:

F:	Documentation/s390/vfio-ap*
F:	drivers/s390/crypto/vfio_ap*

