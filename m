Return-Path: <kvm+bounces-19038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B87EF8FF517
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 21:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66F3C283FFA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 19:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9147A4D5AA;
	Thu,  6 Jun 2024 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eLZiKdiR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DQEBfdeZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eLZiKdiR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DQEBfdeZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474A438DE4
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700474; cv=none; b=iMIJLSq49M7VzcsQLhdAtM+XXvGNWgYLokSvo+GZdt5xEgb0pJyhMXS9EIXBhu/q3rXr80W6elV04d0pLNyDNaBrhLl4TpYYMbGcBVl9fp1h6OBIAD3FdMaxTe0crFZzT/v6X1FODicg5VBN9IhvETRC1uXcD8M4fjdFk8cb1xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700474; c=relaxed/simple;
	bh=pbsfsXOUkmnj76QZ6+wLsqnk9yp6NnwZLil9Nm8nfGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuKGw9PZKYS2muLL9pcPkDoRakPltDdw60baSOj3Lp94VuvcJlSAYO+2d9O6vI5Zdt1LG27cBr1UFxl6sYmGGoOwrNBCyUaYGojSnAsZsmFAsIk2WRaq81nIzjEtMuSg4QF4L3q4ol/HtDy1bz9fwDFozNtc1n/OzV6F7N1hoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eLZiKdiR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DQEBfdeZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eLZiKdiR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DQEBfdeZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 554A321B10;
	Thu,  6 Jun 2024 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MsK0mKtBZW6jGy4qwRj2IyncMFv46i1RORYNPpiNnU4=;
	b=eLZiKdiRj9rKQJmcvyljZu/h0MlOruP8Ln8NjK05sSvxkQC7ruW/LKTqsdTl9+/dUOiEht
	8bXrbv2jzokgji0BEgBJNwMZY0R8IGWbTuxwBBZtdTFRLbRLiMZaQ0bF/FKDJf2M+mz3Qv
	csCnOeLPQezB98zm1B2L0vkiq+8iLTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MsK0mKtBZW6jGy4qwRj2IyncMFv46i1RORYNPpiNnU4=;
	b=DQEBfdeZHfStHz8PN55AltnI3q+UeY+/4YSVJDGg40jHf225W7icqRxrCLHVy0fdVs3Qxp
	I27vhj0asAHcpTCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MsK0mKtBZW6jGy4qwRj2IyncMFv46i1RORYNPpiNnU4=;
	b=eLZiKdiRj9rKQJmcvyljZu/h0MlOruP8Ln8NjK05sSvxkQC7ruW/LKTqsdTl9+/dUOiEht
	8bXrbv2jzokgji0BEgBJNwMZY0R8IGWbTuxwBBZtdTFRLbRLiMZaQ0bF/FKDJf2M+mz3Qv
	csCnOeLPQezB98zm1B2L0vkiq+8iLTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MsK0mKtBZW6jGy4qwRj2IyncMFv46i1RORYNPpiNnU4=;
	b=DQEBfdeZHfStHz8PN55AltnI3q+UeY+/4YSVJDGg40jHf225W7icqRxrCLHVy0fdVs3Qxp
	I27vhj0asAHcpTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E8EB13A1E;
	Thu,  6 Jun 2024 19:01:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NfgbAncHYmZAMAAAD6G6ig
	(envelope-from <vkarasulli@suse.de>); Thu, 06 Jun 2024 19:01:11 +0000
Date: Thu, 6 Jun 2024 21:01:09 +0200
From: Vasant Karasulli <vkarasulli@suse.de>
To: Sean Christopherson <seanjc@google.com>
Cc: vsntk18@gmail.com, kvm@vger.kernel.org, pbonzini@redhat.com,
	jroedel@suse.de, papaluri@amd.com, andrew.jones@linux.dev,
	Varad Gautam <varad.gautam@suse.com>, Marc Orr <marcorr@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 10/11] x86: AMD SEV-ES: Handle IOIO #VC
Message-ID: <ZmIHdamcG6um0QhX@vasant-suse>
References: <20240419161623.45842-1-vsntk18@gmail.com>
 <20240419161623.45842-11-vsntk18@gmail.com>
 <ZmCNhDt0UaDpuqu-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCNhDt0UaDpuqu-@google.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,redhat.com,suse.de,amd.com,linux.dev,suse.com,google.com];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:url,suse.com:email,suse.de:email]

On Mi 05-06-24 09:08:36, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> > From: Vasant Karasulli <vkarasulli@suse.de>
> >
> > Using Linux's IOIO #VC processing logic.
> >
> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> > Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > ---
> >  lib/x86/amd_sev_vc.c | 169 +++++++++++++++++++++++++++++++++++++++++++
> >  lib/x86/processor.h  |   7 ++
> >  2 files changed, 176 insertions(+)
> >
> > diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> > index 6238f1ec..2a553db1 100644
> > --- a/lib/x86/amd_sev_vc.c
> > +++ b/lib/x86/amd_sev_vc.c
> > @@ -177,6 +177,172 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> >  	return ret;
> >  }
> >
> > +#define IOIO_TYPE_STR  BIT(2)
> > +#define IOIO_TYPE_IN   1
> > +#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
> > +#define IOIO_TYPE_OUT  0
> > +#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
> > +
> > +#define IOIO_REP       BIT(3)
> > +
> > +#define IOIO_ADDR_64   BIT(9)
> > +#define IOIO_ADDR_32   BIT(8)
> > +#define IOIO_ADDR_16   BIT(7)
> > +
> > +#define IOIO_DATA_32   BIT(6)
> > +#define IOIO_DATA_16   BIT(5)
> > +#define IOIO_DATA_8    BIT(4)
> > +
> > +#define IOIO_SEG_ES    (0 << 10)
> > +#define IOIO_SEG_DS    (3 << 10)
>
> I assume these are architectural?  I.e. belong in a common header?

Yes, I will move them to lib/x86/svm.h

Thanks,
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com


