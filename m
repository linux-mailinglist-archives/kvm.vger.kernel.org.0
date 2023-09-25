Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1657ADFB4
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjIYTm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjIYTm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:42:58 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Sep 2023 12:42:46 PDT
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3510D
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:42:45 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:550b:0:640:d49b:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 36D8360188;
        Mon, 25 Sep 2023 22:41:14 +0300 (MSK)
Received: from vsementsov-lin.. (unknown [2a02:6b8:b081:6422::1:2a])
        by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id geUBjG0OhCg0-NTf36TY1;
        Mon, 25 Sep 2023 22:41:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
        s=default; t=1695670873;
        bh=cIe/0IKk7zt6P9c5SCbqZyb8mymi/x8y4y8A0MEOJsI=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=gjWvtdOFip8oifB7phrIXrVItMbRM8KVnIsMXzfw9fvWJ6MJ5fq8xA3m6BNpjZHxB
         UfYWxgCN4A3vEeK56eIJbdz+S+EfDL9R+iWrmxKBNQTowSbbLzhb/B+yGMtSuTdMVF
         ipFv22QD139TY0fStYMwLf5fXb8sroyCPoxOSDiI=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, vsementsov@yandex-team.ru,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH 09/12] kvm-all: introduce limits for name_size and num_desc
Date:   Mon, 25 Sep 2023 22:40:37 +0300
Message-Id: <20230925194040.68592-10-vsementsov@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230925194040.68592-1-vsementsov@yandex-team.ru>
References: <20230925194040.68592-1-vsementsov@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Coverity doesn't like when the value with unchecked bounds that comes
from fd is used as length for IO or allocation. And really, that's not
a good practice. Let's introduce at least an empirical limits for these
values.

Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
---
 accel/kvm/kvm-all.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ff1578bb32..6d0ba7d900 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3988,6 +3988,9 @@ typedef struct StatsDescriptors {
 static QTAILQ_HEAD(, StatsDescriptors) stats_descriptors =
     QTAILQ_HEAD_INITIALIZER(stats_descriptors);
 
+
+#define KVM_STATS_QEMU_MAX_NAME_SIZE (1024 * 1024)
+#define KVM_STATS_QEMU_MAX_NUM_DESC (1024)
 /*
  * Return the descriptors for 'target', that either have already been read
  * or are retrieved from 'stats_fd'.
@@ -4021,6 +4024,18 @@ static StatsDescriptors *find_stats_descriptors(StatsTarget target, int stats_fd
         g_free(descriptors);
         return NULL;
     }
+    if (kvm_stats_header->name_size > KVM_STATS_QEMU_MAX_NAME_SIZE) {
+        error_setg(errp, "KVM stats: too large name_size: %" PRIu32,
+                   kvm_stats_header->name_size);
+        g_free(descriptors);
+        return NULL;
+    }
+    if (kvm_stats_header->num_desc > KVM_STATS_QEMU_MAX_NUM_DESC) {
+        error_setg(errp, "KVM stats: too large num_desc: %" PRIu32,
+                   kvm_stats_header->num_desc);
+        g_free(descriptors);
+        return NULL;
+    }
     size_desc = sizeof(*kvm_stats_desc) + kvm_stats_header->name_size;
 
     /* Read stats descriptors */
-- 
2.34.1

