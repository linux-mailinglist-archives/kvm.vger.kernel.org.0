Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAFC157DFE
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgBJO60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:58:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37427 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgBJO60 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 09:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581346705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Ai1/Z236VGvcSi9aos29tUsyKZUbyNytyfpikXX8Exg=;
        b=XiBf0dMx8AB+GSYvq4egmNykaWFCtgdpo4mCRb4oyLtlfl8bw7Q4A051AIRsX6gR/YXfEs
        //1MPcWyaHH7Orni0juiEf06Unql8VWV5QAkPXiNz7/w3XE/zXVK8zyAoDGnmxWYyx0C5k
        ax8k/VGFFNqliELXQ4DnZHW3208FAew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-hvbszyYqOYihSyIlykokpQ-1; Mon, 10 Feb 2020 09:58:21 -0500
X-MC-Unique: hvbszyYqOYihSyIlykokpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD4D21005510;
        Mon, 10 Feb 2020 14:58:19 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBB1E87B2F;
        Mon, 10 Feb 2020 14:58:12 +0000 (UTC)
Subject: Re: [PATCH 21/35] KVM: s390/mm: handle guest unpin events
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-22-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2fd5c392-a2b7-c6b8-f079-8b87ee60f65e@redhat.com>
Date:   Mon, 10 Feb 2020 15:58:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-22-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
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
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/intercept.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 2a966dc52611..e155389a4a66 100644
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
> +		.guest_handle	= kvm_s390_pv_handle(vcpu->kvm),
> +		.gaddr		= guest_uvcb->paddr,
> +	};
> +	int rc;
> +
> +	if (guest_uvcb->header.cmd != UVC_CMD_REMOVE_SHARED_ACCESS) {
> +		WARN_ONCE(1, "Unexpected UVC 0x%x!\n", guest_uvcb->header.cmd);

Is there a way to signal the failed command to the guest, too?

 Thomas


> +		return 0;
> +	}
> +	rc = uv_make_secure(vcpu->arch.gmap, uvcb.gaddr, &uvcb);
> +	if (rc == -EINVAL && uvcb.header.rc == 0x104)
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
> 

