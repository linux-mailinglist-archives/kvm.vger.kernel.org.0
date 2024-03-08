Return-Path: <kvm+bounces-11341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32521875BC6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 02:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6048C1C2097C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE7E219F0;
	Fri,  8 Mar 2024 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyCkon8j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C911C21103;
	Fri,  8 Mar 2024 01:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709860070; cv=none; b=hPXEW1z8LTCQ558indHS9GOTZrrYEWU7GkyFbn27ws13t0pm3vvePiVXyNcOw8lcBAjWdY7Do+vQVGvq5TiaF8uYsgMqSyCDpVXblF1i4sC1FQ+viGxYDeoATkCNntvOfDD1WCHJua/yPZ1p3zngvDk0kWv3HjcUZ0KVKh01HBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709860070; c=relaxed/simple;
	bh=0R9xuIBQcNVdlIuQa7+jPBg5UvVbDCYySe1bOSH30pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fn3peP1vfzobjyeGJhwC/CpdJx6H2EOaiUQe0cf8MNLg/JdECQknbHfU9Hy2AZ8Z/OOnxqo7D8vpmn/jNEk7pKnCFiu87k+VRTB1diHJkGJl8zpm8JHtIGgdLsBsMcDjSXfaNmWKCpAVJXcW8dVUhZMszB0SUmyE1wwU9vNL/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyCkon8j; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709860069; x=1741396069;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0R9xuIBQcNVdlIuQa7+jPBg5UvVbDCYySe1bOSH30pM=;
  b=KyCkon8jl2Tnxti35WQ0+LPCz6XEK/Ppf1ZI8i3bjw7iyUomJO56zAcB
   1St6uLa9CdtGmmgXvl67mnv4SqBeroj/CS2/NQp3G/P7V8/Tpetjj0uVu
   zv84jRKlNrzv+Jes9bVF5MTu2jSgr0WhOYBNagKZaDxWeyRif0Zk9ugp0
   40O4Mj4/qcky6aajc8TXnXGzRzqntCsrk5nPvssjfmMfFryAVPU+42kOv
   uTyEz6odQBoj3RF2rHlDBXyd5SU8B+k8p15mdr92WBierzup+AdpDcsf3
   EBoePHNl5v4BhzFYgAd+Z3CK+IgWBcQJq3RDeS+ljj8t92YpPYMQYgFV8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="15134791"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15134791"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 17:07:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14795366"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 17:07:42 -0800
Date: Thu, 7 Mar 2024 17:07:42 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Matlack <dmatlack@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com, gkirkpatrick@google.com,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
Message-ID: <20240308010742.GK368614@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
 <Zbrj5WKVgMsUFDtb@google.com>
 <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>
 <20240226180712.GF177224@ls.amr.corp.intel.com>
 <Zdzdj6zcDqQJcrNx@google.com>
 <20240227141242.GT177224@ls.amr.corp.intel.com>
 <Zd4cIxZPABFlt-sE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zd4cIxZPABFlt-sE@google.com>

On Tue, Feb 27, 2024 at 09:30:11AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Feb 27, 2024, Isaku Yamahata wrote:
> > On Mon, Feb 26, 2024 at 10:50:55AM -0800,
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > Please post an RFC for _just_ this functionality, and follow-up in existing,
> > > pre-v19 conversations for anything else that changed between v18 and v19 and might
> > > need additional input/discussion.
> > 
> > Sure, will post it. My plan is as follow for input/discussion
> > - Review SEV-SNP patches by Paolo for commonality 
> > - RFC patch to KVM_MAP_MEMORY or KVM_FAULTIN_MEMORY
> > - RFC patch for uKVM for confidential VM
> 
> uKVM?

I meant uAPI, sorry for typo.
Although I looked into a unified uAPI with SEV, the gain seem to be small or
none. I'm currently planning to drop it based on the feedback at
https://lore.kernel.org/kvm/ZL%2Fr6Vca8WkFVaic@google.com/
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

