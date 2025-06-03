Return-Path: <kvm+bounces-48295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF0EACC61D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 14:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51F031886EB8
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 12:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D8422F763;
	Tue,  3 Jun 2025 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DYeJHmJP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334922DA08
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748952246; cv=none; b=fwyJ/XHIiAJIBLyeHcI8dcPqVHKRGkt54Yl+3bQjibNS2aNAWtVQloalr8MDz5Ag/XgWkYPQ16MdIWikYFNNgmRpEpo1JBpVxmAuuY6b2XhzjELY4zB8pslv7AabPCwd33pp4DRxxqg9wKG3xS4t5sdr+4fHCHKcCQswEypn+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748952246; c=relaxed/simple;
	bh=eKVE11jLj8lDyZOQhotMaEk97jjBKUbpiusFQCUvx/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INXHWUqiHwJauEewSpm6WqiPGSSkh3qR3cFTuayUqAJDvTMFJQLUm6AdGEnSiCViG9RowULQex6nhfmYk6VOpUMT7BuMnjZK4b5eQGxlueswLaCCvCVKPm9h6IWAYjpKKESkd9Fga4jg8aN6MlbbQc3qT0XAcSpqHNxEtadly3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DYeJHmJP; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad55d6aeb07so858389066b.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1748952243; x=1749557043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HDZ21hWlWv1x+o04xchdKXVEcwFizZSvZru6Ba/BmlI=;
        b=DYeJHmJPH0IXSvhbBmDnvKnfmFAedWZTkv7JGS+TDGE2AWHD0quGjVWauKouV/DerI
         DAR8YDirmFD4BMNhUxoJ2xyg4FC6b5vp7c0yuHzbYWLlPbjLf189hSx+0/3n3nonYF87
         qKdvIwIGBLTpfDoG+fg4CHg8jRATbNUjDmAL8OeDOLKl1ex4COqBRqkmUM4Z7qxIa5hP
         rMiCu+7zIjQEAN/hCbZLwVzmPDxxi8/XuHEiA8SXbU0Pq0K76RMBwzEd7QU1Kn8+NRC4
         5g1pPVZZuzF4QQumHUlNNh+lTJM26/aj1Popfm2iz7tHRgoWoMBkjWsg1SRtF3gV+/iZ
         z6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748952243; x=1749557043;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HDZ21hWlWv1x+o04xchdKXVEcwFizZSvZru6Ba/BmlI=;
        b=f9QBk03T8wIhlVZPPZLBBu10fO2i6fwNdkmiHf5kPAcgl0wkIxWnmD9KFNkMBz4+oI
         SDwqSGST1uq4Tlgkk+vCdniLIMiQEekAJa+D1hIUiBoPNYKdB8Xzb8IP1hGefbFlHGrY
         yFYJPN8kXUl07bMRZUBW3QayCPGyIp8oOOXh4IFK+GiKKmyQUxCR22S/wFChq0bwk+G3
         q4+xDUO07gD7821EsQscsrTY2Diw9X6CFcvVtojhVh9XXT5fuuPQ9ZC2OkE0UaWnogFT
         TLrYUEMFvGOnbPZ6UYKkIF/q4Xr756j3GHdhvqeMvTtyOpYmHUiaP6aFS4GOdAovBV97
         C33Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRS5d1h9vkiVkg/C3UZCZXE1sGbkSj3hh6LL7zTq3i6HtVGaYx70FDExzqZRJ0yXc9eHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKWTwblnO3jK1TBTJBF3qNS9u0U9vTDnnDzcaSOYm3IyoKG3Ut
	Tm5tEGjJSAlc7ba07DA3x0fbJkbvOYs0898hiM8N8c2Kus5tub50JyrCoZCc62lgwAw=
