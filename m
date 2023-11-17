Return-Path: <kvm+bounces-1934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C00EF7EED29
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 770A0281222
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620D7F4EE;
	Fri, 17 Nov 2023 08:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4moS8YA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AD9D79;
	Fri, 17 Nov 2023 00:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700208486; x=1731744486;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SCQzW/pW2avy9621bQzVkjK0MKBL2ErnQeaaQdJFSkY=;
  b=m4moS8YAx4IvGrCe5rfmjd1vJUMkqki9wk2/4IGtZk46VWFsMQfa3Lim
   2olJO0Jtc1+t4ws50j8d6tz6+CJDB74cFfwRJOihD7AU2DOZ3srH+PTXb
   gRSZ634oVLejtMYQmpWQd2pUnRCoXwuWSBxql4R1hpRF7w+1JMuKs2szd
   rKom9kRUHnc4GbbUHHa0EBgKf3AvmhiPb6sKL1nxOgF7AvuPRvbKYHYqY
   1fTuVv4P3Zi82dDm+uVdzk9QAQK12sPUTNzp/94zaAjtTHNpOPtMvh1uH
   b9NxsQK+oPmESHln06tAaCrUJ5trguf6l9QZFgBd0GLMTq3gfRfFiBzw2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="4343030"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="4343030"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 00:08:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="759099936"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="759099936"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 00:08:04 -0800
Date: Fri, 17 Nov 2023 00:08:04 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v17 071/116] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20231117080804.GF1277973@ls.amr.corp.intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <89926d400f0228384c9571c73208d7f1ab045fda.1699368322.git.isaku.yamahata@intel.com>
 <20231115064956.du6qjjraqkxtjuud@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115064956.du6qjjraqkxtjuud@yy-desk-7060>

On Wed, Nov 15, 2023 at 02:49:56PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Tue, Nov 07, 2023 at 06:56:37AM -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
> > and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> > call them on vcpu migration.  The logic is mostly same as VMX except the
> > TDX SEAMCALLs are used.
> >
> > When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> > each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    |  32 ++++++-
> >  arch/x86/kvm/vmx/tdx.c     | 190 ++++++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/tdx.h     |   2 +
> >  arch/x86/kvm/vmx/x86_ops.h |   4 +
> >  4 files changed, 221 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index e7c570686736..8b109d0fe764 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -44,6 +44,14 @@ static int vt_hardware_enable(void)
> >  	return ret;
> >  }
> >
> ......
> > -void tdx_mmu_release_hkid(struct kvm *kvm)
> > +static int __tdx_mmu_release_hkid(struct kvm *kvm)
> >  {
> >  	bool packages_allocated, targets_allocated;
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	cpumask_var_t packages, targets;
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long j;
> > +	int i, ret = 0;
> >  	u64 err;
> > -	int i;
> >
> >  	if (!is_hkid_assigned(kvm_tdx))
> > -		return;
> > +		return 0;
> >
> >  	if (!is_td_created(kvm_tdx)) {
> >  		tdx_hkid_free(kvm_tdx);
> > -		return;
> > +		return 0;
> >  	}
> >
> >  	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> >  	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> >  	cpus_read_lock();
> >
> > +	kvm_for_each_vcpu(j, vcpu, kvm)
> > +		tdx_flush_vp_on_cpu(vcpu);
> > +
> >  	/*
> >  	 * We can destroy multiple the guest TDs simultaneously.  Prevent
> >  	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> > @@ -236,6 +361,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
> >  	 */
> >  	write_lock(&kvm->mmu_lock);
> >
> > +	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
> > +	if (err == TDX_FLUSHVP_NOT_DONE) {
> 
> Not sure IIUC, The __tdx_mmu_release_hkid() is called in MMU release
> callback, which means all threads of the process have dropped mm by
> do_exit() so they won't run kvm code anymore, and tdx_flush_vp_on_cpu()
> is called for each pcpu they run last time, so will this error really
> happen ?

KVM_TDX_RELEASE_VM calls the function too. Maybe this check should be
introduced with the patch for KVM_TDX_RELEASE_VM.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

