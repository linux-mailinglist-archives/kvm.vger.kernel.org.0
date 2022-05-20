Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12B652F63A
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiETXdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbiETXdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C100E199B36
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t14-20020a1709028c8e00b0015cf7e541feso4722922plo.1
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z6u374eRRq3ZxgbCbMl6Db4qdzVQrIIZZTwWKsQlAh0=;
        b=EpLBXxSVK5SsYvVke0dDLPW/5dG97b1hFVNLmsBv60R/qGZ8i7uy5qwB6sSZIxwnEX
         tyRYZ4hVB/WmU95Dp5DZHrUw0PZBXsD+VfqbKXal/QOV4v0K/Vg7hrXhGksHfr/SLl/z
         N0q4ZWZs6Lpje0gggD8hRkxWxeRPf2hXmt03cOwnFeWPNjual/34bcdAvCQ3SfmHO9mP
         ayRsEsMCVWx28k0e799cOkMODeO7mBub09RpA+S4RFsqzezgRdqTQQGwwp7yuhWxED8L
         FBTgu50Yanob+v1PCcn3HCFhUDQgMLZkhVNgNEW3sXYitKLwX1L9Z/i+9hqhPzp4Tlx0
         PExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z6u374eRRq3ZxgbCbMl6Db4qdzVQrIIZZTwWKsQlAh0=;
        b=OJcgrh08vHVKnPURadOSPSxCcnzNIePjMmQxsdqDJK1McRDsRsi61BEV2Pg++C9lDa
         HiHopRfz+hyaPuzZhM7CeAeI214DjIp5AqNWngO4Xz8zFNqhU/e4OWQkZe+rvTcNpTd8
         o9d4P+qCHKIEf2eAl3LeOs93QL0bsCo1+RHJf/ThVqaLl0xbomzGqfy0Xj/GUCLHiPZQ
         nHtT7/xm87pCgOWtav9QzeU0hktj3Su/DcJ47oI4B2sPdQJoJMxrrjJD9pXrlmEnOW+i
         UxpfwlMEi+/xtV/Yni420ynnYnPH5AwGDEYq98inZRqYhuUV6pqpUNirWaVpZgD/n5ru
         rUhw==
X-Gm-Message-State: AOAM530NxYF+3xHqjDz6p5UpOD/L6qS5z5KrVgc6E2R39DoXg1U9oxyr
        n6p44gJHTj8kyw9JnFGeD8RF6sLLZPjF2g==
X-Google-Smtp-Source: ABdhPJzPChwAYoAZiyethJ+IW4Gzdj9GbVV2AS0eZ6sNmy9/Ngq+vEleLF9jMBF4pgGMIxhYLfzYtrjfain+5w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:dad1:b0:161:9abb:fb75 with SMTP
 id q17-20020a170902dad100b001619abbfb75mr11902065plx.135.1653089582234; Fri,
 20 May 2022 16:33:02 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:43 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 05/11] KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

This is a VMX-related macro so move it to vmx.h. While here, open code
the mask like the rest of the VMX bitmask macros.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 3 ---
 tools/testing/selftests/kvm/include/x86_64/vmx.h       | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 434a4f60f4d9..04f1d540bcb2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -494,9 +494,6 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
-/* VMX_EPT_VPID_CAP bits */
-#define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
-
 #define XSTATE_XTILE_CFG_BIT		17
 #define XSTATE_XTILE_DATA_BIT		18
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..3b1794baa97c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -96,6 +96,8 @@
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 
+#define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
+
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
 #define EXIT_REASON_EXCEPTION_NMI	0
 #define EXIT_REASON_EXTERNAL_INTERRUPT	1
-- 
2.36.1.124.g0e6072fb45-goog

