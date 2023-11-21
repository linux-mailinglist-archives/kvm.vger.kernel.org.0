Return-Path: <kvm+bounces-2169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 877C17F29AE
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4218328223F
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 10:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3F03C6AD;
	Tue, 21 Nov 2023 10:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdEJoy7B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA3112C;
	Tue, 21 Nov 2023 02:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700560962; x=1732096962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P53K9nuYns+G3kNjOrAT6WDUrhQtdzcmrGZfrt36JG4=;
  b=DdEJoy7BLQPpraGlwMaUlxhU1r6bCQ+xy5OyfH5s8HAqzTuMS8gJHs4T
   M6B4MEHBaSU+DE+fxq3qmtd3QewOPZT/lcmtwo+xx732vMRvvn5krhrNK
   lRTLE06kiFRZRS4IY8wSfoE9SNk68qutKWYuAg8uFD41wlDPIeI7jPdi4
   8UQKcFjeSzju9sNpBnnimo1qkZ4CUk20pK2K0FQoaydTiOFJ9OQp6WEDi
   4eMI1s2D81z9twojdeuRKLk7hqqWU1nOKFdXoHeXmfGYErlvyYVXuK3Dr
   D67w4NLfH35YxEqecVnCUa1uuejAn7bQqzBGx+KXh4C8wQCEEq8Q1QJcm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="371980560"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="371980560"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:02:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="8033718"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:02:42 -0800
Date: Tue, 21 Nov 2023 02:02:41 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v6 07/16] KVM: MMU: Introduce level info in PFERR code
Message-ID: <20231121100241.GE1109547@ls.amr.corp.intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <ea9057ece714a919664e0403a3e7f774e4b3fedf.1699368363.git.isaku.yamahata@intel.com>
 <8e0934a0-c478-413a-8a58-36f7d20c23e9@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8e0934a0-c478-413a-8a58-36f7d20c23e9@linux.intel.com>

On Mon, Nov 20, 2023 at 06:54:07PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
> > And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.
> > 
> > 1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.
> > 
> >    TD geust will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
> s/geust/guest
> 
> >    4KB size.
> > 
> > 2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.
> > 
> >    KVM needs to honor it because
> >    a) there is no way to tell guest KVM maps it as 2MB size. And
> >    b) guest accepts it in 4KB size since guest knows some other 4KB page
> >       in the same 2MB range will be used as shared page.
> > 
> > For case 2, it need to pass desired page level to MMU's
> > page_fault_handler. Use bit 29:31 of kvm PF error code for this purpose.
> 
> The level info is needed not only for case 2, KVM also needs the info so
> that
> it can map a 2MB page when TD guest wants to accept a 2MB page.

"MMU's page_fault_handler" = KVM MMU page fault handler, isn't it?
I'll replace it with KVM MMU page fault handler for clarity.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

