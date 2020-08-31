Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87E6258023
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgHaSC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 14:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbgHaSB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 14:01:26 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4432168B;
        Mon, 31 Aug 2020 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598896885;
        bh=G1iH+/QCY280fAQFzIdvytLD1XQc88ODiVu9Ro09iw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DU8uCbCylnrnZOH8dD87Y+JCYVHjfpJYEwY5+H/xHHdfEmrR+irf4GbMQZ6sHgjcV
         78yp/HohQdx54beSNjuMFkBvuXtDaKBYL0tczVVeZ/F5YHyea6TlDDfdFornMLz9Bj
         fUdXBLg3+3KEXU+EYH5ease/PcanM7FNGpu5ofJ8=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH tip/core/rcu 17/24] kvm: mmu: page_track: Fix RCU list API usage
Date:   Mon, 31 Aug 2020 11:01:09 -0700
Message-Id: <20200831180116.32690-17-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200831180050.GA32590@paulmck-ThinkPad-P72>
References: <20200831180050.GA32590@paulmck-ThinkPad-P72>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_rcu()
as it also checkes if the right lock is held.
Using hlist_for_each_entry_rcu() with a condition argument will not
report the cases where a SRCU protected list is traversed using
rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>
---
 arch/x86/kvm/mmu/page_track.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index a84a141..8443a67 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		return;
 
 	idx = srcu_read_lock(&head->track_srcu);
-	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
 			n->track_write(vcpu, gpa, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
@@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		return;
 
 	idx = srcu_read_lock(&head->track_srcu);
-	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_flush_slot)
 			n->track_flush_slot(kvm, slot, n);
 	srcu_read_unlock(&head->track_srcu, idx);
-- 
2.9.5

