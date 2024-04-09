Return-Path: <kvm+bounces-13966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0E189D15A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 05:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4961C218D5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09EA55C36;
	Tue,  9 Apr 2024 03:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oBp5O78P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92C54F95
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634898; cv=none; b=G2d2NJZp2l/RxyZmArR8ZkZjx34uvKdi1/BJ+R45R+CNZl8CWyLu4T6xSyuipwkesKTgbWpSWkquxQl8Cg7jfYI6+SqNJC/v5HwThwPSnWDkO74EpfdnA8WlqbmynOKBY7kIWjkVeBRctdY6peFdTMQeLKbEpRxgC5FEzLk+eic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634898; c=relaxed/simple;
	bh=TjHyUXW5K3Cv7Sy57w4X52mxCGLie2BQ+5W0PQXEs8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOEPG7cbY9U9DeEaMnPDCIj+EkScJvAvWWJ5Irt5r6YrCFXnO4iu5rNdrVBF7At5GQJ0+0v6MSqpZJOjzxmOWP7lvMw61enaYMXyWW+2O8Fu2J3arzl+n2jScZNJ1DppECpxvAJRZ96cCRBp5Pp7dd9hFCUYaEx9uo0s2d/IhGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oBp5O78P; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712634898; x=1744170898;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TjHyUXW5K3Cv7Sy57w4X52mxCGLie2BQ+5W0PQXEs8U=;
  b=oBp5O78P1hF/ihz+tFjRPnmua1rHIa4P8FM+gjZwAKv1JbI3k2JOTM8g
   uDd5r0aJp4QcvtsuV+fJFwj2HaitxEK7t1oui+YyRRMXfC73gUORfTw40
   vv4/1wbo3I81yp15Ykq82UdZ2riAKmpO0Ej3wCH6ExLhpMvlPAM72rlVn
   L8dPySmVcgzk/mP3h23dK8r9Z8zfNQntNNjFZGNarRy33VuLuPbWDKVPe
   2rjUzH7MYe0rWTXbtMW+aXHJHgDmhV/XpzPvhBcRhsd0ym2Vt8teKn2vI
   wiv2g0yoEQTiLeeUL7+lLi6eKFU8/P4aIA6NmHvqoBHKCwINCmeE/2lFK
   Q==;
X-CSE-ConnectionGUID: DnvoBMMkQViMwkCOgPmDSw==
X-CSE-MsgGUID: l2X1hhoXQWOYgeerb51TTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="8062208"
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="8062208"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 20:54:57 -0700
X-CSE-ConnectionGUID: DB3B6k1BSOSqdBanq8BuXQ==
X-CSE-MsgGUID: So+F1JiVSWi0AcAVIxe8hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="24736425"
Received: from jwu7-mobl.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 20:54:54 -0700
Message-ID: <0f92fad5-7984-48d5-a37f-9fc278229ff5@intel.com>
Date: Tue, 9 Apr 2024 11:54:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Fix the condition of #PF interception caused by
 MKTME
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 Tao Su <tao1.su@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com
References: <20240319031111.495006-1-tao1.su@linux.intel.com>
 <171262722847.1420252.6246371182842943019.b4-ty@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <171262722847.1420252.6246371182842943019.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/9/2024 10:01 AM, Sean Christopherson wrote:
> On Tue, 19 Mar 2024 11:11:11 +0800, Tao Su wrote:
>> Intel MKTME repurposes several high bits of physical address as 'keyID',
>> so boot_cpu_data.x86_phys_bits doesn't hold physical address bits reported
>> by CPUID anymore.
>>
>> If guest.MAXPHYADDR < host.MAXPHYADDR, the bit field of ‘keyID’ belongs
>> to reserved bits in guest’s view, so intercepting #PF to fix error code
>> is necessary, just replace boot_cpu_data.x86_phys_bits with
>> kvm_get_shadow_phys_bits() to fix.
>>
>> [...]
> 
> Applied to kvm-x86 fixes, with a massaged shortlog/changelog.
> 
> Note, I don't love using kvm_get_shadow_phys_bits(), 

cannot agree more.

> but only because doing
> CPUID every time is so pointlessly suboptimal.  I have a series to clean up all
> of the related code, which I'll hopefully post later this week.

Look forward to it.

> But I didn't see any reason to hold up this fix, as I really hope no one is
> using allow_smaller_maxphyaddr in a nested VM with EPT enabled, which is the
> only case where CPUID is likely to have a meaningful impact (due to causing a
> VM-Exit).
> 
> [1/1] KVM: x86: Fix the condition of #PF interception caused by MKTME
>        https://github.com/kvm-x86/linux/commit/7f2817ef52a1
> 
> --
> https://github.com/kvm-x86/linux/tree/next


