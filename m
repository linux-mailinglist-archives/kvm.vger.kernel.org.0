Return-Path: <kvm+bounces-41149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5103CA62CBF
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 13:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81238177F32
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 12:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BAB1F9428;
	Sat, 15 Mar 2025 12:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="febno3Nf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A144915C140;
	Sat, 15 Mar 2025 12:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742042208; cv=none; b=rd0iKJ0NY9VJZMlgVTtkImDU3LvG1dhzhS5SZjKNNSqk6+f/ftWDvGMFEKhkJasWHL5DAzNNGhoID/sYyC2gIFpY6X5+PuUjXNqm29NEjT9mCJfeelWAE6N6feIVmkTor+dGp03DajQYeiOQUOicga3QIvF+bGKZF+00mWcg1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742042208; c=relaxed/simple;
	bh=YyKlvmt29Qh2Vkd470jIaliRDoZX2OW1srIhXE3bD1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFHUkIpbhvtyAfpjlfgBjzQOhMKWOn0OzESuSfQDVIIVY8ID+7RhvSY3w0RYyFz7RKLPblfjyL3Vpb35j28aWWURs3Fj9PVIz0hOgRo7DHxG9PuBIk0cYZh7Sn9BaID7eVWBYz3EmNkWby6ObhJyMtSaGhJQ3yZDUWdikMGt9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=febno3Nf; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2AB6740E023B;
	Sat, 15 Mar 2025 12:36:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oiQ0AIcHenPW; Sat, 15 Mar 2025 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742042200; bh=no3h006TL8d+tZb6q5JHQ+7Etc+Dkicu7VnboW7pPiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=febno3NfInG9kTLllv7hdm0+Z9EqW0/pQPleMXPOZIiYCzOZvIE+JmSsz9GJ1M0U3
	 IdPC9LBczQ/RwicKdYgROP1v0WkhskCgRIsHf8GLGKfMhp2YM4A0fYaf9h0vzF6PQ5
	 xTH8hqgOlJix7efCqcZac6hMQzFFop61gYILNc5G00CiMae/rEbgab1MFRzw0LPJHM
	 Vh7WNDjW0vTsjx16G56RQmbf5cBQ9SNLvrEaQoN7hF/gU7QXxYd6+9f8FBRot67xw7
	 MNHaPUADBNU+afVjQhS/UHlM/w+H+xY+l+iWJU1XUsaFSTGsAdIIQZ/HeeU/LkQWJI
	 ZO8EgMJuneWdb118m5cFcogUe6OczZZTKTDuu3fiLUaQQVaNSQEYY9f4CoBEIlSQ7L
	 wuFvuCHmUglaAEhq1wWfvt/Y9HMKnB9okVuqIlnRlldj+EtAzjh6ok1T+t9lUO3KAg
	 gadM+yA20p1hC5Pp+VKXV0HOjcIr7exPkGOB6ifz1Oq6wqInci3qKPIV9T+OGb7uFA
	 Z1VSGm3gcSFt0NryxA7Fz/nlYgKFvfYCKsVqHg4G4cYKQrsp22Xc0c+9lgYhei26Ao
	 PaIJJkQZ1eDb2F8Nt9JXlEnt6LnNyMlv50pWBvYyIMzYT1DzKe9Pj4ytwiQ1JJOCav
	 4nwQR/nKLcZ9aZkMxRl6ADX4=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1B39E40E0196;
	Sat, 15 Mar 2025 12:36:28 +0000 (UTC)
Date: Sat, 15 Mar 2025 13:36:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Junaid Shahid <junaids@google.com>
Cc: Brendan Jackman <jackmanb@google.com>, akpm@linux-foundation.org,
	dave.hansen@linux.intel.com, yosryahmed@google.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterz@infradead.org, seanjc@google.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
Message-ID: <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
 <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
 <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>

On Fri, Mar 14, 2025 at 06:34:32PM -0700, Junaid Shahid wrote:
> The reason this isn't a problem with the current asi_enter() is because
> there the equivalent of asi_start_critical() happens _before_ the address
> space switch. That ensures that even if an NMI arrives in the middle of
> asi_enter(), the NMI epilog will switch to the restricted address space and
> there is no window where an NMI (or any other interrupt/exception for that
> matter) would result in going into vmenter with an unrestricted address
> space.

Aha.

> So
> 	asi_enter();
> 	asi_start_critical();
> 	vmenter();
> 	asi_end_critical();
> 
> is broken as there is a problematic window between asi_enter() and
> asi_start_critical() as Brendan pointed out.
> 
> However,
> 	asi_start_critical();
> 	asi_enter();
> 	vmenter();
> 	asi_end_critical();
> 
> would work perfectly fine.
> 
> Perhaps that might be the way to refactor the API?

Ok, let's see if I understand the API better now. And I'm using function names
which say what they do:

I guess the flow and needed ingredients should be:

	1. asi_lock() or asi_start() or whatnot which does that atomic switch
	   of asi target. That tells other code like the NMI glue where in the
	   asi context the CPU is so that glue code can know what to do on
	   return

	2. asi_switch_address_space() - the expensive pagetables build and CR3
	   switch

	3. asi_enter_critical_region() - this could be NOP but basically marks
	   the beginning of the CPU executing "unsafe" code

		<... executes unsafe code... >

	4. asi_exit_critical_region() - sets ASI target to NULL, i.e., what
	   asi_relax) does now. This also atomic and tells other code, we're
	   done with executing unsafe code but we're still running in the
	   restricted address space.

	   This here can go back to 3 as often as needed.

	5. asi_switch_address_space() - this goes back to the unrestricted
	   adddress space

	6. asi_unlock()

Close?

Btw, I should probably continue reviewing the rest and then we can circle back
to this as then I'll have a fuller big picture.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

