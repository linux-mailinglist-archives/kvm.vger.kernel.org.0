Return-Path: <kvm+bounces-65015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4167C98656
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 18:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4ECF134434B
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 17:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59556335BD5;
	Mon,  1 Dec 2025 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtnBOlWI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tI05RHFX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A027530E0D4
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764608522; cv=none; b=rD1uxf92c8XIvCncmNlXs5hNRy4jV/D646p1Rxk3XtHARlidV3EJqr3DKkGWYZRUblxOyODtOYvnjZAdUeJh/jJATBAzgCv5In5xj+l0qqdmsEs58zAwMtFVHJ41geS+rNoak4cdC6l8GGLLFmSMIoySeFiJ/Lab8OdXV69hdH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764608522; c=relaxed/simple;
	bh=VpIPbRntc0gtWeIyKFcOj0zvWIoHl3o4YpUW6G7xkxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8j9f1SC/1ZppxVnTDifyTCDPYjNOsQFpWbuchCdfNzAYEPdtdDhozQqOU8u03A6qlqeeZMvGSSkzKzk2TUDc1i1IQ3V/ADbEkAnm3z9WAjAoFrclI6Zki5F1vMcOA/f5Bg1RxCONOXMxHzoO5l6sx9Tv9RgrfrXncVMDcdQm78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtnBOlWI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tI05RHFX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764608518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lcWzxv/s0i/NZDIgXRoNrr5kB6YSS08kERnXz4VbwxQ=;
	b=EtnBOlWIL/zY5gIyaBWa9ripjNka7PIeuyvVKIXbNrdVzQGKhIPQB0LmcHjYptNXbnpOMg
	yfXMKDYtYroo8s9V8jV7d/ay1MNHzb4+zEIRxuSc6PvAFyJtL20hi20FIQL2Ue0P6nRoCA
	MILm8NW5hxwvoZsZFZyrM6GnJmetI1I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-WXSl6tlnNOyd2WTkJTL0HA-1; Mon, 01 Dec 2025 12:01:57 -0500
X-MC-Unique: WXSl6tlnNOyd2WTkJTL0HA-1
X-Mimecast-MFC-AGG-ID: WXSl6tlnNOyd2WTkJTL0HA_1764608516
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-640c4609713so5242370a12.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 09:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764608516; x=1765213316; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lcWzxv/s0i/NZDIgXRoNrr5kB6YSS08kERnXz4VbwxQ=;
        b=tI05RHFXNsN63J7etqVbyJRBfSC0+YzpMe/Ou8z35hB2W3Uv2sPQljENS2cRrOPj1N
         TI5B3JZq2uY/U6T1M1uhEDvge37EsgAA/egHlItzrUQAhrK1yzMrqE2Cr8p9qM6ovZor
         OkokmySD4B21pvfhTMcd3lDxuhkpLB0/13WQxuVArlmeh6W3cg/pYh+tVR5lpsPfjmYY
         b/Xc01n6RWTI+Rd3T5X7NgS3kwoFQIcuMRwYOgljLDYI1zKYdERRXSkuJF3lBta6TBYD
         6zMmkRARMeC2CPQEoUutDzj8gCTDxtoAm4Mumi4twtZCz7C2tqc7cfOInndemAfeSggA
         iS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764608516; x=1765213316;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lcWzxv/s0i/NZDIgXRoNrr5kB6YSS08kERnXz4VbwxQ=;
        b=HfTNqzXFtGfA1bqUbfZvpp8JgEYNX40i3/InHK9k/WXk3V3DFOLF4mQR0AYtcDpXZc
         3oydqS/FB2kZ0+wMEggSIRU0sUIX5M1eYlm/DIrfJVKFxunQ5DxMTxRRYx0xjJEK1iXY
         9lcERltp42EY5fGtdslibmMGRm0lybHX68udM/gKBy5KIY440dTcfQhVUb96++aViXAg
         tS308D1BbBGL+NvpMkZvP9clR8JG1aKc6ZD+AyfVsvILuUeGnwjy7jHaqKKvjAKcbX0I
         MSfLi0oqyWxAVMu3D/n6r5c/zlQBHXVgVpU24nQxn0Pd5wpnresW1x8SmcbpxBDl4tt9
         VPbw==
