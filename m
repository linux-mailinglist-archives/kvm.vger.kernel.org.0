Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256A4619B33
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiKDPQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiKDPP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:15:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A76B3C
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 08:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667574902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqajUAJmYrE2XQXwS2++lD6bdpKZOtRow+ECsg6ZdMo=;
        b=Jjt+V1z2V/77eyydv8Tc1n2mFqAjMU0pKMZbHmIyixwzX775/T7XzFZQuAFMLWNcKlNGTr
        i6AeC4wUqRmzVwJs3xDA7BqGxJMbPXNYSuCsishF41OdmfosG/LCD9kKrlSxo0L0YrWOGM
        SyJTjcWNOe+K+GDWs761wZ3LYsDRWVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-iCifCcRINnyAhF1zNoGO6g-1; Fri, 04 Nov 2022 11:14:56 -0400
X-MC-Unique: iCifCcRINnyAhF1zNoGO6g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61DBA185A78F;
        Fri,  4 Nov 2022 15:14:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 223B8C1908B;
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
Subject: [RFC PATCH 1/3] KVM: keep track of running ioctls
Date:   Fri,  4 Nov 2022 11:14:52 -0400
Message-Id: <20221104151454.136551-2-eesposit@redhat.com>
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

kvm_in_ioctl_lock uses a QemuLockCnt to keep track of the running
ioctls. It will be used by the memory listener to make sure no
new ioctl runs when it has to perform memslots modifications.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..099d7bda56 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -105,6 +105,8 @@ static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size = ~0;
 
+QemuLockCnt kvm_in_ioctl_lock;
+
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
     KVM_CAP_INFO(USER_MEMORY),
     KVM_CAP_INFO(DESTROY_MEMORY_REGION_WORKS),
@@ -2310,6 +2312,7 @@ static int kvm_init(MachineState *ms)
     assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
 
     s->sigmask_len = 8;
+    qemu_lockcnt_init(&kvm_in_ioctl_lock);
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
     QTAILQ_INIT(&s->kvm_sw_breakpoints);
@@ -2808,6 +2811,18 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+static void kvm_set_in_ioctl(bool in_ioctl)
+{
+    if (likely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        qemu_lockcnt_inc(&kvm_in_ioctl_lock);
+    } else {
+        qemu_lockcnt_dec(&kvm_in_ioctl_lock);
+    }
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run = cpu->kvm_run;
@@ -3014,7 +3029,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
     va_end(ap);
 
     trace_kvm_vm_ioctl(type, arg);
+    kvm_set_in_ioctl(true);
     ret = ioctl(s->vmfd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret == -1) {
         ret = -errno;
     }
@@ -3050,7 +3067,9 @@ int kvm_device_ioctl(int fd, int type, ...)
     va_end(ap);
 
     trace_kvm_device_ioctl(fd, type, arg);
+    kvm_set_in_ioctl(true);
     ret = ioctl(fd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret == -1) {
         ret = -errno;
     }
-- 
2.31.1

