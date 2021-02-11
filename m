Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9C63188CB
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBKK4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 05:56:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhBKKyJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 05:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613040762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8HThQPXUptMHzLx4V9Kjdirx0coF+DMARAihQm/C5mY=;
        b=HVvABBXj4Qte5uSurE7axwHxYNq3MhIAVRUtMX2/Akpt5V+7fLgCX74HWDvOfg+kkYPSoR
        5gYinLJa7vhRoLww2jMsAxjJ7p49cix1GMW3g7DkQU3n0RSyK97YTTDNanEaCDvfr7A3YH
        777DQ341Q5dwiG0Eq+m7Ymbc8XbfIHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-LXD2eLIYMluGNPlquGz46w-1; Thu, 11 Feb 2021 05:52:38 -0500
X-MC-Unique: LXD2eLIYMluGNPlquGz46w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 072DF91185;
        Thu, 11 Feb 2021 10:52:37 +0000 (UTC)
Received: from [10.36.114.52] (ovpn-114-52.ams2.redhat.com [10.36.114.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1096360C47;
        Thu, 11 Feb 2021 10:52:32 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: introduce leave_pstate to
 leave userspace
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
 <20210209185154.1037852-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <de6db9d1-d831-07d8-4721-93750add3b60@redhat.com>
Date:   Thu, 11 Feb 2021 11:52:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210209185154.1037852-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.02.21 19:51, Claudio Imbrenda wrote:
> In most testcases, we enter problem state (userspace) just to test if a
> privileged instruction causes a fault. In some cases, though, we need
> to test if an instruction works properly in userspace. This means that
> we do not expect a fault, and we need an orderly way to leave problem
> state afterwards.
> 
> This patch introduces a simple system based on the SVC instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  5 +++++
>   lib/s390x/interrupt.c    | 12 ++++++++++--
>   2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 9c4e330a..9902e9fe 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -276,6 +276,11 @@ static inline void enter_pstate(void)
>   	load_psw_mask(mask);
>   }
>   
> +static inline void leave_pstate(void)
> +{
> +	asm volatile("	svc 1\n");
> +}
> +
>   static inline int stsi(void *addr, int fc, int sel1, int sel2)
>   {
>   	register int r0 asm("0") = (fc << 28) | sel1;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1ce36073..59e01b1a 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -188,6 +188,14 @@ int unregister_io_int_func(void (*f)(void))
>   
>   void handle_svc_int(void)
>   {
> -	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
> -		     stap(), lc->svc_old_psw.addr);
> +	uint16_t code = lc->svc_int_code;
> +
> +	switch (code) {
> +	case 1:
> +		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		break;
> +	default:
> +		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
> +			      code, stap(), lc->svc_old_psw.addr);
> +	}
>   }
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

