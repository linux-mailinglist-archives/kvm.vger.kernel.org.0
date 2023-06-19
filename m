Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C74735897
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 15:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjFSNbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 09:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjFSNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 09:30:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331F3E7D
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 06:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687181393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ehDF1EfqVpL/EjIHvvHkOTz1CnikocCQsrKsBdK85Eg=;
        b=h2tGtxiCS2dCo6r5V9C0KVV1SOLVxRiBvT1azW7z8U9TB/QeSakfSJc03v2HbcTdKKfhDN
        b6WxVynvAJ78YmgTYuacjfNS/XJm5d6cUrmByFPsgBWUInMM0CcpCMYOBV+r0ohx+Qwqoh
        Kkp1FOw81YENzMJPudZ6VFDQCKhyvgY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-8EAZKXm1O4mYp8-BEw78EQ-1; Mon, 19 Jun 2023 09:29:50 -0400
X-MC-Unique: 8EAZKXm1O4mYp8-BEw78EQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3111a458cfbso1380219f8f.2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 06:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687181390; x=1689773390;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ehDF1EfqVpL/EjIHvvHkOTz1CnikocCQsrKsBdK85Eg=;
        b=BCB4fySaqVALTQwjDCLYjObuWd3BnL7BiwS47OEsxNZj30aCLYQYHimNQ6ngb82miT
         PD8Q/SwKEQZGBxOV5/Ksr/JoHhOibStDHGQUF1XJYabj5eCcUTXAeDzalcBrtLbk3/g0
         9+FsrlrBPdGpvbPc+V1RzgTMWbhDZhZ/BkIofum658w1siIFsVfk0OPqdlQhdFATeHTX
         e03J1igrutY5GZqRBvUr/p9UL93WEdcMwMd6YOenaKvXsjBstAT+bTFL7uEu32XsuhiY
         kOR0dMigMRhGAkJHzIN5mySN8GD+UH8WDNeULnZn+W9ehXT2geGhRasSRfvRrwCsek1V
         5SIQ==
X-Gm-Message-State: AC+VfDyYAECcZdCoe4sWFlqBM16NgLLs08OSKkRVMOgYT3mXhwBGAiH8
        Oz3hdWxAWDPK2QDS0ZMFKQhWN4MTAOh0VFHCsTbRv63rkFZMcdhSjp0KTQV1V0R20gCFsdgWtpl
        MtIB4gow/qky7
X-Received: by 2002:adf:de8a:0:b0:30f:bc8f:6d49 with SMTP id w10-20020adfde8a000000b0030fbc8f6d49mr7989104wrl.13.1687181389689;
        Mon, 19 Jun 2023 06:29:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5gkXts3fBcO0DhPEqkdGGOMRJbBKr7VX2UJB4CAxFPZSuJglE6lxSJb6gTUvuXnBPXMkfpiA==
X-Received: by 2002:adf:de8a:0:b0:30f:bc8f:6d49 with SMTP id w10-20020adfde8a000000b0030fbc8f6d49mr7989087wrl.13.1687181389229;
        Mon, 19 Jun 2023 06:29:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72f:7100:cede:6433:a77b:41e9? (p200300cbc72f7100cede6433a77b41e9.dip0.t-ipconnect.de. [2003:cb:c72f:7100:cede:6433:a77b:41e9])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d6e0e000000b003078354f774sm31386031wrz.36.2023.06.19.06.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 06:29:48 -0700 (PDT)
Message-ID: <0d5d75ec-c7db-7546-80cb-e8755fc7cae0@redhat.com>
Date:   Mon, 19 Jun 2023 15:29:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
In-Reply-To: <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.23 16:27, Kai Huang wrote:
> Start to transit out the "multi-steps" to initialize the TDX module.
> 
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.
> 
> CMRs tell the kernel which memory is TDX compatible.  The kernel takes
> CMRs (plus a little more metadata) and constructs "TD Memory Regions"
> (TDMRs).  TDMRs let the kernel grant TDX protections to some or all of
> the CMR areas.
> 
> The TDX module also reports necessary information to let the kernel
> build TDMRs and run TDX guests in structure 'tdsysinfo_struct'.  The
> list of CMRs, along with the TDX module information, is available to
> the kernel by querying the TDX module.
> 
> As a preparation to construct TDMRs, get the TDX module information and
> the list of CMRs.  Print out CMRs to help user to decode which memory
> regions are TDX convertible.
> 
> The 'tdsysinfo_struct' is fairly large (1024 bytes) and contains a lot
> of info about the TDX module.  Fully define the entire structure, but
> only use the fields necessary to build the TDMRs and pr_info() some
> basics about the module.  The rest of the fields will get used by KVM.
> 
> For now both 'tdsysinfo_struct' and CMRs are only used during the module
> initialization.  But because they are both relatively big, declare them
> inside the module initialization function but as static variables.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---


