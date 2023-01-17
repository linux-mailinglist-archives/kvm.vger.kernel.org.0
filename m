Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83418670BC7
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjAQWmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAQWlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:41:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708CE4FC30
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:27:12 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 81-20020a250b54000000b007c002e178dfso26012531ybl.9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dPBcRBsDAGoDfORsxWE6afj5vOW1Ynx1npcixEfl3Uk=;
        b=XY97r+ZI3j1H8OMhxVXfjvk1gQTDhvUvtxa1ePQSQ6H7uq4fC7YyE4gXGjvpSJNc6X
         K6np7KC/0asGiXRwoKcGTS7ArqhqLFJdAEJ4OaUjqRpa3Cd3Ofsmm/UVJJZpFJiV1mNC
         SXW9QSH6Qs0DS/GTd5AVQMh+UfkB3hFrIdAyvcORcVe/UuJ+yNU5t9Ttto2FjsORd7hy
         wAM0LMLySg/8hbPs7McH8Z9dkYDqVPvci4eBrZKda0+yeC82FrQYWS9ZE4ASiT21WoZV
         uELrx25MrTxu1q7TiLLDOxh8LukWnjU/s0z4p9IJrcdJa9GQG+grT8rpl9BGRa8Yy7xW
         ctXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dPBcRBsDAGoDfORsxWE6afj5vOW1Ynx1npcixEfl3Uk=;
        b=TjJ0iVr24PSerHA5CeUP+s0i4yf7sSBtmoWmoCQ8+DlCWZkQWGleyrcC0YS+x320er
         M/vXkdkVQ/XxBdlUybnfrfkzrJQZEdneFb7kGrAAo4XAr5hPkHZ+79DjtYfWaS2WT9Uo
         aXlvyjJVRrSKC+l0yCtm1paNvodhl2tnP25R50TY7hPBhBDOR3r4KjEBziXnxdW1zd8p
         8Tttlh46azFHz1u5Bon5ckLBD7YwILKjznJ6ZgqCO8GSVXX3PlnNI3sY1zVuakMy5iiD
         uewrlrM84XdyRZbCZnuAPRYMOAHRP2KzZsRTX4FgwNTXxOJsL9gA3mLAKc68RyBe3NNC
         +1Ig==
X-Gm-Message-State: AFqh2krg0IjKww38dT83NXtFRPce1ype4bjzuPO1WM3rRgOClTL7h3pH
        Qw3bvvSxBhRb67aTAJ+UlgTe4VxUopouOQ==
X-Google-Smtp-Source: AMrXdXvh6ecrbEC0lwAJglyrB/fMU1igRqBopN2uJY51WgGuIpzXrshKKLiXXuSAr9I+DiYzxm5a4Toi1grRTA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:c91:0:b0:4e1:2b59:292d with SMTP id
 139-20020a810c91000000b004e12b59292dmr773670ywm.450.1673994431671; Tue, 17
 Jan 2023 14:27:11 -0800 (PST)
Date:   Tue, 17 Jan 2023 14:27:07 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230117222707.3949974-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Stop assuming stats are contiguous in kvm_binary_stats_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

Remove the assumption from kvm_binary_stats_test that all stats are
laid out contiguously in memory. The current stats in KVM are
contiguously laid out in memory, but that may change in the future and
the ABI specifically allows holes in the stats data (since each stat
exposes its own offset).

While here drop the check that each stats' offset is less than
size_data, as that is now always true by construction.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-9-dmatlack@google.com/
Fixes: 0b45d58738cd ("KVM: selftests: Add selftest for KVM statistics data binary interface")
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
[Re-worded the commit message.]

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 894417c96f70..a7001e29dc06 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -134,7 +134,7 @@ static void stats_test(int stats_fd)
 				    "Bucket size of stats (%s) is not zero",
 				    pdesc->name);
 		}
-		size_data += pdesc->size * sizeof(*stats_data);
+		size_data = max(size_data, pdesc->offset + pdesc->size * sizeof(*stats_data));
 	}
 
 	/*
@@ -149,14 +149,6 @@ static void stats_test(int stats_fd)
 	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
 		    "Data size is not correct");
 
-	/* Check stats offset */
-	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = get_stats_descriptor(stats_desc, i, &header);
-		TEST_ASSERT(pdesc->offset < size_data,
-			    "Invalid offset (%u) for stats: %s",
-			    pdesc->offset, pdesc->name);
-	}
-
 	/* Allocate memory for stats data */
 	stats_data = malloc(size_data);
 	TEST_ASSERT(stats_data, "Allocate memory for stats data");

base-commit: de60733246ff4545a0483140c1f21426b8d7cb7f
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
-- 
2.39.0.246.g2a6d74b583-goog

