Return-Path: <kvm+bounces-24080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494F8951167
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C6ED1C20DB9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10341D53B;
	Wed, 14 Aug 2024 01:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCy6f8Wf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61463B64C;
	Wed, 14 Aug 2024 01:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597708; cv=none; b=fdDFtHM7+J8eoyp5gb29duRMoiCRWEOtFzuVkXeVJLIvYeXJ06AiA8GAmqeqCSUnJHjX60LTGdoi/p1dx26az+b8X9oeHhYirdDsdVXFwFXoDfizoH74GU2i5b8IZj6tbD/zdsIuYLYUagdUTHwQU1v+mxXfaL1rdM+1gHFrB4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597708; c=relaxed/simple;
	bh=1LLecFKbdlY1ORK5ICtphoAdaf2o9+XzjhbLF7AVSoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0ZaSYHeQ1AwXMGAVPBg3DQzSPt0NEESLbLEfQ2PsE0p2MeI2nfOFSakQLVVCrROhXO+UHsp1ber7JThpGa/bWVzm2fXigLgLIqbBa9Px35LzO1/6QjYBffjPfENOo3LoMeRyq0k7bj4F0e8+TKKBkYlX/PIdRl06ttm8Mg1qDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCy6f8Wf; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723597706; x=1755133706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1LLecFKbdlY1ORK5ICtphoAdaf2o9+XzjhbLF7AVSoU=;
  b=HCy6f8Wfk3PxMdp7xw+X/i91TxXkmyUz+b196S5mWQoR4GXXlswtliVK
   VnynNT0Mygq7QNElPenQocwVkNTAQw5jGG5/npOUSIiVaoQBvY1HUZboG
   ++EAQXfMkwJ+ITi9OJ8YMMy0sdSTvKgQdTwnOpm/Z33eyp9ZHqwSWdB7M
   +CjaS6WoMAttiyc5zx58Wtu0Sj8AOGRfhPRlVX3ZqaNLlW/K4NuGSyLxK
   JygcqbnBCM9MfSUigjYrD1pr5wcpKYseBJ+vtFtDTxU+AZ7eA0kjxJBca
   L81K0S/xOl/L0UpGW7YRN6Zq/rwPCcBFDmJ5EQBD8edUhAmYgXr3uUbBZ
   Q==;
X-CSE-ConnectionGUID: AsbyC87HQDyHmZltw5V19w==
X-CSE-MsgGUID: rAXZ+5WJTuSIHidJWI5+NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="47192144"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="47192144"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 18:08:24 -0700
X-CSE-ConnectionGUID: O7KOKWLLQ1KgQwcwgK2FoQ==
X-CSE-MsgGUID: 9JvOTEiBR1ie2FeDCW4TWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63782319"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 18:08:23 -0700
Message-ID: <a0757b84-1a68-44c9-972a-1d6cc72b6a09@linux.intel.com>
Date: Wed, 14 Aug 2024 09:08:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: "Huang, Kai" <kai.huang@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
 rick.p.edgecombe@intel.com, michael.roth@amd.com
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <d7ae5009-748f-4aa2-937e-d805a3172216@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d7ae5009-748f-4aa2-937e-d805a3172216@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 8/14/2024 7:16 AM, Huang, Kai wrote:
>
>
> On 13/08/2024 5:12 pm, Binbin Wu wrote:
>> Check whether a KVM hypercall needs to exit to userspace or not based on
>> hypercall_exit_enabled field of struct kvm_arch.
>>
>> Userspace can request a hypercall to exit to userspace for handling by
>> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
>> hypercall_exit_enabled.  Make the check code generic based on it.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
>
> One nitpicking below:
>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++--
>>   arch/x86/kvm/x86.h | 7 +++++++
>>   2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index af6c8cf6a37a..6e16c9751af7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>       cpl = kvm_x86_call(get_cpl)(vcpu);
>>         ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, 
>> op_64_bit, cpl);
>> -    if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>> -        /* MAP_GPA tosses the request to the user space. */
>> +    if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
>> +        /* The hypercall is requested to exit to userspace. */
>>           return 0;
>
> I believe you put "!ret" check first for a reason?  Perhaps you can 
> add a comment.
>
>
Yes, check "!ret" first to make sure the input of 
is_kvm_hc_exit_enabled() is a valid KVM_HC_*.
Will add a comment.
Thanks.


