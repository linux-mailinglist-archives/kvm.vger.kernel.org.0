Return-Path: <kvm+bounces-19036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCAF08FF50A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 20:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 302401F2547E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD484F615;
	Thu,  6 Jun 2024 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BV0THPXH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qbxwVZTO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BV0THPXH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qbxwVZTO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326101BC3C
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700323; cv=none; b=qUdrpTgsBKjDNDM1WA6LIvjHmJ8Fby+JdLq4QElb/tgxl7IF5dzLK6WjzvVJJSHgmp0D2qDJ5vcqQIimwD6ICh84rNncTPl4w9olN1jnVxmIdOKP7LK8R13xs7ElN4qhSFRlamhCL4URzMnSyQgm82l65McqRmpefZez9ZkDzzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700323; c=relaxed/simple;
	bh=g1k3XGU/oCeOfzgTENFp36x9vDAO0qaNTWOIDVX+Ngg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsSws6u7INwZIR+SIXX4erq+MROLd8fRKtVoepxAHVc9pVgPgjWT9rt7mLAJFs9pWSJpb9/h1KpuTZ4WoLwHp2zSJvFCT2n1/Wp//nGzpAftgw2/Lmusd6sQZxNVQsl313wMf7HjLBrGhIHL0GXiWKeTKhyye0ib2gU0q0cRs80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BV0THPXH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qbxwVZTO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BV0THPXH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qbxwVZTO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63CF91FB4C;
	Thu,  6 Jun 2024 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QKUpdUa/x8KbM7AXBgzDdbig6o0x83idz2vE9UMZi9k=;
	b=BV0THPXH2Qa4r/kLrerolSAvm4B9UuhA1b+ukLGb3YQku9MXbuMPNyD8a8e35rsEktMOJm
	+a9evhfYPY8/R85M/Z4qZCxTW/o5Rb27hmGH19nZoYU5Ma5VZOSU1BljNlQqpA8LpptXmR
	dLV2kgS0V9qGIcC71z6HSusLwt50E3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QKUpdUa/x8KbM7AXBgzDdbig6o0x83idz2vE9UMZi9k=;
	b=qbxwVZTObLP02CrxbrS4GeOJvC1BV3RoCttOZA+pBZtg8G+sc4T9tNXBbrWhAZW100GrUr
	axUj+CBapa/xtbBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BV0THPXH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qbxwVZTO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QKUpdUa/x8KbM7AXBgzDdbig6o0x83idz2vE9UMZi9k=;
	b=BV0THPXH2Qa4r/kLrerolSAvm4B9UuhA1b+ukLGb3YQku9MXbuMPNyD8a8e35rsEktMOJm
	+a9evhfYPY8/R85M/Z4qZCxTW/o5Rb27hmGH19nZoYU5Ma5VZOSU1BljNlQqpA8LpptXmR
	dLV2kgS0V9qGIcC71z6HSusLwt50E3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QKUpdUa/x8KbM7AXBgzDdbig6o0x83idz2vE9UMZi9k=;
	b=qbxwVZTObLP02CrxbrS4GeOJvC1BV3RoCttOZA+pBZtg8G+sc4T9tNXBbrWhAZW100GrUr
	axUj+CBapa/xtbBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19EC713A1E;
	Thu,  6 Jun 2024 18:58:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EX2wBOAGYmZzLwAAD6G6ig
	(envelope-from <vkarasulli@suse.de>); Thu, 06 Jun 2024 18:58:40 +0000
Date: Thu, 6 Jun 2024 20:58:38 +0200
From: Vasant Karasulli <vkarasulli@suse.de>
To: Sean Christopherson <seanjc@google.com>
Cc: vsntk18@gmail.com, kvm@vger.kernel.org, pbonzini@redhat.com,
	jroedel@suse.de, papaluri@amd.com, andrew.jones@linux.dev,
	Varad Gautam <varad.gautam@suse.com>, Marc Orr <marcorr@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 07/11] lib/x86: Move xsave helpers to
 lib/
Message-ID: <ZmIG3sNYe0C1jsXx@vasant-suse>
References: <20240419161623.45842-1-vsntk18@gmail.com>
 <20240419161623.45842-8-vsntk18@gmail.com>
 <ZmCMdLNkhusHSS1Q@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCMdLNkhusHSS1Q@google.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-6.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,redhat.com,suse.de,amd.com,linux.dev,suse.com,google.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.com:url,suse.com:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 63CF91FB4C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -6.01

On Mi 05-06-24 09:04:04, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> > From: Vasant Karasulli <vkarasulli@suse.de>
> >
> > Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
> > Move the xsave read/write helpers used by xsave testcase to lib/x86
> > to share as common code.
>
> This doesn't make any sense, processor.h _is_ common code.  And using
> get_supported_xcr0(), which does CPUID, in a #VC handler is even more nonsensical.
> Indeed, it's still used only by test_xsave() at the end of this series.
>

The idea was to have xcr0 related declarations and definitions in the same place
which were distributed across files. Does that make sense to you?  If not
I will move back get_supported_xcr0() to where it was.

> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> > Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > ---
> >  lib/x86/processor.h | 10 ----------
> >  lib/x86/xsave.c     | 26 ++++++++++++++++++++++++++
> >  lib/x86/xsave.h     | 15 +++++++++++++++
> >  x86/Makefile.common |  1 +
> >  x86/xsave.c         | 17 +----------------
> >  5 files changed, 43 insertions(+), 26 deletions(-)
> >  create mode 100644 lib/x86/xsave.c
> >  create mode 100644 lib/x86/xsave.h

--
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com


