Return-Path: <kvm+bounces-63020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01205C585DE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 16:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C3B23B82A4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CDC35C183;
	Thu, 13 Nov 2025 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="M9/Pgvzf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7012E8B85;
	Thu, 13 Nov 2025 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763046216; cv=none; b=qFDBwxei79g0faJRRENvN17ddrG1SKRA9AKMAWu0wM7L12ZaQsYmV5alDzQnSwFaPUKYVnOT0td7IL3Lk23FoAJl0uF+DLvU5ypUXsAqJLhFPFnV3/DXTvUOluLZ0guzdEeYpiP8xqiDTNDBBCpEa9GwsUqNV2Ltd2bHwbxcRrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763046216; c=relaxed/simple;
	bh=wQXQ+Y3xxm/cWKDXVZTTzjSHFk/xtG4cTkUjNT5/tBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dp4P+OjCREa8AWPkDw0hb+TJBQqIHJSh/Th19iiJRY5qOoNeB+pU3gs0iSPFwJSEgFF2A9ovTdAIWxNRsoLaS0U31XKvgyAKDBzZHm4TMYBHw9bzPJkEM5sHYTTog5MrpCjC6pC/lu2K05n+8KarirYeMz4uZDMIku883tcJkRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=M9/Pgvzf; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6E28240E022E;
	Thu, 13 Nov 2025 15:03:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id C5AG2QN0FSpA; Thu, 13 Nov 2025 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763046204; bh=jAYh6sabzhhvRce6fdBOQGM+VGKwYSBB6gU46uIrAOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9/PgvzfGeSdTP8s1tFJzY0sAZzcR6gxXbaLFoBWqafDgj1kKJ1j1or63nckAVRiv
	 x0V2/kQ9P5XTivpdoaoXPyKAU/K6+Lu0QOite0xbZuJkRTNtAhmMnhlh/PHNTdAmmJ
	 Bok3cPIDcP5SKO97CZ6v/farG2mub7m3VuN9npe59M9PKrnkFKgVHtcBIy7ZQ6079N
	 WkXa8nR26IRBSC2WVJuwq6htjP5Uf34YOyP0Vucj1FIFlkQhL3k+VYwd5GxGQ7e0i7
	 Pm4Y/FgywZSoP+CB4itYVcg2F219DiszVvRZjpfksvq8i/jacJPmC96T/cfdZFak27
	 w+wliEjnamKhjshb0qIpgC87em2eog5wmvQJtdf4giL8OKZkVT5lueW7w46nAofaXI
	 +T6rBce0NzvEA6yrbbY+j1e0IhcTnBvXk7DmBeUpINl5nSuEJp47+3p4sa0qUV0asW
	 1IYrn19MfbdB7kqHPejJauHUrqnOCdxwPXJuJxyyr/XdTmQeP2gf4lzqAqDgIrXs4/
	 BVznDCZzD5k9P/TuDz4prT485Z+bIPIzskeoqTf9QFG2igq7Z+8gDzTjAGRcdHN/2q
	 2WXpB+kzLVo/Z9ROyXluNwDRhZ5tKTj23va0j7DI4y/UD1vSITdU2EdS2I4bEhKiz9
	 uMr4e763KrrAYv1noV+vanAM=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 950A840E016E;
	Thu, 13 Nov 2025 15:03:15 +0000 (UTC)
Date: Thu, 13 Nov 2025 16:03:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 5/8] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM
 as SVM_CLEAR_CPU_BUFFERS
Message-ID: <20251113150309.GCaRXzLS0X5lvy7Xlb@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-6-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:37PM -0700, Sean Christopherson wrote:
> Now that VMX encodes its own sequency for clearing CPU buffers, move

Now that VMX encodes its own sequency for clearing CPU buffers, move
Unknown word [sequency] in commit message.
Suggestions: ['sequence',

Please introduce a spellchecker into your patch creation workflow. :)

> VM_CLEAR_CPU_BUFFERS into SVM to minimize the chances of KVM botching a
> mitigation in the future, e.g. using VM_CLEAR_CPU_BUFFERS instead of
> checking multiple mitigation flags.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/nospec-branch.h | 3 ---
>  arch/x86/kvm/svm/vmenter.S           | 6 ++++--

...

> +#define SVM_CLEAR_CPU_BUFFERS \

I need to remember to grep for "CLEAR_CPU_BUF" in the future in order to catch
them all...

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

