Return-Path: <kvm+bounces-31947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C53419CF257
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 702C61F22F7D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 17:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E2C1D5AA7;
	Fri, 15 Nov 2024 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdHlH1FF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D853A15C15E;
	Fri, 15 Nov 2024 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731690308; cv=none; b=pJ+VJZIiRa7KYq2j/+vg2jO0XoCJhPgxVDknhZSn1S0Se2K8n882qMqMDKsQ4iDPkuomlfS6Bw2vgzAJSTIxYpGtqzRL8r53dHEEU/ps4tVveoglLM4cExou7qOMJnmW/16HGzaD0XgqcdRWtfq3u79Sk37/a1klPt2Fa4fkQg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731690308; c=relaxed/simple;
	bh=IZXJjOHaQOlLB5hUWmL66GluwmMp25uxMZjNvQ7Gh2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuhozYd6yY9pVs6u/HLIoNfXgGVAG35S0DFJ0r+/sFa6efDWkXrvvHdb/8W6K533W17kAMpaRxO9HaH701S+Dz3qilmiqxXI7gpnxXpgFIUk0zqEqJWlNlVd2TWoh+0k0GvgxYd78TqYoihpTullBYgdw+h79RFoaUjSwQcQhAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdHlH1FF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD75C4CECF;
	Fri, 15 Nov 2024 17:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731690307;
	bh=IZXJjOHaQOlLB5hUWmL66GluwmMp25uxMZjNvQ7Gh2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdHlH1FFuWZGoAqVEiD0dtFMCOf3Pss8dTrG6uECfFHaLRAisDIEjWhkB7kTbsCBJ
	 LiHiqtmFBX94e5A9Zuj1/HjCViq9AtvCx8Uwdp6ZOqNnnsX2XpnooK4RwEhb+ttrrM
	 uE4YmjPeJ+DOWyeRQLUqBI6LeGWG6T7CnlQu4YXBhOFiv1JO2lDMLXy8L+qoA1/mZS
	 AD44emBEwFL4zXb3N3QIfp1fSlqwP2a2aA9BN75cKeyRItbVar/CMsBDHuBK726+Qp
	 6FfPZMZO8lQDCFlQZH1DPtjyxhfd/w6ZujKFxCcSMQRZKbWYnbreBwHsVf55eg8Rc0
	 CfOqmsNIq1WBg==
Date: Fri, 15 Nov 2024 09:05:05 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Amit Shah <amit@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241115170505.bngqx5ws52hhzzho@jpoimboe>
References: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
 <20241114075403.7wxou7g5udaljprv@desk>
 <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
 <LV3PR12MB9265FC675DE47911654E605E94242@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <LV3PR12MB9265FC675DE47911654E605E94242@LV3PR12MB9265.namprd12.prod.outlook.com>

On Fri, Nov 15, 2024 at 02:44:12PM +0000, Kaplan, David wrote:
> > On Thu, Nov 14, 2024 at 12:01:16AM -0800, Pawan Gupta wrote:
> > > > For PBRSB, I guess we don't need to worry about that since there
> > > > would be at least one kernel CALL before context switch.
> > >
> > > Right. So the case where we need RSB filling at context switch is
> > > retpoline+CDT mitigation.
> >
> > According to the docs, classic IBRS also needs RSB filling at context switch to
> > protect against corrupt RSB entries (as opposed to RSB underflow).
> 
> Which docs are that?  Classic IBRS doesn't do anything with returns
> (at least on AMD).  The AMD docs say that if you want to prevent
> earlier instructions from influencing later RETs, you need to do the
> 32 CALL sequence.  But I'm not sure what corrupt RSB entries mean
> here, and how it relates to IBRS?

Sorry, by "corrupt", I meant poisoned.  I think we are saying the same
thing.  Classic IBRS doesn't protect against RSB poisoning.

-- 
Josh

