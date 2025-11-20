Return-Path: <kvm+bounces-63967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2DBC75EE2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id A7F872A760
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76F834AAEF;
	Thu, 20 Nov 2025 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b="HZyLRqif"
X-Original-To: kvm@vger.kernel.org
Received: from mail-108-mta94.mxroute.com (mail-108-mta94.mxroute.com [136.175.108.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D6F277CAB
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 18:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763663645; cv=none; b=h77V0C8//u1ammxGVZHk/H9WNqs09PjQV7WGrSqHEk2xDGvi43kMlcbfmY80nGLfpsDCWq8HsEgRTWLqjS41uhl+yNl17/N41awSTxLJpmacuVhHPxtLq4SV4CKsmaIcKbrb/Mlcc5opSz2664ansdpk2ntfZKLh/RKwvUxAKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763663645; c=relaxed/simple;
	bh=ocq3ZCox53Zolv9vp/Sg1v4CHjhwcvR8NakEs7ImFy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILey2u4G2I9uHVP5HI9fcXoig0t1utXqVXVeLUUY/G54aXt5Nz+dd3eVy8IBieI4ys9iVGLjRYOJHhdcUJiZ2uGQ9+KN4pCaucRZjtxjeJ+kN8uKeR2txWoizu4+91ap3h/yhpKksKhANBxXx1RTQLy5LKqicpfGN9pIC3cVjw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol; spf=pass smtp.mailfrom=josie.lol; dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b=HZyLRqif; arc=none smtp.client-ip=136.175.108.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=josie.lol
Received: from filter006.mxroute.com ([140.82.40.27] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta94.mxroute.com (ZoneMTA) with ESMTPSA id 19aa286c9c10004eea.009
 for <kvm@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 20 Nov 2025 18:28:53 +0000
X-Zone-Loop: a8ba760dcba9e7fbc08712cf1bc0d6b32780ee40c64d
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=josie.lol;
	s=x; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Date:
	Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=7iK3eT/igHsCpGz+HzPrT6lSKop8DXWDBOs8vF5XwZk=; b=HZyLRq
	ifs4J8zt9apQWPW3rQfzscU94E8WIeq16hS4MSJcHpJhltIYEhJKLV03dmNXk4DAaA++JCllvng3/
	yKvQ3NjIIIFh7H3KGjl2gPHo3SV25XKTQAfOce2GzHh/9uhipVKtp8SnYauWmdK9Fp3iX2oaG1dGM
	y1v318hNeGRVfNIkhoKqgeTZIBnFLnbGvK9UJovSrVgJ7IzTIl5HwqIGjOOxI+IR8qrGr5Jb1ue/p
	7V38RkHMVfmmap+d33cIdIm/BRZZIQI3JgAdq+H3K4Jk0C9bWUdoHn+ZiYIrkRxq066VhYwsHrF5J
	ucOWcr9h7V033XipJZkswe9Cee7A==;
From: Josephine Pfeiffer <hi@josie.lol>
To: borntraeger@linux.ibm.com
Cc: frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	david@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	svens@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Implement CHECK_STOP support and fix GET_MP_STATE
Date: Thu, 20 Nov 2025 19:28:49 +0100
Message-ID: <20251120182849.1109773-1-hi@josie.lol>
In-Reply-To: <3e4020ae-9fdb-46be-8f18-4319fc09c5cc@linux.ibm.com>
References: <3e4020ae-9fdb-46be-8f18-4319fc09c5cc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: hi@josie.lol

On Mon, 17 Nov 2025 19:14:57 +0100, Christian Borntraeger wrote:
> Am 17.11.25 um 16:18 schrieb Josephine Pfeiffer:
> > Add support for KVM_MP_STATE_CHECK_STOP to enable proper VM migration
> > and error handling for s390 guests. The CHECK_STOP state represents a
> > CPU that encountered a severe machine check and is halted in an error
> > state.
>
> I think the patch description is misleading. We do have proper VM
> migration and we also have error handling in the kvm module. The host
> machine check handler will forward guest machine checks to the guest.
> This logic  is certainly not perfect but kind of good enough for most
> cases.

First of all, thank you for taking the time to look at my patch, and sorry
for taking so long to write up the reply.

You're right, QEMU migrates cpu_state via vmstate [1] and only uses
KVM_SET_MP_STATE to restore the state after migration [2], never calling
KVM_GET_MP_STATE. So I misunderstood something there.

What prompted me to look into this was that the KVM API has advertised
CHECK_STOP support without implementing it. 
Looking at commit 6352e4d2dd9a [3] from 2014: "KVM: s390: implement 
KVM_(S|G)ET_MP_STATE for user space state control"

This commit added KVM_MP_STATE_CHECK_STOP to include/uapi/linux/kvm.h [4] and
documented it in Documentation/virtual/kvm/api.txt with:

  "KVM_MP_STATE_CHECK_STOP: the vcpu is in a special error state [s390]"

But the implementation was explicitly deferred with a fallthrough comment [3]:

  case KVM_MP_STATE_LOAD:
  case KVM_MP_STATE_CHECK_STOP:
      /* fall through - CHECK_STOP and LOAD are not supported yet */
  default:
      rc = -ENXIO;

This created a bit of an API asymmetry where:
- Documentation/virt/kvm/api.rst:1546 [5] advertises CHECK_STOP as valid
- KVM_SET_MP_STATE rejects it with -ENXIO
- KVM_GET_MP_STATE never returns it (always returns STOPPED or OPERATING) [6]

> Now: The architecture defines that state and the interface is certainly
> there. So implementing it will allow userspace to put a CPU into checkstop
> state if you ever need that. We also have a checkstop state that you
> can put a secure CPU in.
>
> The usecase is dubious though. The only case of the options from POP
> chapter11 that makes sense to me in a virtualized environment is an exigent
> machine check but a problem to actually deliver that (multiple reasons,
> like the OS has machine checks disabled in PSW, or the prefix register
> is broken).
>
> So I am curious, do you have any specific usecase in mind?
> I assume you have a related QEMU patch somewhere?

The use cases I see are:

1. API completeness: The state was added to the UAPI 11 years ago but never
   implemented. Userspace cannot use a documented API feature.

2. Fault injection testing: Administrators testing failover/monitoring for
   hardware failures could programmatically put a CPU into CHECK_STOP to
   verify their procedures work.

3. Protected Virtualization: The patch adds PV_CPU_STATE_CHKSTP support [7]
   for the Ultravisor, which can put secure CPUs into CHECK_STOP. Without this,
   userspace cannot detect/handle that condition.

I don't have a QEMU patch, since QEMU already handles the state internally
via cpu_state [1] and only needs KVM_SET_MP_STATE to work (which this enables).

> From a quick glance the patch in general does not look wrong but at
> least this is wrong:
> > diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
> > index 1394d3fb648f..a86e326a2eee 100644
> > --- a/arch/s390/include/asm/kvm_host_types.h
> > +++ b/arch/s390/include/asm/kvm_host_types.h
> > @@ -111,6 +111,7 @@ struct mcck_volatile_info {
> >       ((((sie_block)->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
> >
> >   #define CPUSTAT_STOPPED    0x80000000
> > +#define CPUSTAT_CHECK_STOP 0x40000000
> Bit 1 of the sie control block is a hardware defined bit and
> its meaning is not checkstop, so this is not the right way to do it.
> Lets first clarify your usecase so that we can see what the right way
> forward is.

Understood - using bit 1 of the hardware SIE control block is wrong.

I guess the correct approach would be to add a software-only flag to track CHECK_STOP
state. Unlike STOPPED (which uses CPUSTAT_STOPPED [8]), CHECK_STOP would need software 
tracking since there isn't a corresponding hardware bit with the correct meaning.

Would adding a field to struct kvm_vcpu_arch [9] be the right approach? Or is
there a better way to track this state that I'm missing?

I think completing the API makes sense, even if the use case is uncommon.

Thanks,
Josephine

References:
[1] https://github.com/qemu/qemu/blob/master/target/s390x/machine.c#L270
    VMSTATE_UINT8(env.cpu_state, S390CPU)
[2] https://github.com/qemu/qemu/blob/master/target/s390x/kvm/kvm.c#L410
    kvm_arch_init_vcpu() -> kvm_s390_set_cpu_state()
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6352e4d2dd9a
    KVM: s390: implement KVM_(S|G)ET_MP_STATE for user space state control
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/kvm.h#n596
    #define KVM_MP_STATE_CHECK_STOP 6
[5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/virt/kvm/api.rst#n1546
    KVM_MP_STATE_CHECK_STOP the vcpu is in a special error state [s390]
[6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/s390/kvm/kvm-s390.c#n4465
    kvm_arch_vcpu_ioctl_get_mpstate() implementation
[7] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/s390/include/asm/uv.h#n252
    #define PV_CPU_STATE_CHKSTP 3
[8] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/s390/include/asm/kvm_host_types.h#n113
    #define CPUSTAT_STOPPED 0x80000000 (bit 0 of SIE control block cpuflags)
[9] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/s390/include/asm/kvm_host.h#n414
    struct kvm_vcpu_arch

