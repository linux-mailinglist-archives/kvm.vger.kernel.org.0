Return-Path: <kvm+bounces-12891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C00FF88EC87
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A0F02A32E3
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22894130AF4;
	Wed, 27 Mar 2024 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UBh/RaK+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030521304A6;
	Wed, 27 Mar 2024 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560151; cv=none; b=CWPJ2sEHeNdbO/aSV6q68S7LzMGycLn3yeq7rxrNS1r+t9V+0Kl2AB+z1N8vIKEmHYY+AdLOo7xRIM8KKL6mWRYonJ1lheTyXRj5b9UCrqtArmzrzTqjhdInJmmnlvzBmDOQH/JQhIMWo6XupPwH1D99nQ/TBXyta3nfwvPWrCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560151; c=relaxed/simple;
	bh=jYWITuVZk3q0yW/62whpMi2Vl5VxwGRyqXLkV6raZ/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9nBZzw5Lwb/PxFiWL1N9XSe2bT9zGbuTmpM+yrj6PFAEoFXppFu788Gz0yhMl5n2ZdM5i9JIf66sFGJTvMZA5hXJVimdGYGlWjXw/IQ+kEzFBArXkzWxk6sPxVhvsppYXpqu7KUh/hm/qHcLoufBX5zjpaNKAS3GtdEvWNtVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UBh/RaK+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711560149; x=1743096149;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jYWITuVZk3q0yW/62whpMi2Vl5VxwGRyqXLkV6raZ/k=;
  b=UBh/RaK+XUynvJQYN+VgB/PQOoD1hobCpl0ipzpGWj5VezMc37x50DqK
   vmgcc27IbK7q1Jn2oILM1NlSRIZxvwxR8waSSW82ndmd7HB4p5BvxS7do
   x4SGSB4zVV8fuQSV63Eik4VHxwJKihz71jnCGyanA45Kr0Jb2w6aUMelg
   inyYEPW8V7pvP/IqW2XVY8bFj/d34zNugzfitpga6ZfIl3sNl9RaSurLe
   J9Disurdnd8eWn+CMhMTp74MXlxVqh19x1GUCSKdUykUIl6gsqxU2138r
   kMp2ibf7Z6XQCOXW8ITT6GboSneJPzzGxH1FKvHopVyiOSE5mS7I7JBQx
   g==;
X-CSE-ConnectionGUID: 2ZwJajQ0S++Kc/ZkVNJJRw==
X-CSE-MsgGUID: 8e5X35IFSLW2vvB5UDJLGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9639798"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="9639798"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 10:22:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16993278"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 10:22:27 -0700
Date: Wed, 27 Mar 2024 10:22:27 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Message-ID: <20240327172227.GE2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
 <3c51ec38e523db291ecc914805e0a51208e9ca9f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3c51ec38e523db291ecc914805e0a51208e9ca9f.camel@intel.com>

On Mon, Mar 25, 2024 at 11:41:56PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > TODO: Drop this patch once the common patch is merged.
> 
> What is this TODO talking about?

https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/

This patch was shot down and need to fix it in guest side. TDVF.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

