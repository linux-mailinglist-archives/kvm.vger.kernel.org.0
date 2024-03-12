Return-Path: <kvm+bounces-11654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B841879263
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 11:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6C77B22EA0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 10:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337497867E;
	Tue, 12 Mar 2024 10:46:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E13277F3D
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710240390; cv=none; b=c4tpdRGj+oNmN37kPUEutuhzWG0Jw27RRIWeXzHUJ4HKMurA+H9rz1TgL8pOrZtqzsCFVIo8NSHratiAPISnlv9RzIpGQGizCUwCthkitdqweytyPRNCV38aR2NVbkjcD5+tuivdVtGZNlZMwU6+IYAfDrPOjvMnGmZ1A93VTdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710240390; c=relaxed/simple;
	bh=aMWIMFerMoxckhVONWKIWdYyU1jRwlWL/JHFglW8VcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIafZQ3q2KS/MaYWyo/+sLa/DlTQIEr7/UcRQJPl8pvNVsi9oUclIsAGw8SQyOeUp7YU9vEo1RMrq7ts9Q9HOi7tg9p3fjSafo9SM3mUs19iwUiunuLmJN8bM4z+upocS9n/q4nkXIU6FKI8GYT3qJ7iiiOD8okcYHIF6AupB5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8572C1007;
	Tue, 12 Mar 2024 03:47:05 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C54243F73F;
	Tue, 12 Mar 2024 03:46:26 -0700 (PDT)
Date: Tue, 12 Mar 2024 10:46:20 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 11/13] KVM: arm64: nv: Add emulation for ERETAx
 instructions
Message-ID: <20240312104620.GA1632258@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-12-maz@kernel.org>
 <20240308172059.GA1052268@e124191.cambridge.arm.com>
 <86h6hg1uer.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h6hg1uer.wl-maz@kernel.org>

On Fri, Mar 08, 2024 at 05:54:20PM +0000, Marc Zyngier wrote:
> On Fri, 08 Mar 2024 17:20:59 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Phew..
> 
> [...]
> 
> > Each function in this file is quite small, but there's certainly a lot of
> > complexity and background knowledge required to understand them!
> > 
> > I spent quite some time on each part to see if it matches what I understood
> > from the Arm ARM.
> > 
> > Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> 
> Thanks a lot for putting up with it, much appreciated.
> 
> > A side note / thing I considered. KVM doesn't currently handle ERET exceptions
> > from EL1.
> 
> EL1 is ambiguous here. Is that EL1 from the PoV of the guest?

Yes I meant an EL1 guest (not vEL2).

> 
> >
> > 1. If an ERETA{A,B} were executed from a nested EL1 guest, that would be
> > trapped up to Host KVM at EL2.
> 
> There are two possibilities for that (assuming EL1 from the PoV of a
> L1 guest):
> 
> (1) this EL1 guest is itself a guest hypervisor (i.e. we are running
>     an L1 guest which itself is using NV and running an L2 which
>     itself is a hypervisor). In that case, ERET* would have to be
>     trapped to EL2 and re-injected. Note that we do not support NV
>     under NV. Yet...
> 
> (2) the L2 guest is not a hypervisor (no recursive NV), but the L1
>     hypervisor has set HFGITR_EL2.ERET==1. We'd have to re-inject the
>     exception into L1, just like in the precedent case.
> 
> If neither HCR_EL2.NV nor HFGITR_EL2.ERET are set, then no ERET* gets
> trapped at all. Crucially, when running an L2 guest that doesn't isn't
> itself a hypervisor (no nested NV), we do not trap ERET* at all.

That was the missing part. __compute_hcr() only adds HCR_EL2.NV when
is_hyp_ctxt() is true. When I conjured up this scenario, I had HCR_EL2.NV set
(in my head) for the L2 EL1 guest, which is not the case.

> 
> In a way, the NV overhead is mostly when running L1. Once you run L2,
> the overhead "vanishes", to some extent (as long as you don't exit,
> because that's where the cost is).
> 
> > 2. kvm_hyp_handle_eret() returns false since it's not from vEL2.  Inside
> > kvm_handle_eret(), is_hyp_ctxt() is false so the exception is injected into
> > vEL2 (via kvm_inject_nested_sync()).
> > 
> > 3. vEL2 gets the exception, kvm_hyp_handle_eret() returns false as before.
> > Inside kvm_handle_eret(), is_hyp_ctxt() is also false, so
> > kvm_inject_nested_sync() is called but now errors out since vcpu_has_nv() is
> > false.
> > 
> > Is that flow right? Am I missing something?
> 
> I'm not sure. The cases where ERET gets trapped are really limited to
> the above two cases.
> 

Thanks for the explanation,

Joey

