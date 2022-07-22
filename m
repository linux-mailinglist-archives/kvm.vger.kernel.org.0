Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE157EA25
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbiGVXDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiGVXDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:03:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BAF8C774
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 81-20020a630054000000b0041978b2aa9eso2911991pga.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eFGhzQ9ieMwuMtkU6aZcvdfyIrCCb4Zx8OPekzscmEA=;
        b=Rj7cNuRUCpucaVioPmXIiaEJWvYU48FgfQkcqWs9BdTDYt6d2xNZVgJ8i05utO5yBA
         ZqMtib1JRFofx7GuAYB0jClC6Z/GPrAXxXWySG4lG13dtHH0IPj1LlXEUQfm5j160iXS
         oNDnAdmcLQHunEE4rblSfzNusIGuJJUplpLPYBgPrLuNss0LZFpEk7mHbkYrpzQLn65F
         yqi5Icj2pEBTjOTFIsLYXrl8+a46/LOnPDZr/Pt5fOYRNsd+iVCQQNdNPQAxrV0u9EON
         L2Mt20reNxYUDOMIE9FjYFFrCRhKPuHXfbEEZ1HSRskhR5YDguJUb+SR+9FJ6Xo0lbPw
         p8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eFGhzQ9ieMwuMtkU6aZcvdfyIrCCb4Zx8OPekzscmEA=;
        b=mz34MYNvSiIW907iioBqk60Oag591xvi2r/nSTaey+62pUzlhvQXqLsH/ypA62jrUv
         i4BIiAjaRbCsKL9knSCXd2uAdv9Xjq2VEn+rQO8k3J/TWtq1LivzlK23Zba53QObFLop
         UnWguR4ozXcoHvHMj9xslKWP/5mauzwU9MqZDXGLG5VprqvUhIAhHseM43AdlbLC8UO7
         DSemBi1q9bjlFoAvrnxUUC8isfUE/U9BZGVJtiBJbZjd7haDkzAlHob7jKMqXYPrzbNn
         L+/W+G703Y++2N7SfmVnMLKFCNFRVfjvDCOnf8FJgGxpcAN8Q32AZUP2Kix5z+vKf5+B
         NLVA==
X-Gm-Message-State: AJIora8epBOBQpmZG/1MxqXja6q3Hq9HTE1BxkGv5yWfJs22xkk/n9EE
        6luh51hg+9U/UNrset0CwV/xQi6YP24=
X-Google-Smtp-Source: AGRyM1vHj3Wp6OStOx4/akn2IlWiLgNBGkbbYAibl24DPkdzM2wkiTjgHa/vb1rt6Jr8P9Yq76tjVz4UjsU=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:a17:90a:73ca:b0:1f2:2989:b92d with SMTP id
 n10-20020a17090a73ca00b001f22989b92dmr1934085pjk.182.1658530977975; Fri, 22
 Jul 2022 16:02:57 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:40 -0700
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
Message-Id: <20220722230241.1944655-5-avagin@google.com>
Mime-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 4/5] selftests/kvm/x86_64: set rax before vmcall
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
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

kvm_hypercall has to place the hypercall number in rax.

Trace events show that kvm_pv_test doesn't work properly:
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0

With this change, it starts working as expected:
     kvm_pv_test-54285: kvm_hypercall: nr 0x5 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xa a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xb a0 0x0 a1 0x0 a2 0x0 a3 0x0

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ead7011ee8f6..5d85e1c021da 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1422,7 +1422,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 
 	asm volatile("vmcall"
 		     : "=a"(r)
-		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	return r;
 }
 
-- 
2.37.1.359.gd136c6c3e2-goog

