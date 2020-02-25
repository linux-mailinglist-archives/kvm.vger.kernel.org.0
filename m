Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D809316C0A1
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgBYMTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:19:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgBYMTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 07:19:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582633142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4txWtq5PDJ4huKNCyoyrje49ouJDJ3zc1/f5nbodI94=;
        b=Ph2Kc7OkG8CdXBSWERyIM/Tg8ib0HoGWAnIEwV919sWgfkeABKNsmaJLPGMefLx/BSWjxS
        Q8d3c1bXGVWHCMDStRV2mJ6myg63YBwsbB/Mq7+cjGucMrR+kYyy4ewKxmyEAk53Xo/v1X
        673oAidaApp8WLs5Enp0uiTcym7h7w4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-PQpvN88BMWm7F-YLs3xe5g-1; Tue, 25 Feb 2020 07:18:59 -0500
X-MC-Unique: PQpvN88BMWm7F-YLs3xe5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D9961857367;
        Tue, 25 Feb 2020 12:18:57 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32F5791840;
        Tue, 25 Feb 2020 12:18:53 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:18:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 20/36] KVM: s390/mm: handle guest unpin events
Message-ID: <20200225131838.2d68e7f9.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-21-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-21-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:51 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> The current code tries to first pin shared pages, if that fails (e.g.
> because the page is not shared) it will export them. For shared pages
> this means that we get a new intercept telling us that the guest is
> unsharing that page. We will make the page secure at that point in time
> and revoke the host access. This is synchronized with other host events,
> e.g. the code will wait until host I/O has finished.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index b6b7d4b0e26c..c06599939541 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -16,6 +16,7 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/irq.h>
>  #include <asm/sysinfo.h>
> +#include <asm/uv.h>
>  
>  #include "kvm-s390.h"
>  #include "gaccess.h"
> @@ -484,12 +485,35 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_pv_uvc(struct kvm_vcpu *vcpu)
> +{
> +	struct uv_cb_share *guest_uvcb = (void *)vcpu->arch.sie_block->sidad;
> +	struct uv_cb_cts uvcb = {
> +		.header.cmd	= UVC_CMD_UNPIN_PAGE_SHARED,
> +		.header.len	= sizeof(uvcb),
> +		.guest_handle	= kvm_s390_pv_get_handle(vcpu->kvm),
> +		.gaddr		= guest_uvcb->paddr,
> +	};
> +	int rc;
> +
> +	if (guest_uvcb->header.cmd != UVC_CMD_REMOVE_SHARED_ACCESS) {
> +		WARN_ONCE(1, "Unexpected UVC 0x%x!\n", guest_uvcb->header.cmd);

"Unexpected notification intercept for UVC 0x%x"

?

> +		return 0;
> +	}
> +	rc = gmap_make_secure(vcpu->arch.gmap, uvcb.gaddr, &uvcb);
> +	if (rc == -EINVAL)

Add a comment why?

> +		return 0;
> +	return rc;
> +}
> +
>  static int handle_pv_notification(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->arch.sie_block->ipa == 0xb210)
>  		return handle_pv_spx(vcpu);
>  	if (vcpu->arch.sie_block->ipa == 0xb220)
>  		return handle_pv_sclp(vcpu);
> +	if (vcpu->arch.sie_block->ipa == 0xb9a4)
> +		return handle_pv_uvc(vcpu);
>  
>  	return handle_instruction(vcpu);
>  }

