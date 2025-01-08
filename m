Return-Path: <kvm+bounces-34834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA6EA06520
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A697167E5A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ED320371A;
	Wed,  8 Jan 2025 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="InMCQvq2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B728C200116;
	Wed,  8 Jan 2025 19:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736363711; cv=none; b=e6u/lioS3TZleHXrFxSZzxqyuN6PG1CEHTgM+uyxDsC7qb71ocnMOcbwSyk0cBI5v3WDP7LmfSB8PXP6XwrL7R3TNGWSHls6gYInbdywznhYiLXhH4yEs7fdFB381mTFDZ9u7/69Dv1qo1SXyYf3x6PHiAN2ObVH8N3UCxWWWeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736363711; c=relaxed/simple;
	bh=v/YbEBNRH3UQUfdtG1CwjGMkkVuEIbYA/DKsN1OMOq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivfAY25F8xvXMGezu2Yfu6xdpAOzEy7FLip7V+os3dA2+9ftA7RlrtbtecVYq1heU/QVxjSAbmz9wTOG261w/vyiPfC96S7vRJQ/uEf+Rxt6cA7ANv+DzBdwoQOVV5sNfkZB4GvYgJP/8u64UtifHBYpkMGJiitsrBgdyYFBDTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=InMCQvq2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A7E1940E0288;
	Wed,  8 Jan 2025 19:15:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zsGelwC2IRIp; Wed,  8 Jan 2025 19:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736363702; bh=diu1H08q1pNWSKEXVlf+R2FSk4U5O6ex7UW4HCKvE7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=InMCQvq2i6KGDFSDH5aCAgCUxut4BpK7ufCICqDYakZPI5vuYqnkiTkGEvc67gDFb
	 wf2j85LQiI+XmTvFMYp6n/EB3Pb0cFtgTq/qMWFz2JsyuYojFDsbI3rvEdO9orcEC+
	 uCh09woNHDUoqKDlg61pHnVq64dn6qmvzpDnffeTX53cJ/dDSq70+r5cZLnA0SvyB1
	 08P+ebzbR01xAHrxavzUrsuXbr2JCi0373qkOMtnbdNEqf1wSRzk/SaSgcHdigHYVL
	 l1frS4ZrlMnZzscmIC1VvevkiImZqzEyom6FuWsop7I6HumVP1FijKJIbLjGk/T5mT
	 PxrG+vrgBO32zIM8Vbr55GgPztt5kdi2enNSmdVwxrsyDzeUf22xkl08km63T8rOhW
	 9ovFSGXnfS8qBRrmGWCOwL+F7AtPK2SxUV60mUNCYbRscxul5EmTipSLlPpXe1yuQi
	 mCrGgFYyIVqQAkGDzysB92N5/uhbdN+8dG08JzD36x5uNcsruZPJHDFJXcBfkFKwl8
	 vg318uHDl7PoShReGKxQrNL4U1IEwQ7aC1o5+etrTMqOiTyBKr4RUhX0mLsJKcu0vu
	 uu+3rs3dl2aIYa1X3+MAO/Fa2wDgoK5mkFuVxePhxJ5OYZTagnMwoPWaMxL1qUhoT5
	 oHo0r0xLb1FtgDBgSidHNIrg=
Received: from zn.tnic (p200300ea971f938F329C23FfFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7D30740E0286;
	Wed,  8 Jan 2025 19:14:53 +0000 (UTC)
Date: Wed, 8 Jan 2025 20:14:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250108191447.GHZ37Op2mdA5Zu6aKM@fat_crate.local>
References: <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <CALMp9eTwao7qWsmVTDgqW_KdjMKeRBYp1JpfN2Xyj+qVyLwHbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eTwao7qWsmVTDgqW_KdjMKeRBYp1JpfN2Xyj+qVyLwHbA@mail.gmail.com>

On Wed, Jan 08, 2025 at 10:37:57AM -0800, Jim Mattson wrote:
> Surely, IBPB-on-VMexit is worse for performance than safe-RET?!?

We don't need safe-RET with SRSO_USER_KERNEL_NO=1. And there's no safe-RET for
virt only. So IBPB-on-VMEXIT is the next best thing. The good thing is, those
machines have BpSpecReduce too so you won't be doing IBPB-on-VMEXIT either but
what we're talking about here - BpSpecReduce.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

