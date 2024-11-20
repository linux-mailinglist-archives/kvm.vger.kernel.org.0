Return-Path: <kvm+bounces-32181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B029D3FEF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 192D21F23500
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D101A145335;
	Wed, 20 Nov 2024 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViG1yl9X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED53B1537C3;
	Wed, 20 Nov 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732119683; cv=none; b=S0gkpmb1Nn2XY40xL/ob8Pyd6yTLCGIYJw1vs5s/kchfyouVu5OwKejvVC/MFFnaDOys0hnj/SnrXyULasr1lqGfOEyR1LJ1vkagD8YkvDKRleuQhWOP+OPZqrW/FO7qwdIJombtcnRC88BI0fAmC/fySJQgJIPOixa7W+zCfXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732119683; c=relaxed/simple;
	bh=8V0tVZLTAmcmPHYhysLCyCFUh8prNiIRw2JMFafb1N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aB+qMNWwiULN5O5Xv+BL7lWmVehUQJjq7IT8BF5bRowJTIwfG4ynMEQtECX658jjFQ0tFwa1RfQnSjzRBshav0FIspSOdwqqkoQpC66Sk1ArE7WJzn5hLH5e/idsdGNUubI1MLXDLTF3SgzbnKfijsdj2qPJ97vgmxNNChI2UmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViG1yl9X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE99C4CECD;
	Wed, 20 Nov 2024 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732119682;
	bh=8V0tVZLTAmcmPHYhysLCyCFUh8prNiIRw2JMFafb1N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ViG1yl9Xwx5EhE7iVka9N+4LNcIz5LoK60+wC9sjB8zm2yNFzF745MnIp6UTkciix
	 3bEgjb9ibT3PGPFlnYRoV0LKXNe2UosjoMJbc1N4e+ApzEBGQJ8n1Vqc8d8im/RYzA
	 MaCRVPsUuFH/CeqZLgIon/9FtmDTn9a5yBDAfCYlcs8AKw+opK+mWOkln9JOIgWMPg
	 +2Mk2s6pVjWszU5vxA9QzjLu/QZShqUcVbWzxvHlPbzwrNDuPu/SixH+yVTg9K5/wn
	 aMLtv3rDImDQIdGtTuxunIE9x4CI7q2Hxz6f6yH2o0309351UxuvBR4ESiJVpJpFtH
	 SotSZ5bxps8rg==
Date: Wed, 20 Nov 2024 08:21:20 -0800
From: "jpoimboe@kernel.org" <jpoimboe@kernel.org>
To: "Shah, Amit" <Amit.Shah@amd.com>
Cc: "Phillips, Kim" <kim.phillips@amd.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"Kaplan, David" <David.Kaplan@amd.com>
Subject: Re: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Message-ID: <20241120162120.z6zteeespf4cir4s@jpoimboe>
References: <cover.1732087270.git.jpoimboe@kernel.org>
 <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
 <b2c639694a390208807999873c8b42a674d1ffa2.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2c639694a390208807999873c8b42a674d1ffa2.camel@amd.com>

On Wed, Nov 20, 2024 at 10:27:42AM +0000, Shah, Amit wrote:
> On Tue, 2024-11-19 at 23:27 -0800, Josh Poimboeuf wrote:
> > User->user Spectre v2 attacks (including RSB) across context switches
> > are already mitigated by IBPB in cond_mitigation(), if enabled
> > globally
> > or if at least one of the tasks has opted in to protection.  RSB
> > filling
> > without IBPB serves no purpose for protecting user space, as indirect
> > branches are still vulnerable.
> > 
> > User->kernel RSB attacks are mitigated by eIBRS.  In which case the
> > RSB
> > filling on context switch isn't needed.  Fix that.
> > 
> > While at it, update and coalesce the comments describing the various
> > RSB
> > mitigations.
> 
> Looks good from first impressions - but there's something that needs
> some deeper analysis: AMD's Automatic IBRS piggybacks on eIBRS, and has
> some special cases.  Adding Kim to CC to check and confirm if
> everything's still as expected.

FWIW, so "Technical Guidance for Mitigating Branch Type Confusion" has
the following:

  Finally, branches that are predicted as ‘ret’ instructions get their
  predicted targets from the Return Address Predictor (RAP). AMD
  recommends software use a RAP stuffing sequence (mitigation V2-3 in
  [2]) and/or Supervisor Mode Execution Protection (SMEP) to ensure that
  the addresses in the RAP are safe for speculation. Collectively, we
  refer to these mitigations as “RAP Protection”.

So it sounds like user->kernel RAP poisoning is mitigated by SMEP on AMD.

-- 
Josh

