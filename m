Return-Path: <kvm+bounces-20358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBFF914283
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5E4A1C2170A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB5322064;
	Mon, 24 Jun 2024 06:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="boFIqJbh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E51B13FEE;
	Mon, 24 Jun 2024 06:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719209504; cv=none; b=Vjnj9WJqDZ/o5TsSMc3RUuH4xCUKulSFVdajAGMq8/DBoU0AFCiqHhHkCUSQ/KDuRzln7qWC9Il9CqyHtpGqGzvcv2XbDHG9KSw+9qJ6RW4H0mu8+H7VrL9ucgLsJuaBpZW9e2SPf+2CB2D4oCC2gKfD27Nlwh2WUOajSzctngM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719209504; c=relaxed/simple;
	bh=mVw797ePtiJlcJxO4pVYaME7gD8Pb3g08k207vxRzk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6TsFimixq1W8+7ySgoIGEkwPGdTaFxVZtIC4c/GCu2V/Ct19lb2uUgrHOJEixXUuoqmImFmMYumeaEl7I08+JzfbB0KKFJaGCwzmp6u+yBPvgX4lnB8LXPY0dWIX3FBCQwK57OvEPRQCzdZwbdzU37ew4k3GTBPSlt8/AlWANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=boFIqJbh; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CD14F40E021A;
	Mon, 24 Jun 2024 06:11:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3ln4YmfA0pXi; Mon, 24 Jun 2024 06:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719209493; bh=derf1yQyPee7uC0D89wlVkU8QlOSvLoHkdJzB6kIk1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boFIqJbhjnIKNfIG2j8PnNGMrOTYCuvmVbatBUdCtAfydp7zHBu5xIj1+hht3yGUS
	 6S8HMFv9FnZZhafGa3uYVArlVl/a3U+33MTZorcjhHsgg/ZJWbrFjY35Y4i1hZyEXx
	 9GVgjTqCd9kF4mfIyYIfrfZRTRsWADgvJrVnZORPzCdbS/TOlaKUpyZIWHmJK7/0VH
	 QIDz3opkG4gZibgu0m0EfCmLKJlBX4aDlD7/jxmVsg6dDwwTSDhNnR+ui+yKr0zQRu
	 J/WToQXmu6GGX68EfijOfZDQnMsly4sIXE0IfExrtF2uUBvnTzdRve+VJyZ1SBv/Bc
	 fEtdy0V3ntS287sZE+TXSeeuWvoBFv1/ogj34F/vNRTGhJthJLqBjIBoa7d7332KI5
	 A6peehiiJaFXfSZk+Gy0l6uTnTF8NZ6t9+14/nRyPUqroAq4fZ9C3CuaOiyFSlLtzU
	 dit+KhQBLz1JH5/rbnMiQ4DaX4hCoBhpWRt6r1oe3TDjpkqr2eZ1DUNr/Rz7HlPQ0g
	 e0RCpk7hBWY7NoT8DTy1FiV0H2cAFFNht6MHXFYs5lwzPW9UHUrYurBks2tYPZIwzf
	 fO7QAqdNMRlwQNPFmcIkVI0ElBOryBf9ErFqraJqv9JTokl+A/ErS4CNUBVI4HN1Ty
	 Nwf+oMmWmzV9UQ5PP92Qo3u0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A806340E0177;
	Mon, 24 Jun 2024 06:11:22 +0000 (UTC)
Date: Mon, 24 Jun 2024 08:11:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Message-ID: <20240624061117.GBZnkOBR5FVW8i6qsG@fat_crate.local>
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>

On Sun, Jun 23, 2024 at 09:46:09PM +0530, Nikunj A. Dadhania wrote:
> Yes, payload was earlier fixed at 4000 bytes, without considering the size
> of snp_guest_msg.

Sorry, you'd need to try explaining this again. Who wasn't considering the
size of snp_guest_msg?

AFAICT, the code currently does sizeof(struct snp_guest_msg) which contains
both the header *and* the payload.

What could help is if you structure your commit message this way:

1. Prepare the context for the explanation briefly.

2. Explain the problem at hand.

3. "It happens because of <...>"

4. "Fix it by doing X"

5. "(Potentially do Y)."

And some of those above are optional depending on the issue being
explained.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

