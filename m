Return-Path: <kvm+bounces-19855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB57890CA9E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93578289476
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056421586C7;
	Tue, 18 Jun 2024 11:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vx/Ymzmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD21586DB
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 11:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718710945; cv=none; b=TON3Ex0+oG3OiUNi0KqKToKjdNOUuD1YlRMciaDqE5Tyq2JrxiQkhsY3u0O3OAFH0JTCax6VarIGFVQ5PEiLWA0i2v48gDulFemRO3w0Bi64NJD076/SoxeYL8x1DchPyJwxxpAv+Pye2BWJGTgUboXsZ4KbgG7HqH9qROIYU1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718710945; c=relaxed/simple;
	bh=Pv9YG5VmtMAr1ULh/ECdcRJmYzVUxCUyifaRaj0QWRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzIBfh/hD2O+B8jNv494dbsME46cTRldu2vTahLXfPNw5Ud8Gqxyi2AvasywfAf5MrGLdnzsDsPFnIS1jAldRG/fwuqCcdD9yapainPFTKTH+aauKsfl88o3vmI8SsFeg+Zbg21oMXhCtnPu6UyjRe/Kxto+rXb2HStdorl0Kpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vx/Ymzmc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42198492353so40494495e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 04:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718710941; x=1719315741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f7UmkjiJBk958rN0+3CFAHXb73T4tiq+66V/cS7zu0M=;
        b=Vx/Ymzmcf7iz53Bu2Zmd1c14yJxA/bpGABPuE4h8AtVXYg+ffJkRnrtSmPpIGar3lT
         TTNQlEDjDm9bGFYyJpRUlakhinCuMVbPIyU27xzq+D7Q3DQItqWlf0OMt06EJBF97WSZ
         hPdM2mKw4zyw2RwLJnrNfZt0cB/xP+bn29xfo5Nsee4Dx0uhprZ7GVTGlge4lJyXVMnl
         bN8TpDyVK7xmEwFsy0G6NMwTvtkOsVonzDXuapkHX1fSCuj5Wn+zv6pn2a8zKz7UBoHD
         FF58tuvgXw6c4uO20JGEycVO3ja4wfhKVyteS8oN+G9ZsOGcmf4moKEyU41wsv3rNunU
         WLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718710941; x=1719315741;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7UmkjiJBk958rN0+3CFAHXb73T4tiq+66V/cS7zu0M=;
        b=SZm3vyUJbs5BfQrGIKIGwVUk7yIJUB9scC4hk8WtmHroSt7tFJ5MXSSIUkb/rfjq4z
         JoqMLBV8gOuIaFWBDUhjHC1LbMuv39V0qLoqrXN334+00wOKykF/ogYlGf1xdeyvQEIE
         pNTYk4yzTG3TWPLd+V7jY3C/RJ9m0Wp8kzkrJba7uBk0QOOrdCkelMwiccsMNEJjBIeH
         2KzTVtJ9sS/Uel9zDWp696BZt3qj2JHKhtuS8KK7JJNGBPDOa9g13hFyzE0lCbRU3atV
         qlip1ZfQwRCKZWVa6eN/vd3x5DN/LnELc7QmfXixEgg6lxp6ANvn8XlZlfQeemyJf6SZ
         XROQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCd33E0pBsMfjE+7h7C19uIZ3sqTx8ARcTTPTcpRsD163L2semABehqE3/cIA4g43mOnZGc6BcBeynCZbNKDFMbfmO
X-Gm-Message-State: AOJu0YwgPiZsgu4x3aLYCC86bITz9uARY19l96qjWgOB0UxXGW2QuLeh
	spwlkM1G7PZd1F/+LqYzwoe1A72piUXiWZGY2VOjqr+3aHlFxFajeTBBmAjbnzU=
X-Google-Smtp-Source: AGHT+IGybvnpNsXwNwdYnMA93MRhlhEbgIgkEd2VLdninN0UheKxGBH+tOGStyLG2+JGR2GxN7v2TQ==
X-Received: by 2002:a05:600c:1553:b0:422:1609:a7db with SMTP id 5b1f17b1804b1-42304822a02mr96279175e9.8.1718710940945;
        Tue, 18 Jun 2024 04:42:20 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-360750ad082sm13780507f8f.59.2024.06.18.04.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 04:42:20 -0700 (PDT)
Message-ID: <a7552693-e0df-4225-9cbf-a5f482900626@suse.com>
Date: Tue, 18 Jun 2024 14:42:19 +0300
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
Content-Transfer-Encoding: 7bit

<snip>

>   
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     void *stbuf)
> +/*
> + * Read one global metadata field and store the data to a location of a
> + * given buffer specified by the offset and size (in bytes).
> + */
> +static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,

read_system_metadat_field or read_sys_metadata_field or simply
read_metadata_field

> +				  int bytes)
s/bytes/size
>   {
> -	u16 *st_member = stbuf + offset;
> +	void *st_member = stbuf + offset;

Again, this could be renamed to just 'member', what value does the 'st' 
prefix bring?

>   	u64 tmp;
>   	int ret;
>   
> -	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT))
> +	if (WARN_ON_ONCE(MD_FIELD_BYTES(field_id) != bytes))
>   		return -EINVAL;
>   
>   	ret = read_sys_metadata_field(field_id, &tmp);
>   	if (ret)
>   		return ret;
>   
> -	*st_member = tmp;
> +	memcpy(st_member, &tmp, bytes);
>   
>   	return 0;
>   }
> @@ -294,11 +296,13 @@ static int read_sys_metadata_field16(u64 field_id,
>   struct field_mapping {
>   	u64 field_id;
>   	int offset;
> +	int size;
>   };
>   
> -#define TD_SYSINFO_MAP(_field_id, _struct, _member)	\
> -	{ .field_id = MD_FIELD_ID_##_field_id,		\
> -	  .offset   = offsetof(_struct, _member) }
> +#define TD_SYSINFO_MAP(_field_id, _struct, _member)		\
> +	{ .field_id = MD_FIELD_ID_##_field_id,			\
> +	  .offset   = offsetof(_struct, _member),		\
> +	  .size	    = sizeof(typeof(((_struct *)0)->_member)) }
>   
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
> @@ -319,9 +323,8 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   
>   	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
>   	for (i = 0; i < ARRAY_SIZE(fields); i++) {
> -		ret = read_sys_metadata_field16(fields[i].field_id,
> -						fields[i].offset,
> -						tdmr_sysinfo);
> +		ret = stbuf_read_sysmd_field(fields[i].field_id, tdmr_sysinfo,
> +				fields[i].offset, fields[i].size);
>   		if (ret)
>   			return ret;
>   	}
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index b701f69485d3..812943516946 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -53,7 +53,8 @@
>   #define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
>   		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
>   
> -#define MD_FIELD_ID_ELE_SIZE_16BIT	1
> +#define MD_FIELD_BYTES(_field_id)	\

Just name it MD_FIELD_SIZE, even the MD_FIELD_ID member is called 
ELEMENT_SIZE_CODE, rather than ELEMENT_BYTES_CODE or some such.

> +		(1 << MD_FIELD_ID_ELE_SIZE_CODE(_field_id))
>   
>   struct tdmr_reserved_area {
>   	u64 offset;

