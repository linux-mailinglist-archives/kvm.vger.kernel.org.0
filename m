Return-Path: <kvm+bounces-42018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6C4A710C2
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BE7117117A
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461F918DB19;
	Wed, 26 Mar 2025 06:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qjet6IAg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193E12AEE0
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742971732; cv=none; b=bAtmLnddGxO8pE/Usi2uFHDUnAJbe0uA0a4/0cu+k4+Sh5zEo3rCGphkkpAABY5pSOkprwq7YAGIHZv/bYonvRn/4c5gIpvdp7blvsYe6IQMSPI2vCm65L7Q3OGYv2Dq0UOp+2DXR8xScHnhZ5dZ1PI7PkDwzMQ8VKeJ2wUHy5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742971732; c=relaxed/simple;
	bh=lGHap775uUsDXdJ0pqioIOwfjJYZBUBsKzdh01RnGGQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JZjmiR8aY8epXlZb8IO1U3PA9SzUBjuxEyyPv4D6yPqPaZo/Hr3L5px+wh/OhCv0s2Jjyzs9iNdAv531soN3HVB3fmR21M3VBd7dYeTcPlElsnu1YMuS7Mz4yyXfmCsc4vylqRuXPmjaE8J4zRZR0vs2jMRBDta8vEQ1fmtV3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qjet6IAg; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742971730; x=1774507730;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=lGHap775uUsDXdJ0pqioIOwfjJYZBUBsKzdh01RnGGQ=;
  b=Qjet6IAgBM76ss+1Un5wz9y4WHql7ML90lKR9uwxvL24DJERujk0NNNu
   Gssw1/rO0Wm0wjWvR0NtDjGrCDvEb6sSQ4L5uxP4bRY9D+1Qq9++Z5Jw1
   b14Jxj58UjFcaeiHfahbNxSzfQ6i1epJFvq27t0gPdrOtOPFlJ166O6j9
   Aj/30uctoBpxNsL9ZSfyYzrTWLAKuptUtWd+H4b0+RhQMUSEBQqiQ2lZ9
   VNOLIXG2BUNX3qxNSfh8yMP6B5NqJP9dquEkBt5TYWXU+7Fv4UOteVrz0
   rQP5lnI2vAB8mMJK4+o2xJ4DcL9dYRlhMhcQhemNOjJKUzxb/6iM/JM/Z
   w==;
X-CSE-ConnectionGUID: hx9RzII6REmJX3Cuwf1oeA==
X-CSE-MsgGUID: VHCLuzaMTMu4nBW11kCQbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11384"; a="44345661"
X-IronPort-AV: E=Sophos;i="6.14,277,1736841600"; 
   d="scan'208";a="44345661"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2025 23:48:50 -0700
X-CSE-ConnectionGUID: 68MwVopJSLWzAXB4RNLlSw==
X-CSE-MsgGUID: r+iBB8MXQ2eGfmOr8YxMVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,277,1736841600"; 
   d="scan'208";a="125182656"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2025 23:48:46 -0700
Message-ID: <46f1d5cc-9ef0-4411-93e8-399d2c7e269b@intel.com>
Date: Wed, 26 Mar 2025 14:48:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 52/52] docs: Add TDX documentation
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-53-xiaoyao.li@intel.com>
 <Z-L6CSajU284qAJ4@redhat.com>
 <81e9d055-377c-4521-9588-a6bad60b3a6d@intel.com>
Content-Language: en-US
In-Reply-To: <81e9d055-377c-4521-9588-a6bad60b3a6d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/26/2025 11:36 AM, Xiaoyao Li wrote:
> On 3/26/2025 2:46 AM, Daniel P. Berrangé wrote:
>> On Fri, Jan 24, 2025 at 08:20:48AM -0500, Xiaoyao Li wrote:
>>> Add docs/system/i386/tdx.rst for TDX support, and add tdx in
>>> confidential-guest-support.rst
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>
>>> ---
>>>   docs/system/confidential-guest-support.rst |   1 +
>>>   docs/system/i386/tdx.rst                   | 156 +++++++++++++++++++++
>>>   docs/system/target-i386.rst                |   1 +
>>>   3 files changed, 158 insertions(+)
>>>   create mode 100644 docs/system/i386/tdx.rst
>>
>>
>>> +Launching a TD (TDX VM)
>>> +-----------------------
>>> +
>>> +To launch a TD, the necessary command line options are tdx-guest 
>>> object and
>>> +split kernel-irqchip, as below:
>>> +
>>> +.. parsed-literal::
>>> +
>>> +    |qemu_system_x86| \\
>>> +        -object tdx-guest,id=tdx0 \\
>>> +        -machine ...,kernel-irqchip=split,confidential-guest- 
>>> support=tdx0 \\
>>> +        -bios OVMF.fd \\
>>> +
>>> +Restrictions
>>> +------------
>>> +
>>> + - kernel-irqchip must be split;
>>
>> Is there a reason why we don't make QEMU set kernel-irqchip=split
>> automatically when tdx-guest is enabled ?
>>
>> It feels silly to default to a configuration that is known to be
>> broken with TDX. I thought about making libvirt automatically
>> set kernel-irqchip=split, or even above that making virt-install
>> automatically set it. Addressing it in QEMU would seem the most
>> appropriate place though.
> 
> For x86, if not with machine older than machine-4.0, the default 
> kernel_irqchip is set to split when users don't set a value explicitly:
> 
>   if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
>          s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? 
> ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>      }

Ah! it happens later than tdx_kvm_init(). So we need something like...

> 
> I think QEMU should only set it to split automatically for TDX guest 
> when users don't provide a explicit value. And current code just works 
> as expected.
> 
> Further, I think we can at least add the check in tdx_kvm_init() like this
> 
> if (kvm_state->kernel_irqchip_split != ON_OFF_AUTO_ON) {
>      error_setg(errp, "TDX VM requires kernel_irqchip to be split");
>      return -EINVAL;
> }

...

@@ -693,6 +694,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport 
*cgs, Error **errp)
          return -EINVAL;
      }

+    if (kvm_state->kernel_irqchip_split == ON_OFF_AUTO_AUTO ) {
+        kvm_state->kernel_irqchip_split = ON_OFF_AUTO_ON;
+    } else if(kvm_state->kernel_irqchip_split != ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM requires kernel_irqchip to be split");
+        return -EINVAL;
+    }


> Are you OK with it?
> 
>>
>> With regards,
>> Daniel
> 
> 


