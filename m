Return-Path: <kvm+bounces-60136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC44BE3B2F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 15:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1820C584DAE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 13:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D627339B38;
	Thu, 16 Oct 2025 13:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="dtwtN5rx"
X-Original-To: kvm@vger.kernel.org
Received: from out28-2.mail.aliyun.com (out28-2.mail.aliyun.com [115.124.28.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E931D732;
	Thu, 16 Oct 2025 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760621274; cv=none; b=IJsC+IeXdlWwIrAKfudAY1IvUI+r8sHBqiqHyYmo68rJYM+quMtb5Dr/oYF6jVDrX9oU6ekNVk0u5BuOJFLlrbiNH03oHwXLjAF2RhsAsG+PCCblyItDRF0tY8NVDuYRP9gfQNSkB4StzNilRgasXdCmgU8SZxLtVQpMOjhozd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760621274; c=relaxed/simple;
	bh=rURpKKoKpiPCZKoYFk4mxrb1SCBNbL4IUUCyZ7GgzTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VM421gLylqFZdLn+v10c7H4gnmd7+5BRGY1iNmDYsagkD1kwnJEo6DAbRLwcwQEqEMsELMEBzqvAxmiLR9IP3HD1GbDWRYaMcyp3XEDpkEUqjm+EHjTwPhgmxsWtr0TUHSnHjP14ccI/P+a1oTQ4gT+VITjzHucv4nzpKZ4piLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=dtwtN5rx; arc=none smtp.client-ip=115.124.28.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1760621259; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Wvy+NFSqDgMOqcIBtfcIh0dPe0v9RLra3a++XA6Y7Zs=;
	b=dtwtN5rx1sMlukBBFDBOg1nYqS9xTSHCv6GJuzl3eMeNxKtGSBnZK32GqtWbh0EFH3JdWpA4k8G6q7wkszY0/hsykBP8VAyKq0trgN+d9odJsbpy8dj/7sxeIn9CwOpUH5oNRuMvP3KHRSFfNUdUc3j3Ydtst/t4MsbPeo/Dn/s=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.f06bvyV_1760621258 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 16 Oct 2025 21:27:38 +0800
Date: Thu, 16 Oct 2025 21:27:38 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <20251016132738.GB95606@k08j02272.eu95sqa>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com>
 <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
 <aO_JdH3WhfWr2BKr@google.com>
 <aPCzqQO7LE/cNiMA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPCzqQO7LE/cNiMA@yzhao56-desk.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Oct 16, 2025 at 04:58:17PM +0800, Yan Zhao wrote:
> On Wed, Oct 15, 2025 at 09:19:00AM -0700, Sean Christopherson wrote:
> > +Hou, who is trying to clean up the user-return registration code as well:
> > 
> > https://lore.kernel.org/all/15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com
> > 
> > On Wed, Oct 15, 2025, Yan Zhao wrote:
> > > On Tue, Sep 30, 2025 at 09:34:20AM -0700, Sean Christopherson wrote:
> > > > Ha!  It's technically a bug fix.  Because a forced shutdown will invoke
> > > > kvm_shutdown() without waiting for tasks to exit, and so the on_each_cpu() calls
> > > > to kvm_disable_virtualization_cpu() can call kvm_on_user_return() and thus
> > > > consume a stale values->curr.
> > > Looks consuming stale values->curr could also happen for normal VMs.
> > > 
> > > vmx_prepare_switch_to_guest
> > >   |->kvm_set_user_return_msr //for all slots that load_into_hardware is true
> > >        |->1) wrmsrq_safe(kvm_uret_msrs_list[slot], value);
> > >        |  2) __kvm_set_user_return_msr(slot, value);
> > >                |->msrs->values[slot].curr = value;
> > >                |  kvm_user_return_register_notifier
> > > 
> > > As vmx_prepare_switch_to_guest() invokes kvm_set_user_return_msr() with local
> > > irq enabled, there's a window where kvm_shutdown() may call
> > > kvm_disable_virtualization_cpu() between steps 1) and 2). During this window,
> > > the hardware contains the shadow guest value while values[slot].curr still holds
> > > the host value.
> > > 
> > > In this scenario, if msrs->registered is true at step 1) (due to updating of a
> > > previous slot), kvm_disable_virtualization_cpu() could call kvm_on_user_return()
> > > and find "values->host == values->curr", which would leave the hardware value
> > > set to the shadow guest value instead of restoring the host value.
> > > 
> > > Do you think it's a bug?
> > > And do we need to fix it by disabling irq in kvm_set_user_return_msr() ? e.g.,
> > 
> > Ugh.  It's technically "bug" of sorts, but I really, really don't want to fix it
> > by disabling IRQs.
> > 
> > Back when commit 1650b4ebc99d ("KVM: Disable irq while unregistering user notifier")
> > disabled IRQs in kvm_on_user_return(), KVM blasted IPIs in the _normal_ flow, when
> > when the last VM is destroyed (and also when enabling virtualization, which created
> > its own problems).
> > 
> > Now that KVM uses the cpuhp framework to enable/disable virtualization, the normal
> > case runs in task context, including kvm_suspend() and kvm_resume().  I.e. the only
> > path that can toggle virtualization via IPI callback is kvm_shutdown().  And on
> > reboot/shutdown, keeping the hook registered is ok as far as MSR state is concerned,
> > as the callback will run cleanly and restore host MSRs if the CPU manages to return
> > to userspace before the system goes down.
> > 
> > The only wrinkle is that if kvm.ko module unload manages to race with reboot, then
> > leaving the notifier registered could lead to use-after-free.  But that's only
> > possible on --forced reboot/shutdown, because otherwise userspace tasks would be
> > frozen before kvm_shutdown() is called, i.e. the CPU shouldn't return to userspace
> > after kvm_shutdown().  Furthermore, on a --forced reboot/shutdown, unregistering
> > the user-return hook from IRQ context rather pointless, because KVM could immediately
> > re-register the hook, e.g. if the IRQ arrives before kvm_user_return_register_notifier()
> > is called.  I.e. the use-after-free isn't fully defended on --forced reboot/shutdown
> > anyways.
> > 
> > Given all of the above, my vote is to eliminate the IRQ disabling crud and simply
> > leave the user-return notifier registered on a reboot.  Then to defend against
> > a use-after-free due to kvm.ko unload racing against reboot, simply bump the module
> > refcount.  Trying to account for a rather absurd case in the normal paths adds a
> > ton of noise for almost no gain.
> Thanks for the detailed explanation.
> 
> > E.g.
> > 
> > ---
> >  arch/x86/kvm/x86.c | 29 +++++++++++++++++++++--------
> >  1 file changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4b8138bd4857..f03f3ae836f8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -582,18 +582,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> >  	struct kvm_user_return_msrs *msrs
> >  		= container_of(urn, struct kvm_user_return_msrs, urn);
> >  	struct kvm_user_return_msr_values *values;
> > -	unsigned long flags;
> >  
> > -	/*
> > -	 * Disabling irqs at this point since the following code could be
> > -	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> > -	 */
> > -	local_irq_save(flags);
> >  	if (msrs->registered) {
> >  		msrs->registered = false;
> >  		user_return_notifier_unregister(urn);
> >  	}
> > -	local_irq_restore(flags);
> > +
> >  	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
> >  		values = &msrs->values[slot];
> >  		if (values->host != values->curr) {
> > @@ -13079,7 +13073,21 @@ int kvm_arch_enable_virtualization_cpu(void)
> >  void kvm_arch_disable_virtualization_cpu(void)
> >  {
> >  	kvm_x86_call(disable_virtualization_cpu)();
> > -	drop_user_return_notifiers();
> > +
> > +	/*
> > +	 * Leave the user-return notifiers as-is when disabling virtualization
> > +	 * for reboot, i.e. when disabling via IPI function call, and instead
> > +	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
> > +	 * the *very* unlikely scenario module unload is racing with reboot).
> > +	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
> > +	 * could be actively modifying user-return MSR state when the IPI to
> > +	 * disable virtualization arrives.  Handle the extreme edge case here
> > +	 * instead of trying to account for it in the normal flows.
> > +	 */
> > +	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
> kvm_offline_cpu() may be invoked when irq is enabled.
> So does it depend on [1]?
> 
> [1] https://lore.kernel.org/kvm/aMirvo9Xly5fVmbY@google.com/
>

Actually, kvm_offline_cpu() can't be interrupted by kvm_shutdown().
syscore_shutdown() is always called after
migrate_to_reboot_cpu(), which internally waits for currently running
CPU hotplug to complete, as described in [*].

[*] https://lore.kernel.org/kvm/dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com


> > +		drop_user_return_notifiers();
> > +	else
> > +		__module_get(THIS_MODULE);
> Since vm_vm_fops holds ref of module kvm_intel, and drop_user_return_notifiers()
> is called in kvm_destroy_vm() or kvm_exit():
> 
> kvm_destroy_vm/kvm_exit
>   kvm_disable_virtualization
>     kvm_offline_cpu
>       kvm_disable_virtualization_cpu
>         drop_user_return_notifiers
> 
> also since fire_user_return_notifiers() executes with irq disabled, is it
> necessary to pin kvm.ko?
> 
> >  }
> >  
> >  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> > @@ -14363,6 +14371,11 @@ module_init(kvm_x86_init);
> >  
> >  static void __exit kvm_x86_exit(void)
> >  {
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
> > +
> >  	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
> >  }
> >  module_exit(kvm_x86_exit);
> > 
> > base-commit: fe57670bfaba66049529fe7a60a926d5f3397589
> > --

