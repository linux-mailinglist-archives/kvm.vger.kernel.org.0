Return-Path: <kvm+bounces-32202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD8A9D41F8
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0BE5B29F52
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53781C761F;
	Wed, 20 Nov 2024 18:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dfa99b90"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2421BDAB5;
	Wed, 20 Nov 2024 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732126367; cv=none; b=ZEFWKDxmemknRaSx56XTHcjBPpg56LY0EEqU2zvSLPaFG/anXzX0wQQ7uzQJHHSiDn+ZncTUlpvyvXYPtaHmNKHOU8tvU8+/VOUeFIIssRFd8RKJdzQrnQtgoyzpRi3J+5/vII3mBOTuWDCvYJS4/KMOnNXQESDDxorQn03hpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732126367; c=relaxed/simple;
	bh=ioxxLAUmczTtwoDDSxGkvsdiX6i9vCPHTedkjZs4s1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAWQ6HB76jZ1NKpqLMsZ9fM/I4oqw0zC77rxPC1uM1fEBLXiH5AZp8dX19ia4Bi7LiDM5Bc3ypj3bewLg/T3+iZDsyNzFuQzNQaX3QkeASB6VFwaq9mu/Luw3THkR7dP1esmNs/LYBISnpk+BV/SsKRAzW5TGJbwPbMS2RlE6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dfa99b90; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732126366; x=1763662366;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ioxxLAUmczTtwoDDSxGkvsdiX6i9vCPHTedkjZs4s1A=;
  b=Dfa99b90qaggY0M4T1cHdDp+mLW8IYv7Ydif0M27OMWnTg7vHECJLW9k
   XnLrLlPUYswpwx4gooTkasdNaB9ooHspnTwbThrOKKxy5gPlbeS+TxnJr
   3il7oHrigsJBBTvrZzlj+1zwNY0KsGxHqZM8oirV23O7LbHbhzGrxOKXO
   z0HSo1OEISZEUl1TN6aEgvEUMVwLTmBwFaPxHgBfNwhhjPsSuE4gWI1ID
   9DZNqaJgxT21S/IifvRWRp0RU2wAF0WQ0GdP5UdVdgFithtFS6SqqH/Nx
   2lG3dphwLOHHjihGLNUi7fzIzY9dpC4cSU3so22F9km/AF4asJhFl1YOA
   Q==;
X-CSE-ConnectionGUID: zwVUcXIJSU+WQ47D8ciCZQ==
X-CSE-MsgGUID: nexgseX/T/CAR0cfPhjpQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="43587848"
X-IronPort-AV: E=Sophos;i="6.12,170,1728975600"; 
   d="scan'208";a="43587848"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 10:12:46 -0800
X-CSE-ConnectionGUID: MnaaUSTUQzeAUDvKUoogeA==
X-CSE-MsgGUID: 6J9o4yNOSt2NIfz72mDnzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,170,1728975600"; 
   d="scan'208";a="120863679"
Received: from abkail-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 10:12:45 -0800
Date: Wed, 20 Nov 2024 10:12:38 -0800
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
Subject: Re: [PATCH 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241120181238.n3xwpd6uticlaw4a@desk>
References: <cover.1732087270.git.jpoimboe@kernel.org>
 <2e062b6c142bb3770a0829e2cf21e11e8fb6ae5c.1732087270.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e062b6c142bb3770a0829e2cf21e11e8fb6ae5c.1732087270.git.jpoimboe@kernel.org>

On Tue, Nov 19, 2024 at 11:27:50PM -0800, Josh Poimboeuf wrote:
> eIBRS protects against RSB underflow/poisoning attacks.  Adding
> retpoline to the mix doesn't change that.  Retpoline has a balanced
> CALL/RET anyway.
> 
> So the current full RSB filling on VMEXIT with eIBRS+retpoline is
> overkill.  Disable it (or do the VMEXIT_LITE mitigation if needed).
> 
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

