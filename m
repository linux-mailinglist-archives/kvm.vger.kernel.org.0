Return-Path: <kvm+bounces-1903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FBA7EEA65
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94FF91F259FF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8ECE65E;
	Fri, 17 Nov 2023 00:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mXwyctlT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ACE84;
	Thu, 16 Nov 2023 16:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700181411; x=1731717411;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NyaWUSiuZWIT4oMhTPN14kt5/T3qigWrUT/3PxoD7Uk=;
  b=mXwyctlT197jUHAWmiey7MFuL3DlKUlRv5aCVd0YnaX9Ij1jPe8Dc04P
   j6VJZqfWme5dtY1EeLk54QUPcCLXfjkj2/Pd2/Wuf5fy2YRWqiLNCPGeQ
   +EurMgGygCZ77fcQbkFj/T3mGAsP8xi191BC6Tll/R5x8/isbxtlPhAlW
   kz+GWOu5HMfFwswivQxI5Qj/0jRVYd6sclFsPlvQbj7MZmnnaPKZwza9K
   K71M983f4dtgdi7wgpFVb09wj+863DA56x3aNV+j4EYOTE/OVWGJ/1rdC
   3T8KpZd+399FRKSab53FuVTYcWpLf1suY5go0r70USsrtwlvKDCMr1J8U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="371388770"
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="371388770"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:36:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="6696756"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:36:50 -0800
Date: Thu, 16 Nov 2023 16:36:49 -0800
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
Subject: Re: [PATCH v6 04/16] KVM: TDX: Pass size to tdx_measure_page()
Message-ID: <20231117003649.GD1277973@ls.amr.corp.intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <7b024367db5909ffc22e6762acd0569c3a82ccd3.1699368363.git.isaku.yamahata@intel.com>
 <00b167fa-6635-47a4-a219-1f4117fe6c97@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00b167fa-6635-47a4-a219-1f4117fe6c97@linux.intel.com>

On Thu, Nov 16, 2023 at 04:57:26PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Extend tdx_measure_page() to pass size info so that it can measure
> > large page as well.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 2d5c86e06c5f..a728175c4a6d 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1434,13 +1434,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> >   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> >   }
> > -static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
> > +static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
> IMHO, it's better to pass kvm page level instead of size here to align with
> other APIs.
> 
> >   {
> >   	struct tdx_module_args out;
> >   	u64 err;
> >   	int i;
> > -	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> > +	WARN_ON_ONCE(size % TDX_EXTENDMR_CHUNKSIZE);
> 
> If passed level instead of size, then no need to check KVM_HPAGE_SIZE(level)
> against TDX_EXTENDMR_CHUNKSIZE
> 
> But same qeustion, tdx_measure_page() is only for tdh_mem_page_add(), is
> this
> change necessary?

You're right. As tdx_mem_page_add() is the only caller of tdx_measure_page(),
open-code it into tdx_mem_page_add() and drop this patch.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

