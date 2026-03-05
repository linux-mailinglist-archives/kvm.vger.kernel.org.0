Return-Path: <kvm+bounces-72883-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHzPBlG/qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72883-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:37:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E012216585
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9247315D11F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAB33E3DBE;
	Thu,  5 Mar 2026 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuCQX55b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8383DEAC8;
	Thu,  5 Mar 2026 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731997; cv=none; b=rKg40l2Z8SDvDfYlRiui9hG5zRyA7A30UWGSYtDWMs+7Fg4KmjXsVmIbnRF9VxlvtomEXaLYp7T0CWCt+C8Pyc8KDP31v2jwt2wxHuTCucuEAe/Efg36pdXWc7jI1fdRUNOjRRJyb5k/dIwQNTQxwWcBM2ZAdvHKUR5wiIwb94E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731997; c=relaxed/simple;
	bh=RWKTVFa+wFyx1ZZEtkA2KeKOOuvsRai5l3vU2SyuRvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ReuiD4lh7lhbFO/Yo+5JvNv/eh1l6xxhnNUmK3r7kNwU99Wv9VDVYMUPW3FZydm2+frJWY/V/jVc5i3UbeCvKtpdU0hDGEMQmdtDhDSEeYMz1Ka0DuIaakbQiaFHu97WlH+TZ4B4U7mlSRMK0nyJm01xdOJK1YzG4K+IGovPNLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuCQX55b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE7EC116C6;
	Thu,  5 Mar 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772731997;
	bh=RWKTVFa+wFyx1ZZEtkA2KeKOOuvsRai5l3vU2SyuRvk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EuCQX55bmlspqiXIbARTqKZnNKh+8NhAPrRZ4bvVvUdaTOXhYZ49AAabbbykqpZb+
	 xd/ggMFRCHchu0PxWBeS20GEiK7c+TmBgs3aW4nMlonHY88l88wp8U0+UEcCnJyM3O
	 qtvIhfQIY42ARtOyOZqpj3/ZzvhSPhoSLeIrsN+uJE5gIe5EXn33Rxd4NKNeCoCbSN
	 BL72/9kqgmg4xSb7YzANZEXBwiISoXNQ25QhzlakOFmSzuw4yyIZeSuJ/3ufenae8w
	 GrH/2DOy0jnaxIcXPe3Nk+o2NLtQoLwLVmvVhtot/YEff0rAw6+mE6Nd2aJ6bUGIVO
	 I3FCkWHNDXyUA==
Message-ID: <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org>
Date: Thu, 5 Mar 2026 18:33:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
To: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Matthieu Baerts <matttbe@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <87zf4m2qvo.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E012216585
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72883-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jirislaby@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 05. 03. 26, 17:16, Thomas Gleixner wrote:
>> Dump of any other's mm_cids needed?
> 
> It would be helpful to see the content of all PCPU CIDs and
> tsk::mm_cid::* for all tasks which belong to that process.

Not sure which of the two processes. So both:

crash> rd __per_cpu_offset 4
ffffffff94c38160:  ffff8cc799a6c000 ffff8cc799aec000   ................
ffffffff94c38170:  ffff8cc799b6c000 ffff8cc799bec000   ................



====== PID 7680 (spinning in mm_get_cid()) ======
4 tasks with
   mm = 0xffff8cc406824680
     mm_cid.pcpu = 0x66222619df00,


crash> task -x -R mm_cid ffff8cc4038525c0 ffff8cc40ad40000 
ffff8cc40683cb80 ffff8cc418424b80
PID: 7680     TASK: ffff8cc4038525c0  CPU: 1    COMMAND: "asm"
   mm_cid = {
     active = 0x1,
     cid = 0x80000000
   },

PID: 7681     TASK: ffff8cc40ad40000  CPU: 3    COMMAND: "asm"
   mm_cid = {
     active = 0x1,
     cid = 0x40000000
   },

PID: 7682     TASK: ffff8cc40683cb80  CPU: 0    COMMAND: "asm"
   mm_cid = {
     active = 0x1,
     cid = 0x40000002
   },

PID: 7684     TASK: ffff8cc418424b80  CPU: 2    COMMAND: "asm"
   mm_cid = {
     active = 0x1,
     cid = 0x40000001
   },



crash> struct mm_cid_pcpu -x 0xfffff2e9bfc09f00
struct mm_cid_pcpu {
   cid = 0x40000002
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfc89f00
struct mm_cid_pcpu {
   cid = 0x0
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfd09f00
struct mm_cid_pcpu {
   cid = 0x40000001
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfd89f00
struct mm_cid_pcpu {
   cid = 0x40000000
}




====== PID 7508 (sleeping, holding the rq lock) ======
6 tasks with
   mm = 0xffff8cc407222340
     mm_cid.pcpu = 0x66222619df40,

crash> task -x -R mm_cid ffff8cc43d090000 ffff8cc43d094b80 
ffff8cc494a00000 ffff8cc494a04b80 ffff8cc4038b8000 ffff8cc4038bcb80
PID: 7504     TASK: ffff8cc43d090000  CPU: 0    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000001
   },

PID: 7505     TASK: ffff8cc43d094b80  CPU: 1    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000003
   },

PID: 7506     TASK: ffff8cc494a00000  CPU: 3    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000000
   },

PID: 7507     TASK: ffff8cc494a04b80  CPU: 2    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000002
   },

PID: 7508     TASK: ffff8cc4038b8000  CPU: 1    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000003
   },

PID: 7630     TASK: ffff8cc4038bcb80  CPU: 2    COMMAND: "compile"
   mm_cid = {
     active = 0x1,
     cid = 0x40000002
   },


crash> struct mm_cid_pcpu -x 0xfffff2e9bfc09f40
struct mm_cid_pcpu {
   cid = 0x40000001
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfc89f40
struct mm_cid_pcpu {
   cid = 0x40000003
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfd09f40
struct mm_cid_pcpu {
   cid = 0x40000002
}
crash> struct mm_cid_pcpu -x 0xfffff2e9bfd89f40
struct mm_cid_pcpu {
   cid = 0x40000000
}


Anything else :)?

-- 
js
suse labs

