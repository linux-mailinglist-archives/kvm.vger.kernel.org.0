Return-Path: <kvm+bounces-57341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C43A5B539BB
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9C551CC3C72
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB47F35E4EE;
	Thu, 11 Sep 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D7Li4eg/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA65235E4D6;
	Thu, 11 Sep 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609730; cv=none; b=ZfN/SXpJ5tehCHhp2EoDQxjCD1gIiSH1iXiuTOp2i446rkl7nOA6zp/4GXU31FOP2BxiQg2bzjO9V/dedzxCTOGaa5EyLGRJxwSLK81g9GXpVC8KOYDrmV9R9x4wPEP1k3KKMli7R20Y5+GDIDCDtOt2f+RrJsTWuvv0bAcsvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609730; c=relaxed/simple;
	bh=4cJtU/t0FdZWw6KNuoCu6d8SJpl8M6ogjVQ+HQSCxs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/LDfSK/E2HrZzXdm5p7ktZo2msfsOD1b4+9GdRaREmdnoQxarHDGA2Klk0Cqult3D2hhatx1iHoPmKQZugGzNdUIK4WdWg5FwFN0OFlLeVqCX7RUGlLAf18bfpn/PoapsHbd8XCgSqgY9DuZqyOxEq8gYZrLrWL5dbnGwWOzk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D7Li4eg/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EC6BD40E0140;
	Thu, 11 Sep 2025 16:55:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GbyUNlOUsH3D; Thu, 11 Sep 2025 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757609721; bh=Stz8ndbzOk/9lU3pydnqDDO5LXGN0x06KMzK037HgYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7Li4eg/w8pnztqcM7ecRESztUR9tum0X9oJHu4Z/XN2jMVK9EfdPBUyX6wQAGqo3
	 h++oKCCutBYR1CrsdatsNeyyhv+0Ksizc676Z82wRojyzdFP4E0G9dcU8+2QK7usCi
	 uZkbiqpyR+HWPQSeLgZPNpRIlKQ0CacKeoHDoUFLMFf+TYPjCWB/Pi/3eGMOGa83CA
	 +4tmWZnUwSLVr+RocnncpF/huY4zxZNOxX8Z0H1FCuurslt1a663c9hDyIfUX/mHRk
	 zjFyVotOlW9s/CIEOGm50fx2kWM0I2rFdJN0NGQZ3fRSQQnSIhDXpQv7hZIzOT/YZF
	 D0UeOK4Jpz8iWEGj27wrUDECSPDoDLGtbN3DXpS6afcBwatk5m4A2xcTWkiJU+o9Fv
	 t5hh/QBQCVcfFW6lq/fYlncq0QEDosZ80eKBw8bHect2KjZenwvQ/zkKtgjBexOnsW
	 2Tl+moHboBA+phbXKvIadnCQnO/0n7rs71D7IrmaHHZsN5VC4/5yVBdca+lgfysxlm
	 R9CZXHs6C7OFsWTVaoaUFBETLqsU+u4fB0G38IuNeyNwgreoUiuilAHb0rE6GzTwTj
	 OtmcD7GObLXc61+ukIxfrmPOtfdlEEiTYrxEAmSPSf0LCFAFdK+arkEdkV2QCrr4S6
	 YhTnE/xQ1EjaP4m1TSHySTE4=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id DCB2540E0174;
	Thu, 11 Sep 2025 16:54:38 +0000 (UTC)
Date: Thu, 11 Sep 2025 18:54:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to
 enable assignments on mkdir
Message-ID: <20250911165433.GBaML-yTUZHkywuJIe@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
 <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
 <0bacc30d-0e0d-45da-ab13-dca971f27e2c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0bacc30d-0e0d-45da-ab13-dca971f27e2c@intel.com>

On Thu, Sep 11, 2025 at 09:24:01AM -0700, Reinette Chatre wrote:
> About repeating things: As I see it the annoying repeating results from desire to
> follow the "context-problem-solution" changelog script while also ensuring each
> patch stands on its own. With these new features many patches share the same context
> and then copy&paste results. I see how this can be annoying when going through
> the series and I can also see how this is a lazy approach since the context is
> not tailored to each patch. Will work on this.

Thanks. And I know it makes sense to repeat things to introduce the context
but let's try to keep that at minimum and only when absolutely necessary.

> About too much text that explains the obvious: I hear you and will add these criteria
> to how changelogs are measured. I do find the criteria a bit subjective though and expect
> that I will not get this right immediately and appreciate and welcome your feedback until
> I do.

Yeah, that's fine, don't worry. But it is actually very simple: if it is
visible from the diff itself, then there's no need to state it again in text.
That would be waste of text.

Lemme paste my old git archeology example here in the hope it makes things
more clear. :-)

Do not talk about *what* the patch is doing in the commit message - that
should be obvious from the diff itself. Rather, concentrate on the *why*
it needs to be done.

Imagine one fine day you're doing git archeology, you find the place in
the code about which you want to find out why it was changed the way it 
is now.

You do git annotate <filename> ... find the line, see the commit id and
you do:

git show <commit id>

You read the commit message and there's just gibberish and nothing's
explaining *why* that change was done. And you start scratching your head,
trying to figure out why. Because the damn commit message is not worth the
electrons used to display it with.

This happens to us maintainers at least once a week.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

