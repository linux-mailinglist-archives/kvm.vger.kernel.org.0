Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53360152197
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 21:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgBDUwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 15:52:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47457 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727387AbgBDUwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 15:52:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580849550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cHfYCo9xOYGI2I/K8b0rGJu5EV3ECcANUgM4yGs3DaA=;
        b=CLPPEBwYb2XmKAqUi3w3rN47QZOfeFdxPTCltfDG33ePuzg/SDsQKzjd3UYwmoSj6Gd1Fk
        E/jvGFkzgavn8wqsT5jjlAqPo0QFdQFaGeZcNbh6V0/em/LvBhH0J/u3zjCA6aADQFotJF
        1fwon3DzfstULyZPx4OPl17zbUzUhUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-saq-cmYJMQWxQQrUkHKnOQ-1; Tue, 04 Feb 2020 15:52:26 -0500
X-MC-Unique: saq-cmYJMQWxQQrUkHKnOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8462B2EDA;
        Tue,  4 Feb 2020 20:52:24 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-98.ams2.redhat.com [10.36.116.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 325E489E76;
        Tue,  4 Feb 2020 20:52:19 +0000 (UTC)
Subject: Re: [RFCv2 11/37] KVM: s390/mm: Make pages accessible before
 destroying the guest
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-12-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7b73da46-ad64-3ab5-cd59-5a302bbbdc5f@redhat.com>
Date:   Tue, 4 Feb 2020 21:52:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-12-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> Before we destroy the secure configuration, we better make all
> pages accessible again. This also happens during reboot, where we reboot
> into a non-secure guest that then can go again into a secure mode. As
> this "new" secure guest will have a new ID we cannot reuse the old page
> state.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/pgtable.h |  1 +
>  arch/s390/kvm/pv.c              |  2 ++
>  arch/s390/mm/gmap.c             | 35 +++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 65b6bb47af0a..6e167dcc35f1 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1669,6 +1669,7 @@ extern int vmem_remove_mapping(unsigned long start, unsigned long size);
>  extern int s390_enable_sie(void);
>  extern int s390_enable_skey(void);
>  extern void s390_reset_cmma(struct mm_struct *mm);
> +extern void s390_reset_acc(struct mm_struct *mm);
>  
>  /* s390 has a private copy of get unmapped area to deal with cache synonyms */
>  #define HAVE_ARCH_UNMAPPED_AREA
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index a867b9e9c069..24d802072ac7 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -66,6 +66,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
>  	int rc;
>  	u32 ret;
>  
> +	/* make all pages accessible before destroying the guest */
> +	s390_reset_acc(kvm->mm);
>  	rc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
>  			   UVC_CMD_DESTROY_SEC_CONF, &ret);
>  	WRITE_ONCE(kvm->arch.gmap->se_handle, 0);
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index bf365a09f900..0b00e8d5fa39 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2648,3 +2648,38 @@ void s390_reset_cmma(struct mm_struct *mm)
>  	up_write(&mm->mmap_sem);
>  }
>  EXPORT_SYMBOL_GPL(s390_reset_cmma);
> +
> +/*
> + * make inaccessible pages accessible again
> + */
> +static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> +			    unsigned long next, struct mm_walk *walk)
> +{
> +	pte_t pte = READ_ONCE(*ptep);
> +
> +	if (pte_present(pte))
> +		uv_convert_from_secure(pte_val(pte) & PAGE_MASK);

Is it ok to ignore the return value from uv_convert_from_secure() ?
Problems might go unnoticed ... maybe use at least a WARN_ONCE ?

> +	return 0;
> +}
> +
> +static const struct mm_walk_ops reset_acc_walk_ops = {
> +	.pte_entry		= __s390_reset_acc,
> +};
> +
> +#include <linux/sched/mm.h>
> +void s390_reset_acc(struct mm_struct *mm)
> +{
> +	/*
> +	 * we might be called during
> +	 * reset:                            we walk the pages and clear
> +	 * close of all kvm file descriptor: we walk the pages and clear
> +	 * exit of process on fd closure:    vma already gone, do nothing
> +	 */
> +	if (!mmget_not_zero(mm))
> +		return;
> +	down_read(&mm->mmap_sem);
> +	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +}
> +EXPORT_SYMBOL_GPL(s390_reset_acc);
> 

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>

