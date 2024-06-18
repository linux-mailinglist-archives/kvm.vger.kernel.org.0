Return-Path: <kvm+bounces-19868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA9590D6AF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 303AC1F22D42
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EEF2C6AF;
	Tue, 18 Jun 2024 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IEyi7u4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3B4225DA
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718723427; cv=none; b=FV6ps709XfnI4hjzTYCTB4Sj88rfjVJt39huDIxOh2hPS2OjQlVRllErruUMJXyGcmkAjLp+ZXHAB/WWr4RAL7I6aOULDpznbbfxQQor9r/VSvmCu/XDV+EqfHL/RxcZ8weLKucyhdM8GzHLK3YD1BhVY9fSzhZCkFCAzgzBS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718723427; c=relaxed/simple;
	bh=SP7q81qWNq4cCLZnlLrfBW5vXhkXY9BLAjp64hjh5gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzrBa01RI/LD+P6KAU1KF23w+Tw4HYYesX65B/dxGdERI8L0wg5StusLLeWCgfJeHqv5aMl+Iq/FXcyYRx8HWX0zYoGv8KrUkQVCFGj9+ksKkvdKgmY8UuCwhhVzzg0BTSNJQdZvx1mwBsxgQPMG+CjkhIMljmXsoCNczgGMHa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IEyi7u4Z; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57cb9a370ddso6349868a12.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 08:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718723422; x=1719328222; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iKBE1NSWSd15cPnGMhaK2tiiQsEvDMuGFKV4Mjnsw/I=;
        b=IEyi7u4ZV8x6LKZATCJqVHna+Qgw4hWigoGooMw2HdKLbTNbTs+Dsh2uLHTM6yrpSW
         9/RdP9fN9VxfUHaebVwZ4ZwQCgihQoB2IUsb7SpCsys4+lhf9QTX2VRS1Y9OPCuAdaTd
         Ylsvb1t4Uv4healzfu788JdeFP3ZsNQmSIuVSgUEZrofk/T/I0pew9gWsdVj9Br7DuqK
         fehdYzLeLhEUySYMYRyB83kiK0LL+Zwz+fQ+n1Nm7GciM/CSBKn7DNro4okNc1uARce2
         V0K2qJfIX8h3HBXJ8ay3cN38mektq2LQzKQByUU7JTUIpSUSWlpTxkZVPznQQxTH5Ec3
         5Yug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718723422; x=1719328222;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iKBE1NSWSd15cPnGMhaK2tiiQsEvDMuGFKV4Mjnsw/I=;
        b=XZgjVaUqvptygtM4JhwNVk+sJjXJfQiyYmDA0D+ZKXFU0RUenTOxug++hb1O+tidNv
         uDDoQw7UEysO7jscq3Hnidoa7cHUh1ltVoZg4/KQzN+Thh6uUFWlZTz1inYz8HiQA0Wc
         SvcRlM7gS2s+b/F5tdS8KZMcGndO3Rt24O8y0+AnxdiPwjwWVDeagL9ZyvKO04mQKAjp
         aEYsykysoKrQPS8Qdf1kLW6Fup8S59GBBtu+EFJeJ/BSBHH0VpHcCgkvw4Acv7dIgqEQ
         t5qygMLPwQK/3H6R5kGTlzT6T9GB4Kp/1xPdWvCW2DsEC7ZZpZaTLkDAtCA4mXd5IqVR
         Bg2g==
X-Forwarded-Encrypted: i=1; AJvYcCU69pSdXKy0gkXv82Z7ZaGbnrhprvBxcL64XsnhR2QvIQ8qZ1ra5AIAi7ZivToq4CXMqFuKPFdM7p5EOmmC3bOePc3s
X-Gm-Message-State: AOJu0YxfN829wI7AuDmbgk828aThJ530DoW3y+6H7OFipiATynCiCy5f
	yfQfyx0YV0DDU3DHFTEiBPagSPLpu+EjR82anngGM8jTRxux2BVHWdDxOQCLcg0=
