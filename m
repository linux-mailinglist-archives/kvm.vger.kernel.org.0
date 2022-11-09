Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3DD62366C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiKIWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIWUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:20:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7B612AE0;
        Wed,  9 Nov 2022 14:20:34 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9L9c57028228;
        Wed, 9 Nov 2022 22:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SP2GELv+bIPt9nnhexmy2PzgEFQ9K/ZPGyYruB7rewU=;
 b=tPojm5E28bvxZgZGJLmWBhiE7WLm/0hsoAZqL/zc4iwsHgL3DqQpfW3f6i+Vlm/YM8Id
 T4X1CqZv1hhhX9e91pTdDiPUp3EADV3A0VBZS9s8vsJeEnp0+F6GNxv86N8O0Aa4k+fU
 4tq/oGHPFu8VVY0AFUW5wZ0r/swWEMyQjM4M3CiMG5c9F7W6lSmmeZQ0kR1zF413Ox7x
 0+K/YrXmf3D03vu+3H2HyAnQLtQ1auJM+ZXYT2zPWn/Ggidfpu6G5b9tMMV1RFHE0GSS
 rUrPCqLNrCg2nTxDNeUrqd0siBgHv8qlMQk1/T6K4CG2joA9A+hFm3ma4bvgCgdRxjt2 Lg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krhy1mqy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 22:20:33 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A9MK9HW007236;
        Wed, 9 Nov 2022 22:20:32 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3kngsygkpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 22:20:32 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A9MKWsG67043612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Nov 2022 22:20:32 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E30A58060;
        Wed,  9 Nov 2022 22:20:30 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86DEC5803F;
        Wed,  9 Nov 2022 22:20:29 +0000 (GMT)
Received: from [9.160.191.98] (unknown [9.160.191.98])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  9 Nov 2022 22:20:29 +0000 (GMT)
Message-ID: <c9e7229e-a88d-2185-bb6b-a94e9dac7b7a@linux.ibm.com>
Date:   Wed, 9 Nov 2022 17:20:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 1/2] vfio-ccw: sort out physical vs virtual pointers usage
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221109202157.1050545-1-farman@linux.ibm.com>
 <20221109202157.1050545-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221109202157.1050545-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sRu-cN22UO0xq5tjL_PIp-NrCBkts_mT
X-Proofpoint-GUID: sRu-cN22UO0xq5tjL_PIp-NrCBkts_mT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090166
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/22 3:21 PM, Eric Farman wrote:
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> The ORB is a construct that is sent to the real hardware,
> so should contain a physical address in its interrupt
> parameter field. Let's clarify that.
> 
> Note: this currently doesn't fix a real bug, since virtual
> addresses are identical to physical ones.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> [EF: Updated commit message]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index a59c758869f8..0a5e8b4a6743 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -29,7 +29,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>  
>  	spin_lock_irqsave(sch->lock, flags);
>  
> -	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
> +	orb = cp_get_orb(&private->cp, (u32)virt_to_phys(sch), sch->lpm);

Nit: I think it would make more sense to do the virt_to_phys inside cp_get_orb at the time we place the address in the orb (since that's what gets sent to hardware), rather than requiring all callers of cp_get_orb to pass a physical address.  I realize there is only 1 caller today.

Nit++: Can we make the patch subjects match?  vfio/ccw or vfio-ccw

Either way:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>  	if (!orb) {
>  		ret = -EIO;
>  		goto out;

