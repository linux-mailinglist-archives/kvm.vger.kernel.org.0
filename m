Return-Path: <kvm+bounces-19950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090CB90E706
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 868BE284F20
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656AD811E7;
	Wed, 19 Jun 2024 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KlCQojr/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k0SWOEYe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KlCQojr/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k0SWOEYe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D117EEFD;
	Wed, 19 Jun 2024 09:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718789297; cv=none; b=tKHHAedu7HMldOaYY7FQlBNWuxpDadQQVSM6dF0OpbHMRtJUJpl3PZ2jEMAn+DlDj0vgeFoqY9l35UwjCyj7Lgx35eKHXO1vKbkv4J4j9s0oBpOt5bqtzpXQgLqz6IDeYZOjtBBA4OFnBmOiP1QvK7u/qvn+Yf8YLM+5f5jQN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718789297; c=relaxed/simple;
	bh=gaK5IzdiycFuU8UuMzKoRl4O9os/6zbBkW/wAwELuGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V4kNnJ6onCezfQNGkKgFvWezTwRopCMZjqU0NQX9j/xaFZy0ZIu8tyXZGMoKqMsWoSnyQ/edrZLW+GqcTvpTDaWXNFttW8GjzKDlmKIt1l1m8AS3Z6TTEBD+Ukuso4YtHk9s9ENg2W3gsXf/J/ND78ba0zX1C3VEOmhEL4G2Xd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KlCQojr/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k0SWOEYe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KlCQojr/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k0SWOEYe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8D7D1F787;
	Wed, 19 Jun 2024 09:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718789293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SLViRhlaF4oe5G++zEWyGT7PD7g10KVXrdRFRTAE8RU=;
	b=KlCQojr/zwQiyDOJe6NOsYj5lbpVJX4KqhQD20Qz1anI7ptWvCf0KRfDEwO9UiURWP3jyJ
	OkmadQURgwagDMlydEvdFIRzbtKXK3V5hw+HCeGQraxUfcaI33ZXAXmO6HmA0k0Sdsp7eu
	UFLFcfy7H6n68k7XD05zPqprPh2tWCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718789293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SLViRhlaF4oe5G++zEWyGT7PD7g10KVXrdRFRTAE8RU=;
	b=k0SWOEYesvDap3sL1WWXT35zGXQo5UZqmYjmCeof/e0+sRKVageZ2t6WcAiZ8esmD4ftgY
	tzgfv880TT5w80Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718789293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SLViRhlaF4oe5G++zEWyGT7PD7g10KVXrdRFRTAE8RU=;
	b=KlCQojr/zwQiyDOJe6NOsYj5lbpVJX4KqhQD20Qz1anI7ptWvCf0KRfDEwO9UiURWP3jyJ
	OkmadQURgwagDMlydEvdFIRzbtKXK3V5hw+HCeGQraxUfcaI33ZXAXmO6HmA0k0Sdsp7eu
	UFLFcfy7H6n68k7XD05zPqprPh2tWCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718789293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SLViRhlaF4oe5G++zEWyGT7PD7g10KVXrdRFRTAE8RU=;
	b=k0SWOEYesvDap3sL1WWXT35zGXQo5UZqmYjmCeof/e0+sRKVageZ2t6WcAiZ8esmD4ftgY
	tzgfv880TT5w80Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81A4713ABD;
	Wed, 19 Jun 2024 09:28:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zJ9OH62kcmagLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 19 Jun 2024 09:28:13 +0000
Message-ID: <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>
Date: Wed, 19 Jun 2024 11:28:13 +0200
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
To: paulmck@kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Jakub Kicinski <kuba@kernel.org>,
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
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 kasan-dev <kasan-dev@googlegroups.com>
References: <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com> <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz> <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz> <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
 <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,zx2c4.com,kernel.org,inria.fr,vger.kernel.org,lists.linux.dev,efficios.com,lists.ozlabs.org,linux.ibm.com,csgroup.eu,lists.zx2c4.com,suse.de,netapp.com,oracle.com,talpey.com,netfilter.org,googlegroups.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 6/18/24 7:53 PM, Paul E. McKenney wrote:
