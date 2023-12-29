Return-Path: <kvm+bounces-5318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FA381FD08
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 05:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15E6A1F241D3
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 04:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0B523B4;
	Fri, 29 Dec 2023 04:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EScdZdXm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2E71FA8;
	Fri, 29 Dec 2023 04:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703824886; x=1735360886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dgfYqpicR7jhKma9kepYU0N3HnbYpIvRMXuoY3TARXw=;
  b=EScdZdXmiTxHUbubZ+2JvO2hVcly+UBV34F7d0ws0GrDcO2dvQ/zgP9N
   rhBeBZwnkXsLE1z7ywyhTBU6xPDw0rRsEK1rL5CGZYs7+js8PeF+X4sf4
   cNSj9CWXaJgf4hpBtXCuSr0055lWcsrxrqgcIGcLNZiAeap7LD9B3mE51
   F4tddgqxBex62HvqwT3zTnI/XzkXtgy9CpK2GvojvR34ADBDXu2dO9tsp
   WA+r9JmqDegNmxDvLIiZ7InV/K2/+SE01JONL2CXKGWK+PJWg9UnXnC9I
   PsXCeSMU2VbkiJlovBZcaJLKs8IQyXMMjDekzvDG8C4BeXUaMIhLaQRII
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="376102601"
X-IronPort-AV: E=Sophos;i="6.04,314,1695711600"; 
   d="scan'208";a="376102601"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 20:41:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="771878830"
X-IronPort-AV: E=Sophos;i="6.04,314,1695711600"; 
   d="scan'208";a="771878830"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 20:41:22 -0800
Message-ID: <a22047ed-22e2-4b7f-9a61-16e9f77f3ba2@intel.com>
Date: Fri, 29 Dec 2023 12:41:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@gmail.com
References: <cover.1702974319.git.isaku.yamahata@intel.com>
 <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/2023 4:34 PM, Isaku Yamahata wrote:
> +7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL
> +--------------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is the value of apic bus clock frequency
> +:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
> +          frequency, or -ENXIO if virtual local APIC isn't enabled by
> +          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.
> +
> +This capability sets the APIC bus clock frequency (or core crystal clock
> +frequency) for kvm to emulate APIC in the kernel.  

Isaku,

you are mixing the `bus clock` and `core crystal clock` frequency. They 
are different.

- When CPUID 0x15 doesn't exist, or CPUID 0x15 doesn't enumerate core 
crystal clock frequency, the APIC timer frequency is the processor's bus 
clock.

- When CPUID 0x15 does enumerate the core crystal clock frequency, the 
APIC timer frequency is the core crystal clock frequency.

This patch only enables the user-configurable bus clock frequency, or 
specifically APIC timer frequency. It doesn't enable the configuration 
of core crystal clock frequency. Userspace can configure core crystal 
clock frequency by passing a valid CPUID 0x15 leaf into KVM_SET_CPUID2, 
not by this KVM_CAP.

> The default value is 1000000
> +(1GHz).


