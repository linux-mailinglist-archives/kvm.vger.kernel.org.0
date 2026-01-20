Return-Path: <kvm+bounces-68606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 446AFD3C459
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:58:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E679565A30
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D06F3D6697;
	Tue, 20 Jan 2026 09:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DS4C70GB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF93E959E;
	Tue, 20 Jan 2026 09:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768902394; cv=none; b=ZFaGa5BjZRFXi0LPRirvoKNpXF7Mj4+Fb0U9dVMMCUzUFVRBqEisMABx6QUWGpE9o0gX/HNq/SRfPI3wVl88YT/cdl7eLT6F/fYZg5MACX9OuVUiD1GlwrJqzLyEfjSBHkImbe6oQ1YpLBPWBGsPlcm0aolP1dVIZTK31zHddZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768902394; c=relaxed/simple;
	bh=XE/5lRHO3RRDkKA4ZWEYEm62Xqa6rg6Ol6TX+aF/914=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sGj5pF9N04NprslDPC3hVVKwJKpXd1gRBs503wxLMGwEs3oxYZSKkc2vTy2CB7VUW1Y/UXx2LetM5a34XedCicXNqiax/mqv2F7nhIqWZrDce8gcUGu4uFUKS4PLGF/vjGKJunIo9AekD+qCDr3P4YDkaFYcaZWWMpx5iJYLnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DS4C70GB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768902392; x=1800438392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XE/5lRHO3RRDkKA4ZWEYEm62Xqa6rg6Ol6TX+aF/914=;
  b=DS4C70GBuqoPUSt+x1rLwTVNt7sXv8TAdHrDYrXFb8QaD1WbZ4k/jzuA
   oOijOdRMe5sSuUrKsftqD3ZBrbV28aqowGhRPEIXfdizcr2pbTHKYRpMn
   emEP4HHMX3tuzXkZEYflu/mCRf5fo4/U8FoweW1JhE+p86Q2wI9dE/Xub
   HTaXGyxD6pHE/gF/qaayrG7AMm5Suoa01+2oEFLZ9hcdjlGoQrQ7aoSNl
   YjseMdiDI8fp3V4erxIwEQvvHEVxd58398+r8wDLGWB3omVEQIX9S968B
   I7RbLzHhnWENdNtRajd/0QpYzGn2LnVxuvU44Z0YiXSuFQULdP0wei2J4
   A==;
X-CSE-ConnectionGUID: ZnMAwDqmSoqg4rB1nWhvZQ==
X-CSE-MsgGUID: WiG6r8SDR1KNtQnVHyXIdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="80408620"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="80408620"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:46:32 -0800
X-CSE-ConnectionGUID: XT3laMBvQ9SDnpIwDFME7A==
X-CSE-MsgGUID: ydQTzoflQAiSBKs09vppBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="206337139"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:46:28 -0800
Message-ID: <04d96812-f74a-4f43-9ea4-c4f2723251c5@linux.intel.com>
Date: Tue, 20 Jan 2026 17:46:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
To: Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org,
 sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com> <aRQ3ngRvif/0QRTC@intel.com>
 <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com> <aW83vbC2KB6CZDvl@intel.com>
 <C3F658E2-BB0D-4461-8412-F4BC5BCB2298@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <C3F658E2-BB0D-4461-8412-F4BC5BCB2298@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/20/2026 5:09 PM, Xin Li wrote:
> 
> 
>> On Jan 20, 2026, at 12:07 AM, Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Mon, Jan 19, 2026 at 10:56:29PM -0800, Xin Li wrote:
>>>
>>>
>>>> On Nov 11, 2025, at 11:30 PM, Chao Gao <chao.gao@intel.com> wrote:
>>>>
>>>> I'm not sure if AMD CPUs support FRED, but just in case, we can clear FRED
>>>> i.e., kvm_cpu_cap_clear(X86_FEATURE_FRED) in svm_set_cpu_caps().
>>>
>>> AMD will support FRED, with ISA level compatibility:
>>>
>>> https://www.amd.com/en/blogs/2025/amd-and-intel-celebrate-first-anniversary-of-x86-ecosys.html
>>>
>>> Thus we don’t need to clear the bit.
>>
>> In this case, we need to clear FRED for AMD.
>>
>> The concern is that before AMD's FRED KVM support is implemented, FRED will be
>> exposed to userspace on AMD FRED-capable hardware. This may cause issues.
> 
> Hmm, I think it’s Qemu does that.
> 
> We have 2 filters, one in Qemu and one in KVM, only both are set a feature is enabled.
> 
> What I have missed?

If a newer QEMU (with AMD's FRED support patch) + an older KVM (without AMD's
FRED support, but KVM advertises it), it may cause issues.

I guess it's no safety issue for host though, AMD should also require some
control bit(s) to be set to allow guests to use the feature.

I agree with Chao that it should be cleared for AMD before AMD's FRED KVM
support is implemented.

