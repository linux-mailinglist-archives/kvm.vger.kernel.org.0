Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877C132C719
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbhCDAbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386545AbhCCS3b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HpZXUiaC2c4IcwOvA2cs846pRcaPAAbCPhPXUPapPlg=;
        b=GgAWKx0ImKR4xniVn2BWm10eTQL3hxKbcltUCh2N7r8nwLmETI3yCyd/x2dt1R/ek/n1Pe
        gco+YBNhGkwG+rvYz0GOg0aG417Qje2XN6CBMubriQxlyt5YNOLdaGGWAuKER4UZWsWDC1
        1X8VkrG5JPDsAyQLODJsZtqkidFfHmw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-z506jDzcM72MrWEVa7dOiQ-1; Wed, 03 Mar 2021 13:23:51 -0500
X-MC-Unique: z506jDzcM72MrWEVa7dOiQ-1
Received: by mail-wr1-f69.google.com with SMTP id v13so12196174wrs.21
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HpZXUiaC2c4IcwOvA2cs846pRcaPAAbCPhPXUPapPlg=;
        b=oNEr4oWrAz/A7rxdWfqeSX6wNTl8bsQ+D6tO8nkmO3EO9/Xbg928Yqxm+NMMm9CPX2
         Q/Q21Y2wJ6zslyboZBeob8WE/H4byAg/vvWhtLpG03YltZVP+k+ICrq4t9JQiQ5PxeSz
         aRl5+PqxZuLPVCmXMuoAOhVTlN1Z7Wm56snbv7qi7OZbw9rqjkYOV0tf/vkmcxSOXgHk
         k+jcKHTgKwvEjnT15p7iMEDThmVdT3JgapxvbfiEYJ3rWCj3gsQmJfbVWjDU0tbNJUT0
         aS9Le0MbJadNH2rLMaURcIXXAmXqHvPhrL/+zh/Q5FTIwRey0bfPxtksna8jPTfEO5EA
         6boA==
X-Gm-Message-State: AOAM530ntkm7JfHxh7zbvay4pWgRCJ4XepfBVyDrIanZynnekEXFnjK1
        9IxJ1uPaWCgI2jyqPe9G67DTxNx89YEVG9EyiBx3RnyC5Lby6UzgQ4PA2aV3VhvI5/6NT5ZsLYX
        SEkPP/RdULERK
X-Received: by 2002:adf:9bd7:: with SMTP id e23mr38407wrc.48.1614795829817;
        Wed, 03 Mar 2021 10:23:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5Hi2oRgLR+p5+nLOhzpKyBoO9bwdj0rvSDTYuP5mfCGdgF+ImQznX99ey9HDtd42t6mXMIw==
X-Received: by 2002:adf:9bd7:: with SMTP id e23mr38385wrc.48.1614795829618;
        Wed, 03 Mar 2021 10:23:49 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id p14sm6718722wmc.30.2021.03.03.10.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:49 -0800 (PST)
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
Subject: [RFC PATCH 13/19] accel/kvm: Declare and allocate AccelvCPUState struct
Date:   Wed,  3 Mar 2021 19:22:13 +0100
Message-Id: <20210303182219.1631042-14-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation of moving KVM-specific fields from CPUState
to the accelerator-specific AccelvCPUState structure, first
declare it empty and allocate it. This will make the following
commits easier to review.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/kvm_int.h | 3 +++
 accel/kvm/kvm-all.c      | 5 +++++
 target/s390x/kvm.c       | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index ccb8869f01b..f57be10adde 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -13,6 +13,9 @@
 #include "qemu/accel.h"
 #include "sysemu/kvm.h"
 
+struct AccelvCPUState {
+};
+
 typedef struct KVMSlot
 {
     hwaddr start_addr;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 8259e89bbaf..4ccd12ea56a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -399,6 +399,7 @@ void kvm_destroy_vcpu(CPUState *cpu)
         error_report("kvm_destroy_vcpu failed");
         exit(EXIT_FAILURE);
     }
+    g_free(cpu->accel_vcpu);
 }
 
 static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
@@ -434,6 +435,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
         goto err;
     }
 
+    cpu->accel_vcpu = g_new(struct AccelvCPUState, 1);
     cpu->kvm_fd = ret;
     cpu->kvm_state = s;
     cpu->vcpu_dirty = true;
@@ -468,6 +470,9 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
                          kvm_arch_vcpu_id(cpu));
     }
 err:
+    if (ret < 0) {
+        g_free(cpu->accel_vcpu);
+    }
     return ret;
 }
 
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index d8ac12dfc11..cf6790b2678 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -2085,7 +2085,7 @@ int kvm_s390_set_cpu_state(S390CPU *cpu, uint8_t cpu_state)
     int ret;
 
     /* the kvm part might not have been initialized yet */
-    if (CPU(cpu)->kvm_state == NULL) {
+    if (CPU(cpu)->accel_vcpu == NULL) {
         return 0;
     }
 
-- 
2.26.2

