Return-Path: <kvm+bounces-27558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC6998734F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 14:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88631B25309
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 12:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFB71741C0;
	Thu, 26 Sep 2024 12:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xypqOioA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tQ3HjyUZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xypqOioA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tQ3HjyUZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A4C78C90;
	Thu, 26 Sep 2024 12:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727352644; cv=none; b=aMNpGvmBjWwCW0XgX8vNvmZjK7m43M9tbDi/h1YZNQGlCo0iE5eeJmd/clFmHwGhgJzH5Eu36VlKNugvkV8dmC3Dcy0iLnSadMJ/QB0XcILm0AMrQAVSfq/lkeFeg4UmbE+LZ6SaY4Qq/WM8HjMpLSO7mK58+NUwb0SKDug6nkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727352644; c=relaxed/simple;
	bh=2JosmBuvO1uzpshMRCBoVMz1FQum5GKJW/gaxu6C7NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=be4kzvUfV84SDUcJ0rtcylyJuvym0XHDgvXZO5TgTwvrHG+vYd75w0ydZeUn5ltMVmJ9GGX6YVMv+BDWWZApLmhM628vIHlrjdCHqxuT9CC4xOAoXyOweO1OZMtYkuys1/cn80uSypwoxXIk7BD1PUnYvLgtrUxjVHR7OnZ+QEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xypqOioA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tQ3HjyUZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xypqOioA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tQ3HjyUZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from kitsune.suse.cz (unknown [10.100.12.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BB011F853;
	Thu, 26 Sep 2024 12:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727352634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mO+mBgqQ/T6X+tSWYJekgurpKW0Dnm8xbzizv8ba9T8=;
	b=xypqOioAmz3znrCC0ei4IJzk5VUn5OhOzGsdS/R0MwtXqBZMP3BsT1mp5mKXFJuGn0bh1e
	sAUrAoxgHeS4vLbI1w8Zf4a4rFzR2hl8NsTEWwF0sAqezLt+M4gLLOszNmvyaYJoe0hH3N
	FWE96gOnF0RdB7Xw6mlYwzLKl+4n96k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727352634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mO+mBgqQ/T6X+tSWYJekgurpKW0Dnm8xbzizv8ba9T8=;
	b=tQ3HjyUZ+i6qEqCkzhCWjFTO7FEy2dx6rGn5HaE37/gpFbhVNIlTNWsj3vTeBfPbZrWJr6
	ddCuNn3fdMiLEtBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727352634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mO+mBgqQ/T6X+tSWYJekgurpKW0Dnm8xbzizv8ba9T8=;
	b=xypqOioAmz3znrCC0ei4IJzk5VUn5OhOzGsdS/R0MwtXqBZMP3BsT1mp5mKXFJuGn0bh1e
	sAUrAoxgHeS4vLbI1w8Zf4a4rFzR2hl8NsTEWwF0sAqezLt+M4gLLOszNmvyaYJoe0hH3N
	FWE96gOnF0RdB7Xw6mlYwzLKl+4n96k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727352634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mO+mBgqQ/T6X+tSWYJekgurpKW0Dnm8xbzizv8ba9T8=;
	b=tQ3HjyUZ+i6qEqCkzhCWjFTO7FEy2dx6rGn5HaE37/gpFbhVNIlTNWsj3vTeBfPbZrWJr6
	ddCuNn3fdMiLEtBg==
Date: Thu, 26 Sep 2024 14:10:33 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	mikey@neuling.org, sbhat@linux.ibm.com, kvm@vger.kernel.org,
	amachhiw@linux.vnet.ibm.com, gautam@linux.ibm.com,
	npiggin@gmail.com, David.Laight@aculab.com, kvm-ppc@vger.kernel.org,
	sachinp@linux.ibm.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v5 00/11] KVM: PPC: Nested APIv2 guest support
Message-ID: <ZvVPOW-GmK3G7wnH@kitsune.suse.cz>
References: <20230914030600.16993-1-jniethe5@gmail.com>
 <ZvRIG1LHwqa5_kgP@kitsune.suse.cz>
 <874j636l9a.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874j636l9a.fsf@vajain21.in.ibm.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lists.ozlabs.org,neuling.org,linux.ibm.com,vger.kernel.org,linux.vnet.ibm.com,aculab.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Thu, Sep 26, 2024 at 10:53:45AM +0530, Vaibhav Jain wrote:
> Hi Michal,
> 
> Michal Suchánek <msuchanek@suse.de> writes:
> 
> <snip>
> 
> > Hello,
> >
> > are there any machines on which this is supposed to work?
> >
> > On a 9105-22A with ML1050_fw1050.20 (78) and
> 
> On 9105-22A you need atleast:
> Firmware level: FW1060.10

Indeed, upgrading to FW1060 makes the KVM functionality available.

Thanks

Michal

