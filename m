Return-Path: <kvm+bounces-21874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C65979352DB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CE7D1F21577
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47A0146584;
	Thu, 18 Jul 2024 21:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9Ld49rU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3311459F3
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721336806; cv=none; b=Rh7tL+Iy/b4JBxW8IyUSgJndP2H64Z1px0ZbtgmeDGwiIt6bCOatgpn0KHfYYvG5WFIWI1eW21NRCaCtFJirACR+tqrF3c9Y14ldZShiIRNvQFgx8lXmkFYGa5A0hgbY/zvsJEJF8EmaR1yH0swEgCgAUqOu8MnjTsL4rv4sa98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721336806; c=relaxed/simple;
	bh=vAaCHtwYnbkbBkOZZEJdDXWbZZGdjgoy0QnEu92hXnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qx1/vyVbifzLH+bZWv6f1pq8Zvh3RXBBXHHusebU2/q7GwzqCi0pAJZBrCVzkCqq7U4Vu9YLSvJdk5ewut2YZmnaTIbb1vQY3zLCfoIFAGfqwMRZvKdXtTeNhuGN+pdRUCRDF76WjBut+OqTEM3nkRblC7vajDFhgBun3cLQSXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M9Ld49rU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721336804; x=1752872804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vAaCHtwYnbkbBkOZZEJdDXWbZZGdjgoy0QnEu92hXnc=;
  b=M9Ld49rUtd3VXg0/MueBqYOvlDvprZ/s4tqH8w9IrXIOPaFeRbELOIpw
   mzVdA/uwx+Sz6xRIad8zdHIGcAUsS/vM4MYt/OSXYQ0BZsF3rbz5Y6Syw
   J0NZoQ31Te22pPLe4nu+Xa4kj3d/bqQPDLn0hZfejJ9ij0npWgVOr6/v9
   ji3XPou7mp9GVTQ6dA79hjwLYEqrbJABqh8jzhGB+uWZET0XaxYJTbb2W
   PM1at0fGnMPWFJPFQGZtDt/2NBhX2gaIlt/JX9fjjgZPNht+AkdHc2L7C
   P9/2Mq/WSf5uAvHAFk9hqwrpHFEuQxgui4shxulEHbnc3dMgQSFqZRrtr
   A==;
