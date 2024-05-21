Return-Path: <kvm+bounces-17821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CF28CA624
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 04:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 946F528278D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522D614A8E;
	Tue, 21 May 2024 02:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UxpVGf3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC079C2E9;
	Tue, 21 May 2024 02:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716258308; cv=none; b=Kr4Ga6ddOl8iG0NkmOLt4S94S3Egnp+NUMw0Qxnca+YfIV95qRGgWJnmgsSS5xaUZEUsT1dwbnqg5A9hX/o1fXiCdoW3V/LSWc2tUeJLXUo7gZoKgoItemBJTo4hWXXK8Kahvo1qSGnCWP6vtEy1ac2Q6uuubIloUpkM0Kx5NFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716258308; c=relaxed/simple;
	bh=2JQdNkN8Va5J2PBw3j2euQZnhUifo/T3OFWx1yC23Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5y3TbFOtsdQOjPavDKCZR/wIwgA2y7Kp7Z8+tu7FnnqAexrciVQmYdCF3yUyqa5sN9GxsQpR0+UmjxeeYrGCCFO8x8CH+BzJxkFiGjY/G1ZESFiQhorNXctJPrDrv695fddUE6s+3FZYscLUEn6EC+d/r22IhHonk9CjR+X2kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UxpVGf3P; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716258307; x=1747794307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2JQdNkN8Va5J2PBw3j2euQZnhUifo/T3OFWx1yC23Lg=;
  b=UxpVGf3PTSJVK29zOfryRhxuDGvC1xLCKHEHz6VnqcYarTf5eiMgJvg5
   ZUkIXm0Uo0yPt/6v9LjFu1u3BVrXjqsiPex/CT3FhSi6BOEIVLpIKgUdn
   7h1QE82Y16HIXDuUQVzSn2GFE7m4g3bjnKKSsf7zDO0R0WlAnuBSzpls7
   /1P72UuY7qXAR/N60G3hSdbeDp4Uj/4dREFlRND7WbFp5YfYfHGeju0CT
   uAXRu1v8aealBMHOh1tefaqgMEeZ1H+FkRokFqVgLztv4tNOHBZoc7fl1
   u0CpLCrprHgRIJKKOtNETz0zizQIGfT7Y8rW0MZS/OkVODURtZVVRYelE
   w==;
X-CSE-ConnectionGUID: a2dR5rnNRnmjhbwLZVoTCg==
X-CSE-MsgGUID: bga4bYxbQqOStw/XlJv8eQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="23563707"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="23563707"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 19:25:06 -0700
X-CSE-ConnectionGUID: HSKawQjaTIWB1uxViNhqyA==
X-CSE-MsgGUID: /9AsGmROS4iOnBCH+sDvYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32613622"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 19:25:05 -0700
Date: Mon, 20 May 2024 19:25:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240521022505.GB29916@ls.amr.corp.intel.com>
References: <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
 <20240517081440.GM168153@ls.amr.corp.intel.com>
 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
 <20240520185817.GA22775@ls.amr.corp.intel.com>
 <91444be8576ac220fb66cd8546697912988c4a87.camel@intel.com>
 <2ee12c152c8db9f5e4acd131b95411bac0abb22c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ee12c152c8db9f5e4acd131b95411bac0abb22c.camel@intel.com>

On Mon, May 20, 2024 at 11:39:06PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-05-20 at 12:02 -0700, Rick Edgecombe wrote:
> > 
> > reflect is a nice name. I'm trying this path right now. I'll share a branch.
> 
> Here is the branch:
> https://github.com/rpedgeco/linux/commit/674cd68b6ba626e48fe2446797d067e38dca80e3

Thank you for sharing it. It makes it easy to create further patches on top of
it.

...

> In this solution, the tdp_mmu.c doesn't have a concept of private vs shared EPT
> or GPA aliases. It just knows KVM_PROCESS_PRIVATE/SHARED, and fault->is_private.
> 
> Based on the PROCESS enums or fault->is_private, helpers in mmu.h encapsulate
> whether to operate on the normal "direct" roots or the mirrored roots. When
> !TDX, it always operates on direct.
> 
> The code that does PTE setting/zapping etc, calls out the mirrored "reflect"
> helper and does the extra atomicity stuff when it sees the mirrored role bit.
> 
> In Isaku's code to make gfn's never have shared bits, there was still the
> concept of "shared" in the TDP MMU. But now since the TDP MMU focuses on
> mirrored vs direct instead, an abstraction is introduced to just ask for the
> mask for the root. For TDX the direct root is for shared memory, so instead the
> kvm_gfn_direct_mask() gets applied when operating on the direct root.

"direct" is better than "shared".  It might be confusing with the existing
role.direct, but I don't think of better other name.

I resorted to pass around kvm for gfn_direct_mask to the iterator.  Alternative
way is to stash it in struct kvm_mmu_page of root somehow.  Then, we can strip
kvm from the iterator and the related macros.


> I think there are still some things to be polished in the branch, but overall it
> does a good job of cleaning up the confusion about the connection between
> private and mirrored. And also between this and the previous changes, improves
> littering the generic MMU code with private/shared alias concepts.
> 
> At the same time, I think the abstractions have a small cost in clarity if you
> are looking at the code from TDX's perspective. It probably wont raise any
> eyebrows for people used to tracing nested EPT violations through paging_tmpl.h.
> But compared to naming everything mirrored_private, there is more obfuscation of
> the bits twiddled.

The rename makes the code much less confusing.  I noticed that mirror and
mirrored are mixed. I'm not sure whether it's intentional or accidental.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

