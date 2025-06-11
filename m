Return-Path: <kvm+bounces-49087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B026AD5B56
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5096117C7D3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845901E2606;
	Wed, 11 Jun 2025 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKT6TUOK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CE3EA98;
	Wed, 11 Jun 2025 16:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749657626; cv=none; b=YtPKoztf0r5+guGC6G1dlPrOSbty8eaM4XgHvqfhh3sPR++7wLgsBqsog2XxZ7NHqr6fTD1bnftXMAxBVHwyeQCXSQhoHhk9++QC8W1SgpFFG45UkpzAjoQGWtn3fyUj/n0E8dj28Fkmp7m4+HkkZI1YpxXn6uPFNmeDl3bKn1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749657626; c=relaxed/simple;
	bh=BkD1XYR/BuytZqUUGnqZ6ZVXug4e1DergqtOvJL28Bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ogH9/UphMPlanBBKAeri2x1qvwZFB9vCPoem7HU536mp8xogubKUVP8OPIKByqhs5cd/ztINKsxorJ0iAJnEUKf/zWV400MO079XrsdYBa2OqR5sZMgT0wTH78h5Sg8QdVZ41bqVo3sLi9QrGzOdx5aInYLIkihQQ+DDTly7UQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TKT6TUOK; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749657625; x=1781193625;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BkD1XYR/BuytZqUUGnqZ6ZVXug4e1DergqtOvJL28Bk=;
  b=TKT6TUOKZiMp0IMM0gL+0TemQP2HiVtXKnhubZMFBGGKbsM3cGQ+sdyG
   aERtyMojM6wmC1BhOpgC6kEk/VR5/lxVAuCY8CLWcpg6ShKE8YhfF9het
   VGNmvqwmez4OLmJdbI0k9hXD1Bmy/akM73RqL65VxLwZ8TV6lbWYggEUe
   dbuCPSjikq827OIZ0A30OiPgbivRRqR3KBMebWbjT5oYAwp5qmKuZPG15
   uiKxlLPW9IWhQ0wtRGQKAg7XWakG6DUwpGFCx4R64vT+3mpz6aL/NVcXL
   FLEE2XrZY3aj9ifBmvKOOqehidhs+vw232nqi21VGJCTdoBatxT3/48+y
   w==;
X-CSE-ConnectionGUID: eB0IuQFiTSuvYfvyGhZZsQ==
X-CSE-MsgGUID: A55jczP9TCSNzJn+J++YlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="63153323"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="63153323"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:00:24 -0700
X-CSE-ConnectionGUID: QWv6GWAKTraeOQzbQHaQYw==
X-CSE-MsgGUID: HLeiHM0TTYapsxHFcJgbnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="152392947"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.118]) ([10.124.241.118])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:00:21 -0700
Message-ID: <b4d89b67-0c83-42c7-90d1-3a2c1431a933@linux.intel.com>
Date: Thu, 12 Jun 2025 00:00:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
 <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
 <aEh0oGeh96n9OvCT@google.com>
 <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
 <aEmGTZbMpZhtlkIh@google.com>
 <ac62541b-185a-47aa-86a7-d4425a98699d@intel.com>
 <f0d42c86e0b2fbad3fa3fdcdce214059b0581573.camel@intel.com>
 <a7929151-0a1f-4349-99b5-186c187710ff@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a7929151-0a1f-4349-99b5-186c187710ff@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/11/2025 10:26 PM, Xiaoyao Li wrote:
> On 6/11/2025 10:04 PM, Edgecombe, Rick P wrote:
>> On Wed, 2025-06-11 at 22:01 +0800, Xiaoyao Li wrote:
>>>>> So, when the TDX guest calls MapGPA and KVM finds userspace doesn't opt-in
>>>>> KVM_HC_MAP_GPA_RANGE, just return error to userspace?
>>>>
>>>> Why can't KVM just do what it already does, and return an error to the
>>>> guest?
>>>
>>> Because GHCI requires it must be supported. No matter with the old GHCI
>>> that only allows <GetTdVmCallInfo> to succeed and the success of
>>> <GetTdVmCallInfo> means all the TDVMCALL leafs are support, or the
>>> proposed updated GHCI that defines <MapGpa> as one of the base API/leaf,
>>> and the base API must be supported by VMM.
>>>
>>> Binbin wants to honor it.
>>
>> But KVM doesn't need to support all ways that userspace could meet the GHCI
>> spec. If userspace opts-in to the exit, they will meet the spec. If they
>> configure KVM differently then they wont, but this is their decision.
>
> I agree with you and Sean. And I'm trying to answer Sean's question on behalf of Binbin.
Yes, it was my thought.

>
> Strictly speaking, KVM can be blamed for some reason. Because it is KVM that returns success for <GetTdVmCallInfo> unconditionally when r12 == 0  to report that all the (base) leafs are supported.
>
> But I totally agree with KVM cannot guarantee userspace will behave correctly. Even with this patch that KVM mandates the userspace to enable user exit of KVM_HC_MAP_GPA_RANGE, it's still possible for a misbehaved userspace to error to TD guest on KVM_HC_MAP_GPA_RANGE and breaks the semantics of successful <GetTdVmCallInfo>.
>
> So I'm with you and Sean.
>
Also see my reply
https://lore.kernel.org/kvm/ba611f52-9817-46ff-b16b-a9ef7404a51d@linux.intel.com/

In the next version, how about combining this patch to patch 1 to use
TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED if userspace doesn't opt-in
KVM_HC_MAP_GPA_RANGE?

