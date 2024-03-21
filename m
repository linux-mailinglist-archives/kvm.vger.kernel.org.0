Return-Path: <kvm+bounces-12433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFC488627E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2E3E1F23B1F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB6E13664C;
	Thu, 21 Mar 2024 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CiJNTqx7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630EC135A55;
	Thu, 21 Mar 2024 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711056256; cv=none; b=KqIIc93a3U+7hzPZE6yWIc9hT8Jn5qT8/AnYGfr5ZpW2TePBUzMBbkEXcWwcQHqTLV12C4D8bi8t/c5psL4gW/T7ErLqE6gMHxRKc8151Eauc2S20GKGGb2gIDd3Osf7XD+PN9D85vvftgElZ6p2TcaRvyK0AZEeKHgfagAbJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711056256; c=relaxed/simple;
	bh=0YXDk0lo2amfuxfoAWLgdqVOuj49kR3I7zPhp3zFKBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJsFsuD2KSh+ODOCAfaV44Lc9fnShoS2WocTBJgMxYLOB0HzdepnkLtNjLx9/iJZrzrEqjmqmcErpvQtFvHmtFAcsRJliJNjiZxWVBnWLlL/Tts2LDcg8rkO/bQiUf94JQqfhmbKp9UdBZOz+sK++Jj8EKi24nPU1kuVWAaDo7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CiJNTqx7; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711056254; x=1742592254;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0YXDk0lo2amfuxfoAWLgdqVOuj49kR3I7zPhp3zFKBQ=;
  b=CiJNTqx7EL8rdHXuut3DhS9wrX3J1d4vo8CVbcJ9AqA9tVfTVX1Jk6xW
   fxy7Gr2LPRUw7TP3vtLLcCsqFGXS2tx0SJW6y3Hn9fMQSemEknjrNpE9O
   Uw9frRpCIt9vYyIOHZxpqt7Vz6LEGQWITMfb8Y5cHUPR9oNbnQhFc0nXj
   /b4dqvzbf9eFdY64eyIiNDlukLSwBahKjJLwPDEXqn/Ra995RqFXWbCni
   j2Vah4QPO2fpNdjrXuGo6t5NaR9+Z1zlxu+EnCCd023cIihekbS2Ts1er
   3gBtDOoyEjEfNvt6pz5Riknzs/ZklCqYG6zb9oCIPGenb4pCjJD+Erg7K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9847269"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="9847269"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14627431"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:24:12 -0700
Date: Thu, 21 Mar 2024 14:24:12 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Message-ID: <20240321212412.GR1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
 <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>

On Thu, Mar 21, 2024 at 12:11:11AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > To handle private page tables, argument of is_private needs to be
> > passed
> > down.  Given that already page level is passed down, it would be
> > cumbersome
> > to add one more parameter about sp. Instead replace the level
> > argument with
> > union kvm_mmu_page_role.  Thus the number of argument won't be
> > increased
> > and more info about sp can be passed down.
> > 
> > For private sp, secure page table will be also allocated in addition
> > to
> > struct kvm_mmu_page and page table (spt member).  The allocation
> > functions
> > (tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know
> > if the
> > allocation is for the conventional page table or private page table. 
> > Pass
> > union kvm_mmu_role to those functions and initialize role member of
> > struct
> > kvm_mmu_page.
> 
> tdp_mmu_alloc_sp() is only called in two places. One for the root, and
> one for the mid-level tables.
> 
> In later patches when the kvm_mmu_alloc_private_spt() part is added,
> the root case doesn't need anything done. So the code has to take
> special care in tdp_mmu_alloc_sp() to avoid doing anything for the
> root.
> 
> It only needs to do the special private spt allocation in non-root
> case. If we open code that case, I think maybe we could drop this
> patch, like the below.
> 
> The benefits are to drop this patch (which looks to already be part of
> Paolo's series), and simplify "KVM: x86/mmu: Add a private pointer to
> struct kvm_mmu_page". I'm not sure though, what do you think? Only
> build tested.

Makes sense.  Until v18, it had config to disable private mmu part at
compile time.  Those functions have #ifdef in mmu_internal.h.  v19
dropped the config for the feedback.
  https://lore.kernel.org/kvm/Zcrarct88veirZx7@google.com/

After looking at mmu_internal.h, I think the following three function could be
open coded.
kvm_mmu_private_spt(), kvm_mmu_init_private_spt(), kvm_mmu_alloc_private_spt(),
and kvm_mmu_free_private_spt().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

