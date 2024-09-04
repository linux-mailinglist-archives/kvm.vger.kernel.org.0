Return-Path: <kvm+bounces-25872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6114096BB5E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6A7DB2381E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D881D460E;
	Wed,  4 Sep 2024 11:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="axOBdmZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DD71D45FA
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725451135; cv=none; b=Zpbs0X32zPCvcMmVcIsouUu5iq4+M+d7hm86ZW+AbCvn03Ap7F5CSB1FrMvjW4gHk5ScG3p87dhmpZAj2F2C0qHyoGYx3dHaoHePXkFGeIivTb8QBBgfHGI3oi9NI6soCTSYVAJG6eGGJoZiAUuiKk62WIDrQYZ0HAGHfxlWc5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725451135; c=relaxed/simple;
	bh=oFpYFAwzQWlL+Kvgx4pEoCCAh+xehZKm3+5+PmwqUq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GF218mo/3YbAUE4K3wZb6ncdSjLA8lOoskdqWGVaGq9E5rDNPCYhHhOYIS56n8K06tYf1+txpiaTvMlM3/jv8lHzKiwOQvbBO0R1ayC+UnGcOoqmC1TN9Set7B4bXPzGTd1fOhJesR9mfQxrr2ELVIB5EO8M/yyNhx5QVdqLb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=axOBdmZ3; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53346132365so7991114e87.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725451132; x=1726055932; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VS61FUBAsfsMXwD3b/j+B3Cf4Nz46zKMjoAkgpr9Tb4=;
        b=axOBdmZ3cZ0yA1EZq3ep+WTEIHt3rOocPgvtwU26V30u0VRMwA0REJ5thtQqNlORv1
         WyrYeUu4DQ2D2S/MV7QltBbGhv0s1lx60JelgBYhVXMU2gP0+3o7To+FjgdOa08d2LTr
         e3H/uZKklxJaoBhfHZ6WX8t0FBeoX5jXPdoQZCsOGWZS8OYNsdyolQ3NsSOcw2RREPbD
         haI+53tqnngooa2XJDTflKHd6MAlRV5SkE3hdyPakBqnsFFBNQYu88GjgkOOviG6ct6Y
         GA3o32imIQJd22ss2l9hf2GSyEHuS9UKFDNTjElhgA2CKKdDK/15m+MCRTnvX+Q7+fxk
         VMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725451132; x=1726055932;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VS61FUBAsfsMXwD3b/j+B3Cf4Nz46zKMjoAkgpr9Tb4=;
        b=TXnMUmddijBoDnW7rdNl+/QLCmgr+MK00BaGecv3oG91vd5CaQ1GBCUQ7BLCtTevX6
         W8KKKoVbMObFRRSdIBUKxkckrefGi9JCZACEeqM6zCqbqjV+03xy2jhiOZyytXMlqE0I
         fx40/SzjH1+27h71rc/83Ww8EvHIvVy0Apo/L+sKRE53qF2X1AiS4k1MiolwxK4PvxYX
         0tKPv8QYk3zAXqXcRJHtFK43kt4tO506A9flG3Wt/rD8Qz3Af5L0k583QXKEz1qgbVAH
         wTYdLKEMAl1jkabahIStFUGU1U7ocx41nj58P9lzrmeAJAkCq6hp00NqcnPqMyJwipH9
         pXBw==
X-Forwarded-Encrypted: i=1; AJvYcCU9j2CYlTLtmAyTYzFkZ8wze6sPrvxlhzPTjEpmx1suA98p3/ehV3+zAhGGNV/nlby3gsY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3c5E6JGoOhU/l7b19o8nIU7Rd3HuzG0w+BltghO8Na+h37g86
	MqnC62z1PItpN/RxNouKpvtdyUIbvbUPoodjSo111ZQctElrGfdxuczBSq90RjY=
X-Google-Smtp-Source: AGHT+IHs1wIrBm6X/Hd9ZoeAvwI8G6avm2Xjtx4bTuDlmxGONjsMb86+mwA17/VyPvh0C5XM0JrLgA==
X-Received: by 2002:a05:6512:1589:b0:52e:f2a6:8e1a with SMTP id 2adb3069b0e04-53546b32cacmr13503390e87.29.1725451130774;
        Wed, 04 Sep 2024 04:58:50 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7332:ffbc:ffbc:9dd4:6902? ([2a10:bac0:b000:7332:ffbc:ffbc:9dd4:6902])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89891daeb1sm800902266b.169.2024.09.04.04.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 04:58:50 -0700 (PDT)
Message-ID: <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
Date: Wed, 4 Sep 2024 14:58:48 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240812224820.34826-11-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> While TDX module reports a set of capabilities/features that it
> supports, what KVM currently supports might be a subset of them.
> E.g., DEBUG and PERFMON are supported by TDX module but currently not
> supported by KVM.
> 
> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
> supported_attrs and suppported_xfam are validated against fixed0/1
> values enumerated by TDX module. Configurable CPUID bits derive from TDX
> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
> i.e., mask off the bits that are configurable in the view of TDX module
> but not supported by KVM yet.
> 
> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Change setup_kvm_tdx_caps() to use the exported 'struct tdx_sysinfo'
>     pointer.
>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct tdx_sysinfo'
>     doesn't have 'kvm_tdx_cpuid_config'.
>   - Updates for uAPI changes
> ---
>   arch/x86/include/uapi/asm/kvm.h |  2 -
>   arch/x86/kvm/vmx/tdx.c          | 81 +++++++++++++++++++++++++++++++++
>   2 files changed, 81 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 47caf508cca7..c9eb2e2f5559 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>   	__u64 hw_error;
>   };
>   
> -#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> -
>   struct kvm_tdx_cpuid_config {
>   	__u32 leaf;
>   	__u32 sub_leaf;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 90b44ebaf864..d89973e554f6 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
>   
> +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> +
> +struct kvm_tdx_caps {
> +	u64 supported_attrs;
> +	u64 supported_xfam;
> +
> +	u16 num_cpuid_config;
> +	/* This must the last member. */
> +	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
> +};
> +
> +static struct kvm_tdx_caps *kvm_tdx_caps;
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	return r;
>   }
>   
> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)

Why isn't TDX_TD_ATTR_DEBUG added as well?

<snip>

