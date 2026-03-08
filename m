Return-Path: <kvm+bounces-73237-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCLYMDM+rWlV0AEAu9opvQ
	(envelope-from <kvm+bounces-73237-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 10:15:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB8B22F203
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 10:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C028301E233
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 09:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367AC36212F;
	Sun,  8 Mar 2026 09:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzKCGzS/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E912BF3D7;
	Sun,  8 Mar 2026 09:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772961305; cv=none; b=u/RqxIabZmVagsg+Lpvl5eUIUZGbt6CrZj+pW8M2TIxYraRK7fCgan48TiLpx1pcYaAZecBbSd83tSlNghEVaXl6X/rxGibxTQG1DYfWp/WzC7+HDaS1WqbRHjSLAF4xM0UzRmaDZtqs+or/iCZt8sES4CVOWLXlwEvG0fmqdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772961305; c=relaxed/simple;
	bh=52QtocqDKEObTSjQNRtNF9jdSncGF37NJ1ZjaGX9/Qo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bI399Jxno9S2wOG/PgG/13ebev5XaIOdQ1NdIEBSeS2DQThuxfrfA/4EWc7QFANk4TD6624eZ74OgK/VhfOE/1/a96eVPi+Pwpae3v7TbvFMh5kNgOsB7WSWKje306DDKxB4EggxQfHzdJnXhU65UCTrIflBfj4U2dveQH6C1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzKCGzS/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1B5C116C6;
	Sun,  8 Mar 2026 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772961305;
	bh=52QtocqDKEObTSjQNRtNF9jdSncGF37NJ1ZjaGX9/Qo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MzKCGzS/azSRPm5/oQl177GlGpOoeGhcJaCKo+2Idc1YUvVXCbmYV+bQeZBPjPTwq
	 MwEgnXbQQvLp0loNEbMy53d1Cd8GPMHcu4T8M7TJmAuhPtbR7E6fwyq9UeLTLteBJr
	 00ZWoOfMGR/DCrCNPLqULlPUWMiOBGVN68RBw0JSL7g0UC+xhmcPvMyb9nZ3kBNwhU
	 0ksE9hHhUprn9x1j1FYLqFoU6DvQR0ZVEvXVhOhQ+FsBaMlaUmbeLudXveVyIt8bYY
	 pBbMHE4jxQrOeMHmBwv2vHReqMSWPB0mGq8PjxYiEhybEF/vkh+yVF4NNYBZSbsi/s
	 6h6sJdrejS1Dw==
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
In-Reply-To: <87h5qr2rzi.ffs@tglx>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
 <20260306152458.GT606826@noisy.programming.kicks-ass.net>
 <87ldg42eu7.ffs@tglx> <87h5qr2rzi.ffs@tglx>
Date: Sun, 08 Mar 2026 10:15:01 +0100
Message-ID: <87eclu3coa.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 2BB8B22F203
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_FROM(0.00)[bounces-73237-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tglx@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.225];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sat, Mar 07 2026 at 23:29, Thomas Gleixner wrote:
> I'll look at it more tomorrow in the hope that this rested brain
> approach works out again.

There is another one of the same category. Combo patch below.

Thanks,

        tglx
---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10584,6 +10584,11 @@ static void mm_cid_fixup_cpus_to_tasks(s
 
 		/* Remote access to mm::mm_cid::pcpu requires rq_lock */
 		guard(rq_lock_irq)(rq);
+
+		/* If the transit bit is set already, nothing to do anymore.  */
+		if (cid_in_transit(pcp->cid))
+			continue;
+
 		/* Is the CID still owned by the CPU? */
 		if (cid_on_cpu(pcp->cid)) {
 			/*
@@ -10598,12 +10603,9 @@ static void mm_cid_fixup_cpus_to_tasks(s
 		} else if (rq->curr->mm == mm && rq->curr->mm_cid.active) {
 			unsigned int cid = rq->curr->mm_cid.cid;
 
-			/* Ensure it has the transition bit set */
-			if (!cid_in_transit(cid)) {
-				cid = cid_to_transit_cid(cid);
-				rq->curr->mm_cid.cid = cid;
-				pcp->cid = cid;
-			}
+			cid = cid_to_transit_cid(cid);
+			rq->curr->mm_cid.cid = cid;
+			pcp->cid = cid;
 		}
 	}
 	mm_cid_complete_transit(mm, 0);
@@ -10733,11 +10735,30 @@ void sched_mm_cid_fork(struct task_struc
 static bool sched_mm_cid_remove_user(struct task_struct *t)
 {
 	t->mm_cid.active = 0;
-	scoped_guard(preempt) {
-		/* Clear the transition bit */
+	/*
+	 * If @t is current and the CID is in transition mode, then this has to
+	 * handle both the task and the per CPU storage.
+	 *
+	 * If the CID has TRANSIT and ONCPU set, then mm_unset_cid_on_task()
+	 * won't drop the CID. As @t has already mm_cid::active cleared
+	 * mm_cid_schedout() won't drop it either.
+	 *
+	 * A failed fork cleanup can't have the transit bit set because the task
+	 * never showed up in the task list or got on a CPU.
+	 */
+	if (t == current) {
+		/* Invalidate the per CPU CID */
+		this_cpu_ptr(t->mm->mm_cid.pcpu)->cid = 0;
+		/*
+		 * Clear TRANSIT and ONCPU, so the CID gets actually dropped
+		 * below.
+		 */
 		t->mm_cid.cid = cid_from_transit_cid(t->mm_cid.cid);
-		mm_unset_cid_on_task(t);
+		t->mm_cid.cid = cpu_cid_to_cid(t->mm_cid.cid);
 	}
+
+	mm_unset_cid_on_task(t);
+
 	t->mm->mm_cid.users--;
 	return mm_update_max_cids(t->mm);
 }
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3809,7 +3809,8 @@ static __always_inline bool cid_on_task(
 
 static __always_inline void mm_drop_cid(struct mm_struct *mm, unsigned int cid)
 {
-	clear_bit(cid, mm_cidmask(mm));
+	if (!WARN_ON_ONCE(cid >= num_possible_cpus()))
+		clear_bit(cid, mm_cidmask(mm));
 }
 
 static __always_inline void mm_unset_cid_on_task(struct task_struct *t)
@@ -3978,7 +3979,13 @@ static __always_inline void mm_cid_sched
 		return;
 
 	mode = READ_ONCE(mm->mm_cid.mode);
+
+	/*
+	 * Needs to clear both TRANSIT and ONCPU to make the range comparison
+	 * and mm_drop_cid() work correctly.
+	 */
 	cid = cid_from_transit_cid(prev->mm_cid.cid);
+	cid = cpu_cid_to_cid(cid);
 
 	/*
 	 * If transition mode is done, transfer ownership when the CID is
@@ -3994,6 +4001,11 @@ static __always_inline void mm_cid_sched
 	} else {
 		mm_drop_cid(mm, cid);
 		prev->mm_cid.cid = MM_CID_UNSET;
+		/*
+		 * Invalidate the per CPU CID so that the next mm_cid_schedin()
+		 * can't observe MM_CID_ONCPU on the per CPU CID.
+		 */
+		mm_cid_update_pcpu_cid(mm, 0);
 	}
 }
 

