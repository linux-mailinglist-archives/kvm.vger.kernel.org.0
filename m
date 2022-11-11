Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E4625EB4
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiKKPt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiKKPtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:49:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4E9532F1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668181685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZW+CL4yASmL4vHn8T2MF2cD8Rtx/sxhlm6ERJpnu44E=;
        b=ZuOD+kggVeAjS476hwvGIvugibrcxkP11zFjP6D0LMwIyqGpT95RZhunK2x3Q8vkAqkDYJ
        972+x0/nd0vXmjwz//TudhI3RRgkhwZfnYOydUCSO8fMMfPbOEurJptooLVAaUKBSPbHyf
        xUv3FKlLQdWZJVI6bfiENbJ3eThGm9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-8NXUNLo1MQ-Jqs3fYsgv3g-1; Fri, 11 Nov 2022 10:48:01 -0500
X-MC-Unique: 8NXUNLo1MQ-Jqs3fYsgv3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5431282381D;
        Fri, 11 Nov 2022 15:48:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 589EA1120AC2;
        Fri, 11 Nov 2022 15:48:00 +0000 (UTC)
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
Subject: [PATCH v3 2/3] KVM: keep track of running ioctls
Date:   Fri, 11 Nov 2022 10:47:57 -0500
Message-Id: <20221111154758.1372674-3-eesposit@redhat.com>
In-Reply-To: <20221111154758.1372674-1-eesposit@redhat.com>
References: <20221111154758.1372674-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 accel/kvm/kvm-all.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..ff660fd469 100644
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
+    accel_ioctl_begin();
     ret = ioctl(s->vmfd, type, arg);
+    accel_ioctl_end();
     if (ret == -1) {
         ret = -errno;
     }
@@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
 
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
+    accel_cpu_ioctl_begin(cpu);
     ret = ioctl(cpu->kvm_fd, type, arg);
+    accel_cpu_ioctl_end(cpu);
     if (ret == -1) {
         ret = -errno;
     }
@@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
     va_end(ap);
 
     trace_kvm_device_ioctl(fd, type, arg);
+    accel_ioctl_begin();
     ret = ioctl(fd, type, arg);
+    accel_ioctl_end();
     if (ret == -1) {
         ret = -errno;
     }
-- 
2.31.1

