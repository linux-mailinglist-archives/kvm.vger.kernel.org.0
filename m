Return-Path: <kvm+bounces-8210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43ACB84C4F6
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 07:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7686E1C24317
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 06:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DE31CD35;
	Wed,  7 Feb 2024 06:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2TcFVBd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B911BF2F;
	Wed,  7 Feb 2024 06:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707287182; cv=none; b=S8ke533lZYxxBpczpYcV1U05YUPYp5Bc7s/WBu4Wis8UX3NwRXHzi+3sy/aaUyTYt1nXb2jwKLMLjD1iLfbfqbm6qcshZOsJmYyLvQ+IzRFoV7NfjSx5mvxaEHzVeH+VOwQUJYcXyH9qmv8+lGHoGmDc/s72LCCp5nhZNt6uqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707287182; c=relaxed/simple;
	bh=JR4iOw+Y89uOOayhfwGLM6PMQqlJE72PkLkGScVGlEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hy2IFo0Xl2atrSbs1+6iV0CF5SvDW8NcY08VEQBbvaIeuitlEeH7xPNLAjbgJsm+feoXdplV5rMk46T0hrZe3lpi4fg0sHTwvCcnoUJvEoHeDEioRF79Kz0C1eNo0NUjO8OJv8+dGuH8QR1dGcrFGhGfOZ/mvWRvtC8ZVZtEZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2TcFVBd; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707287179; x=1738823179;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JR4iOw+Y89uOOayhfwGLM6PMQqlJE72PkLkGScVGlEY=;
  b=j2TcFVBd7v6A6aj7waG2BYmDBkADYOynAss1utJVNrpS8iGVrAYCsTWx
   nbgRxCIVM1cpHCaAMDWpn5ODTrIDWbAVAzj9QB54zGRF2vM3L8GvB+6hi
   UZ0uI4hGosLxZQsE4EZa9MdJpA2dOWS1nW6c8k4pEjLvI6dcwhCKw+Nns
   NmbPNPliIk5iTbNQlkiLDhA9i4ceIbDyEiLQEZKGK1gwotMuduAaJkqpE
   s2Q5G9rpOpGXncEEFb3t3GLzJDa1nrhsn19YyDxNagP0t5rlQIB+EW9NB
   tyYR7CBAtHNI2cBnMWvFqkhXPGXmLLpOJKW8q7D6qHNRuiHnicXYrZ0Fu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="395336114"
X-IronPort-AV: E=Sophos;i="6.05,250,1701158400"; 
   d="scan'208";a="395336114"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 22:26:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,250,1701158400"; 
   d="scan'208";a="1268658"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 22:26:15 -0800
Message-ID: <2a5c652f-6e14-4ed7-accd-1cc49f099701@intel.com>
Date: Wed, 7 Feb 2024 14:26:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/asyncpf: Fixes the size of asyncpf PV data and
 related docs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Wanpeng Li <wanpengli@tencent.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
 <170724645418.390975.5795716772259959043.b4-ty@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <170724645418.390975.5795716772259959043.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/2024 5:36 AM, Sean Christopherson wrote:
> On Wed, 25 Oct 2023 01:59:12 -0400, Xiaoyao Li wrote:
>> First patch tries to make the size of 'struct kvm_vcpu_pv_apf_data'
>> matched with its documentation.
>>
>> Second patch fixes the wrong description of the MSR_KVM_ASYNC_PF_EN
>> documentation and some minor improvement.
>>
>> v1: https://lore.kernel.org/all/ZS7ERnnRqs8Fl0ZF@google.com/T/#m0e12562199923ab58975d4ae9abaeb4a57597893
>>
>> [...]
> 
> Applied to kvm-x86 asyncpf_abi.  I'll send a pull request (for 6.9) to Paolo
> "soon" to ensure we get his eyeballs on the ABI change.

Thanks!

> [1/2] x86/kvm/async_pf: Use separate percpu variable to track the enabling of asyncpf
>        https://github.com/kvm-x86/linux/commit/ccb2280ec2f9
> [2/2] KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN
>        https://github.com/kvm-x86/linux/commit/df01f0a1165c
> 
> --
> https://github.com/kvm-x86/linux/tree/next


