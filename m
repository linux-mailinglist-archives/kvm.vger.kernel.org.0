Return-Path: <kvm+bounces-52726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CF4B08911
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31C6D188D065
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD3288CBD;
	Thu, 17 Jul 2025 09:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bZW29Qwf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8F4286D79
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743695; cv=none; b=SzQp2l4G3ZFOgBWRKdvNIhxVOgGgrEPrkxqQctFmYCKHGS6Wf2uJnVnIiV/KNlt5TQIurSw/eJQ+izrukOKNgeDQQZqrK7cEgYRYx8kzxDWzltwULI02eHXoaUImp+RKJgfu9esBcpqHX9w3A0jJ0qkt0epKFrac04sXaD2CxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743695; c=relaxed/simple;
	bh=5FUJ1ODXykL1dBKSpMRvaSvysoeEX1Nqlm3DE0Otw8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnZieyM88rCnyRA8l2y3n4qn2H3oK2+V1a5TXM4K1Bt8fVb6SV5MmfXI51ccPv5uc9Sf2sCe6mp9NfyIQ6mSDdyiEPNHXNjQTOYPvwSp2A/T+f9M/hKhp+jqliqPEK+aWt8hTwn8Y/roA4oemNlBpijMa3/FIZ/66PpgSw7yAlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bZW29Qwf; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae3b336e936so138451866b.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 02:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752743690; x=1753348490; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qvF3zOb5xSpb1Uxmw4UNSSWpqvIymBAoaxDK8LkmqYY=;
        b=bZW29Qwfn1HYSAuZOhBeqi+N9oj/dVBKrir4eHT+yUg6wT6L5YmOXuz461AKd6+a7/
         lajShHBLvv2p0bcstJQ+bX/+PjxuGnK4sDo5sjcnmG3U/fCqXJmuXHyyVXXJf6jGr/2x
         oAXwifZX0dHEqDW+Y5+hj/zWSjLCnwmrGZZXzYkwqMk71LM9S+r7kIw8W0JJPP437Mdy
         ukybpxS3+RyUXpwvnbA0SBf2gV7/8ZVqcvjxsoxxlVPap3VE7mV3vGnm8Ni6Al0EmpYd
         dgyDkdIjr2Gqd5DjI+MG9x6xSyBEFVQFtEBJIsqssxPf7veepX0MVn1Jeea1sopYNXIx
         0MYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752743690; x=1753348490;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvF3zOb5xSpb1Uxmw4UNSSWpqvIymBAoaxDK8LkmqYY=;
        b=mnjZs7r7GQkB45lvf9YYmS7Vn5DevefhnVHjSB3GInlqONknD62t04YaQ36sXgd9SJ
         eeM+ZTaeYi+72oo8PSvFui35yVF0jLM01QVU8UPDoCAfRW1veIEB+KPAajAYNhrK8bMg
         w7PN7K6vbGREgStKArH8LZ1CL8wTtGDmGB5w97e0UVGJlFuSzPC9TSCX++AHNDnF7LPI
         Sbx3BoSoXmSRAYE2RGG1X4dHeCAUTJplILdMKD8Mj9FkVcj+n2Edc01AtiOj86n8OziZ
         BIv4IDKagrD9tLm7S7Sze9Sl1x+hz/p/aSguQYsSRg42r8IJogzJe3ylIqgyAs4IstPw
         NwRA==
X-Forwarded-Encrypted: i=1; AJvYcCWBhX0Vhbcy/aL3ThBeHs5OvDX5eQQCn/1r2Hhi/FGLWhdrrGJ2UHobTalCGG7xREAWzWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSwd1FvfYJMxeaVbkNH3INAid3QC93EtcChcBSMkl+pb5c6jKm
	8p2Yk9lbFDAUaotriI8XCTNxhCnCiR0nX3H2tykJoisO7ad1NHMQyaU12G2pq3pLNFI=
X-Gm-Gg: ASbGncuBUv/9EcP5u0gmzp1/Gk9ZWMTl1OqWkMLr0YzBnnkuDKj09QRRhCm8Dwah6gv
	JOlfvbbbWpi2/RwEH/4hV4pKGCBD0fWNEuwX8KCznFpeFRwqolYmKaxtV8DeDxmj+zl/OwxLs7s
	tVqojnFfLlS3Uv2boWeD2nEKbQYOVxT0bdafpVxoLgcfcCYTjlIZUbP/kqzG56G9DP2a9VrJTr/
	1wZiC+uj+Kr518HntN4qQmm95a+sKTUI/vDf1H9PswfySqV1ujKdIlPGGMnwbXp0Md81yf/IHfJ
	pqSGH18T+RbePLVovcCctwAsP5ye2QUDGicYxxw0/ymSx+Hxij0g0m2G25hbE3QtDcLMlsc9Mp1
	r+a4b9EAF5rjYqn4C+J+w0vWmpy//9a5YNfrJ
