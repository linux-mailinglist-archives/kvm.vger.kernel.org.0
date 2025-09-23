Return-Path: <kvm+bounces-58534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CDABB962C2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79BA918A06D2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5617F233722;
	Tue, 23 Sep 2025 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aR+AoqiP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88921019C;
	Tue, 23 Sep 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637026; cv=none; b=Grz+il3vUYWeDlr7MfLOmaj2euuC0mbqedV0uER+WOBHvAyThANoOvwCYuiejFfqVk4WT7TOfQQNNEXgXenbSGoABOX7j/SA70ePoIKt5RF7K07JANjaZVZ8uQ/+VF9d52QOXeCpwU08s5/7ge2zrZJcGQVsGCx7rp8ND3cpxik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637026; c=relaxed/simple;
	bh=HhfQ8qFnuoue9N89ZUhfgvfqB9CtjDf8lF3wfCaFCP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AaVczR8X/i3hGCszHHiuKogLV7UuD7OsqkTvmFKp5LuNCe9BrLS9TmXqP7uwa+BnclpvE40TCwkaLYoSAgpmhWmFeb9xER0I+03KUhFICzEREf3HlFSTtYUfsrq9RfTwyqOkkmqz27mtItkHYiGV+bPHQ1aa7UVt2QvyEJhJnss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aR+AoqiP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758637025; x=1790173025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HhfQ8qFnuoue9N89ZUhfgvfqB9CtjDf8lF3wfCaFCP4=;
  b=aR+AoqiPRMvUaxvUL/EAN7Vdj1KudpN3DjgM8Gw+U+YpSqFm4x4AfJ9o
   fQ6uyu8rqd1v2WOjI62ZHYNnVgZBGu95+BK0hLk4IoS5GPemUtHePNq5d
   yHHttqfiJV63JcvO+Hx8lLLzxhvmWw4Y03CsYkshEExHxG3FhAsr1zVR5
   /Ah5S4j1znY/LyAuuZplbyePuTMaD3Ab12+4+meW7V5ii5b1dH3P9IVtv
   fouhrm0OEPHpaiv2D2Cz1lJ4Q27Qh+pm+kwG3YyK6EIcpFqtKSHCDpF1n
   QSYvpLFVaQYnVeHV2mvPliQZ4Cjctervu34mY7fyXGhBmNoKjWGB83FMe
   g==;
X-CSE-ConnectionGUID: 9UlBbuPPSeW0WH7ZuJuWXQ==
X-CSE-MsgGUID: hzqP2crLSNCNZekEn4Q2Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60968568"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60968568"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:17:04 -0700
X-CSE-ConnectionGUID: G5N869BDQt2GFauEQX/Rwg==
X-CSE-MsgGUID: HicRN2vSSlS+9cE/bZiUcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="207532883"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:17:01 -0700
Message-ID: <c93438be-642b-47f1-b4ff-9551b9192471@intel.com>
Date: Tue, 23 Sep 2025 22:16:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 19/51] KVM: x86: Don't emulate task switches when IBT
 or SHSTK is enabled
To: Sean Christopherson <seanjc@google.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z
 <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-20-seanjc@google.com>
 <b89600a2-c3ae-4bb6-8c91-ea9a1dd507fb@linux.intel.com>
 <aNGGKm0Yzjvn3YVv@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aNGGKm0Yzjvn3YVv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/2025 1:23 AM, Sean Christopherson wrote:
> On Mon, Sep 22, 2025, Binbin Wu wrote:
>>
>>
>> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
>>> Exit to userspace with KVM_INTERNAL_ERROR_EMULATION if the guest triggers
>>> task switch emulation with Indirect Branch Tracking or Shadow Stacks
>>> enabled,
>>
>> The code just does it when shadow stack is enabled.
> 
> Doh.  Fixed that and the EMULATION_FAILED typo Chao pointed out:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8b31dfcb1de9..06a88a2b08d7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12194,9 +12194,9 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>                   */
>                  if (__kvm_emulate_msr_read(vcpu, MSR_IA32_U_CET, &u_cet) ||
>                      __kvm_emulate_msr_read(vcpu, MSR_IA32_S_CET, &s_cet))
> -                       return EMULATION_FAILED;
> +                       goto unhandled_task_switch;
>   
> -               if ((u_cet | s_cet) & CET_SHSTK_EN)
> +               if ((u_cet | s_cet) & (CET_ENDBR_EN | CET_SHSTK_EN))
>                          goto unhandled_task_switch;
>          }

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

