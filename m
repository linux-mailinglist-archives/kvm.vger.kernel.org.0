Return-Path: <kvm+bounces-24077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0FF95112D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6EB11F22143
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BA79457;
	Wed, 14 Aug 2024 00:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jg3a7bfO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9A631;
	Wed, 14 Aug 2024 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596783; cv=none; b=Olq/gmXQjHbrCSLb/5zQiyROKI6fg9qLTf/T75pr0x458XgJmEg84KL5MA0TTL0g2stdL6397OSmSjnG0oCdMZ2HuUPN7Ny2LJ3ifcKR5+aNpibXxPN3zN1s26JC5CEb3PlzjE+ADKH6wsqze1qDEMaKpwMG2O9xFUMyu4gQnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596783; c=relaxed/simple;
	bh=0lZjYgbt886BAATjYp5u+vJsys8Pa7V7F1dIvlxlsSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHj9VqT/F6JzqourXDXzzcWtuDM/UQ+qz/QrsqHnKhaBqKawceKrxwT4XQVh3SYT+JH7XNZZNRIQg836zv21T60ECBsMnSqJMnIbRxLNDH4EJkGRmaooGR9dUybMRhqsXCpetxMSubIZ3HOViwTXdSLDlWg9V0qQg4gA7xtC8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jg3a7bfO; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723596781; x=1755132781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0lZjYgbt886BAATjYp5u+vJsys8Pa7V7F1dIvlxlsSM=;
  b=Jg3a7bfOQltc2ammIJtc/0zhd/aPnqjItRaHGf6GLgNemimJiNjW3E6d
   3iePP6RQmm/YXq7QcueoTg3zq/020FpK/X1htiqE76h9m3qHC8W6rdcWA
   K/pJG7QNd2/7RAKeyJEmPXfX4snbt9y4rV0C7aYmHCbUQPqXWWBxPl6yg
   fR0Y2UDncPtTYwZzznnRmITIwvUX1+LoOgtd7fp9AhyummYCJmKq7oZIN
   4Zld+YIdf0lGowjmyK+QwpdLM0sSBhpd2cru1EmOOp4hA5c7LJHbToqvK
   +PRrhZ3yubZfKfNrjlTLjgdyI6i/XDQeoK55yrATJ55A8r5uPMZMkN6jT
   Q==;
X-CSE-ConnectionGUID: QXOqwoM+QQiXPiHGnr0KuA==
X-CSE-MsgGUID: 9xe2yvjyR6qmXn4LM1JtKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="47190570"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="47190570"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:53:00 -0700
X-CSE-ConnectionGUID: qS+99hp2Ra++SxVOWTGUxg==
X-CSE-MsgGUID: 7NovaX+ISyyqDPJRbRl91g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63243512"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:53:00 -0700
Date: Tue, 13 Aug 2024 17:52:59 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
 <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>

On Wed, Aug 14, 2024 at 11:11:29AM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 14/08/2024 5:50 am, Isaku Yamahata wrote:
> > On Tue, Aug 13, 2024 at 01:12:55PM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > Check whether a KVM hypercall needs to exit to userspace or not based on
> > > hypercall_exit_enabled field of struct kvm_arch.
> > > 
> > > Userspace can request a hypercall to exit to userspace for handling by
> > > enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> > > hypercall_exit_enabled.  Make the check code generic based on it.
> > > 
> > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > ---
> > >   arch/x86/kvm/x86.c | 4 ++--
> > >   arch/x86/kvm/x86.h | 7 +++++++
> > >   2 files changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index af6c8cf6a37a..6e16c9751af7 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >   	cpl = kvm_x86_call(get_cpl)(vcpu);
> > >   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > > -		/* MAP_GPA tosses the request to the user space. */
> > > +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> > > +		/* The hypercall is requested to exit to userspace. */
> > >   		return 0;
> > >   	if (!op_64_bit)
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index 50596f6f8320..0cbec76b42e6 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> > >   			 unsigned int port, void *data,  unsigned int count,
> > >   			 int in);
> > > +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
> > > +{
> > > +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
> > > +		return false;
> > 
> > Is this to detect potential bug? Maybe
> > BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
> >               !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
> > Overkill?
> 
> I don't think this is the correct way to use __builtin_constant_p(), i.e. it
> doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().
> 
> IIUC you need some build time guarantee here, but __builtin_constant_p() can
> return false, in which case the above BUILD_BUG_ON() does nothing, which
> defeats the purpose.

It depends on what we'd like to detect.  BUILT_BUG_ON(__builtin_constant_p())
can detect the usage in the patch 2/2,
is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE).  The potential
future use of is_kvm_hc_exit_enabled(, KVM_HC_MAP_future_hypercall).

Although this version doesn't help for the one in kvm_emulate_hypercall(),
!ret check is done first to avoid WARN_ON_ONCE() to hit here.

Maybe we can just drop this WARN_ON_ONCE().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

