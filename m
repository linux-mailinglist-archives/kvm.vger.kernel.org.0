Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2361F2B2
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiKGMNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiKGMNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:13:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4731B798;
        Mon,  7 Nov 2022 04:13:40 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7BMg0H016602;
        Mon, 7 Nov 2022 12:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SOtxtQG9TdhG3cJsTfBxIILcYHgJm1HAOWUR8TTA66U=;
 b=HzrGqTYTWkMCZ1wXkyzK2cIO2pKJrPAc9t82XgTTh71CpUx6zPKeS6P8aFFgIu0qkSd0
 02BE8KDmZbtawD1mUQYZxR5anXMsnuqroN0I7FguAWy5Fp0Rv1HlIf3fIq6w2Mi0MEtZ
 2yufxwwGtWAzcwlFclMi3pdaY1juIbvICUZSwz3v3LHMS+Y1c4lmvt5OZW6dCId7nusz
 NZH8Dmn7AWjzVGediOowjEpOPEvcB1uoZONzrfE5s8eYb8mOaBrX6Xiyaxol+axv+9ee
 W8gUN0Al44PzEJIcL3/2Qc+be+6Eg9XZsFWjZREgdZ8x53LZFxkaMjB9QRI1dhR5DOZr 5w== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14x1p50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:13:40 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7C5ajj009538;
        Mon, 7 Nov 2022 12:13:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3kngpsstk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:13:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7CDXtL62783998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 12:13:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD2AAA4059;
        Mon,  7 Nov 2022 12:13:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 882A2A4055;
        Mon,  7 Nov 2022 12:13:33 +0000 (GMT)
Received: from [9.171.47.43] (unknown [9.171.47.43])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 12:13:33 +0000 (GMT)
Message-ID: <2fa2bab1-bcf8-9a9b-d402-c22dc1dbc8a2@linux.ibm.com>
Date:   Mon, 7 Nov 2022 13:13:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 1/1] s390/mm: fix virtual-physical address confusion
 for swiotlb
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221107121221.156274-1-nrb@linux.ibm.com>
 <20221107121221.156274-2-nrb@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221107121221.156274-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PbaH4CdNrpbnNdkOR53HBKg5dcwbMqLe
X-Proofpoint-GUID: PbaH4CdNrpbnNdkOR53HBKg5dcwbMqLe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.11.22 um 13:12 schrieb Nico Boehr:
> swiotlb passes virtual addresses to set_memory_encrypted() and
> set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
> expect physical addresses. This currently works, because virtual
> and physical addresses are the same.
> 
> Add virt_to_phys() to resolve the virtual-physical confusion.
> 
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

You can keep my RB:

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/include/asm/mem_encrypt.h |  4 ++--
>   arch/s390/mm/init.c                 | 12 ++++++------
>   2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
> index 08a8b96606d7..b85e13505a0f 100644
> --- a/arch/s390/include/asm/mem_encrypt.h
> +++ b/arch/s390/include/asm/mem_encrypt.h
> @@ -4,8 +4,8 @@
>   
>   #ifndef __ASSEMBLY__
>   
> -int set_memory_encrypted(unsigned long addr, int numpages);
> -int set_memory_decrypted(unsigned long addr, int numpages);
> +int set_memory_encrypted(unsigned long vaddr, int numpages);
> +int set_memory_decrypted(unsigned long vaddr, int numpages);
>   
>   #endif	/* __ASSEMBLY__ */
>   
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 97d66a3e60fb..d509656c67d7 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -140,25 +140,25 @@ void mark_rodata_ro(void)
>   	debug_checkwx();
>   }
>   
> -int set_memory_encrypted(unsigned long addr, int numpages)
> +int set_memory_encrypted(unsigned long vaddr, int numpages)
>   {
>   	int i;
>   
>   	/* make specified pages unshared, (swiotlb, dma_free) */
>   	for (i = 0; i < numpages; ++i) {
> -		uv_remove_shared(addr);
> -		addr += PAGE_SIZE;
> +		uv_remove_shared(virt_to_phys((void *)vaddr));
> +		vaddr += PAGE_SIZE;
>   	}
>   	return 0;
>   }
>   
> -int set_memory_decrypted(unsigned long addr, int numpages)
> +int set_memory_decrypted(unsigned long vaddr, int numpages)
>   {
>   	int i;
>   	/* make specified pages shared (swiotlb, dma_alloca) */
>   	for (i = 0; i < numpages; ++i) {
> -		uv_set_shared(addr);
> -		addr += PAGE_SIZE;
> +		uv_set_shared(virt_to_phys((void *)vaddr));
> +		vaddr += PAGE_SIZE;
>   	}
>   	return 0;
>   }
