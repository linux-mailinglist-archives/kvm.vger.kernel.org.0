Return-Path: <kvm+bounces-21881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 183129352E7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48D731C2110C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D45E145A1B;
	Thu, 18 Jul 2024 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VLrP5Xm4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072487711F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337069; cv=none; b=eFV2M+nEpBd2gXPiT5azMpYdDBvR0EPk7r64JCwbXp4uXSW3MJkYmnoUih91EVMx3V5J777SrD2HFqibU6B3KESHApCKMRXq3Z2x9Z3iyCGcPX3597OQZ7bQy2oIouKeIx9JWnzt7zkXs8wGv3s2qzKciOqk9owEMTW3CyCGVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337069; c=relaxed/simple;
	bh=xeyJ40gAKiB98Av8NBuU+/x/EOrQ3yZJ21r0nLLcn6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFR17l5ePk3zqbRKgRYUmquaDCb/BvsJXy6raM5Qm7QSnR7WCwsMAdguKvJnoDH/rVmcVRSLYjFi5oCYAsgaLkpKmnsaNgDGzR1sQYVe8Eoy/E1TY+Q8oCoxnerz2G67895EAEIQSu8n7KSXLkEwao/mDqMRG7bJK2fEQMZYdzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VLrP5Xm4; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337068; x=1752873068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xeyJ40gAKiB98Av8NBuU+/x/EOrQ3yZJ21r0nLLcn6M=;
  b=VLrP5Xm4rAXaRMERG2ZUXFXKpERRiMdCzwREwJ11CV7AIxrIQO8S87Nm
   QCzkKVRlfrlH8DzZLGP2VG2LFBdC+TDIRcdcezFdtyOxBGmHWMlC30B0X
   aWOkkSsQN9Q6aPnydKuy2ZyGW9pZ7k32deQ8qkoy7Ab+BZAC3yJF/DJtG
   +Dztl1R9Ip+zc1PQOsy4GTGyuRCxEYRSoxFpQzuuau8S6TWhZPhIVDfCF
   IzRbfTl+ofz8qthb1b8IUHlhiaoSwfboZAicXDdlqtOtrQX7sdzTPxt1i
   NiYzvGSnH/bC4yMBZYUckt4heT45Ld1k2aD5SgxEbFYDspCmp5iiqpdkD
   Q==;
X-CSE-ConnectionGUID: VpYE4wEMSfSe9gu7BDDQoA==
X-CSE-MsgGUID: GnE4TULfQLG2czLuU7vnfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36370752"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36370752"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:11:08 -0700
X-CSE-ConnectionGUID: SsQP3A+yRKecmMS6ETqHpw==
X-CSE-MsgGUID: 4VrL3/CcR4iJOTyYGxEuaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="81935100"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:11:05 -0700
Message-ID: <66b00937-60a8-40b1-95fa-8b680febfce1@intel.com>
Date: Thu, 18 Jul 2024 14:11:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] target/i386/kvm: Replace ARRAY_SIZE(msr_handlers)
 with KVM_MSR_FILTER_MAX_RANGES
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-10-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-10-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> kvm_install_msr_filters() uses KVM_MSR_FILTER_MAX_RANGES as the bound
> when traversing msr_handlers[], while other places still compute the
> size by ARRAY_SIZE(msr_handlers).
> 
> In fact, msr_handlers[] is an array with the fixed size
> KVM_MSR_FILTER_MAX_RANGES, so there is no difference between the two
> ways.
> 
> For the code consistency and to avoid additional computational overhead,
> use KVM_MSR_FILTER_MAX_RANGES instead of ARRAY_SIZE(msr_handlers).
> 
> Suggested-by: Zide Chen <zide.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>


> ---
> v4: new commit.
> ---
>  target/i386/kvm/kvm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index d47476e96813..43b2ea63d584 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5314,7 +5314,7 @@ int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
>  {
>      int i, ret;
>  
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>          if (!msr_handlers[i].msr) {
>              msr_handlers[i] = (KVMMSRHandlers) {
>                  .msr = msr,
> @@ -5340,7 +5340,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
>      int i;
>      bool r;
>  
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>          KVMMSRHandlers *handler = &msr_handlers[i];
>          if (run->msr.index == handler->msr) {
>              if (handler->rdmsr) {
> @@ -5360,7 +5360,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
>      int i;
>      bool r;
>  
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>          KVMMSRHandlers *handler = &msr_handlers[i];
>          if (run->msr.index == handler->msr) {
>              if (handler->wrmsr) {

