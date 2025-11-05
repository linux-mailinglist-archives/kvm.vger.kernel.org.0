Return-Path: <kvm+bounces-62104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD72DC377AD
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B7CD34EF5C
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F3F33F360;
	Wed,  5 Nov 2025 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VQnFthLo"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E00E242D9D;
	Wed,  5 Nov 2025 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370990; cv=none; b=cqly1qT9/SeOjOMzKOXqjmx7DjxGW+iB+43v3yQiF1BMWMnzKQxo1BR1bj8VDtU9o2DwNQswmJCWjRM1aubKTO8vNZ2aISqLSj1SHqW1wZ8yBe1ffN9NCmzvsA0sg4oE0XrWhW7OgE7IOZDGSlV3eiIbqmC2HtPAMxN4kYgTdj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370990; c=relaxed/simple;
	bh=LkTG1zHXP6J3ZFzi+KMBwvboVw8ILLtSPGXHXcUZcWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDp1YMVPjyuELXrnKtmqRLpNHRq1emqn55g9xwwZv9Gbv79jYxIwbq8STg1IxD5vObBqeUoBq/Kp57sDIP66+ycy4FCX91ZGOn6/DKG/oAcElALCDr5/lXuMxHtq3L735x2WGqd1H29mWUgVMK1p5Yo6BRPO2Jc2zc+uJ83y0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VQnFthLo; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Nov 2025 19:29:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762370986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2s6Xz6N3ffaHvjBBNrhTy35NZz3ibcESxZXNI2iVCDU=;
	b=VQnFthLoiT+e1qXntQwDrVbiMWS/KXuxW1RoRoc+xce3OIrTF8ohXSO5O+QNjfDQcMvj8/
	EMC9lKefT/eqZLl775vJ/otAZ8SkrvO0cQZpfZLPW5D+7+N+KNY0JLA9ckqgGVbTNhqxZ9
	ApMfIBTw22HV19ubjlcrMameXpMAWtU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] KVM: nSVM: Add missing consistency check for
 event_inj
Message-ID: <heahqrdiujkusb42hir3qbejwnc6svspt3owwtat345myquny4@5ebkzc6mt2y3>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
 <20251104195949.3528411-4-yosry.ahmed@linux.dev>
 <aQub_AbP6l6BJlB2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQub_AbP6l6BJlB2@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 05, 2025 at 10:48:28AM -0800, Sean Christopherson wrote:
> On Tue, Nov 04, 2025, Yosry Ahmed wrote:
> > According to the APM Volume #2, 15.20 (24593—Rev. 3.42—March 2024):
> > 
> >   VMRUN exits with VMEXIT_INVALID error code if either:
> >   • Reserved values of TYPE have been specified, or
> >   • TYPE = 3 (exception) has been specified with a vector that does not
> >     correspond to an exception (this includes vector 2, which is an NMI,
> >     not an exception).
> > 
> > Add the missing consistency checks to KVM. For the second point, inject
> > VMEXIT_INVALID if the vector is anything but the vectors defined by the
> > APM for exceptions. Reserved vectors are also considered invalid, which
> > matches the HW behavior.
> 
> Ugh.  Strictly speaking, that means KVM needs to match the capabilities of the
> virtual CPU.  E.g. if the virtual CPU predates SEV-ES, then #VC should be reserved
> from the guest's perspective.
> 
> > Vector 9 (i.e. #CSO) is considered invalid because it is reserved on modern
> > CPUs, and according to LLMs no CPUs exist supporting SVM and producing #CSOs.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/include/asm/svm.h |  5 +++++
> >  arch/x86/kvm/svm/nested.c  | 33 +++++++++++++++++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index e69b6d0dedcf0..3a9441a8954f3 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -633,6 +633,11 @@ static inline void __unused_size_checks(void)
> >  #define SVM_EVTINJ_VALID (1 << 31)
> >  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> >  
> > +/* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_TYPE_EXEPT */
> > +#define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_ULL(15) | \
> > +				    BIT_ULL(20) | GENMASK_ULL(27, 22) | \
> > +				    BIT_ULL(31))
> 
> As above, hardcoding this won't work.  E.g. if a VM is migrated from a CPU where
> vector X is reserved to a CPU where vector X is valid, then the VM will observe
> a change in behavior. 
> 
> Even if we're ok being overly permissive today (e.g. by taking an erratum), this
> will create problems in the future when one of the reserved vectors is defined,
> at which point we'll end up changing guest-visible behavior (and will have to
> take another erratum, or maybe define the erratum to be that KVM straight up
> doesn't enforce this correctly?)
> 
> And if we do throw in the towel and don't try to enforce this, we'll still want
> a safeguard against this becoming stale, e.g. when KVM adds support for new
> feature XYZ that comes with a new vector.
> 
> Off the cuff, the best idea I have is to define the positive set of vectors
> somewhere common with a static assert, and then invert that.  E.g. maybe something
> shared with kvm_trace_sym_exc()?

Do you mean define the positive set of vectors dynamically based on the
vCPU caps? Like a helper returning a dynamic bitmask instead of
SVM_EVNTINJ_INVALID_EXEPTS?

If we'll reuse that for kvm_trace_sym_exc() it will need more work, but
I don't see why we need a dynamic list for kvm_trace_sym_exc().

So my best guess is that I didn't really understand your suggestion :)

