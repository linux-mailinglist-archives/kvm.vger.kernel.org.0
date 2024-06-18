Return-Path: <kvm+bounces-19863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D194690D3A8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D77C21C246DB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49098139584;
	Tue, 18 Jun 2024 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FPtT5eS7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF89A13790B
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718718743; cv=none; b=NFcYYfCWVnc2REW7dJVWjgUzA6wmZcLhHUoNZWZ/Z8C9pMi2qFxgs+H+OzTJ/xBjjyjWMQpaZsAohUFmlLUxQN+JXf8g9X13P9lW308RshHu19o+u2WGznOceOf5920txSMG8zykW6qXEzCkk6yl6JNVWvnWkJo6yh9IOulXmX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718718743; c=relaxed/simple;
	bh=6ji8bImoZphxUZlGZKL5B1WUGYaN4s5foLziwZaot34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqlx4JZtrFz6ZwGTHoYbTtBn229psT2/uTHklEkP8cT8Hg8CrY94yJBr+u7DSwBA4lNAQB3RYKZum9+GxBCrU3PX9rwPAGp0ElShrqiDhbwH04ePZZowYsnB4JNaSOuzE8uNpmmuHR//vwMgYBn3SvUN6Hxof+0PB+vuBnCZpAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FPtT5eS7; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4217a96de38so39745565e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 06:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718718739; x=1719323539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bif8Dk+Gwh0B8c6YxRG9d+wF5fvhza7hN5IkBJa7yMQ=;
        b=FPtT5eS7VaBp1OsTq1Gn2QLj26RqbM5j7uK95ArK9+pU8tvlyUH/xv5n5GOmll0jFD
         8/VOnv4VrDc+5T05UMlzD393YFtmRRi14R5d/W/a3HGL28MH6WPNdt6KHd1WvbGD55ev
         QkQrRXaqzwr1gNxJU511SUtqHLonAbIekedWlJsf1vIJ+U8YUxIhgGekmtgE/hcxsmj/
         3qBoZrn3HtmB4BxIyUHKS62bJc5OO5VJpGT574zcABs6q5k0bOVB9n8MK4F8e1o69fEb
         GJ/82CbD8B7FzD1B9H6QXu+2gtZH04C1rStwGCZLjvP6s+D1URFP68xzxjzFddgJfhLK
         xNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718718739; x=1719323539;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bif8Dk+Gwh0B8c6YxRG9d+wF5fvhza7hN5IkBJa7yMQ=;
        b=cjGD6ZN8qP3f6mp8/PVw550+zPnuEfKC18Hm9rwISusJasS7NtN1+o7HcvWLhaToXB
         49bgsa0PKyIkVUd5FgK1EQ0bBIa4rN5HKU7vFacZRT9wzfKF8/rwRk4Ogh+3GRP+6vJ4
         DmH3qRxrxxetZd7LwPmLA5Y1y0oPzkJXAezBCt4VukDtWXPxgKUdEs61CsozAFi65qBS
         Xi3Gpm/poDqMlMiqXuzgJmhPQFGJSQ5p7SXQO0A6F9qogBDa7GJM7Mtwuz3BmyWWR3mp
         Lg/rvximFlbldiSJqFeGeQkLsVouKHkMte2VnFDY/xG0lDxZt4u8yrdIDUBPikqqttvV
         Toxg==
X-Forwarded-Encrypted: i=1; AJvYcCWze1hP8sxuph0Uv6sQ1YT/0RlaK9dWLIWk9xtNiofV6R0v0pPtVzo1Kq3KKpl7feyHdR9srDmA/I8Tjz+kWEORWPf5
X-Gm-Message-State: AOJu0Yxc/P2P0AfAfY3L2f3D9sV2yzu8RqZcZ9dLcAkA8VVsJv++ZWRP
	JE6InGxzsshjnCw53VWqrhzKlpx5DI7TeOq/AyiLpQ5kzNru0eZ+eF0b+o6d1wg=
X-Google-Smtp-Source: AGHT+IGe9QQWwMJrGfB2O4fZVYflKAtUzGz49+pn9fRyvLAyJPHj5WAU6UpUgoQ9tXE7ZmEhXmLKpA==
X-Received: by 2002:a05:600c:3d88:b0:422:dfb0:8644 with SMTP id 5b1f17b1804b1-4230484918cmr104030475e9.33.1718718739242;
        Tue, 18 Jun 2024 06:52:19 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422f5f33bcfsm186576125e9.1.2024.06.18.06.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 06:52:18 -0700 (PDT)
Message-ID: <d8b657a4-ab2d-417e-be24-cbbd7ce99380@suse.com>
Date: Tue, 18 Jun 2024 16:52:17 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] x86/virt/tdx: Print TDX module basic information
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <f81ed362dcb88bdb60859b998d5b9a4ee258a5f3.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <f81ed362dcb88bdb60859b998d5b9a4ee258a5f3.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> Currently the kernel doesn't print any information regarding the TDX
> module itself, e.g. module version.  Printing such information is not
> mandatory for initializing the TDX module, but in practice such
> information is useful, especially to the developers.

It's understood that it's not mandatory to print any information, just 
remove this sentence and leave the "In practice such...."

