Return-Path: <kvm+bounces-73246-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKLpLA+srWmE5gEAu9opvQ
	(envelope-from <kvm+bounces-73246-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 18:04:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4AD231576
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 18:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4BE2C309B410
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 16:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC47038B7B5;
	Sun,  8 Mar 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHNthfgw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF0F36C599;
	Sun,  8 Mar 2026 16:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772989106; cv=none; b=fxpHFNd9g+NoZ9meaS/JIPtesGmdFclgG/L5vqbmEgSx/LfkZyW2CiPpb/x41D+831mseuUqThC7qQ7Dhhk9UoZ0AcRjGb3O0xvawKI23NWSeq+HUUbZysY5vllFshZedQOETecVTRGO3BzoSSW2Dh+cDQ7E7eJvW/+NzuWlv1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772989106; c=relaxed/simple;
	bh=csuDDmQUnwguBiq4+JZat8SV2l/GqXHFvrAKc109vHU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KXlesJFjb1l8j41DeAjIxVndfnkruByB02AJ7K0sg1/K+FZvHC8VItOVBomzGdDJEfkvHHggT9bQWD9vvJdCK4KIdkViMID+QrPG5RX3J/5ygYUnn42zvTVOTcHeXnwn8iG5IB5yRlfkpyIriQbGaWznTC3FkDIxs6tWmMwK3j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHNthfgw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E074EC116C6;
	Sun,  8 Mar 2026 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772989105;
	bh=csuDDmQUnwguBiq4+JZat8SV2l/GqXHFvrAKc109vHU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cHNthfgwDqntovvB18ootlkTTvGH7yhvj+9JaRyixo95eyizCxRr2wtZN7CnGusH+
	 5qDTU51vqRLFJLWiMdvzCCcFALfpem18eE+Ia30vCaPIHH9PPtDq2DRE9b+Q/ApPF6
	 2M10EK3E1+T8nbDWOkIRrSKWv3yerwqRcWfj0FFsYB/P33NJO0V0yf6uXJInh65/5N
	 x15j6N3UM7eJ3BM6F28XedPb8BXsPOkS1ad3sLOFoAMu1ACEqCjGasSTCkvvPMdxZr
	 6DzmGu+bApgAKHkFHqEZ6F9xAWG8/+8J7iFg7ReoGGw6LX1zuZ3vgY3BCvNosG5DQw
	 Hg3XCvgCcSj+Q==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, Matthieu Baerts <matttbe@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
 <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>, Linux Kernel
 <linux-kernel@vger.kernel.org>, Shinichiro Kawasaki
 <shinichiro.kawasaki@wdc.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long
 <longman@redhat.com>, Marco Elver <elver@google.com>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups,
 RCU stalls, timeout
In-Reply-To: <87eclu3coa.ffs@tglx>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
 <20260306152458.GT606826@noisy.programming.kicks-ass.net>
 <87ldg42eu7.ffs@tglx> <87h5qr2rzi.ffs@tglx> <87eclu3coa.ffs@tglx>
Date: Sun, 08 Mar 2026 17:58:22 +0100
Message-ID: <87v7f61cnl.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4A4AD231576
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_FROM(0.00)[bounces-73246-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.290];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sun, Mar 08 2026 at 10:15, Thomas Gleixner wrote:

> On Sat, Mar 07 2026 at 23:29, Thomas Gleixner wrote:
>> I'll look at it more tomorrow in the hope that this rested brain
>> approach works out again.
>
> There is another one of the same category. Combo patch below.

This rested brain thing is clearly a myth. The patch actually solves
nothing because the code ensures that the TRANSIT bit is never set
together with the ONCPU bit.

One of those moments where you just hope that the earth opens up and
swallows you.

So I'm back to square one. I go and do what I should have done in the
first place. Write a debug patch with trace_printks and let the people
who can actually trigger the problem run with it.

