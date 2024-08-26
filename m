Return-Path: <kvm+bounces-25049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C48295EF66
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 13:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D57181F2709A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 11:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628581547E9;
	Mon, 26 Aug 2024 11:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PEZci8xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A71482E3
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 11:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724670275; cv=none; b=OZnVqY4iGh4GTTvy0Me4X4eNNYsDoEt6y4yvKeFe+o65uzTTpRyuC+ElaukZBjD0yMGzogEqtqnoQejUi+Mch+ZABbztT1UCUUQk+61x67D9/alrItApmzLNURsj7Ns0/ETFznRdw91hyRNDn8ZG+MJNDTVWAKVa/JpS3g3V0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724670275; c=relaxed/simple;
	bh=qQwuQmq19WaJY2TKw8051kfCZHiwoDZB2S9b1qWk7As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxZpvak4OH+iOzuaOyFCq5Q1PRs5XU45w79DR89q5ZIHRR5LzIuns0RahiTXVZE0x3spieu08ZST4xkIDdMI11CUmIePk2g1tsWrtX+cNmmclbOIi5hDcTvQWOtqi1vZkblo8z6kfacq9GOGUHVTjXn+bcKv6mnXzZcZCiWBY/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PEZci8xq; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-429e29933aaso34472365e9.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 04:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724670270; x=1725275070; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBUf5QDMv+hVbN1ugf3E0laVvepA0Eshqkxu4Gw5YM0=;
        b=PEZci8xqo5I2MLnHCPmjgoQIAAo3qGuGoGN3N+8QJxGVt5KQhFUERGpZd7sSkdJOce
         IgbO+wXFDuQ5K8aYl75pxWlgg6cnswOFQxrHihNG6xnDGn4pKptIlw6fOQRIOLP+qKEl
         RaJ6fDZK962SvEv+malbpsWZ5AeKY6Ln5I5Ax3Zs2PMLQmwK/u6p8D3cgtqavEC2ulFh
         wp+e/tjV3W16tqPBEn7zcxR42UMXoGLIjbSiFNcp4t/zA9EsfY/0sA3hxnS16fqim74k
         BB9Zv/ywO3mMLsy/Js+S/pnakbJ6MNwKHXji3NsOvfPGg/Xb4NWmverQ47lz/1OktIgG
         hLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724670270; x=1725275070;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBUf5QDMv+hVbN1ugf3E0laVvepA0Eshqkxu4Gw5YM0=;
        b=fNk4HIaAM43pjtzPt+59eLcEr3XrRVS8iZbsDZLIh7A6LMLyju73ZmsylUajHTC8x8
         N9RCCx+BbNRSQkxtWtCsexK/BIMcG9Dr9qBcXrTFTn3aY+8TZjmOz81gLt6wcC/znCDu
         bZyyQtUIaLjdqS6JXRYihlTJ3SzCFsz9DZyoJyyrTDZ0+oCyD6yEHPL+di9di4wi5brG
         Erg9Xi5+YtvvH9r1Fb6HlkgjYx3yByd/jzNLtPvOHgkmHmvaZUQUuq09/PiSTr0zRP89
         C7/bJQ7nRSd0SnG9jA+eVRrYqD4woHqM0eFaagcaPriR76uXZCxAtnZKR6aaI21s6p54
         qP6w==
X-Forwarded-Encrypted: i=1; AJvYcCXRroXA1KySnu++9MMKhV/4TOYU1pCmgJf/KLV5eSQ/uj+CKCgUaq3fFK0HzJlsLFDZ6Pc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsD8a5rkSTwrD3rjOrPVsJrrKeJFmzUSqE0iEdGfiXMbMWu1F5
	ahZbQT2Hvo97ZwbKAPquEzlGDFkv4e4X2n4KV5yvON3QXOK0Y7uY/fz8E07B6CE=
X-Google-Smtp-Source: AGHT+IFjlwzJAG+UaujRUepSwwYiC2cK0519dJmLL8/0p57HqWVGq1Y2q3nJ4NjDjd7xcOtuwkQBYQ==
X-Received: by 2002:a05:600c:47d0:b0:42b:892d:54c0 with SMTP id 5b1f17b1804b1-42b892d54d7mr58161045e9.12.1724670270117;
        Mon, 26 Aug 2024 04:04:30 -0700 (PDT)
Received: from [10.20.4.146] ([212.39.89.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac935211csm134383535e9.47.2024.08.26.04.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2024 04:04:29 -0700 (PDT)
Message-ID: <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
Date: Mon, 26 Aug 2024 14:04:27 +0300
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

<snip>


> +
>   static int tdx_online_cpu(unsigned int cpu)
>   {
>   	unsigned long flags;
> @@ -217,11 +292,16 @@ static int __init __tdx_bringup(void)
>   		goto get_sysinfo_err;
>   	}
>   
> +	r = setup_kvm_tdx_caps();

nit: Since there are other similarly named functions that come later how 
about rename this to init_kvm_tdx_caps, so that it's clear that the 
functions that are executed ones are prefixed with "init_" and those 
that will be executed on every TDV boot up can be named prefixed with 
"setup_"


> +	if (r)
> +		goto get_sysinfo_err;
> +
>   	/*
>   	 * Leave hardware virtualization enabled after TDX is enabled
>   	 * successfully.  TDX CPU hotplug depends on this.
>   	 */
>   	return 0;
> +
>   get_sysinfo_err:
>   	__do_tdx_cleanup();
>   tdx_bringup_err:
> @@ -232,6 +312,7 @@ static int __init __tdx_bringup(void)
>   void tdx_cleanup(void)
>   {
>   	if (enable_tdx) {
> +		free_kvm_tdx_cap();
>   		__do_tdx_cleanup();
>   		kvm_disable_virtualization();
>   	}

