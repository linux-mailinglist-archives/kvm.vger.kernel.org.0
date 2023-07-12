Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BF3751370
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 00:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjGLWPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 18:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjGLWPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 18:15:14 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817351989;
        Wed, 12 Jul 2023 15:15:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-666eba6f3d6so51193b3a.3;
        Wed, 12 Jul 2023 15:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689200113; x=1691792113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OKJc2fatUXMEZdd+ElYGgHoN33D4VFsq7p5npBSUovw=;
        b=jtgur3J7ero92tOAWWdixESrF4rX3Nlrc1aFdImGDCCM1RGpYjIzt/+RkpTipF0XjF
         04PxicYwZ7nqRzVHn8hT2dK5kbaRXF4X0T+ciRFOwuU3qLfU4RLdhVK5kVzbLCRYitrL
         KwzWYCAqUqgJPnxiAg6m0T9fPa1/q2kt0q86pvE6laMhCUcdTWU+Cc15n/7iO6J+hUsA
         L2oicEYPrqenURms5GKloP06w+IEzHXjK0u0hVa7vpiZRtXXg0IVft9cvOUd17IVCRmw
         OiOgz5Wrdvs6IUcQeqSD0wDoki8YJaNZBJqshG4bWFjrVHBjNvNY3yQbsosE679bB9KF
         rwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689200113; x=1691792113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OKJc2fatUXMEZdd+ElYGgHoN33D4VFsq7p5npBSUovw=;
        b=GMk9GQZqfVa5BWClTmAp/YWRSI3W1NjmnjQMzDyf4eBLfrTcTOFemhhvuDNrEEMvZI
         m18QA0Sz9ao9aYr0tn0FWRPhIEbjaNvrHUACnd1ym3oqfcAPrBjBOVOQWJVc6ei70jV3
         iPaym69Ztx9m9jVJ7tDhsHgXjsvxD4NuCUOpJMn4nM2RMXpbP+DI6rDmlXxzN5bqwseC
         dUeApp2tBgHL9C6/79KveIhfA3hzoaES2vHn0q/CZSCJLmVxPn7GHlejhIjEaoE+XW16
         CVqaShf9rHkxjFmMgzKn22OUxt4yg0dzFX58ARbE8KRjakDzp76+P+fz4yg800lkbuOL
         th2g==
X-Gm-Message-State: ABy/qLYNRWIMLOo3fafHzurO3BLnF8R5BHcCjDe2c/KImKSnQfTg9gtw
        jHaNAJHD67m7SkXX8UdkCsc=
X-Google-Smtp-Source: APBJJlGVJ42v2aXC6QZ2slKUnQyyKVs+Nqfk3QCi0v9/KbgtsJRj62hGE7dGbBBT71+5i7L5IOc1vw==
X-Received: by 2002:a05:6a20:9484:b0:115:a2f4:6284 with SMTP id hs4-20020a056a20948400b00115a2f46284mr14738935pzb.16.1689200112750;
        Wed, 12 Jul 2023 15:15:12 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c11100b001b9ecee9f81sm4434217pli.129.2023.07.12.15.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 15:15:12 -0700 (PDT)
Date:   Wed, 12 Jul 2023 15:15:10 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Message-ID: <20230712221510.GG3894444@ls.amr.corp.intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 08:55:23PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  A CPU-attested software module
> called 'the TDX module' runs inside a new isolated memory range as a
> trusted hypervisor to manage and run protected VMs.
> 
> TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
> mode runs only the TDX module itself or other code to load the TDX
> module.
> 
> The host kernel communicates with SEAM software via a new SEAMCALL
> instruction.  This is conceptually similar to a guest->host hypercall,
> except it is made from the host to SEAM software instead.  The TDX
> module establishes a new SEAMCALL ABI which allows the host to
> initialize the module and to manage VMs.
> 
> The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> the basic TDX support: __seamcall(), __seamcall_ret() and
> __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.

Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
KVM TDH.VP.ENTER case, those arguments are already in unsigned long
kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.

If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
change with TDX KVM patch series.

Thanks,


