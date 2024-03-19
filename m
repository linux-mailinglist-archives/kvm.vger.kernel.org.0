Return-Path: <kvm+bounces-12163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB9C880261
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFDA21C22F88
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F0616423;
	Tue, 19 Mar 2024 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwA6f1Lg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB695111B1;
	Tue, 19 Mar 2024 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710865992; cv=none; b=BdPewOrL/ljSsOmUgjzE5caajOEWEnoH8IOUFqNTVubVCnMMgLT2AE3h5PGpdsSMKO+VmidzxXSD1cso1Jd1MrEGnACEfL6OLX9KwavGBDbQK5kivaOUmTLENdM6Ae5eIuO4rmeowTh442c0RgFKdDOU2ctNhZzS6bHoJD7yNO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710865992; c=relaxed/simple;
	bh=CeSuf34/jNpbYW011k2s5HeIiCXlBsD3n8WDQsNB1Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMAMNBWk2u58vhSQFzWpU86JtSnG8+U4DYUr0nemsqmjsfftPgVWP5tmxwkFfIxumPA53i4cwJBO0KlwNCihZrWhW+LyDSfVy9Z3a8c8DCaNtJN2KGLYS1lollMAfNRCsAyRnit8CD7e4iNsfDu5BKVASBacWnofau5fa7gDDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jwA6f1Lg; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710865991; x=1742401991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CeSuf34/jNpbYW011k2s5HeIiCXlBsD3n8WDQsNB1Vw=;
  b=jwA6f1LgEg8uvyptxHEcqW+9z/+QmfQ2qfQ3qQdiQNCv60AlTdBFdCEk
   vOyhKupFPXsZSm1HdGebHxRf+44kXKpScUG3AAZu//cgND/m/zUfGqpDv
   DV6+CLMh+C+jUBvoQgndg9Oo7PirL+3zCIihhmaDCX1LJaLEJ6ih2Ywv4
   W/MpYxyVNt+Ukuhf1X8+WU4J8gcEXuxy+jO35K8kfhLQHCuJkXgU4XfVn
   FzGOHfc4jaz+SCesmKKyuxRgVeTCQQ9zDJcI8o+FQLRjHR+SbqZDX3Luv
   HfwE2GV0YI1S9hJazvDNenpTAfoM3+OWG8RGvB2bmHCnDmr41dai7pYYT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5609688"
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="5609688"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:33:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="18513375"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:33:10 -0700
Date: Tue, 19 Mar 2024 09:33:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: isaku.yamahata@intel.com
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	isaku.yamahata@gmail.com, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <20240319163309.GG1645738@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <ZekQFdPlU7RDVt-B@google.com>
 <20240307020954.GG368614@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240307020954.GG368614@ls.amr.corp.intel.com>

On Wed, Mar 06, 2024 at 06:09:54PM -0800,
Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:

> On Wed, Mar 06, 2024 at 04:53:41PM -0800,
> David Matlack <dmatlack@google.com> wrote:
> 
> > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Implementation:
> > > - x86 KVM MMU
> > >   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
> > >   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
> > >   version.
> > 
> > Restricting to TDP MMU seems like a good idea. But I'm not quite sure
> > how to reliably do that from a vCPU context. Checking for TDP being
> > enabled is easy, but what if the vCPU is in guest-mode?
> 
> As you pointed out in other mail, legacy KVM MMU support or guest-mode will be
> troublesome.  The use case I supposed is pre-population before guest runs, the
> guest-mode wouldn't matter. I didn't add explicit check for it, though.
> 
> Any use case while vcpus running?
> 
> 
> > Perhaps we can just return an error out to userspace if the vCPU is in
> > guest-mode or TDP is disabled, and make it userspace's problem to do
> > memory mapping before loading any vCPU state.
> 
> If the use case for default VM or sw-proteced VM is to avoid excessive kvm page
> fault at guest boot, error on guest-mode or disabled TDP wouldn't matter.

Any input?  If no further input, I assume the primary use case is pre-population
before guest running.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

