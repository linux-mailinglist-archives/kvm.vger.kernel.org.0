Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D081C03F7
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD3Rga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 13:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rga (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 13:36:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340B5C035494;
        Thu, 30 Apr 2020 10:36:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f8so2499693plt.2;
        Thu, 30 Apr 2020 10:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4K4QcAglqQHIVHuLYS6DjBHUlRjOBcFG0F/ETfmLQWg=;
        b=N03tROzm8pumHw1JUBD7EiC5oQJEswsiNzomuy7OpbRaSiKHk2QTN9f+q7w4sQSQe7
         fJy8T967jYwbfdR+88fl9XcFSj/miRIKv7/uFlVCJsQMc404QrlQXITn/JWTETl5Bm71
         WPdN9AP1+qU/FbOht0rP/BMs5kRFcMEecvGwmw0fGBsXKz9lSXY2pQD4W3dtCrjJwFog
         gDu/4TfsuXoHZ6Vs+VkQbDp3l/EyeA0cm0E0zJxNafRJzpLgo+y8JII6oljiWhDrmV+q
         mnw3EDm2Ziq8feN9f+chh/5S+ks2kqhfoQz7rVNgkvMcMyLv7Z+IhDFrikvWrHI2GrwC
         3BOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4K4QcAglqQHIVHuLYS6DjBHUlRjOBcFG0F/ETfmLQWg=;
        b=nwYNYhImWL9iRI/iMMo7H+GyhZPnQBWJnXZqJGa6Za0DriLG45BCokwyuB26iJ2Vvt
         JS4NKXJoXwKeMyqy9QmYkk05y2jSWmMbO0AOYCr93doRXTRlM6YkmtqgeEPex5wqejRb
         LFfEQVM2Q4GhBOsjs98ujVbYCse4VAxAUyxqnACSt1Buodzpqe/YX7sFG3HedZlVuGK1
         cs6byb/SVZHRXzICPU6B0C5qUSmBwpreycRNU9xPFeBkOn9XqQJRnKCcnLkLu1sT5pB3
         fAYrPS7fchRR7GzpUMEniuyJWw7c2WbCtvepcWSOiIl1SEO4msGTX3JzpDzeeSsG+3I5
         TZIw==
X-Gm-Message-State: AGi0PubduTLD8DsVGFDi1ZJIWpE8USMHKhxjVUqYytlSnQjCX7yTjsPR
        FfjEBXhFb8tg7R+VZIjW/oXquuM=
X-Google-Smtp-Source: APiQypIpNnaMBruMNCU96VU9Vfk7isUuz5/L9xxODbz2kzqcpR2dMgbsqjWbTd1c/xhsSPmtI+Siog==
X-Received: by 2002:a17:902:8643:: with SMTP id y3mr64696plt.149.1588268188682;
        Thu, 30 Apr 2020 10:36:28 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:d32:dd79:2591:468a:ee81:9c85])
        by smtp.gmail.com with ESMTPSA id l30sm337331pgu.29.2020.04.30.10.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 10:36:27 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     pbonzini@redhat.com, cai@lca.pw
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] kvm: Fix false-positive RCU list related warnings
Date:   Thu, 30 Apr 2020 23:06:08 +0530
Message-Id: <20200430173608.14663-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following warning and other usage of
RCU list in eventfd.c

[29179.937976][T75781] WARNING: suspicious RCU usage
[29179.942789][T75781] 5.7.0-rc3-next-20200429 #1 Tainted: G           O L
[29179.949752][T75781] -----------------------------
[29179.954498][T75781] arch/x86/kvm/../../../virt/kvm/eventfd.c:472 RCU-list traversed in non-reader section!!

Pass srcu_read_lock_held() as cond to list_for_each_entry_rcu().

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 virt/kvm/eventfd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 67b6fc153e9c..a23787693127 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -77,7 +77,8 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 
-	list_for_each_entry_rcu(irqfd, &resampler->list, resampler_link)
+	list_for_each_entry_rcu(irqfd, &resampler->list, resampler_link,
+				 srcu_read_lock_held(&kvm->irq_srcu))
 		eventfd_signal(irqfd->resamplefd, 1);
 
 	srcu_read_unlock(&kvm->irq_srcu, idx);
@@ -452,7 +453,7 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
 		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-					 link)
+					 link, srcu_read_lock_held(&kvm->irq_srcu))
 			if (kian->gsi == gsi) {
 				srcu_read_unlock(&kvm->irq_srcu, idx);
 				return true;
@@ -469,7 +470,7 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 	struct kvm_irq_ack_notifier *kian;
 
 	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-				 link)
+				 link, srcu_read_lock_held(&kvm->irq_srcu))
 		if (kian->gsi == gsi)
 			kian->irq_acked(kian);
 }
@@ -960,3 +961,4 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 	return kvm_assign_ioeventfd(kvm, args);
 }
+
-- 
2.17.1

