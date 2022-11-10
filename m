Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7547624783
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiKJQuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiKJQtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:49:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D662DC9
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668098897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJciTuRnRb4l+sIQoG140nyybXVYv2g1v3IFlBtCDkY=;
        b=b7dFXW/vhwBoH5JvYEG4SBFwPDZ1EOZN/e3SbFjekO2CrtjKuTUMeReRKBbtcVW3NRn1Gl
        oX5FDYFg6AN1rKdEbcWRPgbMvZvYErZOPAV2PUY8Uavb4Eq2X+YXwwYClq7H1HzUn+ZmAc
        /na0PeQ+jzT1YhnKscSDEO2HisbzyEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-rNaO_w88PSayqrpT6FtzBg-1; Thu, 10 Nov 2022 11:48:13 -0500
X-MC-Unique: rNaO_w88PSayqrpT6FtzBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B21D101A528;
        Thu, 10 Nov 2022 16:48:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C92B640C6F73;
        Thu, 10 Nov 2022 16:48:09 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 2/3] KVM: keep track of running ioctls
Date:   Thu, 10 Nov 2022 11:48:06 -0500
Message-Id: <20221110164807.1306076-3-eesposit@redhat.com>
In-Reply-To: <20221110164807.1306076-1-eesposit@redhat.com>
References: <20221110164807.1306076-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the new accel-blocker API, mark where ioctls are being called
in KVM. Next, we will implement the critical section that will take
care of performing memslots modifications atomically, therefore
preventing any new ioctl from running and allowing the running ones
to finish.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c   | 7 +++++++
 hw/core/cpu-common.c  | 2 ++
 include/hw/core/cpu.h | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..dfc6fe76db 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2310,6 +2310,7 @@ static int kvm_init(MachineState *ms)
     assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
 
     s->sigmask_len = 8;
+    accel_blocker_init();
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
     QTAILQ_INIT(&s->kvm_sw_breakpoints);
@@ -3014,7 +3015,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
     va_end(ap);
 
     trace_kvm_vm_ioctl(type, arg);
+    accel_set_in_ioctl(true);
     ret = ioctl(s->vmfd, type, arg);
+    accel_set_in_ioctl(false);
     if (ret == -1) {
         ret = -errno;
     }
@@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
 
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
+    accel_cpu_set_in_ioctl(cpu, true);
     ret = ioctl(cpu->kvm_fd, type, arg);
+    accel_cpu_set_in_ioctl(cpu, false);
     if (ret == -1) {
         ret = -errno;
     }
@@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
     va_end(ap);
 
     trace_kvm_device_ioctl(fd, type, arg);
+    accel_set_in_ioctl(true);
     ret = ioctl(fd, type, arg);
+    accel_set_in_ioctl(false);
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
index f9b58773f7..15053663bc 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -397,6 +397,9 @@ struct CPUState {
     uint32_t kvm_fetch_index;
     uint64_t dirty_pages;
 
+    /* Use by accel-block: CPU is executing an ioctl() */
+    QemuLockCnt in_ioctl_lock;
+
     /* Used for events with 'vcpu' and *without* the 'disabled' properties */
     DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
     DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);
-- 
2.31.1

