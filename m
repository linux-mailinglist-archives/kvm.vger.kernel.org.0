Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEBD36D489
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 11:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhD1JJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 05:09:34 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:53378 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbhD1JJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 05:09:34 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d23 with ME
        id y98k2400a21Fzsu0398lpr; Wed, 28 Apr 2021 11:08:48 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 28 Apr 2021 11:08:48 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] x86/kvm: Use 'hlist_for_each_entry' to simplify code
Date:   Wed, 28 Apr 2021 11:08:43 +0200
Message-Id: <29796ca9a5d4255c2a0260c2f5c829539a6e7d88.1619600757.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use 'hlist_for_each_entry' instead of hand writing it.
This saves a few lines of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 arch/x86/kernel/kvm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d307c22e5c18..35f5a0898b92 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -89,14 +89,11 @@ static struct kvm_task_sleep_head {
 static struct kvm_task_sleep_node *_find_apf_task(struct kvm_task_sleep_head *b,
 						  u32 token)
 {
-	struct hlist_node *p;
+	struct kvm_task_sleep_node *n;
 
-	hlist_for_each(p, &b->list) {
-		struct kvm_task_sleep_node *n =
-			hlist_entry(p, typeof(*n), link);
+	hlist_for_each_entry(n, &b->list, link)
 		if (n->token == token)
 			return n;
-	}
 
 	return NULL;
 }
@@ -169,14 +166,12 @@ static void apf_task_wake_all(void)
 	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++) {
 		struct kvm_task_sleep_head *b = &async_pf_sleepers[i];
 		struct kvm_task_sleep_node *n;
-		struct hlist_node *p, *next;
+		struct hlist_node *next;
 
 		raw_spin_lock(&b->lock);
-		hlist_for_each_safe(p, next, &b->list) {
-			n = hlist_entry(p, typeof(*n), link);
+		hlist_for_each_entry_safe(n, next, &b->list, link)
 			if (n->cpu == smp_processor_id())
 				apf_task_wake_one(n);
-		}
 		raw_spin_unlock(&b->lock);
 	}
 }
-- 
2.30.2

