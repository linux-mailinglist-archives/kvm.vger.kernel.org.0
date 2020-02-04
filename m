Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEFE151910
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 11:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgBDK5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 05:57:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726631AbgBDK5s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 05:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580813867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfX0iXS1KCHzvK2ztIKpZeVr5aPTKM4ldu7P6kIU4jA=;
        b=hCEisME7/Wx2WXN1A5gSTSsTeuR6bexY1q14HRRJofiYOSSXd1ktl/cKoaLduloNuREVeZ
        e4u20CwX+I9OWEdy/++6MXvIvXniDVKSod54p8PD9flFlnb0e5e/2f87S0I9B+w4f6QaWS
        LU/hMC8pM/inezziXOxoQpaRf5ihkfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-xOYZqA12M4qaXccWRnPs9A-1; Tue, 04 Feb 2020 05:57:46 -0500
X-MC-Unique: xOYZqA12M4qaXccWRnPs9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB0561005F71;
        Tue,  4 Feb 2020 10:57:44 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92A8110018FF;
        Tue,  4 Feb 2020 10:57:40 +0000 (UTC)
Date:   Tue, 4 Feb 2020 11:57:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 05/37] s390/mm: provide memory management functions for
 protected KVM guests
Message-ID: <20200204115738.3336787a.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-6-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-6-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:25 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> This provides the basic ultravisor calls and page table handling to cope
> with secure guests.

I'll leave reviewing the mm stuff to somebody actually familiar with
mm; only some other comments from me.

> 
> Co-authored-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h        |   2 +
>  arch/s390/include/asm/mmu.h         |   2 +
>  arch/s390/include/asm/mmu_context.h |   1 +
>  arch/s390/include/asm/page.h        |   5 +
>  arch/s390/include/asm/pgtable.h     |  34 +++++-
>  arch/s390/include/asm/uv.h          |  59 ++++++++++
>  arch/s390/kernel/uv.c               | 170 ++++++++++++++++++++++++++++
>  7 files changed, 268 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 37f96b6f0e61..f2ab8b6d4b57 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -9,6 +9,7 @@
>  #ifndef _ASM_S390_GMAP_H
>  #define _ASM_S390_GMAP_H
>  
> +#include <linux/radix-tree.h>
>  #include <linux/refcount.h>
>  
>  /* Generic bits for GMAP notification on DAT table entry changes. */
> @@ -61,6 +62,7 @@ struct gmap {
>  	spinlock_t shadow_lock;
>  	struct gmap *parent;
>  	unsigned long orig_asce;
> +	unsigned long se_handle;

This is a deviation from the "protected virtualization" naming scheme
used in the previous patches, but I understand that the naming of this
whole feature is still in flux :) (Would still be nice to have it
consistent, though.)

However, I think I'd prefer something named based on protected
virtualization: the se_* stuff here just tends to make me think of
SELinux...

>  	int edat_level;
>  	bool removed;
>  	bool initialized;
> diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
> index bcfb6371086f..984026cb3608 100644
> --- a/arch/s390/include/asm/mmu.h
> +++ b/arch/s390/include/asm/mmu.h
> @@ -16,6 +16,8 @@ typedef struct {
>  	unsigned long asce;
>  	unsigned long asce_limit;
>  	unsigned long vdso_base;
> +	/* The mmu context belongs to a secure guest. */
> +	atomic_t is_se;

Here as well.

>  	/*
>  	 * The following bitfields need a down_write on the mm
>  	 * semaphore when they are written to. As they are only

(...)

> @@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct mm_struct *mm)
>  	return 0;
>  }
>  
> +static inline int mm_is_se(struct mm_struct *mm)
> +{
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +	if (unlikely(atomic_read(&mm->context.is_se)))
> +		return 1;
> +#endif
> +	return 0;
> +}

I'm wondering how big of an overhead we actually have because we need
to check the flag here if the feature is enabled. We have an extra
check in a few functions anyway, even if protected virt is not
configured in. Given that distributions would likely want to enable the
feature in their kernels, I'm currently tending towards dropping the
extra config option.

> +
>  static inline int mm_alloc_pgste(struct mm_struct *mm)
>  {
>  #ifdef CONFIG_PGSTE

(...)

> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f7778493e829..136c60a8e3ca 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -9,6 +9,8 @@
>  #include <linux/sizes.h>
>  #include <linux/bitmap.h>
>  #include <linux/memblock.h>
> +#include <linux/pagemap.h>
> +#include <linux/swap.h>
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  #include <asm/uv.h>
> @@ -98,4 +100,172 @@ void adjust_to_uv_max(unsigned long *vmax)
>  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>  		*vmax = uv_info.max_sec_stor_addr;
>  }
> +
> +static int __uv_pin_shared(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb = {
> +		.header.cmd	= UVC_CMD_PIN_PAGE_SHARED,
> +		.header.len	= sizeof(uvcb),
> +		.paddr		= paddr,
> +	};
> +
> +	if (uv_call(0, (u64)&uvcb))
> +		return -EINVAL;
> +	return 0;

I guess this call won't set an error rc in the control block, if it
does not set a condition code != 0?

(...)

