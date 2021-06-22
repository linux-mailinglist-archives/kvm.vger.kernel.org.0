Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B203B0F1A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFVVDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVVDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:11 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B045C061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:55 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so19561645qkc.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2WwTCe46deaikUhVyu7Yq+ukrkAZae/spD96bptegqA=;
        b=JKw0cxJMszWEUTNKrji5Mr8+2gGfpeAvwpp8JRE19/TCx6IGxClmo0UDmE/qioVUQq
         Vl1PcNqiUEKuJHNLHaCegMF1fsG1BdD8VnJyHMlZQ3PbEhtQhbJAixA38GdGeiqvzh2L
         hkur6v0fg4ZiGhJT/zSeqQqH8Yj4xslxwRTHhU8uf8lvH4bTmXzx8TTMewJRb9fGCPly
         5wLpHJRWrEQL+VFdw+yIReaDQBAYm7dga9r1aQhDHB4Q0ugGReNyvecCKoPBlO40jqii
         W1J7U+UiScsfSzkqjIRoXHzXbE6jAFZAk111ioICCtu8oTuRhjPUPquGTQiOkMkPXyKy
         wjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2WwTCe46deaikUhVyu7Yq+ukrkAZae/spD96bptegqA=;
        b=PlKOVghM4ytvmLdritLRIoK3gWE3Z7/V/VEDXSYXT1Ybn8DbmqSo+sgUuDKKU29rAW
         SGa+mSpugut17Y027r7+tOY3oazOjqbIGSgCvR78aV7hxmFal8QKHgzSf4HW1NqOhXc6
         YfGhY5iRAX0C9aKL/NFWHLijyqc4bkZOxpQclhn4Mk2UWgF4EyT4K1TzAXR/z6Ocl0PF
         vK0+CztGY2teZd3ctNdocVzh3yglV0jqYmBO1CqOXh667JUiXaiQ55y82rophnJhKsEh
         3qBma3vmJAY/nvcHSfspxDvuNhj9QtZHb/uwjr0k0JNogsLwhiPKta/Qlesqwf42dZ24
         6jMQ==
X-Gm-Message-State: AOAM5328VNktSFXjLe32orNpolBK5lpwzjSHWgXo5pdqjcOthC1lnLWs
        2O7UKJ3Tgf8sOuxz6e2ROSQFAy0iSJ0=
X-Google-Smtp-Source: ABdhPJzkbsfKRDObeakk1KPN1XJej4iNTtfa3F51nr6dEmdhMcKrQaSLRoc3MAwFKQv/gNyk3whta00NK+M=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:f309:: with SMTP id j9mr878013qvl.12.1624395654433;
 Tue, 22 Jun 2021 14:00:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:37 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 02/12] nSVM: Replace open coded NX manipulation
 with appropriate macros
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use PT64_NX_MASK and EFER_NX to set/clear the NX bits in the NPT tests.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index df4c60a..4bfde2c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -707,16 +707,16 @@ static void npt_nx_prepare(struct svm_test *test)
     vmcb_ident(vmcb);
     pte = npt_get_pte((u64)null_test);
 
-    *pte |= (1ULL << 63);
+    *pte |= PT64_NX_MASK;
 }
 
 static bool npt_nx_check(struct svm_test *test)
 {
     u64 *pte = npt_get_pte((u64)null_test);
 
-    *pte &= ~(1ULL << 63);
+    *pte &= ~PT64_NX_MASK;
 
-    vmcb->save.efer |= (1 << 11);
+    vmcb->save.efer |= EFER_NX;
 
     return (vmcb->control.exit_code == SVM_EXIT_NPF)
            && (vmcb->control.exit_info_1 == 0x100000015ULL);
-- 
2.32.0.288.g62a8d224e6-goog

