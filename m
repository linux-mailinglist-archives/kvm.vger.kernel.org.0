Return-Path: <kvm+bounces-32206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F10DD9D4227
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5BA4284051
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C661AC420;
	Wed, 20 Nov 2024 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hscs2gSg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177520B22;
	Wed, 20 Nov 2024 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732128169; cv=none; b=tbrb1YUB325yjyGNn2WRECjZ++8RrqDIoIL6Zt/qucVYktW3MrjRFvb5myI2IIPObYskIBvgMps3QSDuZa4WYxeb5xGCcjaFJRPlXNkeoW/fh1LF8QPLclGZFIUtVZkrc0we2FkTVXB7qU3n3fcv2d4/mfPLZW/galRdQXHwImw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732128169; c=relaxed/simple;
	bh=28aQ2kyC3/EvsIU5pfY5flRbQcMW+sg4mGXUH29bVEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dr2XJVGbeu7+NJ8dnDFVGSdK6KcYRoPhQWVsnkAmT9ghJZ/jjYKuVGTUlf8DLaClyyvtCVtocnTaZFkZBAhYXfcYQIZoSVFSVaQskPVll8gDVdrr8BIbGFv0+M/VQ818TFhpB5IuzpybV4akr03dDrsc7B7n6jzBsJ6LyP58Jxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hscs2gSg; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732128168; x=1763664168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=28aQ2kyC3/EvsIU5pfY5flRbQcMW+sg4mGXUH29bVEQ=;
  b=Hscs2gSg6b7yTKaWLkg0HZ9iZpECOax0/8z4hgjPUuDr5Pv6gKx3S3SD
   TnDvqIc7LxUWA7aF9RiAf4c0pEKQ3uDTDOevOOEU8rD6HxLgJP/qnMSPz
   Gr2tXACP2HGO1UmiaMz6wgMg0ZhQTcLymhOmG2JYbBtXsUpS5yUb7kTRv
   yLjT9RiTAwn9NRQLesSj4eF84I1TZ6MEg8R26bJl0UyciQFOcLCETKsyy
   0d/vm4xHr66dIdatVXump4fsRrpTzCP0Q/H7+xkas02rTe0RMup3tGauD
   Wgtt+Mm0twlcqmhnMRkLZl1sKO23/mmAhJmavgDm2BkaKWd06tlA5AaWQ
   w==;
X-CSE-ConnectionGUID: mTqKa04iTSq2TMnw1hjxyg==
X-CSE-MsgGUID: YHm6r2XGTFy2WtqtFTi8vQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="54706886"
X-IronPort-AV: E=Sophos;i="6.12,170,1728975600"; 
   d="scan'208";a="54706886"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 10:42:45 -0800
X-CSE-ConnectionGUID: jHmHFH6yRECOpsI+vzoUOA==
X-CSE-MsgGUID: h9QtWv1DRU6eJCH5nCRmwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,170,1728975600"; 
   d="scan'208";a="95071096"
Received: from abkail-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 10:42:44 -0800
Date: Wed, 20 Nov 2024 10:42:38 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: Re: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Message-ID: <20241120184238.rddzpb7fhbhtqphr@desk>
References: <cover.1732087270.git.jpoimboe@kernel.org>
 <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>

On Tue, Nov 19, 2024 at 11:27:51PM -0800, Josh Poimboeuf wrote:
> User->user Spectre v2 attacks (including RSB) across context switches
> are already mitigated by IBPB in cond_mitigation(), if enabled globally
> or if at least one of the tasks has opted in to protection.  RSB filling

Is below less ambiguous?

s/if at least one of the tasks/if previous or the next task/

> without IBPB serves no purpose for protecting user space, as indirect
> branches are still vulnerable.
> 
> User->kernel RSB attacks are mitigated by eIBRS.  In which case the RSB
> filling on context switch isn't needed.  Fix that.
> 
> While at it, update and coalesce the comments describing the various RSB
> mitigations.
> 
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

