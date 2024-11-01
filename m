Return-Path: <kvm+bounces-30316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8C89B9490
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 033941F21D5A
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A14D1C876F;
	Fri,  1 Nov 2024 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PClTnFcd"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FEC1ADFE8
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730475542; cv=none; b=qRsLHYJwSMJOTePxF7xtMooP+eBXrhxcGl+ytWMc+yQByQrxBvKXQkYSsHZVy4QCVmMbV0qaxMfhctIu1rCgH0/mm8Y8DSuQOrtbXbHgJpLbQeo8F+mQgSaHZfz0piEv9oGqQuKwxZTxqAV6LQlfiWt+8awTl9jvkJXbCj1bZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730475542; c=relaxed/simple;
	bh=MGpG9+U1NcrPw89BaqJoGGpatnrkgpDjLgz7qBB/IOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmqBwBTsKlWy8jkVoO4ZgI8VwuLrJ1C5+SkFEDyAdsHrPw4aTXApwOr4JHQyfZ+6Xs45DbnSQk0m2aKEHDHDHyqV8LdJh890voDwxWixRm5ECWNF4XoW7BLJGcOH+5dR9RvfBvcvumS3/p/rgUhsT836VbihgMys3VlaMYYBwmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PClTnFcd; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 1 Nov 2024 08:38:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730475537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDBDtrud5eJtuuxZyPOJXE2RSRr8v+TyeHi88AUx8RA=;
	b=PClTnFcdIrcZ78W4jSshcODMfnNiSvNFtWKdgQXgVaJZCwGgQF3dDPomr/MvL2yA9B2Cwx
	sIxnO1FBfdPS2fhSPK5ZXdGtgALWc9G1JWP6xyny1RXUjNkwgAnqURsd9JAi0B3Jon4w0B
	kiA/rkElVf8i8EK1b4eQnPfLrgKPky8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <ZyT2CB6zodtbWEI9@linux.dev>
References: <20241009154953.1073471-1-seanjc@google.com>
 <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
 <ZyTpwwm0s89iU9Pk@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZyTpwwm0s89iU9Pk@google.com>
X-Migadu-Flow: FLOW_OUT

Hey,

On Fri, Nov 01, 2024 at 07:48:00AM -0700, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Mark Brown wrote:
> > On Wed, Oct 09, 2024 at 08:49:42AM -0700, Sean Christopherson wrote:
> > > Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> > > a pointer to storage, as none of the vcpu_get_reg() usage in KVM selftests
> > > accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
> > > 64-bit value.  If a use case comes along that needs to get a register that
> > > is larger than 64 bits, then a utility can be added to assert success and
> > > take a void pointer, but until then, forcing an out param yields ugly code
> > > and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().
> > 
> > This commit, which is in today's -next as 5c6c7b71a45c9c, breaks the
> > build on arm64:
> > 
> > aarch64/psci_test.c: In function ‘host_test_system_off2’:
> > aarch64/psci_test.c:247:9: error: too many arguments to function ‘vcpu_get_reg’
> >   247 |         vcpu_get_reg(target, KVM_REG_ARM_PSCI_VERSION, &psci_version);
> >       |         ^~~~~~~~~~~~
> > In file included from aarch64/psci_test.c:18:
> > include/kvm_util.h:705:24: note: declared here
> >   705 | static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
> >       |                        ^~~~~~~~~~~~
> > At top level:
> > cc1: note: unrecognized command-line option ‘-Wno-gnu-variable-sized-type-not-at
> > -end’ may have been intended to silence earlier diagnostics
> > 
> > since the updates done to that file did not take account of 72be5aa6be4
> > ("KVM: selftests: Add test for PSCI SYSTEM_OFF2") which has been merged
> > in the kvm-arm64 tree.
> 
> Bugger.  In hindsight, it's obvious that of course arch selftests would add usage
> of vcpu_get_reg().
> 
> Unless someone has a better idea, I'll drop the series from kvm-x86, post a new
> version that applies on linux-next, and then re-apply the series just before the
> v6.13 merge window (rinse and repeat as needed if more vcpu_get_reg() users come
> along).

Can you instead just push out a topic branch and let the affected
maintainers deal with it? This is the usual way we handle conflicts
between trees...

> That would be a good oppurtunity to do the $(ARCH) directory switch[*] too, e.g.
> have a "selftests_late" or whatever topic branch.

The right time to do KVM-wide changes (even selftests) is *early* in the
development cycle, not last minute. It gives us plenty of time to iron out
the wrinkles.

> Sorry for the pain Mark, you've been playing janitor for us too much lately.

+1, appreciate your help on this.

-- 
Thanks,
Oliver

