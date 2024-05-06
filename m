Return-Path: <kvm+bounces-16599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD45E8BC582
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 632E91F213E8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 01:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554DC3D962;
	Mon,  6 May 2024 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWE7oxLa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7D1EEE0;
	Mon,  6 May 2024 01:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714959461; cv=none; b=cTPsvfukzkdJng1ybRtYKxQs1cIfVk9AULQceDAfot0sIyNkzN5Ysc669pUFHjx8dsZg/2XiaZEg7tVChxzmiPmj7JY+uLoX0VHXjjRx5kq4Oyu5KBWHm3yxlr+jA0+21PmFw5/gLCsuXxLWFRXT2FT74hXSHPl2NLeZhf5Z8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714959461; c=relaxed/simple;
	bh=HYftu84wTZG3fnG7ffHRltjHsRm3okCLENExzyGTMKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPLbGQQnTWATi1zG9emze1npPlTKoKy8JdVFbhETuBJnOGW6f9NCpnw9Pw19+VIN//5mOxx4+hZQifVydLFfWdZgg9y9WQth8BeZVldF9jyUISh6U785LnSnAqZ6x8bmq1+14fhWHb7ulf6K6rOpI4lgu7NX3VGuB2XI6TFoo94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWE7oxLa; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714959460; x=1746495460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HYftu84wTZG3fnG7ffHRltjHsRm3okCLENExzyGTMKg=;
  b=LWE7oxLaj8sNZQPrsOGPry7Dxjmo0Q9z8QtyFUNKdq/eLxYDn8DIYtUm
   57TIAM5lCIjjaPeZcOWn8HPorAUwyu37Tb6bEqghDUnuEBIBjLAysJDO/
   p1CTCWMO/nIuNmTKwU1L3UaiK8pQKZtxeIVdXWRzQGfUDUfsIlDns5+qR
   ctpuwQEs2K0oOX0S+q+l8ZMq040HSkfFTLzHxDlkC7LIdRLAj+r/dmMJn
   qtLNotrjI6tEPIDgbKF8blTMQ/PuU5vvrvqsTxpsPuNt6Dj+z3lgqIkf8
   FOrmoRofmKDvkPOfuciKVtx1Y00g52b74wxY7tDQ0NHi296DnpebJ4ZZP
   g==;
X-CSE-ConnectionGUID: Z6Mx9lEPRj+qPjpYtcqPuw==
X-CSE-MsgGUID: /cksoM0fSE6CUWpf+J715w==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10566693"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10566693"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 18:37:39 -0700
X-CSE-ConnectionGUID: PsLwOka8Qs6r1guoZeGl7Q==
X-CSE-MsgGUID: yR4ljC2kTa6ektocMmrouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32806438"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 18:37:34 -0700
Message-ID: <22b52180-27a2-4df8-a949-401f73440641@linux.intel.com>
Date: Mon, 6 May 2024 09:37:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] vPMU code refines
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
 <CAL715WK9+aXa53DXM3TP2POwAtA2o40wpojfum+SezdxoOsj1A@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WK9+aXa53DXM3TP2POwAtA2o40wpojfum+SezdxoOsj1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/1/2024 2:15 AM, Mingwei Zhang wrote:
> On Mon, Apr 29, 2024 at 5:45 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> This small patchset refines the ambiguous naming in kvm_pmu structure
>> and use macros instead of magic numbers to manipulate FIXED_CTR_CTRL MSR
>> to increase readability.
>>
>> No logic change is introduced in this patchset.
>>
>> Dapeng Mi (2):
>>   KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
> So, it looks like the 1st patch is also in the upcoming RFCv2 for
> mediated passthrough vPMU. I will remove that from my list then.

Mingwei, we'd better keep this patch in RFCv2 until the this patchset is
merged, then we don't rebase it again when this patch is merged. Thanks.


> Thanks. Regards
> -Mingwei
>
>>   KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
>>
>>  arch/x86/include/asm/kvm_host.h | 10 ++++-----
>>  arch/x86/kvm/pmu.c              | 26 ++++++++++++------------
>>  arch/x86/kvm/pmu.h              |  8 +++++---
>>  arch/x86/kvm/svm/pmu.c          |  4 ++--
>>  arch/x86/kvm/vmx/pmu_intel.c    | 36 +++++++++++++++++++--------------
>>  5 files changed, 46 insertions(+), 38 deletions(-)
>>
>>
>> base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
>> --
>> 2.40.1
>>

