Return-Path: <kvm+bounces-17249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F218C2FF8
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 09:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D241C21290
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 07:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DF9D2FE;
	Sat, 11 May 2024 07:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lr5l8XTa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE4610B
	for <kvm@vger.kernel.org>; Sat, 11 May 2024 07:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715411305; cv=none; b=jjkhOqr6qVUHOFm94F3/TeUMPlOiN95B70vfafr/GKNyyA/8viz4ye7SiFTPlZFqhnsSl31cGbN6+R+plW4EAqtWc2YwSugIs9bij6JVY0g+RhmAUNmgAEHpuIKEAkRzmNArwG/3/9jxiHA54Sy91Wuc74O3mu5WR1Aca/F1qUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715411305; c=relaxed/simple;
	bh=p8kV1rvAwoWvjzhcVQht8UjJlqE6bgmZ5khl4heqc2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RuHWhYdtiG2E/88k019Y/AdWk2cJnCTpybZ0c02GRefIFTCUPsvvGQj1Xsfw6/s0Ghvdid5sX1gzm6qM5kPKpEMB7zHDyoq9QNj+DUMgH8QHqhn2Aem00GouEGKpqUix9L9Ez8e+OvqhutaTHEqZBVuSJyKIBFqrhkMs2LEpAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lr5l8XTa; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715411303; x=1746947303;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p8kV1rvAwoWvjzhcVQht8UjJlqE6bgmZ5khl4heqc2M=;
  b=lr5l8XTawiaMUqgNkev92Gd78afNZBuZ83lg/0jl7qed8h6iyApA0ul9
   ZeiEM9WwovStaBa6ofVE/C4Ionpz/7UjGsP44+L+4t1pf+8Srm2unEbq5
   QCc7cmHQrIUDJ7tAqJj1vApofAhSNnTy83xAf8L6ZBXA/xZ7y7tLU4NXK
   3D+OIacrC/fTfl5ecpkX4SeudaUd2atg88xbVvR3PmK8SWvPG/k3K0MT1
   YngIf+FeR/DO3o3SqUiM0sD6xBFSIDnioV/i21QSZRgNN+U+FL012OgF2
   S9cqIgSCXF85IXxfilMyJvxQKHJeRrLdP6qKBlShnoX3hGBANgHcvKuqc
   g==;
X-CSE-ConnectionGUID: ZI9USOjFTNG1o2aEguMsnw==
X-CSE-MsgGUID: n2LEKlenQci2KeGZQbFsuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="36790644"
X-IronPort-AV: E=Sophos;i="6.08,153,1712646000"; 
   d="scan'208";a="36790644"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2024 00:08:22 -0700
X-CSE-ConnectionGUID: nCI4lW54QkKAYbJLndNl1A==
X-CSE-MsgGUID: k9Xo5meFSLSiCmF8pBj0yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,153,1712646000"; 
   d="scan'208";a="30416493"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2024 00:08:20 -0700
Message-ID: <456e2a3b-a96f-46a2-96d2-03dab56f9eb9@intel.com>
Date: Sat, 11 May 2024 15:08:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
To: Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
 yi1.lai@intel.com
References: <20240510020346.12528-1-tao1.su@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240510020346.12528-1-tao1.su@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/2024 10:03 AM, Tao Su wrote:
> Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
> max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
> dirty_log_test...) add RAM regions close to max_gfn, so guest may access
> GPA beyond its mappable range and cause infinite loop.
> 
> Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
> overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.
> 
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
> This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
> 
> Changelog:
> v1 -> v2:
>   - Only adjust vm->max_gfn in vm_compute_max_gfn()
>   - Add Yi Lai's Tested-by
> 
> v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
> ---
>   tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
>   tools/testing/selftests/kvm/lib/x86_64/processor.c     | 10 ++++++++--
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 81ce37ec407d..ff99f66d81a0 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
>   #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
>   #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
>   #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
> +#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
>   #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
>   #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
>   
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 74a4c736c9ae..aa9966ead543 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
>   unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
>   {
>   	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
> -	unsigned long ht_gfn, max_gfn, max_pfn;
> +	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;
>   	uint8_t maxphyaddr;
>   
> -	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
> +	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
> +		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);

We can get rid of the kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR) 
check and call kvm_cpu_property() unconditionally. As a bonus, we don't 
need to init max_bits as 0.

BTW, could we just name it guest_pa_bits?

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +
> +	if (!max_bits)
> +		max_bits = vm->pa_bits;
> +
> +	max_gfn = (1ULL << (max_bits - vm->page_shift)) - 1;
>   
>   	/* Avoid reserved HyperTransport region on AMD processors.  */
>   	if (!host_cpu_is_amd)
> 
> base-commit: 448b3fe5a0eab5b625a7e15c67c7972169e47ff8


