Return-Path: <kvm+bounces-2444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5CF7F7898
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 17:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4794B1C2090D
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 16:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9C733CEF;
	Fri, 24 Nov 2023 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2h0N/uZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB141998
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700842126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fDHUw944JuBDjccgWURYSTGVRnttpEGwcc0SxiiIiWE=;
	b=Z2h0N/uZGSkhQ8YjDLXesIa5s3zBy0ex9pGq0FwOqobnu6MKjXnaVmFGD4lN+dUtCSjQUR
	F4whcFYZ07ZGQs33XSH5f1llhBJLg5eFJqvfmqJxaUOUb1c7PPNykmrt500f9LyB9kBShN
	yptg1TL+/TMvAvO/2cau9f50x4KCWNY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-f3v5Q_KXMXWuQI1JE6kIRA-1; Fri, 24 Nov 2023 11:08:45 -0500
X-MC-Unique: f3v5Q_KXMXWuQI1JE6kIRA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67a0bbe3eaaso13387666d6.3
        for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700842125; x=1701446925;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fDHUw944JuBDjccgWURYSTGVRnttpEGwcc0SxiiIiWE=;
        b=kUF4MyPKiXHdluZANjbKP9F2wgJoYQlTNKbW00g6QrpBiR6NXcN/MWeGUey+qHiWIS
         HsJquDHBOT9J8xodRxZc4JdqZnXGkBZcWTilE4kt4i30/c/RCF5IhL+LjPTkXSDk/0Xc
         cvbBSutjaJvXGL+yEFSIfHyr6mT20RODO6RVCmI5cGvtv2l9FQC9T7Ur68IaZPSQuwrC
         8eEhi62IqydJQ5mFjUBF8/sZYbbkRzeErLzUKNI80cmKVxSuws1bykNxKvn0IPU7em+0
         bG4LhXbUgxvb2e+Q1Ff9CvaZbZbXNqNoXverEhQeyv7Q6Wja/7bMTBEZ0JKQPQl2rWiL
         hKvQ==
X-Gm-Message-State: AOJu0YzkRlNRR/44B0ChfxaQDwK28mNorSNYuVQyT/zq3DUNee+NeU4d
	0oMKbBzYoMR4JPP03GfJscFJyHp9sFjHwwus+BfwpkvJtPafyvayCcSQSiCfqYh2epVBZydfYrB
	U1u6dzIo3ZGyB
X-Received: by 2002:a05:6214:2d12:b0:67a:46:5da8 with SMTP id mz18-20020a0562142d1200b0067a00465da8mr3813714qvb.58.1700842125257;
        Fri, 24 Nov 2023 08:08:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3MtL/Od4S13LcBLlGcA6LFuOswzvfoIpjOoiey6zb636OkL8bkCVK8DKaVAQZR1N9sPY2sw==
X-Received: by 2002:a05:6214:2d12:b0:67a:46:5da8 with SMTP id mz18-20020a0562142d1200b0067a00465da8mr3813692qvb.58.1700842125011;
        Fri, 24 Nov 2023 08:08:45 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p15-20020ad451cf000000b0067a1cf7737bsm333015qvq.130.2023.11.24.08.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 08:08:43 -0800 (PST)
Message-ID: <cc65a15b-b8cc-4119-b5a2-ee487f7aaaef@redhat.com>
Date: Fri, 24 Nov 2023 17:08:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] KVM: x86: add information about pending requests
 to kvm_exit tracepoint
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
 <20230928103640.78453-4-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20230928103640.78453-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/23 12:36, Maxim Levitsky wrote:
> This allows to gather information on how often kvm interrupts vCPUs due
> to specific requests.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/trace.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 28e8a63368cc02..e275a02a21e523 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -316,12 +316,14 @@ TRACE_EVENT(name,							     \
>   		__field(	u32,	        intr_info	)	     \
>   		__field(	u32,	        error_code	)	     \
>   		__field(	unsigned int,	vcpu_id         )	     \
> +		__field(	u64,		requests        )	     \
>   	),								     \
>   									     \
>   	TP_fast_assign(							     \
>   		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
>   		__entry->isa            = isa;				     \
>   		__entry->vcpu_id        = vcpu->vcpu_id;		     \
> +		__entry->requests       = READ_ONCE(vcpu->requests);	     \
>   		static_call(kvm_x86_get_exit_info)(vcpu,		     \
>   					  &__entry->exit_reason,	     \
>   					  &__entry->info1,		     \
> @@ -331,11 +333,13 @@ TRACE_EVENT(name,							     \
>   	),								     \
>   									     \
>   	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
> -		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
> +		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "      \
> +		  "requests 0x%016llx",					     \
>   		  __entry->vcpu_id,					     \
>   		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
>   		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
> -		  __entry->intr_info, __entry->error_code)		     \
> +		  __entry->intr_info, __entry->error_code, 		     \
> +		  __entry->requests)					     \
>   )
>   
>   /*

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


