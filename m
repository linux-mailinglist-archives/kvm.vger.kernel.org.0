Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EE74C529A
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiBZAS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241495AbiBZARz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:55 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A232255A7
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:56 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 62-20020a621541000000b004f110fdb1aeso3962065pfv.13
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eZ6FrXYp5R1CiB/zutWVqNTtHVIMJ9iK/usaw7re+ZM=;
        b=hl4rpFhiL+jXYPutqrx0t6H9bf3KWGfYlj27fcEIS4FHVk2BLJKj160C755dQet0Om
         5wKQ0jzn+T5sVODiQ3ZVUFHquVzV4gTyXE1RAGwfmiNCujdwofwFLe67wnXAwY3ijDky
         6SOhAc6xWzGXY2bLPyVm02FJWPuCr90UPEKlq6cMCQPphEEo9LBJWScK66QVyzou7qc5
         4ZmdsrFTu6j72r1Bz7uS+S46URV1CD9jrUh3nSS5KFhoixty4Wr8AgwFKpu5RV+sqjz+
         u1EMjoVbVh8eUyq40oxulkA2xXnztTkZBRfq7UC5YNTfkYaybbE9PZdge8FPKML8hwGy
         x+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eZ6FrXYp5R1CiB/zutWVqNTtHVIMJ9iK/usaw7re+ZM=;
        b=Xq89hDnph5rSC9OOHSV2UkOdZf9S0bXG2W/sXaW25EPfbaRwTgEgKjctrg1K68Ck5o
         ER2yKka7XKMbgmIdaqG/r2XFxlAuZG/cJ2ouLu2wf4oE4iczw8yFNiqo1o5IAZFgDPHZ
         HPlGUNzLNMSkkGtVTQF9/ivSbrUIIcVkW5OJl8eKE5qQZ16EdrJ/svwDUAVUl9L0FHr/
         ApyLm1t8ccB8tUQBBXPbjHY4hDF33nwvGxr2bJeEJoYZjd3BwNspAhfZRp4/QrnhoxeC
         tjJn1qVElNIiN10olVQ+EAdeelemAUR4bwakbgP4LIfDETajbR+9RsI0k9HXIyAU/7lg
         zOqw==
X-Gm-Message-State: AOAM532ugpXw5rKvkQhrHm/+2ax296RJKihaEiw34rS8fC/RYxgVfSIj
        ehiI23h8/1p/cVPliUFUnD+XysnWUlA=
X-Google-Smtp-Source: ABdhPJwZkbulWxQN1QcjvFOpJ/+q7sB6nKIs0wpPywx0Zluyg3uCsp5kDjezDFiO3Pz0lKzYCwPrRRNdG08=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc42:b0:14f:e6d0:fb7b with SMTP id
 t2-20020a170902bc4200b0014fe6d0fb7bmr9397561plz.127.1645834606838; Fri, 25
 Feb 2022 16:16:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:45 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 27/28] KVM: selftests: Define cpu_relax() helpers for s390
 and x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add cpu_relax() for s390 and x86 for use in arch-agnostic tests.  arm64
already defines its own version.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/s390x/processor.h  | 8 ++++++++
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
index e0e96a5f608c..255c9b990f4c 100644
--- a/tools/testing/selftests/kvm/include/s390x/processor.h
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -5,6 +5,8 @@
 #ifndef SELFTEST_KVM_PROCESSOR_H
 #define SELFTEST_KVM_PROCESSOR_H
 
+#include <linux/compiler.h>
+
 /* Bits in the region/segment table entry */
 #define REGION_ENTRY_ORIGIN	~0xfffUL /* region/segment table origin	   */
 #define REGION_ENTRY_PROTECT	0x200	 /* region protection bit	   */
@@ -19,4 +21,10 @@
 #define PAGE_PROTECT	0x200		/* HW read-only bit  */
 #define PAGE_NOEXEC	0x100		/* HW no-execute bit */
 
+/* Is there a portable way to do this? */
+static inline void cpu_relax(void)
+{
+	barrier();
+}
+
 #endif
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8a470da7b71a..37db341d4cc5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -363,6 +363,11 @@ static inline unsigned long get_xmm(int n)
 	return 0;
 }
 
+static inline void cpu_relax(void)
+{
+	asm volatile("rep; nop" ::: "memory");
+}
+
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
-- 
2.35.1.574.g5d30c73bfb-goog

