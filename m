Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8E05846C0
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiG1UED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiG1UEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:04:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BEB201AA;
        Thu, 28 Jul 2022 13:04:01 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SJwgNX006896;
        Thu, 28 Jul 2022 20:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yyklyrdqOPSjZe81xSQb/DEOuuyi8oCpC0xlgk/+Xhs=;
 b=HyOtktsARwI5jtMTc1JCn3Af2egcrukUgcFmo45apAjbtfpr9qlo8YMc+uk0ElPGOwqX
 lFfLz5VoBMDBZS+Jq2ztZ0b9+gJA3Cv/K7hkBcStnwYGmXo51uBDHKNjtzW3TAwYMlrK
 0U8mB68RtAhBJRsIOyzj4HCdfmAxBzKXKxD7z1hTE+2V9RkIgRnAQ5ekKIpfFHwKJjc4
 c/NFBbHtwKD6qnYE0QPjDre31iGXUtVhenxQt2MtkyWB7tYan8BQ4TABnZaBkveHj/Ah
 VyKxe7ZBRsq2soMDzhG+jWvMMu/M1iruRqmowN09eNL4xk2OzkbPG6+oD5sOYshUmFi1 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm13b05s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:03:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SJxmBP013841;
        Thu, 28 Jul 2022 20:03:58 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm13b05qj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:03:58 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SJa82j002524;
        Thu, 28 Jul 2022 19:38:08 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3hg97usedm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 19:38:08 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SJc8S119203066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 19:38:08 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07F8E28059;
        Thu, 28 Jul 2022 19:38:08 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87C3E2805A;
        Thu, 28 Jul 2022 19:38:05 +0000 (GMT)
Received: from [9.211.95.8] (unknown [9.211.95.8])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 19:38:05 +0000 (GMT)
Message-ID: <327f4a7c-bc44-6fb9-9d03-6b164ff76a4f@linux.ibm.com>
Date:   Thu, 28 Jul 2022 15:38:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 3/3] vfio/ccw: Check return code from subchannel
 quiesce
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220728160550.2119289-1-farman@linux.ibm.com>
 <20220728160550.2119289-4-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220728160550.2119289-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UF9VcT7-6Caq1OKWpIzhel_ntkgXQ41t
X-Proofpoint-ORIG-GUID: 0cCi7k5JVln-e2SHxOtDtxxja_UGJrrd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 12:05 PM, Eric Farman wrote:
> If a subchannel is busy when a close is performed, the subchannel
> needs to be quiesced and left nice and tidy, so nothing unexpected
> (like a solicited interrupt) shows up while in the closed state.
> Unfortunately, the return code from this call isn't checked,
> so any busy subchannel is treated as a failing one.
> 
> Fix that, so that the close on a busy subchannel happens normally.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 4b8b623df24f..a59c758869f8 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -407,7 +407,7 @@ static void fsm_close(struct vfio_ccw_private *private,
>   
>   	ret = cio_disable_subchannel(sch);
>   	if (ret == -EBUSY)
> -		vfio_ccw_sch_quiesce(sch);
> +		ret = vfio_ccw_sch_quiesce(sch);
>   	if (ret)
>   		goto err_unlock;
>   

