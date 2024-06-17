Return-Path: <kvm+bounces-19790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED01690B4D5
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC7028325B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1849178CE7;
	Mon, 17 Jun 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cgO7Ec0c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d2KMdJCB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pF233v1e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1HIVKVPL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9486153593;
	Mon, 17 Jun 2024 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718637054; cv=none; b=e8lQ0G7mD/p5f794nbWbWPq1V4JYzQvxXUm7YZYZaGHuHsfLcDARXpVzyQUwY3otbJac5Q3fGs+3fMphka53JhZMyguavM21Klz4ju3IrFoUm9ZmkPXH3Aj2zGX9EXAQxlM2eJCo7grzb3THO3vPJKf6y3VQeVgjZmZBkaS/t+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718637054; c=relaxed/simple;
	bh=/1X7hIfTcTiRc+Fad6/3Qv6AEZTTH5fvcoPL6yNc8lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cloc1yxbQq0B9fBXx1BUItO3yuisagytYnsb7Pnvh7m8n3wtgMAJ6ZNKUsYkIm4fGbQzbFx1TYGq6DKyIDvQAZeM35efmIVQsda2uYYlaOt6kwso9fSXSCdHZq2/Xkg0IZ6FV7YzV7SXgkACBsrmCXlbsiiqbofipPV749JrcEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cgO7Ec0c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d2KMdJCB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pF233v1e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1HIVKVPL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E94D73836C;
	Mon, 17 Jun 2024 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718637051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JpCjailk6uzSHmhsPx9E6A+Robg4DOaNP8kYpasrOKc=;
	b=cgO7Ec0c/8vyt88tmxWawFJwL3HXdWVtygAkZIVAPTJQWmftWk1sjhK6borqKMhPa+QcOk
	rxq515tyJSaHLP/RFjBRZvxIQR2tThKorJUHJcKQJurlRpZVgYhpmmLal6zpuB3PVD+sYx
	3SF4JcQI3kBAql7lk4mLxUPlQUtsyP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718637051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JpCjailk6uzSHmhsPx9E6A+Robg4DOaNP8kYpasrOKc=;
	b=d2KMdJCBaWnFFedrUzNwUM4WeZ4gpuw40Dt/P+4AYcrqhMx4keN8/2xqBcoRnaIXGkgeDZ
	AogZ7q3LsrYp8KCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718637050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JpCjailk6uzSHmhsPx9E6A+Robg4DOaNP8kYpasrOKc=;
	b=pF233v1e162BLRBguSnBhti1yjCt1VJ2SVPyKRquFev8zbPvWOCxHCJ4fN4AdId7KTn/8o
	54l3Oft6gVkGQW4xjhWHQJoihEkGIjhQqoHRea7QZESGnelxJ9TBB/L+aMB/5ImeSB9on2
	1d2ctYoP/n7hzz/ObcH/86kY8VqZQJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718637050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JpCjailk6uzSHmhsPx9E6A+Robg4DOaNP8kYpasrOKc=;
	b=1HIVKVPLG/W+0AjeFWOE6nJ+MdMznkv0hiO81SV6BPDStOUNpQ/aVetNB7JTGGE7n3SuC8
	oHOrrsxvWhAssoAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A5EAA13AAA;
	Mon, 17 Jun 2024 15:10:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LdOJJ/pRcGaIZgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 17 Jun 2024 15:10:50 +0000
Message-ID: <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
Date: Mon, 17 Jun 2024 17:10:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Content-Language: en-US
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 linux-block@vger.kernel.org, kernel-janitors@vger.kernel.org,
 bridge@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
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
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com> <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <Zmrkkel0Fo4_g75a@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[zx2c4.com,kernel.org,gmail.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,inria.fr,vger.kernel.org,lists.linux.dev,efficios.com,lists.ozlabs.org,linux.ibm.com,csgroup.eu,gmail.com,lists.zx2c4.com,suse.de,netapp.com,oracle.com,talpey.com,netfilter.org];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLr583pch5u74edj9dsne3chzi)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 6/13/24 2:22 PM, Jason A. Donenfeld wrote:
> On Wed, Jun 12, 2024 at 08:38:02PM -0700, Paul E. McKenney wrote:
>> o	Make the current kmem_cache_destroy() asynchronously wait for
>> 	all memory to be returned, then complete the destruction.
>> 	(This gets rid of a valuable debugging technique because
>> 	in normal use, it is a bug to attempt to destroy a kmem_cache
>> 	that has objects still allocated.)

This seems like the best option to me. As Jason already said, the debugging
technique is not affected significantly, if the warning just occurs
asynchronously later. The module can be already unloaded at that point, as
the leak is never checked programatically anyway to control further
execution, it's just a splat in dmesg.

> Specifically what I mean is that we can still claim a memory leak has
> occurred if one batched kfree_rcu freeing grace period has elapsed since
> the last call to kmem_cache_destroy_rcu_wait/barrier() or
> kmem_cache_destroy_rcu(). In that case, you quit blocking, or you quit
> asynchronously waiting, and then you splat about a memleak like we have
> now.

Yes so we'd need the kmem_cache_free_barrier() for a slab kunit test (or the
pessimistic variant waiting for the 21 seconds), and a polling variant of
the same thing for the asynchronous destruction. Or we don't need a polling
variant if it's ok to invoke such a barrier in a schedule_work() workfn.

We should not need any new kmem_cache flag nor kmem_cache_destroy() flag to
burden the users of kfree_rcu() with. We have __kmem_cache_shutdown() that
will try to flush everything immediately and if it doesn't succeed, we can
assume kfree_rcu() might be in flight and try to wait for it asynchronously,
without any flags.

SLAB_TYPESAFE_BY_RCU is still handled specially because it has special
semantics as well.

As for users of call_rcu() with arbitrary callbacks that might be functions
from the module that is about to unload, these should not return from
kmem_cache_destroy() with objects in flight. But those should be using
rcu_barrier() before calling kmem_cache_destroy() already, and probably we
should not try to handle this automagically? Maybe one potential change with
the described approach is that today they would get the "cache not empty"
warning immediately. But that wouldn't stop the module unload so later the
callbacks would try to execute unmapped code anyway. With the new approach
the asynchronous handling might delay the "cache not empty" warnings (or
not, if kmem_cache_free_barrier() would finish before a rcu_barrier() would)
so the unmapped code execution would come first. I don't think that would be
a regression.


