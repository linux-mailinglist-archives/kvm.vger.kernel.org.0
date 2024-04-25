Return-Path: <kvm+bounces-15936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709078B24BF
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 17:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1186D1F22D4C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDB314AD3E;
	Thu, 25 Apr 2024 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DyMRXkYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9914AD32
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714057837; cv=none; b=PC7tV8EAxb5SvYPMfjKRB3Ik3luh1rwlqpoNB2ng/ye6+kZWNLCFCJtM8RscwR2bViFRbqivyCpvEGTAoijxOq9iz6zOWqE3JIAMOUell7IvWhMqVuETokkenGo6eYUrk76yoxSF0cqbGOHzG+j+aywk5p+2zflgIlXgu+pU5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714057837; c=relaxed/simple;
	bh=aauSZtuZc6T6HDAaLCQbvBPyd353K7Dl14nygvigX2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DtRrjoTrx+E+wkyKtNnrFF6LeD+LPq6CzO3J9Hacxn4dE22JSLg/IyfNYEesjF1akKB4rHYdTO1fvA/mKTYKbocpoD4q9WJadST+tNOKdf48jcsi/tN2XWn/eU6linA6zBHw/I8MJGKoa8fhaXvgpLSsdftXwbjewWIlRLgZxNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DyMRXkYJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714057836; x=1745593836;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=aauSZtuZc6T6HDAaLCQbvBPyd353K7Dl14nygvigX2w=;
  b=DyMRXkYJWda0S3NH/6lefovM3VNUAdsmw3j8ivh8gey/VNcQCIqONJed
   3G4wKOIhG7RSoiV3Hf5VDnMg9Nlr0W5Ji7TzdXntSvaGFtuiOJZOxM3t7
   Bea0WR8+zIgW8O+0dcZgYRW8WtBhsDfXGFtbxm4J9HfZpZM4hdZmkVC8S
   8y7wgoakfnQ3RWNFm94SzwPSPBHugkUNWGL2+17vSHjcyJLpPQgUWSH6o
   xVvbOo4YMQPy3uaVfCRmqlnp6PlSbjIfqNPee8+xSMGJiXUoESW3Ipgqk
   7pKphPzEu2Y/I5e5uzQ2ADZEbmDvEc/2QQX8vN7mmWr0U1CKVoxib40jj
   A==;
X-CSE-ConnectionGUID: UOSJ8HaoQouMZUb8zeamtw==
X-CSE-MsgGUID: 2yCEF8l9Tyacf+fj/2Da/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="32245332"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="32245332"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 08:09:36 -0700
X-CSE-ConnectionGUID: jqyVbMibRy+EUQLIm8YmBA==
X-CSE-MsgGUID: QECKQq6yT6CDt5dOVEg9BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="56277733"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 08:09:33 -0700
Message-ID: <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
Date: Thu, 25 Apr 2024 23:09:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] TDX module configurability of 0x80000008
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/25/2024 12:55 AM, Edgecombe, Rick P wrote:
> Hi,
> 
> This is a new effort to solicit community feedback for potential future TDX
> module features. There are two features in different stages of development
> around the configurability of the max physical address exposed in
> 0x80000008.EAX. I was hoping to get some comments on them and share the current
> plans on whether to implement them in KVM.
> 
> One of the TDX module features is called MAXPA_VIRT. In short, it is similar to
> KVM’s allow_smaller_maxphyaddr. It requires an explicit opt-in by the VMM, and
> allows a TD’s 0x80000008.EAX[7:0] to be configured by the VMM. Accesses to
> physical addresses above the specified value by the TD will cause the TDX module
> to inject a mostly correct #PF with the RSVD error code set. It has to deal with
> the same problems as allow_smaller_maxphyaddr for correctly setting the RSVD
> bit. I wasn’t thinking to push this feature for KVM due the movement away from
> allow_smaller_maxphyaddr and towards 0x80000008.EAX[23:16].
> 
> There is also a potential future TDX module feature currently being evaluated
> around the configurability of 0x80000008.EAX[23:16]. I wanted to get some
> community comments on the feature while it is still in the early stages of
> development.
> 
> 0x80000008[7:0] is defined by the SDM as MAXPHYADDR. KVM is designed to work
> with guest MAXPHYADDR set to host MAXPHYADDR. In the future there is work for
> KVM to also accommodate a potentially smaller value in 0x80000008.EAX[23:16] for
> normal VMs. This value is defined by AMD spec as GuestPhysAddrSize:
>     Maximum guest physical address size in bits. This number applies only to guests
>     using nested paging. When this field is zero, refer to the PhysAddrSize field
>     for the maximum guest physical address size.
> 
> The idea is that TDX module could add the capability to configure these bits as
> well, so that TDs could match normal VMs for cases where there is a desire for
> the guests MAXPA to be smaller than the hosts. The requirements would be,
> roughly:
>   - The VMM specifies the 0x80000008.EAX[23:16] when creating a TD.
>   - The TDX module does sanity checking. 
>   - The 0x80000008.EAX[23:16] field is used to communicate the max addressable
>   GPA to  the guest. It will be used by the guest firmware to make sure
>   resources like PCI bars are mapped into the addressable GPA.
>   - If the guest attempts to access memory beyond the max addressable GPA, then
>   the TDX module generates EPT violation to the VMM. For the VMM, this case
>   means that the guest attempted to access "invalid" (I/O) memory.
>   - The VMM will be expected to terminate the TD guest. The VMM may send
>   a notification, but the TDX module doesn't necessarily need to know how.

This is not the same as how it works for normal (non-TDX) VMs.

For normal VMs, when userspace configures a smaller one than what 
hardware EPT/NPT supports, it doesn't cause any issue if guest accesses 
GPA beyond [23:16] but within hardware EPT/NTP capability.

It's more a hint to guest that KVM doesn't enforce the semantics of it. 
However, for TDX case, you are proposing to make it a hard rule.

> Glad to hear any comments. Thanks.
> 
> Rick


