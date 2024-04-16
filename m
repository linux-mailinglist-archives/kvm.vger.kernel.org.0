Return-Path: <kvm+bounces-14739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0A58A6665
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 734D41C23647
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EE983CDE;
	Tue, 16 Apr 2024 08:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bu0S8lRr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1A83CBE
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257274; cv=none; b=Oyqvvv30cWZm+nrdifN4dfJUVDZ5w8pGQaQvrZIeUgobzh0EkvKclA3/GemS3ZptgqsASIw6pGKPTM8mcHqdWZ/ZfmPWrY1W1tHPegp57ldixtwyEPHDfLmTYNfnN7xoyG1KjwGruAaEgCxehsdDJWykyTRVkweQbkEgONbgc7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257274; c=relaxed/simple;
	bh=yUD4BnGDqogdWytqUQ/WMV31gSMKGLrjKZUbv5EUOBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dj/NUnPfPOBNfk9XvgP6mYAYj9pG9YGnjjzGDmRF8aDVD9Nc1NQMaheqTqyweY4V1JeSM/QlyZELslPz6gDEdwcxJULZJxYSW1QzTzDM6uf4uqj2KsNozKiUon3RSs3OfkfiSl+rs7XM3fdS9ouaL8K+U1CKS55UIeHhMTjwWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bu0S8lRr; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713257274; x=1744793274;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yUD4BnGDqogdWytqUQ/WMV31gSMKGLrjKZUbv5EUOBQ=;
  b=bu0S8lRrW0g/AgYsctZFVdfK9hUGmn4ixtbIJQbgnRpWfLKP2bm80gu1
   k/feNSYc53Ze4l+avDK/GCKEZ/YUjh01+hhyqDzNyjmHLxn0ShsYcMHYI
   su7omPzZeW5VAD5Gt1cJZjZU1AV3KXgv2GPifRd8r6odutUFsPb6fM/Wp
   gdMmpuOIGnZd6pFVx9og007MY87j3CWEP65lpdgnZy3aXOldni6snmfPO
   MIk5FitIDifrdMZW1ik9OUUk8skxB4ZfS0OjxvLTxl+Sa3eTmuMQP3iFZ
   LQ50/qQ/n0qOVjrZO+oSnajUy/eR8GxI5A0il/W0MthieTQVd0fXe9GiX
   g==;
X-CSE-ConnectionGUID: +Wbr9GZgSPC5Q5URTqm2jA==
X-CSE-MsgGUID: 09H2pypNTQaLqySjuHNj+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="12525125"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="12525125"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:47:53 -0700
X-CSE-ConnectionGUID: Iy9AopWKTa+KHdiUFrwGwg==
X-CSE-MsgGUID: deWY6M9qSdqDkfvWW5OHJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22260942"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:47:51 -0700
Message-ID: <a8340038-5dd7-4bff-8ef2-1dbe48ceaf49@intel.com>
Date: Tue, 16 Apr 2024 16:47:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20240313125844.912415-1-kraxel@redhat.com>
 <171270475472.1589311.9359836741269321589.b4-ty@google.com>
 <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com>
 <ZhlXzbL66Xzn2t_a@google.com>
 <627a61bf-de07-43a7-bb4a-9539673674b2@intel.com>
 <Zh1AjYMP-v1z3Xp2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zh1AjYMP-v1z3Xp2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/2024 10:58 PM, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Xiaoyao Li wrote:
>> On 4/12/2024 11:48 PM, Sean Christopherson wrote:
>>> On Fri, Apr 12, 2024, Xiaoyao Li wrote:
>>> If we go deep enough, it becomes a functional problem.  It's not even _that_
>>> ridiculous/contrived :-)
>>>
>>> L1 KVM is still aware that the real MAXPHYADDR=52, and so there are no immediate
>>> issues with reserved bits at that level.
>>>
>>> But L1 userspace will unintentionally configure L2 with CPUID.0x8000_0008.EAX[7:0]=48,
>>> and so L2 KVM will incorrectly think bits 51:48 are reserved.  If both L0 and L1
>>> are using TDP, neither L0 nor L1 will intercept #PF.  And because L1 userspace
>>> was told MAXPHYADDR=48, it won't know that KVM needs to be configured with
>>> allow_smaller_maxphyaddr=true in order for the setup to function correctly.
>>
>> In this case, a) L1 userspace was told by L1 KVM that MAXPHYADDR = 48 via
>> KVM_GET_SUPPORTED_CPUID. But b) L1 userspace gets MAXPHYADDR = 52 by
>> executing CPUID itself.
> 
> KVM can't assume userspace will do raw CPUID.

So the KVM ABI is that, KVM_GET_SUPPORTED_CPUID always reports the 
host's MAXPHYADDR, if userspace wants to configure a smaller one than it 
for guest and expect it functioning, it needs to set 
kvm_intel.allower_smaller_maxphyaddr ?

