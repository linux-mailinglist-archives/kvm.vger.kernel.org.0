Return-Path: <kvm+bounces-19856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B38490CAB2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53C691F2348E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C13315CD7F;
	Tue, 18 Jun 2024 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JIbUsMz9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90CD15CD61
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 11:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718711143; cv=none; b=rWoRafh3883LUTgk4oyWIkCPwg2Wtlh6pqIkjcLkNTcTXTmjqccmGqrTgAKok7huzbQ6fXufnyARlHkK7xV0Hguj1QuGCc5pCojuaQWcNji6klD3FK1tYS5IL5qNjV3Lxuy0vjLg7Jy7qhXN+eO1PY19guGuOKnBRcwSGXdKSGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718711143; c=relaxed/simple;
	bh=tYe3DD1fCSMHGzPNpWN6MJvkH+q9PwDNhe1nQN+VMH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PGbOVjhOOAfVlaangGZdLL/AfRj3UiQVM7v8872+gZg4/bTTnRV0B/DcjnpVnYyfKM08l8rl+FTAxRDxjhlEExoaN2c4/EEdkbkDzyDGsrQRcJc+mtm0NCT1xlLu5zwxnhOyE/o6yK8dVpc++UGWh7RkX+uKw/XfL1l6QtjzRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JIbUsMz9; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-362b32fbb3bso82438f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 04:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718711139; x=1719315939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LYDxvLQlYGKG+H67tH5VGth33yFnD49SE9fJWyG5TWQ=;
        b=JIbUsMz9YKV810xZikRysFuWU6jHwx/dvWyjGfTvxkBY+FKRhJyf+U21qbWDxyNfbC
         a6Y99nL1BvwN1Rc36wX1JpUiNCP623SYJAc2pE5ACTt/jwgeI9gTHCLGKVLyTORFzeV5
         E08O7t4nYvSUMWH7P3dFt3Ktrw0acfORAQjn2FcEdSmuZE3NUMlrVM1q9qTg19mwRrBc
         hrku79oJMBYB1xBlpAKG+bKraZ4SvkGjeb9YpETgH3J5xOt0kcUpNmaz2njG0kDt6o9Q
         Q8ZQn57AycAwSkGj/Fo+vqw9ePrj/R5ZNzjSxxU1JT2bDplJT3y+12GehUagsXevnGFf
         eloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718711139; x=1719315939;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYDxvLQlYGKG+H67tH5VGth33yFnD49SE9fJWyG5TWQ=;
        b=cO5QGqlha0nF+U4sEt3EebSGjmF+iOa+2FWrVULC7jGxGkoEpoArZu4caIdOSnPvSD
         eUF7Y/5STmuuj3hioPcYj8tOPR/GQNIDqj04HMncsTirDwX1Z/oNQherjMj52w8Y1SSH
         U+HLw8+J0RuOgT3kggSAEGTFU6Xi1nHccehDAyMcPgVVCdsljNfDfqFn0TaRTBxRUKvp
         NVIwq9y1F8+MQhSao6c8ARKrRGUKQ8TQvIPuB8sp7yB0yceZY/AI5dJe79EGRJufB9GG
         YE61IKh9L5xdtb8XoXQZq4XZW7VWlWrj8GZvUi8P5rH3Fpp+4cQ2Rrk2XRTDIKnHR+Tz
         WvfA==
X-Forwarded-Encrypted: i=1; AJvYcCXUSXsxLWO0mql0fe2jtx38nlFZsW7+e856bnJ+Z4COeccviTR/0LqOLsK648/Ry8tMtYq2T7a8WVRvLtBLc32/3TwU
X-Gm-Message-State: AOJu0YzuN35zn3S5YKdQkUgLNsAb/P9B+K6MhBaAidei2jlwCXFQDE/A
	gNxB2/68wf9FXUVIPiIcemfNndGrrNQW/TVwHYE30A5H6tAZidffx8KGCbBTROc=
X-Google-Smtp-Source: AGHT+IFWr8Mwu092i/2cJesdM+pm/8E0cF3K/P15rEkIwx6q7O0QTmYvoW47jTNzu5m4wm/boVs8WQ==
X-Received: by 2002:a5d:4e42:0:b0:35f:2c43:8861 with SMTP id ffacd0b85a97d-3607a78112bmr8449439f8f.66.1718711138987;
        Tue, 18 Jun 2024 04:45:38 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3609d95bc02sm2506195f8f.18.2024.06.18.04.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 04:45:38 -0700 (PDT)
Message-ID: <7a9eddb2-2ad1-4aab-8edb-548f05b524ec@suse.com>
Date: Tue, 18 Jun 2024 14:45:37 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] x86/virt/tdx: Abstract reading multiple global
 metadata fields as a helper
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <dd4ab4f97fc12780e4052f7ece94ceadffafd24d.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <dd4ab4f97fc12780e4052f7ece94ceadffafd24d.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
> module.  Future changes will need to read other metadata fields that
> don't make sense to populate to the "struct tdx_tdmr_sysinfo".
> 
> Now the code in get_tdx_tdmr_sysinfo() to read multiple global metadata
> fields is not bound to the 'struct tdx_tdmr_sysinfo', and can support
> reading all metadata element sizes.  Abstract this code as a helper for
> future use.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 27 ++++++++++++++++-----------
>   1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4392e82a9bcb..c68fbaf4aa15 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -304,6 +304,21 @@ struct field_mapping {
>   	  .offset   = offsetof(_struct, _member),		\
>   	  .size	    = sizeof(typeof(((_struct *)0)->_member)) }
>   
> +static int stbuf_read_sysmd_multi(const struct field_mapping *fields,

Rename it to read_system_metadata_fields i.e just use the plural form of 
the single field function. Whatever you choose to rename the singular 
form, just make this function be the plural. But as a general remark - I 
don't see what value the "stbuf" prefix brings. 'sysmd' is also somewhat 
unintuitive. Any of 
read_metadata_fields/read_sys_metadata_fields/read_system_metadata_fields 
seem better.

> +				  int nr_fields, void *stbuf)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < nr_fields; i++) {
> +		ret = stbuf_read_sysmd_field(fields[i].field_id, stbuf,
> +				      fields[i].offset, fields[i].size);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
>   

<snip>

