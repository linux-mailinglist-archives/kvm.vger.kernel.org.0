Return-Path: <kvm+bounces-9962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0787A868016
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 393A81C21A7C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C452912F39F;
	Mon, 26 Feb 2024 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kGrLDHPE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F62E12C815;
	Mon, 26 Feb 2024 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973583; cv=none; b=mv7Oa39e0x5gEfxg7SAyEaijyokLBmO4P68EvgjM7zhmRl/GsdX35j4DE/a4GQp1SC6J/D6LcYuEb4KcUBQ7EeU65g8hWqvuD5PpLpwZdalm1zVRMKJ1bOhQlmLx9Z4GVfOKgOQKkwtRvI93f9NOBdHglFQsMM9dB8463KxD3P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973583; c=relaxed/simple;
	bh=TQGEDSxegQC2Btgob0OA36fZXfP0iz4CRPI3r14mRR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsDaRDmc2BMo+wZ18HTEQOuQLzcwlvVDmNJnyKuyXUEUHpBlsmYVVbBQdVaSM7M7q5gkZv6BFIva8RLhgz3e+whj/XNTWOLTvQ0KKONWrgEElWQAMc8DXpGo1oCLoDZD4CwrZm/TSfz2UILOxoKsk4XcphWvAiNmFngPytP19RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kGrLDHPE; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973581; x=1740509581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TQGEDSxegQC2Btgob0OA36fZXfP0iz4CRPI3r14mRR0=;
  b=kGrLDHPEp4cTflXAncxJWmLPLQghpIsp7BG0xInTzahLJyl8isQw6/fl
   qLd4ON661O1bh4Q9AbuhDEg+pY1Y6dDByrmPhDqdmkEemR5+qGm7Z0qgC
   iKkx5F0FUTlpkiM1pLmPniMJFQzfviRsyAH0mJxK2Ftr/nBzETlw6E6j1
   cx/6JnlyXqssRSM7liTJVM2b37DqdFa/ML6gTWyq3+bdY4K/8TB9ql+yy
   zQtiAa/ytFm+HJmfiG9HQT+AQ9U0rRf4VP93NHjcVwccrWChiGXncrPBO
   mPjuDkA2e5bMQNre3flMB4rQ6jfENtITe3ChIkJ0dwksunLnCK24rJO+U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="7104712"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7104712"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:53:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6789615"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:53:00 -0800
Date: Mon, 26 Feb 2024 10:52:59 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 023/121] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240226185259.GI177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
 <7cc28677-f7d1-4aba-8557-66c685115074@linux.intel.com>
 <20240201061622.hvun7amakvbplmsb@yy-desk-7060>
 <33ef0842-f91f-4c70-821c-0fa41b1d5e6e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <33ef0842-f91f-4c70-821c-0fa41b1d5e6e@linux.intel.com>

On Sun, Feb 04, 2024 at 10:00:45AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/1/2024 2:16 PM, Yuan Yao wrote:
> > On Wed, Jan 24, 2024 at 09:17:15AM +0800, Binbin Wu wrote:
> > > 
> > > On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > TDX has its own limitation on the maximum number of vcpus that the guest
> > > > can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> > > > handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> > > > e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
> > > For legacy VM, KVM just provides the interface to query the max_vcpus.
> > > Why TD needs to provide a interface for userspace to set the limitation?
> > > What's the scenario?
> > I think the reason is TDH.MNG.INIT needs it:
> > 
> > TD_PARAMS:
> >      MAX_VCPUS:
> >          offset: 16 bytes.
> >          type: Unsigned 16b Integer.
> >          size: 2.
> >          Description: Maximum number of VCPUs.
> Thanks for explanation.
> 
> I am also wondering if this info can be passed via KVM_TDX_INIT_VM.
> Because userspace is allowed to set the value no greater than
> min(KVM_MAX_VCPUS, TDX_MAX_VCPUS), providing the extra cap KVM_CAP_MAX_VCPUS
> doesn't make more restriction comparing to providing it in KVM_TDX_INIT_VM.

It's better for the API to be common, not specific to TDX.  Also I don't want
to play with max_vcpu in multiple places.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

