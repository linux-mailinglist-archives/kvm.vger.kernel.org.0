Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0876E455AE9
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbhKRLwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:52:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344103AbhKRLvn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 06:51:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637236122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVvMJWrJ9UKr+oYWnQ3asuZNYNYkBhWlbJlX4He2Ums=;
        b=LDjPy0L4hJ7fAGL/FA0S3JJCCN3yNn0JylNRJFIt7Gp0xpRU851ugDs0cGWE+ruA+JmvAZ
        kuRwGFXs3aixBBWaTCxIoTZMMd79Zguy00xE+uknOcKGNRPkZTDm0Rvh6fiUzazqITcApD
        q4PcSchqCbvz30xhRfIU5fwur92wG4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-zvgDP5ZjNYa2lSvL9U8ZAg-1; Thu, 18 Nov 2021 06:48:37 -0500
X-MC-Unique: zvgDP5ZjNYa2lSvL9U8ZAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A9B804141;
        Thu, 18 Nov 2021 11:48:35 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1452A10246F8;
        Thu, 18 Nov 2021 11:48:30 +0000 (UTC)
Message-ID: <a130e317-58b9-dae8-2d87-98695cdc4f22@redhat.com>
Date:   Thu, 18 Nov 2021 12:48:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Fix SEV-ES INS/OUTS instructions for word, dword, and
 qword.
Content-Language: en-US
To:     Michael Sterritt <sterritt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-coco@lists.linux.dev
Cc:     marcorr@google.com, pgonda@google.com
References: <20211118021326.4134850-1-sterritt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118021326.4134850-1-sterritt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 03:13, Michael Sterritt wrote:
> Properly type the operands being passed to __put_user()/__get_user().
> Otherwise, these routines truncate data for dependent instructions
> (e.g., INSW) and only read/write one byte.
> 
> Tested: Tested by sending a string with `REP OUTSW` to a port and then
> reading it back in with `REP INSW` on the same port. Previous behavior
> was to only send and receive the first char of the size. For example,
> word operations for "abcd" would only read/write "ac". With change, the
> full string is now written and read back.
> 
> Signed-off-by: Michael Sterritt <sterritt@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Gonda <pgonda@google.com>
> ---
>   arch/x86/kernel/sev.c | 57 +++++++++++++++++++++++++++++--------------
>   1 file changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 74f0ec955384..a9fc2ac7a8bd 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -294,11 +294,6 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
>   				   char *dst, char *buf, size_t size)
>   {
>   	unsigned long error_code = X86_PF_PROT | X86_PF_WRITE;
> -	char __user *target = (char __user *)dst;
> -	u64 d8;
> -	u32 d4;
> -	u16 d2;
> -	u8  d1;
>   
>   	/*
>   	 * This function uses __put_user() independent of whether kernel or user
> @@ -320,26 +315,42 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
>   	 * instructions here would cause infinite nesting.
>   	 */
>   	switch (size) {
> -	case 1:
> +	case 1: {
> +		u8 d1;
> +		u8 __user *target = (u8 __user *)dst;
> +
>   		memcpy(&d1, buf, 1);
>   		if (__put_user(d1, target))
>   			goto fault;
>   		break;
> -	case 2:
> +	}
> +	case 2: {
> +		u16 d2;
> +		u16 __user *target = (u16 __user *)dst;
> +
>   		memcpy(&d2, buf, 2);
>   		if (__put_user(d2, target))
>   			goto fault;
>   		break;
> -	case 4:
> +	}
> +	case 4: {
> +		u32 d4;
> +		u32 __user *target = (u32 __user *)dst;
> +
>   		memcpy(&d4, buf, 4);
>   		if (__put_user(d4, target))
>   			goto fault;
>   		break;
> -	case 8:
> +	}
> +	case 8: {
> +		u64 d8;
> +		u64 __user *target = (u64 __user *)dst;
> +
>   		memcpy(&d8, buf, 8);
>   		if (__put_user(d8, target))
>   			goto fault;
>   		break;
> +	}
>   	default:
>   		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
>   		return ES_UNSUPPORTED;
> @@ -362,11 +373,6 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>   				  char *src, char *buf, size_t size)
>   {
>   	unsigned long error_code = X86_PF_PROT;
> -	char __user *s = (char __user *)src;
> -	u64 d8;
> -	u32 d4;
> -	u16 d2;
> -	u8  d1;
>   
>   	/*
>   	 * This function uses __get_user() independent of whether kernel or user
> @@ -388,26 +394,41 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>   	 * instructions here would cause infinite nesting.
>   	 */
>   	switch (size) {
> -	case 1:
> +	case 1: {
> +		u8 d1;
> +		u8 __user *s = (u8 __user *)src;
> +
>   		if (__get_user(d1, s))
>   			goto fault;
>   		memcpy(buf, &d1, 1);
>   		break;
> -	case 2:
> +	}
> +	case 2: {
> +		u16 d2;
> +		u16 __user *s = (u16 __user *)src;
> +
>   		if (__get_user(d2, s))
>   			goto fault;
>   		memcpy(buf, &d2, 2);
>   		break;
> -	case 4:
> +	}
> +	case 4: {
> +		u32 d4;
> +		u32 __user *s = (u32 __user *)src;
> +
>   		if (__get_user(d4, s))
>   			goto fault;
>   		memcpy(buf, &d4, 4);
>   		break;
> -	case 8:
> +	}
> +	case 8: {
> +		u64 d8;
> +		u64 __user *s = (u64 __user *)src;
>   		if (__get_user(d8, s))
>   			goto fault;
>   		memcpy(buf, &d8, 8);
>   		break;
> +	}
>   	default:
>   		WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
>   		return ES_UNSUPPORTED;
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

