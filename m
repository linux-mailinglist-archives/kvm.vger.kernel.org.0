Return-Path: <kvm+bounces-19854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2666790CA46
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EE261C23106
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277272139DC;
	Tue, 18 Jun 2024 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Isz7OeaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5754D50282
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 11:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718709788; cv=none; b=nGt9DDUVXQK3Jv3vqwituyORukN3+vWH0xuaj0SP8IESzPSjZfGNTA1azHL+cWt02/mLcrmtKoo+ALXmFWVOsnIeaWvjXYZiwHB/5SU4dEmzB39AoVB1DR660XXCikjiSsP78y7vdPX3yHTieNvDH3vaAKLIFy1yEvJGY7rTT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718709788; c=relaxed/simple;
	bh=hBpWJYugKdNSKxyYJn3C5KoKYpJ9D3LPCkWwDgEO9/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFArQbMTXGLjdgrnLd38BxrR5vmjXNQ11L1OUFedZMnBpfq6yfTt6gF2RpWfG3IiVt+8o0Lm0AkRdbkPCkM3Oy1hlJE0bA42A9nDX8tWUESCJ1yK/0DkKcy8xbcCyy0jmywMzFjAUvcKqBSSMX4MH96lNqZiccxXadhkylXGDLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Isz7OeaE; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-421757d217aso55927545e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 04:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718709784; x=1719314584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p+gOrsYfZ1800/8WN41PXukGPtARa5FK/2D6JnB2So4=;
        b=Isz7OeaEf8tNDtl474xxYZPziImk4+dHoAWNXDDRj1DLTgRNuZd/J/Q3CtxOWQ9T+k
         /CELC+0b8jl8E2eVj6eDw8K9WxMcnLg6fIp1zluGsrpSF51GEDnWeH5oRasU7qG2tPs+
         jSp81zPd1rrS8+EilTuctek0uLgCxHoDjXq9U7LUR89tK12E4j8pwXtkqwE2q5ibgIW+
         sTPLthQT6TWJuNhnDGwaGLWzy9etBPGKHpGfse8vzIhBRCX9sD4nDejW1KqjHDHv6cgq
         S3G/L790Nl5HUd9m22+BKTRNR4tLVbf44q609ZjmWVqOuK8Dk23V7nHfIJRGZyW8CN9o
         izHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718709784; x=1719314584;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+gOrsYfZ1800/8WN41PXukGPtARa5FK/2D6JnB2So4=;
        b=TsEkrdFzBG2F+b1WEz+IZz7gKkirbkJOyu1psJjaXsgiB9Qjpy7faZQ8wFpeRirFBv
         Mna9FHYohNr7TSK61vUyb0913eObdJRRutjfZpNzAIC16aVbj1obkhBrl6lSoiQyqJ7F
         XKYChj9y91AtAscp9Uf6YUpeIX9qVtv0gCG9DeoDTMT7mV53kSB0K5DYiPUzi0xq2m12
         BSHDU/i1QySN0othRcrQqMYThMztgXj3qDZj0PUlLU+hfWDMy/SS5ek6t7Icq5Jz+cpU
         8E+Oyrnx80Pqaq7AM+JQfGiTprSa9w87f46+9FvG1hSVdz6V7Gdy0NrwlaE+Jaao9R6g
         5qVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVp6R5Se90fopvnWotbbq92e7SZMK9Jm1phmRXXaFAbT9F9LE6XNM9x0NA8Ctu35HfPvyT3oRZrlGVy1dixlKlqzn12
X-Gm-Message-State: AOJu0YzQRIuJjbfhLFa/+pF1tsjfvfebFtPWyMhNYRGjyMWXFDVPbpDe
	dDvfvrErSoVGJ2/zM4G8Wkn9Ajsq+MXXdX7c68vubtJ+XkYDQp7WXA0LcxTFgtY=
X-Google-Smtp-Source: AGHT+IFbHBOxdj+EyogloHZITbETnHDbNwOzEMhz9fPXZyk1bg960ZHujEj16MMpnU24bHjMrWbEEA==
X-Received: by 2002:a05:600c:4f07:b0:421:7e19:5afa with SMTP id 5b1f17b1804b1-42304844b70mr125884405e9.30.1718709783622;
        Tue, 18 Jun 2024 04:23:03 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422f5f33bdasm188191855e9.8.2024.06.18.04.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 04:23:03 -0700 (PDT)
Message-ID: <6fd59803-252d-4126-91de-e65908fca602@suse.com>
Date: Tue, 18 Jun 2024 14:23:01 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <43c646d35088a0bada9fbbf8b731a7e4a44b22c0.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <43c646d35088a0bada9fbbf8b731a7e4a44b22c0.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
> module, and the metadata reading code can only work with that structure.
> 
> Future changes will need to read other metadata fields that don't make
> sense to populate to the "struct tdx_tdmr_sysinfo".  It's essential to
> provide a generic metadata read infrastructure which is not bound to any
> specific structure.
> 
> To start providing such infrastructure, unbind the metadata reading code
> with the 'struct tdx_tdmr_sysinfo'.
> 
> Note the kernel has a helper macro, TD_SYSINFO_MAP(), for marshaling the
> metadata into the 'struct tdx_tdmr_sysinfo', and currently the macro
> hardcodes the structure name.  As part of unbinding the metadata reading
> code with 'struct tdx_tdmr_sysinfo', it is extended to accept different
> structures.
> 
> Unfortunately, this will result in the usage of TD_SYSINFO_MAP() for
> populating 'struct tdx_tdmr_sysinfo' to be changed to use the structure
> name explicitly for each structure member and make the code longer.  Add
> a wrapper macro which hides the 'struct tdx_tdmr_sysinfo' internally to
> make the code shorter thus better readability.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fbde24ea3b3e..854312e97eff 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -272,9 +272,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>   
>   static int read_sys_metadata_field16(u64 field_id,
>   				     int offset,
> -				     struct tdx_tdmr_sysinfo *ts)
> +				     void *stbuf)
>   {
> -	u16 *ts_member = ((void *)ts) + offset;
> +	u16 *st_member = stbuf + offset;

This st_* prefix is completely arbitrary, Just name it "member" since 
this function can be used for any arbitrary member.

>   	u64 tmp;
>   	int ret;
>   

<snip>

