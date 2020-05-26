Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB01BC420
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgD1Pw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727920AbgD1Pw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 11:52:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72448C03C1AB;
        Tue, 28 Apr 2020 08:52:59 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so10860111pfn.5;
        Tue, 28 Apr 2020 08:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2c6uCE675m96/FbxOp/+YpjzTr8Ax/d5qUPMW5Gsuec=;
        b=fr2F0CojibBY6glD0TM6oVEEfkQR6dQ6Xta08+rELpBa63RJXHlQ2mjr8SnXIaQlFy
         9RQMGLd8lLgdOc1MTp+Wi0GWvc8S3nW8SVXeYeY/0/LC0PPafhRG+4JF7ffkYgvIhxDV
         7maE/trbhJ6Ios0CzPbWJTvYGUwsvrflXuGW/+tYnfQG4M7EFqyKKflPqIITL47MKb/Z
         d7VUKbgKbZywljxEDdeQCIfdJ1rAql+/0UW4r3avCnc46Ccf6GpzeSV35ZCihxt4DCZR
         5kD8b0tsu/Fno/T+Ax8w+h8OjNbveBrMTs3Xg8R6+CEP4e6Uzp08FvHSxdaco3GMQ2Zy
         Uqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2c6uCE675m96/FbxOp/+YpjzTr8Ax/d5qUPMW5Gsuec=;
        b=ozBNndw+QmJnkzo509sjglolW9f6rV4aa+oe1/OYrVNv+5bo2ZgyZX1w3EIHwk01R6
         NWMTtwdlpyXSDB7Yz4B1GDquQBPyq4mGFQitofLX0sDn7Vq2N3LXJOq9LOwg2T+JQ4dW
         i+4x4P19kHW8LffX9ljctvC5JruEGVFI+Uq2i1dtu4e0obDuBft8vdIWwr5vMMdVb8K/
         vlIrAw1CZlvhB9TJnvIvVUyIZ6tAGOxynyb+F4SVPJ+qk4TiUXfY1xPv4LKSYxRiIP3s
         Smd/e4HRSe6DEFtoiJTf4KIK6rs7AlDE+LTHxOXkBeXsXMAyKKau2KA3kKebCarsQcLU
         IvJA==
X-Gm-Message-State: AGi0PuZd0ggDjbLCO+W+M4v/Cml+AXy0P7rLXsJG9bABHWvuOc8TPPh2
        TdoV7flxbgt+BZt72H2HMQ==
X-Google-Smtp-Source: APiQypLkMPf9eFxnHsSePauRQebG54rsN5Dm5KoC2usbs2Crxz6EJNZG48I0Ks+vIHv3SzRpf3pkAg==
X-Received: by 2002:a63:2403:: with SMTP id k3mr28091220pgk.295.1588089179049;
        Tue, 28 Apr 2020 08:52:59 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:d33:c58:9c84:8ece:9d0f:426b])
        by smtp.gmail.com with ESMTPSA id mn1sm2410814pjb.24.2020.04.28.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 08:52:58 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com
Cc:     cai@lca.pw, paulmck@kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] kvm: Fix false positive RCU usage warning
Date:   Tue, 28 Apr 2020 21:22:49 +0530
Message-Id: <20200428155249.19990-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Fix the following false positive warnings:

[ 9403.765413][T61744] =============================
[ 9403.786541][T61744] WARNING: suspicious RCU usage
[ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
[ 9403.838945][T61744] -----------------------------
[ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!

and

[ 9405.859252][T61751] =============================
[ 9405.859258][T61751] WARNING: suspicious RCU usage
[ 9405.880867][T61755] -----------------------------
[ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
[ 9405.911942][T61751] -----------------------------
[ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!

Since srcu read lock is held, these are false positive warnings.
Therefore, pass condition srcu_read_lock_held() to
list_for_each_entry_rcu().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 arch/x86/kvm/mmu/page_track.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index ddc1ec3bdacd..1ad79c7aa05b 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		return;
 
 	idx = srcu_read_lock(&head->track_srcu);
-	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
 			n->track_write(vcpu, gpa, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
@@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		return;
 
 	idx = srcu_read_lock(&head->track_srcu);
-	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_flush_slot)
 			n->track_flush_slot(kvm, slot, n);
 	srcu_read_unlock(&head->track_srcu, idx);
-- 
2.17.1

