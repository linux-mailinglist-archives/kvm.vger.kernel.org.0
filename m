Return-Path: <kvm+bounces-19037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A4C8FF513
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 21:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A90D41C25FD8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 19:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9574461FF9;
	Thu,  6 Jun 2024 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e2Ak2JaL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Lk/llbFJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e2Ak2JaL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Lk/llbFJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362F251012
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700393; cv=none; b=NzieJVRX5p0nSZ2uY4qNixG45Vk1FKZiV1OaX1FcwQGSckmeDfwV9TtMcJRLaYbrCZbmr1fvnfAYaTPUow6q7/jqxPundE7CitHNamGCoX8YRlCkylUdBDjXhAzgX+OCOLuX2N/aGnEzolsQm3QpJ9s6PvB38LN0Kjs483BKV+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700393; c=relaxed/simple;
	bh=D0KAHd3XDfDIHmsxP41U0ue6x8OY2DHt8LxLqtFndIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQ8wGAL67I7fTPmjabryOB6pM3HccPCxK9C7NoPWBWp7oe3M/qF7WRqXCP1gN3+UMhtRLl8uGaYf5Oc05ucpmrrJ3UrzY6nYydzYixNMFXdY0lFXRduILCDaZkGmCW77p2z9/ex3z1P+D4J7oEK4C9rXosE43cKKa0wtvQYLf8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e2Ak2JaL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Lk/llbFJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e2Ak2JaL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Lk/llbFJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53C231FB4C;
	Thu,  6 Jun 2024 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkNJaoaogTYp1XNtgDbWsOhyo1BCYnEbAZMJ4ebk2pY=;
	b=e2Ak2JaLChlgnMIqueynhw4iu1COEMBXuwme89q1kSUq2zs80JK2JjUsGw8KOaWYF1XBlg
	7FMaPiPAHtG5bKw5kVFXenP0S1JYn4q3xVOWnZzfu3a7vgOYoSAuNNgM20cCM78EiptSpK
	zn968DoHkNSPj8sT71ewVFmesC3esBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkNJaoaogTYp1XNtgDbWsOhyo1BCYnEbAZMJ4ebk2pY=;
	b=Lk/llbFJmk7eiG0NRCM2S9epYHXWSaheE29snNSV3YKn43b6IO27n4ZKJH0Cz2mSwGAvuw
	dQhGTTIpmVeMA+CQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkNJaoaogTYp1XNtgDbWsOhyo1BCYnEbAZMJ4ebk2pY=;
	b=e2Ak2JaLChlgnMIqueynhw4iu1COEMBXuwme89q1kSUq2zs80JK2JjUsGw8KOaWYF1XBlg
	7FMaPiPAHtG5bKw5kVFXenP0S1JYn4q3xVOWnZzfu3a7vgOYoSAuNNgM20cCM78EiptSpK
	zn968DoHkNSPj8sT71ewVFmesC3esBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkNJaoaogTYp1XNtgDbWsOhyo1BCYnEbAZMJ4ebk2pY=;
	b=Lk/llbFJmk7eiG0NRCM2S9epYHXWSaheE29snNSV3YKn43b6IO27n4ZKJH0Cz2mSwGAvuw
	dQhGTTIpmVeMA+CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1070113A1E;
	Thu,  6 Jun 2024 18:59:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VyGSAiYHYma+LwAAD6G6ig
	(envelope-from <vkarasulli@suse.de>); Thu, 06 Jun 2024 18:59:50 +0000
Date: Thu, 6 Jun 2024 20:59:48 +0200
From: Vasant Karasulli <vkarasulli@suse.de>
To: Sean Christopherson <seanjc@google.com>
Cc: vsntk18@gmail.com, kvm@vger.kernel.org, pbonzini@redhat.com,
	jroedel@suse.de, papaluri@amd.com, andrew.jones@linux.dev,
	Varad Gautam <varad.gautam@suse.com>
Subject: Re: [kvm-unit-tests PATCH v7 08/11] x86: AMD SEV-ES: Handle CPUID #VC
Message-ID: <ZmIHJHHeN5CCIizZ@vasant-suse>
References: <20240419161623.45842-1-vsntk18@gmail.com>
 <20240419161623.45842-9-vsntk18@gmail.com>
 <ZmCNT4vkG9_SGY0S@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCNT4vkG9_SGY0S@google.com>
X-Spam-Flag: NO
X-Spam-Score: -3.59
X-Spam-Level: 
X-Spamd-Result: default: False [-3.59 / 50.00];
	BAYES_HAM(-2.79)[99.11%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,redhat.com,suse.de,amd.com,linux.dev,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,imap1.dmz-prg2.suse.org:helo]

On Mi 05-06-24 09:07:43, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> > +static inline void sev_es_wr_ghcb_msr(u64 val)
> > +{
> > +	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
> > +}
> > +
> > +static inline u64 sev_es_rd_ghcb_msr(void)
> > +{
> > +	return rdmsr(MSR_AMD64_SEV_ES_GHCB);
> > +}
>
> These are silly, they just add a layer of obfuscation.  It's just as easy to do:
>
> 	wrmsr(MSR_AMD64_SEV_ES_GHCB, __pa(ghcb));
>
> > +
> > +
>
> Extra newline.
>

Ok, I will address these two things in the next version.

> > +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> > +					  struct es_em_ctxt *ctxt,
> > +					  u64 exit_code, u64 exit_info_1,
> > +					  u64 exit_info_2)
> > +{
> > +	enum es_result ret;
> > +
> > +	/* Fill in protocol and format specifiers */
> > +	ghcb->version = GHCB_VERSION;
> > +	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
> > +
> > +	ghcb_set_sw_exit_code(ghcb, exit_code);
> > +	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> > +	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> > +
> > +	sev_es_wr_ghcb_msr(__pa(ghcb));

--
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com


