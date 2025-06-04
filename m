Return-Path: <kvm+bounces-48452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 377AFACE5EB
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 22:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00F87176065
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46DB211A11;
	Wed,  4 Jun 2025 20:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xeKrlC9z"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729D1FC0EF
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 20:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749070710; cv=none; b=iaotA2eWv/kumHtzm2OmT44OTg6bevHcJG0KNyqHvy841dIMIg5X9UoqSru+awaUUPNeDIME6TWZCBOi1C+yZCetM920GDr24lrfBmG9mVIDwbGXoZhO8uF0OZuCnXRFSbdvGEBaAkkp9M+495H/7CqdmHmkO5hVlMgihHbhdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749070710; c=relaxed/simple;
	bh=RoPbyZBxENrNdcPnruV3adrDN3KizO26jpCbgNiF/fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVL9tAiVQG8kQfTvJRryZuTcLBYA7PUJf83qyzL9tqRQC10mz9okGYLnumAhNtavyFUPU9rQYIN81hXJMgEeDpBW4NB4yyoa5ZC2ky81p9jQq7SaK6wbLw1SBLxEPqBxyMkswjYgnzqnLOgsbVG0Pf1+IPYQTEb8jFF9BSSsxNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xeKrlC9z; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Jun 2025 13:57:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749070695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AOW1xdrjziPgqyySMNuIr3SaQxi8OEOWfnwiMMxBaSE=;
	b=xeKrlC9zIC3ZmPVYMgcrLAAdA1ixnF5cvvgJyn8+c3/RJLlbX+/MB67tAaFBuiw+t0TcX3
	bT5MXuHNghyhuS4IXUcX8DCQblIYjCBZmsxRaWOO1Pg4L6QzKGiQwcYAuFS5Krli8PlayG
	Kps59HH5Y5EsnRyEyCt7qGrhtUhWWRg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 06/17] KVM: arm64: Introduce method to partition the PMU
Message-ID: <aECzTYoj1F6WHAUC@linux.dev>
References: <aD9w3Kj4-YoizKv5@linux.dev>
 <gsntsekf1d58.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntsekf1d58.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 04, 2025 at 08:10:27PM +0000, Colton Lewis wrote:
> Thank you Oliver for the additional explanation.
> 
> Oliver Upton <oliver.upton@linux.dev> writes:
> 
> > On Tue, Jun 03, 2025 at 09:32:41PM +0000, Colton Lewis wrote:
> > > Oliver Upton <oliver.upton@linux.dev> writes:
> 
> > > > On Mon, Jun 02, 2025 at 07:26:51PM +0000, Colton Lewis wrote:
> > > > >   static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> > > > >   {
> > > > > +	u8 hpmn = vcpu->kvm->arch.arm_pmu->hpmn;
> > > > > +
> > > > >   	preempt_disable();
> 
> > > > >   	/*
> > > > >   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
> > > > >   	 * to disable guest access to the profiling and trace buffers
> > > > >   	 */
> > > > > -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
> > > > > -					 *host_data_ptr(nr_event_counters));
> > > > > -	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> > > > > +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
> > > > > +	vcpu->arch.mdcr_el2 |= (MDCR_EL2_HPMD |
> > > > > +				MDCR_EL2_TPM |
> 
> > > > This isn't safe, as there's no guarantee that kvm_arch::arm_pmu is
> > > > pointing that the PMU for this CPU. KVM needs to derive HPMN from some
> > > > per-CPU state, not anything tied to the VM/vCPU.
> 
> > > I'm confused. Isn't this function preparing to run the vCPU on this
> > > CPU? Why would it be pointing at a different PMU?
> 
> > Because arm64 is a silly ecosystem and system designers can glue
> > together heterogenous CPU implementations. The arm_pmu that KVM is
> > pointing at might only match a subset of CPUs, but vCPUs migrate at the
> > whim of the scheduler (and userspace).
> 
> That means the arm_pmu field might at any time point to data that
> doesn't represent the current CPU. I'm surprised that's not swapped out
> anywhere. Seems like it would be useful to have an arch struct be a
> reliable source of information about the current arch.

There's no way to accomplish that. It is per-VM data, and you could have
vCPUs on a mix of physical CPUs.

This is mitigated somewhat when the VMM explicitly selects a PMU
implementation, as we prevent vCPUs from actually entering the guest on
an unsupported CPU (see ON_SUPPORTED_CPU flag).

> > There are two *very* distinct functions w.r.t. partitioning:
> 
> >   1) Partitioning of a particular arm_pmu that says how many counters the
> >   host can use
> 
> >   2) VMM intentions to present a subset of the KVM-owned counter
> >   partition to its guest
> 
> > #1 is modifying *global* state, we really can't mess with that in the
> > context of a single VM...
> 
> I see the distinction more clearly now. Since KVM can only control the
> number of counters presented to the guest through HPMN, why would the
> VMM ever choose a subset? If the host PMU is globally partitioned to not
> use anything in the guest range, presenting fewer counters to a guest is
> just leaving some counters in the middle of the range unused.

You may not want to give a 'full' PMU to all VMs running on a system,
but some OSes (Windows) expect to have at least the fixed CPU cycle
counter present. In this case the VMM would deliberately expose fewer
counters. FEAT_HPMN0 didn't get added to the architecture by accident...

Thanks,
Oliver

