Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B208A6C810C
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjCXPUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjCXPUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:20:04 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A1B13D5C;
        Fri, 24 Mar 2023 08:20:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id e21so2098092ljn.7;
        Fri, 24 Mar 2023 08:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679671200; x=1682263200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dIWyxrQgf2AAmPr/ggaE2ELdmMSUNu9fSc3jnoT1Ug=;
        b=H5Mq+uiqFaMqW+0cngMdQpEj6Z1UBDWN9xfk2936bKfHxecn/AcujyC94VvVLQFVEE
         PMIYeAxnNUmwfI8GsjST0rWREu69vwC2ZSiHqu2DpOSOi1GjeA8w/5DBcUHb8O56Iqxk
         2kNkpKklmtkfY7YSi9LK5KtNeqXU3d6Bm4sw9hAuCbYPSjrmzn2doF1tA54d+rW/dK6N
         VzpgTFuvNu9p75jjDKIKVGfIvR/jPZzx9w90I2QCPNEUX90LmcLR75tgwnWePN+dX7yl
         PY3ZYqfTquYQk0G+mNyEH0lqTrkY7VSVDA6qldYABPhh0Wrl2IrgHFVgSqaD93+TmG7x
         LTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679671200; x=1682263200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dIWyxrQgf2AAmPr/ggaE2ELdmMSUNu9fSc3jnoT1Ug=;
        b=iQdr/F8Im36PFk7RegmjQMnLszCoSEuA42SrlN6aoJ88pyp+qSzI5w77+CY7Q1S3dC
         qONgyFzaFUX8v5LWH7mVGyxuTjVmX4Cw1bEjWXMCKv5Ji8jIWRFOHiOEVmhwJE9Z4Krt
         3GD7E1gPHLqWqJbUjKggs23Y99TpXwx/ElRFSf4/pZ4Z5Ktx9xyO/1AlMYHZBWT3GKMV
         vPdNARk1pov4jm63rGbc3gZEdLVj99SvSAM1qQRR9QUv7IXHiQthwYqnAbGfv/mlUH23
         FQFrfald4fRjzIR98YR9p2DEsf7TDtvM17bhpxnu09oxcBomOeAWeeEV6jaYD2WAjNXN
         tQ9g==
X-Gm-Message-State: AAQBX9dnQ6Xqdrq/TDsTKRmjzpW1Vbli+KplB4Qw0P4Qwz4buP/JrPbS
        t/OOZXIA8/4ZshgIPvyCkSE=
X-Google-Smtp-Source: AKy350Zvc4rAEAmu0MtbldAQTrsKIGJWCsVQMcFAyx2CdMOdxTSOq1LlRfdse3FnATGKaVjZCZYFyQ==
X-Received: by 2002:a2e:bc05:0:b0:29b:55bc:2bb3 with SMTP id b5-20020a2ebc05000000b0029b55bc2bb3mr892799ljf.3.1679671199691;
        Fri, 24 Mar 2023 08:19:59 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id o7-20020a2e90c7000000b002958c4e96fasm2767445ljg.3.2023.03.24.08.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:19:59 -0700 (PDT)
Date:   Fri, 24 Mar 2023 17:19:47 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20230324171947.000000a2.zhi.wang.linux@gmail.com>
In-Reply-To: <3c2c142e14a04a833b47f77faecaa91899b472cd.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <3c2c142e14a04a833b47f77faecaa91899b472cd.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:35 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> A VMM interacts with the TDX module using a new instruction (SEAMCALL).  A
> TDX VMM uses SEAMCALLs where a VMX VMM would have directly interacted with
  ^ This sentence is little bit confusing, it can be removed. The next two sentences have stated the situation clearly.
> VMX instructions.  For instance, a TDX VMM does not have full access to the
> VM control structure corresponding to VMX VMCS.  Instead, a VMM induces the
> TDX module to act on behalf via SEAMCALLs.
> 
> Export __seamcall and define C wrapper functions for SEAMCALLs for
> readability.
> 
> Some SEAMCALL APIs donates host pages to TDX module or guest TD and the
> donated pages are encrypted.  Some of such SEAMCALLs flush cache lines
                                      ^ "some of" can be removed.
