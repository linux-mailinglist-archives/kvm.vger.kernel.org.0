Return-Path: <kvm+bounces-35618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA34A1331B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 07:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DE0D3A671F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313B1193407;
	Thu, 16 Jan 2025 06:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yjj5fVYr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A41C14A62A;
	Thu, 16 Jan 2025 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737008892; cv=none; b=hHVxUMsI4EA3vM9GAxj8M6ffXRePLSoQH+kQMLb99oMmUcFwjXDU3FQW/l7M/xwuRRrXSoJmoVxQqq8lUuEuzz7L84UtbIpzHSpDb4JLqfw9KdNEA7mycXl2A918xBLMZbBl/GF+ujQS/7QdvZApJrYeRBXG0MFFwLgU3IIBnvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737008892; c=relaxed/simple;
	bh=lNObo4hDlL4EY6vw0EN2XiMroY2fGnYicRvlaLi1G6Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uSqG2Y6BiU4kaBPXuqlCsnTbrqd20TBbYdi5SE4a0MuAxfjh01+TIoc/cxARoXVEEldUoMoSWErW06XEQlzrKhVvVN2KL2iMBDnoSUSESNoNC0ov0WswT8jnCDlvgt41s2+W6KrEcAAW66x8QpxN0QXHHBqbWC6oyWI57uo9HiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yjj5fVYr; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737008890; x=1768544890;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=lNObo4hDlL4EY6vw0EN2XiMroY2fGnYicRvlaLi1G6Y=;
  b=Yjj5fVYrGOzyecbWguMFbSdzUzgHAPPnC/fZvPRPYiSnfLt7wiISRQww
   ANBPPYbYFVUPm2cX9WnAa3ZCxdWgJrN36pOHre99GSFPi/lVQxevXH5dY
   9c0pyDIC3/dUEwtypTEo3JF0lROku/izOWYyHWh/dQ41FlP1XpoGiLGhg
   0aTco/I/8ZN3TaQClx5Gs6tt0pUpkzm0QJ/5w8V2ot9N8rW2XWbrY45U7
   x0vW1H4x9K/JBM9SJ39XxysocDDetHesTkpWF4ty5GCYvSqmceJd29Hh4
   6pM7wAZUKAKOrAeTruJBZ3AOLsr3Dpv52fiuixMeu8CRJnuKjqRmTuinx
   A==;
X-CSE-ConnectionGUID: OLXV7J73TSO0sN1vHXHoow==
X-CSE-MsgGUID: 7VyVJscdSMaIrUznXwtKmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="37532300"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="37532300"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:28:09 -0800
X-CSE-ConnectionGUID: 4h/G5g1LSOid/h9tGCF1Dw==
X-CSE-MsgGUID: Y7iQMlUGSbC2BXWvn237og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105922710"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:28:06 -0800
Message-ID: <61a39104-2ee6-41b3-9eef-332f3a941f2c@linux.intel.com>
Date: Thu, 16 Jan 2025 14:28:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Kick off vCPUs when SEAMCALL is busy during
 TD page removal
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, dmatlack@google.com,
 isaku.yamahata@intel.com, isaku.yamahata@gmail.com
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021250.18948-1-yan.y.zhao@intel.com>
 <8f350bcc-c819-45cf-a1d5-7d72975912d9@linux.intel.com>
Content-Language: en-US
In-Reply-To: <8f350bcc-c819-45cf-a1d5-7d72975912d9@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/16/2025 2:23 PM, Binbin Wu wrote:
>
>
>
> On 1/13/2025 10:12 AM, Yan Zhao wrote:
> [...]
>> +
>>   /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
>>   static int __tdx_reclaim_page(hpa_t pa)
>>   {
>> @@ -979,6 +999,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>           return EXIT_FASTPATH_NONE;
>>       }
>>   +    /*
>> +     * Wait until retry of SEPT-zap-related SEAMCALL completes before
>> +     * allowing vCPU entry to avoid contention with tdh_vp_enter() and
>> +     * TDCALLs.
>> +     */
>> +    if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
>> +        return EXIT_FASTPATH_EXIT_HANDLED;
>> +
>>       trace_kvm_entry(vcpu, force_immediate_exit);
>>         if (pi_test_on(&tdx->pi_desc)) {
>> @@ -1647,15 +1675,23 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>>       if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
>>           return -EINVAL;
>>   -    do {
>> +    /*
>> +     * When zapping private page, write lock is held. So no race condition
>> +     * with other vcpu sept operation.
>> +     * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
>> +     */
>> +    err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
>> +                  &level_state);
>> +    if ((err & TDX_OPERAND_BUSY)) {
>
> It is not safe to use "err & TDX_OPERAND_BUSY".
> E.g., if the error is TDX_EPT_WALK_FAILED, "err & TDX_OPERAND_BUSY" will be true.
>
> Maybe you can add a helper to check it.
>
> staticinlinebooltdx_operand_busy(u64err)
> {
> return(err &TDX_SEAMCALL_STATUS_MASK) ==TDX_OPERAND_BUSY;
> }
>
Don't know why some spaces were dropped by thunderbird. :-(

>
>>           /*
>> -         * When zapping private page, write lock is held. So no race
>> -         * condition with other vcpu sept operation.  Race only with
>> -         * TDH.VP.ENTER.
>> +         * The second retry is expected to succeed after kicking off all
>> +         * other vCPUs and prevent them from invoking TDH.VP.ENTER.
>>            */
>> +        tdx_no_vcpus_enter_start(kvm);
>>           err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
>>                         &level_state);
>> -    } while (unlikely(err == TDX_ERROR_SEPT_BUSY));
>> +        tdx_no_vcpus_enter_stop(kvm);
>> +    }
>>         if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
>>                err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
>> @@ -1726,8 +1762,12 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>>       WARN_ON_ONCE(level != PG_LEVEL_4K);
>>         err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
>> -    if (unlikely(err == TDX_ERROR_SEPT_BUSY))
>> -        return -EAGAIN;
>> +    if (unlikely(err & TDX_OPERAND_BUSY)) {
> Ditto.
>
>> +        /* After no vCPUs enter, the second retry is expected to succeed */
>> +        tdx_no_vcpus_enter_start(kvm);
>> +        err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
>> +        tdx_no_vcpus_enter_stop(kvm);
>> +    }
>>       if (KVM_BUG_ON(err, kvm)) {
>>           pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
>>           return -EIO;
>> @@ -1770,9 +1810,13 @@ static void tdx_track(struct kvm *kvm)
>>         lockdep_assert_held_write(&kvm->mmu_lock);
>>   -    do {
>> +    err = tdh_mem_track(kvm_tdx->tdr_pa);
>> +    if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY) {
>> +        /* After no vCPUs enter, the second retry is expected to succeed */
>> +        tdx_no_vcpus_enter_start(kvm);
>>           err = tdh_mem_track(kvm_tdx->tdr_pa);
>> -    } while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
>> +        tdx_no_vcpus_enter_stop(kvm);
>> +    }
>>
> [...]
>


