Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9921635960
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 11:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiKWKMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 05:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiKWKL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 05:11:26 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A28E9FD2;
        Wed, 23 Nov 2022 02:00:54 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id g12so27438962lfh.3;
        Wed, 23 Nov 2022 02:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJPLqeQj0GrEBh1zsO9U4DPAemzj7HCMiVvwQQPeYf0=;
        b=gN3yWRSQ76Vj45ACuHEW+VIsj6LFa1+amg+pNftOeV41XeNGJBEeLL/gRI6z642A7V
         Yi6ac9grKs0ywoITtwhYSgGIrHQA9IWKiSarIlGOpdSMJdzc7UnC7lVUFLvruAkfUOv9
         uPkex/yPbtenAd4F6O9mhBAMhmG4ep5BDZS9WDZM84NU9zywJD9bKEjfVK2fuzshuQEl
         bnV5+l2uP9bbvhPl7ee9WMokl5VRTmwGxajzBqS9MDIPBGDPJ8VgQeXDx/TY5C7KJyOl
         vHsLpzwzOdW640VzILFbFsjr1eVXQsi+kAftGR5q2Xhw72HRyCpNJ9mcKz85i4gEVylq
         qKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJPLqeQj0GrEBh1zsO9U4DPAemzj7HCMiVvwQQPeYf0=;
        b=GYMptQjO1uhKoByBDIAcciC39r4TLjXv2oZEs5BQ52qJK9aWyNphX4GvXNdK27riIm
         xJ8qqj8l75aZy+oC45BpGIS1MoDvRZnm0XZaZLx2JKxhgVJeA75EHK1n/KyWFaq16uDP
         I7d+zy+1xd4VJb60v2F6E7qqjLgDpqaSBT572R1jydUUP/tguKo0btLwwGMJ0BHdAIyD
         D+UQ3uld96qJIOlHxfEIWww5XaDO1MclXAfaNQwaQLxvX5SCuKtBWBE7d+Cn+pKrektG
         3B/baw7JIj1c6bmTxG178J4ZbxLHk9lkQGQ4cAo7Hm3ToLSLh/enlcT1OcUiNOJOaOK7
         UFPw==
X-Gm-Message-State: ANoB5pmmpQVDvLuonepKdV8GVwfLexyahFts8eYGvS3vHbrHrvOBE1d6
        cfNUZn43uirxCl8+CaUH8QU=
X-Google-Smtp-Source: AA0mqf7blxSSfXZXjr4FNWipa+lYzg0VDA1vXdMDqBlkIVlVQ3jPUMDwZTMxZ7KxurMuZfAonkHtmQ==
X-Received: by 2002:a05:6512:3e6:b0:4aa:f1f2:ad77 with SMTP id n6-20020a05651203e600b004aaf1f2ad77mr5862582lfq.171.1669197652453;
        Wed, 23 Nov 2022 02:00:52 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q3-20020a056512210300b004a8b9c68728sm2857935lfr.105.2022.11.23.02.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 02:00:52 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.a.wang@intel.com>
Date:   Wed, 23 Nov 2022 12:00:47 +0200
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        zhi.a.wang@intel.com
Subject: Re: [PATCH v10 011/108] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20221123120047.00001a9d@gmail.com>
In-Reply-To: <5f1a80e9ab037fa88d8821a6548638d282070f1d.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
        <5f1a80e9ab037fa88d8821a6548638d282070f1d.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 29 Oct 2022 23:22:12 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> A VMM interacts with the TDX module using a new instruction
> (SEAMCALL).  A TDX VMM uses SEAMCALLs where a VMX VMM would have
> directly interacted with VMX instructions.  For instance, a TDX VMM
> does not have full access to the VM control structure corresponding
> to VMX VMCS.  Instead, a VMM induces the TDX module to act on behalf
> via SEAMCALLs.
> 
> Export __seamcall and define C wrapper functions for SEAMCALLs for
> readability.  Some SEAMCALL APIs donates pages to TDX module or guest
> TD. The pages are encrypted with TDX private host key id set in high

