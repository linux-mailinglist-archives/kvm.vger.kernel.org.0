Return-Path: <kvm+bounces-17285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC2C8C39FA
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 04:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 081D5B20CC0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 02:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED7A86AE9;
	Mon, 13 May 2024 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bjake9ZP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91AA200BF
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 02:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715565908; cv=none; b=IUwO5R/yiFMb0WMT6whQ6Viflq9sN5KMl1GWlgnu9X1pAgOdPRjSvrQrtfiiFWhvZzUaCnRmlzZ466Nyp+sfk8IvFLRHnsQMqBdKvKlJ1zgMEZ8e1frUnEMLNfXCFDv6dwpoyqnPfDTuVSJOiBH0LiVNb2bfcZuqrlbbZl+Ix88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715565908; c=relaxed/simple;
	bh=OvIRjsRU/wcZHNN0MuFYEKkTSMgYrM3VDB+C+SXybYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpbrK04PPdREj+AAzkij+3GrR6RpFLfSZb40oT3B6fKcQ7u1vCrF7X8ve3TibT61W+TguwfhpDlk+w+LQM9d7btFXNHi94RSBiqpSA/Wx5sZPLw/c+HlJVf+AdELTaAsi0kb7ILj5F2u0W41vIJH4GLhIwnl092u7bSLpfjWqzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bjake9ZP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715565907; x=1747101907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OvIRjsRU/wcZHNN0MuFYEKkTSMgYrM3VDB+C+SXybYE=;
  b=Bjake9ZPGZXvcLXV8kjJ8euqdWWL9ZOSMeaEDMxs3q+q7xuTrF/gHdVX
   wV7RqK2VnjlSAr/UT0ZxSc6lsb4gG+/at8jt+hmpsZ21taPTYAZTBe57t
   84Of4WbLCTNOzWqo2CDA1CggGStoR7x8a21Ai+NoTPn4okN04TIGC5LgD
   UU+LlnzO2lV0DdOqJRtBwWbsm/2vKcCB1YeS7N8qeDuWjwYmQHLINYqwJ
   wTZ/quDNTpYpgyJFoe8U+POqFEklVMCTC7YDq/GZi0NfWe9VMxNnP9clg
   uQWeq5+iTXxx1ihBNnABrXXb+0Jttv9Vct/sz1GxfnNhEw38PFsKxhFfE
   A==;
X-CSE-ConnectionGUID: NhUoTyTMSoWiGiaDblGX3g==
X-CSE-MsgGUID: XApXu+a2QRG+Y6Axpizq+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11422216"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11422216"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 19:05:07 -0700
X-CSE-ConnectionGUID: b88DPD0KQn63XLqtqK8tng==
X-CSE-MsgGUID: 7I/2o8qMS9ObqUX6A1yoXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="61005644"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 19:05:05 -0700
Date: Mon, 13 May 2024 10:00:35 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	xiaoyao.li@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
Message-ID: <ZkF0Q0uxOfWflfw8@linux.bj.intel.com>
References: <20240510020346.12528-1-tao1.su@linux.intel.com>
 <ZkFwgGYV84TztUxD@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkFwgGYV84TztUxD@chao-email>

On Mon, May 13, 2024 at 09:44:32AM +0800, Chao Gao wrote:
> On Fri, May 10, 2024 at 10:03:46AM +0800, Tao Su wrote:
> >Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
> >max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
> >dirty_log_test...) add RAM regions close to max_gfn, so guest may access
> >GPA beyond its mappable range and cause infinite loop.
> >
> >Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
> >overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.
> >
> >Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> >Tested-by: Yi Lai <yi1.lai@intel.com>
> >---
> >This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
> >
> >Changelog:
> >v1 -> v2:
> > - Only adjust vm->max_gfn in vm_compute_max_gfn()
> > - Add Yi Lai's Tested-by
> >
> >v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
> >---
> > tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
> > tools/testing/selftests/kvm/lib/x86_64/processor.c     | 10 ++++++++--
> > 2 files changed, 9 insertions(+), 2 deletions(-)
> >
> >diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >index 81ce37ec407d..ff99f66d81a0 100644
> >--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> >+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
> > #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
> > #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
> > #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
> >+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
> > #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
> > #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
> > 
> >diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >index 74a4c736c9ae..aa9966ead543 100644
> >--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> >@@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
> > unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> > {
> > 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
> >-	unsigned long ht_gfn, max_gfn, max_pfn;
> >+	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;
> 
> nit: max_bits has only 8 bits. so max_bits should be uint8_t.

Because vm->pa_bits is unsigned int, I'm worried that the compiler will
complain on stricter compilation, what do you think?

> 
> > 	uint8_t maxphyaddr;
> > 
> >-	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
> >+	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
> >+		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
> >+
> >+	if (!max_bits)
> >+		max_bits = vm->pa_bits;
> >+
> >+	max_gfn = (1ULL << (max_bits - vm->page_shift)) - 1;
> > 
> > 	/* Avoid reserved HyperTransport region on AMD processors.  */
> > 	if (!host_cpu_is_amd)
> >
> >base-commit: 448b3fe5a0eab5b625a7e15c67c7972169e47ff8
> >-- 
> >2.34.1
> >

