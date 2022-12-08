Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7A6476AE
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiLHTkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiLHTkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE088389F1
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso540748ybx.19
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBAoBS5l4frpeZWkoJY/UpoQSbDyst8wBhQ9eKXZWXc=;
        b=nlEUPxR6NdyPJq+SxFDJtYRvDL+tSADMT14c6WeSKQQEUdTazqiEtfTEk+SgwjuGEq
         FmaRagIrALcak/FA6XBnlNgJ1op1uF68f9N8DQlFMf5Lg2V/XHFSd+dxvK4sOLW7bEkP
         RGyMlm7idURAZy4kLXqSJMwKdSUs8Pvjw42c4F3o6sWDVgr7R6EWxFOWpXNGMLR+X4qI
         871FbXvdNcwcg/9Wsr6QYxmjjpELz0YhLIMlRDhO3bl+KizlZ1eAChWn2q1SbXmr+KvW
         0p6sqHH9DhxqHphJvurk7B3DlzGH0FBewCHxofIksuZgZ1LvKdA0uEEqGlD800vqy01i
         +GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBAoBS5l4frpeZWkoJY/UpoQSbDyst8wBhQ9eKXZWXc=;
        b=0ZbtFTNHVbq7mEYLEhyxm41eDceQqxwgwtBxW25JKGmylRH2wnnEWkSBaVmzcpdLiP
         GwCuefOzAp8JF7siliMQgdRaeEwJcpRbHvDx3Y7t1drHtOt6HPShcqQc95BWtieZEDmR
         vYLkHUR6QUuBPnfY0k6pJAVB75ydRDP26SxSv3EhOts3N9kt18hXJX4We1qo/NINj+tf
         BLWQlYQFVCYfiBlvfSj2WamaWbsMUJeLY2ORkYilrOBZy7kajCWRyeRbMesHqICJjUqS
         /99mxukOVXUZAEnraQqsDQBZKGvwBm5ebajURBNuOp5lzmgrLMEpQe6S92/5kz9zbQCz
         /3EQ==
X-Gm-Message-State: ANoB5pnZ4c83qKB+38osEbewbAGr8on9Gm1HBaDQ0RiP3lU58bY/1q6e
        aoySLdrw/dcqmYRrMlas3Orq88iiffQ+fQ==
X-Google-Smtp-Source: AA0mqf5xyrJDk8LkqxteQO3uKW9sySGhyFdSCZp1IMvsR62i1Fel4cZTd1/kwLAP2Vd6/CjzjTgnduujan+3NQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d34d:0:b0:6fa:7b0a:3eed with SMTP id
 e74-20020a25d34d000000b006fa7b0a3eedmr35292093ybf.83.1670528393951; Thu, 08
 Dec 2022 11:39:53 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:48 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-29-dmatlack@google.com>
Subject: [RFC PATCH 28/37] KVM: MMU: Stub out tracepoints on non-x86 architectures
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create stub tracepoints outside of x86. The KVM MMU tracepoints can be
moved to common code, but will be deferred to a future commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 include/kvm/mmutrace.h     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 include/kvm/mmutrace.h

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 891877a6fb78..72746b645e99 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,12 +2,12 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "mmutrace.h"
 #include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
 
 #include <kvm/tdp_pgtable.h>
+#include <kvm/mmutrace.h>
 
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
diff --git a/include/kvm/mmutrace.h b/include/kvm/mmutrace.h
new file mode 100644
index 000000000000..e95a3cb47479
--- /dev/null
+++ b/include/kvm/mmutrace.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_KVM_MMUTRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_MMUTRACE_H
+
+#ifdef CONFIG_X86
+#include "../../arch/x86/kvm/mmu/mmutrace.h"
+#else
+#define trace_mark_mmio_spte(...)		do {} while (0)
+#define trace_kvm_mmu_get_page(...)		do {} while (0)
+#define trace_kvm_mmu_prepare_zap_page(...)	do {} while (0)
+#define trace_kvm_mmu_set_spte(...)		do {} while (0)
+#define trace_kvm_mmu_spte_requested(...)	do {} while (0)
+#define trace_kvm_mmu_split_huge_page(...)	do {} while (0)
+#define trace_kvm_tdp_mmu_spte_changed(...)	do {} while (0)
+#endif
+
+#endif /* _TRACE_KVM_MMUTRACE_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

