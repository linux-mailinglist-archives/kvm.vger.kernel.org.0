Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658A6288273
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 08:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgJIGhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 02:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732030AbgJIGfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 02:35:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE8C0613D4;
        Thu,  8 Oct 2020 23:35:38 -0700 (PDT)
Date:   Fri, 09 Oct 2020 06:35:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602225337;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=oUDb2HwG8cuVizWUDjf89gYYGCboHOSex7ly9vGcN4A=;
        b=G+CP1sIAMbOQ0ASZ6pNjOh+NoDmz1xAT621kduUcAB0Fv4o+qHpwAAxR7jSExU5ofA7xrK
        sAmZHnI/Ui6HG07SL+3PHMy1wdbdiUDbN0v7h5Xc2E0f0q/eg6+/zHWhB8XKqY0F50tQh3
        CN5NMyF1XlclE7Ek/w2s4aEJDOTuECEl9vIqfw+CsrVYZVAJP9V8Nw0OaZHGnpzF/pj8mq
        Y51kPyAdmY2+jaOMXXUmY5Xrn95jGHRhEn3YXkAzl7cM1KFKwsAcyCWee0yku/RnQY/bac
        BDKNERaJb4itqKg0cerkoPmboArP+Tp826Rg/8CD0l7/AxFT7RLxiAUNYPxjhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602225337;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=oUDb2HwG8cuVizWUDjf89gYYGCboHOSex7ly9vGcN4A=;
        b=vz4ghSJps1vPvwlbaKzJQbJfeX7f7C20CAyLQ5qtnS6tasXBM4uQNigvjU2n7nz7nAyrcX
        9lUfLNOmsuDqfxDw==
From:   "tip-bot2 for Madhuparna Bhowmik" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] kvm: mmu: page_track: Fix RCU list API usage
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160222533671.7002.15652338637485531444.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     df9a30fd1f70a757df193acd7396622eee23e527
Gitweb:        https://git.kernel.org/tip/df9a30fd1f70a757df193acd7396622eee23e527
Author:        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
AuthorDate:    Sun, 12 Jul 2020 18:40:03 +05:30
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Mon, 24 Aug 2020 18:36:23 -07:00

kvm: mmu: page_track: Fix RCU list API usage

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
