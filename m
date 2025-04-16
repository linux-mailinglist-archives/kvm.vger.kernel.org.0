Return-Path: <kvm+bounces-43397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AB4A8B1CB
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 403937A8816
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0530C219A7E;
	Wed, 16 Apr 2025 07:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pmu527nS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268C22DFA4E;
	Wed, 16 Apr 2025 07:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744787829; cv=none; b=JE8c5V5Ik4pCo90z3naI56yAIILdPpLFmSCRmNDl2Hi+cTeW7HJuiVRGC+kgAW44tkbGznr5QEEt5XRnII9zS0e2GBJPlZCztdsjY5hmelpH1djRiX2ZqX6SKRqIwOad1k+ivN3dBVxtDtbMEM5MrjBnzopn937dTg5iTqLuNQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744787829; c=relaxed/simple;
	bh=IXKK0ukmF5Kl3ZgJ0mpuP+p8YAvc36j9OaE+6Fhbanc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeTmahMzwJh69B5k1YoYA38/1CWzcB2jjPGP/AKfOfyNhfTeg4qENDp6D88AEoXqMBD4/SUEj4HLkgmQ+n8WsKUoedTeaKStEdaa16vqrQ1ybzpNMYtz4XpHv3Sa3JH74j1CkAjCcVCfJ6lClrbR9HeQ9BQNGujhTv3WP0TWp6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pmu527nS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43281C4CEE2;
	Wed, 16 Apr 2025 07:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744787828;
	bh=IXKK0ukmF5Kl3ZgJ0mpuP+p8YAvc36j9OaE+6Fhbanc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pmu527nSj2R/zaECfDGMj10rRpLGoZ49rLUtUtO3KUf6xe0/p8aji3foCcXuNYWgR
	 QzKlJV905qmPXea7H1/D9N8NCQmecIvaN2mQa94u+hpF08UHtnn4azXzf2URRV0Sh8
	 xxA4ThQvfq/h3GKIIVH5W7+UEhi77mctcPDHNHbRSs+frAFrKvadYN9t2AL7YiRAs9
	 A03zv2/S0gh3vHXZ0M/ybLsNr2ZQHlfypgdrjBM+Te1/pWDxAhrw1XYGf4lbDvBccq
	 wFXndvz/XRx7N73UzTVxwrHY0URRvCx4kFi9GJ2dV5vBD8R0MGtqVoxirSVvvi6uNR
	 XAuEgz38mQShw==
Date: Wed, 16 Apr 2025 09:17:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
	Andy Shevchenko <andy@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/e820: Discard high memory that can't be
 addressed by 32-bit systems
Message-ID: <Z_9ZblhCgEeTgGQ8@gmail.com>
References: <20250413080858.743221-1-rppt@kernel.org>
 <174453620439.31282.5525507256376485910.tip-bot2@tip-bot2>
 <a641e123-be70-41ab-b0ce-6710d7fd0c2d@intel.com>
 <Z_4ISTuGo8VmZt9X@kernel.org>
 <c811f662-79fd-4db1-b4e1-74a869d9a4f1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c811f662-79fd-4db1-b4e1-74a869d9a4f1@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> On 4/15/25 00:18, Mike Rapoport wrote:
> >> How about we reuse 'MAX_NONPAE_PFN' like this:
> >>
> >> 	if (IS_ENABLED(CONFIG_X86_32))
> >> 		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
> >>
> >> Would that make the connection more obvious?
> > Yes, that's better. Here's the updated patch:
> 
> Looks, great. Thanks for the update and the quick turnaround on the
> first one after the bug report!
> 
> Tested-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>

I've amended the fix in tip:x86/urgent accordingly and added your tags, 
thanks!

	Ingo

