Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E167F26E
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjA0Xx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjA0XxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:53:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821D584FA6
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674863561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kli5sE9lIHwCvZbbt0ccDIlIdit3t3RFH2I2s6WRBok=;
        b=Om11Y/tI4o/wap2EEnIKebSgPCUA4OIsZaDhZD6vDGyJ0whuXM5MKd469uaWqFN90/Mfti
        SjLYsKGrFwvsOKJkzlfk/ouSjFZ4/4jfl5YgqDYftqMcdwIbciBIsFJXcm9VLQ5+mVTC3A
        xDCqjy5gYtjwmF9oIMXWuqRtSwPd8II=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-Q5XBn_UUMMCmDKAq2A9obQ-1; Fri, 27 Jan 2023 18:52:36 -0500
X-MC-Unique: Q5XBn_UUMMCmDKAq2A9obQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 836E23804067;
        Fri, 27 Jan 2023 23:52:35 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC4F240ED413;
        Fri, 27 Jan 2023 23:52:27 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, yuzhe@nfschina.com,
        gshan@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
Subject: [PATCH v4 1/4] KVM: arm64: Include kvm_mmu.h from vgic.h
Date:   Sat, 28 Jan 2023 07:51:47 +0800
Message-Id: <20230127235150.17025-2-gshan@redhat.com>
In-Reply-To: <20230127235150.17025-1-gshan@redhat.com>
References: <20230127235150.17025-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need a unified helper in 'kvm/vgic/vgic.h' to write guest memory. In
the helper, the check of no-running-vcpu context for dirty ring will be
applied. kvm_write_guest_lock(), defined in 'include/asm/kvm_mmu.h', is
going to be dereferenced by the unified helper.

Include 'include/asm/kvm_mmu.h' to 'kvm/vgic/vgic.h' to avoid including
the former header file when the later one is needed. With the change,
the duplicate inclusions of 'include/asm/kvm_mmu.h' are removed.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c      | 1 -
 arch/arm64/kvm/vgic/vgic-init.c       | 1 -
 arch/arm64/kvm/vgic/vgic-its.c        | 1 -
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 1 -
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 1 -
 arch/arm64/kvm/vgic/vgic-v2.c         | 1 -
 arch/arm64/kvm/vgic/vgic-v3.c         | 1 -
 arch/arm64/kvm/vgic/vgic.h            | 1 +
 8 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 78cde687383c..69201c2dfc6c 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -10,7 +10,6 @@
 #include <linux/kvm_host.h>
 #include <linux/seq_file.h>
 #include <kvm/arm_vgic.h>
-#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f6d4f4052555..de389a5bec45 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -9,7 +9,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 94a666dd1443..ad4bb69ab83e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -18,7 +18,6 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..552668a91bd9 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -8,7 +8,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <linux/uaccess.h>
-#include <asm/kvm_mmu.h>
 #include <asm/cputype.h>
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..8ba04f4fa63d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -13,7 +13,6 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 645648349c99..d8604fdfdfcd 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -7,7 +7,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
-#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 2074521d4a8c..5dfbd03e5e1a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -7,7 +7,6 @@
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
-#include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
 
 #include "vgic.h"
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c8da72953f0..056425e3a490 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -6,6 +6,7 @@
 #define __KVM_ARM_VGIC_NEW_H__
 
 #include <linux/irqchip/arm-gic-common.h>
+#include <asm/kvm_mmu.h>
 
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
-- 
2.23.0

