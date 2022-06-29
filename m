Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6655F3A8
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiF2C5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiF2C5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:57:35 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1688326D2
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:57:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 15-20020a63040f000000b0040c9f7f2978so7546241pge.12
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=T2Ut47E60SPsqySmwlvuXkyJ5ns3uzJ5H4EjkoDgJ5M=;
        b=MIk8qkfXCELWj5VFiDGeFt9oIlETWkDq8ygR3HPg/GislcyBo4ubFGxylk5eten4pK
         vo9cnZOEUIk+tTl3TlAeCNBFDBTNwnzQphFO2ieqfvEiZvKGQjbNUX9UcyO8JNq/wNnb
         s+aE0S71Ag0wD4VbRlESRb74L0IstkZ4Rpg+0EghGlkOR4CkDw1rk3AJXDx1Y+Ge01L8
         ZcM+x7mgd/JL9cjsWolWC/laOg2/OUBLk/1RBHlTu41B8UdMSWRjANUQwWaqf9WjVpx4
         HXNlzmq6Xrbj0hCc5vz9y19t5+kpIFyPsKp3KtBHHpznJeOynU8Z9GF/W1kJx5K9ws97
         RkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=T2Ut47E60SPsqySmwlvuXkyJ5ns3uzJ5H4EjkoDgJ5M=;
        b=yKNhFyfoTDqZwf355OZ5bGnPaNYoE593Sz8L8lcKCggZdreuZry6LBfWwgQ3YzT+yV
         2CDu8rNMJSIyGcAmkIGtI7fVqsXSoy5IAVXTw7w91XPjpEhxJf8eP8c1yhkHXdHAo6+e
         URCJax/os4sxWDfxo2EIiusWndeefUsq5NyCjXd5JkQaXsPEtEe1tSAvdsP53Ighe3Z7
         bc/cej4404rQl+g+OWeJU2G0p/7OYo5fH/GoCMO4H5Y+CPDunOJBXPSBE5muuo70uCiB
         JBxhuLMdHQpAUMLB6sq1EhaAgKEVPtxsSCdBySjgAujMNg0EsHk6hu2UBJ4jFSB6bNXj
         M+ng==
X-Gm-Message-State: AJIora/ioNGq09oRH4Z5NtSxBhCQux9SQlZS6mGN8BDx7QZTjlZc9Fju
        hFCPkQBYWOjTmN0NmCaxiPTLpbVy7uHnn7crAYTuRpCRo/A3MXmnHihc5lKwx+RbXDH+bhpoaSJ
        F7JOqFnKQZPl75daxpOcIkmDxBeYP85Dp4TZ0Jl2Bo8q2l9lX2K/aTgDyY0srQo4=
X-Google-Smtp-Source: AGRyM1vz3qvKBcSqf1nYMJZgqPaBYmMRoQzS8k5diGDdZL8oZRs3yLgJ/NdMJ1CELWsIZoO8a4hTCMYCTjX9mQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:903:206:b0:16b:a02d:274a with SMTP id
 r6-20020a170903020600b0016ba02d274amr1102012plh.9.1656471453446; Tue, 28 Jun
 2022 19:57:33 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:56:34 -0700
Message-Id: <20220629025634.666085-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer
 expiration test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, lixiao.yang@intel.com,
        nadav.amit@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
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

When the VMX-preemption timer fires between the test for
"vmx_get_test_stage() == 0" and the subsequent rdtsc instruction, the
final VM-entry to finish the guest will inadvertently update
vmx_preemption_timer_expiry_finish.

Move the code to finish the guest until after the calculations
involving vmx_preemption_timer_expiry_finish are done, so that it
doesn't matter if vmx_preemption_timer_expiry_finish is clobbered.

Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: b49a1a6d4e23 ("x86: VMX: Add a VMX-preemption timer expiration test")
---
 x86/vmx_tests.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e7085ea..8a1393668d93 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9194,16 +9194,16 @@ static void vmx_preemption_timer_expiry_test(void)
 	reason = (u32)vmcs_read(EXI_REASON);
 	TEST_ASSERT(reason == VMX_PREEMPT);
 
-	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
-	vmx_set_test_stage(1);
-	enter_guest();
-
 	tsc_deadline = ((vmx_preemption_timer_expiry_start >> misc.pt_bit) <<
 			misc.pt_bit) + (preemption_timer_value << misc.pt_bit);
 
 	report(vmx_preemption_timer_expiry_finish < tsc_deadline,
 	       "Last stored guest TSC (%lu) < TSC deadline (%lu)",
 	       vmx_preemption_timer_expiry_finish, tsc_deadline);
+
+	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmx_set_test_stage(1);
+	enter_guest();
 }
 
 static void vmx_db_test_guest(void)
-- 
2.37.0.rc0.161.g10f37bed90-goog

