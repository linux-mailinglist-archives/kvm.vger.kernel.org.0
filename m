Return-Path: <kvm+bounces-19857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E448890CB11
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBC75B27FFD
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB28115ECD6;
	Tue, 18 Jun 2024 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XySjWfI0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543ED159207
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718711278; cv=none; b=lVudwRZ/SO4fNSviPOjEKP1bcN9gQyCb7q3sTmjmnT0z8P1ASey08mT4vMW80/UMKmzrA7KfLktZQqpxdKVtNySZjSTSQiXgx5vrlJJe9mauRUAbPgN8p73KV7Eyxmlmz+JUj6vIyjttPbFQlX9OxjnQ3wMCsVwtTFjOVazp1KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718711278; c=relaxed/simple;
	bh=8KyRiP9WiflJYBT6I7DVWkR9yfJ2369HxCuvXgk0HaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIHJd0aD4QNHlNNLfeD4p1HNa5/exY1H5TosLq8W4DkJ+ZMTUq51n9h2Msym+zyvQZrI7w0a/IqlUv6kbs1l8zqGZBI68DvVW3znhT6OiM8/r6nxAQdw2Fv4BoNTZihlfDoKhWS0GCIqA1JpKivF8RYvv0D+1fVStcQARZ9exXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XySjWfI0; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3609e730be5so603991f8f.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 04:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718711274; x=1719316074; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jj10dJJU5AiMUvm3apxRXa89eKvzjsWdJm9QNQLwuKI=;
        b=XySjWfI0JFAe908m9JxgTa9lgi6dUd7GWYV7QS1T0shmFPmZ0n6R8ZXAGMpjMn+lJi
         hqvkf6WCsG+KCzM6heAQkdCb1edaW2udFcQIxKks3sjXvIErLTTzh32Stl6AxQ0rw3bq
         HJ9lY/khnxGlUzWQ52ScWnay/jAPgAGXS2Qi956D07RJXXe2HOkrq24iMYZ82vtVWK3C
         SlzWrg8eLYuKrd5o/d8sIZX9cYbqxO2+2WTiOjiJmDXCJICeouIZrQ8G/io9DLdZh7bH
         o8XoPpqjTxiayXGT9trKNELfxhvDYzbl/SyDhNqBhZmzxG4f4x3+fuHLaN8Hfbt4t2BQ
         rjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718711274; x=1719316074;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jj10dJJU5AiMUvm3apxRXa89eKvzjsWdJm9QNQLwuKI=;
        b=c0K42fPa5FCFoaLjbKxYZoOkqElNCOAsGETHn2XbzItPeSj7huO6zVHrCPsPCZjtH7
         CzV1eW1aEySym2ZZ96oqpqBveRk04RyZifJjzP1CtCSo8jlQwGzdPKlKomXpZzmWVn5L
         TM7ZklYXP7ENRXoREGJ+lW4DpxguMhNK6XZuna1XVpmRve9x311+FoOqfYK2g4MXGpQV
         +uBIFAXDVwySaQHdK+32Jb3y/l0i37af0s5XenEbTD3W/WOZBF98VWYd8l7Wh1fzKgoO
         jt+26Zr9nsM0vA1nQD/WMfPhh4Q9ftEB7Vgo/miT260oxFhXLIhrtoBuf0Dt1bP6J/BT
         LvZA==
X-Forwarded-Encrypted: i=1; AJvYcCV3Te36fBgQsNG9i6RvjkVMcnJX92C5q8QfG3gBncZROA/XtjBdNe10zGW8eZd3YMV87Mr5wlqqpnpjIi4YeOAJHnE6
X-Gm-Message-State: AOJu0YynXY1xT+NR5yRPX+9Sg2xmRJ+h/v28z4jpqPUXDycpX+4fCxIR
	iYbJ6mlcHiFn1o90VssxiQ2V6tPafvc5RkTsPXD7KX08zowWfoqKIcHU2VRU08Y=
X-Google-Smtp-Source: AGHT+IEvhOi7L2z1SD6V9koNWqnqqSQTRIPdrtKihELObJMqBmi0jvkkLHYN9A/aGRpCNMMLv871Cw==
X-Received: by 2002:adf:f30b:0:b0:360:9500:9bbb with SMTP id ffacd0b85a97d-3609ea67f75mr2215637f8f.12.1718711273674;
        Tue, 18 Jun 2024 04:47:53 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-361a85074a2sm1388769f8f.25.2024.06.18.04.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 04:47:53 -0700 (PDT)
Message-ID: <e79e8576-1cdd-468f-9ee8-5543b8c6b1d5@suse.com>
Date: Tue, 18 Jun 2024 14:47:51 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] x86/virt/tdx: Move field mapping table of getting
 TDMR info to function local
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <c7d85f753172f16238b6b3c9cdb4acf8cbd7bfe6.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <c7d85f753172f16238b6b3c9cdb4acf8cbd7bfe6.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
> module.  The kernel populates the relevant metadata fields into the
> structure using a "field mapping table" of metadata field IDs and the
> structure members.
> 
> Currently the scope of this "field mapping table" is the entire C file.
> Future changes will need to read more global metadata fields that will
> be organized in other structures and use this kind of field mapping
> tables for other structures too.
> 
> Move the field mapping table to the function local to limit its scope so
> that the same name can also be used by other functions.

nit: I think all of this could be condensed simply to :

"The mapping table is only used by foo() so move it there, no functional 
changes". The consideration for future usage seems somewhat moot with 
respect to such a trivial change. In any case:

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>


> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c68fbaf4aa15..fad42014ca37 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -322,17 +322,17 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
>   
> -/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> -static const struct field_mapping fields[] = {
> -	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
> -	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> -};
> -
>   static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>   {
> +	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> +	};
> +
>   	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
>   	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
>   }

