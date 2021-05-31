Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAFC396703
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhEaR1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:27:37 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:58004 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233589AbhEaR1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:27:22 -0400
HMM_SOURCE_IP: 172.18.0.218:53114.1639123736
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38?logid-ed481103dcf04c7799310e542c3cbd82 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id ED4F72800FA;
        Tue,  1 Jun 2021 01:05:57 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id ed481103dcf04c7799310e542c3cbd82 for qemu-devel@nongnu.org;
        Tue Jun  1 01:05:58 2021
X-Transaction-ID: ed481103dcf04c7799310e542c3cbd82
X-filter-score:  filter<0>
X-Real-From: huangy81@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: huangy81@chinatelecom.cn
From:   huangy81@chinatelecom.cn
To:     <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, Hyman <huangy81@chinatelecom.cn>
Subject: [PATCH v1 5/6] migration/dirtyrate: check support of calculation for vcpu
Date:   Tue,  1 Jun 2021 01:05:58 +0800
Message-Id: <8c48e41e38c31827f305806704e6e23faef848c3.1622479162.git.huangy81@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1622479161.git.huangy81@chinatelecom.cn>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>

vcpu method only works when kvm dirty ring is enabled, use
kvm_dirty_ring_enabled to probe if dirty ring is enabled.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
---
 migration/dirtyrate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 7952eb6117..da6500c8ec 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -16,6 +16,7 @@
 #include "cpu.h"
 #include "exec/ramblock.h"
 #include "qemu/rcu_queue.h"
+#include "sysemu/kvm.h"
 #include "qapi/qapi-commands-migration.h"
 #include "ram.h"
 #include "trace.h"
@@ -415,6 +416,14 @@ void qmp_calc_dirty_rate(int64_t calc_time,
         return;
     }
 
+    /*
+     * Vcpu method only works when kvm dirty ring is enabled.
+     */
+    if (has_vcpu && vcpu && !kvm_dirty_ring_enabled()) {
+        error_setg(errp, "kvm dirty ring is disabled, use sample method.");
+        return;
+    }
+
     /*
      * Init calculation state as unstarted.
      */
@@ -427,6 +436,7 @@ void qmp_calc_dirty_rate(int64_t calc_time,
 
     config.sample_period_seconds = calc_time;
     config.sample_pages_per_gigabytes = DIRTYRATE_DEFAULT_SAMPLE_PAGES;
+    config.vcpu = has_vcpu ? vcpu : false;
     qemu_thread_create(&thread, "get_dirtyrate", get_dirtyrate_thread,
                        (void *)&config, QEMU_THREAD_DETACHED);
 }
-- 
2.24.3

