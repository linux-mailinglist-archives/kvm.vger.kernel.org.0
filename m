Return-Path: <kvm+bounces-68307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15296D31059
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 13:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C787306B75A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DCC189BB6;
	Fri, 16 Jan 2026 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JUkQjtJI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7464E54723;
	Fri, 16 Jan 2026 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768566187; cv=none; b=UN28b+zxwXH8Odzau8XA916p+gu+If20RHKuKaK2NAFbV4pfY5OlxXsrwh2uiP8iYklQKj5irsuYtXrH9wSvTCpZXKWHwMHDOvavBCB5OrljVy5QCkWpA9JgXbQFzWTMDkqGjHOVCGvBe8MoTJEOGEkshkpLsVRcNH+jBzYpjzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768566187; c=relaxed/simple;
	bh=4+YoHlk3tupgjwNN98HvFV2urNEKpWandbYHfRmS/Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyitiZY/JtW6A07IS9exAO3+EHSx/m9CN+Esxr2Ksy2A57nDGXaLY3RRJPGKWLTqJAZMdmiPBGCX9dS6J+wfyHrUXMbJFm56ycSCmXb6h8LenTsv2+vlHvoYDWHw8zH2QOshbZxMfEvYsiZDk32XiTQwCLUaWVNFMrO00/qOfmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JUkQjtJI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0022840E02D1;
	Fri, 16 Jan 2026 12:23:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jpmD8IoxVeGN; Fri, 16 Jan 2026 12:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768566177; bh=wc6qbn5KZqqB5xsBMHaq62J78SCttHL2DXkFSeM7qoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JUkQjtJIpvD+OkV5azqH+oO8GpKyEew2HrNFl65zQFV2edJmmYDr077OreKgJdZNJ
	 CisEg90BgD2UfBxqfbXdHODY0bPzSJ5Ih67cmUz2T/qwAr9XCtRPl6rfO7erOVOnCr
	 wwADzoQ1eMaLl0XIvshx8ZyAx835UM9v1v3pGSuMu3jS6j78NKeF52BZuIIxVUmiPy
	 3ZqZ9kYDIyVuT5SafXOBufDvF6Eh4dM//rTR0IVZ27aufNzEHYrmlV4IU1Es8lKBYf
	 +fobOBpo0R4F6KyDv3WeZh0J3XtZ1KUBUADvfHZux3wPANw1bLT6hGmM42yQSSEwC/
	 96II61mUWBKM0YPmuIOuZAaxTdlj1qTY0UkqBjgVfpmji0gO1Uih+dBkugqj0vbfcU
	 R1iMDxl5UQYL+6SiXoJDmHAdKWr32kFYEmjTa6I3JaK3k/rL4l5afmXRqSqT5OmjE9
	 qFBwNId+UVVa4BkFMVYfxFcFN06QMruD1ZtQrJofc/b3yl/3nLAmekPM9cELda76wi
	 PNWEkJLfAS5IzyCtLmy7mFN02oaScCG6lwOw4HhB/nArCYwpN+N8ZyV74RBqI1rjGj
	 RmhEsMZRU45r5+EkF4WoA5swcjDEYMpZsbhLudMp1usB7dJ31HP/XFBKeekT0ZNKjj
	 Ct8I5G/vGq1KdaCwzpFU2BdE=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 31F6040E0194;
	Fri, 16 Jan 2026 12:22:52 +0000 (UTC)
Date: Fri, 16 Jan 2026 13:22:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	x86@kernel.org
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Message-ID: <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
References: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>

On Thu, Jan 01, 2026 at 10:05:12AM +0100, Paolo Bonzini wrote:
> Tested on a Sapphire Rapids machine, reviews and acks are welcome so
> that I can submit it to Linus via the KVM tree.

So I wanted to give this a thorough review after yesterday's discussion and
tried to apply the patch but it wouldn't apply. So I took a look at the code
it touches just to find out that the patch is already in Linus' tree!

Why?

Can you folks please explain to me how is this the process we've all agreed
upon?

Where does it say that people should sneak patches behind the maintainers'
backs without even getting an Ack from them?

By that logic, we can just as well sneak KVM patches behind your back and
you're supposed to be fine with it. Right?

Or should we try to adhere to the development rules we all have agreed upon
and work together in a fair and correct way?

I'd probably vote for latter, after we all sit down and agree upon something.

What I don't want is sneaking patches behind our backs and I'm sure you won't
like this either so let's please stop this.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

