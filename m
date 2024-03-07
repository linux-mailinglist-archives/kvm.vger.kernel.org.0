Return-Path: <kvm+bounces-11246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A78A98745EC
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFF182814E0
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D6A63A9;
	Thu,  7 Mar 2024 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RKdvvWik"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A073153A9;
	Thu,  7 Mar 2024 02:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777399; cv=none; b=CldTop4ZxfRCakm9lGC9rpags/a8dKArjioiV2uKqMdCaFy98e0oJAOeoIZA66hw1T0epufLYkhDdAs0QEZQTeEFPNvKU+JHtfm1VtpcLFa6b2hxurugdqGS0Y0XkDpFNlRZpRuxvUQWA9tS2dDxlXRLmiEGIJcJlv7hIXzy900=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777399; c=relaxed/simple;
	bh=GRzK8ViaMAxJeHXB+2h6QVlT4bjuo8GxQtmPB2W7JFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSMvDzv3SdIVHrbxtOEsKjWSY+RyBXFD5VUy106w7OE0XsdnPHMSPxU9PzVZduacp1FTL78bclct2Lvq1Ue+5WP4tWKM2rY5Ik4KH8iWzqAL5xr5CMCkrucQvzMqR7+Cyt6fDupxWdffbtuv5IiEfx2iV6Qy6oCHo6peYReTMnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RKdvvWik; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709777397; x=1741313397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GRzK8ViaMAxJeHXB+2h6QVlT4bjuo8GxQtmPB2W7JFA=;
  b=RKdvvWikUWWWr9Rn/p6iUhzGWpszBz76+8RlzuxpXzdZAbCXvN1wxlYv
   JcvP7dFg4Fhja54x3++SMeDutzmag3jNuXPmvsRyW1w10eUyslU8oMJwo
   jotdRP9fpjd5gbJh5lv1rQhrfrgVjJeOe+Y0RRiCnx3szdX90jjLLMX+d
   /W0sSHFpQWklhbmfnxT/l8AYCX3yIojqShDFg9DmUTlBTHIWWXfUuosi7
   FCuKfco2SDIOy7vLN4IDOkxboXeVzRpXs+6xSqFRQWSGGYVFOuk+YvJsi
   pes+wre3txPKrtuvUFdyiAVx/DCMRn6gBdxpM2YTF8LHGJfNTjsYEXNeO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4313173"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4313173"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 18:09:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="10383067"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 18:09:55 -0800
Date: Wed, 6 Mar 2024 18:09:54 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <20240307020954.GG368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <ZekQFdPlU7RDVt-B@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZekQFdPlU7RDVt-B@google.com>

On Wed, Mar 06, 2024 at 04:53:41PM -0800,
David Matlack <dmatlack@google.com> wrote:

> On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Implementation:
> > - x86 KVM MMU
> >   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
> >   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
> >   version.
> 
> Restricting to TDP MMU seems like a good idea. But I'm not quite sure
> how to reliably do that from a vCPU context. Checking for TDP being
> enabled is easy, but what if the vCPU is in guest-mode?

As you pointed out in other mail, legacy KVM MMU support or guest-mode will be
troublesome.  The use case I supposed is pre-population before guest runs, the
guest-mode wouldn't matter. I didn't add explicit check for it, though.

Any use case while vcpus running?


> Perhaps we can just return an error out to userspace if the vCPU is in
> guest-mode or TDP is disabled, and make it userspace's problem to do
> memory mapping before loading any vCPU state.

If the use case for default VM or sw-proteced VM is to avoid excessive kvm page
fault at guest boot, error on guest-mode or disabled TDP wouldn't matter.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

