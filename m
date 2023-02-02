Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6BC68865D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjBBS2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjBBS2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:21 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C3B3F285
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:18 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j9-20020a654d49000000b004f0bf9613fbso1375840pgt.20
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oI2rqe8UglBSqeQM/qZzRcQFn/AWh8f3tqKjZ0B80vs=;
        b=n3D5F4ZKgEu5F9+wwtibXHJcuhI7R+kG2XBY/kMf5C0UMb4zaihINeT5u8YcwnOcqr
         ZIG9YfwT6ihp8cAkJkJVxAfhYRAFsi2dxNtmuQ9bpesC1zYnFBXNZpJFtLjXFuhtXtWF
         /pmvmP7pUTj+gHJyRPdpAgXGXAtScU8e8+3I5Odg/hNTFgw5BMMS8+/bZxlUBJF3NZre
         ZZxEQGZMLpK/Fk+ZMI5QRLJ17txFiyi9/L27QuRD5+TbWTIxFiJYxzVkVDO1tgLWVQ5C
         3N3GPLOcRB3986GtQaZsknMzTXX4ytBsBLVZM8Inm2aOaMtXVO1LTUcJwfhSzGUUn+gY
         g7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oI2rqe8UglBSqeQM/qZzRcQFn/AWh8f3tqKjZ0B80vs=;
        b=uLXqaxYP/o0lbGSAXLdIOT6C+i2iL+TnJQ4BefQq+51M2/HtqjughddiC1X69u5PkU
         iHSgzJ52IjnJZ+BHY3QVsCN7/dTeXnfHe7osHY3l9LzNdEinzuUDgQuIgT334f7faU08
         oR0wAKS5XYLzxIBgIRA3ccF/tfSoqAHPR8LbRzw5mAAVfMPlsCEiBKwX5Y1hL0uKXSz4
         LVPfB4BWRUZc2J4SqVYCRKNnVhHLTAII5mAGWhym9NPKI48VRyhxRjU7PJKmgIWOMmGX
         S1nNNOXzvzPuzRKqWSM6Fa0tIaO2vR+atPN/B/EvHTIcw3gYeOqlDlzx3CYPUMc5HXoo
         eAlg==
X-Gm-Message-State: AO0yUKWBDZj9HzvFTJvAEmasQjqyM7ETBZnp5oPkmZaO84pmDcpxlhs8
        k7O2C8lioT6cyeFOFJpMA0lObEtMUp0W
X-Google-Smtp-Source: AK7set93vgx0g+xOwdleq2ZlqNB1tiT2dbYHgasrZB9TUz/RZfwEm8OTxvxeEC2FOX5q01Vckhh5XOPMh0a4
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:f552:b0:198:a5da:bf6c with SMTP id
 h18-20020a170902f55200b00198a5dabf6cmr1834157plf.9.1675362497874; Thu, 02 Feb
 2023 10:28:17 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:52 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-5-bgardon@google.com>
Subject: [PATCH 04/21] KVM: x86/MMU: Add shadow_mmu.(c|h)
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a first step to splitting the Shadow MMU out of KVM MMU common code,
add separate files for it with some of the boilerplate and includes the
Shadow MMU will need.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/Makefile         |  2 +-
 arch/x86/kvm/mmu/mmu.c        |  1 +
 arch/x86/kvm/mmu/shadow_mmu.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h | 21 +++++++++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.c
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17e..d6e94660b006e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,7 +12,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o
+			   mmu/spte.o mmu/shadow_mmu.o
 
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3674bde2203b2..752c38d625a32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -21,6 +21,7 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "tdp_mmu.h"
+#include "shadow_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "smm.h"
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
new file mode 100644
index 0000000000000..eee5a6796d9b0
--- /dev/null
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM Shadow MMU
+ *
+ * Extracted from mmu.c
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
+ * Copyright (C) 2023, Google, Inc.
+ *
+ * Original authors:
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Avi Kivity   <avi@qumranet.com>
+ */
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "mmutrace.h"
+#include "shadow_mmu.h"
+#include "spte.h"
+
+#include <asm/vmx.h>
+#include <asm/cmpxchg.h>
+#include <trace/events/kvm.h>
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
new file mode 100644
index 0000000000000..2bfba6ad20688
--- /dev/null
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KVM Shadow MMU
+ *
+ * Extracted from mmu.c
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright 2010 Red Hat, Inc. and/or its affiliates.
+ * Copyright (C) 2023, Google, Inc.
+ *
+ * Original authors:
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Avi Kivity   <avi@qumranet.com>
+ */
+
+#ifndef __KVM_X86_MMU_SHADOW_MMU_H
+#define __KVM_X86_MMU_SHADOW_MMU_H
+
+#include <linux/kvm_host.h>
+
+#endif /* __KVM_X86_MMU_SHADOW_MMU_H */
-- 
2.39.1.519.gcb327c4b5f-goog

