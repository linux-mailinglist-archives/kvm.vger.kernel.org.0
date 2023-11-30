Return-Path: <kvm+bounces-2837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D42C7FE783
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DDD51C20B95
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F45125C1;
	Thu, 30 Nov 2023 03:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQwNECuH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1589D6C;
	Wed, 29 Nov 2023 19:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701313455; x=1732849455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GCiIaCw+VRboLufR/lMo0OoCNHsxCHgA0wMyBlShb1o=;
  b=SQwNECuH1JCgOtntM9c3ytdKWjE+PxAzqLVvOaBfUVlssD49d2hUo8+3
   EiEKnIDIB8yfL8nx2Lnk+u2z2jBBeyrpmm6eS0877gHDK0bbf099XlGYK
   VFwMpRrJpWxtfH/UtbBFL5whKl2GwDWASiIOWNt0+OiEOayWh67q6yN1u
   6tofHGzJYqsjMUqDJDm7l2NAacxlRRZOTa1R6ezPzumX+rVmOweDcUeoc
   ve8pFGecz4wGHHgGoOsYytJHV6TPKDBQmiypgTuY0M7G8Zo6e3SmKBvZX
   UM06DYaa4MJhzk9LfxK7PQ1fOKiDWEZxEfPfmTTVEWkItgi6lEKfmSBMT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="245356"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="245356"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 19:04:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="1100767184"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="1100767184"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 19:04:10 -0800
Message-ID: <ebacaa61-4156-4948-a9f7-8ea7c0a49e4a@intel.com>
Date: Thu, 30 Nov 2023 11:04:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add logic to detect if ioctl()
 failed because VM was killed
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
 Oliver Upton <oliver.upton@linux.dev>, Colton Lewis <coltonlewis@google.com>
References: <20231108010953.560824-1-seanjc@google.com>
 <20231108010953.560824-3-seanjc@google.com>
 <0ee32216-e285-406f-b20d-dd193b791d2b@intel.com>
 <ZUuyVfdKZG44T1ba@google.com>
 <22c602c9-4943-4a16-a12e-ffc5db29daa1@intel.com>
 <ZWePYnuK65GCOGYU@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZWePYnuK65GCOGYU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/2023 3:22 AM, Sean Christopherson wrote:
> On Mon, Nov 13, 2023, Xiaoyao Li wrote:
>> On 11/9/2023 12:07 AM, Sean Christopherson wrote:
>>> On Wed, Nov 08, 2023, Xiaoyao Li wrote:
>>>> On 11/8/2023 9:09 AM, Sean Christopherson wrote:
>>>>> Add yet another macro to the VM/vCPU ioctl() framework to detect when an
>>>>> ioctl() failed because KVM killed/bugged the VM, i.e. when there was
>>>>> nothing wrong with the ioctl() itself.  If KVM kills a VM, e.g. by way of
>>>>> a failed KVM_BUG_ON(), all subsequent VM and vCPU ioctl()s will fail with
>>>>> -EIO, which can be quite misleading and ultimately waste user/developer
>>>>> time.
>>>>>
>>>>> Use KVM_CHECK_EXTENSION on KVM_CAP_USER_MEMORY to detect if the VM is
>>>>> dead and/or bug, as KVM doesn't provide a dedicated ioctl().  Using a
>>>>> heuristic is obviously less than ideal, but practically speaking the logic
>>>>> is bulletproof barring a KVM change, and any such change would arguably
>>>>> break userspace, e.g. if KVM returns something other than -EIO.
>>>>
>>>> We hit similar issue when testing TDX VMs. Most failure of SEMCALL is
>>>> handled with a KVM_BUG_ON(), which leads to vm dead. Then the following
>>>> IOCTL from userspace (QEMU) and gets -EIO.
>>>>
>>>> Can we return a new KVM_EXIT_VM_DEAD on KVM_REQ_VM_DEAD?
>>>
>>> Why?  Even if KVM_EXIT_VM_DEAD somehow provided enough information to be useful
>>> from an automation perspective, the VM is obviously dead.  I don't see how the
>>> VMM can do anything but log the error and tear down the VM.  KVM_BUG_ON() comes
>>> with a WARN, which will be far more helpful for a human debugger, e.g. because
>>> all vCPUs would exit with KVM_EXIT_VM_DEAD, it wouldn't even identify which vCPU
>>> initially triggered the issue.
>>
>> It's not about providing more helpful debugging info, but to provide a
>> dedicated notification for VMM that "the VM is dead, all the following
>> command may not response". With it, VMM can get rid of the tricky detection
>> like this patch.
> 
> But a VMM doesn't need this tricky detection, because this tricky detections isn't
> about detecting that the VM is dead, it's all about helping a human debug why a
> test failed.
> 
> -EIO already effectively says "the VM is dead", e.g. QEMU isn't going to keep trying
> to run vCPUs.  

If -EIO for KVM ioctl denotes "the VM is dead" is to be the officially 
announced API, I'm fine.


> Similarly, selftests assert either way, the goal is purely to print
> out a unique error message to minimize the chances of confusing the human running
> the test (or looking at results).
> 
>>> Definitely a "no" on this one.  As has been established by the guest_memfd series,
>>> it's ok to return -1/errno with a valid exit_reason.
>>>
>>>> But I'm wondering if any userspace relies on -EIO behavior for VM DEAD case.
>>>
>>> I doubt userspace relies on -EIO, but userpsace definitely relies on -1/errno being
>>> returned when a fatal error.
>>
>> what about KVM_EXIT_SHUTDOWN? Or KVM_EXIT_INTERNAL_ERROR?
> 
> I don't follow,

I was trying to ask if KVM_EXIT_SHUTDOWN and KVM_EXIT_INTERNAL_ERROR are 
treated as fatal error by userspace.

> those are vcpu_run.exit_reason values, not errno values.  Returning
> any flavor of KVM_EXIT_*, which are positive values, would break userspace, e.g.
> QEMU explicitly looks for "ret < 0", and glibc only treats small-ish negative
> values as errors, i.e. a postive return value will be propagated verbatim up to
> QEMU.


