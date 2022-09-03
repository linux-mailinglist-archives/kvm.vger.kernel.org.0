Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEEB5ABBA6
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiICAXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiICAXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF91FF63E2
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:14 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a19-20020aa780d3000000b0052bccd363f8so1726818pfn.22
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=gdqi7/sisgOJWdb3UjZLC+OFglcO8pjrSzcL6Yf8oaE=;
        b=qdZ1uwpywN2x8XHJ4BBaMqpMM/TLq88CuwaWUgF7yRNgkIc2u3iavToNk3hjy/g1M1
         g38i6uQLHl/N/phr+D80midzVaIBr2r5vezSxLvVEM1lKptWwnyLluSqYep03gNZURsu
         wWDHbjf241306jJL9GO7WJf34Cbu5X75AdfwLc3eHznK7iRuheBqg0S6Yk+q/gCL+rsh
         b6Kf6ZyDhrzdfl2V8FXG90fVgQNcMZ4NnLz586ri74P17Un2luWxvVBcuGGwNTwv1N9K
         mC0CpD9RqNMBMZtS55NVq3lsGeL23Z4jt/5q26+840w2d3v1S0Su1pE7CkXaidk3r7Pr
         1qbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=gdqi7/sisgOJWdb3UjZLC+OFglcO8pjrSzcL6Yf8oaE=;
        b=4eo3A+c0D/J9njOeIqWCvbbBzfjmRnKSSIh9IopBdJs7fPcHybCnou5z0HzjLUdq3G
         bGVHAa63Owv37tNcsTsbT39p3GRyl08+YcgDZIMOZMGDm5FcKlWNdk5D8yeRaLyUnLLk
         TxwiclJ4/nEXFKFn2UuayDd3S/TD8/WH3k2WqI7ig+wjmMn0plDOTBDlOFAxk93QKRoQ
         uuaWafLbmVdaSDaUxE6dv1vTV9569cyES+EqWZu0MCS1XFaQ/UL+gyGpPY5qTHhh0hwN
         qnJxu3L55GaWyj8JMovf+o65vEzIoM6J7MIWPvouRPH/zC06mIDYoewn8YjcnbeWiNsC
         AsAw==
X-Gm-Message-State: ACgBeo3zRjmwkBLMXeQjuJ5ITL0DwOlhop9Wk06ZEj5vRIA8n6lolTXS
        WLX9x4EVa0o3ilb6iJrYg+RzzM/7+C4=
X-Google-Smtp-Source: AA6agR6RB/BOIiDbjdEpM8Dns12QouiSyi5WgPSKjeGtgEuZRQsP8v24+Sf8m5p4+sj444ZQ5n6F01wjdkw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da86:b0:174:cbcf:5f98 with SMTP id
 j6-20020a170902da8600b00174cbcf5f98mr26500000plx.49.1662164594392; Fri, 02
 Sep 2022 17:23:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:40 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-10-seanjc@google.com>
Subject: [PATCH v2 09/23] Revert "KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Due to a likely mismerge of patches, KVM ended up with a superfluous
commit to "enable" AVIC's fast path for x2AVIC mode.  Even worse, the
superfluous commit has several bugs and creates a nasty local shadow
variable.

Rather than fix the bugs piece-by-piece[*] to achieve the same end
result, revert the patch wholesale.

Opportunistically add a comment documenting the x2AVIC dependencies.

This reverts commit 8c9e639da435874fb845c4d296ce55664071ea7a.

[*] https://lore.kernel.org/all/YxEP7ZBRIuFWhnYJ@google.com

Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 163edc42f979..8259a64c99d6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -405,7 +405,17 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		logid_index = cluster + __ffs(bitmap);
 
-		if (!apic_x2apic_mode(source)) {
+		if (apic_x2apic_mode(source)) {
+			/*
+			 * For x2APIC, the logical APIC ID is a read-only value
+			 * that is derived from the x2APIC ID, thus the x2APIC
+			 * ID can be found by reversing the calculation (done
+			 * above).  Note, bits 31:20 of the x2APIC ID are not
+			 * propagated to the logical ID, but KVM limits the
+			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
+			 */
+			l1_physical_id = logid_index;
+		} else {
 			u32 *avic_logical_id_table =
 				page_address(kvm_svm->avic_logical_id_table_page);
 
@@ -420,23 +430,6 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 			l1_physical_id = logid_entry &
 					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
-		} else {
-			/*
-			 * For x2APIC logical mode, cannot leverage the index.
-			 * Instead, calculate physical ID from logical ID in ICRH.
-			 */
-			int cluster = (icrh & 0xffff0000) >> 16;
-			int apic = ffs(icrh & 0xffff) - 1;
-
-			/*
-			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
-			 * contains anything but a single bit, we cannot use the
-			 * fast path, because it is limited to a single vCPU.
-			 */
-			if (apic < 0 || icrh != (1 << apic))
-				return -EINVAL;
-
-			l1_physical_id = (cluster << 4) + apic;
 		}
 	}
 
-- 
2.37.2.789.g6183377224-goog

