Return-Path: <kvm+bounces-35356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D130AA101E5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED14F162965
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42F924634B;
	Tue, 14 Jan 2025 08:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtL2zcIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644AE1C3BE0;
	Tue, 14 Jan 2025 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736842826; cv=none; b=XTYwLK3tzH3/QIcIKfLOu7LWYCUigKNz2mAze0K5tBW/xy12rc3ZrKxJB3fZF3vHKC1iLxTU4nh3OUOljDM4YvfbXnywPhLQ9CBKjLg7dPsFdQ4N+Vk2/6i7AlNTHnTTmUtPXPAtOxQbTKxr5bSNF9zL6+HIyIZsxBQBHK9Nn5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736842826; c=relaxed/simple;
	bh=DGs58fUirPBcZE1LcNn7ZHkjvBrWoX0jYAnBFh0vKS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUVeqnYduHqz16y5WZZgBeffJ5Gcs1ScNOdjx56wOg6+Yad4q3m8VFWWHiYe2QXh9UB2DNNsaJCp+QEvRfIcVqskkeBXvrJ2n9VGb1vd8rF4CJ1MvIeAmaI9UH2YJW6bDDxltQHy12xz49lqaBOfB6ZOgF/dU0guUQROsa2MZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtL2zcIr; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736842824; x=1768378824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DGs58fUirPBcZE1LcNn7ZHkjvBrWoX0jYAnBFh0vKS0=;
  b=PtL2zcIrHu0Hd7sqFxjFj9k5K0khXVTeWKOGs/eVEyBhpBDmmhpvMTYj
   qKc75TjEt8fpvUtwQzlh+D/VieB/u6i1F0P1FojKTzB2UZNYdn7sdstAn
   lkm9DdeI2El1fxsd4dwy08bAXtGyzqBQ38AKQGOjEyOgA/LvLEBqIThTJ
   hXLAoGWPEglze1/Y+3FcoB6ZFL/2yLo3PoXQoA51G4viAO2QvZVeh/YUy
   p9OaaC5dBGMkzrqAWVXsB1GtQYZ4LTSvQ7ffPqAWZGsHaGiYvcbp4tkd6
   FRWQGolKMtIdbF/w3IQx7twoNDFF8a/ziXzk/VYK6Vv0P/42fzM7JbORV
   g==;
X-CSE-ConnectionGUID: O1zTfiUrQhubqKpCRO0eWw==
X-CSE-MsgGUID: Efk2npfgRHS2DdUwklHi/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40893804"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="40893804"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:20:24 -0800
X-CSE-ConnectionGUID: +OdjrQgmTSuXJHI9/gW4lg==
X-CSE-MsgGUID: t1KqKeqzT4WXfJ68VjXL3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105222429"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:20:21 -0800
Message-ID: <4dcc7c65-18d1-432b-8e98-501e0c38fc6b@linux.intel.com>
Date: Tue, 14 Jan 2025 16:20:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
 <Z4VKdbW1R0AoLvkB@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z4VKdbW1R0AoLvkB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/14/2025 1:16 AM, Sean Christopherson wrote:
> On Mon, Jan 13, 2025, Binbin Wu wrote:
>> On 1/13/2025 10:03 AM, Binbin Wu wrote:
>>> On 12/9/2024 9:07 AM, Binbin Wu wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv accesses
>>>> from host VMM.
>>>>
>>>> Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for TDX, set
>>>> it on TD initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.
>> Resend due to the format mess.
> That was a very impressive mess :-)
>
>> After TDX vCPU init, APIC is set to x2APIC mode. However, userspace could
>> disable APIC via KVM_SET_LAPIC or KVM_SET_{SREGS, SREGS2}.
>>
>> - KVM_SET_LAPIC
>>    Currently, KVM allows userspace to request KVM_SET_LAPIC to set the state
>>    of LAPIC for TDX guests.
>>    There are two options:
>>    - Force x2APIC mode and default base address when userspace request
>>      KVM_SET_LAPIC.
>>    - Simply reject KVM_SET_LAPIC for TDX guest (apic->guest_apic_protected
>>      is true), since migration is not supported yet.
>>    Choose option 2 for simplicity for now.
> Yeah.  We'll likely need to support KVM_SET_LAPIC at some point, e.g. to support
> PID.PIR save/restore, but that's definitely a future problem.
>
>> Summary about APICv inhibit reasons:
>> APICv could still be disabled runtime in some corner case, e.g,
>> APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED due to memory allocation failure.
>> After checking enable_apicv in tdx_bringup(), apic->apicv_active is
>> initialized as true in kvm_create_lapic().  If APICv is inhibited due to any
>> reason runtime, the refresh_apicv_exec_ctrl() callback could be used to check
>> if APICv is disabled for TDX, if APICv is disabled, bug the VM.
> I _think_ this is a non-issue, and that KVM could do KVM_BUG_ON() if APICv is
> inihibited by kvm_recalculate_apic_map() for a TDX VM.  x2APIC is mandatory
> (KVM_APIC_MODE_MAP_DISABLED and "APIC_ID modified" impossible), KVM emulates
> APIC_ID as read-only for x2APIC mode (physical aliasing impossible), and LDR is
> read-only for x2APIC (logical aliasing impossible).

For logical aliasing, according to the KVM code, it's only relevant to
AMD's AVIC. It's not set in VMX_REQUIRED_APICV_INHIBITS.
Is the reason AVIC using logical-id-addressing while APICv using
physical-id-addressing for IPI virtualization?

>
> To ensure no physical aliasing, KVM would need to require KVM_CAP_X2APIC_API be
> enabled, but that should probably be required for TDX no matter what.
There is no physical aliasing when APIC is in x2apic mode, vcpu_id is used
anyway.  Also, KVM is going to reject KVM_SET_LAPIC/KVM_GET_LAPIC from
userspace for TDX guests, functionally, it doesn't matter whether
KVM_CAP_X2APIC_API is enabled or not.

But for future proof, we could enforce KVM_CAP_X2APIC_API being enabled.

>
>> kvm_arch_dy_has_pending_interrupt()
>> -----------------------------------
>> Before enabling off-TD debug, there is no functional change because there
>> is no PAUSE Exit for TDX guests.
>> After enabling off-TD debug, the kvm_vcpu_apicv_active(vcpu) should be true
>> to get the pending interrupt from PID. Set APICv to active for TDX is the
>> right thing to do.
> And as alluded to above, for save/restore, e.g. intrahost migration.


