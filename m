Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC973401DA6
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbhIFPdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:33:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30028 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242942AbhIFPds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 11:33:48 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186F3xX4146268;
        Mon, 6 Sep 2021 11:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LhLmdJTI6AgTZCvPKytLsM1D6cmN974c7wLVohpLheA=;
 b=dwvIS4lcQsXnCDut+faRAM05/oDfyB+JVLBo/T5qk0IytRsRx4Jon6VfMPaMK/1NH/50
 Km0yYDrQBUeaugxDKhm4VeH9XppYA6FmyHGoKBQ55Uk4s2LqJ9mloO0yHZG+5/P1VfNU
 Q5zqDZ6FQBjD4faaK6vl8zO84p2A9Wyqz+5Jx7z9qqtETHzstHe29Mf6Vpi8JyWKYdSA
 C4G4L9Rs4d1A08/wAmS6nQ3tt5K8Cbd7xzIZpuH0ZBW24YIYFOj2+eUDBiyC21KWwAID
 7ztTu9Zgne8t+yxkK7Y/F4wj8cXdf69szJg/7S8NLYJjyC8aHHn2BMf7MJkTJtWtRBjM 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awmsyh5es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:32:43 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186FGUZ5002560;
        Mon, 6 Sep 2021 11:32:42 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awmsyh5ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:32:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186FRWlY007301;
        Mon, 6 Sep 2021 15:32:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3av02jdvpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 15:32:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186FWaBW52167162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 15:32:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDDDB52065;
        Mon,  6 Sep 2021 15:32:36 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.95.210])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 50DCA52057;
        Mon,  6 Sep 2021 15:32:36 +0000 (GMT)
Subject: Re: [PATCH v4 05/14] KVM: s390: pv: leak the ASCE page when destroy
 fails
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-6-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <36ce2f10-a65d-ff2a-3a11-8f2cd853f3e9@de.ibm.com>
Date:   Mon, 6 Sep 2021 17:32:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MAytNYwHf8ClKL67gIMa5ms91oVoc0Sn
X-Proofpoint-ORIG-GUID: avYDd4c4sW6gu0ESxYlgekFCnz8Wx-2U
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109060096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject should say

KVM: s390: pv: leak the topmost page table when destroy fails


On 18.08.21 15:26, Claudio Imbrenda wrote:
> When a protected VM is created, the topmost level of page tables of its
> ASCE is marked by the Ultravisor; any attempt to use that memory for
> protected virtualization will result in failure.


maybe rephrase that to
Each secure guest must have a unique address space control element and we
must avoid that new guests will use the same ASCE to avoid an error. As
the ASCE mostly consists of the top most page table address (and flags)
we must not return that memory to the pool unless the ASCE is no longer
used.

Only a a successful Destroy Configuration UVC will make the ASCE no longer
collide.
When the Destroy Configuration UVC fails, the ASCE cannot be reused for a
secure guest ASCE. To avoid a collision, it must not be used again.

  
> Only a successful Destroy Configuration UVC will remove the marking.
> 
> When the Destroy Configuration UVC fails, the topmost level of page
> tables of the VM does not get its marking cleared; to avoid issues it
> must not be used again.
> 
> This is a permanent error and the page becomes in practice unusable, so
> we set it aside and leak it.

Maybe add: on failure we already leak other memory that has ultravisor marking (the
variable and base storage for a guest) and not setting the ASCE aside (by
leaking the topmost page table) was an oversight.

Or something like that

maybe also add that we usually do not expect to see such error under normal
circumstances.

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h |  2 ++
>   arch/s390/kvm/pv.c           |  4 ++-
>   arch/s390/mm/gmap.c          | 55 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 40264f60b0da..746e18bf8984 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
>   			     unsigned long gaddr, unsigned long vmaddr);
>   int gmap_mark_unmergeable(void);
>   void s390_reset_acc(struct mm_struct *mm);
> +void s390_remove_old_asce(struct gmap *gmap);
> +int s390_replace_asce(struct gmap *gmap);
>   #endif /* _ASM_S390_GMAP_H */
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 00d272d134c2..76b0d64ce8fa 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -168,9 +168,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	atomic_set(&kvm->mm->context.is_protected, 0);
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>   	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> -	/* Inteded memory leak on "impossible" error */
> +	/* Intended memory leak on "impossible" error */
>   	if (!cc)
>   		kvm_s390_pv_dealloc_vm(kvm);
> +	else
> +		s390_replace_asce(kvm->arch.gmap);
>   	return cc ? -EIO : 0;
>   }
>   
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 9bb2c7512cd5..5a138f6220c4 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2706,3 +2706,58 @@ void s390_reset_acc(struct mm_struct *mm)
>   	mmput(mm);
>   }
>   EXPORT_SYMBOL_GPL(s390_reset_acc);
> +
> +/*
> + * Remove the topmost level of page tables from the list of page tables of
> + * the gmap.
> + * This means that it will not be freed when the VM is torn down, and needs
> + * to be handled separately by the caller, unless an intentional leak is
> + * intended.
> + */
> +void s390_remove_old_asce(struct gmap *gmap)
> +{
> +	struct page *old;
> +
> +	old = virt_to_page(gmap->table);
> +	spin_lock(&gmap->guest_table_lock);
> +	list_del(&old->lru);
> +	spin_unlock(&gmap->guest_table_lock);
> +	/* in case the ASCE needs to be "removed" multiple times */
> +	INIT_LIST_HEAD(&old->lru);
shouldn't that also be under the spin_lock?

> +}
> +EXPORT_SYMBOL_GPL(s390_remove_old_asce);
> +
> +/*
> + * Try to replace the current ASCE with another equivalent one.
> + * If the allocation of the new top level page table fails, the ASCE is not
> + * replaced.
> + * In any case, the old ASCE is removed from the list, therefore the caller
> + * has to make sure to save a pointer to it beforehands, unless an
> + * intentional leak is intended.
> + */
> +int s390_replace_asce(struct gmap *gmap)
> +{
> +	unsigned long asce;
> +	struct page *page;
> +	void *table;
> +
> +	s390_remove_old_asce(gmap);
> +
> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> +	if (!page)
> +		return -ENOMEM;

It seems that we do not handle errors in our caller?

> +	table = page_to_virt(page);
> +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
> +
> +	spin_lock(&gmap->guest_table_lock);
> +	list_add(&page->lru, &gmap->crst_list);
> +	spin_unlock(&gmap->guest_table_lock);
> +
> +	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);

Instead of PAGE_MASK better use _ASCE_ORIGIN ?
> +	WRITE_ONCE(gmap->asce, asce);
> +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> +	WRITE_ONCE(gmap->table, table);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(s390_replace_asce);
> 
