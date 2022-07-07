Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C14569CF8
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 10:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiGGIMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 04:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiGGILh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 04:11:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CB645062;
        Thu,  7 Jul 2022 01:11:21 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2676C582031927;
        Thu, 7 Jul 2022 08:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j5Da+p+UHNT+OKN9SSTeQfNbmKW2FcC8k/0Febxwrn0=;
 b=ItPOA/LxNfzUl8KLYCxHDR232unRGwaJQNHY2ryOj6O7j/E1JVCzwHvcmAAUmwBMfBJ9
 gVTUPYHfIs3fr1WaXRKlYdmOEcN62Pye+Jlt2gOEq0E0u28RC7tZ75FMzmbVOofimIsF
 ApVbJJbSBZHo5JnieIorg7qB/tWlwqhpyr9CKXOl3X4T4JrlyPwhzTHYtufdrlsk9/zq
 nqYN4EvEC1vQbRgvS5JlruaLhYQK3zH3yv9qqbASHaFysS21C15QTQG3TcE9hqtr31kH
 6JWqz79uU9EBUSUW8MfQxbkUatCNrpfoWv8MCkVTb6dxn2T6v2PjfzPe9CjOmk6OA9lD lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5t0ptwx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:11:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2677GmXO015345;
        Thu, 7 Jul 2022 08:11:20 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5t0ptww4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:11:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26784u3n002891;
        Thu, 7 Jul 2022 08:11:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3h4uk99n27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 08:11:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2678BEmf20840736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 08:11:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB13A405B;
        Thu,  7 Jul 2022 08:11:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EE2DA4054;
        Thu,  7 Jul 2022 08:11:14 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 08:11:13 +0000 (GMT)
Message-ID: <c8dcbb5c-73c0-be3d-8727-a376220007fa@linux.ibm.com>
Date:   Thu, 7 Jul 2022 10:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: uv-host: Add access checks
 for donated memory
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-2-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220706064024.16573-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Se8S-p8T-MhCPgLo6fpC2549TpFcWT16
X-Proofpoint-ORIG-GUID: ccf4DJK-6lPT1fA6Jss3rx0CLOYZiwQ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Janosch,

On 7/6/22 08:40, Janosch Frank wrote:
> Let's check if the UV really protected all the memory we donated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/uv-host.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index a1a6d120..983cb4a1 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -43,6 +43,24 @@ static void cpu_loop(void)
>   	for (;;) {}
>   }
>   
> +/*
> + * Checks if a memory area is protected as secure memory.
> + * Will return true if all pages are protected, false otherwise.
> + */
> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
> +{
> +	while (len) {
> +		expect_pgm_int();
> +		*access_ptr += 42;
> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);
> +		len -= PAGE_SIZE;
If someone uses this function with 'len' not being a multiple of
PAGE_SIZE this test does not for what is was intended by testing more 
memory than expected.

I suggest adding an explicit assert at the beginning of the function
that ensures 'len' is a multiple of PAGE_SIZE.

> +	}
> +
> +	return true;
> +}
> +

[snip]

Steffen
