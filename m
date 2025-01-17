Return-Path: <kvm+bounces-35708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40410A1471A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6DEF3A2986
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 00:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D424C2D1;
	Fri, 17 Jan 2025 00:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I4Fzbxk7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBAB5228;
	Fri, 17 Jan 2025 00:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737074984; cv=none; b=P3qRSNyfXArKw8IKePpVrErgGfMC2TZFA5V8i1N5mcosIM0FuA2J+/uFcU62mXt8b3jhoNvWtulbvRpyAbxZDBEWSFOs5w+zeX1HE+fV/Orx/DztQ5hfuAanuNBcJwOZC9b7qilKIRiC5k+E07DJ3Tf0Z3OdrdwkAhOCYybuXpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737074984; c=relaxed/simple;
	bh=Fw+LjwFLcPAC0t3kWWqxLTbj3zns4Aifbl9enBR8HZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnMbL2fWccfCv4QpHAuvaO29fFMWO4yfXGS1Zht/1TMttcgL4SGPIjuT7ediJnr6SPqG6IcyMwgIl1tY7SKFSjBeaV365PjJWvmcCAN48hvflu3DTrxHKHchUgIl+zSMCo0KhGTkKT+Dwe/vspiPGPj9T01XJ2+xZm4raNw6C44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I4Fzbxk7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737074983; x=1768610983;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fw+LjwFLcPAC0t3kWWqxLTbj3zns4Aifbl9enBR8HZw=;
  b=I4Fzbxk7eFjRurlypNG6LzCDxq0nyyW6Us4htXANUFYcgzCzwFiwJ+Cx
   N8PLZkN4f89pYnhmvFKEdqpL4L3szy5pUiVtRap/1vgpL671bEdxByrLr
   pTE1ABOy1NVihGwhcKLoXIMMlO8NkFXsBFjhXxErXdGj/t6KVpWzCRLS/
   SWSb2mYGtNjUkzdzJvAKGsB/pglt1jwoIdM80q5F7qvOnRKd8mWZlyq/G
   GgKuv4yaQirCHIulZe8I3kE5LH2x+MJJaecosksbXE6RorWnhh0wZJTQJ
   mDJyCs+waTOymSrSoWKGFmVsY8PyUGoPd+5BG2abKqp9WxtpqZr8R64oq
   A==;
X-CSE-ConnectionGUID: rhBKQ0tXSb2K76hxBaPnog==
X-CSE-MsgGUID: 07l4IWhrRouYVupLNPlzaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48904886"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="48904886"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 16:49:42 -0800
X-CSE-ConnectionGUID: 6smIe3SCSxOYaTqfCX5ApQ==
X-CSE-MsgGUID: el6jBq/FQHqydcd/RRjgJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="106127976"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.228]) ([10.124.241.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 16:49:38 -0800
Message-ID: <2ca5ce5b-039b-4477-8648-e1a292361eda@linux.intel.com>
Date: Fri, 17 Jan 2025 08:49:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
 <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
 <Z4kcjygm19Qv1dNN@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z4kcjygm19Qv1dNN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/16/2025 10:50 PM, Sean Christopherson wrote:
> On Thu, Jan 16, 2025, Kai Huang wrote:
>> On Mon, 2025-01-13 at 10:09 +0800, Binbin Wu wrote:
>>> Lazy check for pending APIC EOI when In-kernel IOAPIC
>>> -----------------------------------------------------
>>> In-kernel IOAPIC does not receive EOI with AMD SVM AVIC since the processor
>>> accelerates write to APIC EOI register and does not trap if the interrupt
>>> is edge-triggered. So there is a workaround by lazy check for pending APIC
>>> EOI at the time when setting new IOAPIC irq, and update IOAPIC EOI if no
>>> pending APIC EOI.
>>> KVM is also not be able to intercept EOI for TDX guests.
>>> - When APICv is enabled
>>>     The code of lazy check for pending APIC EOI doesn't work for TDX because
>>>     KVM can't get the status of real IRR and ISR, and the values are 0s in
>>>     vIRR and vISR in apic->regs[], kvm_apic_pending_eoi() will always return
>>>     false. So the RTC pending EOI will always be cleared when ioapic_set_irq()
>>>     is called for RTC. Then userspace may miss the coalesced RTC interrupts.
>>> - When When APICv is disabled
>>>     ioapic_lazy_update_eoi() will not be called，then pending EOI status for
>>>     RTC will not be cleared after setting and this will mislead userspace to
>>>     see coalesced RTC interrupts.
>>> Options:
>>> - Force irqchip split for TDX guests to eliminate the use of in-kernel IOAPIC.
>>> - Leave it as it is, but the use of RTC may not be accurate.
>> Looking at the code, it seems KVM only traps EOI for level-triggered interrupt
>> for in-kernel IOAPIC chip, but IIUC IOAPIC in userspace also needs to be told
>> upon EOI for level-triggered interrupt.  I don't know how does KVM works with
>> userspace IOAPIC w/o trapping EOI for level-triggered interrupt, but "force
>> irqchip split for TDX guest" seems not right.
> Forcing a "split" IRQ chip is correct, in the sense that TDX doesn't support an
> I/O APIC and the "split" model is the way to concoct such a setup.  With a "full"
> IRQ chip, KVM is responsible for emulating the I/O APIC, which is more or less
> nonsensical on TDX because it's fully virtual world, i.e. there's no reason to
> emulate legacy devices that only know how to talk to the I/O APIC (or PIC, etc.).
> Disallowing an in-kernel I/O APIC is ideal from KVM's perspective, because
> level-triggered interrupts and thus the I/O APIC as a whole can't be faithfully
> emulated (see below).
>
>> I think the problem is level-triggered interrupt,
> Yes, because the TDX Module doesn't allow the hypervisor to modify the EOI-bitmap,
> i.e. all EOIs are accelerated and never trigger exits.

Yes, and I think it needs to add the description about it and the
level-trigger interrupt in the commit message of some patch.


>
>> so I think another option is to reject level-triggered interrupt for TDX guest.
> This is a "don't do that, it will hurt" situation.  With a sane VMM, the level-ness
> of GSIs is controlled by the guest.  For GSIs that are routed through the I/O APIC,
> the level-ness is determined by the corresponding Redirection Table entry.  For
> "GSIs" that are actually MSIs (KVM piggybacks legacy GSI routing to let userspace
> wire up MSIs), and for direct MSIs injection (KVM_SIGNAL_MSI), the level-ness is
> dictated by the MSI itself, which again is guest controlled.
>
> If the guest induces generation of a level-triggered interrupt, the VMM is left
> with the choice of dropping the interrupt, sending it as-is, or converting it to
> an edge-triggered interrupt.  Ditto for KVM.  All of those options will make the
> guest unhappy.
>
> So while it _might_ make debugging broken guests either, I don't think it's worth
> the complexity to try and prevent the VMM/guest from sending level-triggered
> GSI-routed interrupts.  It'd be a bit of a whack-a-mole and there's no architectural
> behavior KVM can provide that's better than sending the interrupt and hoping for
> the best.
Currently, KVM doesn't do anything special if the guest send level-triggered
interrupts for TDX guests.
QEMU has a patch to set the eoi_intercept_unsupported to true for tdx guests.
https://lore.kernel.org/kvm/20241105062408.3533704-41-xiaoyao.li@intel.com/

And it seems that the level_trigger_unsupported info will be passed to guest
via ACPI table. I didn't dig deep into it, I suppose with the information,
guests will not send level-triggered GSI interrupts?


