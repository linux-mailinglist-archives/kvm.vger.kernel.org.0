Return-Path: <kvm+bounces-14743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 711B58A6681
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23131C2116A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA65084A36;
	Tue, 16 Apr 2024 08:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcMKb3b4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B605D71B50
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257718; cv=none; b=KWOqduEZVw2e1swIAxFbBU6Mw7rGa8i9a2pOIaQwnfXdyVVVfecdIpe0BcCbFIWLSLKYtAGJ/2qhmqDvJ6XP9kk1pRXCyAxMJrB2dxZeU67AHLN8la7eXzBEdEBm+nAPdwNgiNSHgoKQiZ925iPwqNMjLW4gL+Qaic2aWrqCHKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257718; c=relaxed/simple;
	bh=JNmyC1gaMXRjSeOW03drSIWO0UeKKffJRrs68BBM2K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+3Hjb8OxelIHXnbN+LzariLHhmTKTKBw2lBELnw79RrR7i/mAU6dtBEMNFNd56bcNcxFsNdY6DZo9PQCBJxRPupkkL4XFwG2eSdRbUQPO/+jcFBw4tOC9lZpGpwk6N2tpNKdH+TH1iATIj0wfPiw3jVfrHenHolZTNiUijwbzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcMKb3b4; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713257717; x=1744793717;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JNmyC1gaMXRjSeOW03drSIWO0UeKKffJRrs68BBM2K0=;
  b=PcMKb3b4ReWWLLhG0gwTGybIVLdOrX0tL5S72NgnlC5v1qD+6F7pWYMZ
   pHNubL/HdPwk0+Y59HKjw23iPJNcJcV1vDPxVYygMxUEpFuFlg8eG1IZ4
   b12SKChn+pz1pDCgtyTyBkMgeYQ+Rl4PD7qGg+ziLRIs1xVK35DSt6CB4
   ZuwSEw7Xhe3QMRe4XgdQ2Hte8enNmRW2jniG2Dd0d5I9urBrZPezUxAiJ
   EIcDhmtLUbY+xYf9eszBNTAXBMWbVPERlpkCpn6KsQoU7VmHD0p1CdI+W
   eWEzTrizwp6fOV48np1wghjshaYYGxwR1VC5ITTGQwJaa96vM0HvezyZ2
   A==;
X-CSE-ConnectionGUID: 5uTFQqLvR6KsB/20+tgymQ==
X-CSE-MsgGUID: r7wV1YccRZ6K81uBUfu4YA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8793412"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8793412"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:55:16 -0700
X-CSE-ConnectionGUID: SGWtP5HzRpW7C+Gccm07GA==
X-CSE-MsgGUID: KzWTuc6RQuGNdzf/H5sfpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26848349"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:55:10 -0700
Message-ID: <74b0fe93-fd73-4443-b8c6-9a535891948a@intel.com>
Date: Tue, 16 Apr 2024 16:55:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/65] i386/tdx: Disable pmu for TD guest
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-29-xiaoyao.li@intel.com>
 <b89211ee-6ac8-4efe-a9e0-16ae3bec4127@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b89211ee-6ac8-4efe-a9e0-16ae3bec4127@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/2024 4:32 PM, Chenyi Qiang wrote:
> 
> 
> On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
>> Current KVM doesn't support PMU for TD guest. It returns error if TD is
>> created with PMU bit being set in attributes.
>>
>> Disable PMU for TD guest on QEMU side.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 262e86fd2c67..1c12cda002b8 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -496,6 +496,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>>       int r = 0;
>>   
>> +    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
> 
> Is it necessary to output some prompt if the user wants to enable pmu by
> "-cpu host,pmu=on"? As in patch 27, it mentions PMU is configured by
> x86cpu->enable_pmu, but PMU is actually not support in this series and
> will be disabled silently.

We do this in QEMU is mainly for KVM, because KVM will fail to init TD 
if ATTRIBUTE.PERFMON is set.

It's expected that KVM reports PERFMON in attributes.fixed0 when KVM 
cannot provide support of it. Then QEMU will print error message 
automatically when validate the attributes.

For QEMU part, next version is going to set the default value of "pmu" 
to false in kvm_cpu_max_instance_init(), so that "-cpu host" will not 
enable pmu for TDX VMs by default.

I suppose both the KVM and QEMU change will show up in the next version.

>> +
>>       QEMU_LOCK_GUARD(&tdx_guest->lock);
>>       if (tdx_guest->initialized) {
>>           return r;


