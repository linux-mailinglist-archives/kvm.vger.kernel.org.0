Return-Path: <kvm+bounces-61425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A83C1D64C
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6714189BAF3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6DA3176E8;
	Wed, 29 Oct 2025 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXun77EC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7F230E825;
	Wed, 29 Oct 2025 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761772414; cv=none; b=YQi+qLP5P4tM4ckf3wEVIaC1y8xwp5EKecwfZjz5lCblfImPz/D4/GLYxEhLNbmzmduQ+CmcGfcO75y6B+rR0Add7osPJQ2H9bWA9hARW+JOVuF9vHlWOgifNDGTSvi5Ce1Y00Ew5Eqq+CeKZvEuvMIR0dRhAsDrnNreNs07jPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761772414; c=relaxed/simple;
	bh=dwGqFzvSIG4YopfFqscStwzw1aX6bshmENKUonAoHjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kpl67rOvo4KRhL2rtk/6+5rW5hPJ1YNwO8toocPboMbPDKWJY2LVwQAT9MCe7OvpqjVjo4nOc4BwQGp5ndoxPfokAiSGxSnudljD8x7bSrO3Wen/knHeg1EcSFY3hRJn6w7Al4228/9obp3BXj+5KPbQsKiSMJKf0ceAVi8bw6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXun77EC; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761772413; x=1793308413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dwGqFzvSIG4YopfFqscStwzw1aX6bshmENKUonAoHjU=;
  b=OXun77ECFqy58EettHhl4fsvFj1h7E/RNaMi5XOpORcFaeHze7ovz5Gl
   ha8DD9cg4QIgzXwMsCIKMhUouoda8CfOAokVSqF3+oErp9S1e4T4goaaD
   GGMtPq4n8o8d5h/XQfpjnsTWeQ7eXBXMw4MTUBF/6QndbBr4CWOzuQJ9B
   exTsAVoBzPNoAP4qxsl1jzmGir9Sj5bxD2EhBlIToMzqK3C5CZxC/sQil
   1J+hJftsO+2kDm3/5P5yytMvdf0Ig73yKEw6RhoeK1w77rQqUZboZNjzl
   hKgaSHXyB7bDZHzrebkFxPAdJ5U7nEq3i/OjQml2IHZrZDyRNlxtepEpb
   A==;
X-CSE-ConnectionGUID: pqG/LpaKSgS1aN5MW/mlqw==
X-CSE-MsgGUID: cX7TMTIjRkq6bi5Cy+FQmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="64003247"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="64003247"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:13:32 -0700
X-CSE-ConnectionGUID: ScMUlIs7RK+JcG7D2TqI1g==
X-CSE-MsgGUID: CM1SNaZGTRSgRojYNKQmmA==
X-ExtLoop1: 1
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.109.206]) ([10.125.109.206])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:13:31 -0700
Message-ID: <2e0e538e-99f0-4828-bdd3-fda7ad3794c3@intel.com>
Date: Wed, 29 Oct 2025 14:13:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel
 pointer
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
 <20251029194831.6819B2E7@davehans-spike.ostc.intel.com>
 <6bfe570e35364bd121b648fe8475f705666183d6.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6bfe570e35364bd121b648fe8475f705666183d6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 14:06, Edgecombe, Rick P wrote:
> For the KVM side of tdx, the commits are getting prefixed with "KVM: TDX: ", and
> "x86/virt/tdx" is being used arch/x86/virt/vmx/tdx/tdx.c. It's probably not too
> late to adopt the one true naming scheme. I don't have a strong preference
> except some consistency and that the maintainers agree :)

Yeah, I just picked one. I honestly don't care what we do in the end. I
was also probably just going to send these in the tip/x86/tdx branch
unless anyone screams, so I did it the tip-ish way.

>> There are two 'kvm_cpuid2' pointers involved here. There's an "input"
>> side: 'td_cpuid' which is a normal kernel pointer and an 'output'
>> side. The output here is userspace and there is an attempt at properly
>> annotating the variable with __user:
>>
>> 	struct kvm_cpuid2 __user *output, *td_cpuid;
>>
>> But, alas, this is wrong. The __user in the definition applies to both
>> 'output' and 'td_cpuid'.
>>
>> Fix it up by completely separating the two definitions so that it is
>> obviously correct without even having to know what the C syntax rules
>> even are.
> 
> If we want it:
> Fixes: 488808e682e7 ("KVM: x86: Introduce KVM_TDX_GET_CPUID")

Thanks for that. I might dump in in, but sometimes folks can get all hot
and bothered about getting true fixes upstream fast. I was planning to
go go the slow next-merge-window route with these.

