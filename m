Return-Path: <kvm+bounces-11612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C8E878C56
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EC3A1F222F2
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B244C8C;
	Tue, 12 Mar 2024 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GN4pmvOW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C521FA2;
	Tue, 12 Mar 2024 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710207246; cv=none; b=TxPkLrSxPiizS4idxg0KjrowB5GCbQX0qOkU+nODvBq2j8vDOSTNmL8ROfcN46b2vyR5jz/AoKphW/o4j7M8BIGkzIBfOCjkbsbeb9YMTnPmYN2Dwy2hUOH+IoctGi+q5tE7HH7Z1W4NgB0icWzUJulbEsua7PMChWGByxCfTAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710207246; c=relaxed/simple;
	bh=vMH7ngXaCbAZQBoLirYLqEQfgWND9pS2Zgg4wttLtMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0AxFlvj8ahBeKaxS7ejk8IzN8beG726xsCEgNvC1WpCurHwaAethTKTwauPCtkjPJO0b//x8DzMMzZI7nw7RpwzFL7QhW/jNfyaouxXzH/hV1qgf8wM3QtHXb7bW2WdEllOGWd3ELubTpL2IYsCwwuDPpXjfhqVOIMpJqv/1Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GN4pmvOW; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710207245; x=1741743245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vMH7ngXaCbAZQBoLirYLqEQfgWND9pS2Zgg4wttLtMg=;
  b=GN4pmvOWd+Zf7df75X/HSozmyg9zO55TtOAR5vJnA/oZnyH6F4Sf3/Nl
   E3HSMUJKPIW+I9ITJVwbVJzj3wBd9QOzTJPQhj3sMi+fP7kO8QqpSfyY+
   X5CzUQqOr6I7XlqM8CGyztZmjjRSbcD3+FMgsKePgGxjlQnGmEkpgSz0w
   RjtRkFB4gx6bLQzAk/aFYLH2+V/KIHK8RWGIkb3jJMV/z0z+KGjDWSNbG
   f0SDc8NTboog14t0ne0uo1QzApCMhsTzTO/TneZTNjFzTDex/JK53TNA4
   bSczwO+MRyQSmmBMFh31W9/wk/VslQsnLyPdfMn2uWpiAEBxBA5r7s51E
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4822225"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="4822225"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:34:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="42276793"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:34:04 -0700
Date: Mon, 11 Mar 2024 18:34:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240312013403.GE935089@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com>
 <ZepptFuo5ZK6w4TT@google.com>
 <20240308021941.GM368614@ls.amr.corp.intel.com>
 <296e1196-9572-4839-9298-002d6c52537c@intel.com>
 <bf8e5e51-422f-4ecc-ae10-ee13c68eea8f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bf8e5e51-422f-4ecc-ae10-ee13c68eea8f@intel.com>

On Mon, Mar 11, 2024 at 02:08:01PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> Maybe just the "underlying physical pages may be
> > encrypted" etc.
> 
> Sorry, perhaps "encrypted" -> "crypto-protected"?

Thanks for clarifying.  Based on the discussion[1], I'm going to remove
'source' member. So I'll eliminate those sentence.

[1] https://lore.kernel.org/all/Ze-XW-EbT9vXaagC@google.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

