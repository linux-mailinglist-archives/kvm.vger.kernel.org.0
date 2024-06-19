Return-Path: <kvm+bounces-19932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3C990E52A
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44418B23A4E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23FB78C64;
	Wed, 19 Jun 2024 08:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IvUq0+UN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82B77117
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784324; cv=none; b=GTbbQhXWQprh1G7sZ5Xu21MwAjtqeD+zcnfkzhzUkcHG7q20tt8HMHoPtxcwP8Un93neup8owTXtyH8JspjcELHj4eFcIw3+aKMVc94WwBxS+M3WhPo2Ka/z8ezCF0h63q1PUuOSq0aOtPv9Twd32E8JgrNZ+SfixAE7+DE/Nco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784324; c=relaxed/simple;
	bh=ic4OonCzqz8zb+Ab91IFChnLZE4u5xYviggsjSwZYYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBhOvXxWY/PBDgKZjfJAS5WzWP3vjevurlQ9jsHVAJ/o0PERWxMMRiH0iPklHSaRLUVIaXFwb3VuWpBmskTkbp39ZsTvHmsVc7uAoMuSENTGNjFCAPGGAfanME7RsPOEBlzQpGkv2iTO7MAFomXGkGxr4rz8lXe6EWW8A82yd1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IvUq0+UN; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3608545debbso3827026f8f.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 01:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718784321; x=1719389121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0XDhme2tEckF2guKUB8AsWcTvk4ojSd7Dq78DV7RT+Y=;
        b=IvUq0+UNfMSrOtCNKBhEbuVVb5OEsEb0NhbZwy3GxPxIQ2l71CLwQCL10Oork3hqgq
         IefrOEY86XPCUNxPEODi3h5qduFZPOQZy6V3ePFjLGWBPreioxahjiAPvTYBwYUZPOr5
         lz6Ve2eXELFHnVLllYoEYvRreJcrVwpk7+rnxqnKVwr9PFlUzuU4FnPh4evrIqR3t4E4
         W1sYiyp2ncp4sOxayM/lUKrhouO21Ywo1TDYxiJSmHeKFaGqKlSB3IfdwdyxCoPtZAjj
         qky6d1VlbvXKOMgp/hTCiZUbtli5BWg4H90gLS2atcj/AQ33HcTp1jbFkEBqxdGsPnfH
         NUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718784321; x=1719389121;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XDhme2tEckF2guKUB8AsWcTvk4ojSd7Dq78DV7RT+Y=;
        b=XN3sHRDG1uaHCRELrXhbrTYO7ZOrmFURO3i+PYxK/su7QPyUfyCtXYv+SNqlmjIAQh
         MjhKx9mcPbHd/K0qsN1pUyYz4tgbatMhsffE7m1FfHKcGoPEgL5Uo+ZGHFbm49QYs7SP
         uH4vmIP1LlD2Dar1/J2QdyrQ6FcxrQUZ06wCVuaiRrWBIGYWbFPdbfuteVsp9cufZ+sP
         8x+SyaICAQHAUE37L29CzKGl6pkYAUXJIyIh3vin8VCwDE8OuYa/bXxAJ9znoIUqJQTx
         N76RomaEQAwjP5mR91v1qui5tQIrrBrkBWgnUAIcfAq2WNs+oEzhbnRrdDT+6bTvXwL7
         nOew==
X-Forwarded-Encrypted: i=1; AJvYcCWObzr3tD1jNBk/uqqUtcbfAhkQn8diBdxgk/hYrsl0TAt3zal/EoDLpfaCVrt8VChiOdmGFSxQ4q1TL0gc2NerpCc1
X-Gm-Message-State: AOJu0Yx18wKk9lgbamFVDgz9/r0gj6yK4n+J23YwZf/RMZu+4/UjLRku
	5QYyBDPQVZpnXPhLpeYCpXXC0sxQAo+HB4j7ZCgt1czaZkKK3WX+m/gI/VJRdg8=
X-Google-Smtp-Source: AGHT+IEj7vjm+HP1+efuKyLCaFUdRhGnnBejRO8fJMKf2VyJXSdGt3xeE55DDZM87/j6gDghlb3alA==
X-Received: by 2002:adf:b189:0:b0:354:fc65:39d6 with SMTP id ffacd0b85a97d-363175b8055mr1476687f8f.26.1718784321011;
        Wed, 19 Jun 2024 01:05:21 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607510340fsm16427144f8f.93.2024.06.19.01.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 01:05:20 -0700 (PDT)
Message-ID: <dea78e58-a4b5-48ee-8c99-213dd5ec9b8f@suse.com>
Date: Wed, 19 Jun 2024 11:05:19 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all
 element sizes
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <210f7747058e01c4d2ed683660a4cb18c5d88440.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <210f7747058e01c4d2ed683660a4cb18c5d88440.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> The TDX module provides "global metadata fields" for software to query.
> Each metadata field is accessible by a unique "metadata field ID".  TDX
> supports 8/16/32/64 bits metadata element sizes.  The size of each
> metadata field is encoded in its associated metadata field ID.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields for module initialization.  All these metadata fields
> are 16-bit, and the kernel only supports reading 16-bit fields.
> 
> Future changes will need to read more metadata fields with other element
> sizes.  To resolve this once for all, extend the existing metadata
> reading code to support reading all element sizes.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 29 ++++++++++++++++-------------
>   arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
>   2 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 854312e97eff..4392e82a9bcb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -270,23 +270,25 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>   	return 0;
>   }
>   
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     void *stbuf)
> +/*
> + * Read one global metadata field and store the data to a location of a
> + * given buffer specified by the offset and size (in bytes).
> + */
> +static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
> +				  int bytes)

Actually I think opencoding read_sys_metadata_field in 
stbuf_read_sysmd_field and leaving the function named as
read_sys_metadata_field would be best. The new function is still very 
short and linear.

Another point - why do proliferate the offset calculations in the lower 
layers of TDX. Simply pass in a buffer and a size, calculate the exact 
location in the callers of the read functions.

<snip>

