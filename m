Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3563DCC6
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 19:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiK3SM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 13:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiK3SMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 13:12:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA74683E93
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 10:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669831912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=B7880sx1PBKIRMoPqg1DQCmkSSWjOmoGVrCc4UdhdjQ=;
        b=MWZxVgIQ0KDCTdxS6i9Q43UFf4XnIXizqgc+9cpYIXfovv0X3umMU5RgBqpXalcq5kJv6R
        abb/9Vb65N+ik7M1QaSHHqk37+KpNAmdFY4Dy1pSpUuhVPW589WqYYtotoewfZRG6llvIv
        cKACtvlVX1dGkL8ZEvTD/PiKNpg8Kvo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-ru1VOQKMNS2NUueERxvF0A-1; Wed, 30 Nov 2022 13:11:48 -0500
X-MC-Unique: ru1VOQKMNS2NUueERxvF0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC811857F90;
        Wed, 30 Nov 2022 18:11:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF82C40C6EC4;
        Wed, 30 Nov 2022 18:11:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: selftests: restore special vmmcall code layout needed by the harness
Date:   Wed, 30 Nov 2022 13:11:47 -0500
Message-Id: <20221130181147.9911-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values
in vmmcall()/vmcall()", 2022-11-21) broke the svm_nested_soft_inject_test
because it placed a "pop rbp" instruction after vmmcall.  While this is
correct and mimics what is done in the VMX case, this particular test
expects a ud2 instruction right after the vmmcall, so that it can skip
over it in the L1 part of the test.

Inline a suitably-modified version of vmmcall() to restore the
functionality of the test.

Fixes: 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()"
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../kvm/x86_64/svm_nested_soft_inject_test.c        | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index e497ace629c1..b34980d45648 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -41,8 +41,17 @@ static void guest_int_handler(struct ex_regs *regs)
 static void l2_guest_code_int(void)
 {
 	GUEST_ASSERT_1(int_fired == 1, int_fired);
-	vmmcall();
-	ud2();
+
+	/*
+         * Same as the vmmcall() function, but with a ud2 sneaked after the
+         * vmmcall.  The caller injects an exception with the return address
+         * increased by 2, so the "pop rbp" must be after the ud2 and we cannot
+	 * use vmmcall() directly.
+         */
+	__asm__ __volatile__("push %%rbp; vmmcall; ud2; pop %%rbp"
+                             : : "a"(0xdeadbeef), "c"(0xbeefdead)
+                             : "rbx", "rdx", "rsi", "rdi", "r8", "r9",
+                               "r10", "r11", "r12", "r13", "r14", "r15");
 
 	GUEST_ASSERT_1(bp_fired == 1, bp_fired);
 	hlt();
-- 
2.31.1

