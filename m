Return-Path: <kvm+bounces-32327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 225629D562F
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 00:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA96528116C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 23:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337BE1D90BC;
	Thu, 21 Nov 2024 23:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A6+AwDD1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60DC1AAE06;
	Thu, 21 Nov 2024 23:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732231964; cv=none; b=K/9jbUzg+cHa+sGJ7tmEKNx4EPWvyvGv6qksBkwGhkwdlSAMu7bKS8c4VMIvvTRKpzzLusg0+8OlWHpRV1/eUdBup0ccB+ZdoA3EeMMCCt/xrz0KbrwfrVfxn/cFaJ6yLyUqzDTWmGbxrcfqfjs2OKY3zzwNyIBh/yI+WCJjf14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732231964; c=relaxed/simple;
	bh=ygYMDWO/yHZ3l8DQZRGNyMCOr+dX6/eskJ6pouwjMv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jycc3oKb+hRFlV050Imk0FT/H4OzYgljkwwNqT+xYDG6Ocr2+cg301Fp6ma28sWUcrlYFRUOCAbf3I+QHFomJHs8dhZIR0MYUsKZuFU1xfce7MnJan6qUbtZf5r/ESUo5BZMzKNbm8bqJ2cPiGiwBOaZr3DXwo8QbeqFwz9hjFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A6+AwDD1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732231962; x=1763767962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ygYMDWO/yHZ3l8DQZRGNyMCOr+dX6/eskJ6pouwjMv4=;
  b=A6+AwDD1j4R2GBOdNKk4hGro5a5qIj/OFA8Ndfn1RWwzpqUN9G9Mgf9P
   Xu1zHlTvz5DX+N1mzoeNv/LN9UVHXE8fBzABbuZrjvgokY1sCX2zARnQs
   wze0stj4AOEYs6sxPlUjIJoRk+WIvrYjZd+7dZrZzumMwnpXvnheXTrvT
   9Jy+Ev645D2q5k5wyW8pPeIVlrlahS6HLWxwbhoeNH9JWd8tVsuQoCzmT
   dcvkGJVBwu2qZLuTsOp/OSQgQxgF5YD5Uzpj05SlaaV6bpMqALxQ/FxUt
   FGv31a4/MOTWBR1e8+JZ0NjoscIV6NfHfj8qIVNiUwInsPV6sblU4WAAc
   g==;
X-CSE-ConnectionGUID: weEeW3AbRSGlNwiJYQuC4A==
X-CSE-MsgGUID: 9WT/dpxPQue8p0wvy/mE1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32613356"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="32613356"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 15:32:41 -0800
X-CSE-ConnectionGUID: g3cD8rRoRgyoze6v4P/7Mg==
X-CSE-MsgGUID: n2x+Fu8CTPi2umoSbcumDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="91206105"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 15:32:41 -0800
Date: Thu, 21 Nov 2024 15:32:40 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com, rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Marcelo Tosatti <mtosatti@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Message-ID: <Zz/DGOoo/mEvULiG@ls.amr.corp.intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com>

On Mon, Oct 14, 2024 at 08:17:19PM +0530,
"Nikunj A. Dadhania" <nikunj@amd.com> wrote:

> > Solution
> > --------
> > The solution is to keep the KVM TSC offset/multiplier the same as the value of
> > the TDX module somehow.  Possible solutions are as follows.
> > - Skip the logic
> >   Ignore (or don't call related functions) the request to change the TSC
> >   offset/multiplier.
> >   Pros
> >   - Logically clean.  This is similar to the guest_protected case.
> >   Cons
> >   - Needs to identify the call sites.
> > 
> > - Revert the change at the hooks after TSC adjustment
> >   x86 KVM defines the vendor hooks when the TSC offset/multiplier are
> >   changed.  The callback can revert the change.
> >   Pros
> >   - We don't need to care about the logic to change the TSC offset/multiplier.
> >   Cons:
> >   - Hacky to revert the KVM x86 common code logic.
> > 
> > Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> > supported.
> 
> I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and 
> GUEST_TSC_SCALE are only available to the guest.

Although Xiaoyao mentioned KVM emulated timer, let me clarify it.
I think the following is common for SEV-SNP and TDX.

The issue is with guest MSR_IA32_TSC_DEADLINE (and guest local APIC Timer
Initial Count Register).  As long as I understand according to the public
documentation, the SEV-SNP hardware (or the TDX module) doesn't virtualize it so
that the VMM (KVM) has to emulate it.
The KVM uses the host timer(vcpu->arch.apic.lapic_timer) and inject timer
interrupt withit.  KVM tracks TSC multiplier/offset to calculate the host
TSC timeout value based on them.

The KVM multiplier and offset must match with the values the hardware 
(or the TDX module) thinks.  If they don't match,  the KVM tsc deadline timer
(or local APIC timer) emulation is inaccurate.  Timer interrupt is injected
Late or early.

KVM has several points to change tsc multiplier/offset from the original value.
This patch series is to prevent KVM from modifying TSC multipler/offset.

In reality, it's difficult to notice that the timer interrupt is injected late
or early like several miliseconds due to vCPU scheduling.  The injecting timer
interrupt always late harms time sensitive workload (e.g. heart beat) in guest
as Marcelo noticed.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

