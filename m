Return-Path: <kvm+bounces-31926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87EF89CDBE8
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 349091F229BE
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7520A1AF0D7;
	Fri, 15 Nov 2024 09:53:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EF91AC428
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 09:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731664393; cv=none; b=CPE+rCZV4JyBXnvezWDeIgalp5Z+2a40hkb/FrIm41LWukNt1sRwxvUCrqsEjmrRh2A9VTCa7YPPUN43GCq3zc5jnKOoOTBeXybonqc8ZP6pCAymqWb6P4mW3yhiIWdBwUkIYDgnFyWh+Zmicv/PI+p/j4SY+6k8F9KVYJd3MkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731664393; c=relaxed/simple;
	bh=xoBXg6UDKS4/KB1/cETrK/4sAKvKPuYKl2oyR/CE+ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bc6dyFUZNegLusaEDqZQYoEVukq3018eMut2iMOX9PpCnBiTWLKUdSwveMJQUg/zdtEcHZfZk29TJ7ksLRwVy/GeIVrWBHkQNE+cgiTX7LzU1/zNwjJK818yG3cOPIhuazkgENolySPVYgxUW2IqtpT7afrRiD4yjtdGAId8Lfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tBsN0-00COIx-1P;
	Fri, 15 Nov 2024 10:12:02 +0100
Date: Fri, 15 Nov 2024 10:12:02 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexander Graf <graf@amazon.de>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Message-ID: <ZzcQYoExgpAzItdp@mias.mediconcil.de>
References: <20241018100919.33814-1-bk@alpico.io>
 <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
 <ZyOvPYHrpgPbxUtX@google.com>
 <ZyPjwW55n0JHg0pu@mias.mediconcil.de>
 <ZyQS8AhrBFS6nZuq@google.com>
 <ZySXgqcYKoHJ3jcf@mias.mediconcil.de>
 <ZyTqZk88JbE3EcTk@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyTqZk88JbE3EcTk@google.com>

On Fri, Nov 01, 2024 at 07:49:10AM -0700, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Bernhard Kauer wrote:
> > On Thu, Oct 31, 2024 at 04:29:52PM -0700, Sean Christopherson wrote:
> > > With a userspace APIC, the roundtrip to userspace to emulate the EOI is measured
> > > in tens of thousands of cycles.  IIRC, last I played around with userspace exits
> > > the average turnaround time was ~50k cycles.
> > 
> > 
> > That sound a lot so I did some quick benchmarking.  An exit is around 1400
> > TSC cycles on my AMD laptop, instruction emulation takes 1200 and going
> > to user-level needs at least 6200.  Not terribly slow but still room for
> > optimizations.
> 
> Ah, I suspect my recollection of ~50k cycles is from measuring all exits to
> userspace, i.e. included the reaaaaly slow paths.

I finally found the reason for the slow user-level roundtrip on my Zen3+
machine.

Disabling SRSO with spec_rstack_overflow=off improves the user-level part
by 3x.  The exit as well as the instruction emulation overhead is down by 40%.

Thus without SRSO a roundtrip to user-level needs roughly 2000 cycles.


                        SRSO=off        default         factor
INSTR   CPUID           1008            1394            1.4x
        RDMSR           1072            1550            1.4x
MMIO    APIC            1666            2609            1.6x
        IOAPIC          1783            2800            1.6x
        HPET            3626            9426            2.6x
PIO     PIC             1250            1804            1.4x
        UART            2837            8011            2.8x


