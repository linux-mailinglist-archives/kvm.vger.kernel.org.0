Return-Path: <kvm+bounces-10746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6EB86F91F
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 05:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA60C281686
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 04:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DBBF611B;
	Mon,  4 Mar 2024 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2Evt+eQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2163C39
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 04:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709525329; cv=none; b=AdjHW5oDU9XX4rESNYTgpfL2v0r9tlwHtV2Q1ivSAfu1r26wmfKIQV5N4GHo+kbhbJ0WYawXIWIPFGjOd//cuDfD2smY51efGFEbobu40zXBzmZd47YSnJ+7mqwjn520vmSQMGt2a42reclyRoQpzDOE28Of0uD9UVLt8LmcGEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709525329; c=relaxed/simple;
	bh=kPEzY1Q/YiJkCG9/zvlWooKynCaKb4rUYhJRl+dFyFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpt46Pv91eeqSOU3xM04U6f8BsbZMn7rw9UvK1TiRLNXLIGLWZi9SaP4kpX1TG1XXHeOgR+aZRytNqv65QfXCdHW8xInIPN5U3mGk2tPOMCFirP5EqWv/kSK8tdXAcP5+X3POXnaoKZCl01mvUY5pp6ORfHoLAJfBHvIULXDmNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b2Evt+eQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709525328; x=1741061328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kPEzY1Q/YiJkCG9/zvlWooKynCaKb4rUYhJRl+dFyFs=;
  b=b2Evt+eQoFAd1l8asfgYRjBxZl1/R0jIlNzvF4838YrTl3zf9RO2M074
   vwrhTfhcJv/8tv4GkpIV9okwtWG+a+8a8KjSj5I5MnHrXJQXxxzAr3TGB
   8h2ZjB4JWYUQHuJugcXz3umSmEx2oDVNrmvkOnjcnLC+hJuSHsi2X8G7n
   3f2TVLdfIqyNi6S4QyQCIs5/8AtGDzh7UUSJYanZsNMhhrN2M85tNSpVm
   HsCO5kHTF9i6toovix16y3jTOPkb7vO5DCRGdwJ4tWhG+ZRbqbPHLcoOT
   HPUfhKHHYGwV+mjYIrUd3pKcQ8Y17fgjRWb7LmRliM/MXbblBSpDRuquG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="3858457"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="3858457"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 20:08:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="9296666"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 20:08:44 -0800
Date: Mon, 4 Mar 2024 12:05:50 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] kvm: add support for guest physical bits
Message-ID: <ZeVIniWQDtPufs7W@linux.bj.intel.com>
References: <20240301101713.356759-1-kraxel@redhat.com>
 <20240301101713.356759-2-kraxel@redhat.com>
 <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>

On Mon, Mar 04, 2024 at 09:54:40AM +0800, Xiaoyao Li wrote:
> On 3/1/2024 6:17 PM, Gerd Hoffmann wrote:
> > query kvm for supported guest physical address bits using
> > KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
> > (leaf 0x80000008, eax, bits 16-23).
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >   target/i386/cpu.h     | 1 +
> >   target/i386/cpu.c     | 1 +
> >   target/i386/kvm/kvm.c | 8 ++++++++
> >   3 files changed, 10 insertions(+)
> > 
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 952174bb6f52..d427218827f6 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -2026,6 +2026,7 @@ struct ArchCPU {
> >       /* Number of physical address bits supported */
> >       uint32_t phys_bits;
> > +    uint32_t guest_phys_bits;
> >       /* in order to simplify APIC support, we leave this pointer to the
> >          user */
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 2666ef380891..1a6cfc75951e 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >           if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
> >               /* 64 bit processor */
> >                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> > +             *eax |= (cpu->guest_phys_bits << 16);
> 
> I think you misunderstand this field.
> 
> If you expose this field to guest, it's the information for nested guest.
> i.e., the guest itself runs as a hypervisor will know its nested guest can
> have guest_phys_bits for physical addr.

I'm also thinking about this issue...

Currently guest KVM doesn't use this field to advertise MAXPHYADDR because
nested guest hasn't tdp. And this patch only affects KVM hypervisor now.

Thanks,
Tao

> 
> >           }
> >           *ebx = env->features[FEAT_8000_0008_EBX];
> >           if (cs->nr_cores * cs->nr_threads > 1) {
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 42970ab046fa..e06c9d66bb01 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -1716,6 +1716,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
> >       X86CPU *cpu = X86_CPU(cs);
> >       CPUX86State *env = &cpu->env;
> >       uint32_t limit, i, j, cpuid_i;
> > +    uint32_t guest_phys_bits;
> >       uint32_t unused;
> >       struct kvm_cpuid_entry2 *c;
> >       uint32_t signature[3];
> > @@ -1751,6 +1752,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
> >       env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
> > +    guest_phys_bits = kvm_check_extension(cs->kvm_state, KVM_CAP_VM_GPA_BITS);
> > +    if (guest_phys_bits &&
> > +        (cpu->guest_phys_bits == 0 ||
> > +         cpu->guest_phys_bits > guest_phys_bits)) {
> > +        cpu->guest_phys_bits = guest_phys_bits;
> > +    }
> > +
> >       /*
> >        * kvm_hyperv_expand_features() is called here for the second time in case
> >        * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
> 
> 

