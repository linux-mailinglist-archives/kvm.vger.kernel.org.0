Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E5246F2F4
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbhLIS17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhLIS16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:27:58 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE878C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:24:24 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id q13-20020a170902edcd00b00145280d7422so2766953plk.18
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nEbnmMLnxFijfTxQFcKhYorjkHl6s9gXZWmFJky2ed4=;
        b=fXVRFEk7Cwg9g8Aqe3Ykv4J4B3w4CcF+ToWWfV57DYZV6gXroGNDLRRokT/P+48VFL
         FzluMjiJAYOhxp5sWoeeow0lmLsyPZxbAtFySkOOUcCGFdSS1V+K54Jwup402IrOTc/L
         pdwdqNW8Yil5LsC4KnnJDOb1JatjdyK872PnRREm/FIjv1AivlSSq/xwqZ7Fi/Z+ALpF
         C+smcVmcZZB5eFocfENiu0uVHvhCRkIc2GS3hoHYRWL4sl+Y2HttONXcWe+dWjObGYPU
         O4E55PdLACnmysI3NW8JL9fDIS+IWjLZ8YagqGW+EFzUTMOJTGtwkYT1EIF5VzX5mpXJ
         0OLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nEbnmMLnxFijfTxQFcKhYorjkHl6s9gXZWmFJky2ed4=;
        b=l4yKb3rYl7ZRYdh49ErfaPxOjqXuSUsNR2zCN640Ib/xJnhLIkQ0hFB4DrhNXvtS2u
         H5C8JCpbritgYTbFza+mMDPkePco6yByRMPG7musLJwe0QiALN3OnB0IZa3pNXNJm8zX
         IfjP0iPmvFtxoFNmevW+ixIxis6ag+8CoPUG6Kn2t2pZR5O7UJ2EkeYTBWAzhmV7fuAU
         DlA2wZjGxVe7DCmaB8/nKuscrRRt6s713eGVvhFuWg9owVhoCsgnB/OBRdy2DbJfELK+
         TOa1fcg1KSWgV/P0yfYnUobpO6ksfhwvLXZD/bGkQ3jFUpJCIENV9KB3uUWaT8lpMAD2
         9Blw==
X-Gm-Message-State: AOAM532FNbYavnJviPySGxIZkGXVd1oxkaElLyFqDhvhNmDQyldWWBGJ
        C95nuloDULzHk35oUqvozFpz/KKdqmM=
X-Google-Smtp-Source: ABdhPJwD9mtX5fZHIN/Vq9GSaColmVEza+eOOt4xFB6eYKpBQHRpyn0YETu5FlTxwCr4FmjDVO4168EM/YY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ef0a:5d4a:e2d7:ed84])
 (user=pgonda job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr1037136pjf.1.1639074263837; Thu, 09 Dec 2021 10:24:23 -0800 (PST)
Date:   Thu,  9 Dec 2021 10:24:17 -0800
Message-Id: <20211209182417.218496-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH V0.1 2/3] selftests: sev_migrate_tests: Fix sev_ioctl()
From:   Peter Gonda <pgonda@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TEST_ASSERT in SEV ioctl was allowing errors because it checked return
value was good OR the FW error code was OK. This TEST_ASSERT should
require both (aka. AND) values are OK.

Currently issues with the PSP driver functions mean the firmware error
is not always reset to SEV_RET_SUCCESS when a call is successful.
Mainly sev_platform_init() doesn't correctly set the fw error if the
platform has already been initialized.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---

V0.1
 * Removes extra whitespace line.
 * Corrects patch description.

---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index fbc742b42145..4bb960ca6486 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -30,8 +30,9 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
 	};
 	int ret;
 
 	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
-	TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
+	TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
 		    "%d failed: return code: %d, errno: %d, fw error: %d",
 		    cmd_id, ret, errno, cmd.error);
 }
-- 
2.34.1.400.ga245620fadb-goog

