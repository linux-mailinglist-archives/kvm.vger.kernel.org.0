Return-Path: <kvm+bounces-73008-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLY8E+ylqml6UwEAu9opvQ
	(envelope-from <kvm+bounces-73008-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:01:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCFD21E597
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:01:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 118FC30E3FAF
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D193358D27;
	Fri,  6 Mar 2026 09:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKS/oUlo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC034B18E;
	Fri,  6 Mar 2026 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772791040; cv=none; b=qBYyQa+Gh+5o+W/b0LietsEhM/WYTqqgltB6mkjwX1rmhZrlBLwBLgypA3jZzOOn4flwR6/XhB3uHpKWjYSfuScy7jjcRa3zlH28tdbsB3SriCn3wYKj7ox8PsrMis/bz8xKtwR9J+aP+Pid+F0OBx1YkvGSeQOXftUYpVm3KlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772791040; c=relaxed/simple;
	bh=pkUmUb2g7nlB5B4CBhLHrn/LJcujtm0BE3qbKB1dNzw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OVyUpg2f2Lx7jZC4mUmg5E7kGZ4ubUHc0nXnJ/vmBjYZ5cY8OF/E0XozYBOCgItNvnW8LjLoVR1OQbhE1ySGiRJxUKGPzLIQT0ugAnF/uTeG9rFxxKLLpkeKq+5p1XdTvdRDjVhUahP3IY+ytkaJvuGm3qlioX7GJDlzCe+bLUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKS/oUlo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA38CC19422;
	Fri,  6 Mar 2026 09:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772791039;
	bh=pkUmUb2g7nlB5B4CBhLHrn/LJcujtm0BE3qbKB1dNzw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sKS/oUlo15AAxdnctAxUwY2A1P2GQWdJK4gC1hid5Z0qldhSQiA/r9UWPt9d+eFMl
	 5eFbKs0mKAYurXL1agu9sz6qDzBJ0i4Jcr+JNoieCv7QjaN+93GVXyF8cSGIVRm+zQ
	 EBtSLT06ZjEPHbaRfYyFNaDQOzjoLX2Cwu6cVoi0SFlmoDABpyw/bw0lXXSbnR0sgZ
	 zkmCq2VjSAVQ+2E+SVWJve839VfqrNBJombhWZWtCjIyC7jxWpgZL6+c0ZRNvG2OLn
	 nyL+hpCk1272FRNnhcH689uJ0P3VZqG+DCCRj5vwH0qRJunhCx1nevyBm42cuSGtCB
	 a6e49CQbKv9Yw==
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
In-Reply-To: <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org>
Date: Fri, 06 Mar 2026 10:57:15 +0100
Message-ID: <87qzpx2sck.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8BCFD21E597
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73008-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Action: no action

On Fri, Mar 06 2026 at 06:48, Jiri Slaby wrote:
> On 05. 03. 26, 20:25, Thomas Gleixner wrote:
>> Is there simple way to reproduce?
>
> Unfortunately not at all. To date, I even cannot reproduce locally, it 
> reproduces exclusively in opensuse build service (and github CI as per 
> Matthieu's report). I have a project in there with packages which fail 
> more often than others:
>    https://build.opensuse.org/project/monitor/home:jirislaby:softlockup
> But it's all green ATM.
>
> Builds of Go 1.24 and tests of rust 1.90 fail the most. The former even 
> takes only ~ 8 minutes, so it's not that intensive build at all. So the 
> reasons are unknown to me. At least, Go apparently uses threads for 
> building (unlike gcc/clang with forks/processes). Dunno about rust.

I tried with tons of test cases which stress test mmcid with threads and
failed.

Can you provide me your .config, source version, VM setup (Number of
CPUs, memory etc.)?

I tried to find it on that github page Matthiue mentioned but I'm
probably too stupid to navigate this clicky interface.

Thanks

        tglx

