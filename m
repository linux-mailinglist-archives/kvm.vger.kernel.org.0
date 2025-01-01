Return-Path: <kvm+bounces-34459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E00729FF47F
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 17:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9F891882449
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 16:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628DB1E2611;
	Wed,  1 Jan 2025 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BjgiuL3p"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48A6A33F;
	Wed,  1 Jan 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735748158; cv=none; b=kh8GWerFPeVlEO852tEsHS7kswbxd4Oy2IHViWTFUqj/jgY0hWrfB2A4EFV0E40AWgm6OW7sYGwC8P/KKUzW7RVWnjUqcI0CUb/hgWnMiY2Y7bSm7cVfi0wtE3ZDb+UxFr5PLXTa4czEIxBiqlelA2mvXKxrRXObD2pGbqLu/5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735748158; c=relaxed/simple;
	bh=BOf9Bar9fb3qXkOuUozLrc9pmZvKQITT6VvXn3Rt6Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X97wZ85p0tM5hoPPWSzrXdDPUv3EjonBoDZyyrPfpPOLtalDJQUeg+gI5+pkDtK84hwMoAVHUHxbJei5bb74ERZxY5SZapB5NW3OOYjCrzngwydkrmhVyhRqH5fY8+qLunXOZtO1aIwsokJPYY7txuRyyc2Fyz9hx99lwRs3Nys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BjgiuL3p; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D782540E02D6;
	Wed,  1 Jan 2025 16:15:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rO4wGGj0kHOW; Wed,  1 Jan 2025 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735748150; bh=LeAGf+0nfdA4stt7Yb7BgZrafFILuC0wCwBKyXC3JQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjgiuL3pwiPlTETuyEt3FYEOC/fS0nipqoBT3AvrQvnLqD+/N3lD9tNKZ+AHQIS/T
	 RW9t+QPzLwB9TnlVBGoiXm23Q+CXvRoqc3mq+3MgSu9yeosbl+lIbDqG4Y6h9vH5ym
	 NGVduGv2KMhpqOSeOB+CaOeqB6qeaEkhOMXZ0jsOo6xObpKmp5Jp+AwBbIxXkeLZZy
	 /+mTx+r5Mq8DxdWkKKBcSft6cnKr+c+MecxnqttXWtkWGSQvfuolbULHO4ZCda+a5Z
	 LAXa/9+7wZBL06F6MjW+PxYl+9Ki85DEPxBKGTdhdyecY/wDxFhj8XQEI7JYHnD3JT
	 qBfgjNEeBm6lXACF6pJqPdmOuXMw2ztWI7JLC7Dbdmvslildr6YYGLHnwrzyky5o10
	 Bf6iAUZiMQXlryQBFLa9BzKiE6PJMlUIdwWwZy4dSX41nkH1X1yOoCV832ShJvzfJj
	 V752GgHzhhAOszbf5cdY4NC6AgF7zvvTBwb0RYNzva0DmkNi6DOpsOiNS+xnhLSwmx
	 9f6vG1DrELb2G2P7nMNqkOvixY+154BCFxRPHC3r/2XBzNEzcSX/yD4uaZM2Xfv/Hs
	 3QWImJQbOdA/KFwby2FxRtb50B6OYdllrZRV74Vg+XH8o9WrypD6SpuuajglU9Tcg0
	 oTmWPJztf9Oi7zRCj1W+Y2bs=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C4AED40E02C4;
	Wed,  1 Jan 2025 16:15:38 +0000 (UTC)
Date: Wed, 1 Jan 2025 17:15:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>

On Wed, Jan 01, 2025 at 02:26:04PM +0530, Nikunj A. Dadhania wrote:
> As kvm-clock would have set the callbacks, I need to point them to securetsc_get_tsc_khz().
> 
> arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_tsc = kvm_get_tsc_khz;
> arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_cpu = kvm_get_tsc_khz;
> 
> For virtualized environments, I see that all of them are assigning the same functions to different function ptrs.

So just because the others do it, you should do it too without even figuring
out *why*?

How about you do some git archeology and get to the actual reason why there
are two different function pointers and then analyze whether a secure TSC
guest can use the same function for both?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

