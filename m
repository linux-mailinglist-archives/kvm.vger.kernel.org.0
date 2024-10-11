Return-Path: <kvm+bounces-28598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE80A999B7B
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 06:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5ED1C22077
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683931F4FCC;
	Fri, 11 Oct 2024 04:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2BOZNtu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1824F2FB2
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 04:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728619585; cv=none; b=JIpCxRmrIoD1pdQv7W7adLReh3JgucCXKDvB15b2KFW/BfBhjd3J5J+X0nM2rcKq61Xe+NG/5IWuSbS68DI7BMnGhPjWY9ghExyfIVFFjN+pCKQPspk7p1Get5VmZY65pWlftb1jRfp+ImbhIjRp01ohBmQ1loxCAzzzxxWBPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728619585; c=relaxed/simple;
	bh=pmhUn37a+zGP9NJwDxKGimua04LfrRf1ZOIV6NgRpkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PF4LtQY6hbXXJo9Qt1PKBgfKcI10OUrh+TB5pQKnRz6CXOWoAQWVJ1O/6UYmdIFFfeOL7ak25nTfqYsCJv4cfwgfmK5AC0iirudpgXMwqtDeN9OkqFgKVIqRFaMrwHpxco9tyaf9gAJtqf+yXnIpDZOUsBnynpWZL93ZioYLLsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2BOZNtu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728619583; x=1760155583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pmhUn37a+zGP9NJwDxKGimua04LfrRf1ZOIV6NgRpkE=;
  b=d2BOZNtu/CdFgYuuAeeKuIGDD6MpC+Ubq7SO0HFPUqW3ToNRtUN/edSj
   lMbfk0GNREk9qTHYZr0jXRCAHc81mvaU+lQiLc3FP6v+L5lJTX56RcFme
   l8uEK393c1nXYTOJUbF5pk9kjSxiSz2dCSTyTlw3snap0ka/J+kDKcMtG
   fWM6jOrwT549kg8RuNWkXr5FJIh4Id5Qnp1ZiiRTBn+bh479dXPdiYofU
   7FmXPuV48qL2q8F31OxmkAgvMP/OXKgm+nRnQ1G7sTMwSp7znx2GiIldn
   8eN+b7bxNNGdoqg0Jq3Uc6F1Ktj913cNV/Iv1Ps2G5YmD6kBUWsPYq+vN
   w==;
X-CSE-ConnectionGUID: B0a3/xkwRVydSNE4kwlz/Q==
X-CSE-MsgGUID: Nonpm4QnQE695q3xvibj5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="38593370"
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="38593370"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 21:06:22 -0700
X-CSE-ConnectionGUID: MORqKw7cRBO6Ir+v3w0r2A==
X-CSE-MsgGUID: VFbReQmPQJSoaRl58OGDpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="76999513"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 10 Oct 2024 21:06:20 -0700
Date: Fri, 11 Oct 2024 12:22:32 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, jmattson@google.com,
	pawan.kumar.gupta@linux.intel.com, jon@nutanix.com,
	kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH] target/i386: Add more features enumerated by
 CPUID.7.2.EDX
Message-ID: <ZwioCPNusih5f8zS@intel.com>
References: <20240919051011.118309-1-chao.gao@intel.com>
 <ZwY1AeJPlrniISB1@intel.com>
 <ZwY69phzk3GpGvsh@intel.com>
 <9bd5659c-6066-46f9-a096-10f585f8561e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd5659c-6066-46f9-a096-10f585f8561e@redhat.com>

On Thu, Oct 10, 2024 at 03:17:16PM +0200, Paolo Bonzini wrote:
> Date: Thu, 10 Oct 2024 15:17:16 +0200
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH] target/i386: Add more features enumerated by
>  CPUID.7.2.EDX
> 
> On 10/9/24 10:12, Chao Gao wrote:
> > > > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > > > index 85ef7452c0..18ba958f46 100644
> > > > --- a/target/i386/cpu.c
> > > > +++ b/target/i386/cpu.c
> > > > @@ -1148,8 +1148,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
> > > >       [FEAT_7_2_EDX] = {
> > > >           .type = CPUID_FEATURE_WORD,
> > > >           .feat_names = {
> > > > -            NULL, NULL, NULL, NULL,
> > > > -            NULL, "mcdt-no", NULL, NULL,
> > > > +            "intel-psfd", "ipred-ctrl", "rrsba-ctrl", "ddpd-u",
> > > > +            "bhi-ctrl", "mcdt-no", NULL, NULL,
> > > 
> > > IIUC, these bits depend on "spec-ctrl", which indicates the presence of
> > > IA32_SPEC_CTRL.
> > > 
> > > Then I think we'd better add dependencies in feature_dependencies[].
> > 
> > (+ kvm mailing list)
> > 
> > Thanks for pointing that out. It seems that any of these bits imply the
> > presence of IA32_SPEC_CTRL. According to SDM vol4, chapter 2, table 2.2,
> > the 'Comment' column for the IA32_SPEC_CTRL MSR states:
> > 
> >    If any one of the enumeration conditions for defined bit field positions holds.
> > 
> > So, it might be more appropriate to fix KVM's handling of the
> > IA32_SPEC_CTRL MSR (i.e., guest_has_spec_ctrl_msr()).
> > 
> > what do you think?
> 
> You're right, the spec-ctrl CPUID feature covers the IBRS bit of
> MSR_IA32_SPEC_CTRL and also the IBPB feature of MSR_IA32_PRED_CMD.  It does
> not specify the existence of MSR_IA32_SPEC_CTRL.
> 
> In practice it's probably not a good idea to omit spec-ctrl when passing
> other features to the guest that cover that MSR; but the specification says
> it's fine.

I think these features are also worth updating in the CPU models, as
well as in this document: 'cpu-models-x86.rst.inc' - section 'Important
CPU features for Intel x86 hosts' (maybe in the followup patches :))

Thanks,
Zhao


