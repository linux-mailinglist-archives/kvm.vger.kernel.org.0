Return-Path: <kvm+bounces-64017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B308C76BBA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 84AC7356D8C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C432222D0;
	Fri, 21 Nov 2025 00:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bgLx+BDq"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C67D13E02A
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684421; cv=none; b=uTd53xauGgbe4VYAaYA+ADt2dELrtLEHV5FpaQZDYmMrXAH9R3DMPNZrq7uxV6re088XSRGexPDZZ1kHynOqSavnRzhGadiV/r9Fp5CZpu3NhtQOvL3EUhdhbkDXx+TiAi80dnwmRQ5/1QWS37lvu+PUArRWEsEDR2MS1f6BAGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684421; c=relaxed/simple;
	bh=D/ewtZSpBCFHNVdbIzFWoWwQibP1I8mpa9SiVoqivfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCb6WjCMQhsMZsg1a8K0wMvSc24YbWLjyB78ip1aBrmyMH18X2uXIwl7aOmAe16jB0REuK1+pLSpDnRDjMGhYy/8kRyDmYWIN9X5Bo19uJcbf7IWxdaiTzdlB9vlpLWXWCsPn/uzict/wrZ4Y37KPbw3uhbFAaWWqpQf/OyQoFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bgLx+BDq; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Nov 2025 00:20:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763684417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdFfOTE5Oe6n6i2bafb8PahAhBBEyq4Zl+IlfHn9wSo=;
	b=bgLx+BDqpyaECbdtorDL9HOCIHeYW8rINJBYaXkS/hsbW2w5odXg0fP+Qu5ILnuNc9lzjW
	UU1b9O1u9BFZsKkKwTjUwwcViwY+lSjT0Imqp2oy0su8BAbFaMKaJgKXCg+hv/dpr/gnVx
	JOR+e6+WW8W1aUVaZm2fJjXJhzVrwJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 18/23] KVM: selftests: Generalize nested mapping
 functions
Message-ID: <bkwzbzd4g4rhr64jisdjfd73ldfiowubdo5swuoji6jryxxehd@vujif5jswg4j>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <20251021074736.1324328-19-yosry.ahmed@linux.dev>
 <aR-uC-afVZYKfdLC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-uC-afVZYKfdLC@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 04:10:51PM -0800, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> > Instead of passing in a pointer to struct vmx_pages, pass in the GPA of
> > the root of the EPTs, as that's the only member being used. Furthermore,
> > only use ept_pte_masks for VMX, and use x86_pte_masks otherwise (which
> > is what NPT uses).
> > 
> > This is in preparation of supporting NPTs as well.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/include/x86/vmx.h |  6 +++---
> >  .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
> >  tools/testing/selftests/kvm/lib/x86/vmx.c     | 20 ++++++++++---------
> >  .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 +++---
> >  4 files changed, 19 insertions(+), 17 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
> > index 5aa14ceed050a..4429e83e1f52c 100644
> > --- a/tools/testing/selftests/kvm/include/x86/vmx.h
> > +++ b/tools/testing/selftests/kvm/include/x86/vmx.h
> > @@ -561,11 +561,11 @@ bool load_vmcs(struct vmx_pages *vmx);
> >  
> >  bool ept_1g_pages_supported(void);
> >  
> > -void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> > +void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
> >  		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
> > -void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
> > +void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
> >  			uint32_t memslot);
> > -void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
> > +void nested_identity_map_1g(struct kvm_vm *vm, vm_paddr_t root_gpa,
> >  			    uint64_t addr, uint64_t size);
> 
> Ugh, "nested" is a bad namespace.  Running L2 doesn't strictly require nested
> TDP, and the operations themselves are non-nested, in the sense that we're
> modifying stage-2 / TDP page tables.
> 
> My vote would be to do a rename to either stage2_pg_map() or tdp_pg_map()

It is 'nested' in the since that we are creating mappings in nested TDP
(i.e. not L0's TDP), but I guess that doesn't make much sense given that
most selftests library functions are already referring to the guest
anyway.

I will use tdp_pg_map() only because that's the common x86 terminology
(although I do like stage2 better in general).

