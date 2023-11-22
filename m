Return-Path: <kvm+bounces-2309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 410157F498E
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 15:59:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFF8D28129A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 14:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7618D4D132;
	Wed, 22 Nov 2023 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCVpdFxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3B01BD
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 06:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700665177; x=1732201177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6uFQr2BOae89W7b8VpCI3Jyj/oX3gvHnnZeaGh2CYF4=;
  b=SCVpdFxV4+VEUZNk/S81GVpb5G2adVp4MKUcazzK+CFgzBFy6D7SFlfq
   wmmU8ufwGsO9tKi3q/uaAXs9fmbaqd+xRItUIG7oW35H3eK2vfc44WHNn
   8b0G2rw9c/HEQ62P0DvBNkQYydMxbv0BN5c+twnhFQVMHPWyRPk1GssWr
   qsVxmco0sRE/V8kdMdAlYez0DOLFah+L5zT49GXLPlUwEw+g8DLTmkUuX
   25ngzGvuWghFqqJUrh2a4QktqTLNy1Q1fpzgTClBkJQ4j0N20WXCJuiRK
   R1p79/b6Q4LqPD/UQA0YuRyq9R5P21HdUqO8yloKNCxNz4TdlXUDOQKl2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="377095030"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="377095030"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 06:59:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="910840038"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="910840038"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga001.fm.intel.com with ESMTP; 22 Nov 2023 06:59:26 -0800
Date: Wed, 22 Nov 2023 22:57:33 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
Message-ID: <ZV4W3epvrQi1qtat@yilunxu-OptiPlex-7050>
References: <20231117122633.47028-1-lirongqing@baidu.com>
 <ZVzJTK4J+sm5prKG@yilunxu-OptiPlex-7050>
 <0b000299dc964dad8bdc26271e4939a6@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b000299dc964dad8bdc26271e4939a6@baidu.com>

On Wed, Nov 22, 2023 at 06:15:44AM +0000, Li,Rongqing wrote:
> 
> 
> > -----Original Message-----
> > From: Xu Yilun <yilun.xu@linux.intel.com>
> > Sent: Tuesday, November 21, 2023 11:14 PM
> > To: Li,Rongqing <lirongqing@baidu.com>
> > Cc: x86@kernel.org; kvm@vger.kernel.org
> > Subject: Re: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
> > create vcpu
> > 
> > On Fri, Nov 17, 2023 at 08:26:33PM +0800, Li RongQing wrote:
> > > Static key kvm_has_noapic_vcpu should be reduced when fail to create
> > > vcpu, this patch fixes it
> > >
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > > 41cce50..2a22e66 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -11957,7 +11957,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
> > *vcpu)
> > >  	kfree(vcpu->arch.mci_ctl2_banks);
> > >  	free_page((unsigned long)vcpu->arch.pio_data);
> > >  fail_free_lapic:
> > > -	kvm_free_lapic(vcpu);
> > > +	if (!lapic_in_kernel(vcpu))
> > > +		static_branch_dec(&kvm_has_noapic_vcpu);
> > > +	else
> > > +		kvm_free_lapic(vcpu);
> > >  fail_mmu_destroy:
> > >  	kvm_mmu_destroy(vcpu);
> > >  	return r;
> > 
> > It is good to me. But is it better also take the chance to tidy up
> > kvm_arch_vcpu_destroy():
> > 
> > 	kvm_free_lapic(vcpu);
> > 	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > 	kvm_mmu_destroy(vcpu);
> > 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > 	free_page((unsigned long)vcpu->arch.pio_data);
> > 	kvfree(vcpu->arch.cpuid_entries);
> > 	if (!lapic_in_kernel(vcpu))
> > 		static_branch_dec(&kvm_has_noapic_vcpu);
> > 
> 
> Do you means that calling kvm_free_lapic when lapic_in_kernel is true?

Yes.

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c92407..9d176c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12122,14 +12122,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         kvm_pmu_destroy(vcpu);
>         kfree(vcpu->arch.mce_banks);
>         kfree(vcpu->arch.mci_ctl2_banks);
> -       kvm_free_lapic(vcpu);
> +
> +       if (lapic_in_kernel(vcpu))
> +               kvm_free_lapic(vcpu);
> +       else
> +               static_branch_dec(&kvm_has_noapic_vcpu);

Better keep the same style as in kvm_arch_vcpu_create():

  if (!lapic_in_kernel(vcpu))
	static_branch_dec(&kvm_has_noapic_vcpu);
  else
	kvm_free_lapic(vcpu);

Thanks,
Yilun

> +
>         idx = srcu_read_lock(&vcpu->kvm->srcu);
>         kvm_mmu_destroy(vcpu);
>         srcu_read_unlock(&vcpu->kvm->srcu, idx);
>         free_page((unsigned long)vcpu->arch.pio_data);
>         kvfree(vcpu->arch.cpuid_entries);
> -       if (!lapic_in_kernel(vcpu))
> -               static_branch_dec(&kvm_has_noapic_vcpu);
>  }
> 
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
> 
> 

