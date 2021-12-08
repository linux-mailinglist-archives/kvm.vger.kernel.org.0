Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F0E46DBE3
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhLHTUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhLHTUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 14:20:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED509C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 11:16:50 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id a4-20020a170902ecc400b00142562309c7so1322378plh.6
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 11:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eOpoQheuEChiITz5cym4C+k0co10zhRi6836ZIOv28w=;
        b=T7kCIG7w2xmIK2EtnGZlhYtaU8xXzQ5YVeEvmIdwJJrc3yNAKNwYigULZRqEmdlBPu
         VjmmVr8NWxgrMYQxkzzqV7P/NKlHyQZvMDJUgfZEtWebTLycLwgQPQIVxp1cqcyHSdD5
         67hwsa36BerMIBXU3kcumPxdLeAPvIbF56S3/PevxAg2hSb8BbGlZr7dsVJK/qVMG6v7
         3ISG50tNlt/lLvTYqHmtKJwxlwaXFiw88RBk7G5yvJLgnjnfkSfbWFMSTUdz2aYIkRPe
         w1QXzh1qcLZNwzAzAjVcLJ/4fDLs4FcZLnlpOV+2wBErPO2iQwfKBI2xtDSiULaOUB47
         em9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eOpoQheuEChiITz5cym4C+k0co10zhRi6836ZIOv28w=;
        b=y82iHKqEC3+pTV4dhbeyMqBtF+cPbMSC4nJgTbxjnfokGrWEjGFqtpSq+AgocVrrtY
         lAXGJCnrXvHkHXQ/YG9lkMxsTKuDMrv770tdnq6rW+tldwFMiofC+AUCYu036YLyoXKe
         h8rs7DAHwHiMWElacBwQNpIsKve7eLNQ/8P5VFrDieD9P/WPQi0W6t1F2rpcb6dJeb9Z
         ++RarRybxAkrDDKhOREag89WNDRlFcFd0QKSoAK3fErjVYiuZEMa+WcOj/vl0Ilc/cEI
         rQj9IVfN+6qngRpdrWPTT+btq2JrAQeNgy82+bBOcDQJ5sydHb3yiqZjJQX1aWDkT4t5
         lwcw==
X-Gm-Message-State: AOAM5325tSxNuURoRLjrxB7q9jyITZC0Ja0BkMSdmpBgczvc5CQKsvV9
        OMnA2fuL9IBUzHpp1eC24tFSrfw5oMs=
X-Google-Smtp-Source: ABdhPJyupc2xZtwjqqqGvzWU1Z5O0JBqB5W9LbfnGsTyfih5jQlM82Q1KqXD7VYVQ0ZDwAPtuZ3z0V4jiX0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ff20:12b0:c79e:3e6b])
 (user=pgonda job=sendgmr) by 2002:aa7:8886:0:b0:49f:fae6:c5f5 with SMTP id
 z6-20020aa78886000000b0049ffae6c5f5mr7353661pfe.8.1638991010447; Wed, 08 Dec
 2021 11:16:50 -0800 (PST)
Date:   Wed,  8 Dec 2021 11:16:41 -0800
In-Reply-To: <20211208191642.3792819-1-pgonda@google.com>
Message-Id: <20211208191642.3792819-3-pgonda@google.com>
Mime-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 2/3] selftests: sev_migrate_tests: Fix sev_ioctl()
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
require both (aka. AND) values are OK. Removes the LAUNCH_START from the
mirror VM because this call correctly fails because mirror VMs cannot
call this command. Currently issues with the PSP driver functions mean
the firmware error is not always reset to SEV_RET_SUCCESS when a call is
successful. Mainly sev_platform_init() doesn't correctly set the fw
error if the platform has already been initialized.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
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
 
+
 	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
-	TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
+	TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
 		    "%d failed: return code: %d, errno: %d, fw error: %d",
 		    cmd_id, ret, errno, cmd.error);
 }
-- 
2.34.1.400.ga245620fadb-goog

