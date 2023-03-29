Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742E26CD802
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjC2K6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 06:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjC2K6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 06:58:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646AB40EC
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 03:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680087434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7gh6XFwu5hMvVOxYYNwtrZsfvB+xr8aqEPmgKL84ru4=;
        b=a1cAU0+07b4EvLZ/q1D7glLj8E+EFLKfPFtx4Ih8YkP1oqIaoPXw03NjLz8uKubegQSuf7
        kp+bPvw64UuinWjQedSwXNLItlMY9Zm4bpOGpu9bMwlVEyEveEhBLa7EhrltUtYLoSJTI3
        ZqFOS5C9idthWcZuViKM7B9l+uZoKxY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-nR94zKcoNz-ZEq-ipski8Q-1; Wed, 29 Mar 2023 06:57:12 -0400
X-MC-Unique: nR94zKcoNz-ZEq-ipski8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F53A1C0758A
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 10:57:12 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DCB6C15BA0;
        Wed, 29 Mar 2023 10:57:11 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86/syscall: Add suffix to "sysret" to silence an assembler warning
Date:   Wed, 29 Mar 2023 12:57:10 +0200
Message-Id: <20230329105710.57968-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The assembler in Fedora 37 complains:

 x86/syscall.c: Assembler messages:
 x86/syscall.c:93: Warning: no instruction mnemonic suffix given and no
  register operands; using default for `sysret'

Add the "l" suffix here to make it silent.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/syscall.c b/x86/syscall.c
index b0df0720..402d3973 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -90,7 +90,7 @@ static void test_syscall_tf(void)
     asm volatile("  push %%rbp\n"
                  "  mov %%rsp, (%%rax)\n"  // stack pointer for exception handler
                  "  pushf; pop %%rax\n"   // expected by syscall32_target
-                 "  sysret\n"
+                 "  sysretl\n"
                  "back_to_test:\n"
                  "  pop %%rbp"
                  : [sysret_target] "+c"(rcx), [sp0] "+a" (rax) :
-- 
2.31.1

