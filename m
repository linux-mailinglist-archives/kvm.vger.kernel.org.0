Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28B22FA460
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390423AbhARPR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 10:17:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405636AbhARPRS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 10:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qw4bLrauxaYv+NU5WthB52Dg6DmZkhc0QbWly8U7Svs=;
        b=Gpjs+Mn3CbugE+tjmfrUCQyCh6s+0vsaOj9xEzf9td9ywcP11SvhBbMW5ndSHcSN8/LKYn
        86WFGA+PH0OaIGmq2AvVZu8LGqjSu8c3nsNpPm1X/+fwiijx+gfsPOj+oL6UDDWqvrW12h
        +jIiBxk/Wg/uG4PokLjzSSGj+suHPFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-ixxU3zWyOc-HvZ9eBQiEBA-1; Mon, 18 Jan 2021 10:15:50 -0500
X-MC-Unique: ixxU3zWyOc-HvZ9eBQiEBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1778D806664;
        Mon, 18 Jan 2021 15:15:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B667C60622;
        Mon, 18 Jan 2021 15:15:44 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Fix uv_call() exception behavior
To:     Janosch Frank <frankja@linux.ibm.com>, KVM <kvm@vger.kernel.org>
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210118140344.3074-1-frankja@linux.ibm.com>
 <20210118150922.5229-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <d876410c-fd7b-5fb8-1f9e-d3a13e9f44c3@redhat.com>
Date:   Mon, 18 Jan 2021 16:15:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118150922.5229-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 16.09, Janosch Frank wrote:
> On a program exception we usually skip the instruction that caused the
> exception and continue. That won't work for UV calls since a "brc
> 3,0b" will retry the instruction if the CC is > 1. Let's forgo the brc
> when checking for privilege exceptions and use a uv_call_once().
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> ---
>   lib/s390x/asm/uv.h | 24 ++++++++++++++++--------
>   s390x/uv-guest.c   |  6 +++---
>   2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 4c2fc48..39d2dc0 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -50,19 +50,12 @@ struct uv_cb_share {
>   	u64 reserved28;
>   } __attribute__((packed))  __attribute__((aligned(8)));
>   
> -static inline int uv_call(unsigned long r1, unsigned long r2)
> +static inline int uv_call_once(unsigned long r1, unsigned long r2)
>   {
>   	int cc;
>   
> -	/*
> -	 * The brc instruction will take care of the cc 2/3 case where
> -	 * we need to continue the execution because we were
> -	 * interrupted. The inline assembly will only return on
> -	 * success/error i.e. cc 0/1.
> -	*/
>   	asm volatile(
>   		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> -		"		brc	3,0b\n"
>   		"		ipm	%[cc]\n"
>   		"		srl	%[cc],28\n"
>   		: [cc] "=d" (cc)
> @@ -71,4 +64,19 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>   	return cc;
>   }
>   
> +static inline int uv_call(unsigned long r1, unsigned long r2)
> +{
> +	int cc;
> +
> +	/*
> +	 * CC 2 and 3 tell us to re-execute because the instruction
> +	 * hasn't yet finished.
> +	 */
> +	do {
> +		cc = uv_call_once(r1, r2);
> +	} while (cc > 1);
> +
> +	return cc;
> +}
> +
>   #endif
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index d47333e..091a19b 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -31,7 +31,7 @@ static void test_priv(void)
>   	uvcb.len = sizeof(struct uv_cb_qui);
>   	expect_pgm_int();
>   	enter_pstate();
> -	uv_call(0, (u64)&uvcb);
> +	uv_call_once(0, (u64)&uvcb);
>   	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>   	report_prefix_pop();
>   
> @@ -40,7 +40,7 @@ static void test_priv(void)
>   	uvcb.len = sizeof(struct uv_cb_share);
>   	expect_pgm_int();
>   	enter_pstate();
> -	uv_call(0, (u64)&uvcb);
> +	uv_call_once(0, (u64)&uvcb);
>   	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>   	report_prefix_pop();
>   
> @@ -49,7 +49,7 @@ static void test_priv(void)
>   	uvcb.len = sizeof(struct uv_cb_share);
>   	expect_pgm_int();
>   	enter_pstate();
> -	uv_call(0, (u64)&uvcb);
> +	uv_call_once(0, (u64)&uvcb);
>   	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>   	report_prefix_pop();

That looks nicer, indeed.

Reviewed-by: Thomas Huth <thuth@redhat.com>

