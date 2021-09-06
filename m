Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47812401DBB
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhIFPry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:47:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58852 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231359AbhIFPrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 11:47:53 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186FYfMo042902;
        Mon, 6 Sep 2021 11:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bJPDx5YkN0OvbpWmsIrGzk78OW8FXNIw73w9gZpOJ44=;
 b=aPxa96N/xDDUAt6s178S6tApJMWcjH341XbmphlMU3Bv+9JLd+I5WKBqQB1WqB1sFI5S
 3q9dGmRcLi3u6QxQxaJXexBy1A4plLwryV8UxP7dFoD8GRd9GtrI5ii5TNzFWvnmRnIY
 UT/bDHVnfOrNi/Y8aY6vhRKFSAARL5IeTrQB/hzySmWeW8B+ktlb5WJfvlsN2/HqHrmn
 vsJtF2Ljf1rrprrweWQg/eTMzAgR3yeFfhvZwwBG4HTAwKwF7cojUzGBuClAbJYZo1/l
 mtPelPsu7yNJ65p5djrd9BY2XGtZyXvSAZyHHGA0JwxuujmpkuxH6UO9NhooGfdzMK2x QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awnrkr50j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:46:47 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186FZOsm047791;
        Mon, 6 Sep 2021 11:46:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awnrkr505-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:46:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186FhOfV014213;
        Mon, 6 Sep 2021 15:46:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3av02j55f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 15:46:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186FgUh556820154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 15:42:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FDC252057;
        Mon,  6 Sep 2021 15:46:41 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.95.210])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 196EB5204F;
        Mon,  6 Sep 2021 15:46:41 +0000 (GMT)
Subject: Re: [PATCH v4 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-7-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1a44ff5c-f59f-2f37-2585-084294ed5e11@de.ibm.com>
Date:   Mon, 6 Sep 2021 17:46:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K4dlWt3rTIdepGndDu4RgLPYmqToymp6
X-Proofpoint-GUID: xjVZqJVlpIwISUtsgH9ROE-vT8x_osvG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.08.21 15:26, Claudio Imbrenda wrote:
> Introduce variants of the convert and destroy page functions that also
> clear the PG_arch_1 bit used to mark them as secure pages.
> 
> These new functions can only be called on pages for which a reference
> is already being held.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>

Can you refresh my mind? We do have over-indication of PG_arch_1 and this
might result in spending some unneeded cycles but in the end this will be
correct. Right?
And this patch will fix some unnecessary places that add overindication.
> ---
>   arch/s390/include/asm/pgtable.h |  9 ++++++---
>   arch/s390/include/asm/uv.h      | 10 ++++++++--
>   arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
>   arch/s390/mm/gmap.c             |  4 +++-
>   4 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index dcac7b2df72c..0f1af2232ebe 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>   	pte_t res;
>   
>   	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> @@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
>   	pte_t res;
>   
>   	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(vma->vm_mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> @@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>   	} else {
>   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>   	}
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index b35add51b967..3236293d5a31 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -356,8 +356,9 @@ static inline int is_prot_virt_host(void)
>   }
>   
>   int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> -int uv_destroy_page(unsigned long paddr);
> +int uv_destroy_owned_page(unsigned long paddr);
>   int uv_convert_from_secure(unsigned long paddr);
> +int uv_convert_owned_from_secure(unsigned long paddr);
>   int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>   
>   void setup_uv(void);
> @@ -367,7 +368,7 @@ void adjust_to_uv_max(unsigned long *vmax);
>   static inline void setup_uv(void) {}
>   static inline void adjust_to_uv_max(unsigned long *vmax) {}
>   
> -static inline int uv_destroy_page(unsigned long paddr)
> +static inline int uv_destroy_owned_page(unsigned long paddr)
>   {
>   	return 0;
>   }
> @@ -376,6 +377,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
>   {
>   	return 0;
>   }
> +
> +static inline int uv_convert_owned_from_secure(unsigned long paddr)
> +{
> +	return 0;
> +}
>   #endif
>   
>   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 68a8fbafcb9c..05f8bf61d20a 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -115,7 +115,7 @@ static int uv_pin_shared(unsigned long paddr)
>    *
>    * @paddr: Absolute host address of page to be destroyed
>    */
> -int uv_destroy_page(unsigned long paddr)
> +static int uv_destroy_page(unsigned long paddr)
>   {
>   	struct uv_cb_cfs uvcb = {
>   		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> @@ -135,6 +135,22 @@ int uv_destroy_page(unsigned long paddr)
>   	return 0;
>   }
>   
> +/*
> + * The caller must already hold a reference to the page
> + */
> +int uv_destroy_owned_page(unsigned long paddr)
> +{
> +	struct page *page = phys_to_page(paddr);
> +	int rc;
> +
> +	get_page(page);
> +	rc = uv_destroy_page(paddr);
> +	if (!rc)
> +		clear_bit(PG_arch_1, &page->flags);
> +	put_page(page);
> +	return rc;
> +}
> +
>   /*
>    * Requests the Ultravisor to encrypt a guest page and make it
>    * accessible to the host for paging (export).
> @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
>   	return 0;
>   }
>   
> +/*
> + * The caller must already hold a reference to the page
> + */
> +int uv_convert_owned_from_secure(unsigned long paddr)
> +{
> +	struct page *page = phys_to_page(paddr);
> +	int rc;
> +
> +	get_page(page);
> +	rc = uv_convert_from_secure(paddr);
> +	if (!rc)
> +		clear_bit(PG_arch_1, &page->flags);
> +	put_page(page);
> +	return rc;
> +}
> +
>   /*
>    * Calculate the expected ref_count for a page that would otherwise have no
>    * further pins. This was cribbed from similar functions in other places in
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 5a138f6220c4..38b792ab57f7 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2678,8 +2678,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>   {
>   	pte_t pte = READ_ONCE(*ptep);
>   
> +	/* There is a reference through the mapping */
>   	if (pte_present(pte))
> -		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
> +		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> +
>   	return 0;
>   }
>   
> 
