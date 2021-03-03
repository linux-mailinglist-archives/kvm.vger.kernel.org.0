Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8E32C716
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhCDAbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386550AbhCCS3b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jSFJR2T0y61cEAykVjSlmIgXEHeIk/fhpqbk5zPRC7k=;
        b=TXHM3J5ZTJy+nxwMU7umk3u7uw74HODwcUmf3ckN/QYyN+ICHoGa/K1EAZOOfztrcGi3lw
        Pn9qAnUhbHNXvJvr1h2U8xDXTxe6AHTY/+P+Uafv8hCvEHlNcAe31Gu/uqNE6REaWPuZFq
        +TIq41FDdc5r8phpLGEMm3JaOSjVnIg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-VbVCEvlhOiq08SsSoUZiXA-1; Wed, 03 Mar 2021 13:23:56 -0500
X-MC-Unique: VbVCEvlhOiq08SsSoUZiXA-1
Received: by mail-wm1-f69.google.com with SMTP id u15so3401915wmj.2
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jSFJR2T0y61cEAykVjSlmIgXEHeIk/fhpqbk5zPRC7k=;
        b=j2+Duw1iE/ufbc/3E8yi2K1aZtt5RBVvQ3JYEdeEj8W4aokml0kyorExpDfNcEYZAt
         S5VZr8icXjbFhFw98u3qkL6rBwBr/cXdVpFkRPhM0KaeEX2fiarJhNffHULFbzcX9ole
         I42ku1RDbTTe6jNdNyCO5ohNTCAXggDsNiyYy20IXPdlPvDcWtBvLL0mxDWRSu8NGebA
         BxyMAT2LXwESrPGqa91wv83v+IGqO6+KW8bMNdOo9JM/lBR/TK0lqd2DiZGg3zNVo38Y
         TKD8aFZG12m/mYgKveafXXwz9yGdf+/Byci7AQy3vb28gCvycjSBS+ncFTHDxAwG34iD
         aWLA==
X-Gm-Message-State: AOAM533GId/WWZAaZeOWP2Ys8+DR6iLNFjM+y3EPWMDy0fTlD2FiFzis
        pQhPQ4d1GL5XbfqNN0cQNkVWlp2CNA0Rzdb/oYhU8KJfEQMW1A0K6obsSDsCA7Dm1PeOhjMX3Xg
        HzBHQGIWN7a/u
X-Received: by 2002:adf:f941:: with SMTP id q1mr29310620wrr.189.1614795835235;
        Wed, 03 Mar 2021 10:23:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+U5MnteFFnH0DvjeZoCaADZkKnu3iy+W7Ik0whDtmDP3G8okupBtGMb7OSZvJC7sHUOE4eg==
X-Received: by 2002:adf:f941:: with SMTP id q1mr29310594wrr.189.1614795835090;
        Wed, 03 Mar 2021 10:23:55 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id l15sm6604958wme.43.2021.03.03.10.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:54 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 14/19] accel/kvm: Move the 'kvm_fd' field to AccelvCPUState
Date:   Wed,  3 Mar 2021 19:22:14 +0100
Message-Id: <20210303182219.1631042-15-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h    | 2 --
 include/sysemu/kvm_int.h | 4 ++++
 accel/kvm/kvm-all.c      | 8 ++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 65ff8d86dbc..ca2526e6a23 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -314,7 +314,6 @@ struct AccelvCPUState;
  * @opaque: User data.
  * @mem_io_pc: Host Program Counter at which the memory was accessed.
  * @accel_vcpu: Pointer to accelerator-specific AccelvCPUState field.
- * @kvm_fd: vCPU file descriptor for KVM.
  * @work_mutex: Lock to prevent multiple access to @work_list.
  * @work_list: List of pending asynchronous work.
  * @trace_dstate_delayed: Delayed changes to trace_dstate (includes all changes
@@ -416,7 +415,6 @@ struct CPUState {
 
     /* Accelerator-specific fields. */
     struct AccelvCPUState *accel_vcpu;
-    int kvm_fd;
     struct KVMState *kvm_state;
     struct kvm_run *kvm_run;
     int hvf_fd;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index f57be10adde..3bf75e62293 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -14,6 +14,10 @@
 #include "sysemu/kvm.h"
 
 struct AccelvCPUState {
+    /**
+     * @kvm_fd: vCPU file descriptor for KVM
+     */
+    int kvm_fd;
 };
 
 typedef struct KVMSlot
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 4ccd12ea56a..1c08ff3fbe0 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -387,7 +387,7 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
 
     vcpu = g_malloc0(sizeof(*vcpu));
     vcpu->vcpu_id = kvm_arch_vcpu_id(cpu);
-    vcpu->kvm_fd = cpu->kvm_fd;
+    vcpu->kvm_fd = cpu->accel_vcpu->kvm_fd;
     QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
 err:
     return ret;
@@ -436,7 +436,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
     }
 
     cpu->accel_vcpu = g_new(struct AccelvCPUState, 1);
-    cpu->kvm_fd = ret;
+    cpu->accel_vcpu->kvm_fd = ret;
     cpu->kvm_state = s;
     cpu->vcpu_dirty = true;
 
@@ -449,7 +449,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
     }
 
     cpu->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED,
-                        cpu->kvm_fd, 0);
+                        cpu->accel_vcpu->kvm_fd, 0);
     if (cpu->kvm_run == MAP_FAILED) {
         ret = -errno;
         error_setg_errno(errp, ret,
@@ -2631,7 +2631,7 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
 
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
-    ret = ioctl(cpu->kvm_fd, type, arg);
+    ret = ioctl(cpu->accel_vcpu->kvm_fd, type, arg);
     if (ret == -1) {
         ret = -errno;
     }
-- 
2.26.2

