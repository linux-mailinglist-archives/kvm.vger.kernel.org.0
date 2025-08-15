Return-Path: <kvm+bounces-54762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCEFB27651
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 056AF1B6422D
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2CB2BD5A3;
	Fri, 15 Aug 2025 02:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oh0T+hif"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80A29ACED;
	Fri, 15 Aug 2025 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226054; cv=none; b=cDADD+DHHK7QUHPxOMhyqvr1TgqJxqv9DUSRJwDz1ipyC8GnbVdR1LOuheBvcV6yE/x4eUUebrGTic1dl2xX3Rl+rTtgVMP7xbIRXKMLMefefrfnK42Qz0THDSBxQw7wijGKtym1bIuCZT70rMI8m1GKIMDOWi/RBDN9bokX7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226054; c=relaxed/simple;
	bh=tUeCc9ThgrHoqXZlg9UZj7CL5h9CrTzdS+fOkqe0qYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwlIFjRID2FXksmH/vsyDUJOSDUrSBsGBHnfvwMcyL2CSqjRvBLZl6SLqSX9Cxgm2wad4b0vA32c57c4JFxoq2Eb3HYOI5VB/d/Kw6CALjILVUwbi3bI6uGFcYjndYfCv2Ugc9JhxCJ64b6vbj3ubiS6hywPEc1j5gTXwVRaeDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oh0T+hif; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755226053; x=1786762053;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tUeCc9ThgrHoqXZlg9UZj7CL5h9CrTzdS+fOkqe0qYg=;
  b=Oh0T+hifYhufXnayXUNDcO3U+faclzywXsIAzr9FFmZ7fmzTaCXFOZJY
   VVQxHiCrfRCUY54xw0EWdndssEjF+DqLQDlYk3Eyfhu+gIRnbSTe2cbXU
   bx2obFPl23iRSAiNDpr7oUfbn4FXfNsHw2QyQDi5WK7NFBTodNaJthzgO
   2YhTfNZHjFopImkM383yZV/iIylhfn74hY5GRvUcAxMCAL6006gXINSOz
   GezOs+6kBmWRxyW9oPRPTZ/zxnkug8y96S4Y3Qf2TJ/LdT1eqa7FuxAh9
   ZVx3Ch0nH73Ihl95ltm+Coq9yqG3obDl5rF6IVsGaShbhMn/AREio5Zts
   Q==;
X-CSE-ConnectionGUID: qY484xyWSXSQN+l5h7RXHg==
X-CSE-MsgGUID: yXbkP92+RGyYOBKniVHSnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="67822342"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="67822342"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 19:47:32 -0700
X-CSE-ConnectionGUID: QNJit5/IQiO/mRXOgmG1Ig==
X-CSE-MsgGUID: lDe+5FosRvyosWE0PxClsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167269050"
Received: from hmao3-mobl1.ccr.corp.intel.com (HELO [10.238.0.213]) ([10.238.0.213])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 19:47:29 -0700
Message-ID: <066780ea-95f0-49c4-938a-3405975ebf60@intel.com>
Date: Fri, 15 Aug 2025 10:47:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [????] RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism
 to virt_spin_lock
To: Peter Zijlstra <peterz@infradead.org>, "Li,Rongqing"
 <lirongqing@baidu.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Tianyou" <tianyou.li@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
 <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
 <bb474c693d77428eb0336566150a1ea3@baidu.com>
 <20250814104156.GV4067720@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Guo, Wangyang" <wangyang.guo@intel.com>
In-Reply-To: <20250814104156.GV4067720@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2025 6:41 PM, Peter Zijlstra wrote:
> On Thu, Aug 14, 2025 at 03:10:46AM +0000, Li,Rongqing wrote:
>>> On 8/13/2025 10:33 PM, Peter Zijlstra wrote:
>>>> On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
>>>>> Binary exponential backoff is introduced. As try-lock attempt
>>>>> increases, there is more likely that a larger number threads compete
>>>>> for the same lock, so increase wait time in exponential.
>>>>
>>>> You shouldn't be using virt_spin_lock() to begin with. That means
>>>> you've misconfigured your guest.
>>>>
>>>> We have paravirt spinlocks for a reason.
>>>
>>> We have tried PARAVIRT_SPINLOCKS, it can help to reduce the contention cycles,
>>> but the throughput is not good. I think there are two factors:
>>>
>>> 1. the VM is not overcommit, each thread has its CPU resources to doing spin
>>> wait.
>>
>> If vm is not overcommit, guest should have KVM_HINTS_REALTIME, I think native qspinlock should be better
>> Could you try test this patch
>> https://patchwork.kernel.org/project/kvm/patch/20250722110005.4988-1-lirongqing@baidu.com/
> 
> Right, that's the knob.

Yes, that works.
By providing qemu-kvm with `-cpu host,kvm-hint-dedicated` option, it can 
use mcs qspinlock and have better performance compared to virt_spin_lock().

But for non-overcommit VM, we may add `-overcommit cpu-pm=on` to let 
guest to handle idle by itself and reduce the guest latency. Current 
kernel will fallback to virt_spin_lock, even kvm-hint-dedicated is 
provided. With Rongqing's patch, it can fix this problem.

BR
Wangyang