> (typically by movdir64b instruction), some don't.  Those that doesn't
> clear cache lines require the VMM to flush the cache lines to avoid cache
> line alias.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h       |   4 +
>  arch/x86/kvm/vmx/tdx_ops.h       | 202 +++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/seamcall.S |   2 +
>  arch/x86/virt/vmx/tdx/tdx.h      |   3 -
>  4 files changed, 208 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 112a5b9bd5cd..6c01ab572c1f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -104,10 +104,14 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  bool platform_tdx_enabled(void);
>  int tdx_cpu_enable(void);
>  int tdx_enable(void);
> +u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
>  static inline int tdx_cpu_enable(void) { return -EINVAL; }
>  static inline int tdx_enable(void)  { return -EINVAL; }
> +static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +			     struct tdx_module_output *out) { return TDX_SEAMCALL_UD; };
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> new file mode 100644
> index 000000000000..70e569838e1c
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -0,0 +1,202 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_OPS_H
> +#define __KVM_X86_TDX_OPS_H
> +
> +#include <linux/compiler.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/asm.h>
> +#include <asm/kvm_host.h>
> +
> +#include "tdx_errno.h"
> +#include "tdx_arch.h"
> +#include "x86.h"
> +
> +static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +			       struct tdx_module_output *out)
> +{
> +	u64 ret;
> +
> +	ret = __seamcall(op, rcx, rdx, r8, r9, out);
> +	if (ret == TDX_SEAMCALL_UD) {
> +		/*
> +		 * TDX requires VMXON or #UD.  In the case of reboot or kexec,
> +		 * VMX is made off (VMXOFF) by kvm reboot notifier,
> +		 * kvm_reboot(), while TDs are still running.  The callers check
> +		 * the returned error and complain.  Suppress it by returning 0.
> +		 */
> +		kvm_spurious_fault();
> +		return 0;
> +	}
> +	return ret;
> +}
> +
> +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
> +}
> +
> +static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(page), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
> +}
> +
> +static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return kvm_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +					struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
> +}
> +
> +static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
> +}
> +
> +static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mng_key_config(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
> +{
> +	clflush_cache_range(__va(tdr), PAGE_SIZE);
> +	return kvm_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
> +{
> +	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
> +	return kvm_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
> +				struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_finalize(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_flush(hpa_t tdvpr)
> +{
> +	return kvm_seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_key_freeid(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
> +			       struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
> +}
> +
> +static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
> +{
> +	return kvm_seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
> +			    struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_phymem_page_reclaim(hpa_t page,
> +					  struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_sys_lp_shutdown(void)
> +{
> +	return kvm_seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_track(hpa_t tdr)
> +{
> +	return kvm_seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
> +					struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_phymem_cache_wb(bool resume)
> +{
> +	return kvm_seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
> +{
> +	return kvm_seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
> +			    struct tdx_module_output *out)
> +{
> +	return kvm_seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
> +}
> +
> +#endif /* __KVM_X86_TDX_OPS_H */
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> index f81be6b9c133..b90a7fe05494 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.S
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -1,5 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/linkage.h>
> +#include <asm/export.h>
>  #include <asm/frame.h>
>  
>  #include "tdxcall.S"
> @@ -50,3 +51,4 @@ SYM_FUNC_START(__seamcall)
>  	FRAME_END
>  	RET
>  SYM_FUNC_END(__seamcall)
> +EXPORT_SYMBOL_GPL(__seamcall)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 48f830087e7e..4e497f202586 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -144,7 +144,4 @@ struct tdmr_info_list {
>  	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
>  };
>  

> -struct tdx_module_output;
> -u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> -	       struct tdx_module_output *out);
Better move this part to a correct place.
>  #endif

