Return-Path: <kvm+bounces-72376-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GaHOd6hpWmuCAAAu9opvQ
	(envelope-from <kvm+bounces-72376-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:42:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8719F1DB0F2
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AE0D30514AC
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C36A3FFAB6;
	Mon,  2 Mar 2026 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqXiXnTG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD8F3FD13B
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772461830; cv=none; b=c9f648WGYxNNOS0n5zebtcV94lZJbq8LzhdZk4sRK7vQ7FHBx7rSdMzJxh6qhQ857sLjyUaZTivC7upXu+VGtPtVtH5ACUMtyH0pikCy78VxO5MMoTZG40ffCFwkpioKSLtX0u2dqmhMP8YA1ni70HFJmSZF2vV4J97+Li1ItAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772461830; c=relaxed/simple;
	bh=go/HfHG2FhJ+w9bQEAGjLmNf1Gd9GlG8R02BB56S9xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQm4nKanGkpm6+ywlcr4ASssblnz1rrsKKH0dRmPAH02aBQvN/tabbc3b9/rN0/85VPZtVzgSXVRSkxJVaUb0VXT4c2FXryFEYVSKYifBYCGt87RcMbwUIseLs2ux5lOD6N5ffoxRl4juZYlbDFRWj2626r+wIaCEc9+2cVmH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqXiXnTG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772461828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSIOGuuIrHUJItOjt9CUoocoM/Zq4Wh4orGn8CXzeGs=;
	b=aqXiXnTGNqW0uIC/6IQ0tmYPiZ9kGpApQ2unyUqznbo71x1pQD37iI6mU42TKsWLB5x+1A
	t/WKnsGvWGOJRAij3+LnKqmFgK6CY2F7Rbk0TCAiL5S8OM3Xt54eE6o4+acgBvtHLaMZZc
	Dr0qwMZIK/bY0Xm/lAf+AVr/rbF4vmo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-n6LlL0JgN5qdE3OoDNWahA-1; Mon,
 02 Mar 2026 09:30:25 -0500
X-MC-Unique: n6LlL0JgN5qdE3OoDNWahA-1
X-Mimecast-MFC-AGG-ID: n6LlL0JgN5qdE3OoDNWahA_1772461823
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB42B1800581;
	Mon,  2 Mar 2026 14:30:22 +0000 (UTC)
Received: from [10.22.65.79] (unknown [10.22.65.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B784F1800348;
	Mon,  2 Mar 2026 14:30:19 +0000 (UTC)
Message-ID: <d828fd84-55f5-4392-8afb-d5b1c539a2ef@redhat.com>
Date: Mon, 2 Mar 2026 09:30:18 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
To: Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@kernel.org>
Cc: Matthieu Baerts <matttbe@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260302114636.GL606826@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 8719F1DB0F2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-72376-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[longman@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,msgid.link:url]
X-Rspamd-Action: no action

On 3/2/26 6:46 AM, Peter Zijlstra wrote:
> On Mon, Mar 02, 2026 at 06:28:38AM +0100, Jiri Slaby wrote:
>
>> The state of the lock:
>>
>> crash> struct rq.__lock -x ffff8d1a6fd35dc0
>>    __lock = {
>>      raw_lock = {
>>        {
>>          val = {
>>            counter = 0x40003
>>          },
>>          {
>>            locked = 0x3,
>>            pending = 0x0
>>          },
>>          {
>>            locked_pending = 0x3,
>>            tail = 0x4
>>          }
>>        }
>>      }
>>    },
>>
>
> That had me remember the below patch that never quite made it. I've
> rebased it to something more recent so it applies.
>
> If you stick that in, we might get a clue as to who is owning that lock.
> Provided it all wants to reproduce well enough.
>
> ---
> Subject: locking/qspinlock: Save previous node & owner CPU into mcs_spinlock
> From: Waiman Long <longman@redhat.com>
> Date: Fri, 3 May 2024 22:41:06 -0400

Oh, I forgot about that patch. I should had followed up at that time. 
BTW, a lock value of 3 means that it is running paravirtual qspinlock. 
It also means that we may not know exactly what the lock owner is if it 
was acquired by lock stealing.

Cheers,
Longman

>
> From: Waiman Long <longman@redhat.com>
>
> When examining a contended spinlock in a crash dump, we can only find
> out the tail CPU in the MCS wait queue. There is no simple way to find
> out what other CPUs are waiting for the spinlock and which CPU is the
> lock owner.
>
> Make it easier to figure out these information by saving previous node
> data into the mcs_spinlock structure. This will allow us to reconstruct
> the MCS wait queue from tail to head. In order not to expand the size
> of mcs_spinlock, the original count field is split into two 16-bit
> chunks. The first chunk is for count and the second one is the new
> prev_node value.
>
>    bits 0-1 : qnode index
>    bits 2-15: CPU number + 1
>
> This prev_node value may be truncated if there are 16k or more CPUs in
> the system.
>
> The locked value in the queue head is also repurposed to hold an encoded
> qspinlock owner CPU number when acquiring the lock in the qspinlock
> slowpath of an contended lock.
>
> This lock owner information will not be available when the lock is
> acquired directly in the fast path or in the pending code path. There
> is no easy way around that.
>
> These changes should make analysis of a contended spinlock in a crash
> dump easier.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://patch.msgid.link/20240504024106.654319-1-longman@redhat.com
> ---
>   include/asm-generic/mcs_spinlock.h |    5 +++--
>   kernel/locking/mcs_spinlock.h      |    8 +++++++-
>   kernel/locking/qspinlock.c         |    8 ++++++++
>   3 files changed, 18 insertions(+), 3 deletions(-)
>
> --- a/include/asm-generic/mcs_spinlock.h
> +++ b/include/asm-generic/mcs_spinlock.h
> @@ -3,8 +3,9 @@
>   
>   struct mcs_spinlock {
>   	struct mcs_spinlock *next;
> -	int locked; /* 1 if lock acquired */
> -	int count;  /* nesting count, see qspinlock.c */
> +	int locked;	 /* non-zero if lock acquired */
> +	short count;	 /* nesting count, see qspinlock.c */
> +	short prev_node; /* encoded previous node value */
>   };
>   
>   /*
> --- a/kernel/locking/mcs_spinlock.h
> +++ b/kernel/locking/mcs_spinlock.h
> @@ -13,6 +13,12 @@
>   #ifndef __LINUX_MCS_SPINLOCK_H
>   #define __LINUX_MCS_SPINLOCK_H
>   
> +/*
> + * Save an encoded version of the current MCS lock owner CPU to the
> + * mcs_spinlock structure of the next lock owner.
> + */
> +#define MCS_LOCKED	(smp_processor_id() + 1)
> +
>   #include <asm/mcs_spinlock.h>
>   
>   #ifndef arch_mcs_spin_lock_contended
> @@ -34,7 +40,7 @@
>    * unlocking.
>    */
>   #define arch_mcs_spin_unlock_contended(l)				\
> -	smp_store_release((l), 1)
> +	smp_store_release((l), MCS_LOCKED)
>   #endif
>   
>   /*
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -250,6 +250,7 @@ void __lockfunc queued_spin_lock_slowpat
>   
>   	node->locked = 0;
>   	node->next = NULL;
> +	node->prev_node = 0;
>   	pv_init_node(node);
>   
>   	/*
> @@ -278,6 +279,13 @@ void __lockfunc queued_spin_lock_slowpat
>   	next = NULL;
>   
>   	/*
> +	 * The prev_node value is saved for crash dump analysis purpose only,
> +	 * it is not used within the qspinlock code. The encoded node value
> +	 * may be truncated if there are 16k or more CPUs in the system.
> +	 */
> +	node->prev_node = old >> _Q_TAIL_IDX_OFFSET;
> +
> +	/*
>   	 * if there was a previous node; link it and wait until reaching the
>   	 * head of the waitqueue.
>   	 */
>


