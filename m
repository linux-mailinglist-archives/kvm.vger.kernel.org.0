Return-Path: <kvm+bounces-19035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCFC8FF507
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 20:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF729286000
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08BF64F1F2;
	Thu,  6 Jun 2024 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IgFTVnsJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RCZSUEX7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IgFTVnsJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RCZSUEX7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1041BC3C
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700236; cv=none; b=eolIB4i5S31aoO9fByLtqRPCIsESsICVCqusyylZcHZ3d9bGPGEoJnFF9xIXR49DRJ9YSbIJIG4x43MVA/WJmefhyMQT7pLMesg/Oi9rm3ZlOhlkcm4BHta4Fk62xC4YFJhrX1SjG+0IeeAQmgwRynvp3Anr43fAvJVM5G58WKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700236; c=relaxed/simple;
	bh=ZdFK5GoCTUsPbCl1teVVP7rHxjW4VHt136nW+kr5I8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obwk/oegKm/SNv0+keaPjDFiGzvl3B5QpTPVnLuxwc37V5bT9zlusqGY/ElJo+vieeOMCGG5uWu7sXGwRl9mihgc1gHeRfR8jzSuimZz8PKXH8QaYkfdN466qS6EjMQp8thj0xPLenHeRqehY2vmrn6EjTIBalofRJ+W51kOGRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IgFTVnsJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RCZSUEX7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IgFTVnsJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RCZSUEX7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70DAA21B05;
	Thu,  6 Jun 2024 18:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mya5zuLyCt5R7JqAiRUqyNe8zuVIeCvtuIFQTUVjrPQ=;
	b=IgFTVnsJ0lIXp55I2D15FaCNoYCkhsmEQNMgxthg3ZGFGdXYUvYpqiWEmma67sxZKMPxyA
	vcydAwXg2TEzTjJwDxuM3y+YQu5atDrdfP+GSr3tOG/pLfDhRArdViNIhZHlMK/ImPd6WI
	T1XAP6z3SmY6A6R6+3xm1nsRDMTUiiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mya5zuLyCt5R7JqAiRUqyNe8zuVIeCvtuIFQTUVjrPQ=;
	b=RCZSUEX7q5kCEdOIEht2dzyCjwB0lcrXKE8yFTa6qQnMFlt50EwgA9ZXyxs05Fh6hxGHI8
	Z6vemEbJhbJSPfAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IgFTVnsJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RCZSUEX7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717700232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mya5zuLyCt5R7JqAiRUqyNe8zuVIeCvtuIFQTUVjrPQ=;
	b=IgFTVnsJ0lIXp55I2D15FaCNoYCkhsmEQNMgxthg3ZGFGdXYUvYpqiWEmma67sxZKMPxyA
	vcydAwXg2TEzTjJwDxuM3y+YQu5atDrdfP+GSr3tOG/pLfDhRArdViNIhZHlMK/ImPd6WI
	T1XAP6z3SmY6A6R6+3xm1nsRDMTUiiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717700232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mya5zuLyCt5R7JqAiRUqyNe8zuVIeCvtuIFQTUVjrPQ=;
	b=RCZSUEX7q5kCEdOIEht2dzyCjwB0lcrXKE8yFTa6qQnMFlt50EwgA9ZXyxs05Fh6hxGHI8
	Z6vemEbJhbJSPfAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2511213A1E;
	Thu,  6 Jun 2024 18:57:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JyyTB4gGYmb6LgAAD6G6ig
	(envelope-from <vkarasulli@suse.de>); Thu, 06 Jun 2024 18:57:12 +0000
Date: Thu, 6 Jun 2024 20:57:10 +0200
From: Vasant Karasulli <vkarasulli@suse.de>
To: Sean Christopherson <seanjc@google.com>
Cc: vsntk18@gmail.com, kvm@vger.kernel.org, pbonzini@redhat.com,
	jroedel@suse.de, papaluri@amd.com, andrew.jones@linux.dev,
	Varad Gautam <varad.gautam@suse.com>, Marc Orr <marcorr@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 02/11] x86: Move svm.h to lib/x86/
Message-ID: <ZmIGhvRMCaBWz3l6@vasant-suse>
References: <20240419161623.45842-1-vsntk18@gmail.com>
 <20240419161623.45842-3-vsntk18@gmail.com>
 <ZmCMyL3zzg9CtFHU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCMyL3zzg9CtFHU@google.com>
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
X-Rspamd-Queue-Id: 70DAA21B05
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -6.01

On Mi 05-06-24 09:05:28, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> > From: Vasant Karasulli <vkarasulli@suse.de>
> >
> > This enables sharing common definitions across testcases and lib/.
> >
> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> > Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > ---
> >  {x86 => lib/x86}/svm.h | 0
>
> No, there is far, far more crud in svm.h than belongs in lib/.  The architectural
> definitions and whatnot belong in lib/, but all of the nSVM support code does not.

Ok, I will leave architectural definitions in lib/x86/svm.h, and move
the SVM related definitions to x86/svm.h.

>
> >  x86/svm.c              | 2 +-
> >  x86/svm_tests.c        | 2 +-
> >  3 files changed, 2 insertions(+), 2 deletions(-)
> >  rename {x86 => lib/x86}/svm.h (100%)
> >
> > diff --git a/x86/svm.h b/lib/x86/svm.h
> > similarity index 100%
> > rename from x86/svm.h
> > rename to lib/x86/svm.h
> > diff --git a/x86/svm.c b/x86/svm.c
> > index e715e270..252d5301 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -2,7 +2,7 @@
> >   * Framework for testing nested virtualization
> >   */
> >
> > -#include "svm.h"
> > +#include "x86/svm.h"
> >  #include "libcflat.h"
> >  #include "processor.h"
> >  #include "desc.h"
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index c81b7465..a180939f 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -1,4 +1,4 @@
> > -#include "svm.h"
> > +#include "x86/svm.h"
> >  #include "libcflat.h"
> >  #include "processor.h"
> >  #include "desc.h"
> > --
> > 2.34.1
> >

--
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com


