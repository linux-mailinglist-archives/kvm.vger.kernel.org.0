Return-Path: <kvm+bounces-48696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA65AD0B06
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 04:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6778F1891D95
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 02:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1A6258CC2;
	Sat,  7 Jun 2025 02:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TV8RzDJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15FB67A;
	Sat,  7 Jun 2025 02:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749264744; cv=none; b=NOAINh0+zm3EqnNygeWFXpVoQ6Au0hhfo4OCBQxwMat9IX/z5fdW9HBTF/D8UoPodNmew9ESFjcPdcn2Iq8g0E2PSoezsobu7vquWQFLZEFdWm6AdrESrQqWZdZgW9xua4FOwphRX9x1kuUU9HMImj1PEOHU3VkwbEVwsMuPiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749264744; c=relaxed/simple;
	bh=lQczlWJS0+1NAZxns2cnXt/wYRNUS+DRnMlnKt4NP/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CV4RDTEowBYEW3v11YZxsAFm2ltwj/YeCz7aVVdOygLz4ABwsZqWyUz+uM49bLpEI+SNFB+fSgZZ4gsaRxircMNtXiJDhBQ0tetNLINjrTQOU8SIYl4ROSwogOoOUCOnjgfhyE0YDdHr1ZGyOYTCycfgdk/cuRson5JMmCRpcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TV8RzDJQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749264742; x=1780800742;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lQczlWJS0+1NAZxns2cnXt/wYRNUS+DRnMlnKt4NP/4=;
  b=TV8RzDJQ340iPIoHV+hyNsEZHAjMxJWn3dGXX3vzWidRwG0mfoL1gBFj
   DPp/LLLLB813U8af2WwTo8XOClFtyZz7n4yfuxXr3sbA16bzV0zDajRBy
   43DGCAltBPDb41YAOMjZbdPnG/VwMCMO5srllky2N/zzoov5vQsBYBFk3
   elCX6NdsUCmGV/eSSurUitfWKUCFUlVeqntfxXh8WIXKXuvy/6wpItqrb
   e4D9LAGShqMbKo1eEC094WtILQCbZmI4k9UVxy22DkOUyR329499toDkZ
   geTWeBJ3zRpmQvK9/+R+iLwPxVg75AJAcvGyzVEmxE0qlP5S9LPqVLRW3
   A==;
X-CSE-ConnectionGUID: /lrELgg6Sp6a+pdYU+UAwg==
X-CSE-MsgGUID: fpuMhVQyRry/SuDzriOlxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="54048502"
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="54048502"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 19:52:21 -0700
X-CSE-ConnectionGUID: VSFEqLOzTAmgepYM6LBEAw==
X-CSE-MsgGUID: 8ePsBAY2QteDMGxVdeglug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="176933155"
Received: from mmercado-mobl6.amr.corp.intel.com (HELO desk) ([10.125.146.40])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 19:52:21 -0700
Date: Fri, 6 Jun 2025 19:52:13 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Fix MMIO Stale Data Mitigation
Message-ID: <20250607025213.o226wig3qtt5spv2@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
 <20250529033546.dhf3ittxsc3qcysc@desk>
 <aD42rwMoJ0gh5VBy@google.com>
 <20250603012208.cadagk7rgwy24gkh@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603012208.cadagk7rgwy24gkh@desk>

On Mon, Jun 02, 2025 at 06:22:08PM -0700, Pawan Gupta wrote:
> On Mon, Jun 02, 2025 at 04:41:35PM -0700, Sean Christopherson wrote:
> > > Regarding validating this, if VERW is executed at VMenter, mitigation was
> > > found to be effective. This is similar to other bugs like MDS. I am not a
> > > virtualization expert, but I will try to validate whatever I can.
> > 
> > If you can re-verify the mitigation works for VFIO devices, that's more than
> > good enough for me.  The bar at this point is to not regress the existing mitigation,
> > anything beyond that is gravy.
> 
> Ok sure. I'll verify that VERW is getting executed for VFIO devices.

I have verified that with below patches CPU buffer clearing for MMIO Stale
Data is working as expected for VFIO device.

  KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest
  KVM: x86/mmu: Locally cache whether a PFN is host MMIO when making a SPTE
  KVM: x86: Avoid calling kvm_is_mmio_pfn() when kvm_x86_ops.get_mt_mask is NULL

For the above patches:

Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Below are excerpts from the logs with debug prints added:

# virsh start ubuntu24.04                                                      <------ Guest launched
[ 5737.281649] virbr0: port 1(vnet1) entered blocking state
[ 5737.281659] virbr0: port 1(vnet1) entered disabled state
[ 5737.281686] vnet1: entered allmulticast mode
[ 5737.281775] vnet1: entered promiscuous mode
[ 5737.282026] virbr0: port 1(vnet1) entered blocking state
[ 5737.282032] virbr0: port 1(vnet1) entered listening state
[ 5737.775162] vmx_vcpu_enter_exit: 13085 callbacks suppressed
[ 5737.775169] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO  <----- Buffers not cleared
[ 5737.775192] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO
[ 5737.775203] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO
...
Domain 'ubuntu24.04' started

[ 5739.323529] virbr0: port 1(vnet1) entered learning state
[ 5741.372527] virbr0: port 1(vnet1) entered forwarding state
[ 5741.372540] virbr0: topology change detected, propagating
[ 5742.906218] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO
[ 5742.906232] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO
[ 5742.906234] kvm_intel: vmx_vcpu_enter_exit: CPU buffer NOT cleared for MMIO
[ 5747.906515] vmx_vcpu_enter_exit: 267825 callbacks suppressed
...

# virsh attach-device ubuntu24.04 vfio.xml  --live                            <----- Device attached

[ 5749.913996] ioatdma 0000:00:01.1: Removing dma and dca services
[ 5750.786112] vfio-pci 0000:00:01.1: resetting
[ 5750.891646] vfio-pci 0000:00:01.1: reset done
[ 5750.900521] vfio-pci 0000:00:01.1: resetting
[ 5751.003645] vfio-pci 0000:00:01.1: reset done
Device attached successfully
[ 5751.074292] kvm_intel: vmx_vcpu_enter_exit: CPU buffer cleared for MMIO    <----- Buffers getting cleared
[ 5751.074293] kvm_intel: vmx_vcpu_enter_exit: CPU buffer cleared for MMIO
[ 5751.074294] kvm_intel: vmx_vcpu_enter_exit: CPU buffer cleared for MMIO
[ 5756.076427] vmx_vcpu_enter_exit: 68991 callbacks suppressed