X-Google-Smtp-Source: AGHT+IEnD/7R/2gqsCpLAcNMPV3t2q2FnJZCaxlABMRQi65QpmoSs4DiQ6mxeDbvEffx+/eNFV0Nbg==
X-Received: by 2002:a17:906:f049:b0:ae0:cc3d:7929 with SMTP id a640c23a62f3a-ae9cdd861c1mr523581866b.1.1752743689884;
        Thu, 17 Jul 2025 02:14:49 -0700 (PDT)
Received: from [10.20.4.146] ([149.62.209.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e82964a9sm1336344566b.141.2025.07.17.02.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 02:14:49 -0700 (PDT)
Message-ID: <60d4e55c-2a4f-44b4-9c93-fab97938a19c@suse.com>
Date: Thu, 17 Jul 2025 12:14:46 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com>
 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <aHEdg0jQp7xkOJp5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.07.25 г. 17:19 ч., Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Xiaoyao Li wrote:
>> On 7/11/2025 9:05 PM, Sean Christopherson wrote:
>>> On Fri, Jul 11, 2025, Xiaoyao Li wrote:
>>>> On 6/26/2025 11:58 PM, Sean Christopherson wrote:
>>>>> On Wed, Jun 25, 2025, Sean Christopherson wrote:
>>>>>> On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
>>>>>>> Changes in V4:
>>>>>>>
>>>>>>> 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>>>>>> 	Use KVM_BUG_ON() instead of WARN_ON().
>>>>>>> 	Correct kvm_trylock_all_vcpus() return value.
>>>>>>>
>>>>>>> Changes in V3:
>>>>>>> 	Refer:
>>>>>>>                https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
>>>>>>>
>>>>>>> [...]
>>>>>>
>>>>>> Applied to kvm-x86 vmx, thanks!
>>>>>>
>>>>>> [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
>>>>>>          https://github.com/kvm-x86/linux/commit/111a7311a016
>>>>>
>>>>> Fixed up to address a docs goof[*], new hash:
>>>>>
>>>>>          https://github.com/kvm-x86/linux/commit/e4775f57ad51
>>>>>
>>>>> [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au
>>>>
>>>> Hi Sean,
>>>>
>>>> I think it's targeted for v6.17, right?
>>>>
>>>> If so, do we need the enumeration for the new TDX ioctl? Yes, the userspace
>>>> could always try and ignore the failure. But since the ship has not sailed,
>>>> I would like to report it and hear your opinion.
>>>
>>> Bugger, you're right.  It's sitting at the top of 'kvm-x86 vmx', so it should be
>>> easy enough to tack on a capability.
>>>
>>> This?
>>
>> I'm wondering if we need a TDX centralized enumeration interface, e.g., new
>> field in struct kvm_tdx_capabilities. I believe there will be more and more
>> TDX new features, and assigning each a KVM_CAP seems wasteful.
> 
> Oh, yeah, that's a much better idea.  In addition to not polluting KVM_CAP,
> 
> LOL, and we certainly have the capacity in the structure:
> 
> 	__u64 reserved[250];
> 
> Sans documentation, something like so?
> 
> --
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 13da87c05098..70ffe6e8d216 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -963,6 +963,8 @@ struct kvm_tdx_cmd {
>          __u64 hw_error;
>   };
>   
> +#define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0) > +
>   struct kvm_tdx_capabilities {
>          __u64 supported_attrs;
>          __u64 supported_xfam;
> @@ -972,7 +974,9 @@ struct kvm_tdx_capabilities {
>          __u64 kernel_tdvmcallinfo_1_r12;
>          __u64 user_tdvmcallinfo_1_r12;
>   
> -       __u64 reserved[250];
> +       __u64 supported_caps;
> +
> +       __u64 reserved[249];
>   
>          /* Configurable CPUID bits for userspace */
>          struct kvm_cpuid2 cpuid;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f4d4fd5cc6e8..783b1046f6c1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -189,6 +189,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>          if (!caps->supported_xfam)
>                  return -EIO;
>   
> +       caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;

nit: For the sake of consistency make that a |= so that all subsequent 
additions to it will be uniform with the first.
> +
>          caps->cpuid.nent = td_conf->num_cpuid_config;
>   
>          caps->user_tdvmcallinfo_1_r11 =
> --
> 
> 
> Aha!  And if we squeeze in a patch for 6.16. to zero out the reserved array, we
> can even avoid adding a capability to enumerate the TDX capability functionality.
> 
> --
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f4d4fd5cc6e8..9c2997665762 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -181,6 +181,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>   {
>          int i;
>   
> +       memset(caps->reserved, 0, sizeof(caps->reserved));
> +
>          caps->supported_attrs = tdx_get_supported_attrs(td_conf);
>          if (!caps->supported_attrs)
>                  return -EIO;
> --
> 

