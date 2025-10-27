Return-Path: <kvm+bounces-61234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C9525C11F44
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B5984F4217
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1D632D0EE;
	Mon, 27 Oct 2025 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWFpn1j8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F851DED64;
	Mon, 27 Oct 2025 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607050; cv=none; b=QHnpHws10QBjhjRhvM9eQqgiDWLiWLsbPsT5MvJrhXTVolTxUjG6L8CYLivbzFxhCDmmMo6wVGR4mHq9zUFuE1k/s+YRiQDvrd+lmL9KKCTwtPtXBQd2N+QhMFxhvxo026ANt3tAn0JC+M5NBzfE0lgFIUb2JuOX8NmVVBjGkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607050; c=relaxed/simple;
	bh=6OtgfqIRdZsgR1vejKSr5be3N8OY5BHziSmvSqV5jpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlJ65NmOkJVhFrHlUQh7cdTi48C1N09ISpbAfS9PGsMc+0rEf4jlyLoHuDZVeUxxDixm60iJKTl67wd8NsooRMlD34fWf6pSOzdClT2Nl3RakhillpaPFgpLKLp9rkNw7otfMOQgMSPot7F+7UOwN4rHli5MiHc7NKDYVd1iKjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWFpn1j8; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761607049; x=1793143049;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6OtgfqIRdZsgR1vejKSr5be3N8OY5BHziSmvSqV5jpg=;
  b=jWFpn1j8EOYaY9pL0j5R1OMILl6SfE0/BthX65xbJpQXjiWR5exYac/e
   RQkt253LerDlFJB9UzNF8L8P7yHeyRksHzLaNwtf4ytRXjw/ZKq3JtzG9
   BG8+/Zl9LrAAy/xo16DvRo3ELgH1+JLQghO4HbMwo3GHwglyrvPJjgdlu
   burCvOsHIhlmDOI0OG4L9gRJoWF2UxpKZABPRDG6n/G/ZY0O2EkBInVmX
   Z674pVZIwzcU3fc7nmv5XVvui9zxXkaAb1TTbvyRJc95AeK/CGfx4Y2PG
   +83dEkbOAh2B9NL5cjMUBsDm+87Dk/bGm+vGLZoBP0l7kqmF7eCjWhvI4
   g==;
X-CSE-ConnectionGUID: xqxbQppmSgO7YwGvxKXctw==
X-CSE-MsgGUID: NMdzvI8BTt60fFzy4QVHMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63736746"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="63736746"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:17:28 -0700
X-CSE-ConnectionGUID: CvC83en+Q7Ccr1143GwIyA==
X-CSE-MsgGUID: jgNyviWIS6+sq/55QdfWAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="184882532"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:17:28 -0700
Date: Mon, 27 Oct 2025 16:17:21 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251027231721.irprdsyqd2klt4bf@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
 <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk>
 <20251022012021.sbymuvzzvx4qeztf@desk>
 <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com>

On Mon, Oct 27, 2025 at 03:03:23PM -0700, Jim Mattson wrote:
> On Tue, Oct 21, 2025 at 6:20 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > ...
> > Thinking more on this, the software sequence is only invoked when the
> > system doesn't have the L1D flushing feature added by a microcode update.
> > In such a case system is not expected to have a flushing VERW either, which
> > was introduced after L1TF. Also, the admin needs to have a very good reason
> > for not updating the microcode for 5+ years :-)
> 
> KVM started reporting MD_CLEAR to userspace in Linux v5.2, but it
> didn't report L1D_FLUSH to userspace until Linux v6.4, so there are
> plenty of virtual CPUs with a flushing VERW that don't have the L1D
> flushing feature.

Shouldn't only the L0 hypervisor be doing the L1D_FLUSH?

kvm_get_arch_capabilities()
{
...
        /*
         * If we're doing cache flushes (either "always" or "cond")
         * we will do one whenever the guest does a vmlaunch/vmresume.
         * If an outer hypervisor is doing the cache flush for us
         * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
         * capability to the guest too, and if EPT is disabled we're not
         * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
         * require a nested hypervisor to do a flush of its own.
         */
        if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
                data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;


