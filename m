Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0D652F564
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353790AbiETV5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353796AbiETV5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A01A04BA
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902c2c400b0015f16fb4a54so4635904pla.22
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z6u374eRRq3ZxgbCbMl6Db4qdzVQrIIZZTwWKsQlAh0=;
        b=AH5h//rnKEWJfL9N5Ss62V7I6gwUFM1ui3Ku+hjiAVH40L06Hh6/2stcx26oHWHFJg
         zolFFkb3/3b2eiTHBDTUVD8/oAkUD+iCNVg+4Wu650U7IPaAoMSzIhaYsUfmFaIkxPSy
         F2x+m9Afyb++ykaotv6HoGEpw6gBU0JuVgI7CP+wTNUDVd1mGUg8FNMKmvjqVBsq8z/K
         V7OC2dUwGr9iY02lQU7jj7t2aqvvlTTRE37sYhN4v/Ja1qc+1fWTWqzVTtUm24hRs7O7
         iFZUvDSgXSF7id75QGow974OycvFOnNHLsySzdkjADLr7MndusJ90acGaYWCIIwSbdVp
         Lkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z6u374eRRq3ZxgbCbMl6Db4qdzVQrIIZZTwWKsQlAh0=;
        b=5CrRvzMuvWexzEIwHon8ZtuMgr7iSBSstVa75sBX3gT2nXsZSLIZr29/oPeiKG+Rzx
         r5kgxskleAYC+ND6hyKW6Tb1mg8r4c5s6XIafvyetl8PgTxtvMSnzehwdXd2MsboU9uf
         okjOmNN3EV9L0lqYmYHRhEWhLG51EPG8jQdz7MekALrlEoqLEFCnalIGiZBKiyS60NgC
         oQxemSvlnbO/8EuUVU7k/axw7YiBtuvTG7/W1JQ2qduxLnPPn1Za7rx1FbNPRzUk7ZTi
         gj1jbo8vlD3OHj4ZF5pLIcglgpfP8iCssxYcw/Yr9ZkZ5S+a2gMh7cubymYr4xxTPQ5F
         3qVQ==
X-Gm-Message-State: AOAM532TfLd/nVGJtvq2ML+ItfN18DnDokGZF/g8qMMIpgqOCbQly07a
        xr7xchS+SE51yLlydl5giETAkQeKZxP0bw==
X-Google-Smtp-Source: ABdhPJxQxP7pYHQ6TpYpB4cct2qG9BGZTYmLGpAeGvc9Ahjl8dNodSPhFEACKJn/oh1FAh8tkT4MunjcBNO/Tg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a385:b0:1cb:bfa8:ae01 with SMTP
 id x5-20020a17090aa38500b001cbbfa8ae01mr12973233pjp.116.1653083855177; Fri,
 20 May 2022 14:57:35 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:18 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 05/10] KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
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

