Return-Path: <kvm+bounces-11242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4929087459F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83B5C285964
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3CD4C97;
	Thu,  7 Mar 2024 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/tX6S8n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F91391;
	Thu,  7 Mar 2024 01:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709774978; cv=none; b=G3tuKw+i8+KSsQCJDxzPL1maWy2N5+VkdDu1biI91V8UuSuc+18ko+3nfvff3FL5fx18zAJMAMsYwgvrV/pVvA+vlsDugK3+zm3z5eamlrYGFukCyEN/kK4UT4uGAjoJgUmGdfqkBoLth9dRa/FcK3Z/xeD2uhDWV/2mHdWgXD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709774978; c=relaxed/simple;
	bh=+G3P5fZ1KtJkD5uP1P0r4wxS61wLtCc7RBBUY4HZWBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPVSNNGXBawPoroOzNFcuH96XnEhbh19Ft0ZZk3is8QuN0GqGnrD8kGo/3lE+YATgfXjUBdaRmJ04bpsKhqiSrSk6/Y+TL6M5BPFULMinf92cuK5QcQs7e6F9Aig0qtdLgJ9aUo+KEGWKcKpaFFQ04yjET7xDWBovol0YAH6bUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/tX6S8n; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709774977; x=1741310977;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+G3P5fZ1KtJkD5uP1P0r4wxS61wLtCc7RBBUY4HZWBM=;
  b=l/tX6S8nvIWkr6/VOLeSEvfF3KCA2JkqEMqCbL4zwR2rmjFYmkH4qKdw
   tmnp3IXwDyX09Bjww0Av1J3HMry4c6MpaYbb18+s/+ifNAycvjgqGYnPx
   ZbdshZw7O+OMcLOKsImsSmpPYJ3P1sM92gJM3Fu/uDkTkcb4qjuhmIH+O
   pVCCL+F83Nm5ASBEB1FwsmOK8LhjH/aauSlvRyI+nhQ6TqOVcLUG45X7e
   2jeDHc7dcw3hJPrO4GKlewLQ0wXceIJjUyiSCQfZkwBet4U/61WujN4jw
   OfSd8i/LqG3gxnhlHfV1yUS/e3i3B8tUCcJlQ/zqQL5CNb4T50kRYF/pM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15147516"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15147516"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14533859"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:29:35 -0800
Date: Wed, 6 Mar 2024 17:29:34 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240307012934.GD368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <ZekNx-WkGNrVfFRD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZekNx-WkGNrVfFRD@google.com>

On Wed, Mar 06, 2024 at 04:43:51PM -0800,
David Matlack <dmatlack@google.com> wrote:

> On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +
> > +  struct kvm_memory_mapping {
> > +	__u64 base_gfn;
> > +	__u64 nr_pages;
> > +	__u64 flags;
> > +	__u64 source;
> > +  };
> > +
> > +  /* For kvm_memory_mapping:: flags */
> > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> > +  #define KVM_MEMORY_MAPPING_FLAG_PRIVATE       _BITULL(3)
> > +
> > +KVM_MAP_MEMORY populates guest memory in the underlying mapping. If source is
> > +not zero and it's supported (depending on underlying technology), the guest
> > +memory content is populated with the source.
> 
> What does "populated with the source" mean?

source is user pointer and the memory contents of source is copied into
base_gfn. (and it will encrypted.)


> > The flags field supports three
> > +flags: KVM_MEMORY_MAPPING_FLAG_WRITE, KVM_MEMORY_MAPPING_FLAG_EXEC, and
> > +KVM_MEMORY_MAPPING_FLAG_USER.
> 
> There are 4 flags.

Oops. Let me update it.


KVM_MAP_MEMORY populates guest memory at the specified range (`base_gfn`,
`nr_pages`) in the underlying mapping. `source` is an optional user pointer. If
`source` is not NULL and the underlying technology supports it, the memory
contents of `source` are copied into the guest memory. The backend may encrypt
it.

The `flags` field supports four flags: KVM_MEMORY_MAPPING_FLAG_WRITE,
KVM_MEMORY_MAPPING_FLAG_EXEC, KVM_MEMORY_MAPPING_FLAG_USER, and
KVM_MEMORY_MAPPING_FLAGS_PRIVATE. The first three correspond to the fault code
for the KVM page fault to populate guest memory.  write fault, fetch fault, and
user fault.  KVM_MEMORY_MAPPING_FLAGS_PRIVATE is applicable only for guest
memory with guest_memfd.  It is to populate guest memory with the memory
attribute of KVM_MEMORY_ATTRIBUTE_PRIVATE set.

When the ioctl returns, the input values are updated.  If `nr_pages` is large,
it may return -EAGAIN and update the values (`base_gfn` and `nr_pages`. `source`
if not zero) to point to the remaining range.

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