X-Forwarded-Encrypted: i=1; AJvYcCVbJyJC+62GZuyVfHPN13pPZTLo+BcvVReo7endr9Et8KRk4kbk5biYAJQZ9y2NKa1qopk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx1opCajkRvF8WHnjip+fDqF0uvewZD7mwh9Bj9LfdeEtx3aBz
	EZQLkCzXGw1YbSmuhzGeAOKW0fvaC0Xs0NM4XFj2cb1F38Us3xEoh3m3NKJ3HDzLaeEuTHc0xh3
	f5ZqlCl0a4yZrzOfGU5gbu4yncS3TArv3WFHvgbxewMybzrcYHI0ZWg==
X-Gm-Gg: ASbGncs7sZvfknI7sADzeeY+KFKoncEKwJyu5IF+MA6uqCFPyP94uN+gqmDjm45Yez2
	V7MMZzU1FuM5RdQ8mHmgYn+VQWlprxmm/4s5w83N5KQbUMhs2XS3x1Ljb3t1G9HExHk/3VGxcyX
	YGYDHusrg0Aa/bExfn7N9Ti2sgi6jHjrgezU0QxV+YpqWWezmqnYfIByiqvnXQyszMeUhC+azIi
	nwy0HxvjWvBmcmwYiSaHcpxV8GVOtX0XDsZsZDgQPF9eDlS79A1LzbPkhnVBOzWKvTdrfWOgqsB
	3die5KC4ERHVnLeQiPWO31sKNOI2M7p+oYHay5/I1Q1ivyhGkMIwzwirn2OJhCGBtE4pjEv2Cis
	8/Kpy7HOOZrXyl7ywT3NJfq0/09zfsK0YzI+cz3o+EXnEiEm3cOvj1zc3yNWfVAG7ZQx0mucAVo
	SPEFSUiwoLy0nEpsw=
X-Received: by 2002:a17:907:7e9e:b0:b71:1420:334b with SMTP id a640c23a62f3a-b76c546da4bmr2475550266b.8.1764608514147;
        Mon, 01 Dec 2025 09:01:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESMffEF++MlIevqwJYsJiZlsygB4BU5rkZZxsHpfBL3PRwP9k4oL7Q7EeDqjABSeuuWqmTJg==
X-Received: by 2002:a17:907:7e9e:b0:b71:1420:334b with SMTP id a640c23a62f3a-b76c546da4bmr2475537666b.8.1764608512928;
        Mon, 01 Dec 2025 09:01:52 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b76f519d883sm1261396466b.17.2025.12.01.09.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 09:01:52 -0800 (PST)
Message-ID: <3103289d-e86c-486d-a3c0-95d7615099c6@redhat.com>
Date: Mon, 1 Dec 2025 18:01:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/23] i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and
 CET-SHSTK
To: Zhao Liu <zhao1.liu@intel.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, Xin Li <xin@zytor.com>, John Allen
 <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>,
 Zide Chen <zide.chen@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
 <20251118034231.704240-18-zhao1.liu@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251118034231.704240-18-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/25 04:42, Zhao Liu wrote:
> From: "Xin Li (Intel)" <xin@zytor.com>
> 
> Both FRED and CET-SHSTK need MSR_IA32_PL0_SSP, so add the vmstate for
> this MSR.
> 
> When CET-SHSTK is not supported, MSR_IA32_PL0_SSP keeps accessible, but
> its value doesn't take effect. Therefore, treat this vmstate as a
> subsection rather than a fix for the previous FRED vmstate.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes Since v3:
>   - New commit.
> ---
>   target/i386/machine.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 45b7cea80aa7..0a756573b6cd 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -1668,6 +1668,31 @@ static const VMStateDescription vmstate_triple_fault = {
>       }
>   };
>   
> +static bool pl0_ssp_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +#ifdef TARGET_X86_64
> +    if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
> +        return true;
> +    }
> +#endif
> +
> +    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);

Can you just make it return "!!(env->pl0_ssp)"?  If all of these bits 
are zero the MSR will not be settable, and this way you can migrate VMs 
as long as they don't use PL0_SSP.

Paolo


