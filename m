Return-Path: <kvm+bounces-14912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354538A798C
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61AE21C2235D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48ED613AD11;
	Tue, 16 Apr 2024 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z5kQaskv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578EB40850;
	Tue, 16 Apr 2024 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713311994; cv=none; b=Lf7Tt2MgNvx0QZvjETN9Knu2sKHFyWr5TM9YTPlHD/spc1xCbQTV7+ntG0uV7HBnzWrih7EsHvuHQ9bWj52U4YfiR1QaFAniHZyL2kLKLTW8AVz/WB/hddpr0GK9WzV0Ly/ECoCfX4lAnnF0JvsrcRzRB8JlPR7psGpF8ANapq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713311994; c=relaxed/simple;
	bh=Vx+HDH1cQHnldwgMARSmJhI6g68VoC6OilGGmpFSPpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrcy9rdYBAaHxpfyZRkWqjkBTjiwe0H9LgUki41INwh3iuxNrM4hMPe/4uELtxRSwfBCYgVvmDUhynWsgCf2zhDCThG4HbUMzW5RQHwBV4bDmeraKKxlgKmIptnVt4nnbbeeBrMJdSLGctw0G0+jH0rwgw4npIZc5gM1RJmhU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z5kQaskv; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713311992; x=1744847992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vx+HDH1cQHnldwgMARSmJhI6g68VoC6OilGGmpFSPpA=;
  b=Z5kQaskv3CvjMrtuO9zNM/7KBR5NaPZDry7TBj2WjHQ1tmr/FCqG5Mmw
   kdZcN8PpWQOC0sEnQH8dBS2JQPLD9ayIBiBd0p4Phmvy8g5sBGx+EWu2L
   OnJt8X0pU7qQIFkTjgpWxBnr58hwyzEQrM7C/5BwJzYZYOHPbbjPjNiGB
   VD0KqNqMuv9kuUKLsTag0zglwoWTkeEfkEKQ1dj6L6lGTRSHeKEMDveuh
   jfxA4lcP1UvQvscS48y+SXLYEUO5IfU1G2yfN0BkDnU42NYqoBs0huM/1
   JqtQH8uKJ+/5njdEEwXW8av9mLbFNdisXcpYBuubfRXDzNcjqr/ySgtPW
   w==;
X-CSE-ConnectionGUID: GT+7brLpTECL7KF9AMAaiQ==
X-CSE-MsgGUID: OhIbYortS+e/K79S5Ct02w==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8644669"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="8644669"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:59:50 -0700
X-CSE-ConnectionGUID: XXSph9GBSRGb6mGKaIuoEQ==
X-CSE-MsgGUID: HhJS9hzDSRKopR4VbWV+MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22297766"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:59:51 -0700
Date: Tue, 16 Apr 2024 16:59:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 04/10] KVM: x86/mmu: Make __kvm_mmu_do_page_fault()
 return mapped level
Message-ID: <20240416235949.GC3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <eabc3f3e5eb03b370cadf6e1901ea34d7a020adc.1712785629.git.isaku.yamahata@intel.com>
 <567468a068fb160b724a7fa1fa8c36767d9155ac.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <567468a068fb160b724a7fa1fa8c36767d9155ac.camel@intel.com>

On Tue, Apr 16, 2024 at 02:40:39PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-04-10 at 15:07 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The guest memory population logic will need to know what page size or level
> > (4K, 2M, ...) is mapped.
> 
> TDX needs this, but do the normal VM users need to have it fixed to 4k? Is it
> actually good?

I meant that the function, kvm_arch_vcpu_map_memory(), in
[PATCH v2 06/10] KVM: x86: Implement kvm_arch_vcpu_map_memory() needs level.

No logic in this patch series enforces to fixed 4K. 
gmem_max_level() hook will determine it.

https://lore.kernel.org/all/20240404185034.3184582-12-pbonzini@redhat.com/

I'll update the commit message to reflect it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

