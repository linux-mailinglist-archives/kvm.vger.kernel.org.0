Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7F1D5F9D
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgEPIWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 04:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgEPIWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 04:22:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F44C061A0C;
        Sat, 16 May 2020 01:22:39 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fu13so2110384pjb.5;
        Sat, 16 May 2020 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n8zeuSyWYmnUTCcGG4KcbVscwA04lg+t/YXhdGOdoRk=;
        b=kSHTwd5eDGUl/K2MsusgZkFTMR3AophuUBe1kXDJlVfE5ua9O9OGjGOTYBUA3y5LCn
         8hfYpuOH9CiRvEIBKKz0DdncM80p7x2LCzSJsHtx9GOPiVNuYor8fBKkYpooLG+K18tI
         8c2l3vKaAQh3GcMZwwMvWipE1/aFXrVcw2aOz/ihBV690LmRmrcCqn4JXXF9u7tpAnRQ
         ymfsLBjAXaAY2/IYj7vPtMnKY5CNAK5wHgJ846IwYx/qZmLwhq4NKXE0mqvPU0LgGQxw
         YgOazcAPN8DRZkJWwS5Ds8FcdLH04a4/lCqZhFVRLctKTXmMN+hM+6Jb5xlsWjDkNWYd
         sudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n8zeuSyWYmnUTCcGG4KcbVscwA04lg+t/YXhdGOdoRk=;
        b=ZB79viSLq4sH6E9R2OfAZX+sXv20vMHAhBRN1KEcHy0lqX61n3eaDaT2e8PlP586ic
         /RQV/Y/P6UShlsgQlFN+Ia2LH05DCTt7pvhorEZEDY+dVljlq0OIni6DLi98G3l6wSFq
         T70fLxlpnXt9R3EKU3jW0UwZ4X2gqGsMEHbcoZdFOiG9oHOab43Qc+AzlEmNzJhvbyZW
         GtxEqU1HTEFfDPTA8AXwDK7h1wQe74FtLoJ03UwQDpFwtmeiAOihfXY26VrsX+osLhYB
         /GgrCy2m3lWMBfdmsEr8A8+SBRGYixP2f4MhfhWqq9Daa05C1CRUezVfS9W3FY6WcbD8
         itug==
X-Gm-Message-State: AOAM531pT426NTHMwnz7c8aDkkVlqKw35TmUUt/HwKVZtK2KLtzLy2j3
        7612Q/Qxo2YMMJ0h+8Vujg==
X-Google-Smtp-Source: ABdhPJy0lauqLn17lbGE3w8KJHGHD9NuhDV2LLqXRRaRQTMDJP5PCGFyuaHLhQCh2EmHugUqCHILZg==
X-Received: by 2002:a17:90b:1492:: with SMTP id js18mr1459691pjb.212.1589617359233;
        Sat, 16 May 2020 01:22:39 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13a5:a61b:b5d4:b438:1bc1:57f3])
        by smtp.gmail.com with ESMTPSA id j7sm3695288pfi.160.2020.05.16.01.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2020 01:22:38 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH v2] kvm: Fix false positive RCU usage warning
Date:   Sat, 16 May 2020 13:52:27 +0530
Message-Id: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
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
v2:
-Rebase v5.7-rc5

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

