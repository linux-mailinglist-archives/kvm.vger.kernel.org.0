Return-Path: <kvm+bounces-64817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF72C8CA05
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 03:01:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 10776350BD0
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3843623EA93;
	Thu, 27 Nov 2025 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K6I7nncR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DDF1E86E;
	Thu, 27 Nov 2025 02:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764208867; cv=none; b=fNkRIdZNV14ls8jU9E4jJ47D6Zw6B3ApAOdwvMI17ek2gz/A1vG81KCSPgyMVIcCZm+aPRy7e2iR9zbzQqwrlmsOuOLtZNPjHj/21NSKT96ynx+qt8YqCZmX54byePO4685eWjeKGC5VGQWumN6RkJDJLF5QjKq35xm4fGF8do0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764208867; c=relaxed/simple;
	bh=HeO2wrUQw0PgPdxBZs5zT3hvFSXUG6gILNzv/cC7IUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvCHj8ACX/tL7fZAjJuW4IK3mbxR5nP9K3uBhK5Ez3Udnjt4saLBDJ5xQPhf0oc6MfVX43/URR4ItAfZwYCIxBjUqu9fWa4MDqbqV4czE/2RDNJ+kvQSUqvj7ImL/g5CO2i1ii1z0/BW+XoNW0MndsRxaIVJGPLDYdcIjqGiPuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K6I7nncR; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764208865; x=1795744865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HeO2wrUQw0PgPdxBZs5zT3hvFSXUG6gILNzv/cC7IUI=;
  b=K6I7nncRjtU6OYsqWVmhStiHl06yYEOqkDhyYJZiDaYiUb/sso5IkLnw
   QDO0U0mSFNDZ2YIcWu4CzQ6pEigOpNrxv2nijdlJ0BHx6o63xa3+SPm+A
   g1MA8Y9e0qpvQ3yi/lY1X6RN625wlVPaAUO3YhQEGZBqZxrFoYDHhQ6C7
   aqp737v7rFtxK1N1zUSBlS62fw9VUYk+QIsHHakTO+hbIsgiMm/aK0qxn
   yJqYP8PKjFEWjFz+D1ECW6Waw0aTCVm/xT2tUbcO3asjzdbeYnw2BuIiF
   wTpqSCDDrNZFSh5Log/0U8hN/UwhwG5V8PRVWZY1lYQXlzdFsO/lzQrT7
   A==;
X-CSE-ConnectionGUID: L6s4MuRgRN6hfBWY589rXw==
X-CSE-MsgGUID: qGWNB1nKSfCFG8/zwlDDSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76942308"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76942308"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 18:01:05 -0800
X-CSE-ConnectionGUID: DBnQY0PASRGLpPfld4oR/w==
X-CSE-MsgGUID: rGC+5TuSSpeAB2twKGbqjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="197259619"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 18:01:01 -0800
Message-ID: <0f8983e9-0e23-4a05-8015-de6e2218d8a5@intel.com>
Date: Thu, 27 Nov 2025 10:00:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Reinette Chatre <reinette.chatre@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, chao.p.peng@intel.com
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
 <20251126100205.1729391-2-xiaoyao.li@intel.com>
 <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
 <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>
 <qvsi3xht4kn3iwkx5xw2p7zsq4cvpg4xhq3ra52fe34xjpixfo@fsgchsobc343>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <qvsi3xht4kn3iwkx5xw2p7zsq4cvpg4xhq3ra52fe34xjpixfo@fsgchsobc343>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/2025 9:35 PM, Kiryl Shutsemau wrote:
> On Wed, Nov 26, 2025 at 08:17:18PM +0800, Xiaoyao Li wrote:
>> On 11/26/2025 7:25 PM, Kiryl Shutsemau wrote:
>>> On Wed, Nov 26, 2025 at 06:02:03PM +0800, Xiaoyao Li wrote:
>>>> When the host enables split lock detection feature, the split lock from
>>>> guests (normal or TDX) triggers #AC. The #AC caused by split lock access
>>>> within a normal guest triggers a VM Exit and is handled in the host.
>>>> The #AC caused by split lock access within a TDX guest does not trigger
>>>> a VM Exit and instead it's delivered to the guest self.
>>>>
>>>> The default "warning" mode of handling split lock depends on being able
>>>> to temporarily disable detection to recover from the split lock event.
>>>> But the MSR that disables detection is not accessible to a guest.
>>>>
>>>> This means that TDX guests today can not disable the feature or use
>>>> the "warning" mode (which is the default). But, they can use the "fatal"
>>>> mode.
>>>>
>>>> Force TDX guests to use the "fatal" mode.
>>>>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>>    arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
>>>>    1 file changed, 16 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
>>>> index 981f8b1f0792..f278e4ea3dd4 100644
>>>> --- a/arch/x86/kernel/cpu/bus_lock.c
>>>> +++ b/arch/x86/kernel/cpu/bus_lock.c
>>>> @@ -315,9 +315,24 @@ void bus_lock_init(void)
>>>>    	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
>>>>    }
>>>> +static bool split_lock_fatal(void)
>>>> +{
>>>> +	if (sld_state == sld_fatal)
>>>> +		return true;
>>>> +
>>>> +	/*
>>>> +	 * TDX guests can not disable split lock detection.
>>>> +	 * Force them into the fatal behavior.
>>>> +	 */
>>>> +	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
>>>> +		return true;
>>>> +
>>>> +	return false;
>>>> +}
>>>> +
>>>>    bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>>>>    {
>>>> -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
>>>> +	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
>>>>    		return false;
>>>
>>> Maybe it would be cleaner to make it conditional on
>>> cpu_model_supports_sld instead of special-casing TDX guest?
>>>
>>> #AC on any platfrom when we didn't asked for it suppose to be fatal, no?
>>
>> But TDX is the only one has such special non-architectural behavior.
>>
>> For example, for normal VMs under KVM, the behavior is x86 architectural.
>> MSR_TEST_CTRL is not accessible to normal VMs, and no split lock #AC will be
>> delivered to the normal VMs because it's handled by KVM.
> 
> How does it contradict what I suggested?
> 
> For both normal VMs and TDX guest, cpu_model_supports_sld will not be
> set to true. So check for cpu_model_supports_sld here is going to be
> NOP, unless #AC actually delivered, like we have in TDX case. Handling
> it as fatal is sane behaviour in such case regardless if it TDX.
> 
> And we don't need to make the check explicitly about TDX guest.

Well, it depends on how defensive we would like to be, and whether to 
specialize or commonize the issue.

Either can work. If the preference and agreement are to commonize the 
issue, I can do it in v2. And in this direction, what should we do with 
the patch 2? just drop it since it's specialized for TDX ?

