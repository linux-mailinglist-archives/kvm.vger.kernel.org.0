Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593CB7AD23
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfG3QB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:41018 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730229AbfG3QB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from [172.16.25.136] (helo=localhost.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <andrey.shinkevich@virtuozzo.com>)
        id 1hsUZS-0001RG-1s; Tue, 30 Jul 2019 19:01:50 +0300
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, berto@igalia.com, mdroth@linux.vnet.ibm.com,
        armbru@redhat.com, ehabkost@redhat.com, rth@twiddle.net,
        mtosatti@redhat.com, pbonzini@redhat.com, den@openvz.org,
        vsementsov@virtuozzo.com, andrey.shinkevich@virtuozzo.com
Subject: [PATCH 1/3] test-throttle: Fix uninitialized use of burst_length
Date:   Tue, 30 Jul 2019 19:01:36 +0300
Message-Id: <1564502498-805893-2-git-send-email-andrey.shinkevich@virtuozzo.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ThrottleState::cfg of the static variable 'ts' is reassigned with the
local one in the do_test_accounting() and then is passed to the
throttle_account() with uninitialized member LeakyBucket::burst_length.

Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
---
 tests/test-throttle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/test-throttle.c b/tests/test-throttle.c
index a288122..ebf3aeb 100644
--- a/tests/test-throttle.c
+++ b/tests/test-throttle.c
@@ -557,6 +557,8 @@ static bool do_test_accounting(bool is_ops, /* are we testing bps or ops */
     BucketType index;
     int i;
 
+    throttle_config_init(&cfg);
+
     for (i = 0; i < 3; i++) {
         BucketType index = to_test[is_ops][i];
         cfg.buckets[index].avg = avg;
-- 
1.8.3.1

