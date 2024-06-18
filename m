Return-Path: <kvm+bounces-19860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C45D90D253
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 948B01C24A07
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5201AC435;
	Tue, 18 Jun 2024 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Wk1/qrd/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657BB15A4B5
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716671; cv=none; b=sOZ2mJElRVWMJTYayEoMkt2JyYR1jNJ0zm1oZJ1m5FR2UHY3SOIgtmg03ziATsdzkEsITf0RSIm/LvW7AiQCV9iKAM9GiheXhVMFsFM17Y8WkEkM2D/f1yCabMhX8DE7m9atIT6nICyutj0v9y4ujrmTq4Mc8jHCxvAaiYWtsMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716671; c=relaxed/simple;
	bh=FwLqxqdPHtrlROgIdFxoN9wh8MjrTUm/GU20D7rH1sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gR4F7BXmz0tewlX8HA+bTovfLB9/F70qAYIQXhdCkzkNb6A1DNKC5KR7u+v1PgBmbU09wH8eP86MgmxaaZkmy6n+Pr98pxJZtAPIcO2Kgg7EOpHa5dQazM/cUoeNmL9XvyaNsP6zQ0+w+B4QXDY81rz9fS1W030qec8MAsZs2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Wk1/qrd/; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52c7fbad011so6343050e87.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 06:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718716667; x=1719321467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EX24AlEN/UD/1l0F51YlU1CSwhLSmC3XywghaDbsT0o=;
        b=Wk1/qrd/j70pLlqcj4IkwWKB3kHZoxi0Ky+O4/vAhXZykFVM8cGPx8JUYD5V85m1JI
         Lw08br7KapLc7wCVj7jFBz+XGYvt41Wv3Bu0q0MMZtzpqPUncmM2YoATH+dwl23/hLwW
         3qMnDeMhYHvz8k4j0g6sZw+8LAvSq+g5scVFbprEVvSk9YJ0SmF/nNAlY2tvIXi026TG
         Zq/zWDdg4VYH+Aetse4bWBl0xFh6iQUnvxAgysGDEquwV6j0P3dT3vp0vH222qMYzUfk
         jajg9uMhTYBs4hefszNiGfvb0YnwukD6oZ2cwH/nCsapOVG/FxNBdAHHbvcYFNkmTTZO
         JACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718716667; x=1719321467;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EX24AlEN/UD/1l0F51YlU1CSwhLSmC3XywghaDbsT0o=;
        b=JAJyUYWEORb+esJ6vc1ccrL9H9O49JuPYsC7FdV7tRklkU96o7qvdSe4ZHYEtaXxZC
         iYcvutIqUK5SP8w+jJON1nKr1kr4bVLrQjRsJVe2MMbBwYfs2kPxbhBSkSQXUgTzwyyv
         PcVQuTPIs7wkfwAISbY2CK/JUQv8typX90CMJPqJeTrYIKs2cBCdMOyEDFv0rgSxjWn+
         xpRsbKmfx8S0JSK1GGsuWvXGzVSsI47PhZfWDcP6h1VW7CyYe0638I4Hkq3HPDi6qOt2
         Q95H9Wx5xyCvxRZW9NhOKjExIBnzKASnDZJ4vHh0bvjAl+6HQUD+gMs9gPyyVr1HHgV0
         qcCA==
X-Forwarded-Encrypted: i=1; AJvYcCUwAtaWZtxNRWVQEXxhS6xMf0RQ+cv2I2keJi7QorAM4EiNngdkQH7Y+fKrHvawW5JZHkAKJ0VrTQvofPXvSNy2ZDfD
X-Gm-Message-State: AOJu0YwmVB7kS0KjQ2KSnGng7YbQCjc5KD3fTKuDmdpWizEX+gL/qvuX
	HYvHCgEnsIruSycrYq2fnpq3MhnRqIgDTw7IyZYdekVybIbOzSi0y58A/DH308I=
X-Google-Smtp-Source: AGHT+IGua5x8LafWw9WAPWbl0CgAw6aLG0KZ4tYcFFaM48yEd4PyCk39eOdS5cDBR/nRMuyf+2cEOg==
X-Received: by 2002:a05:6512:60c:b0:52c:785f:ae23 with SMTP id 2adb3069b0e04-52ca6e65959mr7107247e87.24.1718716667581;
        Tue, 18 Jun 2024 06:17:47 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286eefa07sm228468645e9.8.2024.06.18.06.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 06:17:47 -0700 (PDT)
Message-ID: <54324a46-a196-4e6e-a623-b4bf39cbb5a6@suse.com>
Date: Tue, 18 Jun 2024 16:17:45 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] x86/virt/tdx: Start to track all global metadata in
 one structure
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <9759a946d7861821bf45c6bc73c9f596235087bc.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <9759a946d7861821bf45c6bc73c9f596235087bc.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sysinfo' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Class"es.  E.g.,
> the current TDMR related fields are under class "TDMR Info".  Instead of
> making 'struct tdx_sysinfo' a plain structure to contain all metadata
> fields, organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the current construct_tdmr() can just
> take the structure which contains "TDMR Info" metadata fields.
> 
> Start with moving 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo', and
> rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo_tdmr_info' to
> make it consistent with the "class name".
> 
> Add a new function get_tdx_sysinfo() as the place to read all metadata
> fields, and call it at the beginning of init_tdx_module().  Move the
> existing get_tdx_tdmr_sysinfo() to get_tdx_sysinfo().
> 
> Note there is a functional change: get_tdx_tdmr_sysinfo() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.

Why? I don't see build_tdx_memlist() using any tdmr data.

> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

This patch semantically does 3 independent things :

1. Renames tdx_tdmr_sysinfo to tdx_sysinfo_tdmr_info
2. Introduces tdx_sysinfo and puts the aforementioned struct in it.
3. Moves get_tdx_tdmr_sysinfo

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 29 +++++++++++++++++------------
>   arch/x86/virt/vmx/tdx/tdx.h | 32 +++++++++++++++++++++++++-------
>   2 files changed, 42 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fad42014ca37..4683884efcc6 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -320,11 +320,11 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>   }
>   
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
> -	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
>   
> -static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>   {
> -	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +	/* Map TD_SYSINFO fields into 'struct tdx_sysinfo_tdmr_info': */
>   	static const struct field_mapping fields[] = {
>   		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
>   		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> @@ -337,6 +337,11 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
>   }
>   
> +static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)

What's the point of this function, directly calling 
get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info); isn't any less obvious.

> +{
> +	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
> +}
> +
>   /* Calculate the actual TDMR size */
>   static int tdmr_size_single(u16 max_reserved_per_tdmr)
>   {

<snip>

