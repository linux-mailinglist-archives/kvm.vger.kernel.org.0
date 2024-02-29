Return-Path: <kvm+bounces-10502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2895886CAC2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEA411F21E3E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E4212CDB5;
	Thu, 29 Feb 2024 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJmgoJRS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB362127B5B;
	Thu, 29 Feb 2024 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709214914; cv=none; b=RJdCp5RqPKH7EtS8KF57yOqN5JglBS7yzrma7Fr9dRZ5Mzi2i1AqnPMGcf/sFLsiqlyb4zQgTMVpL4jIyELicJommQ9flMVZiXUMCKIWg+2a5txU6INRXlH+oq8Q3GMLzQaKmxccPb0rsedTmBQbyMQ/8KVubxZ51m2NTRRJvi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709214914; c=relaxed/simple;
	bh=LeS/h5krYSbncffIIacMEIdRyxkd65pv7/uGwUBWSjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hY8EIS/aTDMgfTu2uZAsg4L1TT1NXI/z6BWy9/yL9jdsjWO5/h3DGGRwspS5gjAJ/uAQJrQEPhe/Izxog/wNyzk0RboklZ/W4ZHP2pC1SlauUd8FLK7cb7R/hOaRmFWLCCo/O3ucw3PEDEy/khDm+8o7rPYFg89L3L/n6k6tSmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJmgoJRS; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709214913; x=1740750913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LeS/h5krYSbncffIIacMEIdRyxkd65pv7/uGwUBWSjE=;
  b=OJmgoJRSdmWr2kCDGGSzrueLIPF3KNd8LA+tcPXgeNY3xdFJR7VL6Q//
   D/PXEi8TeLmSNQ2RLkrkWUfSVkpvum83jKXPRrfeBdqp6l7zH86wyZKr6
   +9WF0N2G+cyNTrMcQiLwexQjOMllz8DawFtL1vjcnaJhL1RaMN5pm2zZR
   g9cbVn8Uh+RcAn6tLTXU9I22tV7qK8SYPulTWqxC7scTpYtqV1H1tkGQw
   pnWQs0Hqs2I3rr6r2p5SIRH4cbDimXG3WbJWbuHUC3z0izgxLhgIMsbyd
   wKqR79YW6kYcMvI0+RR3b1YcG2uiLqifces3ZwdTwzWz1Fmy7uEVwXX8p
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3528662"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3528662"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7705704"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 05:55:09 -0800
Message-ID: <5ac647f6-84aa-40e5-8d67-112e38a48382@intel.com>
Date: Thu, 29 Feb 2024 21:55:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/21] KVM: x86/mmu: Allow non-zero value for non-present
 SPTE and removed SPTE
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com, Binbin Wu <binbin.wu@linux.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-5-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
> is not able to access the private memory of TD guest and do the emulation.
> Instead, TD guest expects to receive #VE when it accesses the MMIO and then
> it can explicitly make hypercall to KVM to get the expected information.
> 
> To achieve this, the TDX module always enables "EPT-violation #VE" in the
> VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
> 1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
> violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
> sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
> the #VE instead of EPT misconfiguration unlike VMX case.  For the shared GPA
> that is not populated yet, EPT violation need to be triggered when TD guest
> accesses such shared GPA.  The non-present SPTE value for shared GPA should
> set "suppress #VE" bit.
> 
> Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
> REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
> for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
> present bit is off; 2) for normal VMX guest, KVM never enables the
> "EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
> hardware.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Message-Id: <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

+ 1 to the nit pointed by Yilun,

after that,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


