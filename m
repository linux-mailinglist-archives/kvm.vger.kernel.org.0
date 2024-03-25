Return-Path: <kvm+bounces-12618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89CC388B2C6
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28A901FA2947
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B976EB5B;
	Mon, 25 Mar 2024 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GaHsfH4d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803BF17579;
	Mon, 25 Mar 2024 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402192; cv=none; b=VxLDKC5qlVAfQ0QbxIb/WyjmLuzSbrno7+zzE7h9KzjKFBrZ7j/6lSdMS8WYxRhRn89m3dhyGqHbpOpEXsfrvGjTyNqwmFSUbnBhD4atlm003TqPh1ISJxr4KqidnGGUkjnqDIaDEBXeGdQxQXvHZX8iDtYMkRhEoQX9VsAfQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402192; c=relaxed/simple;
	bh=nCPzrrqVkGAk193TG/GOsmAWn7X4cHwfNIfJbvfkbpI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDirP086plW3QcvmnXh0AePgfcn/EU0oypBvJsUXzUCdYfS1OUu7sNjlINmIvd6EhLNCrjVT2uC75GAcT3z3YnwX68a1Uncc7JRYx5kaxuyK8TzGheojsjTbq+I1Thl4Du4lXvq1gLFlcLR3PD9UQmOeUFSdrXE/lRyPIbU6GYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GaHsfH4d; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711402191; x=1742938191;
  h=from:date:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nCPzrrqVkGAk193TG/GOsmAWn7X4cHwfNIfJbvfkbpI=;
  b=GaHsfH4d2NARuwTOLUxNWc8ZoBd8kMRpobAYufkXqsA47q+RqGgRfxAt
   krxm5XjrnFFzSAhT2pWti5jZNKB9ZCW0v9JlxqwdOzgiILQLu/soifqhU
   tKt34bWbY8SeDdOsndx3stNd7XBWROoLPRQfy/m6rDkcbwr6/XWfhMan+
   cpQSsfJw7HvvUy6wYYqoBOwBcUm9ugH0Bf4ao7LNvcoPa5BrheoAwxxbe
   LuvFbcL7fwWm2Y09Z/50jHD7s7NhAMxobCPC32E5ZUbSDGiTHWC/2UwEs
   bKZDQEUGPtFbG714LMRjFxOXh/XkkZG9jnRVMvLqHNhj+6NR7Y0otjv9b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17862724"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="17862724"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:29:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="53209913"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:29:50 -0700
From: isaku.yamahata@intel.com
Date: Mon, 25 Mar 2024 14:29:49 -0700
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240325212949.GK2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
 <20240323011335.GC2357401@ls.amr.corp.intel.com>
 <d4014bb8-168e-4147-9554-bab22b0f4afe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d4014bb8-168e-4147-9554-bab22b0f4afe@intel.com>
rom: Isaku Yamahata <isaku.yamahata@intel.com>

On Mon, Mar 25, 2024 at 09:43:31PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > > Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but doesn't
> > > allow to enable KVM_CAP_MAX_VCPUS to configure the number of maximum vcpus
> >                                                       maximum number of vcpus
> > > on VM-basis.
> > > 
> > > Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.
> > > 
> > > The userspace-configured value then can be verified when KVM is actually
> >                                               used
> > > creating the TDX guest.
> > > "
> 
> I think we still have two options regarding to how 'max_vcpus' is handled in
> ioctl() to do TDH.MNG.INIT:
> 
> 1) Just use the 'max_vcpus' done in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS),
> 2) Still pass the 'max_vcpus' as input, but KVM verifies it against the
> value that is saved in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS).
> 
> 2) seems unnecessary, so I don't have objection to use 1).  But it seems we
> could still mention it in the changelog in that patch?

Sure, let me update the commit log.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

