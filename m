Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481C16BCFDB
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCPMtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCPMtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:49:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D9A21950
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678970939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wep6XHXzYN0UhAG1ks9ds3OGXXSxIe57lGj0K9uT3Fc=;
        b=Vle8/4TUU+epbXvqds35G9uE50id3ySl4WYdZFnouIpJNdfBHCjB+B434K3ZhMFqkl5qgA
        M01e2K2YrapVzSnJY/FDuPaCuiATYx2XqkNJRA7Y2VzXY+qD0fBz6ULq6s5kLnC+c05OUc
        cE0+7y3JCshYPJYW3lLALcnaIJrYAYg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-Min9RGxbMdCZ4BjpHi6JRQ-1; Thu, 16 Mar 2023 08:48:57 -0400
X-MC-Unique: Min9RGxbMdCZ4BjpHi6JRQ-1
Received: by mail-wm1-f72.google.com with SMTP id bd27-20020a05600c1f1b00b003ed5cf99f0cso580377wmb.1
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678970936;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wep6XHXzYN0UhAG1ks9ds3OGXXSxIe57lGj0K9uT3Fc=;
        b=4ZtL9b/FYMdicxjBQOp9wUx9x7EzlEAkR7kwUm53yOOwjnHcjG1vnZGyoDE5ipYCFQ
         OcqYCWVt8lVcJmdNDteAjXV+P7UySpo5bC8ai03raJEXdKaICIxCtBr0R22mm68CTw33
         Bmus0yFLJxFbi50pQYHZmpRdT6W4B48RVTpjuiJ3xeDmSmXBox4CfuH/K60b+k9hb59Y
         R/akkJtmL2G5WVsrScuAU9DdBPpLyR+vWjNnRhna+VMFSk/5Vv4evKLrNys5tqIss+Jt
         TmuCvB+UTyJTC1S24Zp3jG08kkPCTzeZMyoBWvh0crbGuMBo8v9XZS5gi0XZecQUcGqj
         jrpg==
X-Gm-Message-State: AO0yUKVVoHEF3TUpmCgftLE0sY+l3el9WqbLyGYQQUEvb8vzD+wvKMaC
        vef9PFkAing6tEoIL3BI275DSpHMJslwvyApWjb8gof09v9JC0/+SzQ2r7XBTGRrTPucZQ1+jm7
        i81fxuWgAJBFU
X-Received: by 2002:a05:6000:1109:b0:2ce:aa62:ff73 with SMTP id z9-20020a056000110900b002ceaa62ff73mr4500580wrw.54.1678970936320;
        Thu, 16 Mar 2023 05:48:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set9F8FY56GyHEMl2L8uie+xP3SHy7uoJAaOPrsQGYeCNBSq+KiOqmz4HY4GTIvLIKRLlytqolQ==
X-Received: by 2002:a05:6000:1109:b0:2ce:aa62:ff73 with SMTP id z9-20020a056000110900b002ceaa62ff73mr4500548wrw.54.1678970935961;
        Thu, 16 Mar 2023 05:48:55 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id d12-20020a056000114c00b002c6d0462163sm7162991wrx.100.2023.03.16.05.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:48:55 -0700 (PDT)
Message-ID: <90f6a15c-0dec-4a19-7a21-b18b73932a21@redhat.com>
Date:   Thu, 16 Mar 2023 13:48:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1678111292.git.kai.huang@intel.com>
 <35a2421ca97d9e8dd938dcd744674602f4faa617.1678111292.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
In-Reply-To: <35a2421ca97d9e8dd938dcd744674602f4faa617.1678111292.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.03.23 15:13, Kai Huang wrote:
> Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  A CPU-attested software module
> called 'the TDX module' runs inside a new isolated memory range as a
> trusted hypervisor to manage and run protected VMs.
> 
> Pre-TDX Intel hardware has support for a memory encryption architecture
> called MKTME.  The memory encryption hardware underpinning MKTME is also
> used for Intel TDX.  TDX ends up "stealing" some of the physical address
> space from the MKTME architecture for crypto-protection to VMs.  The
> BIOS is responsible for partitioning the "KeyID" space between legacy
> MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
> KeyIDs' or 'TDX KeyIDs' for short.
> 
> TDX doesn't trust the BIOS.  During machine boot, TDX verifies the TDX
> private KeyIDs are consistently and correctly programmed by the BIOS
> across all CPU packages before it enables TDX on any CPU core.  A valid
> TDX private KeyID range on BSP indicates TDX has been enabled by the
> BIOS, otherwise the BIOS is buggy.

So we don't trust the BIOS, but trust the BIOS that it won't hot-remove 
physical memory or hotplug physical CPUS (if I understood the cover 
letter correctly)? :)

> 
> The TDX module is expected to be loaded by the BIOS when it enables TDX,
> but the kernel needs to properly initialize it before it can be used to
> create and run any TDX guests.  The TDX module will be initialized by
> the KVM subsystem when KVM wants to use TDX.
> 
> Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
> private KeyIDs.  Also add a function to report whether TDX is enabled by
> the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
> cache flush is needed.
> 
> The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
> to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
> own protection.  Just use the first TDX KeyID as the global KeyID and
> leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
> disable TDX as initializing the TDX module alone is useless.

Does that really happen in practice that we care about that at all? 
Seems weird and rather like a broken firmware or sth like that ...

> 
> To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
> TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
> to opt-in TDX host kernel support (to distinguish with TDX guest kernel
> support).  So far only KVM uses TDX.  Make the new config option depend
> on KVM_INTEL.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


