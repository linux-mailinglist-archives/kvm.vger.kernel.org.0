Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BE23DA185
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 12:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhG2Kta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 06:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236520AbhG2KtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 06:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627555753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZ7sUAzPLCx+igL+qYK5oAUhkT7/9Lc+cUII6v850Ns=;
        b=LMjuFFg3UHJqy8AM2o2mATWvaABSuZGt+ObS7e/LSqKxNPteboMRNq6FinSDDFyM3uk5Xa
        SDXIKNxLty7ZNM/iqrnmeXYa0owIBeieYwzuePM+92omd7BszytYdDFOF5Tp+/W8nup5cY
        QsV3FoWMwTZZrl4ialVBrU6unz69yQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-O721HR48OhWO6uZVuyu9sA-1; Thu, 29 Jul 2021 06:49:10 -0400
X-MC-Unique: O721HR48OhWO6uZVuyu9sA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06BE018C8C01;
        Thu, 29 Jul 2021 10:49:09 +0000 (UTC)
Received: from localhost (unknown [10.39.192.140])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 159391007606;
        Thu, 29 Jul 2021 10:49:04 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] KVM: s390: pv: avoid stall notifications for
 some UVCs
In-Reply-To: <20210728142631.41860-2-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-2-imbrenda@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 29 Jul 2021 12:49:03 +0200
Message-ID: <87h7gd2y5c.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28 2021, Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> Improve make_secure_pte to avoid stalls when the system is heavily
> overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> because of the loop over all pages that needed unpacking.
>
> Also fix kvm_s390_pv_init_vm to avoid stalls when the system is heavily
> overcommitted.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 11 ++++++++---
>  arch/s390/kvm/pv.c    |  2 +-
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..fd0faa51c1bb 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -196,11 +196,16 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>  	if (!page_ref_freeze(page, expected))
>  		return -EBUSY;
>  	set_bit(PG_arch_1, &page->flags);
> -	rc = uv_call(0, (u64)uvcb);
> +	rc = __uv_call(0, (u64)uvcb);
>  	page_ref_unfreeze(page, expected);
> -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> -	if (rc)
> +	/*
> +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * If busy or partially completed, return -EAGAIN.
> +	 */
> +	if (rc == 1)
>  		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> +	else if (rc > 1)
> +		rc = -EAGAIN;
>  	return rc;
>  }

Possibly dumb question: when does the call return > 1?
gmap_make_secure() will do a wait_on_page_writeback() for -EAGAIN, is
that always the right thing to do?

