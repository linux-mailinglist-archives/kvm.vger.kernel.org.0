Return-Path: <kvm+bounces-4778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE21818368
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FB801C239A7
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6283B11729;
	Tue, 19 Dec 2023 08:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T1hwVZ7i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE871170E
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 08:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974880; x=1734510880;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/AJflqguvggkoDJdxkTmATsGoNer2Ix95dY9Xi+Jc2U=;
  b=T1hwVZ7i/2ROWv4OCMkr9oH3Rh6QbaUHXuz1rE03uo+Gev9XnZ14Ylle
   mwCHP/R+pg1ikzTTVJ0QTRdz4orDsP1ohlxg9Dvnor5/u14UYNyhk6YOM
   Z8b7XrrKdnGkYyfAc6XjvXMITcUGt6yXVKMDPTzYHoYpxj1euhNXb+eI8
   Y9EuiCUGZatrY13u5soqrn1ax0Za7aX/XuWp6D5xYwNN+BOLTnvRdifYi
   6MSHdd/AxqVo4/LbBfg3duYqsSII83IHRdSz0Nd77ULkDgWr4YWVUmNlg
   D7Fw/QYjvmUHaI9vvgYFgp/usGVM0nKswD1pRle1fhaynXS89fgOk8ylG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="459968865"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="459968865"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="919562023"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="919562023"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:36 -0800
Date: Tue, 19 Dec 2023 16:31:29 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com,
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZYFU4WjjQykG5CIq@linux.bj.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYBhl200jZpWDqpU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYBhl200jZpWDqpU@google.com>

On Mon, Dec 18, 2023 at 07:13:27AM -0800, Sean Christopherson wrote:
> On Mon, Dec 18, 2023, Tao Su wrote:
> > When host doesn't support 5-level EPT, bits 51:48 of the guest physical
> > address must all be zero, otherwise an EPT violation always occurs and
> > current handler can't resolve this if the gpa is in RAM region. Hence,
> > instruction will keep being executed repeatedly, which causes infinite
> > EPT violation.
> > 
> > Six KVM selftests are timeout due to this issue:
> >     kvm:access_tracking_perf_test
> >     kvm:demand_paging_test
> >     kvm:dirty_log_test
> >     kvm:dirty_log_perf_test
> >     kvm:kvm_page_table_test
> >     kvm:memslot_modification_stress_test
> > 
> > The above selftests add a RAM region close to max_gfn, if host has 52
> > physical bits but doesn't support 5-level EPT, these will trigger infinite
> > EPT violation when access the RAM region.
> > 
> > Since current Intel CPUID doesn't report max guest physical bits like AMD,
> > introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when tdp is
> > enabled and report the max guest physical bits which is smaller than host.
> > 
> > When guest physical bits is smaller than host, some GPA are illegal from
> > guest's perspective, but are still legal from hardware's perspective,
> > which should be trapped to inject #PF. Current KVM already has a parameter
> > allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
> > host.MAXPHYADDR, which is disabled by default when EPT is enabled, user
> > can enable it when loading kvm-intel module. When allow_smaller_maxphyaddr
> > is enabled and guest accesses an illegal address from guest's perspective,
> > KVM will utilize EPT violation and emulate the instruction to inject #PF
> > and determine #PF error code.
> 
> No, fix the selftests, it's not KVM's responsibility to advertise the correct
> guest.MAXPHYADDR.

This patch is not for fixing these selftests, it is for fixing the issue
exposed by the selftests. KVM has responsibility to report a correct
guest.MAXPHYADDR, which lets userspace set a valid physical bits to KVM.

Actually, KVM will stuck in a loop if it tries to build spte with any bit
of bits[51:48] set, e.g., assign a huge RAM to guest.

Thanks,
Tao


