Return-Path: <kvm+bounces-48037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0985FAC8513
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C96854E4A24
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D9F2586C8;
	Thu, 29 May 2025 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQWi7Skc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818D9230BFF;
	Thu, 29 May 2025 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562022; cv=none; b=t/Whc6LcRiPcgteFcMfuCdZFRHlii8uR94PPxrGeuPVc6RUoAKWd13SS295RKIVQ18YfIG34qM66c87av+kUIj8wj99jreC44x+LZnYxAThF6+TKPdZLFCJhzz0wftLT68rCKTjC55lkxL6hZUUSoCUSKeK9jvnOMdLT1r+dj/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562022; c=relaxed/simple;
	bh=yqH8SLmi/6XiYcSNKAYKUwI0eWIHT5QDJJgdXPJj83c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBbJTvrXlVrNW+P4elGStAvkpmC49kDRmy1OnLNcOxBsmHDJTM43gvYy8/WmvypfBo0R4IohEpVfYiGImjGL5stoQgGNNyPVCUHSr/THdTpnTav1dibkzIcuVXXNPoX9puTF8wg7J5e+D7lTSWjCg1vodgB7NPrzEFtGjNFmsnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQWi7Skc; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748562020; x=1780098020;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yqH8SLmi/6XiYcSNKAYKUwI0eWIHT5QDJJgdXPJj83c=;
  b=kQWi7SkctHwBDByLod4E0tRgm40CzP9pQ5oggwNf2oZ6KM3oWjzUQwfC
   /uNpnl5QmkZX5o/t5pbUCrnn7D92ZULUCG/IUPeb9Q6klafIR1bN+NpOd
   +ilNlkFoVhDoP+U92lAwtSyteo0Q7uIKp/8pOwZyN77Tf2YoivLwQBlsA
   UbwBzF6cXipwqSdfo/FwFJ5pneAGEEgkb0u75dIc1phamEiL5rJi8AkMI
   pWdxtzFAyDwU/kB9J2oKq3zh8Abx/MM+qiFbuS4K4n0tH2WKcWr3OjBja
   0O4oDAbjeppHMEqpCwwEsmbqJXXqUtaRgT7yzqDqijh/AVcRPJ/Ql3hcK
   Q==;
X-CSE-ConnectionGUID: a2SNQvPaQyuXj8pNOGgH0A==
X-CSE-MsgGUID: RZs7CO2hRtSL3EJ+QjRA5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50793286"
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="50793286"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 16:40:19 -0700
X-CSE-ConnectionGUID: htUU3XhpSGm8Cxkw/0yJQw==
X-CSE-MsgGUID: 2RIZPymESWaI95yBmG/FXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="143740009"
Received: from drlynch-mobl1.amr.corp.intel.com (HELO desk) ([10.125.146.32])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 16:40:18 -0700
Date: Thu, 29 May 2025 16:40:13 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM
 maps MMIO into the guest
Message-ID: <20250529234013.fbxruxq44wpfh5w4@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
 <20250523011756.3243624-4-seanjc@google.com>
 <20250529042710.crjcc76dqpiak4pn@desk>
 <aDjdagbqcesTcnhc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDjdagbqcesTcnhc@google.com>

On Thu, May 29, 2025 at 03:19:22PM -0700, Sean Christopherson wrote:
> On Wed, May 28, 2025, Pawan Gupta wrote:
> > On Thu, May 22, 2025 at 06:17:54PM -0700, Sean Christopherson wrote:
> > > @@ -7282,7 +7288,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > >  	if (static_branch_unlikely(&vmx_l1d_should_flush))
> > >  		vmx_l1d_flush(vcpu);
> > >  	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> > > -		 kvm_arch_has_assigned_device(vcpu->kvm))
> > > +		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
> > >  		mds_clear_cpu_buffers();
> > 
> > I think this also paves way for buffer clear for MDS and MMIO to be done at
> > a single place. Please let me know if below is feasible:
> 
> It's definitely feasible (this thought crossed my mind as well), but because
> CLEAR_CPU_BUFFERS emits VERW iff X86_FEATURE_CLEAR_CPU_BUF is enabled, the below
> would do nothing for the MMIO case (either that, or I'm missing something).

Thats right, CLEAR_CPU_BUFFERS needs rework too.

> We could obviously rework CLEAR_CPU_BUFFERS, I'm just not sure that's worth the
> effort at this point.  I'm definitely not opposed to it though.

My goal with this is to have 2 separate controls for user-kernel and
guest-host. Such that MDS/TAA/RFDS gets finer controls to only enable
user-kernel or guest-host mitigation. This would play well with the Attack
vector series by David:

https://lore.kernel.org/lkml/20250509162839.3057217-1-david.kaplan@amd.com/

For now this patch is fine as is. I will send update separately including
the CLEAR_CPU_BUFFERS rework.

