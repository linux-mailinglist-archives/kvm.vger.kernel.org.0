Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D856F68CB05
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjBGAWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjBGAWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:22:01 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33E730B31
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:22:00 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id ju17-20020a170903429100b00198f13d11e8so4063074plb.8
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 16:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nzcAfp64RgqcLL8tXedEG2XEeGgWNFMNxiM0uRzJp4w=;
        b=Q6qEG83GMi8v8ZeZsxpbkqifoEW4rwCPZIInoKHwi4YthNxXboTG0Fhk1oeHAIthAg
         7LMmg45BVvXqMMHjAtXuEyv9eTpx5EBX8yA7Q+UmY6a5PivElMs8Gv7Y+BrwetMI1E3z
         Oh+kaNm6/qiIeIzO6P+Vydkj6iPPzLfXfgCMUo2wdMx/9ju+/1mTcSt8D1H0wA06VQcS
         uPnkSfeVdOdDPQTX5uiLDHXqIW3ABwVMPjJA1aUyh4mRlShQZVmAmbDE0n+YcKP7o6tb
         vrYzSG/HKcN4jMGJ0vJBGK2g+Z/dM6DQvrPg9dy5t2OgPm28bIGfZRZI71T1yQ4iKsZs
         bFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzcAfp64RgqcLL8tXedEG2XEeGgWNFMNxiM0uRzJp4w=;
        b=2JexeAzlS9ak08nGN8qjnnNFNSu1ghnt9hZXol3IY9sZze7fxd7mmxsZzqz8TldB/C
         bzbhjBUkqafb8iKApZY+T1UjNp9CHILvkiOztc5WtLhaLDbcSttJZMQWo3Hqx/GurFa9
         TQknrWSTLnqxuw4y35nlZs+LvNDrzkApCJlGZjr5+BR8SUyVvuhlIva0mwsAvAy2RWps
         w49LWCdqpFiku2GuUk9l6BZrnzGiuKAg2XPC1nQ+Bxniizm7O5ClXI0d2cePR9W9U7pK
         MWXn9WOMMt+4R2pQ8BVESCKBB7n3fpxFn/umKevPZEdCzyGPFIQpoIaspS//uijKyuYO
         xxyg==
X-Gm-Message-State: AO0yUKVD5xz3b26a/SNzX28CDE9BmDZKLoxV3KFKAos8ts3Ew8KOOk5u
        dUCywCT7u68onnuqPttfvUfXzHUSGuE=
X-Google-Smtp-Source: AK7set/TtEmNMITnoUdIjvea4mIwpEfLF4mEaqloWfuQfGau/ehx6R7oR9q8c2pwHigEZiZ46oaqcc1nez0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1a4a:0:b0:58d:bb58:ac78 with SMTP id
 a71-20020a621a4a000000b0058dbb58ac78mr275531pfa.48.1675729320237; Mon, 06 Feb
 2023 16:22:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Feb 2023 00:21:54 +0000
In-Reply-To: <20230207002156.521736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230207002156.521736-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207002156.521736-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: SVM: Fix a benign off-by-one bug in AVIC physical
 table mask
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
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

Define the "physical table max index mask" as bits 8:0, not 9:0.  x2AVIC
currently supports a max of 512 entries, i.e. the max index is 511, and
the inputs to GENMASK_ULL() are inclusive.  The bug is benign as bit 9 is
reserved and never set by KVM, i.e. KVM is just clearing bits that are
guaranteed to be zero.

Note, as of this writing, APM "Rev. 3.39-October 2022" incorrectly states
that bits 11:8 are reserved in Table B-1. VMCB Layout, Control Area.  I.e.
that table wasn't updated when x2AVIC support was added.

Opportunistically fix the comment for the max AVIC ID to align with the
code, and clean up comment formatting too.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cb1ee53ad3b1..770dcf75eaa9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -261,20 +261,22 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
 
 /*
- * For AVIC, the max index allowed for physical APIC ID
- * table is 0xff (255).
+ * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
+ * 0xff is a broadcast to all CPUs, i.e. can't be targeted individually.
  */
 #define AVIC_MAX_PHYSICAL_ID		0XFEULL
 
 /*
- * For x2AVIC, the max index allowed for physical APIC ID
- * table is 0x1ff (511).
+ * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
+static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-- 
2.39.1.519.gcb327c4b5f-goog

