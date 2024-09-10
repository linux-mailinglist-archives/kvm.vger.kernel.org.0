Return-Path: <kvm+bounces-26235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77130973601
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FD07B24CB4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F269418DF97;
	Tue, 10 Sep 2024 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hZZJaLgg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA1618A6B9;
	Tue, 10 Sep 2024 11:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725966915; cv=none; b=fwNPoTEVzF2IZCq+iDk0r+Hzatw+ab1q7CSyVBQOinWcX+0SCbHcz0AVtfWB5nH9MVPqIa9QddHaRKCkUqi0gKP5sKEh7oaELAMlHr925voZVIp/5hv/UkVlYVQoJg3qxTNjO18+iQU18r5+JLHUpooNBXYmnSFN7GyWgxaFmDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725966915; c=relaxed/simple;
	bh=nqs0o+h1KdF/H50Mxp8SLZWpWhEws0D0OPKmKXw+CrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sul5GKyxkqASMuGMezsaYPzKcln/EU98FohKBSKPLW2nuiUGYIf1fCz/UFEmQv2D0LHG/XQCz4kbVZGtG8lb2UFZvF+a1OVkHpBvhc1ffT4+I0ddd5kgRxGqW20UmyGD+26OPzzSIxihzTFV7fpVLOAlZcIGvcx4/PPWybU7+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hZZJaLgg; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725966913; x=1757502913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nqs0o+h1KdF/H50Mxp8SLZWpWhEws0D0OPKmKXw+CrY=;
  b=hZZJaLggRIkey8/qkMN2jaknnAr4KtORlW1bC2IEhb9vAxod1gpKr+3W
   kFF491rn17mlVE7dlmjePnB+1EmLNfdzOnjqVkjwdVRvbvpC9nqTgfPXa
   Usa6w3BbZfJybdSSS8uI3idp8aWt17WJI+DCe/T5XhR4geXcuLc4C798B
   r2uQXO/hRD6yDC+VBhnXVhPKGvU3AMlVOin7kNZ+IjggrTaVgmCQB50wO
   N4roSMj4JM4vueZILiPLwOPwW/tsQyN7NranLN4pyI58ETXaYFyF8SbYZ
   pcQClzEpJAKlUGKx6hGR+ybz2aTtlkAJN67Ch/3Cdu3NEsQ8yiCqwXV0U
   g==;
X-CSE-ConnectionGUID: BoXuQNMVQayiwFqGwlc9BQ==
X-CSE-MsgGUID: 5EQ+hHzbQkOvNxcuCmOJUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24865214"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="24865214"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:15:12 -0700
X-CSE-ConnectionGUID: wabqkZBHQD2FN1rjUaAFng==
X-CSE-MsgGUID: yqA1uC7GQbaA1FW0igEiCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="67284049"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:15:08 -0700
Message-ID: <e58349f3-fa36-4635-9b2b-9ff8f2d88038@intel.com>
Date: Tue, 10 Sep 2024 14:15:02 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
 <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
 <5b2fa2b3-ca77-4d6e-a474-75c196b8fefc@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <5b2fa2b3-ca77-4d6e-a474-75c196b8fefc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/09/24 13:33, Paolo Bonzini wrote:
> On 9/4/24 17:37, Adrian Hunter wrote:
>> Isaku was going to lock the mmu.  Seems like the change got lost.
>> To protect against racing with KVM_PRE_FAULT_MEMORY,
>> KVM_TDX_INIT_MEM_REGION, tdx_sept_set_private_spte() etc
>> e.g. Rename tdx_td_finalizemr to __tdx_td_finalizemr and add:
>>
>> static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>> {
>>     int ret;
>>
>>     write_lock(&kvm->mmu_lock);
>>     ret = __tdx_td_finalizemr(kvm, cmd);
>>     write_unlock(&kvm->mmu_lock);
>>
>>     return ret;
>> }
> 
> kvm->slots_lock is better.  In tdx_vcpu_init_mem_region() you can take it before the is_td_finalized() so that there is a lock that is clearly protecting kvm_tdx->finalized between the two.  (I also suggest switching to guard() in tdx_vcpu_init_mem_region()).

Doesn't KVM_PRE_FAULT_MEMORY also need to be protected?

> 
> Also, I think that in patch 16 (whether merged or not) nr_premapped should not be incremented, once kvm_tdx->finalized has been set?

tdx_sept_set_private_spte() checks is_td_finalized() to decide
whether to call tdx_mem_page_aug() or tdx_mem_page_record_premap_cnt()
Refer patch 14 "KVM: TDX: Implement hooks to propagate changes
of TDP MMU mirror page table" for the addition of
tdx_sept_set_private_spte()



