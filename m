Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA9061F342
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiKGMau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiKGM3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:29:14 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E57513CCE;
        Mon,  7 Nov 2022 04:29:13 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7C9dox031474;
        Mon, 7 Nov 2022 12:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NJ875JqG8nx5lP+9Ofjvcl66nb8P9Ka7WbRGVcqVXas=;
 b=SevJlLChXDby5NAlmHm1ClTG4zsxa+D/1glIkj33OEldzp9Wf4Mj/YOzwUmJ5ycGeh4o
 FW5y3RHoH+nWJOTjbcfdKerrv9Hw/mc8N3a+ygev7fuTchQjlvHAWBqg/+5tHgs1cXX6
 FajVmCv/xhN27Mi7ajIKr0tOmZ00gW+vt7Dkcvz/y0k1YUgP95iJme1nNSPtvw+S0pL2
 0JdLiJPwL9hxS46NBN9GRMxG+cO08+g5bB26f2rvQgmcQw1o9eQR+v+caBRPbMpTiMgR
 rtgPtaPXvOT/W0SiKCxjTykGc+mkZAnYd+5Wwr0FsFZ9eShzQ7J5FgutnNXBKh33kNod LQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gm1p3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:29:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7CK02b023356;
        Mon, 7 Nov 2022 12:29:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kngqgak54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:29:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7CT71A62456224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 12:29:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 216D411C058;
        Mon,  7 Nov 2022 12:29:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4E2F11C04C;
        Mon,  7 Nov 2022 12:29:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 12:29:06 +0000 (GMT)
Date:   Mon, 7 Nov 2022 13:29:05 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/1] s390/mm: fix virtual-physical address confusion
 for swiotlb
Message-ID: <20221107132905.1025414f@p-imbrenda>
In-Reply-To: <20221107121221.156274-2-nrb@linux.ibm.com>
References: <20221107121221.156274-1-nrb@linux.ibm.com>
        <20221107121221.156274-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Jnxt4Cf9_-yrTY4vsoN1TkaepRMjtdaC
X-Proofpoint-GUID: Jnxt4Cf9_-yrTY4vsoN1TkaepRMjtdaC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Nov 2022 13:12:21 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> swiotlb passes virtual addresses to set_memory_encrypted() and
> set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
> expect physical addresses. This currently works, because virtual
> and physical addresses are the same.
> 
> Add virt_to_phys() to resolve the virtual-physical confusion.
> 
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/mem_encrypt.h |  4 ++--
>  arch/s390/mm/init.c                 | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
> index 08a8b96606d7..b85e13505a0f 100644
> --- a/arch/s390/include/asm/mem_encrypt.h
> +++ b/arch/s390/include/asm/mem_encrypt.h
> @@ -4,8 +4,8 @@
>  
>  #ifndef __ASSEMBLY__
>  
> -int set_memory_encrypted(unsigned long addr, int numpages);
> -int set_memory_decrypted(unsigned long addr, int numpages);
> +int set_memory_encrypted(unsigned long vaddr, int numpages);
> +int set_memory_decrypted(unsigned long vaddr, int numpages);
>  
>  #endif	/* __ASSEMBLY__ */
>  
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 97d66a3e60fb..d509656c67d7 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -140,25 +140,25 @@ void mark_rodata_ro(void)
>  	debug_checkwx();
>  }
>  
> -int set_memory_encrypted(unsigned long addr, int numpages)
> +int set_memory_encrypted(unsigned long vaddr, int numpages)
>  {
>  	int i;
>  
>  	/* make specified pages unshared, (swiotlb, dma_free) */
>  	for (i = 0; i < numpages; ++i) {
> -		uv_remove_shared(addr);
> -		addr += PAGE_SIZE;
> +		uv_remove_shared(virt_to_phys((void *)vaddr));
> +		vaddr += PAGE_SIZE;
>  	}
>  	return 0;
>  }
>  
> -int set_memory_decrypted(unsigned long addr, int numpages)
> +int set_memory_decrypted(unsigned long vaddr, int numpages)
>  {
>  	int i;
>  	/* make specified pages shared (swiotlb, dma_alloca) */
>  	for (i = 0; i < numpages; ++i) {
> -		uv_set_shared(addr);
> -		addr += PAGE_SIZE;
> +		uv_set_shared(virt_to_phys((void *)vaddr));
> +		vaddr += PAGE_SIZE;
>  	}
>  	return 0;
>  }

