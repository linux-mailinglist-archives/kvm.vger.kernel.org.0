Return-Path: <kvm+bounces-42532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF769A79973
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0809E3B4CE7
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19A1B28DB3;
	Thu,  3 Apr 2025 00:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5d/PuAP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD3118024;
	Thu,  3 Apr 2025 00:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743640486; cv=none; b=rsU5+bfb7fEh2tJackYgjPEQzpMxlBOvdzVIbDkPIoScoN1SAlRkyoH2wjZMcegKHroOtnKtWWB9D9BkKXhD8/Ilhs73ZiEwUJdi05maljyb1+7AiDtrfQlS+fzy05inh0KLTczXzQTFQLI8AR4SboBYHKPgtbLOxFljBA53oz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743640486; c=relaxed/simple;
	bh=5eika8kEa66iF+FLfC46ntBQt4ql8lkAtwKFpeEJYFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJrjkuUy8WZx41Hgb0yTf3dIbYAM1Rw+K3Q1TO9XPvPBMINn+QE2D+V7khaDejbaDqS9zBbSDwx//WjPfqKYS3hzEYAovRJl7LScxzm2sTpuywc/J5uYvqLKygkbfKLysiYVZt+nIhZoNf95j6ktukH6i1fLWv8iT+HyAGL8s9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5d/PuAP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22612C4CEDD;
	Thu,  3 Apr 2025 00:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743640485;
	bh=5eika8kEa66iF+FLfC46ntBQt4ql8lkAtwKFpeEJYFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5d/PuAP0zRPCrAvZv0YqbK7kN26FnfAkCaDdFm+hWY+ELH+8NXvmbu5/Lj4qxFMo
	 gax04m4bAtZ5Af2GdpooV69Hd5gyDbYEl+9R4vd5W/nZ7IHK0aM4G+TtHO8vNHSZO2
	 n05wvIPKRRuKAa2NfUlmTHYAgqSV6kZDedlBHkDaRRhOEAuuXw3Bv4JZE6vCAT0mVD
	 W+Kb2rD2fLT5aKNzwN1FLHhi2L/ZG3MCB4F/dvXsInn249GpXZHiXB4gzXJBPdxzIF
	 KmoBISvH0QqduLU14aHn7EdKpmP36kwjf5Vuhg8gtYz0gwpHbktSHabBblxLyXG3q/
	 27Jf+gd34njLw==
Date: Wed, 2 Apr 2025 17:34:42 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Message-ID: <ynp7rzrlqj26pgimogurymwmn2tpeg5knofowant2g3dvagows@5r3n4sy4buf2>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
 <Z-2R4_xF8H_DlEqm@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z-2R4_xF8H_DlEqm@gmail.com>

On Wed, Apr 02, 2025 at 09:37:07PM +0200, Ingo Molnar wrote:
> 
> * Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> > There's nothing entry-specific about entry_ibpb().  In preparation for
> > calling it from elsewhere, rename it to __write_ibpb().
> 
> Minor Git-log hygienic request, could you please mention in such 
> patches what the *new* name is?
> 
> This title is annoyingly passive-aggressive:

LOL

>   x86/bugs: Rename entry_ibpb()
> 
> Let's make it:
> 
>   x86/bugs: Rename entry_ibpb() to write_ibpb()
> 
> ... or so. Because the new name is infinitely more important going 
> forward than the old name is ever going to be. :-)

Indeed, thanks.

-- 
Josh