> On Tue, Jun 18, 2024 at 07:21:42PM +0200, Vlastimil Babka wrote:
>> On 6/18/24 6:48 PM, Paul E. McKenney wrote:
>> > On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
>> >> > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
>> >> > >> +
>> >> > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
>> >> > >> +
>> >> > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
>> >> > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
>> >> > > wanted to avoid initially.
>> >> > 
>> >> > I wanted to avoid new API or flags for kfree_rcu() users and this would
>> >> > be achieved. The barrier is used internally so I don't consider that an
>> >> > API to avoid. How difficult is the implementation is another question,
>> >> > depending on how the current batching works. Once (if) we have sheaves
>> >> > proven to work and move kfree_rcu() fully into SLUB, the barrier might
>> >> > also look different and hopefully easier. So maybe it's not worth to
>> >> > invest too much into that barrier and just go for the potentially
>> >> > longer, but easier to implement?
>> >> > 
>> >> Right. I agree here. If the cache is not empty, OK, we just defer the
>> >> work, even we can use a big 21 seconds delay, after that we just "warn"
>> >> if it is still not empty and leave it as it is, i.e. emit a warning and
>> >> we are done.
>> >> 
>> >> Destroying the cache is not something that must happen right away. 
>> > 
>> > OK, I have to ask...
>> > 
>> > Suppose that the cache is created and destroyed by a module and
>> > init/cleanup time, respectively.  Suppose that this module is rmmod'ed
>> > then very quickly insmod'ed.
>> > 
>> > Do we need to fail the insmod if the kmem_cache has not yet been fully
>> > cleaned up?
>> 
>> We don't have any such link between kmem_cache and module to detect that, so
>> we would have to start tracking that. Probably not worth the trouble.
> 
> Fair enough!
> 
>> >  If not, do we have two versions of the same kmem_cache in
>> > /proc during the overlap time?
>> 
>> Hm could happen in /proc/slabinfo but without being harmful other than
>> perhaps confusing someone. We could filter out the caches being destroyed
>> trivially.
> 
> Or mark them in /proc/slabinfo?  Yet another column, yay!!!  Or script
> breakage from flagging the name somehow, for example, trailing "/"
> character.

Yeah I've been resisting such changes to the layout and this wouldn't be
worth it, apart from changing the name itself but not in a dangerous way
like with "/" :)

>> Sysfs and debugfs might be more problematic as I suppose directory names
>> would clash. I'll have to check... might be even happening now when we do
>> detect leaked objects and just leave the cache around... thanks for the
>> question.
> 
> "It is a service that I provide."  ;-)
> 
> But yes, we might be living with it already and there might already
> be ways people deal with it.

So it seems if the sysfs/debugfs directories already exist, they will
silently not be created. Wonder if we have such cases today already because
caches with same name exist. I think we do with the zsmalloc using 32 caches
with same name that we discussed elsewhere just recently.

Also indeed if the cache has leaked objects and won't be thus destroyed,
these directories indeed stay around, as well as the slabinfo entry, and can
prevent new ones from being created (slabinfo lines with same name are not
prevented).

But it wouldn't be great to introduce this possibility to happen for the
temporarily delayed removal due to kfree_rcu() and a module re-insert, since
that's a legitimate case and not buggy state due to leaks.

The debugfs directory we could remove immediately before handing over to the
scheduled workfn, but if it turns out there was a leak and the workfn leaves
the cache around, debugfs dir will be gone and we can't check the
alloc_traces/free_traces files there (but we have the per-object info
including the traces in the dmesg splat).

The sysfs directory is currently removed only with the whole cache being
destryed due to sysfs/kobject lifetime model. I'd love to untangle it for
other reasons too, but haven't investigated it yet. But again it might be
useful for sysfs dir to stay around for inspection, as for the debugfs.

We could rename the sysfs/debugfs directories before queuing the work? Add
some prefix like GOING_AWAY-$name. If leak is detected and cache stays
forever, another rename to LEAKED-$name. (and same for the slabinfo). But
multiple ones with same name might pile up, so try adding a counter then?
Probably messy to implement, but perhaps the most robust in the end? The
automatic counter could also solve the general case of people using same
name for multiple caches.

Other ideas?

Thanks,
Vlastimil

> 
> 							Thanx, Paul
> 
>> >> > > Since you do it asynchronous can we just repeat
>> >> > > and wait until it a cache is furry freed?
>> >> > 
>> >> > The problem is we want to detect the cases when it's not fully freed
>> >> > because there was an actual read. So at some point we'd need to stop the
>> >> > repeats because we know there can no longer be any kfree_rcu()'s in
>> >> > flight since the kmem_cache_destroy() was called.
>> >> > 
>> >> Agree. As noted above, we can go with 21 seconds(as an example) interval
>> >> and just perform destroy(without repeating).
>> >> 
>> >> --
>> >> Uladzislau Rezki
>> 


