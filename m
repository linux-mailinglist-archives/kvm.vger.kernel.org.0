Return-Path: <kvm+bounces-47910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE638AC721C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 22:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 046893B29CF
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 20:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9D9220F24;
	Wed, 28 May 2025 20:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lWaSbmne"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACEF8F6B;
	Wed, 28 May 2025 20:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748463734; cv=none; b=qWNT/4gLEekoc7Hh/GrTgKda2cooJSPXY69t8qqZQ4uoHEdphwubhtw05easlYbKvMaYiBHA2sxGNMviTxATqqz0scfB3inKkgVYaSLuyQ1Ht03zI6iVcsp7hCwjg5WXLUAsVW53caYOWlAjlvgRT3OsX49qhwavYz0N5DYt4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748463734; c=relaxed/simple;
	bh=ZI6VQPkrPer19ZEC9jKMXXA3lE38+GZfUoNzjphj3ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXehIs7iK6tzrN2SbYySDrOlZ8UdoXVLaGISxVX8tuneUTNRodEVljW6ME2F/T1uh1q0EK3f8xuUmGJatrFTFw9j9FZvjecV8DFgbiAPS/WCPd2SVMX+Bd2NDXKaDabnRN+mcZ57OoHdXBEnez9z7aXswyLi04nytclgHXqHq98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lWaSbmne; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 May 2025 13:21:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748463720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJF9HWy7wkusHjQ5XOzTnD26subHMVamVnoXMJ3j9ys=;
	b=lWaSbmnesIXm8TvqRaGJyb4mtKLnRTErMhmaV0isdSqCDAUXJtv5slw7A+8jLeTIwU6k5M
	kLCq8ZAZWXOIGy3Um5AcDj1pA7a6FPgFpMMw0brsDPLtDla6O0Bq85rKGuqthWj+wjKRdo
	1X29WU4k78nHFAS3E3MD/bNL587ZQAE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
Message-ID: <aDdwXrbAHmVqu0kA@linux.dev>
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-6-jthoughton@google.com>
 <aBqj3s8THH9SFzLO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBqj3s8THH9SFzLO@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 06, 2025 at 05:05:50PM -0700, Sean Christopherson wrote:
> > +	if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> > +	    (change == KVM_MR_FLAGS_ONLY)) {
> > +		if (old_flags & KVM_MEM_USERFAULT)
> > +			kvm_mmu_recover_huge_pages(kvm, new);
> > +		else
> > +			kvm_arch_flush_shadow_memslot(kvm, old);
> 
> The call to kvm_arch_flush_shadow_memslot() should definitely go in common code.
> The fancy recovery logic is arch specific, but blasting the memslot when userfault
> is toggled on is not.

Not like anything in KVM is consistent but sprinkling translation
changes / invalidations between arch and generic code feels
error-prone. Especially if there isn't clear ownership of a particular
flag, e.g. 0 -> 1 transitions happen in generic code and 1 -> 0 happens
in arch code.

Even in the case of KVM_MEM_USERFAULT, an architecture could potentially
preserve the stage-2 translations but reap access permissions without
modifying page tables / TLBs.

I'm happy with arch interfaces that clearly express intent (make this
memslot inaccessible), then the architecture can make an informed
decision about how to best achieve that. Otherwise we're always going to
use the largest possible hammer potentially overinvalidate.

Thanks,
Oliver

