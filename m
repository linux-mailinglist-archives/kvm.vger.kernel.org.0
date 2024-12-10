Return-Path: <kvm+bounces-33392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 464A69EAA69
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07374286A49
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 08:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1061023099F;
	Tue, 10 Dec 2024 08:16:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EEA2309A7
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 08:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733818617; cv=none; b=LxXroMJ/66jxAiMqGe2dS5gO0DdXF/CXFrvBWTabSRDkM6kJv6fNTqSMw/487Uzo5K4YW227GvwCyE+HeiH8gcb9gtfO+ovajEnE0mH6VdGqPyrA7YVqak3nK3ooAQn5UE7c3Nx341W2JagNPco03f4fxoMknQ+Iv6PNZSylb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733818617; c=relaxed/simple;
	bh=extk9TCQIKx7iP8Tp6ST/a0IBzn1bqOSaZSDcUfyZa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYAyrxpJq6XHKYUa42OWyTXY/y1iqZp0xVvpYPGFibx8vpn9ql7n28rk0nX0vZi1LSoblPtnMOZoJ/FeycquP5hjm8P65LhrWtn9esuQBl5LWQ1JBS6crby3fu0nBA/eMBTPIzH42CRGBuDKOIEiEFwYoMLzIjIpUyhjyrDgo9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=pass smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tKvQ5-005Jwu-14;
	Tue, 10 Dec 2024 09:16:37 +0100
Date: Tue, 10 Dec 2024 09:16:37 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
Message-ID: <Z1f45XzpgDMC2cvI@mias.mediconcil.de>
References: <20241021102321.665060-1-bk@alpico.io>
 <Z1eXyv2VVsFiw_0i@google.com>
 <Z1ecILHBlpkiAThl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1ecILHBlpkiAThl@google.com>

On Mon, Dec 09, 2024 at 05:40:48PM -0800, Sean Christopherson wrote:
> On Mon, Dec 09, 2024, Sean Christopherson wrote:
> > On Mon, Oct 21, 2024, Bernhard Kauer wrote:
> > > It used a static key to avoid loading the lapic pointer from
> > > the vcpu->arch structure.  However, in the common case the load
> > > is from a hot cacheline and the CPU should be able to perfectly
> > > predict it. Thus there is no upside of this premature optimization.
> > > 
> > > The downside is that code patching including an IPI to all CPUs
> > > is required whenever the first VM without an lapic is created or
> > > the last is destroyed.
> > >
> > I'm on the fence, slightly leaning towards removing all three of these static keys.

Thanks for continuing this work.


> > With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
> > goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
> > (mostly laziness), the average latency goes from 1034 => 1053.

Are these kind of benchmarks tracked somewhere automatically?  With it one
could systematically optimize for faster exits.


> > On the other hand, we lose gobs and gobs of cycles with far less thought.  E.g.
> > with mitigations on, the latency for a single vCPU jumps all the way to 1600+ cycles.

In the end it is a tradeoff to be made.  The cost for switching between the
modes is more than a hundred microsecond unexpected latency.  On the other
hande one saves 1-2% per exit but has a larger code-base.



