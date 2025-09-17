Return-Path: <kvm+bounces-57891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF0BB7F4A8
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0864F485EAD
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4FC2C3252;
	Wed, 17 Sep 2025 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="WmkvACG8"
X-Original-To: kvm@vger.kernel.org
Received: from out28-51.mail.aliyun.com (out28-51.mail.aliyun.com [115.124.28.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368981E1E19;
	Wed, 17 Sep 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115665; cv=none; b=Xjb8KQUJroW0ZFCyb8qIqLziXXtdbD0wEel6rTsNN4ln187TdR7ovOjocOVcQhnFGKEar+4GlBQZD+2+0nGmaf4jmVgWklIboMJfVYI5y+cKkOt3HqpomHcxEgFyvNloNcUBwp5vLHSYZza6ga7Fk+CazdFC+AxsvtcUZaLkYzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115665; c=relaxed/simple;
	bh=K20C3YswhYrkfhKueFLBtLWtxSyZRcsL0bdoVPT53qE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oitZYjkxwm8IApuPlzs1xcoRx67wQkhzk1luiP5OTDXRYf4CnHHJJfMZwiL6OaOjuEqHBBFcmsL0wXcix08m4CDN7MMbfqteLTT9+OlkzkXmHkgWi7pCokWtCq0N7fYyXmHoW5oPXEKB/VzuxFTIdnsbX/LZjLzq31L/4/kcp6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=WmkvACG8; arc=none smtp.client-ip=115.124.28.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758115651; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Si9bvpV/P3U16VBrFiz4XdJmadG7Z1pIWYDjkXD5J7w=;
	b=WmkvACG8SX5Ngqk5ERs31xbivHPu+DK4FgmUhhoMgYzlaSPpxfTKnQ2w4xoqhT3id8MujKlt0H+IpdOaUaA6w77uto+tV8MA4CKZk39Rp0E2Gu4+9f0p61UBreqcAUIcSyusoknAXskWuXfl0CE3pwvu2a0jmNKG+a8V5IBclJ8=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ehKMKZL_1758114711 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 17 Sep 2025 21:11:52 +0800
Date: Wed, 17 Sep 2025 21:11:51 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] KVM: Disable IRQs in
 kvm_online_cpu()/kvm_offline_cpu()
Message-ID: <20250917131151.GA100623@k08j02272.eu95sqa>
References: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
 <dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Sep 16, 2025 at 10:12:03AM +0000, Huang, Kai wrote:
> On Tue, 2025-09-16 at 14:07 +0800, Hou Wenlong wrote:
> > After the commit aaf12a7b4323 ("KVM: Rename and move
> > CPUHP_AP_KVM_STARTING to ONLINE section"), KVM's hotplug callbacks have
> > been moved into the ONLINE section, where IRQs and preemption are
> > enabled according to the documentation. However, if IRQs are not
> > guaranteed to be disabled, it could theoretically be a bug, because
> > virtualization_enabled may be stale (with respect to the actual state of
> > the hardware) when read from IRQ context, making the callback
> > potentially reentrant. Therefore, disable IRQs in kvm_online_cpu() and
> > kvm_offline_cpu() to ensure that all paths for
> > kvm_enable_virtualization_cpu() and kvm_disable_virtualization_cpu() are
> > in an IRQ-disabled state.
> 
> Reading the v1 thread [*], IIUC the "virtualization_enabled being stale
> when read from IRQ context" is referring to the case where
> kvm_disable_virtualization_cpu() got interrupted by IRQ and re-entered.
> 
> But IIUC this shouldn't happen.  If I am not missing anything, the
> syscore_shutdown() (from which KVM sends IRQ to call
> kvm_disable_virtualization_cpu()) is always called after
> migrate_to_reboot_cpu(), which internally waits for currently running CPU
> hotplug to complete (if any) and disables future CPU hotplug.  Therefore
> it shouldn't be possible that kvm_disable_virtualization_cpu() could be
> interrupted and re-entered via IRQ.
> 
Yes, you are right. The syscore_ops are exclusive hotplug callbacks, so
there are actually no bugs, and I didn't add a Fix tag here. The above
description is just an assumption in case it is interrupted, as the
callback is not in an IRQ-disabled state. Sorry, I forgot to include the
important part you mentioned in my commit message.

> I don't oppose this code change, but I think this should somehow
> documented in the changelog, if I am not missing anything?
> 
> [*]: https://lore.kernel.org/kvm/aMirvo9Xly5fVmbY@google.com/
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  virt/kvm/kvm_main.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 18f29ef93543..cf8dddeed37e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -5580,6 +5580,8 @@ __weak void kvm_arch_disable_virtualization(void)
> >  
> >  static int kvm_enable_virtualization_cpu(void)
> >  {
> > +	lockdep_assert_irqs_disabled();
> > +
> >  	if (__this_cpu_read(virtualization_enabled))
> >  		return 0;
> >  
> > @@ -5595,6 +5597,8 @@ static int kvm_enable_virtualization_cpu(void)
> >  
> >  static int kvm_online_cpu(unsigned int cpu)
> >  {
> > +	guard(irqsave)();
> > +
> >  	/*
> >  	 * Abort the CPU online process if hardware virtualization cannot
> >  	 * be enabled. Otherwise running VMs would encounter unrecoverable
> > @@ -5605,6 +5609,8 @@ static int kvm_online_cpu(unsigned int cpu)
> >  
> >  static void kvm_disable_virtualization_cpu(void *ign)
> >  {
> > +	lockdep_assert_irqs_disabled();
> > +
> >  	if (!__this_cpu_read(virtualization_enabled))
> >  		return;
> >  
> > @@ -5615,6 +5621,8 @@ static void kvm_disable_virtualization_cpu(void *ign)
> >  
> >  static int kvm_offline_cpu(unsigned int cpu)
> >  {
> > +	guard(irqsave)();
> > +
> >  	kvm_disable_virtualization_cpu(NULL);
> >  	return 0;
> >  }
> > @@ -5648,7 +5656,6 @@ static int kvm_suspend(void)
> >  	 * dropped all locks (userspace tasks are frozen via a fake signal).
> >  	 */
> >  	lockdep_assert_not_held(&kvm_usage_lock);
> > -	lockdep_assert_irqs_disabled();
> >  
> >  	kvm_disable_virtualization_cpu(NULL);
> >  	return 0;
> > @@ -5657,7 +5664,6 @@ static int kvm_suspend(void)
> >  static void kvm_resume(void)
> >  {
> >  	lockdep_assert_not_held(&kvm_usage_lock);
> > -	lockdep_assert_irqs_disabled();
> >  
> >  	WARN_ON_ONCE(kvm_enable_virtualization_cpu());
> >  }
> > 
> > base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383

