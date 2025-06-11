Return-Path: <kvm+bounces-49082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4A6AD5AB4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 17:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CA2F1886AE8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2786D1CBA18;
	Wed, 11 Jun 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BCqoz7zu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A8B1A8404;
	Wed, 11 Jun 2025 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656007; cv=none; b=pjGOcF60IW37meOVNec5jVeAWuKLQJllGb27yD3dyTnwV1ohpSj4XxkIVVvpcCE1stBZnKceyB+VGhHiZeCxzgXXf3v8kBlUKYPyHedOcDVCC1smEYk35YKCp/jy9JxLsdO7wr3Yw+cTzwB3H3HmnD8MhfLUAEktGcJV/s6JCMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656007; c=relaxed/simple;
	bh=rHdWhg+1tRJ8pdNXFOs6DUEIeNHlwGzTwvSNZrMPbo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3WY5QrQXYKrXR0x+dZx/l+tKdEUsetI/Jxy/IgKX6WsRfFVseR8+c3Qt0g/4P1Av52yIoYUjOvrWJBmMbXrJ70y7sVINgXBPn2kOJMiGK4hzWZjKO7Kiqgo1UGfzAKnqGwe4wy87wsprZRm9Y0eJZnqLANFSJCr3V1Kyv2eSTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BCqoz7zu; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749656005; x=1781192005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rHdWhg+1tRJ8pdNXFOs6DUEIeNHlwGzTwvSNZrMPbo0=;
  b=BCqoz7zu2POseJcFiWXxAfPBC2Vhj3tu8gQfgDdevHdtoQuoGsD36YQL
   OYBTwVyj+OgiE8kolp5xwJQxb0bHBPOonpZlRYtvqq9R6QP2l/fGPDb28
   WdvB+RhR3tirzIjZJdTapI3vIIOmGEyDgVUPoNwh/SiUPibMZSbYzZu/7
   BaNQqVWCjL/bdcH+FVNCbbJVtK4a4AW0yFKyZnahzE1idPmNbm2qfREef
   suYGl1azJh63F3sAMOKWyZ6RKGeQhCqTVZmxmbSQ3uwbQhml/+2C5LS8I
   8lEE3McomItFcKuJcMkebbSXr3GqlNDETXq5IcJB8V+dQ6DQ9Y3kv4wYW
   g==;
X-CSE-ConnectionGUID: TNeozDW7QGKdn1HY8pP2Uw==
X-CSE-MsgGUID: rZ4hxHaRQiOHNPOzFN/Fzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="77205331"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="77205331"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 08:33:25 -0700
X-CSE-ConnectionGUID: zTeiCBArR7qm9y0XLQQFLg==
X-CSE-MsgGUID: YzgO8cNLQsS+jXVw2sVciw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="178181372"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.118]) ([10.124.241.118])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 08:33:22 -0700
Message-ID: <ba611f52-9817-46ff-b16b-a9ef7404a51d@linux.intel.com>
Date: Wed, 11 Jun 2025 23:33:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Jiewen Yao <jiewen.yao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Tony Lindgren <tony.lindgren@intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Kirill Shutemov <kirill.shutemov@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
 <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
 <aEh0oGeh96n9OvCT@google.com>
 <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
 <aEmGTZbMpZhtlkIh@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aEmGTZbMpZhtlkIh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 9:36 PM, Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Binbin Wu wrote:
>> On 6/11/2025 3:58 AM, Sean Christopherson wrote:
>>> On Tue, Jun 10, 2025, Rick P Edgecombe wrote:
>>>> It seems like the reasoning could be just to shrink the possible configurations
>>>> KVM has to think about, and that we only have the option to do this now before
>>>> the ABI becomes harder to change.
>>>>
>>>> Did you need any QEMU changes as a result of this patch?
>>>>
>>>> Wait, actually I think the patch is wrong, because KVM_CAP_EXIT_HYPERCALL could
>>>> be called again after KVM_TDX_FINALIZE_VM. In which case userspace could get an
>>>> exit unexpectedly. So should we drop this patch?
>>> Yes, drop it.
>>>
>> So, when the TDX guest calls MapGPA and KVM finds userspace doesn't opt-in
>> KVM_HC_MAP_GPA_RANGE, just return error to userspace?
> Why can't KVM just do what it already does, and return an error to the guest?
>
> 	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
> 		ret = TDVMCALL_STATUS_INVALID_OPERAND;
> 		goto error;
> 	}
>
My previous thought was MapGpa is in base GHIC API.
Userspace is required to opt-in KVM_HC_MAP_GPA_RANGE.
If not, it's userspace's responsibility, so I thought exit to userspace with
error may be better.

If return an error code is preferred, now it has a new status code
TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED to use.

Basically, if the MapGpa is not support, either choice will stop VM from
execution. But had a second thought, returning an error code to guest allows
guest to choose to continue or not if MapGpa failed, though I can't
imagine what case it is.

