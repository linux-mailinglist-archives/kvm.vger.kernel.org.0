Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4813966B7
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhEaRSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:18:33 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.219]:58422 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234053AbhEaRRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:17:25 -0400
HMM_SOURCE_IP: 172.18.0.218:37984.253484957
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39?logid-4a3d34afc9d14b97a5e6c1a5d502adc7 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D220D2800B0;
        Tue,  1 Jun 2021 01:04:59 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 4a3d34afc9d14b97a5e6c1a5d502adc7 for qemu-devel@nongnu.org;
        Tue Jun  1 01:04:59 2021
X-Transaction-ID: 4a3d34afc9d14b97a5e6c1a5d502adc7
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
Subject: [PATCH v1 3/6] migration/dirtyrate: add vcpu option for qmp calc-dirty-rate
Date:   Tue,  1 Jun 2021 01:05:00 +0800
Message-Id: <28111cd734b1b6e76f7cd8f2f6ad1d4c54f12842.1622479162.git.huangy81@chinatelecom.cn>
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

calculate dirtyrate for each vcpu if vcpu is true, add the
dirtyrate of each vcpu to the return value also.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
---
 migration/dirtyrate.c |  5 ++++-
 migration/dirtyrate.h |  1 +
 qapi/migration.json   | 28 ++++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index ccb98147e8..3c1a824a41 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -383,7 +383,10 @@ void *get_dirtyrate_thread(void *arg)
     return NULL;
 }
 
-void qmp_calc_dirty_rate(int64_t calc_time, Error **errp)
+void qmp_calc_dirty_rate(int64_t calc_time,
+                         bool has_vcpu,
+                         bool vcpu,
+                         Error **errp)
 {
     static struct DirtyRateConfig config;
     QemuThread thread;
diff --git a/migration/dirtyrate.h b/migration/dirtyrate.h
index 6ec429534d..f20dd52d77 100644
--- a/migration/dirtyrate.h
+++ b/migration/dirtyrate.h
@@ -38,6 +38,7 @@
 struct DirtyRateConfig {
     uint64_t sample_pages_per_gigabytes; /* sample pages per GB */
     int64_t sample_period_seconds; /* time duration between two sampling */
+    bool vcpu; /* calculate dirtyrate for each vcpu using dirty ring */
 };
 
 /*
diff --git a/qapi/migration.json b/qapi/migration.json
index 7a5bdf9a0d..896ebcb93b 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -1708,6 +1708,21 @@
 { 'event': 'UNPLUG_PRIMARY',
   'data': { 'device-id': 'str' } }
 
+##
+# @DirtyRateVcpu:
+#
+# Dirty rate of vcpu.
+#
+# @id: vcpu index.
+#
+# @dirty-rate: dirty rate.
+#
+# Since: 6.1
+#
+##
+{ 'struct': 'DirtyRateVcpu',
+  'data': { 'id': 'int', 'dirty-rate': 'int64' } }
+
 ##
 # @DirtyRateStatus:
 #
@@ -1740,6 +1755,10 @@
 #
 # @calc-time: time in units of second for sample dirty pages
 #
+# @vcpu: calculate dirtyrate for each vcpu (Since 6.1)
+#
+# @vcpu-dirty-rate: dirtyrate for each vcpu (Since 6.1)
+#
 # Since: 5.2
 #
 ##
@@ -1747,7 +1766,9 @@
   'data': {'*dirty-rate': 'int64',
            'status': 'DirtyRateStatus',
            'start-time': 'int64',
-           'calc-time': 'int64'} }
+           'calc-time': 'int64',
+           '*vcpu': 'bool',
+           '*vcpu-dirty-rate': [ 'DirtyRateVcpu' ] } }
 
 ##
 # @calc-dirty-rate:
@@ -1756,13 +1777,16 @@
 #
 # @calc-time: time in units of second for sample dirty pages
 #
+# @vcpu: calculate vcpu dirty rate if true, the default value is
+#        false (since 6.1)
+#
 # Since: 5.2
 #
 # Example:
 #   {"command": "calc-dirty-rate", "data": {"calc-time": 1} }
 #
 ##
-{ 'command': 'calc-dirty-rate', 'data': {'calc-time': 'int64'} }
+{ 'command': 'calc-dirty-rate', 'data': {'calc-time': 'int64', '*vcpu': 'bool'} }
 
 ##
 # @query-dirty-rate:
-- 
2.24.3

