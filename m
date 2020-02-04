Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A881151DFD
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBDQPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:15:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgBDQPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 11:15:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014G8kBj070177;
        Tue, 4 Feb 2020 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZrnVqhi8BXM/a8DRkP1ZS8QamZvpMhFz/n8n8D97bY4=;
 b=MEOTfQT2juaIjGhaixOmiWjxuXzwsoJQmYHAhl+L1bQoKPr8Hg3cgeN2jsdnCiaqpIEU
 p0qewlGaPDF77oLXk0gxK8wDR3ibPmRv8qXAQU5vTghFqluH/L2CnwmSPvszAp4OXPj8
 vodabVhxaoSshTbfKP4/ySFClPuqBiuBNUt9n/Zlm/31U+rYJAHHjHW172SSqQ0jCxEi
 96o7SPFrYL4Xpl4llig07iuK9dZk/Wg2UtcgxAo7jZ9RLXQKUNJt6Fpf85h20j4zxSwD
 LpD2r1MIUg8l81VAwc9gfmiPdT4eBbMSF93JR+4pv6xPfgdWIzDsDcUDgSgpKvuKxbdk ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xw19qfqp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 16:14:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014G9Ttk067973;
        Tue, 4 Feb 2020 16:14:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xxsbq73jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 16:14:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 014GEQGH005683;
        Tue, 4 Feb 2020 16:14:26 GMT
Received: from [10.175.207.61] (/10.175.207.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 08:14:25 -0800
Subject: Re: [PATCH RFC 01/10] mm: Add pmd support for _PAGE_SPECIAL
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-2-joao.m.martins@oracle.com>
 <20200203213442.GK8731@bombadil.infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <82a41394-76c3-d643-3b49-af37a2036b73@oracle.com>
Date:   Tue, 4 Feb 2020 16:14:18 +0000
MIME-Version: 1.0
In-Reply-To: <20200203213442.GK8731@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9520 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/20 9:34 PM, Matthew Wilcox wrote:
> On Fri, Jan 10, 2020 at 07:03:04PM +0000, Joao Martins wrote:
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -293,6 +293,15 @@ static inline int pgd_devmap(pgd_t pgd)
>>  {
>>  	return 0;
>>  }
>> +#endif
>> +
>> +#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
>> +static inline int pmd_special(pmd_t pmd)
>> +{
>> +	return !!(pmd_flags(pmd) & _PAGE_SPECIAL);
>> +}
>> +#endif
> 
> The ifdef/endif don't make much sense here; x86 does have PTE_SPECIAL,
> and this is an x86 header file, so that can be assumed.
> 
Gotcha.

>> +++ b/mm/gup.c
>> @@ -2079,6 +2079,9 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>  		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
>>  	}
>>  
>> +	if (pmd_special(orig))
>> +		return 0;
> 
> Here, you're calling it unconditionally.  I think you need a pmd_special()
> conditionally defined in include/asm-generic/pgtable.h
> 
> +#ifndef CONFIG_ARCH_HAS_PTE_SPECIAL
> +static inline bool pmd_special(pmd_t pmd)
> +{
> +	return false;
> +}
> +#endif
> 
> (oh, and plese use bool instead of int; I know that's different from
> pte_special(), but pte_special() predates bool and nobody's done the work
> to convert it yet)
> 
Got it.

>> +++ b/mm/huge_memory.c
>> @@ -791,6 +791,8 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>>  	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>>  	if (pfn_t_devmap(pfn))
>>  		entry = pmd_mkdevmap(entry);
>> +	else if (pfn_t_special(pfn))
>> +		entry = pmd_mkspecial(entry);
> 
> Again, we'll need a generic one.
> 
Will add it.

>> @@ -823,8 +825,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>>  	 * but we need to be consistent with PTEs and architectures that
>>  	 * can't support a 'special' bit.
>>  	 */
>> -	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
>> -			!pfn_t_devmap(pfn));
>> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
> 
> Should that rather be ...
> 
> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
> +			!pfn_t_devmap(pfn) && !pfn_t_special(pfn));
> 
Yes. That is indeed a mistake I had already fixed for v2. Patch 3 does the exact
same, so as the other comments you mentioned here too so will adjust that
accordingly.

> I also think this comment needs adjusting:
> 
>         /*
>          * There is no pmd_special() but there may be special pmds, e.g.
>          * in a direct-access (dax) mapping, so let's just replicate the
>          * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
>          */
> 
> 
I'll replace with what vm_normal_page() equivalent has:

	/* !CONFIG_ARCH_HAS_PTE_SPECIAL case follows: */

  Joao