X-Gm-Gg: ASbGncsHQjLTm36ue6gVfv6k1fAuxZj/6nhMJETy2O5NcxeZaJufFYZs2ndpvtwrex3
	po3ZS3eU0SUqsKZreGxHey5bEhvTzDTw7C2Iv7lwBauQt6wyS67AnXTWVN0Hgs4CbwP+Dkx0S9+
	x5zmFXz/6yFFtlfhNQMm3Zekaue0/sVRhG0lBhwIHmHBq5uALY7k+X5GIw9ApBGaGC0AYMaE5b1
	0pjSjwfH9CTaoDvxftUG18Nl+V71tjuRpz4YgxCYeIilBHaAq2yK5agTs3jXE1YpARp1K2Ikl6K
	hNEWxOo0miKnhlKwcv7wWPN/IdWsiGJpAOsPyHP037Eb/PJk04K5ritY
X-Google-Smtp-Source: AGHT+IFdRpQTjbCVEAc5nDVoTookmyFz0UYQ5bCgOGFgKVeZAWQ8RM/2i+LzJ8MkDBkj3RKJ8+7qOQ==
X-Received: by 2002:a17:907:6eac:b0:ad5:3156:2c06 with SMTP id a640c23a62f3a-adb36be2f5emr1647258866b.28.1748952242835;
        Tue, 03 Jun 2025 05:04:02 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.159.167])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adb34881d45sm753497466b.128.2025.06.03.05.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 05:04:02 -0700 (PDT)
Message-ID: <a845370c-a1f0-4d02-9144-f199ca845d59@suse.com>
Date: Tue, 3 Jun 2025 15:04:00 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 11/20] x86/virt/seamldr: Abort updates if errors
 occurred midway
To: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
 x86@kernel.org, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, eddie.dong@intel.com,
 kirill.shutemov@intel.com, dave.hansen@intel.com, dan.j.williams@intel.com,
 kai.huang@intel.com, isaku.yamahata@intel.com, elena.reshetova@intel.com,
 rick.p.edgecombe@intel.com, Farrah Chen <farrah.chen@intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-12-chao.gao@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20250523095322.88774-12-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/25 12:52, Chao Gao wrote:
> The update process is divided into multiple stages, each of which may
> encounter failures. However, the current state machine for updates proceeds
> to the next stage regardless of errors.
> 
> Continuing updates when errors occur midway is pointless.
> 
> Implement a mechanism that transitions directly to the final stage,
> effectively aborting the update and skipping all remaining stages when an
> error is detected.
> 
> This is in preparation for adding the first stage that may fail.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/seamldr.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
> index 01dc2b0bc4a5..9d0d37a92bfd 100644
> --- a/arch/x86/virt/vmx/tdx/seamldr.c
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -247,6 +247,7 @@ enum tdp_state {
>   static struct {
>   	enum tdp_state state;
>   	atomic_t thread_ack;
> +	atomic_t failed;
>   } tdp_data;
>   
>   static void set_state(enum tdp_state state)
> @@ -261,8 +262,16 @@ static void set_state(enum tdp_state state)
>   /* Last one to ack a state moves to the next state. */
>   static void ack_state(void)
>   {
> -	if (atomic_dec_and_test(&tdp_data.thread_ack))
> -		set_state(tdp_data.state + 1);
> +	if (atomic_dec_and_test(&tdp_data.thread_ack)) {
> +		/*
> +		 * If an error occurred, abort the update by skipping to
> +		 * the final state
> +		 */
> +		if (atomic_read(&tdp_data.failed))
> +			set_state(TDP_DONE);
> +		else
> +			set_state(tdp_data.state + 1);
> +	}
>   }
>   
>   /*
> @@ -285,6 +294,9 @@ static int do_seamldr_install_module(void *params)
>   			default:
>   				break;
>   			}
> +
> +			if (ret)
> +				atomic_inc(&tdp_data.failed);

Should there be some explicit ordering requirement between setting an 
error and reading it in ack_state by a different CPU?


  < snip>


