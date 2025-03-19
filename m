Return-Path: <kvm+bounces-41495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B56FA69385
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 16:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2A071B654F4
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2E61D5145;
	Wed, 19 Mar 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CFWiM4q/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826C41AF0BC;
	Wed, 19 Mar 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742397846; cv=none; b=isDMaZ0mTfF4ukPCWm2f9zN5wicHFGw60Wy868BppH2g8JEx+zy/6W8Gtz+F2Dy8458SC+vf7+2sONkMCRELqep2DePgNM92R/WpB5EQoGTutcY3omwi2lT12z2lnlNMs5Wi2ZuXz4pQIBZif2Z0jaVgdtawmJRen9od52E2K5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742397846; c=relaxed/simple;
	bh=SuLiSg+iwQRmagl/zN6fVsyrGzHy4R1aJgFXqqFqzVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lie29vDQ13u9ef5/gcrIiNSI3PQ1ZI+FfB8aif7TXL9s9Eygj0OIxeUDDWD5gw8/uB7w7yz6EZZno67nk1h/LFF7yUhgU/TZs4h2dvvFyHBYght/X5CIgYuyqsUHwHP2XM0tNjv+16QYAtTES+ZyXP0ycYssMIdZqGuCmlmWlh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CFWiM4q/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 31BA340E015E;
	Wed, 19 Mar 2025 15:23:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2iqIG6A3kFW3; Wed, 19 Mar 2025 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742397832; bh=dTUlw5KEEZ97CTBCRQiFNuk0D3vXcvLCa8fhUwF5gGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CFWiM4q/rS8KAgDkL53q/bw3AZY7eKaEw0sO/ku1coa7PkfeSobS8NYPRjfCwlEsc
	 yYez9wiXQ4jDae7iWU100we1cQMMhVJkmxGMATbOWdGkEEThfC8WGYXDKgBKeXn7sG
	 mSVTJBRBxl54bNBqjzHd8ILDQM5qB5ykenFKKiWCHh+tUKwbql9HmNczvJZfioRB8D
	 V7zjxy7UFUO8Fmu2bF+WSbuu8OIHg43VKOgJl61g4aMzWR4lLp0OG2p2Zu81F7V3ru
	 PwGFdZOrrsJ8M8IrrXepdfXfVT6RVZU/JfNoGq0KdZxFreWRljsPexLJCQfZFd4P1k
	 1faZuFKMBMmn7Wg/2snOhsD5B5UB/d6c7CMX8Fvj/6k1LUVusPjCbS0KBWyzQZA9Km
	 l5HWu8AFczBX0no3wCGXgFTX8kecXLGEvPPTJSQoOypmqtn12mIfGSsZPdPDrYQjbY
	 BqW37uAw3sRf+gj2pIjvYNkhSzuRXBIlW5RDDlERz7yTGXeo1/DrKA+mTfBogPdlyn
	 xofvSE7f0vOq/s1TC+C85KVjmOP+MLuKEIe8+UEAmOaemLS0Tm4zglnTYQBxixSwy3
	 RNqtkVEav60ePCu2o1f9S/9oFm/PiB5sKzV2QLbzw8Zelsi0C5WNTqjas1DVkL0/1H
	 zZ5n6gsuKqxDP2ydevi7UNEg=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 739EB40E0215;
	Wed, 19 Mar 2025 15:23:40 +0000 (UTC)
Date: Wed, 19 Mar 2025 16:23:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Junaid Shahid <junaids@google.com>
Cc: Brendan Jackman <jackmanb@google.com>, akpm@linux-foundation.org,
	dave.hansen@linux.intel.com, yosryahmed@google.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterz@infradead.org, seanjc@google.com,
	tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
Message-ID: <20250319152334.GLZ9rhdrBYW2yXRbY3@fat_crate.local>
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
 <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
 <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>
 <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>
 <Z9gKLdNm9p6qGACS@google.com>
 <4ce0b11c-d2fd-4dff-b9db-30e50500ee83@google.com>
 <D8JEV1QJHY6E.10X36UUX60ECW@google.com>
 <14f9106d-3a34-4f10-ba4e-465c73c94eba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14f9106d-3a34-4f10-ba4e-465c73c94eba@google.com>

On Tue, Mar 18, 2025 at 03:48:47PM -0700, Junaid Shahid wrote:
> > Oh. Yeah. In my proposal below I had totally forgotten we had
> > asi_exit() in the context_switch() path (it is there in this patch).
> > 
> > So we only need the asi_exit() in the KVM code in order to avoid
> > actually hitting e.g. exit_to_user_mode() in the restricted address
> > space.
> > 
> > But... we can just put an asi_exit() there explicitly instead of
> > dumping all this weirdness into the "core API" and the KVM codebase.
> > 
> > So... I think all we really need is asi_start_critical() and
> > asi_end_critical()? And make everything else happen as part of the
> > normal functioning of the entry and context-switching logic. Am I
> > forgetting something else?
> 
> Yes, I think this should work.

Ok, what I read so far makes sense to me. That thing - modulo simplification
but even without it - is kinda clear and straight-forward:

ioctl(KVM_RUN) {
    enter_from_user_mode()
    asi_start()
    while !need_userspace_handling()
        asi_start_critical();
        vmenter();
        asi_end_critical();
    }
    asi_end()
    exit_to_user_mode()
}

Lemme continue through the set.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

