Return-Path: <kvm+bounces-62033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A49C3365A
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 00:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6857B3A2CB0
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 23:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F216347BA0;
	Tue,  4 Nov 2025 23:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fIHXjlup"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCB9346FC5;
	Tue,  4 Nov 2025 23:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299409; cv=none; b=YuJHJ6yjgUXMe8FhNcLyd0ryiEeo34dgunrZRvlp1ktL95efAdE6MPl0/x8SCJF9ImUf+jVfvd7BYOQGuJl2wxifF6E85veGUVU/5Otn2ydJo5uk/Nppkg7A5ONjIiHSqz63nvrRLzxdPifnCEf6VfV5zoSwSADQwgMZRzzpnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299409; c=relaxed/simple;
	bh=PKWKmIdlfyKfFqEKnAFOIWxWsIWRYB5asKBV1Y6ZW1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tcwt9ht45br9g4vPcdTPx748sWrfzYhn9CwQqcOQ37hGmNNCdoioA3RawGIWBHONlALKEM/FRWBMIqyx88r9i49AZhjOzE7HqF8L9mVKmfhJVV5xvUsVo0LceKCYK5o9ICKpb27/dO5pZutrOr1YAaO7grz0rXPFiB4XzELAOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fIHXjlup; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762299408; x=1793835408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PKWKmIdlfyKfFqEKnAFOIWxWsIWRYB5asKBV1Y6ZW1g=;
  b=fIHXjlupSitaAKkoVJ1rg0hWirb8XoN3IFRYzRJ3y2rmWZqAPKtJPsRg
   uIilztaTgNO32Sk3nF38oAH7v7iYhGNBzDzkoAMcQ9cmaHRYxpH/sI9Zd
   MMof6L7BipS2lZWht8EpWRcXyLB76/bWlgGyICp8wwPnYKhaDS5o+w7d0
   mZskxYLxVK6UGiTdpZ/ZzVBmQ955HIRBl+vDJNtcRrg0EnazfB+u2jMbi
   CrTiM4UH8G4joghJW+kcMpBngRk7nKKj731FRx/Ukwha9WYgb7pXVSMaz
   STHOmM4xj6nODAxYXqI+nyfCscCUx+bp8dCLW0k8K6jjARyslpAt80ZZ/
   A==;
X-CSE-ConnectionGUID: rBs3imWnR1G93hQxKgsgaQ==
X-CSE-MsgGUID: JOZgcLQVRqqcl3w/PAyP8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="68265513"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="68265513"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 15:36:46 -0800
X-CSE-ConnectionGUID: rswLq5OwQS6ylN+55p2Log==
X-CSE-MsgGUID: 31jX9TLASFqYdLt9tXRV8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="186540925"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.221.88])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 15:36:45 -0800
Date: Tue, 4 Nov 2025 15:36:39 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 3/3] x86/vmscape: Remove LFENCE from BHB clearing long
 loop
Message-ID: <20251104233639.luharyaq5twafmlk@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-3-5793c2534e93@linux.intel.com>
 <c98e68f0-e5e2-482d-9a64-ad8164e4bae8@intel.com>
 <20251104220100.wrorcuok5slqy74u@desk>
 <c6b9a696-975f-4dfa-bf65-9a1e983fab54@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b9a696-975f-4dfa-bf65-9a1e983fab54@intel.com>

On Tue, Nov 04, 2025 at 02:35:11PM -0800, Dave Hansen wrote:
> On 11/4/25 14:01, Pawan Gupta wrote:
> > On Mon, Nov 03, 2025 at 12:45:35PM -0800, Dave Hansen wrote:
> ...
> >> Too. Much. Assembly.
> >>
> >> Is there a reason we can't do more of this in C?
> > 
> > Apart from VMSCAPE, BHB clearing is also required when entering kernel from
> > system calls. And one of the safety requirement is to absolutely not
> > execute any indirect call/jmp unless we have cleared the BHB. In a C
> > implementation we cannot guarantee that the compiler won't generate
> > indirect branches before the BHB clearing can be done.
> 
> That's a good reason, and I did forget about the CLEAR_BRANCH_HISTORY
> route to get in to this code.
> 
> But my main aversion was to having so many different functions with
> different names to do different things that are also exported to the world.
> 
> For instance, if we need an LFENCE in the entry code, we could do this:
> 
> .macro CLEAR_BRANCH_HISTORY
>         ALTERNATIVE "", "call clear_bhb_loop; lfence",\
> 			X86_FEATURE_CLEAR_BHB_LOOP
> .endm
> 
> Instead of having a LFENCE variant of clear_bhb_loop().

This makes perfect sense. I will do that.

> >> Can we have _one_ assembly function, please? One that takes the loop
> >> counts? No macros, no duplication functions. Just one:
> > 
> > This seems possible for all the C callers. ASM callers should stick to asm
> > versions of BHB clearing to guarantee the compiler did not do anything
> > funky that would break the mitigation.
> 
> ASM callers can pass arguments to functions too. ;)

Oh my comment was more from the safety perspective of compiler induced
code.

> Sure, the syscall entry path might not be the *best* place in the world
> to do that because it'll add even more noops.

Right.

> It does make me wonder if we want to deal with this more holistically
> somehow:
> 
>         /* clobbers %rax, make sure it is after saving the syscall nr */
>         IBRS_ENTER
>         UNTRAIN_RET
>         CLEAR_BRANCH_HISTORY
> 
> especially if we're creating lots and lots of variants of functions to
> keep the ALTERNATIVE noop padding short.

Hmm, mitigations that are mutually exclusive can certainly be grouped
together in an ALTERNATIVE_N block. It also has a potential to quickly
become messy. But certainly worth exploring.