X-CSE-ConnectionGUID: PFqcBlU5QPu1WTi6BQTzAg==
X-CSE-MsgGUID: zk+yPQixQx+iI3nMCG9RKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="21831242"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="21831242"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:06:43 -0700
X-CSE-ConnectionGUID: Ir5Vn0A3QQmNkHzVwzzhaQ==
X-CSE-MsgGUID: 48JvaiOcSYmldTGN/ItyFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55178660"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:06:43 -0700
Message-ID: <fe4d90aa-144c-46b6-bb7c-00133c10fc16@intel.com>
Date: Thu, 18 Jul 2024 14:06:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] target/i386/kvm: Add feature bit definitions for
 KVM CPUID
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-2-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> Add feature definitions for KVM_CPUID_FEATURES in CPUID (
> CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
> offset calculations.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: zide.chen@intel.com


> ---
> v3: Resolved a rebasing conflict.
> v2: Changed the prefix from CPUID_FEAT_KVM_* to CPUID_KVM_*. (Xiaoyao)
> ---
>  hw/i386/kvm/clock.c   |  5 ++---
>  target/i386/cpu.h     | 23 +++++++++++++++++++++++
>  target/i386/kvm/kvm.c | 28 ++++++++++++++--------------
>  3 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
> index 40aa9a32c32c..ce416c05a3d0 100644
> --- a/hw/i386/kvm/clock.c
> +++ b/hw/i386/kvm/clock.c
> @@ -27,7 +27,6 @@
>  #include "qapi/error.h"
>  
>  #include <linux/kvm.h>
> -#include "standard-headers/asm-x86/kvm_para.h"
>  #include "qom/object.h"
>  
>  #define TYPE_KVM_CLOCK "kvmclock"
> @@ -334,8 +333,8 @@ void kvmclock_create(bool create_always)
>  
>      assert(kvm_enabled());
>      if (create_always ||
> -        cpu->env.features[FEAT_KVM] & ((1ULL << KVM_FEATURE_CLOCKSOURCE) |
> -                                       (1ULL << KVM_FEATURE_CLOCKSOURCE2))) {
> +        cpu->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
> +                                       CPUID_KVM_CLOCK2)) {
>          sysbus_create_simple(TYPE_KVM_CLOCK, -1, NULL);
>      }
>  }
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c43ac01c794a..b59bdc1c9d9d 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -28,6 +28,7 @@
>  #include "qapi/qapi-types-common.h"
>  #include "qemu/cpu-float.h"
>  #include "qemu/timer.h"
> +#include "standard-headers/asm-x86/kvm_para.h"
>  
>  #define XEN_NR_VIRQS 24
>  
> @@ -988,6 +989,28 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>  #define CPUID_8000_0007_EBX_OVERFLOW_RECOV    (1U << 0)
>  #define CPUID_8000_0007_EBX_SUCCOR      (1U << 1)
>  
> +/* (Old) KVM paravirtualized clocksource */
> +#define CPUID_KVM_CLOCK            (1U << KVM_FEATURE_CLOCKSOURCE)
> +/* (New) KVM specific paravirtualized clocksource */
> +#define CPUID_KVM_CLOCK2           (1U << KVM_FEATURE_CLOCKSOURCE2)
> +/* KVM asynchronous page fault */
> +#define CPUID_KVM_ASYNCPF          (1U << KVM_FEATURE_ASYNC_PF)
> +/* KVM stolen (when guest vCPU is not running) time accounting */
> +#define CPUID_KVM_STEAL_TIME       (1U << KVM_FEATURE_STEAL_TIME)
> +/* KVM paravirtualized end-of-interrupt signaling */
> +#define CPUID_KVM_PV_EOI           (1U << KVM_FEATURE_PV_EOI)
> +/* KVM paravirtualized spinlocks support */
> +#define CPUID_KVM_PV_UNHALT        (1U << KVM_FEATURE_PV_UNHALT)
> +/* KVM host-side polling on HLT control from the guest */
> +#define CPUID_KVM_POLL_CONTROL     (1U << KVM_FEATURE_POLL_CONTROL)
> +/* KVM interrupt based asynchronous page fault*/
> +#define CPUID_KVM_ASYNCPF_INT      (1U << KVM_FEATURE_ASYNC_PF_INT)
> +/* KVM 'Extended Destination ID' support for external interrupts */
> +#define CPUID_KVM_MSI_EXT_DEST_ID  (1U << KVM_FEATURE_MSI_EXT_DEST_ID)
> +
> +/* Hint to KVM that vCPUs expect never preempted for an unlimited time */
> +#define CPUID_KVM_HINTS_REALTIME    (1U << KVM_HINTS_REALTIME)
> +
>  /* CLZERO instruction */
>  #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
>  /* Always save/restore FP error pointers */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index becca2efa5b4..86e42beb78bf 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -539,13 +539,13 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>           * be enabled without the in-kernel irqchip
>           */
>          if (!kvm_irqchip_in_kernel()) {
> -            ret &= ~(1U << KVM_FEATURE_PV_UNHALT);
> +            ret &= ~CPUID_KVM_PV_UNHALT;
>          }
>          if (kvm_irqchip_is_split()) {
> -            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
> +            ret |= CPUID_KVM_MSI_EXT_DEST_ID;
>          }
>      } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
> -        ret |= 1U << KVM_HINTS_REALTIME;
> +        ret |= CPUID_KVM_HINTS_REALTIME;
>      }
>  
>      if (current_machine->cgs) {
> @@ -3424,20 +3424,20 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>          kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
>          kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
>          kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
> +        if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
>          }
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
> +        if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF) {
>              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
>          }
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
> +        if (env->features[FEAT_KVM] & CPUID_KVM_PV_EOI) {
>              kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, env->pv_eoi_en_msr);
>          }
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
> +        if (env->features[FEAT_KVM] & CPUID_KVM_STEAL_TIME) {
>              kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
>          }
>  
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
> +        if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> @@ -3900,19 +3900,19 @@ static int kvm_get_msrs(X86CPU *cpu)
>  #endif
>      kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
>      kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
> -    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
> +    if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>          kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
>      }
> -    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
> +    if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF) {
>          kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, 0);
>      }
> -    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
> +    if (env->features[FEAT_KVM] & CPUID_KVM_PV_EOI) {
>          kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, 0);
>      }
> -    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
> +    if (env->features[FEAT_KVM] & CPUID_KVM_STEAL_TIME) {
>          kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
>      }
> -    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
> +    if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
>      if (has_architectural_pmu_version > 0) {
> @@ -5613,7 +5613,7 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
>          return address;
>      }
>      env = &X86_CPU(first_cpu)->env;
> -    if (!(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID))) {
> +    if (!(env->features[FEAT_KVM] & CPUID_KVM_MSI_EXT_DEST_ID)) {
>          return address;
>      }
>  

