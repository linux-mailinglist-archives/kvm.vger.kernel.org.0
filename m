Return-Path: <kvm+bounces-9478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54889860954
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 04:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7AB21F2298C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 03:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A54C2C6;
	Fri, 23 Feb 2024 03:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVX8vBvM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82C2C2C4
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 03:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708658523; cv=none; b=VPoSLRhfEvYNJ3XvH1mzzfICAgd/t2Jex5+LFAcyuzy+u745HbC2j4X0ruRdliiAUJZQUeReMqcgOs78mMAYW4p1QzFRUTdbyt5oz189olnp9uEAYddbO/M1nUmLo6cra4guUBG+uKSEwrxNMMnPpR+G1x6riobNtBSddo20aI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708658523; c=relaxed/simple;
	bh=VBbAKL/s5QKKAzFQYg0xK0ZTO0fF09wSYm1fPY9nymc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wc70ykVb2i7/JTzArv00hE4zIooG77eQ/wBEGWQG7VsWL1uYdcSek1zVTMbbBNBIofagRGUCAJKENWxMi8TAhNYYDWC/TBwvgpkgJlK1AI6YxIDegmAHjUvWWWYyDDr1s6m58J3t4kL00VLIZquQfdSwPxCG8qUXuSADIS5vdYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVX8vBvM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708658522; x=1740194522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VBbAKL/s5QKKAzFQYg0xK0ZTO0fF09wSYm1fPY9nymc=;
  b=mVX8vBvMiG8PmE9DS3wycVwwpxupxY5oObzzv7TS1Q8iuRtuO7fQ9c/B
   KdKB4t96A6+R4TWY9UFFCgYh0p5ARLOiEJiqM2lgJij5DlseVlSx0S+cY
   F7bIsCUh6yTyNWzwwvxVu3G1dzhtpGDdLjWls45ZXECjZjyWy7WA5huV7
   aoEe0RfDN2MK4eMTMvO8XD6IHgRbQLpNYSD2faw9lOuOxD39Eg+zzoYT+
   ATTnoTBc6U1zFcCpOIewrL5HXtJ7N/FZzCjR0M9IMSALEDXeSPdZZXIGk
   0XTQfcLUtPoxlnkY3Vm5jXegtcjgtpVyvt96ultow+nRxbtVKjUiXK16S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3113456"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3113456"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 19:22:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="36559813"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 22 Feb 2024 19:21:59 -0800
Date: Fri, 23 Feb 2024 11:35:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	xiaoyao.li@intel.com, chao.gao@intel.com, robert.hu@linux.intel.com
Subject: Re: [PATCH v4 2/2] target/i386: add control bits support for LAM
Message-ID: <ZdgSi35/Lb9FeNoG@intel.com>
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
 <20240112060042.19925-3-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112060042.19925-3-binbin.wu@linux.intel.com>

On Fri, Jan 12, 2024 at 02:00:42PM +0800, Binbin Wu wrote:
> Date: Fri, 12 Jan 2024 14:00:42 +0800
> From: Binbin Wu <binbin.wu@linux.intel.com>
> Subject: [PATCH v4 2/2] target/i386: add control bits support for LAM
> X-Mailer: git-send-email 2.25.1
> 
> LAM uses CR3[61] and CR3[62] to configure/enable LAM on user pointers.
> LAM uses CR4[28] to configure/enable LAM on supervisor pointers.
> 
> For CR3 LAM bits, no additional handling needed:
> - TCG
>   LAM is not supported for TCG of target-i386.  helper_write_crN() and
>   helper_vmrun() check max physical address bits before calling
>   cpu_x86_update_cr3(), no change needed, i.e. CR3 LAM bits are not allowed
>   to be set in TCG.
> - gdbstub
>   x86_cpu_gdb_write_register() will call cpu_x86_update_cr3() to update cr3.
>   Allow gdb to set the LAM bit(s) to CR3, if vcpu doesn't support LAM,
>   KVM_SET_SREGS will fail as other reserved bits.
> 
> For CR4 LAM bit, its reservation depends on vcpu supporting LAM feature or
> not.
> - TCG
>   LAM is not supported for TCG of target-i386.  helper_write_crN() and
>   helper_vmrun() check CR4 reserved bit before calling cpu_x86_update_cr4(),
>   i.e. CR4 LAM bit is not allowed to be set in TCG.
> - gdbstub
>   x86_cpu_gdb_write_register() will call cpu_x86_update_cr4() to update cr4.
>   Mask out LAM bit on CR4 if vcpu doesn't support LAM.
> - x86_cpu_reset_hold() doesn't need special handling.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  target/i386/cpu.h    | 7 ++++++-
>  target/i386/helper.c | 4 ++++
>  2 files changed, 10 insertions(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 18ea755644..598a3fa140 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -261,6 +261,7 @@ typedef enum X86Seg {
>  #define CR4_SMAP_MASK   (1U << 21)
>  #define CR4_PKE_MASK   (1U << 22)
>  #define CR4_PKS_MASK   (1U << 24)
> +#define CR4_LAM_SUP_MASK (1U << 28)
>  
>  #define CR4_RESERVED_MASK \
>  (~(target_ulong)(CR4_VME_MASK | CR4_PVI_MASK | CR4_TSD_MASK \
> @@ -269,7 +270,8 @@ typedef enum X86Seg {
>                  | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
>                  | CR4_LA57_MASK \
>                  | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
> -                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK))
> +                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
> +                | CR4_LAM_SUP_MASK))
>  
>  #define DR6_BD          (1 << 13)
>  #define DR6_BS          (1 << 14)
> @@ -2522,6 +2524,9 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
>      if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS)) {
>          reserved_bits |= CR4_PKS_MASK;
>      }
> +    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
> +        reserved_bits |= CR4_LAM_SUP_MASK;
> +    }
>      return reserved_bits;
>  }
>  
> diff --git a/target/i386/helper.c b/target/i386/helper.c
> index 2070dd0dda..1da7a7d315 100644
> --- a/target/i386/helper.c
> +++ b/target/i386/helper.c
> @@ -219,6 +219,10 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
>          new_cr4 &= ~CR4_PKS_MASK;
>      }
>  
> +    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
> +        new_cr4 &= ~CR4_LAM_SUP_MASK;
> +    }
> +
>      env->cr[4] = new_cr4;
>      env->hflags = hflags;
>  
> -- 
> 2.25.1
> 
> 

