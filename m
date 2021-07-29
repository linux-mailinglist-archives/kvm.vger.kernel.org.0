Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509FD3DA259
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 13:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhG2Lnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 07:43:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233949AbhG2Lng (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 07:43:36 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TBZRYL158253;
        Thu, 29 Jul 2021 07:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N77Uh/TOkWlgGPDK+0wtUuo8+tx2rxTwOHNNLClxXHE=;
 b=bf6N1I8oi17285BZF2NdUxuu4sF/MMD9EZhCDr/GlCMO9wc5rmx7B5Fu5/j0/WuSBSp7
 exIhQi/c9rkEBPwJ704heKoDiVevSNQnMP+cUQD3xgKF6ULMDbijoL/UKLVPVBDR7C8/
 4UVJCyWK3NB/0k42b5t0wVxV6DhAcTfiHz8/TjEjs1Y8E9xuP+/HWt+GOzeBbSC9xP19
 pDDGrleylEbxLQCEo5eYaWjlDd9HMfNQgIBgF5sUORhB5201Z/MFvTMqF43IDDoSxtJl
 I+2GZpHPZoAlv4v+mBRDzEE62bFiwt9tSXHLYKJkHCz4LNuHsEXTiQXfW8YoRWLdr0mS qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3fb162kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 07:43:33 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TBaM1T165593;
        Thu, 29 Jul 2021 07:43:32 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3fb162jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 07:43:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TBhDex003197;
        Thu, 29 Jul 2021 11:43:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3a235ps34g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 11:43:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TBhQ6N31261114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 11:43:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6489C11C070;
        Thu, 29 Jul 2021 11:43:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA3511C052;
        Thu, 29 Jul 2021 11:43:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 11:43:25 +0000 (GMT)
Subject: Re: [PATCH v2 03/13] KVM: s390: pv: properly handle page flags for
 protected guests
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <825b1d54-39ea-334d-e637-a26995780f53@linux.ibm.com>
Date:   Thu, 29 Jul 2021 13:43:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728142631.41860-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: If0OG2Vr98Ex_lrPPAhL1BNthCCz56rD
X-Proofpoint-GUID: NVKAAFblsZOUl-cpFvJl9yjQkJrJMy52
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> Introduce variants of the convert and destroy page functions that also
> clear the PG_arch_1 bit used to mark them as secure pages.
> 
> These new functions can only be called on pages for which a reference
> is already being held.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h |  9 ++++++---
>  arch/s390/include/asm/uv.h      | 10 ++++++++--
>  arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
>  arch/s390/mm/gmap.c             |  4 +++-
>  4 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index dcac7b2df72c..0f1af2232ebe 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  	pte_t res;
>  
>  	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>  	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>  	return res;
>  }
>  
> @@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
>  	pte_t res;
>  
>  	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>  	if (mm_is_protected(vma->vm_mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>  	return res;
>  }
>  
> @@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>  	} else {
>  		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>  	}
> +	/* At this point the reference through the mapping is still present */
>  	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>  	return res;
>  }
>  
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..bbd51aa94d05 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -351,8 +351,9 @@ static inline int is_prot_virt_host(void)
>  }
>  
>  int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> -int uv_destroy_page(unsigned long paddr);
> +int uv_destroy_owned_page(unsigned long paddr);
>  int uv_convert_from_secure(unsigned long paddr);
> +int uv_convert_owned_from_secure(unsigned long paddr);
>  int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>  
>  void setup_uv(void);
> @@ -362,7 +363,7 @@ void adjust_to_uv_max(unsigned long *vmax);
>  static inline void setup_uv(void) {}
>  static inline void adjust_to_uv_max(unsigned long *vmax) {}
>  
> -static inline int uv_destroy_page(unsigned long paddr)
> +static inline int uv_destroy_owned_page(unsigned long paddr)
>  {
>  	return 0;
>  }
> @@ -371,6 +372,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
>  {
>  	return 0;
>  }
> +
> +static inline int uv_convert_owned_from_secure(unsigned long paddr)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index fd0faa51c1bb..5a6ac965f379 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -115,7 +115,7 @@ static int uv_pin_shared(unsigned long paddr)
>   *
>   * @paddr: Absolute host address of page to be destroyed
>   */
> -int uv_destroy_page(unsigned long paddr)
> +static int uv_destroy_page(unsigned long paddr)
>  {
>  	struct uv_cb_cfs uvcb = {
>  		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> @@ -135,6 +135,22 @@ int uv_destroy_page(unsigned long paddr)
>  	return 0;
>  }
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
>  /*
>   * Requests the Ultravisor to encrypt a guest page and make it
>   * accessible to the host for paging (export).
> @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
>  	return 0;
>  }
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
>  /*
>   * Calculate the expected ref_count for a page that would otherwise have no
>   * further pins. This was cribbed from similar functions in other places in
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 9bb2c7512cd5..de679facc720 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2678,8 +2678,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>  {
>  	pte_t pte = READ_ONCE(*ptep);
>  
> +	/* There is a reference through the mapping */
>  	if (pte_present(pte))
> -		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
> +		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> +
>  	return 0;
>  }
>  
> 

