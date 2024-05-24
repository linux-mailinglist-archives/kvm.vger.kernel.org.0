Return-Path: <kvm+bounces-18107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E15068CE243
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E7611C2164A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 08:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C321129A75;
	Fri, 24 May 2024 08:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAGE4zEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79231292F3;
	Fri, 24 May 2024 08:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716538813; cv=none; b=LB9VRfSk7AO6M4yyW4BNb0n0uQrhromqVgbO13ut5oWNj4P3TFGXncLxeIDvoXyvedKlbQy+XmfMxbwQKv8RThd0FG03k5lEpOk5nYgYtTkeDrxQelW7JWpjWlgIM7th8kOBJmqQobAPmN7hajwW5hK9BaHC4lT2Bia2urophFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716538813; c=relaxed/simple;
	bh=+xGA9KaBSgBCEiAhABllk7n/yu/dZz74PjiyJpMJwGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSlLv9MU8tGY8UogeWNgSGKqdrqYyOLECY7fssf2RZerO86XZobXAtYrCe6/5O7KwFqoi6fEcm1hth/5LZiUepBwaYGknj052OCaLJIwSd71+EuKB8mb5pOpcYUR4gCA6zB40TRq3rpsCnbq95/xi+PmsGTZJXHh8sqhDhuv7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fAGE4zEC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716538812; x=1748074812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+xGA9KaBSgBCEiAhABllk7n/yu/dZz74PjiyJpMJwGM=;
  b=fAGE4zECq5Yu8Ckon3fBqxk5zPHjUVOlWMj0IzLUHUb8PjHaQ5yd6SvT
   mNQuvOSFXCoOkcYUgTUiZ2zuS33Q4cKGFZ378EKXuoW3Hr/SeUBFnGenW
   IG43k39JWBVJ68l/Weop2vRXmThP8eB+btzFqi5ohAO7wKOU7GBTjkrJJ
   c4VWUdBQRK9YSM2O6W9iAPK8guAVeLq97XmZ6A/dhDIw8j8Ph/AqSSsML
   +jnZtA21W8+9xGacNyVlsZDfBZJj+zd9LQH1EMYeq1v0iBL/WAzvgI/1s
   U9mCkBUfj4J32Bg6uHh9Z9x9010RqJa4R96HbQg9ZeMcg3GNub/dV5Zs0
   g==;
X-CSE-ConnectionGUID: wrpfELGxTVmP1Qt9TaLW1A==
X-CSE-MsgGUID: CGOgEnN2Qyi8kOF/Il8NeQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="24313557"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="24313557"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 01:20:09 -0700
X-CSE-ConnectionGUID: ehc9AIyISp6+kMyLAJQrRQ==
X-CSE-MsgGUID: yz1nRhXpSSGPCe6qImG0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="33872523"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 01:20:07 -0700
Date: Fri, 24 May 2024 01:20:06 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240524082006.GG212599@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>

On Thu, May 23, 2024 at 11:14:07PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
> > +static void handle_removed_private_spte(struct kvm *kvm, gfn_t gfn,
> > +                                       u64 old_spte, u64 new_spte,
> > +                                       int level)
> > +{
> > +       bool was_present = is_shadow_present_pte(old_spte);
> > +       bool was_leaf = was_present && is_last_spte(old_spte, level);
> > +       kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > +       int ret;
> > +
> > +       /*
> > +        * Allow only leaf page to be zapped. Reclaim non-leaf page tables
> > page
> > +        * at destroying VM.
> > +        */
> > +       if (!was_leaf)
> > +               return;
> > +
> > +       /* Zapping leaf spte is allowed only when write lock is held. */
> > +       lockdep_assert_held_write(&kvm->mmu_lock);
> > +       ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> > +       /* Because write lock is held, operation should success. */
> > +       if (KVM_BUG_ON(ret, kvm))
> > +               return;
> > +
> > +       ret = static_call(kvm_x86_remove_private_spte)(kvm, gfn, level,
> > old_pfn);
> 
> I don't see why these (zap_private_spte and remove_private_spte) can't be a
> single op. Was it to prepare for huge pages support or something? In the base
> series they are both only called once.

That is for large page support. The step to merge or split large page is
1. zap_private_spte()
2. tlb shoot down
3. merge/split_private_spte()
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

