Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5CF61F1BC
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiKGLWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 06:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiKGLWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 06:22:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BBA15816;
        Mon,  7 Nov 2022 03:22:05 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7A3QgB025207;
        Mon, 7 Nov 2022 11:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=942OhUkpK4u5+VWDLhDefC0103nb8+LOWq28jshjl/E=;
 b=Lm0pwSagYtMZsRx41//Mw0KjVjMN9MEFwnWc7tNTugjrun2Z0Lh1M0GoACkg/B2toUc+
 0OLV5NeVShtbEzM8W1rkBJe+oUbuUGpB2TuQbuyjfROP6pplEsJus9M/1BOBuXIQAXqf
 4lzvpyEsndtC1unZLaJxngcEn7XlAA1InrTq8KuE+zmaDJuObnWQqNEWaFosWipoxTcU
 u9hoRhqnkThMb+r2M26wocFvjCmd7V96CiJsc1wbvabpFW+UzPr9U5hRwbtjsKzAukYr
 TVuOS1PyKO8F1ePUaagflRTXCK37RWtOvcRwnGvrmXvUvJy6gYLVN8MlvvsVdwaJ2LYr pg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp8bf0k1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 11:22:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7BJgDE006450;
        Mon, 7 Nov 2022 11:22:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3kngpsss60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 11:22:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7BLxIm65602026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 11:21:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 144B2A4053;
        Mon,  7 Nov 2022 11:21:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C50FAA4051;
        Mon,  7 Nov 2022 11:21:58 +0000 (GMT)
Received: from [9.171.47.43] (unknown [9.171.47.43])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 11:21:58 +0000 (GMT)
Message-ID: <86aa57d3-e92e-4846-8676-cb2f93dcf59c@linux.ibm.com>
Date:   Mon, 7 Nov 2022 12:21:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v1] s390/mm: fix virtual-physical address confusion for
 swiotlb
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221107105843.6641-1-nrb@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221107105843.6641-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5iGouIc4uVm6XBqf1K3q_gPQ1_8bmmEQ
X-Proofpoint-ORIG-GUID: 5iGouIc4uVm6XBqf1K3q_gPQ1_8bmmEQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.11.22 um 11:58 schrieb Nico Boehr:
> swiotlb passes virtual addresses to set_memory_encrypted() and
> set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
> expect physical addresses. This currently works, because virtual
> and physical addresses are the same.
> 
> Add virt_to_phys() to resolve the virtual-physical confusion.
> 
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I am asking myself if we should rename addr to vaddr to make this more obvious.
(Other users of these functions do use vaddr as well).

> ---
>   arch/s390/mm/init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 97d66a3e60fb..8b652654064e 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -146,7 +146,7 @@ int set_memory_encrypted(unsigned long addr, int numpages)
>   
>   	/* make specified pages unshared, (swiotlb, dma_free) */
>   	for (i = 0; i < numpages; ++i) {
> -		uv_remove_shared(addr);
> +		uv_remove_shared(virt_to_phys((void *)addr));
>   		addr += PAGE_SIZE;
>   	}
>   	return 0;
> @@ -157,7 +157,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>   	int i;
>   	/* make specified pages shared (swiotlb, dma_alloca) */
>   	for (i = 0; i < numpages; ++i) {
> -		uv_set_shared(addr);
> +		uv_set_shared(virt_to_phys((void *)addr));
>   		addr += PAGE_SIZE;
>   	}
>   	return 0;
