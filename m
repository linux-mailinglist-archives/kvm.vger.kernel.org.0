Return-Path: <kvm+bounces-39290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 762A2A4629E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:26:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C774B17DFCE
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41215227B88;
	Wed, 26 Feb 2025 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="chi0m7b2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE322154E;
	Wed, 26 Feb 2025 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740579782; cv=none; b=tnyWQKADM77Bsd3f6S9GyGCqSUl3JB1IsbSNEfdw04f4VZu38FwEoG3TlN9iQGZPKUBnAmXQClB8oPH2BYBS8fzKaJpBp5KYSV6M2LmR5KKc2cyRWlPrsTwxgXdMktDknDI5eL3igHdZs3XgGA/fYsq/U1eZjdjk20tGzIc6aNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740579782; c=relaxed/simple;
	bh=2xtZdg1o0mcGgtwPEq0nDvn90UkibPYUNiunJgBmxo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muB+e9q9Vmdj+J0tyBM6L2J3Rnqph4B/AbpfrLJFd2dEd/4SU+Pb7xMalmimS4Tjkv/7hxpmVWj6s7FHvz/O8gFTip8v5BcRu6fDQ3PxCe+BAm7n8vTnaqIuVxszy9UfklQCq6wQ54ikl3uYW/NBJPWnDQZsZc+CfQu5jSjtp2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=chi0m7b2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D817B40E01AE;
	Wed, 26 Feb 2025 14:22:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hB8TCgDSMEUl; Wed, 26 Feb 2025 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1740579772; bh=qV0BRFew9iIjwnorvNTFrnH55kkijGPj+DC5RPEAgKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=chi0m7b2audNsQyqqkMNNYIcEZbhaX5Tl0GKJ2dEEcWJfuh4UaVliV6yToRHGIQvx
	 y3ON/8CSY5aMQdStv76ckYVOkg6fbowpmnoXaRMmaZmcZaem47WrI9MYaNkhQrUwY+
	 RRWHisMeV/FTwDsvj33nU0IcdlQ6Sj0CaljBMkv+uAq2lY7TYq4Phkp+L2DTfbxyad
	 om3hEdIGRqHtn/ZlYV3nVGHp2AVHa3hosUvFMwK0k5ON0CPbi2vTO1DqbRjqm2M33S
	 CndwTv9PbEtuKEF7YQrWvpvg2KjDBYS6ManmI+14IwzwkM3d3/nykHakrQ7XsTxuuL
	 nb++XT75JPQ3MiElB3U9w8q9KRyClDI5YgeCVfkvktIxGHDzclMvxUlUz+9WbN5hX5
	 kAHiacVAw02DNYtk+WPCLRGbconc8oWWx3EZRcRYw6L0t68cvi5D3Bawup5QHg8EJu
	 BHnykzqStumQFOpmnfcQ9ahRupoabgHo7Mot/TDw7b3M96vK4ZHlcQlD5qDtFRXhr8
	 c8mJcYGYwecm3xRV+Tp4GZBjGsG8L9NN//hXNQMgq8s4FlI4n/nbc5JXxAx7l91Frv
	 NA9y/lp/qBLHU6pfLxEsA+bynefiMFL0n6JpWYaK6nu74Hy3/y2mSK/KcVc/x9fV74
	 kY9kZV1wPfQjWUd6ACx9yXjk=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C5CDB40E0028;
	Wed, 26 Feb 2025 14:22:30 +0000 (UTC)
Date: Wed, 26 Feb 2025 15:22:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Loughlin <kevinloughlin@google.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
	kirill.shutemov@linux.intel.com, kai.huang@intel.com,
	ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com,
	mizhang@google.com, rientjes@google.com, manalinandan@google.com,
	szy0127@sjtu.edu.cn
Subject: Re: [PATCH v6 1/2] x86, lib: Add WBNOINVD helper functions
Message-ID: <20250226142222.GGZ78jnpbBc45Nl9uU@fat_crate.local>
References: <20250123002422.1632517-1-kevinloughlin@google.com>
 <20250201000259.3289143-1-kevinloughlin@google.com>
 <20250201000259.3289143-2-kevinloughlin@google.com>
 <Z75t3d1EXQpmim9m@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z75t3d1EXQpmim9m@google.com>

On Tue, Feb 25, 2025 at 05:26:53PM -0800, Sean Christopherson wrote:
> /* Instruction encoding provided for binutils backwards compatibility. */
> #define ASM_WBNOINVD ".byte 0xf3,0x0f,0x09"

Yah, or simply INSN_WBNOINVD as that name basically tells you what it is. And
we have already

arch/x86/include/asm/bug.h:13:#define INSN_UD2  0x0b0f

oh and

arch/x86/include/asm/bug.h:12:#define ASM_UD2           ".byte 0x0f, 0x0b"

Pff.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

