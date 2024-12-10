Return-Path: <kvm+bounces-33428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8330B9EB529
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7348C188889E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8301F1BBBD0;
	Tue, 10 Dec 2024 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bKt0MkRw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51921B0433;
	Tue, 10 Dec 2024 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733845052; cv=none; b=GtZ/8ESR8KNHOcmjnFD4wfPW+7111Yr+UqxebyA77CLyqsWSKFkCPjC7DuULNT+4doh3cUEw9fSpZAHpgZ749hq7zW1dN+sPReVC11JCt/eMj1wPGLtBH0XbZ6QNhn7fov1cVSOkpq4/Sxn4IGgIuJ5VopmEzP1pEWyLsMCgc24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733845052; c=relaxed/simple;
	bh=5UBLnPT6HIvLsS5QH4WOu5G99eHjGBdiyV0YRvJPJ+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQRVC/vzQ0SU46dUaYDKpXoHTNaJbBCsrscudlVkKXFtq02xVvoAEehOZANA6YKau/YtOMzkJlDNkoDIsUzuYMqrM0JDzIALaMr2e6FRH6/Q8cftx7aoZ5OyVJAI+Y6T9hs+7ffgY7cXftPE9iq+rhtiKS5PrnmcCFn4Ad/WRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bKt0MkRw; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AFDDB40E0286;
	Tue, 10 Dec 2024 15:37:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PWcxWWL22RTk; Tue, 10 Dec 2024 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733845044; bh=VPjdw+Eb354bv9tVRWybjMpXb9OUxx59dMw+TfX0QJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKt0MkRwHOmpStr8nzizXL09CNjus+A2ice6mREZYCgGOksuD9Ix+ByXrhRlSdpYb
	 z4k7yKLvYV2/pxhfAncP/nGXCI2fdR46a1cOGE2Ai/NZy0oizB8SKJD67WYDyULETe
	 I8o7YegEhoiwSTYOsz0oAJ4v4hRDuAEEC8FCqpxwcanuNEndQEDDYEPfrnnDS6nWPF
	 gHn7aaYu5c/v0iRfwctzITY2eHgxHhJY1ww6ZYWLsRnPSW4qSaDvUCcn7zX+K73ThA
	 5EHGrim/JH8u/8tCI09DN8Cm9ENIEA0G9Clch9OoOM/BMD6q3i1HXoMQsPI3zsEIsM
	 sE4zSttx/vgKMKq/36BXPP7AM2JgCcZv9PGxxoGgEZx+fi7FxQnfFk9qf/0/2keu52
	 omfWiMslCr6KxN9m+WgRZCeH9M2YlF4krMIl1eWXsShRJQfjIJ+uQGRuCLOb/ppJaf
	 y0KZrSPYuHK/98uObXlAnMSTkIfncu3VbslvjyQn3A/fVeaZSrudHanuIE0M/tvyZ6
	 NQQ7dMh1xgt8im6lwZbrTrXe0WWIMhL8gXJApWWCabrcYdnkWO29juwxt+dsS/cLdF
	 RAJ5ljElQ5s81AXcZPgFAuYxDtSiHY2Db7AdN1yXSJDB3LKwutduOuV1msoFhHq1Qx
	 xKW0sAIv3zpVHMqW4+nuiKh4=
Received: from zn.tnic (p200300eA971F930C329C23Fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ADA2440E0288;
	Tue, 10 Dec 2024 15:37:16 +0000 (UTC)
Date: Tue, 10 Dec 2024 16:37:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Borislav Petkov <bp@kernel.org>,
	Sean Christopherson <seanjc@google.com>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Message-ID: <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-2-bp@kernel.org>
 <20241210065331.ojnespi77no7kfqf@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241210065331.ojnespi77no7kfqf@jpoimboe>

On Mon, Dec 09, 2024 at 10:53:31PM -0800, Josh Poimboeuf wrote:
> The presence of SRSO_USER_KERNEL_NO should indeed change the default,
> but if the user requests "safe_ret" specifically, shouldn't we give it
> to them?

Hardly a valid use case except for debugging but if you're doing that, you can
change the kernel too.

Because we just fixed this and if some poor soul has left
spec_rstack_overflow=safe-ret in her /etc/default/grub (it has happened to me
a bunch on my test boxes), she'll never get her performance back and that
would be a yucky situation.

> That would be more consistent with how we handle requested
> mitigations.

Yeah, but if there were a point to this, I guess. We don't really need this
mitigation as there's nothing to mitigate on the user/kernel transition
anymore.

> Also it doesn't really make sense to add a printk here as the mitigation
> will be printed at the end of the function.

This is us letting the user know that we don't need Safe-RET anymore and we're
falling back. But I'm not that hung up on that printk...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

