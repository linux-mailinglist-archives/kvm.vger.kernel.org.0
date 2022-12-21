Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B358F65387F
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiLUWY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiLUWYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:24 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D402715F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z13-20020aa79f8d000000b00576b614b7d2so9181083pfr.14
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aKlgYMYIrlGLbMYP963Rt32Noqo2pCtoxK8D34uyWJ4=;
        b=PWqhNCgkLNsL4LTq6n3P2N/wL2IC5fNtKlHcljZPjv1KMJIXNnu+jM/wiOaUfvSQzQ
         sqxmogZSTOlLja/osRpS7Ow8EfzSUYnreoaLWkkFdbixfiBmjccx0+KswydFi9OPd7G+
         ufafOm2aNUYdbkAWCv2FGT5m/chD2Utam3lq9+XJO5/Q1b+hNSmrMeQga388z7ynT7v8
         NX7DKNfpSeQMnVeRYugzoXNHWHSvxsw+I6ma6X+E6cBtDFf2MAyzy1YNcTGk8tmCzLNd
         ney/iJw+QhWYPcoct/qe9KDj8ngJbHLXsqU23YGjejcPJ/Eqxv/IM84tu17ag52e0e8x
         5slQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aKlgYMYIrlGLbMYP963Rt32Noqo2pCtoxK8D34uyWJ4=;
        b=Vc/LBMPTGvxZ+dMNqQ5LbsTt6i8ZjBuLJHqfbFvVu18xWlcJDvYTAMZg+HzOLaWLZ8
         ffupc6u2bmzUrwlaHah0XFxaduKniPw8UCLdFWnjyCYillAhCDjfSXxLc+gtBrcTIbkA
         QpbyeuF02nJnGNwES+I1do8qePlab38YB5/b1gOWGt2aXiqXrwELd2ClBEOprILYPKsi
         kL8LrGCCKmlCB8Gn9GwtuSr0My3lXEChktWuHqv6dabj2un/8Ot0wPxkw/liKnp1wk9O
         SU58DYXlQgVwdCAWjoJC6jwfjRJhv9gUEyJmVKF+qyVWDipw6Iskb6C6h/lt/1ZIDELT
         KfTQ==
X-Gm-Message-State: AFqh2kqDH0DPwzhckIS9wIQY/I4PiQ/1Rymk8LJCmE8zvCGHtza1zruP
        VrcfSQccQyd4pLh9gWtuMg0EP9BJ4z/K
X-Google-Smtp-Source: AMrXdXtezmpm9/qcQiNZToPZHhHL5FScFsYx6ESyDed8IH5dss9kLF5PXnxx3ct4s9IE+lK/su3Wnrko61my
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:6845:b0:219:2bc2:f71e with SMTP id
 e5-20020a17090a684500b002192bc2f71emr274766pjm.142.1671661463529; Wed, 21 Dec
 2022 14:24:23 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:05 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-2-bgardon@google.com>
Subject: [RFC 01/14] KVM: x86/MMU: Add shadow_mmu.(c|h)
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
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
 arch/x86/kvm/mmu/shadow_mmu.c | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h |  8 ++++++++
 4 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.c
 create mode 100644 arch/x86/kvm/mmu/shadow_mmu.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..d6e94660b006 100644
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
index 4736d7849c60..07b99a7ce830 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -20,6 +20,7 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "tdp_mmu.h"
+#include "shadow_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "smm.h"
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
new file mode 100644
index 000000000000..7bce5ec52b2e
--- /dev/null
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM Shadow MMU
+ *
+ * This file implements the Shadow MMU: the KVM MMU implementation which has
+ * developed organically from hardware which did not have second level paging,
+ * and so used "shadow paging" to virtualize guest memory. The Shadow MMU is
+ * an alternative to the TDP MMU which only supports hardware with Two
+ * Dimentional Paging. (e.g. EPT on Intel or NPT on AMD CPUs.) Note that the
+ * Shadow MMU also supports TDP, it's just less scalable. The Shadow and TDP
+ * MMUs can cooperate to support nested virtualization on hardware with TDP.
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
index 000000000000..719b10f6c403
--- /dev/null
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __KVM_X86_MMU_SHADOW_MMU_H
+#define __KVM_X86_MMU_SHADOW_MMU_H
+
+#include <linux/kvm_host.h>
+
+#endif /* __KVM_X86_MMU_SHADOW_MMU_H */
-- 
2.39.0.314.g84b9a713c41-goog

