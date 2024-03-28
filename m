Return-Path: <kvm+bounces-13036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F49890C0F
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74BF8B256B7
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 20:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B8813A879;
	Thu, 28 Mar 2024 20:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myihduew"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18C4594C;
	Thu, 28 Mar 2024 20:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711659321; cv=none; b=uM2bP9lJk1I5PG29XP/h0cFbIJROAjsNw28W+oZoEP5nHV8urzR/dK5ikcahnfvmUBiLZF/52g6hrmS3GSghGMVGMkVNzjo1r/QgI0q/I8xYbMjpjkj7Ru/vCdyUKAynA/2UmKNevDibPHJ9+mPaAuUWbn+6m1RMpMTuKnuwYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711659321; c=relaxed/simple;
	bh=NlPf3KGnVETWty2mAwv7g0uKCHiSOl4SH1FWESdoYrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCY2KMC0Rpg4GVZIah8JnDhXFMR8kj2WrO++MYWvZIZ6TtESs2OprhvnaQc3WXC1YucyJCcP658uQWmkKBY0UNsHZa18YwkMeAmMNxX71akKxaID38pPcN/SVurF4AbmcuwUuhV5XznVb2I7Si2ocB6Hl2QEoJdIFEkJkAxn/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=myihduew; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711659320; x=1743195320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NlPf3KGnVETWty2mAwv7g0uKCHiSOl4SH1FWESdoYrc=;
  b=myihduewvEXAcX8PwFO4zNnu8OkGdhIIDzfQQzKaXWvYT969xpz/KkG2
   TFCExXj/YLq/EYs2NQzhwwo4AYTggA08bxkIFDWLa60vQpxtdFkTyuc29
   jYuK9t4Rqtg1nCp7U5eKDkTDH6JuMaX5eMD2vrT5wWz1V333D3QGf+8S+
   lYOnZmviPIwvp+FHO/1O2ehusrTU2Oiqh9lY7lJ05muWd/Iq7Hja1Cmu/
   TXua6DBQgtqPJbK1nI7WM7EKcYexG2NglRCxNToi5U/H/VV9an85IWp9K
   z78J50ra+ug8x7j4aNDHhaZWtiJTpFM5eKDWc1AKUc23KB0LQik2hcnuG
   Q==;
X-CSE-ConnectionGUID: rj9XjWBdTMal1W0jh5KYag==
X-CSE-MsgGUID: tusWMITURbOSzByzs43GwA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="10655603"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="10655603"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 13:55:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="17408469"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 13:55:19 -0700
Date: Thu, 28 Mar 2024 13:55:17 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 060/130] KVM: x86/tdp_mmu: Apply mmu notifier
 callback to only shared GPA
Message-ID: <20240328205517.GQ2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dead197f278d047a00996f636d7eef4f0c8a67e8.1708933498.git.isaku.yamahata@intel.com>
 <2f2b4b37-2b99-4373-8d0d-cc6bc5eed33f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f2b4b37-2b99-4373-8d0d-cc6bc5eed33f@linux.intel.com>

On Thu, Mar 28, 2024 at 04:29:50PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The private GPAs that typically guest memfd backs aren't subject to MMU
> > notifier because it isn't mapped into virtual address of user process.
> > kvm_tdp_mmu_handle_gfn() handles the callback of the MMU notifier,
> > clear_flush_young(), clear_young(), test_young()() and change_pte().  Make
>                                                    ^
>                                                    an extra "()"

Will fix it. Thanks.

> > kvm_tdp_mmu_handle_gfn() aware of private mapping and skip private mapping.
> > 
> > Even with AS_UNMOVABLE set, those mmu notifier are called.  For example,
> > ksmd triggers change_pte().
> 
> The description about the "AS_UNMOVABLE", you are refering to shared memory,
> right?
> Then, it seems not related to the change of this patch.

Ok, will remove this sentence.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