> 
> For instance, there are couple of use cases for dumping module basic
> information:
> 
> 1) When something goes wrong around using TDX, the information like TDX
>     module version, supported features etc could be helpful [1][2].
> 
> 2) For Linux, when the user wants to update the TDX module, one needs to
>     replace the old module in a specific location in the EFI partition
>     with the new one so that after reboot the BIOS can load it.  However,
>     after kernel boots, currently the user has no way to verify it is
>     indeed the new module that gets loaded and initialized (e.g., error
>     could happen when replacing the old module).  With the module version
>     dumped the user can verify this easily.
> 
> So dump the basic TDX module information:
> 
>   - TDX module type: Debug or Production.
>   - TDX_FEATURES0: Supported TDX features.
>   - TDX module version, and the build date.
> 
> And dump the information right after reading global metadata, so that
> this information is printed no matter whether module initialization
> fails or not.

Instead of printing this on 3 separate rows why not print something like:

"Initialising TDX Module $NUMERIC_VERSION ($BUILD_DATE 
$PRODUCTION_STATE), $TDX_FEATURES"

That way:
a) You convey the version information
b) You explicitly state that initialisation has begun and make no 
guarantees that because this has been printed the module is indeed 
properly initialised. I'm thinking if someone could be mistaken that if 
this information is printed this surely means that the module is 
properly working, which is not the case.



> 
> The actual dmesg will look like:
> 
>    virt/tdx: Production module.
>    virt/tdx: TDX_FEATURES0: 0xfbf
>    virt/tdx: Module version: 1.5.00.00.0481, build_date: 20230323
> 
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 67 +++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h | 33 +++++++++++++++++-
>   2 files changed, 99 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4683884efcc6..ced40e3b516e 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -319,6 +319,61 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>   	return 0;
>   }
>   
> +#define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_info, _member)

What's the point of this define, simply use the raw TD_SYSINFO_MAP 
inside the respective function. It doesn't really add any value 
especially everything is encapsulated in one function. Literally you add 
it so that you don't have to type "struct tdx_sysinfo_module_info" on 
each of the 2 lines this define is used...

> +
> +static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
> +{
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes),
> +		TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0),
> +	};
> +
> +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modinfo);
> +}
> +
> +#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_version, _member)

DITTO

> +
> +static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
> +{
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major),
> +		TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor),
> +		TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update),
> +		TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal),
> +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num),
> +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date),
> +	};
> +
> +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
> +}
> +
> +static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
> +{
> +	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
> +	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
> +	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;
> +
> +	pr_info("%s module.\n", debug ? "Debug" : "Production");
> +
> +	pr_info("TDX_FEATURES0: 0x%llx\n", modinfo->tdx_features0);
> +
> +	/*
> +	 * TDX module version encoding:
> +	 *
> +	 *   <major>.<minor>.<update>.<internal>.<build_num>
> +	 *
> +	 * When printed as text, <major> and <minor> are 1-digit,
> +	 * <update> and <internal> are 2-digits and <build_num>
> +	 * is 4-digits.
> +	 */
> +	pr_info("Module version: %u.%u.%02u.%02u.%04u, build_date: %u\n",
> +			modver->major,		modver->minor,
> +			modver->update,		modver->internal,
> +			modver->build_num,	modver->build_date);
> +}
> +
>   #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>   	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
>   
> @@ -339,6 +394,16 @@ static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>   
>   static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
>   {
> +	int ret;
> +
> +	ret = get_tdx_module_info(&sysinfo->module_info);
> +	if (ret)
> +		return ret;
> +
> +	ret = get_tdx_module_version(&sysinfo->module_version);
> +	if (ret)
> +		return ret;
> +
>   	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
>   }
>   
> @@ -1121,6 +1186,8 @@ static int init_tdx_module(void)
>   	if (ret)
>   		return ret;
>   
> +	print_basic_sysinfo(&sysinfo);
> +
>   	/*
>   	 * To keep things simple, assume that all TDX-protected memory
>   	 * will come from the page allocator.  Make sure all pages in the
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 6b61dc67b0af..d80ec797fbf1 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -31,6 +31,15 @@
>    *
>    * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
>    */

nit:

[Not related to this patch but still a problem in its own]

Those fields are defined in the global_metadata.json which is part of 
the  "Intel TDX Module v1.5 ABI Definitions" and not the 1.5 ABI spec, 
as the ABI spec is the pdf.

> +#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
> +#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
> +#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
> +#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
> +#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
> +#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
> +#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
> +#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
> +
>   #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>   #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
>   #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
> @@ -124,8 +133,28 @@ struct tdmr_info_list {
>    *
>    * Note not all metadata fields in each class are defined, only those
>    * used by the kernel are.
> + *
> + * Also note the "bit definitions" are architectural.
>    */
>   
> +/* Class "TDX Module Info" */
> +struct tdx_sysinfo_module_info {
> +	u32 sys_attributes;
> +	u64 tdx_features0;
> +};
> +
> +#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
> +
> +/* Class "TDX Module Version" */
> +struct tdx_sysinfo_module_version {
> +	u16 major;
> +	u16 minor;
> +	u16 update;
> +	u16 internal;
> +	u16 build_num;
> +	u32 build_date;
> +};
> +
>   /* Class "TDMR Info" */
>   struct tdx_sysinfo_tdmr_info {
>   	u16 max_tdmrs;
> @@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
>   };
>   
>   struct tdx_sysinfo {
> -	struct tdx_sysinfo_tdmr_info tdmr_info;
> +	struct tdx_sysinfo_module_info		module_info;
> +	struct tdx_sysinfo_module_version	module_version;
> +	struct tdx_sysinfo_tdmr_info		tdmr_info;
>   };
>   
>   #endif