[...]


> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 67 +++++++++++++++++++++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h | 72 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index bcf2b2d15a2e..9fde0f71dd8b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -20,6 +20,7 @@
>   #include <asm/msr-index.h>
>   #include <asm/msr.h>
>   #include <asm/archrandom.h>
> +#include <asm/page.h>
>   #include <asm/tdx.h>
>   #include "tdx.h"
>   
> @@ -191,12 +192,76 @@ int tdx_cpu_enable(void)
>   }
>   EXPORT_SYMBOL_GPL(tdx_cpu_enable);
>   
> +static inline bool is_cmr_empty(struct cmr_info *cmr)
> +{
> +	return !cmr->size;
> +}
> +

Nit: maybe it's just me, but this function seems unnecessary.

If "!cmr->size" is not expressive, then I don't know why "is_cmr_empty" 
should be. Just inline that into the single user.

.. after all the single caller also uses/prints cmr->size ...

> +static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_cmrs; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		/*
> +		 * The array of CMRs reported via TDH.SYS.INFO can
> +		 * contain tail empty CMRs.  Don't print them.
> +		 */
> +		if (is_cmr_empty(cmr))
> +			break;
> +
> +		pr_info("CMR: [0x%llx, 0x%llx)\n", cmr->base,
> +				cmr->base + cmr->size);
> +	}
> +}
> +
> +/*
> + * Get the TDX module information (TDSYSINFO_STRUCT) and the array of
> + * CMRs, and save them to @sysinfo and @cmr_array.  @sysinfo must have
> + * been padded to have enough room to save the TDSYSINFO_STRUCT.
> + */
> +static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
> +			   struct cmr_info *cmr_array)
> +{
> +	struct tdx_module_output out;
> +	u64 sysinfo_pa, cmr_array_pa;
> +	int ret;
> +
> +	sysinfo_pa = __pa(sysinfo);
> +	cmr_array_pa = __pa(cmr_array);
> +	ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
> +			cmr_array_pa, MAX_CMRS, NULL, &out);
> +	if (ret)
> +		return ret;
> +
> +	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",


"attributes" ?

> +		sysinfo->attributes,	sysinfo->vendor_id,
> +		sysinfo->major_version, sysinfo->minor_version,
> +		sysinfo->build_date,	sysinfo->build_num);
> +
> +	/* R9 contains the actual entries written to the CMR array. */
> +	print_cmrs(cmr_array, out.r9);
> +
> +	return 0;
> +}
> +
>   static int init_tdx_module(void)
>   {
> +	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
> +			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
> +	static struct cmr_info cmr_array[MAX_CMRS]
> +			__aligned(CMR_INFO_ARRAY_ALIGNMENT);
> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	int ret;
> +
> +	ret = tdx_get_sysinfo(sysinfo, cmr_array);
> +	if (ret)
> +		return ret;
> +
>   	/*
>   	 * TODO:
>   	 *
> -	 *  - Get TDX module information and TDX-capable memory regions.
>   	 *  - Build the list of TDX-usable memory regions.
>   	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
>   	 *    all TDX-usable memory regions.
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 9fb46033c852..97f4d7e7f1a4 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -3,6 +3,8 @@
>   #define _X86_VIRT_TDX_H
>   
>   #include <linux/types.h>
> +#include <linux/stddef.h>
> +#include <linux/compiler_attributes.h>
>   
>   /*
>    * This file contains both macros and data structures defined by the TDX
> @@ -21,6 +23,76 @@
>    */
>   #define TDH_SYS_INIT		33
>   #define TDH_SYS_LP_INIT		35
> +#define TDH_SYS_INFO		32
> +
> +struct cmr_info {
> +	u64	base;
> +	u64	size;
> +} __packed;
> +
> +#define MAX_CMRS			32
> +#define CMR_INFO_ARRAY_ALIGNMENT	512
> +
> +struct cpuid_config {
> +	u32	leaf;
> +	u32	sub_leaf;
> +	u32	eax;
> +	u32	ebx;
> +	u32	ecx;
> +	u32	edx;
> +} __packed;
> +
> +#define DECLARE_PADDED_STRUCT(type, name, size, alignment)	\
> +	struct type##_padded {					\
> +		union {						\
> +			struct type name;			\
> +			u8 padding[size];			\
> +		};						\
> +	} name##_padded __aligned(alignment)
> +
> +#define PADDED_STRUCT(name)	(name##_padded.name)
> +
> +#define TDSYSINFO_STRUCT_SIZE		1024

So, it can never be larger than 1024 bytes? Not even with many cpuid 
configs?

> +#define TDSYSINFO_STRUCT_ALIGNMENT	1024
> +

-- 
Cheers,

David / dhildenb

