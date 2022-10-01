Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC65F17D2
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiJABBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiJABAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA9276762
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s16-20020a170902ea1000b00176cf52a348so4224452plg.3
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=dFvueQwazR7qcZPfUIQimBC+x3rQLHZMrcIkKg64ifQ=;
        b=EpK0ALenm4zbHpOSA24Pi1/jyH+cK1w2xDgB8+8UDnsHC30boFQKR5lHjpQI65qmEp
         4yrKvTH9N0rjbQC0cfCsK288JroxVHupqkSDa9NoyYP77yu4I/3n2r302uuFyFiFjWch
         5E5ALuMZRFhuBXbT08VEbhNwsnejhpnyQGPViDE0+/YuNT9KdYI8CnCHLu6dh4GcS8xR
         Fx5kTEZM6dQs+DZBlQ+JtTjHIBwTBE5wAZu02RrrmHlzYZ6ZyRMXhZ4c8kdu88MtOEQr
         UyBApkdkfnKok5tYqiAvZ59B/Mfhdltpzuoo9WLcMPJQcM3lZCNIQ16qt7AqZBPi81Ht
         WpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=dFvueQwazR7qcZPfUIQimBC+x3rQLHZMrcIkKg64ifQ=;
        b=WQGJeBJxpZk5oyoX/mZU2nDIOZQClOT3xv0jV/yc7q/FUvbromkSEhUYv4O41nRCUo
         aGJwTP+borljCwhH0+RSXx8jQH+4vmVi6K12bEkRtHw+jolVz3oMqh7pB8CXgbxRyyBo
         1CuiXk+t1Zs7hclSLA0dueTSJewt0whZtdVXg7t01uLMSxrU6kePxNX3uTFC5ni5xm95
         4U67q/7njIwVHFRyssj3c6rTSDHOWZGtgJcTKnLQu7Q7g5jQrB2ESuzCAfHpfXcKQ4wv
         ptrL7AQ0c7P7pW6EfVgvn5g/vTL2d2q0NLlCvi5JNKLvstf0jBue6fdDMbQELvQhetFQ
         aH0g==
X-Gm-Message-State: ACrzQf1oRmQNT1s7/IO5Rxfg2xc/PfKZII+pqa9xpfE2P1SCt3Bh9NBu
        UIP/V1Ueyp63ZBy/k1UC0bTs/nuUDU0=
X-Google-Smtp-Source: AMsMyM7HbBoWFKSA1thkQrOuQSvSNO1SpJDcXbx3J+FoPh5Xuv4GZ8HJM5KW5zk/CDlvfiinmdBqAG+fTy0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c9cc:b0:17a:a81:2a8c with SMTP id
 q12-20020a170902c9cc00b0017a0a812a8cmr11487126pld.6.1664585984328; Fri, 30
 Sep 2022 17:59:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:58 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-16-seanjc@google.com>
Subject: [PATCH v4 15/32] Revert "KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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
index e35e9363e7ff..605c36569ddf 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -378,7 +378,17 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
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
 
@@ -393,23 +403,6 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
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
2.38.0.rc1.362.ged0d419d3c-goog