It seems a little bit confusing here.

I guess you are talking about the host pages donated to TDX module will
be encrypted with TDX module global key id, which is used to
encrypted the pages only used by TDX module. For pages donated to the
TD guest, the pages are encrypted with TD guest prviate key id?

It might be better that you can talk about the actual reaason instead of
the key id stuff. For example Some SEMCALL APIs will zap or write the
pages donated by VMM via MOVDIR64B, which requires the VMM to flush the
cachelines.

> bits of physical address.  If any modified cache lines may exit for

typo exit->exist

> these pages, flush them to memory by clflush_cache_range().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h       |   2 +
>  arch/x86/kvm/vmx/tdx_ops.h       | 185
> +++++++++++++++++++++++++++++++ arch/x86/virt/vmx/tdx/seamcall.S |
> 2 + 3 files changed, 189 insertions(+)
>  create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 5cff7ed5b11e..ba2e4c69fb9f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -186,6 +186,8 @@ struct tdsysinfo_struct {
>  const struct tdsysinfo_struct *tdx_get_sysinfo(void);
>  bool platform_tdx_enabled(void);
>  int tdx_enable(void);
> +u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  struct tdsysinfo_struct;
>  static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) {
> return NULL; } diff --git a/arch/x86/kvm/vmx/tdx_ops.h
> b/arch/x86/kvm/vmx/tdx_ops.h new file mode 100644
> index 000000000000..85adbf49c277
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -0,0 +1,185 @@
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
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +
> +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return __seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> hpa_t source,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return __seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source,
> out); +}
> +
> +static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level,
> hpa_t page,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(page), PAGE_SIZE);
> +	return __seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page,
> 0, out); +}
> +
> +static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int
> level,
> +				      struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0,
> 0, out); +}
> +
> +static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return __seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t
> hpa,
> +					struct tdx_module_output
> *out) +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return __seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0,
> out); +}
> +
> +static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +				   struct tdx_module_output *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return __seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
> +}
> +
> +static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int
> level,
> +				      struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0,
> 0, out); +}
> +
> +static inline u64 tdh_mng_key_config(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
> +{
> +	clflush_cache_range(__va(tdr), PAGE_SIZE);
> +	return __seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
> +{
> +	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
> +	return __seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct
> tdx_module_output *out) +{
> +	return __seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
> +				struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_finalize(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_flush(hpa_t tdvpr)
> +{
> +	return __seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_key_freeid(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
> +			       struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
> +}
> +
> +static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
> +{
> +	return __seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
> +			    struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_phymem_page_reclaim(hpa_t page,
> +					  struct tdx_module_output
> *out) +{
> +	return __seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0,
> out); +}
> +
> +static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int
> level,
> +				      struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0,
> 0, out); +}
> +
> +static inline u64 tdh_sys_lp_shutdown(void)
> +{
> +	return __seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_track(hpa_t tdr)
> +{
> +	return __seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int
> level,
> +					struct tdx_module_output
> *out) +{
> +	return __seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr,
> 0, 0, out); +}
> +
> +static inline u64 tdh_phymem_cache_wb(bool resume)
> +{
> +	return __seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0,
> 0, NULL); +}
> +
> +static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
> +{
> +	return __seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0,
> NULL); +}
> +
> +static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64
> mask,
> +			    struct tdx_module_output *out)
> +{
> +	return __seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
> +}
> +#endif /* CONFIG_INTEL_TDX_HOST */
> +
> +#endif /* __KVM_X86_TDX_OPS_H */
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S
> b/arch/x86/virt/vmx/tdx/seamcall.S index f81be6b9c133..b90a7fe05494
> 100644 --- a/arch/x86/virt/vmx/tdx/seamcall.S
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

