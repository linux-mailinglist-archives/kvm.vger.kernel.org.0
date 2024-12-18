Return-Path: <kvm+bounces-34027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D64719F5C53
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 02:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2FB31894404
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D84C42048;
	Wed, 18 Dec 2024 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8JBAX0k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FAE3596E;
	Wed, 18 Dec 2024 01:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734485898; cv=none; b=nAenpbM7JUB/ZJ0D7UylZlrPezWh6k6VfkIjT06doLv/T5+YRIXoLj2UD5rNDxYM9sSwPNgjr0vS+YDgIGqRd/3g5sRofu1fc0ZDM4PI6zoKh620/bwTIwCOeH2I49dKvzD8ObMlRYGVgH3exWB+goI4/nhU06sKnAYbZpDg+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734485898; c=relaxed/simple;
	bh=+bRsbd/FmUrPageFeGe2okkMtZRiKcGRziWtptFB+Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VS+B840PN/GAwgLKpu2ssdhAj3Ir1ynrkIaoMsJDSCW7R1aOJ690efHBn80AXCldkC/NkbU71inQxkGIJAXh4iei/S3E0fIoAm12bScH05NCpokJFTtRYBUOew3sIoNxwMRN3WYjIQeHc4d/TKDMTQndQcNMxSein4eAAH2ssC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8JBAX0k; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734485896; x=1766021896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+bRsbd/FmUrPageFeGe2okkMtZRiKcGRziWtptFB+Zg=;
  b=W8JBAX0kJmPNzFPfco6shlZeKaKuJW8NcTWUWfdyfy1by/oCGhBWmPNQ
   grlbLrFjWE/NNNs2VscO0wglI/tsH7424NEME5c/vnCYnl0oX1WgZFxEo
   HvV5WE7nxJ5qjh6SfFtwZ7oDWWwaUVp4JX/hX06dbD0XPuDuMvUqQXoQL
   tK1Y+vYZdNparveASYx/joHHZQVLp2NU88Enbz6FNSZ41LJ6BR5C7rRxl
   5CjgY1AqDDzrzvKY5jCyIDzCJlrT1cOQw/rrgXSS3/kxYwVKa+W08mPS/
   UcTAXbC7cK/eK8sGTPtSMm+mnNtGsykSpOMSn6EYSOl7xiBNwtKNmPhxX
   Q==;
X-CSE-ConnectionGUID: MfHf1iaRRqipaPjSpcaCqQ==
X-CSE-MsgGUID: j5Q9MB9kROWNohqj634Brw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="38882656"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="38882656"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 17:38:15 -0800
X-CSE-ConnectionGUID: WkC/lnTHQK24GjPSSOXN3g==
X-CSE-MsgGUID: 578vc1vRSceBcbndxg+YSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135036486"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 17:38:13 -0800
Message-ID: <fc0306fe-8a78-4024-9b67-0f8cb9f7450a@linux.intel.com>
Date: Wed, 18 Dec 2024 09:38:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <d3adecc6-b2b9-42ba-8c0f-bd66407e61f0@intel.com>
 <692aacc1-809f-449d-8f67-8e8e7ede8c8d@linux.intel.com>
 <edc7f1f3-e498-44cc-aa3c-994d3f290e01@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <edc7f1f3-e498-44cc-aa3c-994d3f290e01@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/16/2024 2:03 PM, Xiaoyao Li wrote:
> On 12/16/2024 9:08 AM, Binbin Wu wrote:
>>
>>
>>
>> On 12/13/2024 5:32 PM, Xiaoyao Li wrote:
>>> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>>>
>> [...]
>>>> +
>>>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct vcpu_tdx * tdx = to_tdx(vcpu);
>>>> +    u64 gpa = tdvmcall_a0_read(vcpu);
>>>
>>> We can use kvm_r12_read() directly, which is more intuitive. And we can drop the MACRO for a0/a1/a2/a3 accessors in patch 022.
>> I am neutral about it.
>>
>
> a0, a1, a2, a3, are the name convention for KVM's hypercall. It makes sense when serving as the parameters to __kvm_emulate_hypercall().
>
> However, now __kvm_emulate_hypercall() is made to a MACRO and we don't need the temp variable like a0 = kvm_xx_read().
>
> For TDVMCALL leafs other than normal KVM hypercalls, they are all TDX specific and defined in TDX GHCI spec, a0/a1/a2/a3 makes no sense for them.
OK, make sense.

Thanks!


