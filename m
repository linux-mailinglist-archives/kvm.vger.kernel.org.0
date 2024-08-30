Return-Path: <kvm+bounces-25425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F16D29654B2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A08471F23336
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 01:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7249A481DB;
	Fri, 30 Aug 2024 01:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NL0TDQjA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35064690;
	Fri, 30 Aug 2024 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724981367; cv=none; b=B6EcD/9sFARdEU52UfucPzvUfAHvNNeJr5pqr9/obEzK2XMKHm2bv3IKwArHsSz2qoNc9e4Ss9Eb1A2HkPWaEQm4E8opc0+AT7KWLx+ks62o27aqNy88ZLxwbeFeMPQ1RNnYKIL0a/DDvPxmpjbQrAAqOfLfaVryBKBTYno5Wb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724981367; c=relaxed/simple;
	bh=pkUmoxffZAzxV8tI1/o047ilCDHAtHXf1NsIkJBqzuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQCIo+ZmmrKEK488BdPChkv1WmbJn5L5GHfUemxWf0IiHz2Oz1/anHVtAKUk94d2XFAIK/CnbrKQNHTFlZofgQzBB+XbxTVGvojNtJA9XOcNih5KbadBATuee6vHepZG1Xrl1VmTb2L8gCzWDkKEKCor1Wz0FlHJZU16+biGCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NL0TDQjA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724981365; x=1756517365;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pkUmoxffZAzxV8tI1/o047ilCDHAtHXf1NsIkJBqzuk=;
  b=NL0TDQjAAJmmxejJKjKuFWmBACNZXjOy2816W2m4nCZYibmNf7Y7axYm
   ZZ21oVads22n+xkZ6ShhRRLS8enCqK4yenOcI9zmXXEz36xPT/mKzQiGe
   bQ3JZ2xlmWC6AaRUqM+TEuUZfZeX+E7zltfCjk1iB9VUWt6ljnGeNzkha
   I8Ka5G5Pej1Dc9FdEZzLpkP1oub8YDwdXjd7FnVzdMYLIknuPQy3bnMAU
   Q4MVPN/vAgAkPZSTAoqVro3ZtNHAu/A22RMnPJgXZ1A7QA2c/pZQd5iqJ
   MzZurYFWq7ofBYtimvdSnvW2T/XGzY7W/LMJptaHMTbTmDJMkfBA30wQb
   g==;
X-CSE-ConnectionGUID: q2CpDKHDTMyC4JMzSRY/Vw==
X-CSE-MsgGUID: 7B9eqNTYQD6gGZBJgYsvpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27490099"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="27490099"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 18:29:25 -0700
X-CSE-ConnectionGUID: omHaOa5tTEWSdnGgt9nXxw==
X-CSE-MsgGUID: 6/koAYe/Rryk7ff40Wd+hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="101261202"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 18:29:22 -0700
Message-ID: <e686a7ac-fc50-4de8-a279-e674ad8a84f4@intel.com>
Date: Fri, 30 Aug 2024 09:29:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-3-rick.p.edgecombe@intel.com>
 <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
 <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/30/2024 3:46 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-08-29 at 21:25 +0800, Xiaoyao Li wrote:
>> On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
>>> +/*
>>> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is
>>> 1024B.
>>> + */
>>> +struct td_params {
>>> +       u64 attributes;
>>> +       u64 xfam;
>>> +       u16 max_vcpus;
>>> +       u8 reserved0[6];
>>> +
>>> +       u64 eptp_controls;
>>> +       u64 exec_controls;
>>
>> TDX 1.5 renames 'exec_controls' to 'config_flags', maybe we need update
>> it to match TDX 1.5 since the minimum supported TDX module of linux
>> starts from 1.5.
> 
> Agreed.
> 
>>
>> Besides, TDX 1.5 defines more fields that was reserved in TDX 1.0, but
>> most of them are not used by current TDX enabling patches. If we update
>> TD_PARAMS to match with TDX 1.5, should we add them as well?
> 
> You mean config_flags or supported "features0"? For config_flags, it seems just
> one is missing. I don't think we need to add it.

No. I meant NUM_L2_VMS, MSR_CONFIG_CTLS, IA32_ARCH_CAPABILITIES_CONFIG, 
MRCONFIGSVN and MROWNERCONFIGSVN introduced in TD_PARAMS from TDX 1.5.

Only MSR_CONFIG_CTLS and IA32_ARCH_CAPABILITIES_CONFIG likely need 
enabling for now since they relates to MSR_IA32_ARCH_CAPABILITIES 
virtualization of TDs.

>>
>> This leads to another topic that defining all the TDX structure in this
>> patch seems unfriendly for review. It seems better to put the
>> introduction of definition and its user in a single patch.
> 
> Yea.


