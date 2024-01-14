Return-Path: <kvm+bounces-6167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B533382D078
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 13:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60615282589
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 12:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285E2107;
	Sun, 14 Jan 2024 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvRmZ1QF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B641EEE8
	for <kvm@vger.kernel.org>; Sun, 14 Jan 2024 12:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705234158; x=1736770158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0hibwSD1PQ4vDgip1K/Sx6DPnqV9+de/ew2mFMg5AVY=;
  b=gvRmZ1QFERM+BQj9yMFaRowHbDQngaiQDkXyOu1YyMzpQ5C4lGMWCaXL
   XqQxQ2tH1iJN/sWiNXDAc+c51pYgDcpmpu1+6OsERlTuZUSoCXjOKyywn
   7sZLQNKQ7m6E3NCs2p99t5hU3kGlB/McabTUX9tQmJ3Ubql8E+WKaIEkr
   S6fmxORQ6r64JYUcNSUSrfHWtL36HZn0nz//x01F1ZETxCKf2WFTH2hzX
   dHiLJUupfTY9jk9ORJ/dF3PEhE1M11sLf2qeUW0SSd9quzPxyJQtE2MOK
   AY8P8SFOeL4Jqrhs2Oa8CMpNepwk0n3K1siTcukGm8U23rKxoNDZvRGxS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10952"; a="399133646"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="399133646"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 04:09:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10952"; a="926860982"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="926860982"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 04:09:15 -0800
Message-ID: <cf6d5c3a-384b-41c9-aa5f-04b2dd0e8c6d@intel.com>
Date: Sun, 14 Jan 2024 20:09:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] target/i386: add control bits support for LAM
Content-Language: en-US
To: Binbin Wu <binbin.wu@linux.intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, chao.gao@intel.com, robert.hu@linux.intel.com
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
 <20240112060042.19925-3-binbin.wu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240112060042.19925-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/2024 2:00 PM, Binbin Wu wrote:
> LAM uses CR3[61] and CR3[62] to configure/enable LAM on user pointers.
> LAM uses CR4[28] to configure/enable LAM on supervisor pointers.
> 
> For CR3 LAM bits, no additional handling needed:
> - TCG
>    LAM is not supported for TCG of target-i386.  helper_write_crN() and
>    helper_vmrun() check max physical address bits before calling
>    cpu_x86_update_cr3(), no change needed, i.e. CR3 LAM bits are not allowed
>    to be set in TCG.
> - gdbstub
>    x86_cpu_gdb_write_register() will call cpu_x86_update_cr3() to update cr3.
>    Allow gdb to set the LAM bit(s) to CR3, if vcpu doesn't support LAM,
>    KVM_SET_SREGS will fail as other reserved bits.
> 
> For CR4 LAM bit, its reservation depends on vcpu supporting LAM feature or
> not.
> - TCG
>    LAM is not supported for TCG of target-i386.  helper_write_crN() and
>    helper_vmrun() check CR4 reserved bit before calling cpu_x86_update_cr4(),
>    i.e. CR4 LAM bit is not allowed to be set in TCG.
> - gdbstub
>    x86_cpu_gdb_write_register() will call cpu_x86_update_cr4() to update cr4.
>    Mask out LAM bit on CR4 if vcpu doesn't support LAM.
> - x86_cpu_reset_hold() doesn't need special handling.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.h    | 7 ++++++-
>   target/i386/helper.c | 4 ++++
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 18ea755644..598a3fa140 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -261,6 +261,7 @@ typedef enum X86Seg {
>   #define CR4_SMAP_MASK   (1U << 21)
>   #define CR4_PKE_MASK   (1U << 22)
>   #define CR4_PKS_MASK   (1U << 24)
> +#define CR4_LAM_SUP_MASK (1U << 28)
>   
>   #define CR4_RESERVED_MASK \
>   (~(target_ulong)(CR4_VME_MASK | CR4_PVI_MASK | CR4_TSD_MASK \
> @@ -269,7 +270,8 @@ typedef enum X86Seg {
>                   | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
>                   | CR4_LA57_MASK \
>                   | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
> -                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK))
> +                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
> +                | CR4_LAM_SUP_MASK))
>   
>   #define DR6_BD          (1 << 13)
>   #define DR6_BS          (1 << 14)
> @@ -2522,6 +2524,9 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
>       if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS)) {
>           reserved_bits |= CR4_PKS_MASK;
>       }
> +    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
> +        reserved_bits |= CR4_LAM_SUP_MASK;
> +    }
>       return reserved_bits;
>   }
>   
> diff --git a/target/i386/helper.c b/target/i386/helper.c
> index 2070dd0dda..1da7a7d315 100644
> --- a/target/i386/helper.c
> +++ b/target/i386/helper.c
> @@ -219,6 +219,10 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
>           new_cr4 &= ~CR4_PKS_MASK;
>       }
>   
> +    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_LAM)) {
> +        new_cr4 &= ~CR4_LAM_SUP_MASK;
> +    }
> +
>       env->cr[4] = new_cr4;
>       env->hflags = hflags;
>   


