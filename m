Return-Path: <kvm+bounces-38108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77282A3539F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 02:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58C447A3CBE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDEF70824;
	Fri, 14 Feb 2025 01:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UbdOsdoK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B61E502;
	Fri, 14 Feb 2025 01:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739496042; cv=none; b=NQV3eo20G4QcYcv1/3SMmDHgZkB76LTgEsZZHuHUtqZfro0lE3O4gR4b73iWsiSTW2NvV4ZCSfiBQEHE8Ss7J7xdHR9EaSHMyZre2mTixR6pnvCylIPbi6rZ7KEL3tzWqhLjWgtYpXFHw3xt/CmmX9BrqDZd2xSuo1X5wDWnTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739496042; c=relaxed/simple;
	bh=i+KxcQUtTSoRPj7eik45+TNJr+WDnEYIYJQJCziSKng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ULrvkZtdTT+sJ9pA+xHTe8EU0av3140s4oCm3++IsOvUym+RIugpbh9uasvTB5t5c93sx7sv6scH7JsGtLC/BQcw5TczEltjbYmjWagmJ8r7LR92WTyuWCmL7Er6IvNex9RabCqLkaKC+9SjsbW2TN0Y3MeD25skfsTBQQOl+Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UbdOsdoK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739496041; x=1771032041;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i+KxcQUtTSoRPj7eik45+TNJr+WDnEYIYJQJCziSKng=;
  b=UbdOsdoK58v4zb/RWfjHE4ywLZF6eqVVvild0M5JMOPntivbvpcx54HE
   l48LgP9nxVuxuiHnQ4rOg+XYDTL6AVbQ7rjgaW0T50RDTrEd5q7sSJPru
   EYdILX3OUCGxq+misqOZmPnOfySkfPjrJ5P6detpA5+zJLCI+j60ALWFM
   gE5zN84NyBdcSiSqDkk7c+c6XsuFVLXv7qCrxne9MInSybK3HWo0PvkXo
   WwlJ5CkTxsjUqjTUUgaVnzk4/zlvPvvOiiFXphnIHFJcp4t3RkvhPNxet
   hyB0LMk0xIFg4TbqqzcjsiMQAL8asPt/fqn5z9j5hBZTxSLPAhi1G4tXH
   g==;
X-CSE-ConnectionGUID: Fyt6LyWVQb2nNYgB2RV0zw==
X-CSE-MsgGUID: XlNiPqWPT3+Nsh5MxU+Hqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="40263472"
X-IronPort-AV: E=Sophos;i="6.13,284,1732608000"; 
   d="scan'208";a="40263472"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 17:20:40 -0800
X-CSE-ConnectionGUID: YPutUsYAQ1eT0l1Nd6JPOg==
X-CSE-MsgGUID: 7/i8F6UuS0ymYMAg5TEjAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118523543"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 17:20:37 -0800
Message-ID: <d67ccc93-9341-4551-9926-4b67f9c4ad09@linux.intel.com>
Date: Fri, 14 Feb 2025 09:20:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
 <Z6wHZdQ3YtVhmrZs@intel.com>
 <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
 <da350e731810aa6726ff7f5dfc489e1969a85afb.camel@intel.com>
 <aa6a2af0-fa4b-42a7-98d6-d295efbb2732@linux.intel.com>
 <d79ebae6825071201f38bbae4af4df05d84c7ab5.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d79ebae6825071201f38bbae4af4df05d84c7ab5.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/14/2025 9:01 AM, Edgecombe, Rick P wrote:
> On Fri, 2025-02-14 at 08:47 +0800, Binbin Wu wrote:
>> On 2/14/2025 5:41 AM, Edgecombe, Rick P wrote:
>>> On Wed, 2025-02-12 at 10:39 +0800, Binbin Wu wrote:
>>>>> IIRC, a TD-exit may occur due to an EPT MISCONFIG. Do you need to
>>>>> distinguish
>>>>> between a genuine EPT MISCONFIG and a morphed one, and handle them
>>>>> differently?
>>>> It will be handled separately, which will be in the last section of the KVM
>>>> basic support.  But the v2 of "the rest" section is on hold because there is
>>>> a discussion related to MTRR MSR handling:
>>>> https://lore.kernel.org/all/20250201005048.657470-1-seanjc@google.com/
>>>> Want to send the v2 of "the rest" section after the MTRR discussion is
>>>> finalized.
>>> I think we can just put back the original MTRR code (post KVM MTRR removal
>>> version) for the next posting of the rest. The reason being Sean was pointing
>>> that it is more architecturally correct given that the CPUID bit is exposed. So
>>> we will need that regardless of the guest solution.
>> The original MTRR code before removing is:
>> https://lore.kernel.org/kvm/81119d66392bc9446340a16f8a532c7e1b2665a2.1708933498.git.isaku.yamahata@intel.com/
>>
>> It enforces WB as default memtype and disables fixed/variable range MTRRs.
>> That means this solution doesn't allow guest to use MTRRs as a communication
>> channel if the guest firmware wants to program some ranges to UC for legacy
>> devices.
> I'm talking about the internal version that existed after KVM removed MTRRs for
> normal VMs. We are not talking about adding back KVM MTRRs.
Sorry, I misunderstood it.

>
>>
>> How about to allow TDX guests to access MTRR MSRs as what KVM does for
>> normal VMs?
>>
>> Guest kernels may use MTRRs as a crutch to get the desired memtype for devices.
>> E.g., in most KVM-based setups, legacy devices such as the HPET and TPM are
>> enumerated via ACPI.  And in Linux kernel, for unknown reasons, ACPI auto-maps
>> such devices as WB, whereas the dedicated device drivers map memory as WC or
>> UC.  The ACPI mappings rely on firmware to configure PCI hole (and other device
>> memory) to be UC in the MTRRs to end up UC-, which is compatible with the
>> drivers' requested WC/UC-.
>>
>> So KVM needs to allow guests to program the desired value in MTRRs in case
>> guests want to use MTRRs as a communication channel between guest firmware
>> and the kernel.
>>
>> Allow TDX guests to access MTRR MSRs as what KVM does for normal VMs, i.e.,
>> KVM emulates accesses to MTRR MSRs, but doesn't virtualize guest MTRR memory
>> types.  One open is whether enforce the value of default MTRR memtype as WB.
> This is basically what we had previously (internally), right?
Yes. Then we are aligned. :)

>
>> However, TDX disallows toggling CR0.CD.  If a TDX guest wants to use MTRRs
>> as the communication channel, it should skip toggling CR0.CD when it
>> programs MTRRs both in guest firmware and guest kernel.  For a guest, there
>> is no reason to disable caches because it's in a virtual environment.  It
>> makes sense for guest firmware/kernel to skip toggling CR0.CD when it
>> detects it's running as a TDX guest.
> I don't see why we have to tie exposing MTRR to a particular solution for the
> guest and bios. Let's focus on the work we know we need regardless for KVM.

Guest could choose to use MTRRs or other SW protocal to communicate the memtype
for devices. I just wanted to point it out that if guest chooses to use MTRRs
as the communicate channel, it will face the #VE issue caused by toggleing
CR0.CD.



