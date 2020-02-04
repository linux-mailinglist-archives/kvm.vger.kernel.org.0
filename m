Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2206B151972
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 12:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgBDLSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 06:18:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726908AbgBDLSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 06:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580815109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPIhvHt3W7KVSuQIB0FkR5M7QwcguUaHb9Jb9v+rfPg=;
        b=GXKeeKfxXmkyEEC1jbdx+x2mo05wLEeeFuLp7xgFVojAwyXXBi82irDwbQGZf6uNb5BF8V
        4jGMQs8BdmTxEebA0wv8MSLgYeXrIHRHNsNnYYo8AhJlqUs+0c/fiLOkpyrBuNSOWaRkS1
        r0KrBjoXhYsBjsDUps4BQpH5SOjg1rI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-3_uETUYmNjCvQ46Yz3i2Iw-1; Tue, 04 Feb 2020 06:18:25 -0500
X-MC-Unique: 3_uETUYmNjCvQ46Yz3i2Iw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E6C51336575;
        Tue,  4 Feb 2020 11:18:24 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF1BF5D9CA;
        Tue,  4 Feb 2020 11:18:19 +0000 (UTC)
Date:   Tue, 4 Feb 2020 12:18:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
Message-ID: <20200204121817.10a5f271.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-7-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-7-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:26 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add exceptions handlers performing transparent transition of non-secure
> pages to secure (import) upon guest access and secure pages to
> non-secure (export) upon hypervisor access.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [adding checks for failures]
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> [further changes like adding a check for gmap fault]
> ---
>  arch/s390/kernel/pgm_check.S |  4 +-
>  arch/s390/mm/fault.c         | 87 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
> index 59dee9d3bebf..27ac4f324c70 100644
> --- a/arch/s390/kernel/pgm_check.S
> +++ b/arch/s390/kernel/pgm_check.S
> @@ -78,8 +78,8 @@ PGM_CHECK(do_dat_exception)		/* 39 */
>  PGM_CHECK(do_dat_exception)		/* 3a */
>  PGM_CHECK(do_dat_exception)		/* 3b */
>  PGM_CHECK_DEFAULT			/* 3c */
> -PGM_CHECK_DEFAULT			/* 3d */
> -PGM_CHECK_DEFAULT			/* 3e */
> +PGM_CHECK(do_secure_storage_access)	/* 3d */
> +PGM_CHECK(do_non_secure_storage_access)	/* 3e */

I suppose that these two can only happen when we actually run a
protected virt guest...

>  PGM_CHECK_DEFAULT			/* 3f */
>  PGM_CHECK_DEFAULT			/* 40 */
>  PGM_CHECK_DEFAULT			/* 41 */
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 7b0bb475c166..bd75b0765cf1 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -38,6 +38,7 @@
>  #include <asm/irq.h>
>  #include <asm/mmu_context.h>
>  #include <asm/facility.h>
> +#include <asm/uv.h>
>  #include "../kernel/entry.h"
>  
>  #define __FAIL_ADDR_MASK -4096L
> @@ -816,3 +817,89 @@ static int __init pfault_irq_init(void)
>  early_initcall(pfault_irq_init);
>  
>  #endif /* CONFIG_PFAULT */
> +
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +
> +void do_secure_storage_access(struct pt_regs *regs)
> +{
> +	unsigned long addr = regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	struct page *page;
> +	int rc;

...so this rather complex function will never be called if we don't act
as a host for protected virt guests?

> +
> +	switch (get_fault_type(regs)) {
> +	case USER_FAULT:
> +		mm = current->mm;
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma(mm, addr);
> +		if (!vma) {
> +			up_read(&mm->mmap_sem);
> +			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +			break;
> +		}
> +		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
> +		if (IS_ERR_OR_NULL(page)) {
> +			up_read(&mm->mmap_sem);
> +			break;
> +		}
> +		if (arch_make_page_accessible(page))
> +			send_sig(SIGSEGV, current, 0);
> +		put_page(page);
> +		up_read(&mm->mmap_sem);
> +		break;
> +	case KERNEL_FAULT:
> +		page = phys_to_page(addr);
> +		if (unlikely(!try_get_page(page)))
> +			break;
> +		rc = arch_make_page_accessible(page);
> +		put_page(page);
> +		if (rc)
> +			BUG();
> +		break;
> +	case VDSO_FAULT:
> +		/* fallthrough */
> +	case GMAP_FAULT:
> +		/* fallthrough */
> +	default:
> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +NOKPROBE_SYMBOL(do_secure_storage_access);
> +
> +void do_non_secure_storage_access(struct pt_regs *regs)
> +{
> +	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
> +	struct uv_cb_cts uvcb = {
> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.guest_handle = gmap->se_handle,
> +		.gaddr = gaddr,
> +	};
> +	int rc;

Same for this function, of course.

> +
> +	if (get_fault_type(regs) != GMAP_FAULT) {
> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +		WARN_ON_ONCE(1);
> +		return;
> +	}
> +
> +	rc = uv_make_secure(gmap, gaddr, &uvcb, 0);
> +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
> +		send_sig(SIGSEGV, current, 0);
> +}
> +NOKPROBE_SYMBOL(do_non_secure_storage_access);
> +
> +#else
> +void do_secure_storage_access(struct pt_regs *regs)
> +{
> +	default_trap_handler(regs);
> +}
> +
> +void do_non_secure_storage_access(struct pt_regs *regs)
> +{
> +	default_trap_handler(regs);
> +}

And these should not really be called at all, I guess?

> +#endif

IOW, we don't really introduce complex code paths for systems not
acting as protected virt hosts, even if we switch on the config option
or ditch it completely?

