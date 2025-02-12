Return-Path: <kvm+bounces-37947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE018A31C8D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 04:12:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BF8D7A3E1D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 03:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221381D89E4;
	Wed, 12 Feb 2025 03:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JODFbWLt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF727182B;
	Wed, 12 Feb 2025 03:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739329944; cv=none; b=NkZufyn76BxLPFwqZDFzyy6ZuUSN+bqeY9sSd041tafyHDW+WM0S/YCloAiBMSgpjI4MKC5VLQnkspFqe5o6hCMMf2osOc+/v2TiLZz91TutQjz0rwS0Sl6gl8VyLf8MH5hMUWhvoEKdu5+tVOwRxfvbfSLqUqk8z1cI/Cj9L18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739329944; c=relaxed/simple;
	bh=hS0C6YuBmSuMaJvuGugmlUTvoT5Svl7GpzGy4fckWqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1HATPnkBuZA+6x6/MIE0IvylEujGasbOZ2rAY4GWs0RQs6mrXroRTRIQo7vkBils/Asu3Pq4QtQRYvrvzx3MuxDRfK4BnOFZHyEVfAsbriw6lJm/UnMBg2crTS12GUpBCYiHJHGReUneHR9XtltPF/a3R0v4RuKwtLzL0Y5y38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JODFbWLt; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739329942; x=1770865942;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hS0C6YuBmSuMaJvuGugmlUTvoT5Svl7GpzGy4fckWqg=;
  b=JODFbWLtGujXT+ErZoSzfN1WNJJN1kuPXD+FTFxee5RPZoajKt31K4nH
   5lkkocFfO8LXKLsme/wy9sLBqczj2t18yz6JXSyWfT8PViJ9Pmkx9ILgg
   pEwZgt2E7puoqnKmYw5nSMuJhYGAdpbSjL/ETPwotH6j1KEryAMaHdESv
   k800oWWROMmrL264FEFvtjdAvnq5B4641/EhApBUe9FzN3LXMOax1gytt
   ADE1Jf2L85Q8jcvr4FnOHeInwKxYk1QAXL6/JTEJEIBsQ6ig1PSEnS/Mj
   Hocus2SfmLiFy7RNfBuNhsSSG4mX4VSV/eLanQN352VNUsprOlznifnyR
   Q==;
X-CSE-ConnectionGUID: +DgbPe7qRlO371EPWpXD9Q==
X-CSE-MsgGUID: f8KqcM+0T9WBE4MKr2h+SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="39992757"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="39992757"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 19:12:21 -0800
X-CSE-ConnectionGUID: WZWEef/aS7WzUr1iw4fYBA==
X-CSE-MsgGUID: bcGxCh1+TV2ZLtDPHxCwHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="112681941"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 19:12:18 -0800
Message-ID: <13d7d1ad-d631-436f-b1b6-a11a77e6660a@intel.com>
Date: Wed, 12 Feb 2025 11:12:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read
 the GPRs
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-2-binbin.wu@linux.intel.com>
 <de966c9c-54e4-4da2-8dd3-d23b59b279a3@intel.com>
 <7abea257-7d83-40a2-8d56-c155593153f4@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7abea257-7d83-40a2-8d56-c155593153f4@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/2025 9:32 AM, Binbin Wu wrote:
> 
> 
> On 2/11/2025 6:23 PM, Xiaoyao Li wrote:
>> On 2/11/2025 10:54 AM, Binbin Wu wrote:
>>> Have ____kvm_emulate_hypercall() read the GPRs instead of passing them
>>> in via the macro.
>>>
>>> When emulating KVM hypercalls via TDVMCALL, TDX will marshall 
>>> registers of
>>> TDVMCALL ABI into KVM's x86 registers to match the definition of KVM
>>> hypercall ABI _before_ ____kvm_emulate_hypercall() gets called. 
>>> Therefore,
>>> ____kvm_emulate_hypercall() can just read registers internally based 
>>> on KVM
>>> hypercall ABI, and those registers can be removed from the
>>> __kvm_emulate_hypercall() macro.
>>>
>>> Also, op_64_bit can be determined inside ____kvm_emulate_hypercall(),
>>> remove it from the __kvm_emulate_hypercall() macro as well.
>>
>> After this patch, __kvm_emulate_hypercall() becomes superfluous.
>> we can just put the logic to call the "complete_hypercall" into 
>> ____kvm_emulate_hypercall() and rename it to __kvm_emulate_hypercall()
>>
>>
> According to the commit message of
> "KVM: x86: Refactor __kvm_emulate_hypercall() into a macro":
> "Rework __kvm_emulate_hypercall() into a macro so that completion of
> hypercalls that don't exit to userspace use direct function calls to the
> completion helper, i.e. don't trigger a retpoline when RETPOLINE=y."

I see.

I thought the purpose of introducing the macro was for TDX usage. My 
fault that didn't checking the commit message of that change.

It makes sense for retpoline reason.

> So I kept the macro.


