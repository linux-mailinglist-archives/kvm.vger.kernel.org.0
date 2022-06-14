Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0754BB66
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357945AbiFNUJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357611AbiFNUJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722EF4F458
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id h6-20020a17090a580600b001eab5988770so2856546pji.8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=K0KRVkUMqr9HilXYEGpWol1qMgJzvxP/fvNXOBy5syI=;
        b=LfG8d16faXS6+zLzbmXubosAUEIUFvF8bXDbPYtOUm9Y+HqjxB9YZTMUGJwf+cV2bG
         t5aVb5T+ahQqimNhTlj+jhunK50HNOq3m7mJ2V9zrl184ByEGKI0HwUbzOnKOSFl5ZbE
         7Y9+fi06/lft1N/mCJBZ89xvjeu2eiWxrwqOVNgmWjqqWz68NIrk16C0dhMCghrmRfLf
         0+sFO/5L+62MMWiUE57UF/w2cpXgwK28fM/JkcPTDDcT99kklLghX4uNFM+XHn6CSXFv
         ywnAFXtccbqKrAvJXL0pVPYZI/tkIQuFxPiBqp9//WpSXfdMwlalA3H4HSHtEBDzQ8N3
         iggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=K0KRVkUMqr9HilXYEGpWol1qMgJzvxP/fvNXOBy5syI=;
        b=a+r3LUt6J/ePi0hWNnaj6BPClbcrsgFjAgtMygkLRqDZx33bvwxrBMY6CwCo4Ufhal
         kgqF3KOJgHFiIk5/1Ud8pMV6JDraaoHzIDzGXO73I6cukSDVLgI/JmuJ09yDMEMkxPIr
         4Im30mddBop/pKypXwQff2BGh0od1CnNbVlbAWSjl2ytTKVl65UEgo5HgiBifqr862Jj
         02NnuXpPdLHnql4NQE87rkgY/7h1pG3z7uLeySz2ULwN4SQoQLeunTXV2haRgrDu7mXP
         E8dtQ3rKLTP3U4dUANCUk4ZxbO67fFC8i3TBV3761vfP0fYhMgwcSbG7fYHUGmgH91OI
         yhpA==
X-Gm-Message-State: AOAM531YAOTVze4d7rD8CrPFTyHK2TefLkXcX2ASXq4bxDM5JIjKQRdo
        MRpoXVUP7gEqT2eNKu0pswvEc5W65CM=
X-Google-Smtp-Source: AGRyM1vleOyhOHbogXs9WGT/bajRXjGNAhfi3rke+40RFJIhC7SDTzq8Q1z6IuDNBNmSfiMWg8T5DlA/HpY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e0cc:b0:167:82d5:4753 with SMTP id
 e12-20020a170902e0cc00b0016782d54753mr5899159pla.138.1655237291812; Tue, 14
 Jun 2022 13:08:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:58 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-34-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 33/42] KVM: selftests: Use this_cpu_has() in CR4/CPUID sync test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use this_cpu_has() to query OSXSAVE from the L1 guest in the CR4=>CPUID
sync test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h       |  3 ---
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     | 14 ++------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index be2ce21926db..f56a3a7a4246 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -158,9 +158,6 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_KVM_HC_MAP_GPA_RANGE	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 16)
 #define X86_FEATURE_KVM_MIGRATION_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 17)
 
-/* CPUID.1.ECX */
-#define CPUID_OSXSAVE		(1ul << 27)
-
 /* Page table bitfield declarations */
 #define PTE_PRESENT_MASK        BIT_ULL(0)
 #define PTE_WRITABLE_MASK       BIT_ULL(1)
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 092fedbe6f52..a310674b6974 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -21,19 +21,9 @@
 
 static inline bool cr4_cpuid_is_sync(void)
 {
-	int func, subfunc;
-	uint32_t eax, ebx, ecx, edx;
-	uint64_t cr4;
+	uint64_t cr4 = get_cr4();
 
-	func = 0x1;
-	subfunc = 0x0;
-	__asm__ __volatile__("cpuid"
-			     : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
-			     : "a"(func), "c"(subfunc));
-
-	cr4 = get_cr4();
-
-	return (!!(ecx & CPUID_OSXSAVE)) == (!!(cr4 & X86_CR4_OSXSAVE));
+	return (this_cpu_has(X86_FEATURE_OSXSAVE) == !!(cr4 & X86_CR4_OSXSAVE));
 }
 
 static void guest_code(void)
-- 
2.36.1.476.g0c4daa206d-goog

