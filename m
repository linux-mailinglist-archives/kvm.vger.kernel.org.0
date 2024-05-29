Return-Path: <kvm+bounces-18255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1EA8D2ABA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1548A2854C9
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926B615B0E5;
	Wed, 29 May 2024 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQj2hlY+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4D4DA08;
	Wed, 29 May 2024 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716949206; cv=none; b=fyxWLght3+Z63s81RiQp3ziMQid+r/+++wXmEcKjzItyXpf7e7Vj6GoZvaf2/1mEtNhAxtjb6xwLWdNUYmueLjw79ZHp9BJWOrZkdh6WkNMu30XQGIuBDBZfa3YpoY4Y+mZkYY8wPdQwOJZqH4mmjQGKdRzAieFkoQhu/tuoCBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716949206; c=relaxed/simple;
	bh=1Lxina2QR/i/PAe6wbyp4MvFOW2Mak7+iWIwuFEcXBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKrETO2vLkOoyTKeLsTR1ZASnz1X1r4ilOASFuyrfzGvGG9AVuoFRtztRGSXJ1sf4mhA4/3h7XdTTuB9ptU2ZtEeCUzkJVZrJB/Z9Yo8GcCJp2dlVhIekphfgw+2OBTBMMJ6CczXbzcfJuV75pGUzj3+CylL8Tq1WC7p9rvad9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQj2hlY+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716949206; x=1748485206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1Lxina2QR/i/PAe6wbyp4MvFOW2Mak7+iWIwuFEcXBk=;
  b=WQj2hlY+9YYjf9LTip0Rp+7MTJZZNuXRIv7Nevnge0IUStWgvTsm56x8
   OdHmh+rJ6VkctcaigndH30yz4J1e+FJk0kbrfYu6fDNAfN7Z2T43IHEhb
   LSLBeITlKjsqKZSZjqbNo0ljBXQcfhHb8f9vaiZRd4FR3g8X6JxsABzaL
   eFhRXRWPCujPzkGLsqlQavH73BHJEM3A3CUopn2IVU5LUQjcnFadzsNAo
   phhgOGgPLrj2cgdgeOzUsKwPfXUjC3PU68KDm6x6XHX3f2yhEbmu0omFi
   2Iw9VLcf+HswxBBcHBd3lanay7Zm4h4aRYZ069D0Q6YgChSbB6PJAX+g+
   w==;
X-CSE-ConnectionGUID: 8E2uLc1IRb2eb3aaDM93XA==
X-CSE-MsgGUID: Pt2cMSCkTZOrKCWFEOfUSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13170257"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13170257"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:20:05 -0700
X-CSE-ConnectionGUID: eAAshPejSTO9bYY/tgY3Bg==
X-CSE-MsgGUID: ElrHQ9duQUq+ev6u3ztCWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="66465436"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:20:04 -0700
Date: Tue, 28 May 2024 19:20:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529022003.GG386318@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
 <20240524082006.GG212599@ls.amr.corp.intel.com>
 <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>
 <20240529011609.GD386318@ls.amr.corp.intel.com>
 <2b3fec05250a4ec993b17ab8c90403428ca5c957.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b3fec05250a4ec993b17ab8c90403428ca5c957.camel@intel.com>

On Wed, May 29, 2024 at 01:50:05AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-28 at 18:16 -0700, Isaku Yamahata wrote:
> > > Looking at how to create some more explainable code here, I'm also wondering
> > > about the tdx_track() call in tdx_sept_remove_private_spte(). I didn't
> > > realize
> > > it will send IPIs to each vcpu for *each* page getting zapped. Another one
> > > in
> > > the "to optimize later" bucket I guess. And I guess it won't happen very
> > > often.
> > 
> > We need it. Without tracking (or TLB shoot down), we'll hit
> > TDX_TLB_TRACKING_NOT_DONE.  The TDX module has to guarantee that there is no
> > remaining TLB entries for pages freed by TDH.MEM.PAGE.REMOVE().
> 
> It can't be removed without other changes, but the TDX module doesn't enforce
> that you have to zap and shootdown a page at at time, right? Like it could be
> batched.

Right. TDX module doesn't enforce it.  If we want to batch zapping, it requires
to track the SPTE state, zapped, not TLB shoot down yet, and not removed yet.
It's simpler to issue TLB shoot per page for now. It would be future
optimization.

At runtime, the zapping happens when memory conversion(private -> shared) or
memslot deletion.  Because it's not often, we don't have to care.
For vm destruction, it's simpler to skip tlb shoot down by deleting HKID first
than to track SPTE state for batching TLB shoot down.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

