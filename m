Return-Path: <kvm+bounces-26780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 410039777A2
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 05:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71C151C23888
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 03:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0C21C57BB;
	Fri, 13 Sep 2024 03:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lNX/zvs1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB848827;
	Fri, 13 Sep 2024 03:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726199828; cv=none; b=oMg6ebg/ElLAnGtZEXTQvh9bmigwZ1Bz1XYmkSzRDri2SdWtzmwvJBL6NtNiHTQC7G3PS8V7TZoV6ByJ56mmO1feRzQa9ExPt6ab268BxbpIsMGXQe21WW4Iy4GEMHBnrlkH7wwi1EKZK2dPnBxxOibknsY1gcR6tA4Iho8Bk/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726199828; c=relaxed/simple;
	bh=liKC1EKMRdqiBH2jb9JmSP9lhWJ6/iwlcLuKoJC0xUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePkWo1W8lKYDB+9HoyilAfQuFwFfoheXFFtQ1oTBLEomW4lcec4G32fUGM9iRO9UDWn1eSZN2oCsHPwsijTFNG9zsAoC9nKyarKvouxv7TcqgLkq6X9Tu7av1Bma5gbIbpHlVO4qu6CCeN7UR22onXqmqEM3xT5/qss4vggpG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lNX/zvs1; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726199827; x=1757735827;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=liKC1EKMRdqiBH2jb9JmSP9lhWJ6/iwlcLuKoJC0xUg=;
  b=lNX/zvs1vhGttEi5izMx27QAEhqZhOlTaJRVj8olfTcY68tFn/K2nS8V
   5S/EOkbksErJ/TshNpvzC/TMxqboQ+xDcn3NW/Bu/ap+/nRMpYG/YnQEr
   /O2ryy2o+/cpB3Q+tsvYwl7wTMjNGt2zssiSdmce/TxON2S+y7nyok8L7
   7JXPHv6APIcvhXZl8UJC8gDrKh/WY3lwWMxmtmIKm/GB3DsuZ9oZe+sHq
   g4R4Nu05olhfTHqpqyQ8L13SZKPQTUj3JgBcCwVfPOxR4+0ZOX9abyJJh
   eDQG6P2w27JTJ7cyxOzyqSkUc4y3ZKlBaG+A+vo+SXII1yA+0obLASR0D
   g==;
X-CSE-ConnectionGUID: bA9+Nx4NTMe6XkLTXr6jyg==
X-CSE-MsgGUID: TV4uLeBeRo+w13fSKdvLIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="24962510"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="24962510"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 20:57:06 -0700
X-CSE-ConnectionGUID: NaIflIlETj65yjXV3Y8A5Q==
X-CSE-MsgGUID: MtqsJIkgRYWCl4t83rkITg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="72727893"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 20:57:03 -0700
Message-ID: <33f21483-0e55-4370-8405-12ed7439c3e9@intel.com>
Date: Fri, 13 Sep 2024 11:57:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
 <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
 <ZuMZ2u937xQzeA-v@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZuMZ2u937xQzeA-v@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/13/2024 12:42 AM, Sean Christopherson wrote:
> On Thu, Sep 12, 2024, Paolo Bonzini wrote:
>> On Thu, Sep 12, 2024 at 4:45 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>> KVM is not going to have any checks, it's only going to pass the
>>>> CPUID to the TDX module and return an error if the check fails
>>>> in the TDX module.
>>>
>>> If so, new feature can be enabled for TDs out of KVM's control.
>>>
>>> Is it acceptable?
>>
>> It's the same as for non-TDX VMs, I think it's acceptable.
> 
> No?  IIUC, it's not the same.
> 
> E.g. KVM doesn't yet support CET, and while userspace can enumerate CET support
> to VMs all it wants, guests will never be able to set CR4.CET and thus can't
> actually enable CET.
> 
> IIUC, the proposal here is to allow userspace to configure the features that are
> exposed _and enabled_ for a TDX VM without any enforcement from KVM.
> 
> CET might be a bad example because it looks like it's controlled by TDCS.XFAM, but
> presumably there are other CPUID-based features that would actively enable some
> feature for a TDX VM.
> 
> For HYPERVISOR and TSC_DEADLINE_TIMER, I would much prefer to fix those KVM warts,
> and have already posted patches[1][2] to do exactly that.
> 
> With those out of the way, are there any other CPUID-based features that KVM
> supports, but doesn't advertise?  Ignore MWAIT, it's a special case and isn't
> allowed in TDX VMs anyways.

Actually MWAIT becoems allowed by TDX and it's configurable.

> [1] https://lore.kernel.org/all/20240517173926.965351-34-seanjc@google.com
> [2] https://lore.kernel.org/all/20240517173926.965351-35-seanjc@google.com
> 


