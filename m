Return-Path: <kvm+bounces-49068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF4FAD57F4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44DAC3A7C1C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEAE28C5DB;
	Wed, 11 Jun 2025 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PG2oUHNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5255E2690FB;
	Wed, 11 Jun 2025 14:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749650480; cv=none; b=ix9sl2Y3+V+3Np20xGbb+WpJZGiwYbktLtPMhodp/b4QQc5i5YmB8BoZLuYyoMOMlV69Phc6K9IVQo+wNHZvLQEYRB8Wt0r1iO1cEyfyWrb6gvhv2ZZhrEQXPsP774YX2FwsjpMQT4WqtUk7s31fc2cIlziUzekdy8fLU32iCAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749650480; c=relaxed/simple;
	bh=O0xtyNWz6yzJ/v9TJy03FqVKbNcI/0B/yaZJDxxjJrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWtmuPzvOlwTHuZo2IoGbEH8faSg0hgPFQcV7EQ5KnNvneBXcJ9uYBGiqahyTwYs9Qyf+8uPFYJMsmOnDh9EwYbut6pNGs6CiC0QrMfF8clCbMQ9MwOArHyIBRXaSGJXzMxvk2CFY4kvFCd2WBM+LAuADT97vntC9GKLVsTasPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PG2oUHNb; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749650478; x=1781186478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O0xtyNWz6yzJ/v9TJy03FqVKbNcI/0B/yaZJDxxjJrA=;
  b=PG2oUHNbC9eWqUgOxrGy8EkT2LKr+BPsNcKbpgtlpFuhLAiPs3q9VPiG
   GnLyxltv+RwQUWV1qXnQZduM6L55XrjY2Vii7pO18bJmqV36zmh0mPt83
   xsHCgTGdigvPzS1cxW2lLuItiieA2dZAKhQv+Mmxr+RfvSjjP02LZxNzh
   gOrhMmnI7q0848XbP145SzNxrXrhDaTnUYhTq/OQVAtKoLaG938Lpn6r6
   /ULmSFRO7mq4rPpVtyWOouoXXoLd06sFqWdDYk1HbtA7UDPnH59sYo+s+
   rrAJW1k6RHXOgJC2vfcLkUBo+ObIoynKOqho/NFFsabvloTu7uqGQhRL4
   w==;
X-CSE-ConnectionGUID: aiWPhCqQTpKanQ9w2NmK3g==
X-CSE-MsgGUID: +dL2UhAdTm+RjScetZXO/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51017006"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51017006"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:01:15 -0700
X-CSE-ConnectionGUID: YjoTA+f/QkGOj+1MoCvdnA==
X-CSE-MsgGUID: TNPILqvQTdapTvwDBlLKaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="170380882"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:01:10 -0700
Message-ID: <ac62541b-185a-47aa-86a7-d4425a98699d@intel.com>
Date: Wed, 11 Jun 2025 22:01:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
To: Sean Christopherson <seanjc@google.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Jiewen Yao <jiewen.yao@intel.com>,
 Tony Lindgren <tony.lindgren@intel.com>,
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
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
> 
> Why can't KVM just do what it already does, and return an error to the guest?

Because GHCI requires it must be supported. No matter with the old GHCI 
that only allows <GetTdVmCallInfo> to succeed and the success of 
<GetTdVmCallInfo> means all the TDVMCALL leafs are support, or the 
proposed updated GHCI that defines <MapGpa> as one of the base API/leaf, 
and the base API must be supported by VMM.

Binbin wants to honor it.

> 	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
> 		ret = TDVMCALL_STATUS_INVALID_OPERAND;
> 		goto error;
> 	}


