Return-Path: <kvm+bounces-53192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61909B0ED7A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D58E1C8300C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48F1280330;
	Wed, 23 Jul 2025 08:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcyDt4sF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725F27990C
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260154; cv=none; b=ejAxEEaCNOShmQmBKLhFqBX1OMYm2tpyZA3vOyzyosMY2YT3fZQjAOwfGMq4MMceu3wOFP3+7bF836Hk9ZtOMpvehrA86qzrx9nVwMaPOdE2/nDzxBLR6CfgnUA7eWEQfFZ64flpj5IpmAp5wPwJW38m5y27fYQvRTyWDy1TzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260154; c=relaxed/simple;
	bh=QNYAp68jc80gMi8DboSo831/pCWYJq8t+unCh2agpCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjPSeGFM8Gp4sd544teqEplb1KN22+Ndpgj3TGwud/RNc+qGg2cZ8vSTLfOdRpLi7Hl5CY/0CiXMIJLA5FhiFqOLy5/emB1ge4LGznn0xKyYUQ0sD09uEzL99HyG/aBMlxP+koDaeM8n518rjWO/ytMa4YzI9rUWol0DoapfeJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcyDt4sF; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753260152; x=1784796152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QNYAp68jc80gMi8DboSo831/pCWYJq8t+unCh2agpCo=;
  b=KcyDt4sFt+CyKQb/ZeMcBuvpPSDkC7WTyAIh60+oCvANbpo681Xm4UxQ
   dQBmnkv4YsdR18SCN3gCaKDcRmUVWtKlGDxsirrpGLcZKHgGBRxDuFJLj
   IUIxZtDmEyrSzZcnisxZXlb1Sm1yw8AHe8sxp1jWW55CN74WxueV3O84j
   Th6OUc9Ejqhd3BGQDTFiTIfHBxbuvWnxJSJyOW9ccidEde6XgspiqpHiU
   VZ4rDpxYaXY6KFLeYe9xsQZwA43+IWfiCzKRQkEGp/YanvnAWLGiXA81e
   ElH6CX6FFpb4AhZCsoTghbLPoqc6Wxg0ZJtxIlQhJZzy2acx4Mj5KNxwC
   g==;
X-CSE-ConnectionGUID: V7ORXNSFQuCTRLMwM7ND0Q==
X-CSE-MsgGUID: 6Imc0JL9Rc6tqIP1sXHZxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59351796"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="59351796"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:42:32 -0700
X-CSE-ConnectionGUID: c2/SzqT6QzO8r37kmmWaBQ==
X-CSE-MsgGUID: Ryun+ZNWTSSf0WZQv13n6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="160114778"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:42:30 -0700
Message-ID: <fbd47fb6-838e-47bf-a344-f90be06eed99@intel.com>
Date: Wed, 23 Jul 2025 16:42:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] i386/kvm: Disable hypercall patching quirk by default
To: Mathias Krause <minipli@grsecurity.net>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250722204316.1186096-1-minipli@grsecurity.net>
 <206a04b9-91cb-41e4-b762-92201c659d78@intel.com>
 <ebbb7c3c-b8cb-49b6-a029-e291105300fd@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ebbb7c3c-b8cb-49b6-a029-e291105300fd@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/23/2025 3:53 PM, Mathias Krause wrote:
>> I would leave it to Paolo to decide whether a compat property is needed
>> to disable the hypercall patching by default for newer machine, and keep
>> the old machine with old behavior (hypercall patching is enabled) by
>> default.
> Bleh, I just noticed that there are KUT tests that actually rely on the
> feature[1]. I'll fix these but, looks like, we need to default on for
> the feature -- at least for existing machine definitions 🙁

You reminds me.

There is also even a specific KUT hypercall.c, and default off fails it 
as well.

enabling apic
smp: waiting for 0 APs
Hypercall via VMCALL: OK
Unhandled exception 6 #UD at ip 00000000004003dd
error_code=0000      rflags=00010002      cs=00000008
rax=00000000ffffffff rcx=00000000000003fd rdx=00000000000003f8 
rbx=0000000000000001
rbp=0000000000710ff0 rsi=00000000007107b1 rdi=000000000000000a
  r8=00000000007107b1  r9=00000000000003f8 r10=000000000000000d 
r11=0000000000000020
r12=0000000000000001 r13=0000000000000000 r14=0000000000000000 
r15=0000000000000000
cr0=0000000080000011 cr2=0000000000000000 cr3=000000000040c000 
cr4=0000000000000020
cr8=0000000000000000
	STACK: @4003dd 4001ad
  > Looks like I have to go the compat property route.
> 
> [1]
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/x86/ 
> vmexit.c?ref_type=heads#L36