> To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
> TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
> to opt-in TDX host kernel support (to distinguish with TDX guest kernel
> support).  So far only KVM uses TDX.  Make the new config option depend
> on KVM_INTEL.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/Kconfig                 | 12 +++++++
>  arch/x86/Makefile                |  2 ++
>  arch/x86/include/asm/tdx.h       |  7 +++++
>  arch/x86/virt/Makefile           |  2 ++
>  arch/x86/virt/vmx/Makefile       |  2 ++
>  arch/x86/virt/vmx/tdx/Makefile   |  2 ++
>  arch/x86/virt/vmx/tdx/seamcall.S | 54 ++++++++++++++++++++++++++++++++
>  7 files changed, 81 insertions(+)
>  create mode 100644 arch/x86/virt/Makefile
>  create mode 100644 arch/x86/virt/vmx/Makefile
>  create mode 100644 arch/x86/virt/vmx/tdx/Makefile
>  create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 53bab123a8ee..191587f75810 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1952,6 +1952,18 @@ config X86_SGX
>  
>  	  If unsure, say N.
>  
> +config INTEL_TDX_HOST
> +	bool "Intel Trust Domain Extensions (TDX) host support"
> +	depends on CPU_SUP_INTEL
> +	depends on X86_64
> +	depends on KVM_INTEL
> +	help
> +	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> +	  host and certain physical attacks.  This option enables necessary TDX
> +	  support in the host kernel to run confidential VMs.
> +
> +	  If unsure, say N.
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index b39975977c03..ec0e71d8fa30 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -252,6 +252,8 @@ archheaders:
>  
>  libs-y  += arch/x86/lib/
>  
> +core-y += arch/x86/virt/
> +
>  # drivers-y are linked after core-y
>  drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
>  drivers-$(CONFIG_PCI)            += arch/x86/pci/
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 9b0ad0176e58..a82e5249d079 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -74,5 +74,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  	return -ENODEV;
>  }
>  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +u64 __seamcall(u64 fn, struct tdx_module_args *args);
> +u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
> +u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
> +#endif	/* CONFIG_INTEL_TDX_HOST */
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASM_X86_TDX_H */
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
> index 000000000000..46ef8f73aebb
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-y += seamcall.o
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> new file mode 100644
> index 000000000000..650a40843afe
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/linkage.h>
> +#include <asm/frame.h>
> +
> +#include "tdxcall.S"
> +
> +/*
> + * __seamcall() - Host-side interface functions to SEAM software
> + *                (the P-SEAMLDR or the TDX module).
> + *
> + * __seamcall() function ABI:
> + *
> + * @fn   (RDI)  - SEAMCALL Leaf number, moved to RAX
> + * @args (RSI)  - struct tdx_module_args for input
> + *
> + * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
> + * fails, or the completion status of the SEAMCALL leaf function.
> + */
> +SYM_FUNC_START(__seamcall)
> +	TDX_MODULE_CALL host=1 ret=0 saved=0
> +SYM_FUNC_END(__seamcall)
> +
> +/*
> + * __seamcall_ret() - Host-side interface functions to SEAM software
> + *                    (the P-SEAMLDR or the TDX module).
> + *
> + * __seamcall_ret() function ABI:
> + *
> + * @fn   (RDI)  - SEAMCALL Leaf number, moved to RAX
> + * @args (RSI)  - struct tdx_module_args for input and output
> + *
> + * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
> + * fails, or the completion status of the SEAMCALL leaf function.
> + */
> +SYM_FUNC_START(__seamcall_ret)
> +	TDX_MODULE_CALL host=1 ret=1 saved=0
> +SYM_FUNC_END(__seamcall_ret)
> +
> +/*
> + * __seamcall_saved_ret() - Host-side interface functions to SEAM software
> + *                          (the P-SEAMLDR or the TDX module) with extra
> + *                          "callee-saved" registers as input/output.
> + *
> + * __seamcall_saved_ret() function ABI:
> + *
> + * @fn   (RDI)          - SEAMCALL Leaf number, moved to RAX
> + * @args (RSI)          - struct tdx_module_args for input and output
> + *
> + * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
> + * fails, or the completion status of the SEAMCALL leaf function.
> + */
> +SYM_FUNC_START(__seamcall_saved_ret)
> +	TDX_MODULE_CALL host=1 ret=1 saved=0
> +SYM_FUNC_END(__seamcall_saved_ret)
> -- 
> 2.41.0
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