[...]

> ---
>   arch/x86/Kconfig                 |  12 ++++
>   arch/x86/Makefile                |   2 +
>   arch/x86/include/asm/msr-index.h |   3 +
>   arch/x86/include/asm/tdx.h       |   7 +++
>   arch/x86/virt/Makefile           |   2 +
>   arch/x86/virt/vmx/Makefile       |   2 +
>   arch/x86/virt/vmx/tdx/Makefile   |   2 +
>   arch/x86/virt/vmx/tdx/tdx.c      | 105 +++++++++++++++++++++++++++++++
>   8 files changed, 135 insertions(+)
>   create mode 100644 arch/x86/virt/Makefile
>   create mode 100644 arch/x86/virt/vmx/Makefile
>   create mode 100644 arch/x86/virt/vmx/tdx/Makefile
>   create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3604074a878b..fc010973a6ff 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1952,6 +1952,18 @@ config X86_SGX
>   
>   	  If unsure, say N.
>   
> +config INTEL_TDX_HOST
> +	bool "Intel Trust Domain Extensions (TDX) host support"
> +	depends on CPU_SUP_INTEL
> +	depends on X86_64
> +	depends on KVM_INTEL
> +	help
> +	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> +	  host and certain physical attacks.  This option enables necessary TDX
> +	  support in host kernel to run protected VMs.

s/in host/in the host/ ?

Also, is "protected VMs" the right term to use here? "Encrypted VMs", 
"Confidential VMs" ... ?

> +
> +	  If unsure, say N.
> +
>   config EFI
>   	bool "EFI runtime service support"
>   	depends on ACPI
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 9cf07322875a..972b5a64ce38 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -252,6 +252,8 @@ archheaders:
>   
>   libs-y  += arch/x86/lib/
>   
> +core-y += arch/x86/virt/
> +
>   # drivers-y are linked after core-y
>   drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
>   drivers-$(CONFIG_PCI)            += arch/x86/pci/
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 37ff47552bcb..952374ddb167 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -512,6 +512,9 @@
>   #define MSR_RELOAD_PMC0			0x000014c1
>   #define MSR_RELOAD_FIXED_CTR0		0x00001309
>   
> +/* KeyID partitioning between MKTME and TDX */
> +#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
> +
>   /*
>    * AMD64 MSRs. Not complete. See the architecture manual for a more
>    * complete list.
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 25fd6070dc0b..4dfe2e794411 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -94,5 +94,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>   	return -ENODEV;
>   }
>   #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +bool platform_tdx_enabled(void);
> +#else	/* !CONFIG_INTEL_TDX_HOST */
> +static inline bool platform_tdx_enabled(void) { return false; }
> +#endif	/* CONFIG_INTEL_TDX_HOST */
> +
>   #endif /* !__ASSEMBLY__ */
>   #endif /* _ASM_X86_TDX_H */
> diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
> new file mode 100644
> index 000000000000..1e36502cd738
> --- /dev/null
> +++ b/arch/x86/virt/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-y	+= vmx/
> diff --git a/arch/x86/virt/vmx/Makefile b/arch/x86/virt/vmx/Makefile
> new file mode 100644
> index 000000000000..feebda21d793
> --- /dev/null
> +++ b/arch/x86/virt/vmx/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx/
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> new file mode 100644
> index 000000000000..93ca8b73e1f1
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-y += tdx.o
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> new file mode 100644
> index 000000000000..a600b5d0879d
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2023 Intel Corporation.
> + *
> + * Intel Trusted Domain Extensions (TDX) support
> + */
> +
> +#define pr_fmt(fmt)	"tdx: " fmt
> +
> +#include <linux/types.h>
> +#include <linux/cache.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/printk.h>
> +#include <asm/msr-index.h>
> +#include <asm/msr.h>
> +#include <asm/tdx.h>
> +
> +static u32 tdx_global_keyid __ro_after_init;
> +static u32 tdx_guest_keyid_start __ro_after_init;
> +static u32 tdx_nr_guest_keyids __ro_after_init;
> +
> +/*
> + * Use tdx_global_keyid to indicate that TDX is uninitialized.
> + * This is used in TDX initialization error paths to take it from
> + * initialized -> uninitialized.
> + */
> +static void __init clear_tdx(void)
> +{
> +	tdx_global_keyid = 0;
> +}

Why not set "tdx_global_keyid" last, such that you don't have to clear 
when anything goes wrong before that? Seems more straight forward.

> +
> +static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
> +					    u32 *nr_tdx_keyids)
> +{
> +	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
> +	int ret;
> +
> +	/*
> +	 * IA32_MKTME_KEYID_PARTIONING:
> +	 *   Bit [31:0]:	Number of MKTME KeyIDs.
> +	 *   Bit [63:32]:	Number of TDX private KeyIDs.
> +	 */
> +	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
> +			&_nr_tdx_keyids);
> +	if (ret)
> +		return -ENODEV;
> +
> +	if (!_nr_tdx_keyids)
> +		return -ENODEV;
> +
> +	/* TDX KeyIDs start after the last MKTME KeyID. */
> +	_tdx_keyid_start = _nr_mktme_keyids + 1;
> +
> +	*tdx_keyid_start = _tdx_keyid_start;
> +	*nr_tdx_keyids = _nr_tdx_keyids;
> +
> +	return 0;
> +}

-- 
Thanks,

David / dhildenb

