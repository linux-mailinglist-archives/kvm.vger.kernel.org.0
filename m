Return-Path: <kvm+bounces-72358-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Km8CAV6pWm6CAYAu9opvQ
	(envelope-from <kvm+bounces-72358-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 12:52:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 781D11D7E20
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 12:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 524FB309CCAF
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 11:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE72363C55;
	Mon,  2 Mar 2026 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kze1Y62c"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BC175A8B;
	Mon,  2 Mar 2026 11:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452009; cv=none; b=qJLhYufMWo9z8nDt8KdhOBhKGzFAqrU0RnXVriJl1z2vqzys+904n/5tYEx48PF12evW7KkbQAmh2k48cnNhG/oBBbWycVqUNP8UUvlekmvmM14A5O9fE+wG83Q1LhPB6z9vB57Tu/XNPxDPIIBLVntF0Mu/3IUr+FtIw+MnBAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452009; c=relaxed/simple;
	bh=dZrOA+1QPUYVCXFMovFbCtFNY6xI315tteq+nBYF/HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRVdPIZXOSfx1Nfg7uu8imsf7O92u3OnnPxfbnvVyzJ9f1xiGA89mW+3l9ncAkTdo177ueRM7pW2C0W/I16Kmsgzx74exXGwnptXdtWrpD7dq5A0SsqwFdTmo4HGjhB6F8e+zx/9NeZcpc+E4ciQTW2yMNbOyiWlII7AQUwyK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kze1Y62c; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mee3Fn9fKuTL6HlV7u9HV8PPrdbpMBB1HvOzNZ43Rbw=; b=Kze1Y62c26784z5nuWg/Xdi77E
	2wYdWPVjwviEZv1JGS5TZQMNiQMgT5dxB9pD1QKcuYuMC8VF8MoWWrPG3xkruJuJ8LHEpBEfO93iI
	ZDjUThoSflE1iTLxBTeGrL/7XfF9EuI92HfHcz+MNgy68npSDXzet2x4psJhBX0gAi4bt+OnuqFy5
	pT7ustlANyWPtRO0EQvJkjxvC7XXxQXl0U6amuvUwK0SffpGEys5BrcaZZOQRycJW3H6EnkDpluUa
	F8E1iAya8jCnpu+NUdQ2taliMbDV1EOleoqtoipj1NroGMJe4yTsID5FzRLjCk+6Z64g+74659Flw
	d6X2D3yA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx1jT-00000009Lim-01SH;
	Mon, 02 Mar 2026 11:46:39 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B57B1300B40; Mon, 02 Mar 2026 12:46:36 +0100 (CET)
Date: Mon, 2 Mar 2026 12:46:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Matthieu Baerts <matttbe@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
	rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <MKoutny@suse.com>,
	Waiman Long <longman@redhat.com>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Message-ID: <20260302114636.GL606826@noisy.programming.kicks-ass.net>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72358-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,msgid.link:url,infradead.org:email,infradead.org:dkim,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: 781D11D7E20
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 06:28:38AM +0100, Jiri Slaby wrote:

> The state of the lock:
> 
> crash> struct rq.__lock -x ffff8d1a6fd35dc0
>   __lock = {
>     raw_lock = {
>       {
>         val = {
>           counter = 0x40003
>         },
>         {
>           locked = 0x3,
>           pending = 0x0
>         },
>         {
>           locked_pending = 0x3,
>           tail = 0x4
>         }
>       }
>     }
>   },
> 


That had me remember the below patch that never quite made it. I've
rebased it to something more recent so it applies.

If you stick that in, we might get a clue as to who is owning that lock.
Provided it all wants to reproduce well enough.

---
Subject: locking/qspinlock: Save previous node & owner CPU into mcs_spinlock
From: Waiman Long <longman@redhat.com>
Date: Fri, 3 May 2024 22:41:06 -0400

From: Waiman Long <longman@redhat.com>

When examining a contended spinlock in a crash dump, we can only find
out the tail CPU in the MCS wait queue. There is no simple way to find
out what other CPUs are waiting for the spinlock and which CPU is the
lock owner.

Make it easier to figure out these information by saving previous node
data into the mcs_spinlock structure. This will allow us to reconstruct
the MCS wait queue from tail to head. In order not to expand the size
of mcs_spinlock, the original count field is split into two 16-bit
chunks. The first chunk is for count and the second one is the new
prev_node value.

  bits 0-1 : qnode index
  bits 2-15: CPU number + 1

This prev_node value may be truncated if there are 16k or more CPUs in
the system.

The locked value in the queue head is also repurposed to hold an encoded
qspinlock owner CPU number when acquiring the lock in the qspinlock
slowpath of an contended lock.

This lock owner information will not be available when the lock is
acquired directly in the fast path or in the pending code path. There
is no easy way around that.

These changes should make analysis of a contended spinlock in a crash
dump easier.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20240504024106.654319-1-longman@redhat.com
---
 include/asm-generic/mcs_spinlock.h |    5 +++--
 kernel/locking/mcs_spinlock.h      |    8 +++++++-
 kernel/locking/qspinlock.c         |    8 ++++++++
 3 files changed, 18 insertions(+), 3 deletions(-)

--- a/include/asm-generic/mcs_spinlock.h
+++ b/include/asm-generic/mcs_spinlock.h
@@ -3,8 +3,9 @@
 
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
-	int locked; /* 1 if lock acquired */
-	int count;  /* nesting count, see qspinlock.c */
+	int locked;	 /* non-zero if lock acquired */
+	short count;	 /* nesting count, see qspinlock.c */
+	short prev_node; /* encoded previous node value */
 };
 
 /*
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -13,6 +13,12 @@
 #ifndef __LINUX_MCS_SPINLOCK_H
 #define __LINUX_MCS_SPINLOCK_H
 
+/*
+ * Save an encoded version of the current MCS lock owner CPU to the
+ * mcs_spinlock structure of the next lock owner.
+ */
+#define MCS_LOCKED	(smp_processor_id() + 1)
+
 #include <asm/mcs_spinlock.h>
 
 #ifndef arch_mcs_spin_lock_contended
@@ -34,7 +40,7 @@
  * unlocking.
  */
 #define arch_mcs_spin_unlock_contended(l)				\
-	smp_store_release((l), 1)
+	smp_store_release((l), MCS_LOCKED)
 #endif
 
 /*
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -250,6 +250,7 @@ void __lockfunc queued_spin_lock_slowpat
 
 	node->locked = 0;
 	node->next = NULL;
+	node->prev_node = 0;
 	pv_init_node(node);
 
 	/*
@@ -278,6 +279,13 @@ void __lockfunc queued_spin_lock_slowpat
 	next = NULL;
 
 	/*
+	 * The prev_node value is saved for crash dump analysis purpose only,
+	 * it is not used within the qspinlock code. The encoded node value
+	 * may be truncated if there are 16k or more CPUs in the system.
+	 */
+	node->prev_node = old >> _Q_TAIL_IDX_OFFSET;
+
+	/*
 	 * if there was a previous node; link it and wait until reaching the
 	 * head of the waitqueue.
 	 */

