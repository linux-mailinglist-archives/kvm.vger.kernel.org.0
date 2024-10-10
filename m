Return-Path: <kvm+bounces-28410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DBE9982CA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DDE21C21363
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264AF1C1758;
	Thu, 10 Oct 2024 09:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fjtd1GYd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2901BD4FD;
	Thu, 10 Oct 2024 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728553764; cv=none; b=uIMFI0uZHP0zv5OKlgl40ExHJgv1tH69zpuGshsDniI7oht2zHMIoKGld+t2scVZ4liNV+Yc1hN5jIOY0Z6LTbhT72GOJENBrrUsiT4LtYQz/J+2A2h50Pj50dKlm81BGociWchvXMSVyL+jgRu+ri8xOyf1J6L3lAYBvO9XQoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728553764; c=relaxed/simple;
	bh=YKwBaNRBcMS2JUEZSf0dCWw9etVXQcaFKd1Ay07y9YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGs0bMr5Cd3IQXV6x1QyUfsEbQAHVqkU9htzIELyiip6hwLlMnDDSktgdCNCI7as/IZ2ynF5uyjbyH/EXv5jmIaWgWRnUayyxKitIflKFV6xGWD2j+krOxOXtnPBcSt829tdc6wYEk0894Vf/nY/7LDXIh/QTFIlZ9ft+lLBV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fjtd1GYd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728553763; x=1760089763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YKwBaNRBcMS2JUEZSf0dCWw9etVXQcaFKd1Ay07y9YE=;
  b=Fjtd1GYd0eXRGZuwRmoGN6G/tf3emSx9JrrNmvs+oU15gK18Lb1IwPMu
   ks2AcMgXze4I6Ro+MEusQHZDELT78GN9jh0pAtu3jpGVFS+nYbdac9P0n
   4Z2ALKnusmdFuHO94LhnSued7bGs0EMj9BvZdvrNko+EXLjaYke2laBvq
   R1qEwxMHCO4ASpBTapmkxqBOrr6queaXkdVsvtdpBHZt9+tL2vBwVKVji
   VjmQu9pwqm9G93ayUW2e9G6In6TqGR4hJ4EDIujxXvkeZaK990//fL3W8
   RbwE29OaKwkTvEub6hErKRpTGDdUtZZ9A4F/zkDH/UwBTgalP4AAktc5I
   A==;
X-CSE-ConnectionGUID: +lAWoJ5pRg+ZpSA4LWyj/w==
X-CSE-MsgGUID: u4JlRoVbQ1uJm3Jz/0uL+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="39265377"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="39265377"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 02:49:22 -0700
X-CSE-ConnectionGUID: WTr7bdOISeOZ2Up/vEvgNQ==
X-CSE-MsgGUID: EH9vSkLlSRm8b9lQnQPmQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="81538325"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.114])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 02:49:18 -0700
Date: Thu, 10 Oct 2024 12:49:11 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZwejF11FxumXLFFr@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
 <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
 <b3a46758-b0ac-4136-934b-ec38fc845eeb@redhat.com>
 <ZuFPBPLy9MqgTsR1@tlindgre-MOBL1>
 <3275645a-ffd9-4dd4-bfa4-037186a989ae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3275645a-ffd9-4dd4-bfa4-037186a989ae@intel.com>

On Thu, Oct 10, 2024 at 04:25:30PM +0800, Xiaoyao Li wrote:
> On 9/11/2024 7:04 PM, Tony Lindgren wrote:
> > On Tue, Sep 10, 2024 at 07:15:12PM +0200, Paolo Bonzini wrote:
> > > On 8/29/24 06:51, Tony Lindgren wrote:
> > > > > nit: Since there are other similarly named functions that come later how
> > > > > about rename this to init_kvm_tdx_caps, so that it's clear that the
> > > > > functions that are executed ones are prefixed with "init_" and those that
> > > > > will be executed on every TDV boot up can be named prefixed with "setup_"
> > > > We can call setup_kvm_tdx_caps() from from tdx_get_kvm_supported_cpuid(),
> > > > and drop the struct kvm_tdx_caps. So then the setup_kvm_tdx_caps() should
> > > > be OK.
> > > 
> > > I don't understand this suggestion since tdx_get_capabilities() also needs
> > > kvm_tdx_caps.  I think the code is okay as it is with just the rename that
> > > Nik suggested (there are already some setup_*() functions in KVM but for
> > > example setup_vmcs_config() is called from hardware_setup()).
> > 
> > Oh sorry for the confusion, looks like I pasted the function names wrong
> > way around above and left out where setup_kvm_tdx_caps() can be called
> > from.
> > 
> > I meant only tdx_get_capabilities() needs to call setup_kvm_tdx_caps().
> > And setup_kvm_tdx_caps() calls tdx_get_kvm_supported_cpuid().
> > 
> > The data in kvm_tdx_caps is only needed for tdx_get_capabilities(). It can
> > be generated from the data already in td_conf.
> > 
> > At least that's what it looks like to me, but maybe I'm missing something.
> 
> kvm_tdx_caps is setup in __tdx_bringup() because it also serves the purpose
> to validate the KVM's capabilities against the specific TDX module. If KVM
> and TDX module are incompatible, it needs to fail the bring up of TDX in
> KVM. It's too late to validate it when KVM_TDX_CAPABILITIES issued.  E.g.,
> if the TDX module reports some fixed-1 attribute bit while KVM isn't aware
> of, in such case KVM needs to set enable_tdx to 0 to reflect that TDX cannot
> be enabled/brought up.

OK makes sense, thanks for clarifying the use case for __tdx_bringup().

We can check the attributes_fixed1 and xfam_fixed1 also on __tdx_bringup()
no problem.

Regards,

Tony

