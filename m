Return-Path: <kvm+bounces-26238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87802973644
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D1BFB26B15
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D2F18F2E3;
	Tue, 10 Sep 2024 11:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GwCjox3O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCE917CA09;
	Tue, 10 Sep 2024 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725967898; cv=none; b=gIDzqmfWEqHbgM7DG/koUfWOTItClD1LVImlM42pfBhTkJ7MfseSJxMjVWrpc5/eLIxYj3id+wQNf+4Y+0+v5+ZkHAkJUd1pHQCRY6A+9J2BxSLrDPDqOwcbf0G94x7rALtors+WA5cT/0qaER09mg4cbeopc+3mGSY87psqTmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725967898; c=relaxed/simple;
	bh=tX2gTWhwl0ENhxTWOYQoj+JYJkAmmIO5ZLnbHKom64I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YCicL7gC2yh2DmxBCfn+HWjPVwg1HLmoUujFlYjgyjnqcOhAPoey6FkT8zcnPB0OnwGp7UDO62Fn412nBv7fvnGf0l9GwNjnQiOiFCy8StsjzHUDkgXYq6px28314HIGA7u7O3sUBZyiOeNwlT0FITQr7Bqx9p6gxzeEl2Ki0R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GwCjox3O; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725967897; x=1757503897;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=tX2gTWhwl0ENhxTWOYQoj+JYJkAmmIO5ZLnbHKom64I=;
  b=GwCjox3O+1xhdSAuihX6036MlXiUPhwEc1qM/7BQogjJ1eCuzT4Bx1bA
   dSPBUFM4vOJVQApIIPlaHXRoypAVtW6tySds1KfzX+sqU64PW2m2cFaMT
   fE56ivVIXsadXdj+kcnGcMuUvydZEWShcQQL6Q1LSz3Nn8WuAGyMvHCTk
   MPUUFOE4vENTBEbMqA8xXq/ThS0Q/ckewjy2vuA4Bet7B2+ssF5ojh5LI
   m3NFgYRDzEfb6tUua6sy7Tswv5zMDwW4hFLqDtq22+G7pKEm/qZklomtH
   FO+tstdldDwVdhwdO6HwLR8eJyRxhBmgW6gZJHpzZ5W9J7pLjkfN/uxTt
   Q==;
X-CSE-ConnectionGUID: 2W/joI/YTKia8TBukSTZTA==
X-CSE-MsgGUID: 9WUQLhcNRJeHlsMSI1KTzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="35846133"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="35846133"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:31:36 -0700
X-CSE-ConnectionGUID: 0Qo2BjzgTTmBx1bjul6YVQ==
X-CSE-MsgGUID: N7z+pVYAQTqYJeaGX/yqCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="67007526"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:31:33 -0700
Message-ID: <ddaebed0-beeb-4403-ba53-8f07cbe0e235@intel.com>
Date: Tue, 10 Sep 2024 14:31:26 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
From: Adrian Hunter <adrian.hunter@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
 <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
 <5b2fa2b3-ca77-4d6e-a474-75c196b8fefc@redhat.com>
 <e58349f3-fa36-4635-9b2b-9ff8f2d88038@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <e58349f3-fa36-4635-9b2b-9ff8f2d88038@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/09/24 14:15, Adrian Hunter wrote:
> On 10/09/24 13:33, Paolo Bonzini wrote:
>> On 9/4/24 17:37, Adrian Hunter wrote:
>>> Isaku was going to lock the mmu.  Seems like the change got lost.
>>> To protect against racing with KVM_PRE_FAULT_MEMORY,
>>> KVM_TDX_INIT_MEM_REGION, tdx_sept_set_private_spte() etc
>>> e.g. Rename tdx_td_finalizemr to __tdx_td_finalizemr and add:
>>>
>>> static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>>> {
>>>     int ret;
>>>
>>>     write_lock(&kvm->mmu_lock);
>>>     ret = __tdx_td_finalizemr(kvm, cmd);
>>>     write_unlock(&kvm->mmu_lock);
>>>
>>>     return ret;
>>> }
>>
>> kvm->slots_lock is better.  In tdx_vcpu_init_mem_region() you can take it before the is_td_finalized() so that there is a lock that is clearly protecting kvm_tdx->finalized between the two.  (I also suggest switching to guard() in tdx_vcpu_init_mem_region()).
> 
> Doesn't KVM_PRE_FAULT_MEMORY also need to be protected?

Ah, but not if pre_fault_allowed is false.

> 
>>
>> Also, I think that in patch 16 (whether merged or not) nr_premapped should not be incremented, once kvm_tdx->finalized has been set?
> 
> tdx_sept_set_private_spte() checks is_td_finalized() to decide
> whether to call tdx_mem_page_aug() or tdx_mem_page_record_premap_cnt()
> Refer patch 14 "KVM: TDX: Implement hooks to propagate changes
> of TDP MMU mirror page table" for the addition of
> tdx_sept_set_private_spte()
> 
> 


