Return-Path: <kvm+bounces-33439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 287059EB822
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73A3164897
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A193F86330;
	Tue, 10 Dec 2024 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jy+8s1oj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50F23ED73;
	Tue, 10 Dec 2024 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733851165; cv=none; b=IHrmSwcVDvRgJzjmGcC9tsGg5xc4tnKhSiHOyR4msCngdp6IxZjAML8TtbrkHmgHWW4zJxp3Obi4D1v7oH4jnEF5DQJk55ELe5Iu75XWl5++Pj9RfN7HVUyQ/mWN9ZSGKPJHujAqwo5OxAV8bCxnNJcUTgFpiBICuUxn1bJ67Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733851165; c=relaxed/simple;
	bh=9NLcram25uGG4pJA65qR5hY7bjLt/TKcvouELSThXm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFkhdha0NDT9CCFiUSGOL+LdLUZEusdr+Ml7+x1QSn4b5NWzff1GvnJcIopqYcmQuuiZHAWg9KoeuX+La4g0+xpix92tX08Me2fNygJQRgiLNVperpQivH1qyecUw54c5CwH3EXM4uDxY25XMt2FovTx4Npr4yxeRjmWXjwI0c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Jy+8s1oj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8FE5540E0289;
	Tue, 10 Dec 2024 17:19:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0jnBisfy_Cqk; Tue, 10 Dec 2024 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733851155; bh=rAzyiP+MOBHFa4O5i82TYJRQbhWHe5IRsXkt/3mioNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jy+8s1ojKVZ6mdeKYesGtlBK4UWWKzHNOMwIDDLu2NiUgCEEKWZsMUEMiR+Ay3Bwt
	 +jYD6gIob55rc/wc9tPjuNANpUQbnQvTGEMqbMMEvqWVaoaXyegdXk5BXREJM5ajy0
	 mt7JsUOlx0evNc0ze42by7r9fMkcW+b/iWDsIAbuEwy5sawA37/xzTBKiBYgam2PWh
	 KBRuzr54SYvJy+JbUHZB1O8hlHFAYOUwNw2QvmycugaQhrb55tH4UgzWCpnx3DGW9A
	 UKb6YOFh7Qh65y3JjEAPHj65H8+dMI+9sC9C2efbuhFs/8XSpy75w6Zy37LRNXVpaM
	 CEKjBhBWQPCyvCxvOWqdRuKIdsyfABPfobB2ZbMReSvoBa2AyyoRSIebYRmW0vI6nk
	 VLzyER8gq+cbfZ5wlkciHA+mI3KHyuGSVSc7jjcP3h5j351+hgfx8qkOl79RFj1RZG
	 OD2guCajHFRp7eEVq6JoKWRs/Xfx9kJJsZZ1E2roYvnPl5g5614+j9CcUEMFYekoTS
	 nmOkwMX8sQeH393a7dXsl8Eorzv0CDj/ahc37uoqpKdUH0McsigbXkaU1TGSZRbTrI
	 31+Fi9WruYIiikevYEwqYIhdjk/wQ5SQy2NxxzlRYZ9MqulbrfPAOqNcPEY22sfs8/
	 mra+RYSeIOrNjj1XmHKhQqVo=
Received: from zn.tnic (p200300EA971f930C329C23FfFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B405040E02B9;
	Tue, 10 Dec 2024 17:19:04 +0000 (UTC)
Date: Tue, 10 Dec 2024 18:18:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>

On Tue, Dec 10, 2024 at 10:43:05PM +0530, Nikunj A Dadhania wrote:
> This is incorrect, for a non-Secure TSC guest, a read of intercepted 
> MSR_AMD64_GUEST_TSC_FREQ will return value of rdtsc_ordered(). This is an invalid 
> MSR when SecureTSC is not enabled.

So how would you change this diff to fix this?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

