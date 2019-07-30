Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E937AD22
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfG3QB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:01:57 -0400
Received: from relay.sw.ru ([185.231.240.75]:41022 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfG3QB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:01:57 -0400
Received: from [172.16.25.136] (helo=localhost.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <andrey.shinkevich@virtuozzo.com>)
        id 1hsUZT-0001RG-68; Tue, 30 Jul 2019 19:01:51 +0300
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, berto@igalia.com, mdroth@linux.vnet.ibm.com,
        armbru@redhat.com, ehabkost@redhat.com, rth@twiddle.net,
        mtosatti@redhat.com, pbonzini@redhat.com, den@openvz.org,
        vsementsov@virtuozzo.com, andrey.shinkevich@virtuozzo.com
Subject: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
Date:   Tue, 30 Jul 2019 19:01:38 +0300
Message-Id: <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not the whole structure is initialized before passing it to the KVM.
Reduce the number of Valgrind reports.

Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
---
 target/i386/kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index dbbb137..ed57e31 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
         return 0;
     }
 
+    memset(&msr_data, 0, sizeof(msr_data));
     msr_data.info.nmsrs = 1;
     msr_data.entries[0].index = MSR_IA32_TSC;
     env->tsc_valid = !runstate_is_running();
@@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     if (has_xsave) {
         env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
+        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
     }
 
     max_nested_state_len = kvm_max_nested_state_length();
@@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
         return 0;
     }
 
+    memset(&dbgregs, 0, sizeof(dbgregs));
     for (i = 0; i < 4; i++) {
         dbgregs.db[i] = env->dr[i];
     }
-- 
1.8.3.1

