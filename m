Return-Path: <kvm+bounces-66035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 563C4CBFB0E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A28623007740
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B44E1CDFD5;
	Mon, 15 Dec 2025 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k5NAXrya"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B9248F69
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829464; cv=none; b=d+y8eI+nqsErCr2ivAhXfyqG0jpy4aLgIxZJvDncGm+lxT/S4U9gznEausoqjNfX6i5tu1CWUbDnWiMWs7M1uuGEhKZ05ilRks5tb2JOlG0efhFfmLnbImrcpHKr/q6UIvsadQvF12rsQDoV+hf4Q0LUlCmYe5cAUHIr1zVAFek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829464; c=relaxed/simple;
	bh=q/LYhOuV2YpEyCEmejQf0P7Eu/DntrPAh8/QWUtJ6uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2vsNQIfbAIDqWkKEakCZNuUM506iD6zH0f2gqIFe1YTdnvRnKJo8VqeKKkbIQMRNkhPVliC9iYA68GSLdn8IeQ46/5er7vbRQJsPJvgYrxobu5x8PL/Tq8Q2jSe6xSFNIksYL4XRx62ofbmRtTzwpr67m9NWEOMZuVwcGNstzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k5NAXrya; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 20:10:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765829454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MOqWmgUj0AAwYWJPWLBqrj8UijMveyhjIFurgZUrRlI=;
	b=k5NAXrya1BV1jaTcgTvgVUHeeDFiTqTQrAYcqMTFLBhOwnRZLwXjQ35P0P7nXrflKf9Idz
	Mao62By3qkt1n8BujsdCzR6l6riG5Y28wRK5QCqqvKwC38/nlIeYpzZ/P0NF9DLEnmR83/
	WfJG1K62Dk0Dg2vWLP/Men50+nABFFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Message-ID: <rlwgjee2tjf26jyvdwipdwejqgsira63nvn2r3zczehz3argi4@uarbt5af3wv2>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
 <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
 <aUBjmHBHx1jsIcWJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUBjmHBHx1jsIcWJ@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 11:38:00AM -0800, Sean Christopherson wrote:
> On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> > On Mon, Dec 15, 2025 at 07:26:54PM +0000, Yosry Ahmed wrote:
> > > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > > already set correctly. This results in force_msr_bitmap_recalc always
> > > being set to true on every nested transition, essentially undoing the
> > > hyperv optimization in nested_svm_merge_msrpm().
> > > 
> > > Fix it by keeping track of whether LBR MSRs are intercepted or not and
> > > only doing the update if needed, similar to x2avic_msrs_intercepted.
> > > 
> > > Avoid using svm_test_msr_bitmap_*() to check the status of the
> > > intercepts, as an arbitrary MSR will need to be chosen as a
> > > representative of all LBR MSRs, and this could theoretically break if
> > > some of the MSRs intercepts are handled differently from the rest.
> > > 
> > > Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> > > only recently introduced with no direct alternatives in older kernels.
> > > 
> > > Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > 
> > Sigh.. I had this patch file in my working directory and it was sent by
> > mistake with the series, as the cover letter nonetheless. Sorry about
> > that. Let me know if I should resend.
> 
> Eh, it's fine for now.  The important part is clarfying that this patch should
> be ignored, which you've already done.

FWIW that patch is already in Linus's tree so even if someone applies
it, it should be fine.

