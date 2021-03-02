Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42932A6E6
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837218AbhCBPyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577056AbhCBFjS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 00:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614663469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r35kuAzNpgRSS60OOwIr83hMJJPeAqcPh7Z3M+Sj8as=;
        b=SFEGfv6+GciTU0ik7MKfZcIKSkZNiKwQnQH7jb+/voWrdZVr2907KrYjrysRVt6BbkuEVg
        twU57CoTOrXbdHeU1xqYcAEvsoppjPGJo9Ga5kxhZh7lddTXyKcPYBXPdYlhDjKqa0lo8c
        V0YMMSI/0CIoNOBmJyzoJiqIaiR0GWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-BuoTzVihNG-aVKf0NiwJyA-1; Tue, 02 Mar 2021 00:37:47 -0500
X-MC-Unique: BuoTzVihNG-aVKf0NiwJyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D4B0107ACE3;
        Tue,  2 Mar 2021 05:37:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-57.ams2.redhat.com [10.36.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F90060BFA;
        Tue,  2 Mar 2021 05:37:41 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: introduce leave_pstate to
 leave userspace
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210301182830.478145-1-imbrenda@linux.ibm.com>
 <20210301182830.478145-2-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <afadec9c-e6f3-b807-8557-8a76b4525900@redhat.com>
Date:   Tue, 2 Mar 2021 06:37:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210301182830.478145-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/03/2021 19.28, Claudio Imbrenda wrote:
> In most testcases, we enter problem state (userspace) just to test if a
> privileged instruction causes a fault. In some cases, though, we need
> to test if an instruction works properly in userspace. This means that
> we do not expect a fault, and we need an orderly way to leave problem
> state afterwards.
> 
> This patch introduces a simple system based on the SVC instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  7 +++++++
>   lib/s390x/interrupt.c    | 12 ++++++++++--
>   2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 9c4e330a..4cf8eb11 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -173,6 +173,8 @@ struct cpuid {
>   	uint64_t reserved : 15;
>   };
>   
> +#define SVC_LEAVE_PSTATE 1
> +
>   static inline unsigned short stap(void)
>   {
>   	unsigned short cpu_address;
> @@ -276,6 +278,11 @@ static inline void enter_pstate(void)
>   	load_psw_mask(mask);
>   }
>   
> +static inline void leave_pstate(void)
> +{
> +	asm volatile("	svc %0\n" : : "i" (SVC_LEAVE_PSTATE));
> +}
> +
>   static inline int stsi(void *addr, int fc, int sel1, int sel2)
>   {
>   	register int r0 asm("0") = (fc << 28) | sel1;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1ce36073..d0567845 100644
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
> +	case SVC_LEAVE_PSTATE:
> +		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		break;
> +	default:
> +		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
> +			      code, stap(), lc->svc_old_psw.addr);
> +	}
>   }
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

