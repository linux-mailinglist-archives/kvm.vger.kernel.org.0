Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0753F3A8392
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhFOPGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 11:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhFOPGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 11:06:52 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD18C06175F
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 08:04:47 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id r4-20020a7bc0840000b02901b7cb5713ecso580249wmh.1
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=U8tRY4eIjdncY15KEK0ToYItELXvjbZLJizxIivWu1Q=;
        b=Ispz2PyvAyjZnAVA1+Y3WPgpeUeoOkfKFvjo7W4ag/MGmGEU9MxA4xWSbctmAGWwn+
         FrTtaYpVOp3JUInUR8RLQLqvXV2tp2zcYTxBGpFWPW8xz3Js0oBId7lZsubwg1kviMWM
         UXAzn/Tx6+yFihjJCsAci/gHKDfXT3b7g47X8u7OPP/3u8iE630TDgK5VBb1eowV3xuC
         yxdlKqoWEdaZUHWKgaLZdjPQ/08aI3mqlxVF7RobqmW2x7zZckova3xuFjsFZkW8tRqo
         q2UCfnXQq03CQehMLvaSJjEaiHTUD862b/oDfg00u0c8eX9FS2Jj+8nHQXvOiPDXDcDW
         Pf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=U8tRY4eIjdncY15KEK0ToYItELXvjbZLJizxIivWu1Q=;
        b=FLEyJ+uj+RFsEoJxIo6DVxDxsU+V9VoIQm8gHTQOkPmQE0iu8yxRq2vmVg03YPE0v7
         YJV4iOSBWlB5WvXlTpjc4ZvKzUk36Y9jUwuwvlYGLqXBjlk/UnZnnAtcyaJ2s51MslMH
         H87+CKfFzV0dZR0UKRWBr2R2N3Ja1Cct5j7LiwmOjOtbdHtbsN/4nCR9q+rD00Vyg1rI
         UAPYr4z2lOJNQ8cUsRSu2hQEpJd/OqtsdBfvG2wdIXB77mfoLdqEonZQcQfRsE4/Stz7
         jAX3PqcxuRa7+UEJbUtvHzYoNWnAA1+1jUhSBWgb40DSFNkR50FAZqsT55Bi6NfBGtA7
         ojdw==
X-Gm-Message-State: AOAM533qSbXGDNrxWmQI6FtSlFkS9PwJrFSY8qB6vl/YhCqRUHiydcv0
        yGWklm/im2LF1xSeQjv3KfGnrRNBX7nhcRUHCmNgzxW4UKg5zwyeo+kz0aNBLxJxu3lo9r2goX6
        1xQvW54qly3J+4z+x7qNcDHOZ02sEkfH+nHJuZkfdkFZCT0ASAkA46+c=
X-Google-Smtp-Source: ABdhPJz+mh38NR+lnir4yQjF9dF4diMuUD+c2Pk5Htw6LMcTuZVcFuhgLQogn/QsYcn2OOGFsneBaELe/g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4681:: with SMTP id u1mr26257350wrq.268.1623769485680;
 Tue, 15 Jun 2021 08:04:45 -0700 (PDT)
Date:   Tue, 15 Jun 2021 16:04:43 +0100
Message-Id: <20210615150443.1183365-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] KVM: selftests: Fix kvm_check_cap() assertion
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CHECK_EXTENSION ioctl can return any negative value on error,
and not necessarily -1. Change the assertion to reflect that.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5c70596dd1b9..a2b732cf96ea 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,7 +82,7 @@ int kvm_check_cap(long cap)
 
 	kvm_fd = open_kvm_dev_path_or_exit();
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
+	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
 
 	close(kvm_fd);
-- 
2.32.0.272.g935e593368-goog

