Return-Path: <kvm+bounces-19825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799F990BCC9
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE218B24449
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E50D1990AA;
	Mon, 17 Jun 2024 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pa0lswvz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uDHwF1Or";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FF0jdC88";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TuCB6fhw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8431991DD;
	Mon, 17 Jun 2024 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718659081; cv=none; b=B94QUgZNn185sqfpDSmqz1kUhvocr6u7hNg4C8Z1kdh9p7m5pr+ffgI4jdcXQClQc8wvFWADpx3/T+349tJcNVU/lN3oZ/A+zgM5KZxq7oHYZeuVdqOQdWlHJInvUbeRHBbshlaXjVwBRynFGTKEgNYrh/SrZZ4kERn12ePy87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718659081; c=relaxed/simple;
	bh=CycXSzWtI++XwaIZ8T4bfyISqqnnJafiRd07i759+wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqYLcBvdxj+NfRaVusIg0avOVeksAJeNonPRJGyqVVKvyLMeILaRB1vfNob96KCQm4KZt50piv1gWs8Bjomt4s2l+Qyt5qrtC/oSPBZ/UAVXCeRQYX/3y7St/IuvC2+/EmejrI/L4u4cM000KJCSUlGjkr+22Zw/Y55DfdlE8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pa0lswvz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uDHwF1Or; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FF0jdC88; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TuCB6fhw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ABA921F395;
	Mon, 17 Jun 2024 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718659077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUds48oScu4/C+pkGPV1ry62ZJoePkIvLYk2jW3f754=;
	b=pa0lswvzDFMjD8H7K4gdtAUq5symiJaQRcEJTjFu4e/Aw/UniD4OjZndbSp/Uu7qVqV4Jw
	Bld+pO5JBLkMwO+x3Fnd3CwF1tfQHPHFMzn7r1uQKnyFMhAHHepmbXEps5ckzykTKieaoV
	xFhUH1/ZZfxtme24TLVbED3e7a+sZho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718659077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUds48oScu4/C+pkGPV1ry62ZJoePkIvLYk2jW3f754=;
	b=uDHwF1Oro49W1/+Lg8Aumr/UbHq+X8871hqwesFOgR4apjhiRGrItN7gCEjvBAs6D+uTQz
	j8aLNJ49YSO7p9BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718659076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUds48oScu4/C+pkGPV1ry62ZJoePkIvLYk2jW3f754=;
	b=FF0jdC88vsv3Mazo5aoTk/icaEwSKhBU9g/15c7soDFDi/7D3b7GT4wE3fOvSSfJt3Uzn/
	maZOpELYGdji/vMja5AQs5K8FcMvbesycLyixY4dCanyjRNBR1LO+QH8plF1WWPo2+BK87
	XYTYr6ulYEryja/CJGfoAl+B5INpgbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718659076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUds48oScu4/C+pkGPV1ry62ZJoePkIvLYk2jW3f754=;
	b=TuCB6fhwOvdyoJ1YLynNsz7cy1vl4m/OgMpfHRHpVjrdJr4EDStSvK76MnPDBmm3uL3boo
	KLBlQyL45iZAzlAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A0BD13AAA;
	Mon, 17 Jun 2024 21:17:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SlZzFQSocGYMTgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 17 Jun 2024 21:17:56 +0000
Message-ID: <bbc96338-825d-434e-80e8-6407c947780b@suse.cz>
Date: Mon, 17 Jun 2024 23:19:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
 kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Nicholas Piggin <npiggin@gmail.com>, netdev@vger.kernel.org,
 wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
 ecryptfs@vger.kernel.org, Neil Brown <neilb@suse.de>,
 Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org,
 linux-can@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan> <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636> <ZnBOkZClsvAUa_5X@zx2c4.com>
 <ZnBkvYdbAWILs7qx@pc636>
 <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>
 <b415b8e3-24cc-4747-a30d-706e1dcfdff7@suse.cz> <ZnBsomxy_cCnnIBy@zx2c4.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <ZnBsomxy_cCnnIBy@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -8.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-8.29 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,inria.fr,vger.kernel.org,lists.linux.dev,efficios.com,lists.ozlabs.org,linux.ibm.com,csgroup.eu,lists.zx2c4.com,suse.de,netapp.com,oracle.com,talpey.com,netfilter.org];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 6/17/24 7:04 PM, Jason A. Donenfeld wrote:
>>> Vlastimil, this is just checking a boolean (which could be
>>> unlikely()'d), which should have pretty minimal overhead. Is that
>>> alright with you?
>>
>> Well I doubt we can just set and check it without any barriers? The
>> completion of the last pending kfree_rcu() might race with
>> kmem_cache_destroy() in a way that will leave the cache there forever, no?
>> And once we add barriers it becomes a perf issue?
> 
> Hm, yea you might be right about barriers being required. But actually,
> might this point toward a larger problem with no matter what approach,
> polling or event, is chosen? If the current rule is that
> kmem_cache_free() must never race with kmem_cache_destroy(), because

Yes calling alloc/free operations that race with destroy is a bug and we
can't prevent that.

> users have always made diligent use of call_rcu()/rcu_barrier() and

But the issue we are solving here is a bit different - the users are not
buggy, they do kfree_rcu() and then kmem_cache_destroy() and no more
operations on the cache afterwards. We need to ensure that the handling
of kfree_rcu() (which ultimately is basically kmem_cache_free() but
internally to rcu/slub) doesn't race with kmem_cache_destroy().

> such, but now we're going to let those race with each other - either by
> my thing above or by polling - so we're potentially going to get in trouble
> and need some barriers anyway. 

The barrier in the async part of kmem_cache_destroy() should be enough
to make sure all kfree_rcu() have finished before we proceed with the
potentially racy parts of destroying, and we should be able to avoid
changes in kmem_cache_free().

> I think?
> 
> Jason

