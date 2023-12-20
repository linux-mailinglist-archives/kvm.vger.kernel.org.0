Return-Path: <kvm+bounces-4919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11804819E94
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 892F3B228F6
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 12:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1331B21A15;
	Wed, 20 Dec 2023 12:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjJI2GZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA75122303
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703073769; x=1734609769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=8WN+Try9xy8InKLjijV88xLitFgN3gZ5VIeX3/4PrBc=;
  b=KjJI2GZ1PaNclKA4G3x4/DQeKHRx3bwfEsscezz1i+yFLb7oD0qVXW83
   stz6pfG4sk99mYFkyVmuhnvhDibjW9t83aAwL60ud6MUhrB2kqT+unN5Y
   mWOtwH9DE0EgGF6GWnGoIcRYXQLcCuVQczr50hmItoY9qlL+N6pIAa+r/
   FkKlxHy/LQj3nl9rmkkTcuYJcFcKyZ0WdRps3IKChCXR7pO2iY6aoQLHA
   tuVGx2XCXrcFFn01IKQZs5kYbVJU42x0rUDtaVW2h0LpA8WvvAq3JIxi7
   D6xPyjonGFSF90bF97na+IJUSx+OzWAtS0rTB3rGNRRGFaLDxWTOe8rD0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="9184669"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="9184669"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 04:02:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="776316603"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="776316603"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 04:02:45 -0800
Date: Wed, 20 Dec 2023 19:59:38 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com,
	xiaoyao.li@intel.com, yuan.yao@linux.intel.com, yi1.lai@intel.com,
	xudong.hao@intel.com, chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZYLXKkd6W5L+Drw/@linux.bj.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYBhl200jZpWDqpU@google.com>
 <ZYEFGQBti5DqlJiu@chao-email>
 <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
 <ZYFPsISS9K867BU5@chao-email>
 <ZYG2CDRFlq50siec@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZYG2CDRFlq50siec@google.com>

On Tue, Dec 19, 2023 at 07:26:00AM -0800, Sean Christopherson wrote:
> On Tue, Dec 19, 2023, Chao Gao wrote:
> > On Mon, Dec 18, 2023 at 07:40:11PM -0800, Jim Mattson wrote:
> > >Honestly, I think KVM should just disable EPT if the EPT tables can't
> > >support the CPU's physical address width.
> > 
> > Yes, it is an option.
> > But I prefer to allow admin to override this (i.e., admin still can enable EPT
> > via module parameter) because those issues are not new and disabling EPT
> > doesn't prevent QEMU from launching guests w/ smaller MAXPHYADDR.
> > 
> > >> Here nothing visible to selftests or QEMU indicates that guest.MAXPHYADDR = 52
> > >> is invalid/incorrect. how can we say selftests are at fault and we should fix
> > >> them?
> > >
> > >In this case, the CPU is at fault, and you should complain to the CPU vendor.
> > 
> > Yeah, I agree with you and will check with related team inside Intel.
> 
> I agree that the CPU is being weird, but this is technically an architecturally
> legal configuration, and KVM has largely committed to supporting weird setups.
> At some point we have to draw a line when things get too ridiculous, but I don't
> think this particular oddity crosses into absurd territory.
> 
> > My point was just this isn't a selftest issue because not all information is
> > disclosed to the tests.
> 
> Ah, right, EPT capabilities are in MSRs that userspace can't read.
> 
> > And I am afraid KVM as L1 VMM may run into this situation, i.e., only 4-level
> > EPT is supported but MAXPHYADDR is 52. So, KVM needs a fix anyway.
> 
> Yes, but forcing emulation for a funky setup is not a good fix.  KVM can simply
> constrain the advertised MAXPHYADDR, no? 

GPA is controlled by guest, I.e., just install PTE in guest page table, and the
GPAs beyond 48-bits always trigger EPT violation. If KVM does nothing, guest
can’t get #PF when accessing >MAXPHYADDR, which is inconsistent with
architectural behavior. But doing nothing is also an option because userspace
doesn’t respect the reported value.

Thanks,
Tao


