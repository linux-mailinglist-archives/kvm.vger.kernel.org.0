Return-Path: <kvm+bounces-44574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D350A9F2C1
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECA101A82AC0
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 13:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD46326A1AA;
	Mon, 28 Apr 2025 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fvk7aIFz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0CA269B0D
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745848277; cv=none; b=CNnJS522y9oycPXzggHLui2tfvUptGb+CL2SqikjsXObhh+E5wW6iuPU4s9w4gpPkNXqq6VaUzyoFdyFFYLzHGTN6YO5871qT9q1b4k9rPFO2d2YjwIesnmwsrtmg5QuGTOcSRxnxmCgaw2JAdZ5yWWY5ri4VUvSLdxqSeKSS80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745848277; c=relaxed/simple;
	bh=VsHmrNXKviIE8IQ9R1HhlyLdam+mB76jNTS9v/imXWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAlefjPy4bhwNfow/LHcWd2U00Thimfb9g9pyFe/32D7L7IVp355eUhHZJZ8vmhMZWcPFWBfyXmfEIvILSzH0UkkgAswaELnfTlEXhgqo6W5JasiO1eUCt8QNcCncorLeY0G9uqmDcbAC4tl4Uk/TE7ST4szUJerUt8mPIPwHzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fvk7aIFz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745848275; x=1777384275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VsHmrNXKviIE8IQ9R1HhlyLdam+mB76jNTS9v/imXWs=;
  b=Fvk7aIFzAshoWJl9tPkmcUnpX/pAk1CPsJ7AKpY0exbdUuwljd/UQ9Wg
   euojlhFoKBlBBJSSJdDGq6AddlRzIyeQO3D1PrLPEf18vPtd40oTa4XIo
   J8GUX5oKwLEmE64QOOpwzURty2ijEbjnqzNR58cYOGoxckLmTTM5f2G44
   7Kj7jB5jQMh6SLV/bh2mXYjXtZeyUt/n/l0tu2MKGl5z2jfFOwbbpTqEY
   0+Lg4XVug2SkM3fH41dBfO57yMWc1ScdEM3LdXMNXFab1C81Mobscx4wA
   vEUVVmzOJZQO4DieMHyOMNiUNb22RCu2m0Qlp+PErf9xeUXUnBK8Uo+Gd
   w==;
X-CSE-ConnectionGUID: CBKNITfoSYCk/sbV4ixrjw==
X-CSE-MsgGUID: 0Fgd5atWRxC5xkCq2JS5wQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="58085735"
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="58085735"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 06:51:14 -0700
X-CSE-ConnectionGUID: 9rsWKEuKTXSkzsns7eGPDg==
X-CSE-MsgGUID: mHZMTY5nS4exFTHFKWI5vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="164487636"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 28 Apr 2025 06:51:09 -0700
Date: Mon, 28 Apr 2025 22:12:06 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 2/5] i386/kvm: Support basic KVM PMU filter
Message-ID: <aA+MttdYlZKPAwqT@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-3-zhao1.liu@intel.com>
 <878qnoha3j.fsf@pond.sub.org>
 <aA3sLRzZj2270cSs@intel.com>
 <87r01c3jd2.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r01c3jd2.fsf@pond.sub.org>

On Mon, Apr 28, 2025 at 08:12:09AM +0200, Markus Armbruster wrote:
> Date: Mon, 28 Apr 2025 08:12:09 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 2/5] i386/kvm: Support basic KVM PMU filter
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > ...
> >
> >> > diff --git a/qemu-options.hx b/qemu-options.hx
> >> > index dc694a99a30a..51a7c61ce0b0 100644
> >> > --- a/qemu-options.hx
> >> > +++ b/qemu-options.hx
> >> > @@ -232,7 +232,8 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
> >> >      "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
> >> >      "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
> >> >      "                thread=single|multi (enable multi-threaded TCG)\n"
> >> > -    "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
> >> > +    "                device=path (KVM device path, default /dev/kvm)\n"
> >> > +    "                pmu-filter=id (configure KVM PMU filter)\n", QEMU_ARCH_ALL)
> >> 
> >> As we'll see below, this property is actually available only for i386.
> >> Other target-specific properties document this like "x86 only".  Please
> >> do that for this one, too.
> >
> > Thanks! I'll change QEMU_ARCH_ALL to QEMU_ARCH_I386.
> 
> That would be wrong :)
> 
> QEMU_ARCH_ALL is the last argument passed to macro DEF().  It applies to
> the entire option, in this case -accel.

Thank you for correction! I didn't realize this point :-(.

> I'd like you to mark the option parameter as "(x86 only)", like
> notify-vmexit right above, and several more elsewhere.

Sure, I see. This option has already provided good example for me.

> >> As far as I can tell, the kvm-pmu-filter object needs to be activated
> >> with -accel pmu-filter=... to do anything.  Correct?
> >
> > Yes,
> >
> >> You can create any number of kvm-pmu-filter objects, but only one of
> >> them can be active.  Correct?
> >
> > Yes! I'll try to report error when user repeats to set this object, or
> > mention this rule in doc.
> 
> Creating kvm-pmu-filter objects without using them should be harmless,
> shouldn't it?  I think users can already create other kinds of unused
> objects.

I think I understand now. Indeed, creating an object should be allowed
regardless of whether it's used, as this helps decouple "-object" from
other options.

I can add something that:

the kvm-pmu-filter object needs to be activated with "-accel pmu-filter=id",
and only when it is activated, its filter policy can be passed to KVM.

(A single sentence is just an example; I think it needs to be carefully
refined within the context of the entire paragraph :-).)

> >> > +
> >> > +static int kvm_install_pmu_event_filter(KVMState *s)
> >> > +{
> >> > +    struct kvm_pmu_event_filter *kvm_filter;
> >> > +    KVMPMUFilter *filter = s->pmu_filter;
> >> > +    int ret;
> >> > +
> >> > +    kvm_filter = g_malloc0(sizeof(struct kvm_pmu_event_filter) +
> >> > +                           filter->nevents * sizeof(uint64_t));
> >> 
> >> Should we use sizeof(filter->events[0])?
> >
> > No, here I'm trying to constructing the memory accepted in kvm interface
> > (with the specific layout), which is not the same as the KVMPMUFilter
> > object.
> 
> You're right.  What about sizeof(kvm_filter->events[0])?

I get your point now! Yes, I should do in this way.

Thanks,
Zhao


