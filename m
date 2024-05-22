Return-Path: <kvm+bounces-17918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441D28CB9DE
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B4D7B20FA4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A980174BEC;
	Wed, 22 May 2024 03:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W/sAlneu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D76CDCC
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 03:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716349071; cv=none; b=T50OXXyRrcKACGuPeVG6IW0Uw9vUK6DU+sYla0DCzapGaOj23HvNgMaad6aMFfkuCnIp8lXSaB67PxPcRzqFjylJrvGPlwg/QZBGSW3KMQRsk4kV46mFOo/i5tPhzd506zMjIDzKiToJqfoI8g02tOo8TDWHr3DMr29Hqf0M5vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716349071; c=relaxed/simple;
	bh=AnDEOlakrKfbAsgGaXaEb5QDHkkWv+wRNfCQOMVRV6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUQsjPVVnms/s4DBTS63JX/PlX5sYB6tMA45QNlYxZbWoIjD3scF35Lv7HAmr5xExxiNJQ5OtVOwRqyiv90mz4Bi1/9yiMEvR9kZWkRGJfi+WxFOCB0T9atuVtREOssAk6mOUhlVUpzMyRMog3VdIkjgzBje8Bwb/pNOyhDQAn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W/sAlneu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716349070; x=1747885070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=AnDEOlakrKfbAsgGaXaEb5QDHkkWv+wRNfCQOMVRV6g=;
  b=W/sAlneumdGPz/SyQzGze/FmhAzELFgPtIKxdNxWYF65higIKbctolM7
   Tbk26QGFeMdHWq33mSUuRJpZ/nYu69gEuJPQ2JYtbGOLnEm9ntq15B+Xf
   V28OCCMGsc4zxb8e/7MX9mi66IUD8tCHU3htMhWEXEja0fyK7+J+cHl+w
   X7PKqJpZ2/9kc1kVzZMpS3oDPfaBp/s3gGknfjThyL156mkT3WiQR1Z2i
   teMqXKZiOQFE0oh1DiSIuR2QEgZhY2gbN54KDqvTCR8WbdDOu+SQ8k/pt
   2g2kF+6RRJ5GBo2zQqtliizDcGSFlGzTHAT9oQ60pMgrOHVodrUw49gqo
   Q==;
X-CSE-ConnectionGUID: 3R3jcJIAS5WB52kUDyDT5w==
X-CSE-MsgGUID: EyVUvzTKSgW1TmZ4fcrVAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12690240"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12690240"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:37:50 -0700
X-CSE-ConnectionGUID: +4m6+BeURxSGzeN/avCRzw==
X-CSE-MsgGUID: 9H17vCBuSTuhX7UeCph9Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="56363072"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:37:47 -0700
Date: Wed, 22 May 2024 11:33:20 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Advertise AVX10.1 CPUID to userspace
Message-ID: <Zk1ngN0dNeYdikQ5@linux.bj.intel.com>
References: <20240520022002.1494056-1-tao1.su@linux.intel.com>
 <ZkthpjnKRD1Jpj2A@google.com>
 <ZkwQQZ22ImN6fXTM@linux.bj.intel.com>
 <Zkz5Ak0PQlAN8DxK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zkz5Ak0PQlAN8DxK@google.com>

On Tue, May 21, 2024 at 12:41:54PM -0700, Sean Christopherson wrote:
> On Tue, May 21, 2024, Tao Su wrote:
> > On Mon, May 20, 2024 at 07:43:50AM -0700, Sean Christopherson wrote:
> > > On Mon, May 20, 2024, Tao Su wrote:
> > > > @@ -1162,6 +1162,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> > > >  			break;
> > > >  		}
> > > >  		break;
> > > > +	case 0x24: {
> > > > +		u8 avx10_version;
> > > > +		u32 vector_support;
> > > > +
> > > > +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> > > > +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > > > +			break;
> > > > +		}
> > > > +		avx10_version = min(entry->ebx & 0xff, 1);
> > > 
> > > Taking the min() of '1' and anything else is pointless.  Per the spec, the version
> > > can never be 0.
> > > 
> > >   CPUID.(EAX=24H, ECX=00H):EBX[bits 7:0]  Reports the Intel AVX10 Converged Vector ISA version. Integer (≥ 1)
> > > 
> > > And it's probably too late, but why on earth is there an AVX10 version number?
> > > Version numbers are _awful_ for virtualization; see the constant vPMU problems
> > > that arise from bundling things under a single version number..  Y'all carved out
> > > room for sub-leafs, i.e. there's a ton of room for "discrete feature bits", so
> > > why oh why is there a version number?
> > > 
> > 
> > Per the spec, AVX10 wants to reduce the number of CPUID feature flags required
> > to be checked, which may simplify application development. Application only
> > needs to check the version number that can know whether hardware supports an
> > instruction.
> 
> I get that, but it royally hoses virtualization.  Bundling multiple features
> under a single flag is annoying, e.g. it makes it impossible to selectively
> advertise features, but I can appreciate that there are situations where having
> one feature but not another is nonsensical.
> 
> Incrementing version numbers are a whole other level of bad though.  E.g. if
> AVX10.2 has a feature that shouldn't be enumerated to guests for whatever reason,
> then KVM can't enumerate any "later" features either, because the only way to hide
> the problematic AVX10.2 feature is to set the version to AVX10.1 or lower.
> 

I see, if a 'small part' of a version cannot be advertised, it will block the
virtualization of all subsequent versions. If this special 'small part' is
really introduced later, I believe this will belong to the rare case and be
enumerated in the sub-leaf of CPUID leaf 24H.

> FWIW, unlike the PMU, which is a bit of a disaster due to version numbers, I don't
> expect AVX to be problematic in practice.  E.g. most AVX features are just passed
> through and don't have virtualization controls.

Yes, I can’t agree more.

> I just think it's a terrible
> tradeoff.  E.g. if features really need to be bundled together, I don't see how
> application development is meaningfully more difficult if enumeration is done
> via a multi-purpose CPUID flag, versus a version number.
> 

For applications, it seems no significant advantage to the version number.
Maybe applications can batch operations based on the version number and the
supported vector length.

> > There's indeed a sub-leaf for enumerating discrete CPUID feature bits, but
> > the sub-leaf is only in the rare case.
> > 
> > AVX10.2 (version number == 2) is the initial and fully-featured version of
> 
> So what's AVX10.1?
>

AVX10.1 just adds the related CPUIDs for software pre-enabling, i.e. AVX10.1
has no VMX capability, Embedded rounding and Suppress All Exceptions (SAE)
control, which will be introduced in AVX10.2.

> > AVX10, we may need to advertise AVX10.2 in the future. Is keeping min() more
> > flexible to control the advertised version number? E.g.
> > 
> >     avx10_version = min(entry->ebx & 0xff, 2);
> > 
> > can advertise AVX10.2 to userspace.
> 
> I'm not worried about flexibility at this point, as much as I'm worried about
> having sensible code.  E.g. if we know AVX10.2 is coming (or already here?), why
> not set KVM's supported min version to 2 from the get-go?

Per the spec, AVX10.2 will have a VMX capability, i.e. in the future, KVM may
have to do something before advertising AVX10.2. But now there are CPUs that
support AVX10.1, so AVX10.1 should to be advertised to guest firstly.


