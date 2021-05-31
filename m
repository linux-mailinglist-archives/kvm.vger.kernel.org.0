Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCA23966AC
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhEaRQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:16:55 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:57600 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234694AbhEaRPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:15:16 -0400
HMM_SOURCE_IP: 172.18.0.218:47064.1907396775
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38?logid-29ae52c8a85445e99aab72860cfd77f0 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 4D8B52800F6;
        Tue,  1 Jun 2021 01:04:12 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 29ae52c8a85445e99aab72860cfd77f0 for qemu-devel@nongnu.org;
        Tue Jun  1 01:04:30 2021
X-Transaction-ID: 29ae52c8a85445e99aab72860cfd77f0
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
Subject: [PATCH v1 2/6] KVM: introduce dirty_pages into CPUState
Date:   Tue,  1 Jun 2021 01:04:06 +0800
Message-Id: <78cc154863754a93d88070d1fae9fed6a1ec5f01.1622479161.git.huangy81@chinatelecom.cn>
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

dirty_pages is used to calculate dirtyrate via dirty ring, when enabled,
kvm-reaper will increase the dirty pages after gfns being dirtied.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
---
 accel/kvm/kvm-all.c   | 6 ++++++
 include/hw/core/cpu.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 2e96b77b31..52cba1b094 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -506,6 +506,9 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
         }
     }
 
+    cpu->dirty_pages = 0;
+    cpu->stat_dirty_pages = false;
+
     ret = kvm_arch_init_vcpu(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret,
@@ -739,6 +742,9 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
                                  cur->offset);
         dirty_gfn_set_collected(cur);
         trace_kvm_dirty_ring_page(cpu->cpu_index, fetch, cur->offset);
+        if (cpu->stat_dirty_pages) {
+            cpu->dirty_pages++;
+        }
         fetch++;
         count++;
     }
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 044f668a6e..973c193501 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -375,6 +375,8 @@ struct CPUState {
     struct kvm_run *kvm_run;
     struct kvm_dirty_gfn *kvm_dirty_gfns;
     uint32_t kvm_fetch_index;
+    uint64_t dirty_pages;
+    bool stat_dirty_pages;
 
     /* Used for events with 'vcpu' and *without* the 'disabled' properties */
     DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
-- 
2.24.3

