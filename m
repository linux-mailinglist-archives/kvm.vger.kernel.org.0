Return-Path: <kvm+bounces-11611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE53878C51
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1F6F280F8C
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2C54C8C;
	Tue, 12 Mar 2024 01:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUoSUydy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E217F7;
	Tue, 12 Mar 2024 01:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710207132; cv=none; b=HU1PG+Vo2ZOHDymc795CpaRf1Ur5tAkjhc+yElPiN4MvKkGVYxQ74qBvl183k0biFEnGPODcSAZuWQRZQBaViXiw8qsuqYZyzNVXwpgTo5JLXJKr9ei5/Y6TUCz1EZJo4HUehWESiKnjGO2CBHjdPkBXdgKA4rh+/rEVw2vRONA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710207132; c=relaxed/simple;
	bh=DQiMo2W6ZgCMZgmVW436D7oZbKZEGL/9fScs0o5heAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2KDLIs69I0rhZahclw8aRZhpWsT3ERGIE0J/8BFI5QQMfo34lcO/hQENhcHKk4V0nndfqMD3B6TWztA3ePn9yOlKDPYmwA8iW1aFinZd7cSsHAIrhbGbfD3NwWx4TZFL/UyKMmXQKqzOLw4WGo3EPJ9seqbUX2Y5BnJELgkykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUoSUydy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710207131; x=1741743131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DQiMo2W6ZgCMZgmVW436D7oZbKZEGL/9fScs0o5heAw=;
  b=KUoSUydydbi9m8ykI98fTwYow19ksmbe1mwouXDVpa3tsuMqk+cYdHME
   GeISQe0Vt9SL6NJTJAVmlj9eOBd8y+3d6Z6vhUzy6rX2vQwZ4pW/H27Mo
   muL7fKgJOgbkFr7zA/2/rKnOo7I6IBnH487/7PjWAHIxmzejjbOyEz6FV
   wUFGcDYS798h11OOoRxm0GYrKBD81AHqzwa3KpEq7Lrg4hWg7hgeDMxHJ
   ORTPi8CdCN3+q+GZ5968g/n9PVLRAJCpzTXUV3kKmlRv4LdxuI29pC70x
   K6mrligFDlvmksTXwaHxHBf03YwSG0J8Gu+9VGUQv5e1QaF6js7ne00nt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="27373543"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="27373543"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:32:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11278425"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:32:08 -0700
Date: Mon, 11 Mar 2024 18:32:08 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <20240312013208.GD935089@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <20240311032051.prixfnqgbsohns2e@amd.com>
 <Ze-XW-EbT9vXaagC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ze-XW-EbT9vXaagC@google.com>

On Mon, Mar 11, 2024 at 04:44:27PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Sun, Mar 10, 2024, Michael Roth wrote:
> > On Fri, Mar 01, 2024 at 09:28:42AM -0800, isaku.yamahata@intel.com wrote:
> > >   struct kvm_sev_launch_update_data {
> > >         __u64 uaddr;
> > >         __u32 len;
> > >   };
> > > 
> > > - TDX and measurement
> > >   The TDX correspondence is TDH.MEM.PAGE.ADD and TDH.MR.EXTEND.  TDH.MEM.EXTEND
> > >   extends its measurement by the page contents.
> > >   Option 1. Add an additional flag like KVM_MEMORY_MAPPING_FLAG_EXTEND to issue
> > >             TDH.MEM.EXTEND
> > >   Option 2. Don't handle extend. Let TDX vendor specific API
> > >             KVM_EMMORY_ENCRYPT_OP to handle it with the subcommand like
> > >             KVM_TDX_EXTEND_MEMORY.
> > 
> > For SNP this happens unconditionally via SNP_LAUNCH_UPDATE, and with some
> > additional measurements via SNP_LAUNCH_FINISH, and down the road when live
> > migration support is added that flow will be a bit different. So
> > personally I think it's better to leave separate for now.
> 
> +1.  The only reason to do EXTEND at the same time as PAGE.ADD would be to
> optimize setups that want the measurement to be extended with the contents of a
> page immediately after the measurement is extended with the mapping metadata for
> said page.  And AFAIK, the only reason to prefer that approach is for backwards
> compatibility, which is not a concern for KVM.  I suppose maaaybe some memory
> locality performance benefits, but that seems like a stretch.
> 
> <time passes>
> 
> And I think this whole conversation is moot, because I don't think there's a need
> to do PAGE.ADD during KVM_MAP_MEMORY[*].  If KVM_MAP_MEMORY does only the SEPT.ADD
> side of things, then both @source (PAGE.ADD) and the EXTEND flag go away.
> 
> > But I'd be hesitant to bake more requirements into this pre-mapping
> > interface, it feels like we're already overloading it as is.
> 
> Agreed.  After being able to think more about this ioctl(), I think KVM_MAP_MEMORY
> should be as "pure" of a mapping operation as we can make it.  It'd be a little
> weird that using KVM_MAP_MEMORY is required for TDX VMs, but not other VMs.  But
> that's really just a reflection of S-EPT, so it's arguably not even a bad thing.
> 
> [*] https://lore.kernel.org/all/Ze-TJh0BBOWm9spT@google.com

Let me give it a try to remove source from struct kvm_memory_mapping. With the
unit in byte instead of page, it will be
  struct kvm_memory_mapping {
        __u64 base_address;
	__u64 size;
	__u64 flags;
  };

SNP won't have any changes.  Always error for KVM_MAP_MEMORY for SNP?
(I'll leave it to Roth.)
TDX will have TDX_INIT_MEM_REGION with new implementation.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

