Return-Path: <kvm+bounces-10137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C3286A070
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C000283704
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6EA1482F3;
	Tue, 27 Feb 2024 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ee1shJSH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC87C4F896;
	Tue, 27 Feb 2024 19:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709063183; cv=none; b=UNUuXUn3yX3tKwAtL9Ep3WLSghBlQ7T+qS9mBHtvKJ+SgqsRRK0NSNae7+qZxhaqUFfhBK/3HS5MZlguXvf5MpYlp/hsSm5AV2tA3fjjBRO81ez6l0rt1xAJXBc8ql+GBItNLSY0AQIm63bINU4KIWOp+7Qsjn0MlywcjnNqBGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709063183; c=relaxed/simple;
	bh=N7KwRP5bKOkxPnEHeYIOMj734ueqXgEYKkuX+3PGk9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9gSMBPOPpKElJXuFBE84ESuLqzeU991tqigP9RYkq6RwXoXSm/DiILXrdHihuJRvAETWgPryUcofKWrZMwdn96OVX36hEv+I7ckTlViV/pNsK5TsVjHi+ZscLRS6Jf/qXoHfXCzF9rvsahsU9lzzILtN3mWtAiQdSst6qvIBhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Ee1shJSH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D0FE40E0192;
	Tue, 27 Feb 2024 19:46:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RP2JviedFxYr; Tue, 27 Feb 2024 19:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709063172; bh=gjl5DhImKtXFO2OnbyFX2WAmTlM7Sa7herXxx57PDGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ee1shJSHTTY77pOxeV6lX9PhBW24vkwAZu1GFfbSQP/GOp+n9e88TWmMrHM6I6Pcn
	 K+xsMh0aZ5ciPX/htrgTf0j5HaW7jV8fq46EsCFW+MAYBJGZxzw5lBn9q9gnodbJEv
	 9g7Ep60KgsioFQh5meWvdWoExXXn54F/xKVh+xLln8b+R5D+6y8w9ql+dFhIyqEgTk
	 f42MS0vJBDbRzPoHNQWmlyabBldRkPD32sJ7AWxbuwM8PW6ZoJA1dMNas9qBYpb76O
	 E1xusY43RPH7sqn8NHjQpYta/17NCgYYRNsseeZkoVP6YSkwlZng1U/ikvMqQZ0CgK
	 EaPQPmWOQPhfKobeoKoW9YKsuYOzHprbwikeCihCjq3uM8YdvuhbF+aW+s10MoflO9
	 LBsIhQ9SZ/yw6sF2If+XaPDx7jxJw+X6oqCid05j45b1w7MHOz0lCjr4436ANuN9sS
	 yA5QrBqN6THK3K0Qpp9MqjvkJLIimKUz0bQNXkGzrq4HXjo79BNVsTDpC64igo3USi
	 jKie2nDQgidmsrIKf2Y9Hyw6Ig/YJuUpVqGy58IShs7d2uUAJCVqRpYhBtmmuh3nmA
	 iWhtTzdX4XuYhpQJzkgfC7zzSO4lKBQdEsIzC52VAG4jjaD1phKnCRlNi4CnZKUqd0
	 qDnDpTaJh6f8X/9BAzKur2B0=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D71740E016B;
	Tue, 27 Feb 2024 19:46:02 +0000 (UTC)
Date: Tue, 27 Feb 2024 20:45:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com,
	rick.p.edgecombe@intel.com, seanjc@google.com,
	thomas.lendacky@amd.com, pbonzini@redhat.com, mlevitsk@redhat.com,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/9] x86/boot: Move boot_*msr helpers to
 asm/shared/msr.h
Message-ID: <20240227194556.GEZd479Ek_lSfMf30b@fat_crate.local>
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-2-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226213244.18441-2-john.allen@amd.com>

On Mon, Feb 26, 2024 at 09:32:36PM +0000, John Allen wrote:
> The boot_rdmsr and boot_wrmsr helpers used to reduce the need for inline
> assembly in the boot kernel can also be useful in code shared by boot
> and run-time kernel code. Move these helpers to asm/shared/msr.h and
> rename to raw_rdmsr and raw_wrmsr to indicate that these may also be
> used outside of the boot kernel.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - New in v2
> ---
>  arch/x86/boot/compressed/sev.c    | 10 +++++-----
>  arch/x86/boot/cpucheck.c          | 16 ++++++++--------
>  arch/x86/boot/msr.h               | 26 --------------------------
>  arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
>  4 files changed, 28 insertions(+), 39 deletions(-)
>  delete mode 100644 arch/x86/boot/msr.h

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

