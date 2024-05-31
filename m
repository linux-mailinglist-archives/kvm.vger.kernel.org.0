Return-Path: <kvm+bounces-18463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4328D57B9
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 03:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105541C2446B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 01:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E414EAE9;
	Fri, 31 May 2024 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gctc3cpe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16AE7483;
	Fri, 31 May 2024 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717118584; cv=none; b=L/vNuUVWoEnZpV795cM53uOwssywO8YdZCv9an+kdtZEKVcNelFQwAlAziTIHXUqIcGbgtMafG1logrSsLYNV0E65dehXrdkcPPhCc9T8ob/vtl65VbGi7f/4CxDQxLD9aU8wGkT/4FI4zpBBio0p3CDeWSkY6g7bv50yioAiZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717118584; c=relaxed/simple;
	bh=nlJxlGmynhU7KREnzEbXx6DTgU2f7pwNSzsU+KcONRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jR7EnXNoRPR3czusByXxDheyzstM9xfAkEp7KnumzPN2PjcRW7FKGms5YQYEJQQFq0QZ4oQ5e8ARupFcRjSOrV9aVjtCxENo0gQeVEMN0ZJlamrfTzCF1UcCkt42Mxyiw56H5efDptVfxnMe4PZgzBNP0A3H03slMHxxlcNy0JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gctc3cpe; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717118582; x=1748654582;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nlJxlGmynhU7KREnzEbXx6DTgU2f7pwNSzsU+KcONRc=;
  b=Gctc3cpe6JcGNm4yd1wve0ZwGc6ksMgZ1q8nMoN7/0NUvyjdcck0mcLF
   QTdHd+EQDKNNByUYC7oPHSPwQgcNUtrWLZJkHAs+UlaiM6gUJeQKa6n9i
   8ONn8NxzXPpu/ljg+CLJhcg76zJE+BnyIKXOgwQOl5UKIQz/yu4ex3PCa
   kQkQfxQtMkpHLJSOiGsgvcrOIsuARUMoA9HWTMrWknBoK4hCAduEoL4c3
   q03g9mNhHoEunL/7m+oqM6JXuTbVuzYxRwwDwmMDpODpzOi2FpYTPkw2e
   GBCii+P3pJsFXDhz+OXfG3cgCmzfMAxJIUHmJ/0wdST5VUxEbqEgg9veR
   Q==;
X-CSE-ConnectionGUID: AffI23o3RU2EH1pTXQsM0g==
X-CSE-MsgGUID: aQsD+GwnRwWG+DzhioaLqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13813789"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13813789"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 18:23:02 -0700
X-CSE-ConnectionGUID: JYIBlf2GTXWPxN7j2kb+Tw==
X-CSE-MsgGUID: 0jVmIHa9Re2o9ypgdTRyTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="67200458"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 18:22:53 -0700
Message-ID: <3999aadf-92a8-43f9-8d9d-84aa47e7d1ae@linux.intel.com>
Date: Fri, 31 May 2024 09:22:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com>
 <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
 <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com>
 <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
 <7da9c4a3-8597-44aa-a7ad-cc2bd2a85024@linux.intel.com>
 <CABgObfajCDkbDbK6-QyZABGTh=5rmE5q3ifvHfZD1A2Z+u0v3A@mail.gmail.com>
 <ZleJvmCawKqmpFIa@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZleJvmCawKqmpFIa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/30/2024 4:02 AM, Sean Christopherson wrote:
> On Tue, May 28, 2024, Paolo Bonzini wrote:
>> On Mon, May 27, 2024 at 2:26 PM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>> It seems like TDX should be able to do something similar by limiting the
>>>> size of each KVM_HC_MAP_GPA_RANGE to TDX_MAP_GPA_MAX_LEN, and then
>>>> returning TDG_VP_VMCALL_RETRY to guest if the original size was greater
>>>> than TDX_MAP_GPA_MAX_LEN. But at that point you're effectively done with
>>>> the entire request and can return to guest, so it actually seems a little
>>>> more straightforward than the SNP case above. E.g. TDX has a 1:1 mapping
>>>> between TDG_VP_VMCALL_MAP_GPA and KVM_HC_MAP_GPA_RANGE events. (And even
>>>> similar names :))
>>>>
>>>> So doesn't seem like there's a good reason to expose any of these
>>>> throttling details to userspace,
>> I think userspace should never be worried about throttling. I would
>> say it's up to the guest to split the GPA into multiple ranges,
> I agree in principle, but in practice I can understand not wanting to split up
> the conversion in the guest due to the additional overhead of the world switches.
>
>>   but that's not how arch/x86/coco/tdx/tdx.c is implemented so instead we can
>>   do the split in KVM instead. It can be a module parameter or VM attribute,
>>   establishing the size that will be processed in a single TDVMCALL.
> Is it just interrupts that are problematic for conversions?  I assume so, because
> I can't think of anything else where telling the guest to retry would be appropriate
> and useful.

The concern was the lockup detection in guest.

>
> If so, KVM shouldn't need to unconditionally restrict the size for a single
> TDVMCALL, KVM just needs to ensure interrupts are handled soonish.  To do that,
> KVM could use a much smaller chunk size, e.g. 64KiB (completely made up number),
> and keep processing the TDVMCALL as long as there is no interrupt pending.
> Hopefully that would obviate the need for a tunable.

Thanks for the suggestion.
By this way, interrupt can be injected to guest in time and the lockup 
detection should not be a problem.

About the chunk size, if it is too small, it will increase the cost of 
kernel/userspace context switches.
Maybe 2MB?

