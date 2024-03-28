Return-Path: <kvm+bounces-13035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B2D890B87
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C32D297417
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 20:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FAE13A885;
	Thu, 28 Mar 2024 20:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+rbttlR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77A17EF;
	Thu, 28 Mar 2024 20:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658346; cv=none; b=gW615JZiK3UJq4popaQq9MrWmZzyPi/QqSPsJvS/rIloAZWtdoFuenXAIxtMTrDk1+3V1wqhM7tvdW+VKxp/TniMWab1HzqqsrPeeUMGC+aYv5HgOFZuL65uPbBhTJnpI9z/oxE08/EkPWS3n11eTuDaHJpl21oHxdMHpRoNZpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658346; c=relaxed/simple;
	bh=zp2qL6ydfBycrCAW9nXS8bSJZLCcBUydjvSCCE1BPt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXsvCEorZXaBrvvKh4/Z/2lD9CAR5QNmflKrA/VdiNZGp+cSTw+7bd5tt2j5UX9nthH/vEMcY32HgJoGywuI55ReX+AQTxokTJIPfAbqX1qWbzZHU1eAWrMPjt5d3zjt3e7MowZg07JwYzNB7H3n6kUktxydpDG4GfKLiVlD71I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+rbttlR; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711658344; x=1743194344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zp2qL6ydfBycrCAW9nXS8bSJZLCcBUydjvSCCE1BPt0=;
  b=f+rbttlRzNYNt3VGUdAfAABpfFncBRX6VuTD3g6fnP2wXQXPTpxk4IY3
   tXlAK3vufN5oi2EBIM52RJs5o/hHXgVLn14uN2mdbJkIebaBobxdfiWFW
   YJnK5SB2aYv2ojfXgm3EXOBQ2UJ/kfm3LH1jcnK2OZEzvdwr2YH+v/DGp
   cvTlhumJNcrbLRZvzmpz8ujyn8Q48NRZgEFaKpfJjVLSQInviZenoUCCu
   lOhvGtR3X2i3g5OcYzPzkObYPlqLGnWB2ma17H2v+GZLr+BCgqw8UQvr9
   xjdt89mO9n/dptIPeLrjGk/i2qkq9ABNwzOjbFdra8taPc1l57xgPMX8R
   A==;
X-CSE-ConnectionGUID: LlRI8Bi+SkuUtP8CV4OpDA==
X-CSE-MsgGUID: +t/WAQ5IRaiPWRTT8+WU8A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6734012"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6734012"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 13:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16595289"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 13:39:03 -0700
Date: Thu, 28 Mar 2024 13:39:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240328203902.GP2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
 <20240328053432.GO2444378@ls.amr.corp.intel.com>
 <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>

