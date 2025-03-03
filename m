Return-Path: <kvm+bounces-39920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E57C8A4CBE9
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 20:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19C791712A2
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FEA33F6;
	Mon,  3 Mar 2025 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CaB7/lnJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DE9171A1
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 19:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741029539; cv=none; b=ZzKomazfj0H0yj7AGgr4FE5aF255Qfj0nICMAPtbYLl1r8jYBGMKblOVVrvZCagDgLT3tymkOrFErZyocJOdR5M2q7OxF2GMBUU2d/T64qlxznOXTgzkm6nFOv4tTKN2bC4RVXEapUtcIDjhmG6bHmxG5LSvN3xjz8694JdO0d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741029539; c=relaxed/simple;
	bh=i0xKwn6Yi5dkkeqqR1TOuISGKY92j3VUghHea48WNHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzmetFD63MqiQAma3vfI43dERKE8Epz/HRXT1ISMBEscGB902nUlTr3oCjoLNjvTLT4b2nVh4JQFqyc5J9pS2RYjAK0o+C+s3jjxLA9bN6j+SHFENcdxcQOECycAGL6WxXN5ZGFKjbCwA4v46BG8jcoMOS0W3c8iwq6RVsbSiY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CaB7/lnJ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 19:18:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741029534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvlLy63C4pAhyP3doWxsBOQLA/O5IqeEO2OLT5Y0i38=;
	b=CaB7/lnJYU5fMT37I/1zOkWM087nXR5wpS86GAIU3fDtJZ0VfAnrWR/nHiXsvisq/njS9Y
	BZLT9Sd6t9UwXljH+RlUGPvklIyGVUA2tSJX/JSzHYf9k0xHIbZkEDMkPYj+k1sU61T2ai
	S/sr3U5ssYERWkORs7xkGA2tG3x0Bqg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
Message-ID: <Z8YAmU4neF2PvpkJ@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-2-yosry.ahmed@linux.dev>
 <Z8JOvMx6iLexT3pK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8JOvMx6iLexT3pK@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 04:03:08PM -0800, Sean Christopherson wrote:
> +Jim, for his input on VPIDs.
> 
> On Wed, Feb 05, 2025, Yosry Ahmed wrote:
> > The ASID is currently tracked per-vCPU, because the same ASID is used by
> > L1 and L2. That ASID is flushed on every transition between L1 and L2.
> > 
> > Track the ASID separately for each VMCB (similar to the
> > asid_generation), giving L2 a separate ASID. This is in preparation for
> > doing fine-grained TLB flushes on nested transitions instead of
> > unconditional full flushes.
> 
> After having some time to think about this, rather than track ASIDs per VMCB, I
> think we should converge on a single approach for nVMX (VPID) and nSVM (ASID).
> 
> Per **VM**, one VPID/ASID for L1, and one VPID/ASID for L2.
> 
> For SVM, the dynamic ASID crud is a holdover from KVM's support for CPUs that
> don't support FLUSHBYASID, i.e. needed to purge the entire TLB in order to flush
> guest mappings.  FLUSHBYASID was added in 2010, and AFAIK has been supported by
> all AMD CPUs since.

This means that for these old CPUs, every TLB flush done for the guest
will also flush the TLB entries of all other guests and the host IIUC. I
am not sure what CPUs around do not support FLUSHBYASID, but this sounds
like a big regression for them.

I am all for simplifying the code and converging nVMX and nSVM, but I am
a bit worried about this. Sounds like you are not though, so maybe I am
missing something :P

I initially that that the ASID space is too small, but it turns out I
was confused by the ASID messages from the SEV code. The max number of
ASIDs seems to be (1 << 15) on Rome, Milan, and Genoa CPUs. That's half
of VMX_NR_VPIDS, and probably good enough.

> 
> KVM already mostly keeps the same ASID, except for when a vCPU is migrated, in
> which case KVM assigns a new ASID.  I suspect that following VMX's lead and
> simply doing a TLB flush in this situation would be an improvement for modern
> CPUs, as it would flush the entries that need to be flushed, and not pollute the
> TLBs with stale, unused entries.
> 
> Using a static per-VM ASID would also allow using broadcast invalidations[*],
> would simplify the SVM code base, and I think/hope would allow us to move much
> of the TLB flushing logic, e.g. for task migration, to common code.
> 
> For VPIDs, maybe it's because it's Friday afternoon, but for the life of me I
> can't think of any reason why KVM needs to assign VPIDs per vCPU.  Especially
> since KVM is ridiculously conservative and flushes _all_ EPT/VPID contexts when
> running a different vCPU on a pCPU (which I suspect we can trim down?).

I think for the purpose of this series we can switch SVM to use one ASID
per vCPU to match the current nVMX behavior and simplify things. Moving
both nSVM and nVMX to use a single ASID per VM instead of per vCPU, and
potentially moving some of the logic to the common code, could be a
separate followup effort (maybe something that I can work on later this
year if no one picks it up :) ).

WDYT?

> 
> Am I forgetting something?
> 
> [*] https://lore.kernel.org/all/Z8HdBg3wj8M7a4ts@google.com

