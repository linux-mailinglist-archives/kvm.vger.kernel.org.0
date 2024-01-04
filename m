Return-Path: <kvm+bounces-5662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC038246E3
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 18:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42888283AE0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AF92557A;
	Thu,  4 Jan 2024 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5YIbXbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3759C25560;
	Thu,  4 Jan 2024 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704388081; x=1735924081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qPUzoILDd3+YEP2nl1nUfeLW8U963CpH72/0YjAzmlo=;
  b=l5YIbXbQgXwHC7lMnxYPVkP7JwAllc/RZILLL5Q8nkv6iKiYwMaukAdZ
   J82zTo5YUdftLlkeElG8WYjJXgqEU0Xey+i7fuOUe2Mu303mA1vLuxyuf
   sUnPgB651aEkhhZ0dHCEglNBfNZdiyp8OYcUKzx+vsfnfBF4//6hznZ7v
   QDcEoLxAoTOHTdEk3CeXi8VMKcvqsixonETBhMNdObnOFnRNQ86MAoRFf
   jh89F3RgxXtPkVsOr9F/8110Gz/KP6uDcyD4XFvryCfbv2iQy7OUaIIJT
   gxzOHYZOQkz3Fkv2NMo6JF2ekBIkeaZrpsKTqBdbEQpaauubbyfw+NS4R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4409440"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="4409440"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:07:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="780475868"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="780475868"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:07:57 -0800
Date: Thu, 4 Jan 2024 09:07:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Like Xu <like.xu@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <ZZbl7KqomDOR+HUC@tassilo>
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
 <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
 <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>
 <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>

> My (completely random) guess is that there is some rare combination
> of events that causes this code to fail.  If so, is it feasible to
> construct a test that makes this rare combination of events less rare,
> so that similar future bugs are caught more quickly?

Yes, I tested something similar before. What you need is create lots of 
PMIs with perf (running perf top should be enough) and a workload that creates
lots of exits in a guest (e.g. running fio on a virtio device). This 
will stress test this particular path.

-Andi

