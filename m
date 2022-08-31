Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015D65A72BA
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiHaAhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiHaAg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C5DA98F1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q128-20020a632a86000000b0042fadb61e4aso1306424pgq.3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=4TG9Pw7tLSyGALSM6JTWSHx8b3lurYVthYrmdEh1p4g=;
        b=BJ9OXvL27Yj6rdDyCiAw19+HrndK/auzwWJGMQw7nqbI+yAeXdHOSXXSh1EfNSX0bs
         GrBeIsk/6KGSGmQGSosFyUcK8FQMUORi8sx6axKAT0TEQcAqXBgm/SNdLqstO2E+U+zD
         Wz/J4KL/BYF7uFXu/tIRMYoe5cF/51L5Gz2bZRRePjmhZV/gilJwvDoePyIiK9GNPXNW
         XjqArH6J5opNkN7KUq+47sVH/3YH7Iaz95Rzjb6T8BSzTZn7+P7Wm+FZx5+FU5uBAMRp
         0E6QpDIyq0qpLQ1nFP9sJMb99YUAePRQtj5gamUj/inEo4QVVSenCoPu1Wie4AodG6hX
         xBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=4TG9Pw7tLSyGALSM6JTWSHx8b3lurYVthYrmdEh1p4g=;
        b=64CkNuZlRigKR2WaxjllhKqOB6z9IkC3bbHL04SDRMqbA4/fIKvC5GCJhfc5l7PX3c
         wZnHXEWqul39LRni8bn7YALLaf1hEr2F+qI7kLlBMRzJGUli4fIxqJrNz4onhKV9rHlD
         2JHwZtPNHjknJZ8PHsA99Xka6z5DEBAz+9re0olmqtbeCs3liMbDV8lP93mV8HXj5URB
         iS6JEyNVPq6StP0/EOPGsxAnzD8lBPVbw/EK/11yj6AGUNZ9T4GKo5YZiUU03G/aGufu
         MLfbG8ShnO5UVcSuCKLnZOR+bM8jyJ77UkgZtd07kyHaD6LfpfJHb9RNXcpNYuYnQWV+
         9qYw==
X-Gm-Message-State: ACgBeo3cBwIBUUYX+gB8lQrIa4mUJ6x9ma/2v6eGxamCW27JoB9tAVKZ
        4lfJvF3OcIn16Rz1PJJmRMYL5FfJyD0=
X-Google-Smtp-Source: AA6agR41WRDmT9Kt+fXLTMjq+WmuvHa/9yx5PXfX9AgYEa/iF8hdt5K8Sq67P15XocA2UjnehilOpHT/B8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7b95:b0:172:9dc3:6c12 with SMTP id
 w21-20020a1709027b9500b001729dc36c12mr23747496pll.94.1661906124977; Tue, 30
 Aug 2022 17:35:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:56 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-10-seanjc@google.com>
Subject: [PATCH 09/19] KVM: SVM: Drop duplicate calcuation of AVIC/x2AVIC
 "logical index"
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the duplicate calculation of the logical "index", which ends up
being the same for x2APIC vs. xAPIC: cluster + bit number.

Note, the existing code is a mess and uses ffs(), which is 1-based, and
__ffs(), which is 0-based, for the exact same calculation, i.e. replacing
"ffs(bitmap) - 1" with "__ffs(bitmap)" is intentional.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8c9cad96008e..05a1cde8175c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -407,12 +407,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
 		} else {
 			/*
-			 * For x2APIC logical mode, cannot leverage the index.
-			 * Instead, calculate physical ID from logical ID in ICRH.
+			 * For x2APIC, the logical APIC ID is a read-only value
+			 * that is derived from the x2APIC ID, thus the x2APIC
+			 * ID can be found by reversing the calculation (done
+			 * above).  Note, bits 31:20 of the x2APIC ID are not
+			 * propagated to the logical ID, but KVM limits the
+			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
 			 */
-			int apic = ffs(bitmap) - 1;
-
-			l1_physical_id = cluster + apic;
+			l1_physical_id = logid_index;
 		}
 	}
 
-- 
2.37.2.672.g94769d06f0-goog

