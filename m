Return-Path: <kvm+bounces-72940-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGM5F7fYqWl5GAEAu9opvQ
	(envelope-from <kvm+bounces-72940-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:25:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 018752177B6
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA4FA3005A86
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8620137E2EE;
	Thu,  5 Mar 2026 19:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLjeM4LE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF773148D0;
	Thu,  5 Mar 2026 19:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772738730; cv=none; b=EuATIRvr0P2ssfc8PesAR9eOwqZ4OhBSuKB8D+5fIpQ/GWS6XvRxX9xoeeKjnF1TvnlYIE0RRJ6pboDLXlChT6vKkB3lEI+Mwfh+ec/G1HCD1F9IVqCXNtScK4LCKB/NlijZreGnjvqgqnnBXsaUdex98AMAkEEVbnh/W5rJNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772738730; c=relaxed/simple;
	bh=ln+zmT6dVmCfKEb11g1BjE/cjuoBJVgUvWUSnOfgvmc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YsO7aFuCqY6hE4e2Q7cDYOhUlMUpTwzqijsFOVbfB50tTlIm066Siwj+YtlD+zqxmnfTK9MiiLuOmaMHJ6GALgLgzQAZyaLfL9WKlKhijTC+nL7P84yqv1/+ukqSVZ/CdaeYJU4RLpef/9nX43glBk/B4f0WWccFWgC8XklcQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLjeM4LE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9412C116C6;
	Thu,  5 Mar 2026 19:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772738730;
	bh=ln+zmT6dVmCfKEb11g1BjE/cjuoBJVgUvWUSnOfgvmc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dLjeM4LE5dXR9m0xHLTdkzFdRU6WH5jM6sBt6bzgqmW/m1pCV1fgnxhtQ2vxfnQms
	 lIGU1Pgqcrs0hGxEeqFBI2JOIInj1sdmbdDRuBYfadSL9HAfeu44vbjmZxV9XVqxsu
	 4C7ekz8VQ87LFqLjcf3PWU32/mie8n5MOMtDpoUghFjAp+chM4CkkDwKwSZiFxLNLl
	 n8u8HRhxDwFJ/qBA55nIwevYUCM+2DEL2RNTGVDIuGZ8NXVJFBE8FpD9HNZk2OAS2d
	 Pz43CzlW1m78aO0KJB5qYNmiJvoxI7Z+3/LU80vHz0mDONbdHsIRnU3mKCsa8r2KVZ
	 RNawaEMbOkqcQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Matthieu Baerts <matttbe@kernel.org>, Stefan Hajnoczi
 <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, Netdev
 <netdev@vger.kernel.org>, rcu@vger.kernel.org, MPTCP Linux
 <mptcp@lists.linux.dev>, Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 "luto@kernel.org" <luto@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?=
 <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups,
 RCU stalls, timeout
In-Reply-To: <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org>
Date: Thu, 05 Mar 2026 20:25:22 +0100
Message-ID: <87tsuu2i59.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 018752177B6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-72940-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05 2026 at 18:33, Jiri Slaby wrote:
> On 05. 03. 26, 17:16, Thomas Gleixner wrote:
>
> ====== PID 7680 (spinning in mm_get_cid()) ======
> 4 tasks with
>    mm = 0xffff8cc406824680
>      mm_cid.pcpu = 0x66222619df00,
>
>
> crash> task -x -R mm_cid ffff8cc4038525c0 ffff8cc40ad40000 
> ffff8cc40683cb80 ffff8cc418424b80
> PID: 7680     TASK: ffff8cc4038525c0  CPU: 1    COMMAND: "asm"
>    mm_cid = {
>      active = 0x1,
>      cid = 0x80000000
>    },

So CID 3 has gone AWOL...

> PID: 7681     TASK: ffff8cc40ad40000  CPU: 3    COMMAND: "asm"
>    mm_cid = {
>      active = 0x1,
>      cid = 0x40000000
>    },
>
> PID: 7682     TASK: ffff8cc40683cb80  CPU: 0    COMMAND: "asm"
>    mm_cid = {
>      active = 0x1,
>      cid = 0x40000002
>    },
>
> PID: 7684     TASK: ffff8cc418424b80  CPU: 2    COMMAND: "asm"
>    mm_cid = {
>      active = 0x1,
>      cid = 0x40000001
>    },
>
> crash> struct mm_cid_pcpu -x 0xfffff2e9bfc09f00
> struct mm_cid_pcpu {
>    cid = 0x40000002
> }
> crash> struct mm_cid_pcpu -x 0xfffff2e9bfc89f00
> struct mm_cid_pcpu {
>    cid = 0x0
> }
> crash> struct mm_cid_pcpu -x 0xfffff2e9bfd09f00
> struct mm_cid_pcpu {
>    cid = 0x40000001
> }
> crash> struct mm_cid_pcpu -x 0xfffff2e9bfd89f00
> struct mm_cid_pcpu {
>    cid = 0x40000000
> }

... as 0, 1, 2 are owned by CPUs 3, 2, 0. 

The other process is not relevant. That's just fallout and has a
different CID space, which is consistent.

Is there simple way to reproduce?

Thanks,

        tglx