On Thu, Mar 28, 2024 at 11:14:42AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2024-03-27 at 22:34 -0700, Isaku Yamahata wrote:
> > On Thu, Mar 28, 2024 at 02:49:56PM +1300,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > 
> > > 
> > > On 28/03/2024 11:53 am, Isaku Yamahata wrote:
> > > > On Tue, Mar 26, 2024 at 02:43:54PM +1300,
> > > > "Huang, Kai" <kai.huang@intel.com> wrote:
> > > > 
> > > > > ... continue the previous review ...
> > > > > 
> > > > > > +
> > > > > > +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> > > > > > +{
> > > > > > +	WARN_ON_ONCE(!td_page_pa);
> > > > > 
> > > > >  From the name 'td_page_pa' we cannot tell whether it is a control page, but
> > > > > this function is only intended for control page AFAICT, so perhaps a more
> > > > > specific name.
> > > > > 
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> > > > > 
> > > > > "are" -> "is".
> > > > > 
> > > > > Are you sure it is TDCX, but not TDCS?
> > > > > 
> > > > > AFAICT TDCX is the control structure for 'vcpu', but here you are handling
> > > > > the control structure for the VM.
> > > > 
> > > > TDCS, TDVPR, and TDCX.  Will update the comment.
> > > 
> > > But TDCX, TDVPR are vcpu-scoped.  Do you want to mention them _here_?
> > 
> > So I'll make the patch that frees TDVPR, TDCX will change this comment.
> > 
> 
> Hmm.. Looking again, I am not sure why do we even need
> tdx_reclaim_control_page()?
> 
> It basically does tdx_reclaim_page() + free_page():
> 
> +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> +{
> +	WARN_ON_ONCE(!td_page_pa);
> +
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (tdx_reclaim_page(td_page_pa))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's
> an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.
> +		 */
> +		return;
> +	free_page((unsigned long)__va(td_page_pa));
> +}
> 
> And why do you need a special function just for control page(s)?

We can revise the code to have common function for reclaiming page.


> > > Otherwise you will have to explain them.
> > > 
> > > [...]
> > > 
> > > > > > +
> > > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > > > +{
> > > > > > +	bool packages_allocated, targets_allocated;
> > > > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > > > +	cpumask_var_t packages, targets;
> > > > > > +	u64 err;
> > > > > > +	int i;
> > > > > > +
> > > > > > +	if (!is_hkid_assigned(kvm_tdx))
> > > > > > +		return;
> > > > > > +
> > > > > > +	if (!is_td_created(kvm_tdx)) {
> > > > > > +		tdx_hkid_free(kvm_tdx);
> > > > > > +		return;
> > > > > > +	}
> > > > > 
> > > > > I lost tracking what does "td_created()" mean.
> > > > > 
> > > > > I guess it means: KeyID has been allocated to the TDX guest, but not yet
> > > > > programmed/configured.
> > > > > 
> > > > > Perhaps add a comment to remind the reviewer?
> > > > 
> > > > As Chao suggested, will introduce state machine for vm and vcpu.
> > > > 
> > > > https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/
> > > 
> > > Could you elaborate what will the state machine look like?
> > > 
> > > I need to understand it.
> > 
> > Not yet. Chao only propose to introduce state machine. Right now it's just an
> > idea.
> 
> Then why state machine is better?  I guess we need some concrete example to tell
> which is better?

At this point we don't know which is better.  I personally think it's worthwhile
to give it a try.  After experiment, we may discard or adapt the idea.

Because the TDX spec already defines its state machine, we could follow it.


> > > > How about this?
> > > > 
> > > > /*
> > > >   * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
> > > >   * TDH.MNG.KEY.FREEID() to free the HKID.
> > > >   * Other threads can remove pages from TD.  When the HKID is assigned, we need
> > > >   * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
> > > >   * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
> > > >   * present transient state of HKID.
> > > >   */
> > > 
> > > Could you elaborate why it is still possible to have other thread removing
> > > pages from TD?
> > > 
> > > I am probably missing something, but the thing I don't understand is why
> > > this function is triggered by MMU release?  All the things done in this
> > > function don't seem to be related to MMU at all.
> > 
> > The KVM releases EPT pages on MMU notifier release.  kvm_mmu_zap_all() does. If
> > we follow that way, kvm_mmu_zap_all() zaps all the Secure-EPTs by
> > TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().  Because
> > TDH.MEM.{SEPT, PAGE}.REMOVE() is slow, we can free HKID before kvm_mmu_zap_all()
> > to use TDH.PHYMEM.PAGE.RECLAIM().
> 
> Can you elaborate why TDH.MEM.{SEPT,PAGE}.REMOVE is slower than
> TDH.PHYMEM.PAGE.RECLAIM()?
> 
> And does the difference matter in practice, i.e. did you see using the former
> having noticeable performance downgrade?

Yes. With HKID alive, we have to assume that vcpu can run still. It means TLB
shootdown. The difference is 2 extra SEAMCALL + IPI synchronization for each
guest private page.  If the guest has hundreds of GB, the difference can be
tens of minutes.

With HKID alive, we need to assume vcpu is alive.
- TDH.MEM.PAGE.REMOVE()
- TDH.PHYMEM.PAGE_WBINVD()
- TLB shoot down
  - TDH.MEM.TRACK()
  - IPI to other vcpus
  - wait for other vcpu to exit

After freeing HKID
- TDH.PHYMEM.PAGE.RECLAIM()
  We already flushed TLBs and memory cache.


> > > Freeing vcpus is done in
> > > kvm_arch_destroy_vm(), which is _after_ mmu_notifier->release(), in which
> > > this tdx_mmu_release_keyid() is called?
> > 
> > guest memfd complicates things.  The race is between guest memfd release and mmu
> > notifier release.  kvm_arch_destroy_vm() is called after closing all kvm fds
> > including guest memfd.
> > 
> > Here is the example.  Let's say, we have fds for vhost, guest_memfd, kvm vcpu,
> > and kvm vm.  The process is exiting.  Please notice vhost increments the
> > reference of the mmu to access guest (shared) memory.
> > 
> > exit_mmap():
> >   Usually mmu notifier release is fired. But not yet because of vhost.
> > 
> > exit_files()
> >   close vhost fd. vhost starts timer to issue mmput().
> 
> Why does it need to start a timer to issue mmput(), but not call mmput()
> directly?

That's how vhost implements it.  It's out of KVM control.  Other component or
user space as other thread can get reference to mmu or FDs.  They can keep/free
them as they like.


> >   close guest_memfd.  kvm_gmem_release() calls kvm_mmu_unmap_gfn_range().
> >     kvm_mmu_unmap_gfn_range() eventually this calls TDH.MEM.SEPT.REMOVE()
> >     and TDH.MEM.PAGE.REMOVE().  This takes time because it processes whole
> >     guest memory. Call kvm_put_kvm() at last.
> > 
> >   During unmapping on behalf of guest memfd, the timer of vhost fires to call
> >   mmput().  It triggers mmu notifier release.
> > 
> >   Close kvm vcpus/vm. they call kvm_put_kvm().  The last one calls
> >   kvm_destroy_vm().  
> > 
> > It's ideal to free HKID first for efficiency. But KVM doesn't have control on
> > the order of fds.
> 
> Firstly, what kinda performance efficiency gain are we talking about?

2 extra SEAMCALL + IPI sync for each guest private page.  If the guest memory
is hundreds of GB, the difference can be tens of minutes.


> We cannot really tell whether it can be justified to use two different methods
> to tear down SEPT page because of this.
> 
> Even if it's worth to do, it is an optimization, which can/should be done later
> after you have put all building blocks together.
> 
> That being said, you are putting too many logic in this patch, i.e., it just
> doesn't make sense to release TDX keyID in the MMU code path in _this_ patch.

I agree that this patch is too huge, and that we should break it into smaller
patches.


> > > But here we are depending vcpus to be freed before tdx_mmu_release_hkid()?
> > 
> > Not necessarily.
> 
> I am wondering when is TDH.VP.FLUSH done?  Supposedly it should be called when
> we free vcpus?  But again this means you need to call TDH.MNG.VPFLUSHDONE
> _after_ freeing vcpus.  And this  looks conflicting if you make
> tdx_mmu_release_keyid() being called from MMU notifier.

tdx_mmu_release_keyid() call it explicitly for all vcpus.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