X-Google-Smtp-Source: AGHT+IHY8c3KDfS2CVVbRxmS3YzW470n5QtJw/ekP0zpRyqlNqmiR7aZ1yM+wIR4w7JGNw0jAYyOkw==
X-Received: by 2002:a17:907:a092:b0:a6f:7591:9217 with SMTP id a640c23a62f3a-a6f7591974cmr712123866b.55.1718723422094;
        Tue, 18 Jun 2024 08:10:22 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075104a8fsm14212761f8f.110.2024.06.18.08.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 08:10:21 -0700 (PDT)
Message-ID: <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
Date: Tue, 18 Jun 2024 18:10:20 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> A TDX module initialization failure was reported on a Emerald Rapids
> platform:
> 
>    virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>    virt/tdx: module initialization failed (-28)
> 
> As a step of initializing the TDX module, the kernel tells the TDX
> module all the "TDX-usable memory regions" via a set of TDX architecture
> defined structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB
> aligned and in 1GB granularity, and all "non-TDX-usable memory holes" in
> a given TDMR must be marked as a "reserved area".  Each TDMR only
> supports a maximum number of reserved areas reported by the TDX module.
> 
> As shown above, the root cause of this failure is when the kernel tries
> to construct a TDMR to cover address range [0x0, 0x80000000), there
> are too many memory holes within that range and the number of memory
> holes exceeds the maximum number of reserved areas.
> 
> The E820 table of that platform (see [1] below) reflects this: the
> number of memory holes among e820 "usable" entries exceeds 16, which is
> the maximum number of reserved areas TDX module supports in practice.
> 
> === Fix ===
> 
> There are two options to fix this: 1) put less memory holes as "reserved
> area" when constructing a TDMR; 2) reduce the TDMR's size to cover less
> memory regions, thus less memory holes.
> 
> Option 1) is possible, and in fact is easier and preferable:
> 
> TDX actually has a concept of "Convertible Memory Regions" (CMRs).  TDX
> reports a list of CMRs that meet TDX's security requirements on memory.
> TDX requires all the "TDX-usable memory regions" that the kernel passes
> to the module via TDMRs, a.k.a, all the "non-reserved regions in TDMRs",
> must be convertible memory.
> 
> In other words, if a memory hole is indeed CMR, then it's not mandatory

So TDX requires all TDMR to be CMR, and CMR regions are reported by the 
BIOS, how did you arrive at the conclusion that if a hole is CMR there 
is no point in creating a TDMR for it?

> for the kernel to add it to the reserved areas.  The number of consumed
> reserved areas can be reduced if the kernel doesn't add those memory
> holes as reserved area.  Note this doesn't have security impact because
> the kernel is out of TDX's TCB anyway.
> 
> This is feasible because in practice the CMRs just reflect the nature of
> whether the RAM can indeed be used by TDX, thus each CMR tends to be a
> large range w/o being split into small areas, e.g., in the way the e820
> table does to contain a lot "ACPI *" entries.  [2] below shows the CMRs
> reported on the problematic platform (using the off-tree TDX code).
> 
> So for this particular module initialization failure, the memory holes
> that are within [0x0, 0x80000000) are mostly indeed CMR.  By not adding
> them to the reserved areas, the number of consumed reserved areas for
> the TDMR [0x0, 0x80000000) can be dramatically reduced.
> 
> On the other hand, although option 2) is also theoretically feasible, it
> requires more complicated logic to handle around splitting TDMR into
> smaller ones.  E.g., today one memory region must be fully in one TDMR,
> while splitting TDMR will result in each TDMR only covering part of some
> memory region.  And this also increases the total number of TDMRs, which
> also cannot exceed a maximum value that TDX module supports.
> 

<snip>

> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 149 ++++++++++++++++++++++++++++++++----
>   arch/x86/virt/vmx/tdx/tdx.h |  13 ++++
>   2 files changed, 146 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ced40e3b516e..88a0c8b788b7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -293,6 +293,10 @@ static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
>   	return 0;
>   }
>   
> +/* Wrapper to read one metadata field to u8/u16/u32/u64 */
> +#define stbuf_read_sysmd_single(_field_id, _pdata)	\
> +	stbuf_read_sysmd_field(_field_id, _pdata, 0, sizeof(typeof(*(_pdata))))

What value does adding yet another level of indirection bring here?

> +
>   struct field_mapping {
>   	u64 field_id;
>   	int offset;
> @@ -349,6 +353,76 @@ static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
>   	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
>   }
>   
> +/* Update the @cmr_info->num_cmrs to trim tail empty CMRs */
> +static void trim_empty_tail_cmrs(struct tdx_sysinfo_cmr_info *cmr_info)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_info->num_cmrs; i++) {
> +		u64 cmr_base = cmr_info->cmr_base[i];
> +		u64 cmr_size = cmr_info->cmr_size[i];
> +
> +		if (!cmr_size) {
> +			WARN_ON_ONCE(cmr_base);
> +			break;
> +		}
> +
> +		/* TDX architecture: CMR must be 4KB aligned */
> +		WARN_ON_ONCE(!PAGE_ALIGNED(cmr_base) ||
> +				!PAGE_ALIGNED(cmr_size));
> +	}
> +
> +	cmr_info->num_cmrs = i;
> +}

That function is somewhat weird, on the one hand its name suggests it's 
doing some "optimisation" i.e removing empty cmrs, at the same time it 
will simply cap the number of CMRs until it meets the first empty CMR, 
what aif we have and will also WARN. In fact it could even crash the 
machine if panic_on_warn is enabled, furthermore the alignement checks 
suggest it's actually some sanity checking function. Furthermore if we 
have:"

ORDINARY_CMR,EMPTY_CMR,ORDINARY_CMR

(Is such a scenario even possible), in this case we'll ommit also the 
last ordinary cmr region?

> +
> +#define TD_SYSINFO_MAP_CMR_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_cmr_info, _member)

nit: Again, no real value in introducing yet another level of 
indirection in this case.

> +
> +static int get_tdx_cmr_info(struct tdx_sysinfo_cmr_info *cmr_info)
> +{
> +	int i, ret;
> +
> +	ret = stbuf_read_sysmd_single(MD_FIELD_ID_NUM_CMRS,
> +			&cmr_info->num_cmrs);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < cmr_info->num_cmrs; i++) {
> +		const struct field_mapping fields[] = {
> +			TD_SYSINFO_MAP_CMR_INFO(CMR_BASE0 + i, cmr_base[i]),
> +			TD_SYSINFO_MAP_CMR_INFO(CMR_SIZE0 + i, cmr_size[i]),
> +		};
> +
> +		ret = stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields),
> +				cmr_info);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * The TDX module may just report the maximum number of CMRs that
> +	 * TDX architecturally supports as the actual number of CMRs,
> +	 * despite the latter is smaller.  In this case all the tail
> +	 * CMRs will be empty.  Trim them away.
> +	 */
> +	trim_empty_tail_cmrs(cmr_info);
> +
> +	return 0;
> +}
> +
> +static void print_cmr_info(struct tdx_sysinfo_cmr_info *cmr_info)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_info->num_cmrs; i++) {
> +		u64 cmr_base = cmr_info->cmr_base[i];
> +		u64 cmr_size = cmr_info->cmr_size[i];
> +
> +		pr_info("CMR[%d]: [0x%llx, 0x%llx)\n", i, cmr_base,
> +				cmr_base + cmr_size);
> +	}
> +}

Do we really want to always print all CMR regions, won't that become way 
too spammy and isn't this really useful in debug scenarios? Perhaps gate 
this particular information behind a debug flag?

> +
>   static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
>   {
>   	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;

<snip>

