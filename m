Return-Path: <kvm+bounces-5826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC1C827031
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAF041F232CB
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C782245BE6;
	Mon,  8 Jan 2024 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yfn0tnus"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1445977
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 13:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704721687; x=1736257687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=l7IOQjW3e3Pa7PmRmgUkhxOIMvBarMyQKZT3x2OZ4Xo=;
  b=Yfn0tnusKVR0idG43HfYE0eIrACSi+fF71/jTAS41NXRzX53iWgiYC9y
   WdufBhdjOe029lM1hiGEtt/gJPjOAVAHoqFIcCvOfo8NJjJ+Wrw3Ap3x0
   IiR8VwSFXMZGatK4/rV8tRqWDtJGtrHoSorVoqVSkcF0/RK9UbR7+wFh+
   QK8w3w54+l2v4iM+b5YWzScYcFX40eljYc0ijfBhzq6ChjZTxcged7iKl
   AI1DhqYpExjtkTvspPTtBH7gKEOrYyKjJp3rdLJR43o/XcrwllnWeJMEn
   S89ti0yGeDT6jEGohkYR/DXEmW6ege7JMqYLWb8l6BkqaTeBnEQ21zNHG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="464282162"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="464282162"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 05:48:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="924872852"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="924872852"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 05:48:03 -0800
Date: Mon, 8 Jan 2024 21:45:00 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Chao Gao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, eddie.dong@intel.com, xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com,
	chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZZv8XA3eUHLaCr8K@linux.bj.intel.com>
References: <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
 <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com>
 <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
 <ZZbJxgyYoEJy+bAj@chao-email>
 <CALMp9eTf=9VqM=xutOXmgRr+aFz-YhOz6h4B+uLgtFBXtHefPA@mail.gmail.com>
 <ZZhl4FHcdrzMXoVy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZZhl4FHcdrzMXoVy@google.com>

On Fri, Jan 05, 2024 at 12:26:08PM -0800, Sean Christopherson wrote:
> On Thu, Jan 04, 2024, Jim Mattson wrote:
> > On Thu, Jan 4, 2024 at 7:08 AM Chao Gao <chao.gao@intel.com> wrote:
> > >
> > > On Wed, Jan 03, 2024 at 07:40:02PM -0800, Jim Mattson wrote:
> > > >On Wed, Jan 3, 2024 at 6:45 PM Chao Gao <chao.gao@intel.com> wrote:
> > > >>
> > > >> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> > > >> >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > > >> >> This is all just so broken and wrong. The only guest.MAXPHYADDR that
> > > >> >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> > > >> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
> > > >> >> every #PF,
> > > >>
> > > >> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supports only
> > > >> 4-level EPT), KVM has no need to intercept #PF because accessing a GPA with
> > > >> RSVD bits 51-48 set leads to EPT violation.
> > > >
> > > >At the completion of the page table walk, if there is a permission
> > > >fault, the data address should not be accessed, so there should not be
> > > >an EPT violation. Remember Meltdown?
> > >
> > > You are right. I missed this case. KVM needs to intercept #PF to set RSVD bit
> > > in PFEC.
> > 
> > I have no problem with a user deliberately choosing an unsupported
> > configuration, but I do have a problem with KVM_GET_SUPPORTED_CPUID
> > returning an unsupported configuration.
> 
> +1
> 
> Advertising guest.MAXPHYADDR < host.MAXPHYADDR in KVM_GET_SUPPORTED_CPUID simply
> isn't viable when TDP is enabled.  I suppose KVM do so when allow_smaller_maxphyaddr
> is enabled, but that's just asking for confusion, e.g. if userspace reflects the
> CPUID back into the guest, it could unknowingly create a VM that depends on
> allow_smaller_maxphyaddr.
> 
> I think the least awful option is to have the kernel expose whether or not the
> CPU support 5-level EPT to userspace.  That doesn't even require new uAPI per se,
> just a new flag in /proc/cpuinfo.  It'll be a bit gross for userspace to parse,
> but it's not the end of the world.  Alternatively, KVM could add a capability to
> enumerate the max *addressable* GPA, but userspace would still need to manually
> take action when KVM can't address all of memory, i.e. a capability would be less
> ugly, but wouldn't meaningfully change userspace's responsibilities.

Yes, exposing whether the CPU support 5-level EPT is indeed a better solution, it
not only bypasses the KVM_GET_SUPPORTED_CPUID but also provides the information to
userspace.

I think a new KVM capability to enumerate the max GPA is better since it will be
more convenient if userspace wants to use, e.g., automatically limit physical bits
or the GPA in the user memory region.

But only reporting this capability can’t solve the KVM hang issue, userspace can
choose to ignore the max GPA, e.g., six selftests in changelog are still failed. I
think we can reconsider patch2 if we don’t advertise
guest.MAXPHYADDR < host.MAXPHYADDR in KVM_GET_SUPPORTED_CPUID.

Thanks,
Tao

> 
> I.e.
> 
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index c6a7eed03914..266daf5b5b84 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -25,6 +25,7 @@
>  #define VMX_FEATURE_EPT_EXECUTE_ONLY   ( 0*32+ 17) /* "ept_x_only" EPT entries can be execute only */
>  #define VMX_FEATURE_EPT_AD             ( 0*32+ 18) /* EPT Accessed/Dirty bits */
>  #define VMX_FEATURE_EPT_1GB            ( 0*32+ 19) /* 1GB EPT pages */
> +#define VMX_FEATURE_EPT_5LEVEL         ( 0*32+ 20) /* 5-level EPT paging */
>  
>  /* Aggregated APIC features 24-27 */
>  #define VMX_FEATURE_FLEXPRIORITY       ( 0*32+ 24) /* TPR shadow + virt APIC */
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index 03851240c3e3..1640ae76548f 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>                 c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_AD);
>         if (ept & VMX_EPT_1GB_PAGE_BIT)
>                 c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_1GB);
> +       if (ept & VMX_EPT_PAGE_WALK_5_BIT)
> +               c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_5LEVEL);
>  
>         /* Synthetic APIC features that are aggregates of multiple features. */
>         if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&
> 

