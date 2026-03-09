Return-Path: <kvm+bounces-73288-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNDNLfy+rmlEIgIAu9opvQ
	(envelope-from <kvm+bounces-73288-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:37:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE45238F39
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5606F30A5949
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 12:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAF13ACA46;
	Mon,  9 Mar 2026 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PvW4+5jG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CD33A7834;
	Mon,  9 Mar 2026 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773059034; cv=none; b=QMn8snAqNI07Dc9XNo8ZkSa6+7I2bQ/F/T7m1h+0dTqICjGDzoXkogVt725+pp2roW5LNCzapvmcynufTj7ZnbaDzpX44f8YKHU1JVjVX4JeKrbp/xyb9iFfq09GwBmuzArvexptrCVCBNxaooVv/mk56y81yzZ9qsqnnU2Cuh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773059034; c=relaxed/simple;
	bh=Py+g6qnSgfEWX6Iy57JwP3p1Ze1RcHqTVF7eH+A0Jhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxnc78KH1VCZkM4/Qr2YTqTyik039zIQwnnXXxnjo9guFlrsw3Jq6lgZOQyoz2j8t/feVFdnNn1N3XreOau6QHugJaWdjbVR9kwACJ7h/pPU463AJmAoCvwGVyXoP3sfsGjTRaqjSOYTvr1/gwJnwKPTBmv/vsP5+EmkOk/yD4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PvW4+5jG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CD8C2BC9E;
	Mon,  9 Mar 2026 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773059033;
	bh=Py+g6qnSgfEWX6Iy57JwP3p1Ze1RcHqTVF7eH+A0Jhk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PvW4+5jGrvqEwqTJgwKyHWnHCD4CDRJ/u0vWGwgMRhHQYFXpnPbSqrG+0BB/qCigK
	 0rjDo7Wbe/D/FtdJEth+OLeRQNISEeO9zfkJDjL0iFSQ+MjzesPDa+YhQCM7uRjj8M
	 bYI3GGrKrQhaLcBsA1wbHipEKP6czfMaWYy1dFu9rs7SgNLeHk6pmbyiiQatCeYSK+
	 nVBxHPOid2BywQf1QS/xk8+7vM5bjB36WH+hi+GGkOaR1/M1TneLJI/yLTeiaEe9kR
	 505lQlqcTSIio85UBYbLQL7OSLtFP1syJxfq+LY8AKNvuB5it3nCV0QLaqS+6X+15c
	 KXgvvhib5oFeg==
Message-ID: <0ae4d678-5676-4523-bae3-5ad73b526e27@kernel.org>
Date: Mon, 9 Mar 2026 13:23:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Content-Language: en-GB, fr-BE
To: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, luto@kernel.org,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>, Marco Elver <elver@google.com>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
 <20260306152458.GT606826@noisy.programming.kicks-ass.net>
 <87ldg42eu7.ffs@tglx> <87h5qr2rzi.ffs@tglx> <87eclu3coa.ffs@tglx>
 <87v7f61cnl.ffs@tglx> <57c1e171-9520-4288-9e2d-10a72a499968@kernel.org>
 <87pl5ds88r.ffs@tglx>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <87pl5ds88r.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFE45238F39
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73288-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	HAS_ORG_HEADER(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.990];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi Thomas,

On 09/03/2026 09:43, Thomas Gleixner wrote:
> On Sun, Mar 08 2026 at 18:23, Matthieu Baerts wrote:
>> 08 Mar 2026 17:58:26 Thomas Gleixner <tglx@kernel.org>:
>>> So I'm back to square one. I go and do what I should have done in the
>>> first place. Write a debug patch with trace_printks and let the people
>>> who can actually trigger the problem run with it.
>>
>> Happy to test such debug patches!
> 
> See below.
> 
> Enable the tracepoints either on the kernel command line:
> 
>     trace_event=sched_switch,mmcid:*
> 
> or before starting the test case:
> 
>     echo 1 >/sys/kernel/tracing/events/sched/sched_switch/enable
>     echo 1 >/sys/kernel/tracing/events/mmcid/enable
> 
> I added a 50ms timeout into mm_cid_get() which freezes the trace and
> emits a warning. If you enable panic_on_warn and ftrace_dump_on_oops,
> then it dumps the trace buffer once it hits the warning.
> 
> Either kernel command line:
> 
>    panic_on_warn ftrace_dump_on_oops
> 
> or
> 
>   echo 1 >/proc/sys/kernel/panic_on_warn
>   echo 1 >/proc/sys/kernel/ftrace_dump_on_oops
> 
> That should provide enough information to decode this mystery.

Thank you for the debug patch and the clear instructions. I managed to
reproduce the issue with the extra debug. The ouput is available here:

  https://github.com/user-attachments/files/25841808/issue-617-debug.txt.gz

Just in case, the kernel config file that was used:


https://github.com/user-attachments/files/25841873/issue-617-debug.config.gz

Please tell me if it is an issue to download these files from GitHub.
The output file has 10k+ lines.

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


