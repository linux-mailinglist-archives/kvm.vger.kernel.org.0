Return-Path: <kvm+bounces-17250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B55BC8C3055
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 11:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C94941C20C47
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 09:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8573D53393;
	Sat, 11 May 2024 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TknC9+6c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78B320328
	for <kvm@vger.kernel.org>; Sat, 11 May 2024 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715419097; cv=none; b=UKo3sPUYqJHbKt2od0oKr+m3PrgzU+0ymr8rDRxfslCz3PlUoBwIKFWlSxcJmqKNN9TQ6CfVwJyYKR6EowL4nCxaKOg58z8EAorPgg//TukXGdXSfWS4TJX59ywJKVBVZD7eTIrW4R7LzQiQ0+t7eeP/LvbkLKDlqe4zc85mAxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715419097; c=relaxed/simple;
	bh=nqvIptmZ+vkS0RcaGibeSprrmUZRb9NMjISFmLwJV98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMdJ5R6ZVrIWfoQPsEw2/z+oSQICWmYay96a0GPn0JmzB7bsl5zUecvqAepBrfKZp6gBjkBXjN45I9mzEN7gYb22Iz2zd9ScAaT2BTvIVpuNGmWIBAV3EkXaRaz4hEnw1Xuz/hY+zquUvga24hFrNlC/hq0+dJl5W3UyHJnzi3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TknC9+6c; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715419096; x=1746955096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nqvIptmZ+vkS0RcaGibeSprrmUZRb9NMjISFmLwJV98=;
  b=TknC9+6c56aIaE2r80FYCe7z2YcqKePRbVd606lPt7WqHTogYP8Bw0iJ
   TUHBn756Xig15Dd+6Pk/NB2TCV/0FXhAifRvt4JpM4Y9LnQESYSE/OAZU
   JLc25VBxfIQZ3WlPP7hL0i6Q1E2XdCyKYMKA4xpyNAxbxe56fPRSlBeFK
   Ay1sobnwdelv1XlP3qAxDnqo7VcnUKjb8000Kn3ibUPhhwaue2rxjDEC/
   hHUq8C2wmUGDkz1LGjk97YxtXc/3mMPD+PD3j4r3pI4GXob5J8MxlcWZS
   gBvxSJdtKIKyuVzwlH6t//KuYlWOyaHOMxubOk93X03THwmLzh9kFDPqr
   A==;
X-CSE-ConnectionGUID: wj1wfDM2RZq9N/2XiDfGdQ==
X-CSE-MsgGUID: C+kCkYrgReeXanhceqzhmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="33925712"
X-IronPort-AV: E=Sophos;i="6.08,153,1712646000"; 
   d="scan'208";a="33925712"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2024 02:18:16 -0700
X-CSE-ConnectionGUID: 3I72o0W0R+i8FLRpZmqhaQ==
X-CSE-MsgGUID: m0lh3s+8RMa+yA6cYTH5VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,153,1712646000"; 
   d="scan'208";a="34541032"
Received: from linux.bj.intel.com ([10.238.157.71])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2024 02:18:14 -0700
Date: Sat, 11 May 2024 17:13:44 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	chao.gao@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
Message-ID: <Zj82yMtYW6VrB5z9@linux.bj.intel.com>
References: <20240510020346.12528-1-tao1.su@linux.intel.com>
 <456e2a3b-a96f-46a2-96d2-03dab56f9eb9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456e2a3b-a96f-46a2-96d2-03dab56f9eb9@intel.com>

On Sat, May 11, 2024 at 03:08:16PM +0800, Xiaoyao Li wrote:

[...]

> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 74a4c736c9ae..aa9966ead543 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
> >   unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> >   {
> >   	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
> > -	unsigned long ht_gfn, max_gfn, max_pfn;
> > +	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;
> >   	uint8_t maxphyaddr;
> > -	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
> > +	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
> > +		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
> 
> We can get rid of the kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR) check
> and call kvm_cpu_property() unconditionally. As a bonus, we don't need to
> init max_bits as 0.

Thanks, good suggestion!

> 
> BTW, could we just name it guest_pa_bits?

Yes, it will be more accurate.


