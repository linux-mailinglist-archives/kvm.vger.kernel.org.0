Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054BB21C95A
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 15:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgGLNK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 09:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgGLNK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 09:10:27 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36DCC061794;
        Sun, 12 Jul 2020 06:10:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x72so4784506pfc.6;
        Sun, 12 Jul 2020 06:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QlHdcq1NMFZUiVr/PWZTQMUwB+nApvKctneHSUoV9JI=;
        b=CDx8EbSNzRbyCNhyw7LW1mm97sOqmMXjqAFWs4mxTiPuHBDb0GM1lk1UwKagomOVR5
         pFVN5rAHmjjq0wHMbWdUctDF6J0OpGVsK21gv74z/DHVdqRe5Cv0V4OkzuaqOKRu0VDc
         3tUtThRmTJNUYnY/olbPHMAUcalI2BDfArzx0sfEk26J8q21cHTwII/j0FwMwPCBNZyy
         7ACuD6Ua+HhLe4dh9NmV0YWtHilYo+WvHMXXGIr8Lu3Sy7gHi1RC4Q8ehTMGvQ3DJq6+
         hMcnS9E7DoQ/qiqvzI58Ye1eQ5fc2U3FyqXTfIRE+TQCDhRH6S7kaOUDIz8tmxyAaN2k
         yCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QlHdcq1NMFZUiVr/PWZTQMUwB+nApvKctneHSUoV9JI=;
        b=BXGEm/TW7bWqZ8wZO/nYWXPy420IVu7s/mFp0HvEiYg8W4omPnY06C5Ps72oJ9CUI0
         Qbqw8zvFEerjLWDJ6ansvx4vRa2Tj4mEJLI9Modox69LvmM3Dpix/ZiXlQuyFAtcz1Ve
         izCZIg2C/1s4ATsIx+s28gdkaSiPe1N/c+8/IJIigfKD6UWcbzvVNb+GvUIk6bf2WWjj
         AYv98ymZtz8vLYAJ4Ab+nDCtCl8ZdsGGo4fZcAktKo8d5HfoK6qoEJhI3HSitXHEoHM7
         IDZIeMGgBwYv/svo8bgNv/Iwk06L2yQ2vyX4zO+g8xF9//UxenBv3sGi0ubzIIMZaUtQ
         Z/eQ==
X-Gm-Message-State: AOAM533DkuRoVrjx+dISyVlzc67zyclnv77C9Dhk6tTYipDNDhyqDmy9
        5BaYaZNrNzFawgf5nabfzg==
X-Google-Smtp-Source: ABdhPJzGCWqeGrl0pmni+0aENWLJwun+oPUDiRCIjS3IwjlN3XTVOCk6hJo4EVWSlnu21qMCqiR/Cg==
X-Received: by 2002:a62:b413:: with SMTP id h19mr17778687pfn.142.1594559427253;
        Sun, 12 Jul 2020 06:10:27 -0700 (PDT)
Received: from localhost.localdomain ([2409:4071:200a:9520:4919:edd3:5dbd:ffec])
        by smtp.gmail.com with ESMTPSA id q24sm12093014pfg.95.2020.07.12.06.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 06:10:26 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     paulmck@kernel.org, josh@joshtriplett.org, joel@joelfernandes.org,
        pbonzini@redhat.com
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm@vger.kernel.org, frextrite@gmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
Date:   Sun, 12 Jul 2020 18:40:03 +0530
Message-Id: <20200712131003.23271-2-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
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
---
 arch/x86/kvm/mmu/page_track.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index a7bcde34d1f2..a9cd17625950 100644
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
2.17.1

