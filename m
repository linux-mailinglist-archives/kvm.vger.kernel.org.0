Return-Path: <kvm+bounces-60078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54677BDF251
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 16:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43AB63A74D4
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 14:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9177288C96;
	Wed, 15 Oct 2025 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEHUbJPR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BBE146593;
	Wed, 15 Oct 2025 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760539531; cv=none; b=mvVMIyH1PM/bgaYJHWTYhtFUS0VCVLY2yTqcNhu7g29I1yOlg+FjAtBhy8avOAb8usFfIvOyRbny7elPgZtiOjPRoa5x5VrJUgKHPyzkvi0snvjqtgc2UKDofEhox0nLcMkbkmVGO41zdoEfmJsGVShiSgDflyHsg1DP/TtWITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760539531; c=relaxed/simple;
	bh=DxykulbCclXQIdOChVzul8ruhiC9vL4ODdzyxdPg/UQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXDfjGD02Wfsw9n6T/hJ3rpfLztUWICUQbtvQUktcF8lUpRbKCRuU1//djOrDeKKqX4+zK7T0/zcjpI+ApcxJpz/ppYa4Y1jfAqW89nuyeLuJkGhQorSyXo8kiDDBpvZYKzVV3/DRvzEDLjn+P+wr5eJvYm1bpTjB9nM7A8ZTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEHUbJPR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760539530; x=1792075530;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DxykulbCclXQIdOChVzul8ruhiC9vL4ODdzyxdPg/UQ=;
  b=dEHUbJPROoENL+zYm9P4yMgSOoPUDyk+Yd6fTdh1jnrwTZRlNQvE9FEM
   Xy5JAgd8p1UsaaYyM8QenthzS1NJZ0OMBwl0gv8demP/8xoh0y/VvIup2
   532cqaxjpG2HlGK9vKDaGepnluse1duUNk0Eyiw+l3ZE7jgNre4TbMee/
   v0yN734B2XW1aoKXat3OMcw5MkCPoNDMpa8ObruDg8qhLaM6iEex3Qkxg
   D8H/f1cpvbI1aEf5YVUekX9Zm8hVuEvV0BGpQHv8eE2O7Y5iQV8FZkMUs
   1L660530DwKcysBfGz4LaYH0wbk7fJ+zObdQkOkoWxIj5hqOXp+Hpu7UG
   A==;
X-CSE-ConnectionGUID: WyFAgWzBSuGiIweSAI0qyg==
X-CSE-MsgGUID: uH50NfsTRRmyqGvIj+Dz4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62617523"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="62617523"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 07:45:29 -0700
X-CSE-ConnectionGUID: H2ArtWPnRlyznsJ9jqrtLQ==
X-CSE-MsgGUID: skdx+DmTQVu2q9LH+b/iNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="186457103"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 07:45:27 -0700
Message-ID: <456146b7-e4f3-46d4-8b30-8b0ccb250f08@intel.com>
Date: Wed, 15 Oct 2025 22:45:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20251014231042.1399849-1-seanjc@google.com>
 <b12f4ba6-bf52-4378-a107-f519eb575281@intel.com>
 <aO-oTw_l9mU1blRo@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aO-oTw_l9mU1blRo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/2025 9:57 PM, Sean Christopherson wrote:
> On Wed, Oct 15, 2025, Xiaoyao Li wrote:
>> On 10/15/2025 7:10 AM, Sean Christopherson wrote:
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 76271962cb70..f64a1eb241b6 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>>>    	case EXIT_REASON_NOTIFY:
>>>    		/* Notify VM exit is not exposed to L1 */
>>>    		return false;
>>> +	case EXIT_REASON_SEAMCALL:
>>> +	case EXIT_REASON_TDCALL:
>>> +		/*
>>> +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
>>> +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
>>> +		 * never want or expect such an exit.
>>> +		 */
>>
>> The i.e. part is confusing? It is exactly forwarding the EXITs to L1, while
>> it says L1 should never want or expect such an exit.
> 
> Gah, the comment is right, the code is wrong.

So the intent was to return false here? to let L0 handle the exit?

Then I have a question, why not implement it in 
nested_vmx_l0_wants_exit()? what's the reason and rule here?


> /facepalm
> 
> I even tried to explicitly test this, but I put the TDCALL and SEAMCALL in L1
> instead of L2.
> 
> diff --git a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
> index a100ee5f0009..1d7ef7d2d381 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
> +++ b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
> @@ -23,11 +23,17 @@ static void l2_guest_code(void)
>                       : : [port] "d" (ARBITRARY_IO_PORT) : "rax");
>   }
>   
> +#define tdcall         ".byte 0x66,0x0f,0x01,0xcc"
> +#define seamcall       ".byte 0x66,0x0f,0x01,0xcf"
> +
>   static void l1_guest_code(struct vmx_pages *vmx_pages)
>   {
>   #define L2_GUEST_STACK_SIZE 64
>          unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>   
> +       TEST_ASSERT_EQ(kvm_asm_safe(tdcall), UD_VECTOR);
> +       TEST_ASSERT_EQ(kvm_asm_safe(seamcall), UD_VECTOR);
> +
>          GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
>          GUEST_ASSERT(load_vmcs(vmx_pages));
>   


