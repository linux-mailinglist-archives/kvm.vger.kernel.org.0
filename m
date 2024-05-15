Return-Path: <kvm+bounces-17451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 372268C6B84
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD2D41F235D8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90986745E7;
	Wed, 15 May 2024 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HXebnCtB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C2C4C3CD
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715794401; cv=none; b=IdX90VJ+lGNUbRkVcE3xDRSyEx+/PfNQ+408XGf08aGhc2lUwgImhlLEcJ2kYN1SYZ9fXbk5oNxtjm2HPMAC2XOQ7FZ6khxBdDDdKYE/EuHsEAy+xdbW/X2Ic92H/FomW8/RKuKwklxj83JiAoZDagKxBlVXvsE12I5CLwgQ9XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715794401; c=relaxed/simple;
	bh=KQ7vgtIHJ0lCY1+lYQaLcR526DvemfZD38rR0OBQSp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZN3MOE1sg0NA+TDaIvOagE8Y4i5XRkn7W60dv83WbMCUyBQwzsndze5ym9PB1QlM2BcfTmJ9JZmTxIiOzHqJNRdF9lj5ZQHUkTbxigV8u2dQpHETqVpEozs86RqIbBQLa4hfaU/gBq+KTwp3k5rxo7LPNPtor7gTWTvngGuNA2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HXebnCtB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715794397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LfUbT0bqMFevfxtZ83fq1OENBuxrXgJtBQk+DKSrhj8=;
	b=HXebnCtBqAbOpMjQP0jkMH6pqfR20DKuWjfUjcd+LA2+ErZ36yG1WsOnj6zxCp/9GfC7Fy
	bOBPCwHz0cU973voDf2rMqJa6VOGb1MG29VaKJt+t3jsTgFBHwRSKzTwojc9UNr6ioofT8
	y80KpiCOBYuBIn5WKZjHnsVZfkXtprQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-7pNnm7MEOx28S_2bYhjFHA-1; Wed, 15 May 2024 13:33:16 -0400
X-MC-Unique: 7pNnm7MEOx28S_2bYhjFHA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-41ffa918455so29118585e9.3
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 10:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715794395; x=1716399195;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LfUbT0bqMFevfxtZ83fq1OENBuxrXgJtBQk+DKSrhj8=;
        b=aac+GY8S3HP6SBA3g055dLL3h/FzUuUbmg1b8AVAUlITw4LYjFzVdjmdosH7QfvuDb
         yhWz16aZZMR3/Esvpa2yhU68WM55MHdKenHbPqOabhyex6IyMhlyS43QKCff9CozYb91
         kiGVOszpm0JNHMuam8xfNiTO6kH9C0cf9jwAM1fUKes/HZGPhAAQgoEXnYU7N0i/WZsr
         ac9gCCZ908jX86HP+4JdGrgXJFPCVKZ7Y5D0y4wWXkX88lNx2jfC8xJhdAiLahRmlSTR
         Q2Cx3u2eq5WW2zUIAZ7f7aLoffVcwlJYN5fbmPa9ZcTfgxDLOb8hcRE9Zc44URW/6miF
         pnVA==
X-Forwarded-Encrypted: i=1; AJvYcCW9vcTxjjcld7oBwWD6UbjIIMfc6mlWr238zzFrMdhPXNMlRzM4a7lBKrg1PILmtN2XZli/jNt11M7pXDxZSlE5Rc9D
X-Gm-Message-State: AOJu0YyEBd+iGo0Xf79x9slP7GEKDUKRDhl1Di5cPEb8hmU4GALoFBv3
	Sg+kj7GPYRlErIGEnEyZUfKIRpCIxCRPwUd4JrvPqWbzUmOGZSJUcJf2mj7dQpK43c+Oz78dJsi
	W5Q5TQGjIupX9gGGFUBJJGN6U4TEVCbqmK0PJeXJdAHMW+fSZvg==
X-Received: by 2002:a05:600c:a46:b0:41f:f144:5623 with SMTP id 5b1f17b1804b1-41ff1445732mr130137675e9.14.1715794394974;
        Wed, 15 May 2024 10:33:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEn29gC0xlHgiaGlcHKOXEBPkcWc5GqRKQ+sTlTUnbCHKlL078H8MP3ATQM4jwusDZdn2rlnw==
X-Received: by 2002:a05:600c:a46:b0:41f:f144:5623 with SMTP id 5b1f17b1804b1-41ff1445732mr130137545e9.14.1715794394619;
        Wed, 15 May 2024 10:33:14 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-41fccee92c7sm248384785e9.34.2024.05.15.10.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 10:33:14 -0700 (PDT)
Message-ID: <4d80cec1-9505-4a8c-8bd3-c996b5a42790@redhat.com>
Date: Wed, 15 May 2024 19:33:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, rick.p.edgecombe@intel.com
References: <20240507154459.3950778-1-pbonzini@redhat.com>
 <20240507154459.3950778-3-pbonzini@redhat.com>
 <20240515173209.GD168153@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20240515173209.GD168153@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 19:32, Isaku Yamahata wrote:
> Paolo, how do you want me to proceed? I can send a updated patch or you can
> directly fix the patch in kvm-coco-queue.  I'm fine with either way.

I'll fix it, thanks!

Paolo

> From 7910130c0a3f2c5d814d6f14d663b4b692a2c7e4 Mon Sep 17 00:00:00 2001
> Message-ID:<7910130c0a3f2c5d814d6f14d663b4b692a2c7e4.1715793643.git.isaku.yamahata@intel.com>
> From: Isaku Yamahata<isaku.yamahata@intel.com>
> Date: Wed, 15 May 2024 10:19:08 -0700
> Subject: [PATCH] fixup! KVM: x86/mmu: Replace hardcoded value 0 for the
>   initial value for SPTE
> 
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1259dd63defc..36539c1b36cd 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -626,7 +626,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * SPTEs.
>   	 */
>   	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			    0, iter->level, true);
> +			    SHADOW_NONPRESENT_VALUE, iter->level, true);
>   
>   	return 0;
>   }
> 
> base-commit: 698ca1e403579ca00e16a5b28ae4d576d9f1b20e



