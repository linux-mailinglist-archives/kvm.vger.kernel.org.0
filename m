Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530C7619B35
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiKDPQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiKDPQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:16:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486F438B0
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667574900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tE42PNnFF/m0fEHtmSiadsyNXCXcPI2ur/gt+05bV+k=;
        b=dkf7btOF8dsGwpO5VRRBPeLQynq/DXHlr4WDeNQhkjLmyB+Jq1VZTg7IC/toIeSuZyukoK
        Hio88/LuCasVKufLSJ6mrfGgP1Hu22zpNuFc4XSL08O1O2VzeZFs+VOOMJUOhvaBDtG1jX
        25/EN+ifUMU2vpx9Jk3NTRHn2rVqVyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-bP32ffFeP-WFP6Kkw4XF0g-1; Fri, 04 Nov 2022 11:14:57 -0400
X-MC-Unique: bP32ffFeP-WFP6Kkw4XF0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDC132999B25;
        Fri,  4 Nov 2022 15:14:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ABD2C2C8D9;
        Fri,  4 Nov 2022 15:14:56 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [RFC PATCH 2/3] KVM: keep track of running vcpu ioctls
Date:   Fri,  4 Nov 2022 11:14:53 -0400
Message-Id: <20221104151454.136551-3-eesposit@redhat.com>
In-Reply-To: <20221104151454.136551-1-eesposit@redhat.com>
References: <20221104151454.136551-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just as in kvm-all.c, introduce per-vcpu QemuLockCnt to keep
track when vcpus are executing an ioctl.
Keep a per-vcpu lock to minimize cache line bouncing.
The kvm listener will then use the lock to prevent new ioctls
from running when modifying memslots.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c   | 14 ++++++++++++++
 hw/core/cpu-common.c  |  2 ++
 include/hw/core/cpu.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 099d7bda56..48cdf1fecd 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2811,6 +2811,18 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+static void kvm_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl)
+{
+    if (unlikely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        qemu_lockcnt_inc(&cpu->in_ioctl_lock);
+    } else {
+        qemu_lockcnt_dec(&cpu->in_ioctl_lock);
+    }
+}
+
 static void kvm_set_in_ioctl(bool in_ioctl)
 {
     if (likely(qemu_mutex_iothread_locked())) {
@@ -3049,7 +3061,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
 
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, true);
     ret = ioctl(cpu->kvm_fd, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, false);
     if (ret == -1) {
         ret = -errno;
     }
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index f9fdd46b9d..8d6a4b1b65 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -237,6 +237,7 @@ static void cpu_common_initfn(Object *obj)
     cpu->nr_threads = 1;
 
     qemu_mutex_init(&cpu->work_mutex);
+    qemu_lockcnt_init(&cpu->in_ioctl_lock);
     QSIMPLEQ_INIT(&cpu->work_list);
     QTAILQ_INIT(&cpu->breakpoints);
     QTAILQ_INIT(&cpu->watchpoints);
@@ -248,6 +249,7 @@ static void cpu_common_finalize(Object *obj)
 {
     CPUState *cpu = CPU(obj);
 
+    qemu_lockcnt_destroy(&cpu->in_ioctl_lock);
     qemu_mutex_destroy(&cpu->work_mutex);
 }
 
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index f9b58773f7..07852b2a3c 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -397,6 +397,9 @@ struct CPUState {
     uint32_t kvm_fetch_index;
     uint64_t dirty_pages;
 
+    /* kvm only for now: CPU is in kvm_vcpu_ioctl() (esp. KVM_RUN) */
+    QemuLockCnt in_ioctl_lock;
+
     /* Used for events with 'vcpu' and *without* the 'disabled' properties */
     DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
     DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);
-- 
2.31.1

