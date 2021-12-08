Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C402146DBE1
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhLHTUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLHTUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 14:20:21 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15039C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 11:16:49 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z8-20020a6553c8000000b00324e0d208d3so1830234pgr.2
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 11:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ojJrL2dJFM5Q++eDGH0upQ2LSoAJ/x18fk0JOthYkyU=;
        b=F9xUeZvVXMCohXl9eYXKYkj5Q7qFz4AxIrnY3AFhnlke6CeZOEtHdPqb4b2SkwcSPU
         The/ULJOrwm/KIW3p+mIqGwkytI2MsPOku0O/OwSbXDchG+TqjF6WDgzjSjjou8aVk7g
         SfEblOnKryn9vWTufvVV2fz7UwN2Vl1ndw5aosfeZe4zw5h79SteWHZmRCxzxEs+/pm2
         EXp36xwDVCAc4+YBuPVCliTWzSV1B2yBwnPj+wV93tIxeyTT5ofXA3Gb3+nOglr6ucJF
         hCSjVXUoouucJNvpXunstQ87fvEwthQ+5sf0IfCQywtTRfiPKHeK2WAsZrgjHuwKx3ee
         dCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ojJrL2dJFM5Q++eDGH0upQ2LSoAJ/x18fk0JOthYkyU=;
        b=Z39HfZjbvz7CxkHlc6piUVvllZAvV4m4yhCb5DcTOe1k/r1Smsyb2AYwDiAP+YbWUz
         wfoV6TB5FTiPzV6wZE0CRoTCRRiL+iOJArDEkvF1VeWcLQD5X71wpzVI+vZdpFP18fPS
         uUazfF7W2EsKD1gv58xPEe2ahK1lIQzf6oLdHZBD3WDEbOAppNSYcdQmPP/lRjOS80LO
         +Ho1Df41YrGz/hLKGPqfZKYfe/uxG79rGN2BRKfDfMi0BJApI3cRwTUcUYYncOh21KYo
         i+ZWZckhb/THkwc7dHmphsOfMVAQ5rvY3o8jwvGITOkdblg5qrqoDPzUdlPE1DBSwH2q
         n+VQ==
X-Gm-Message-State: AOAM530ffkxFzRYjwowFZgyV0yWefoWflungF/xMUNUCB+emKtPpNrSN
        suEWR1YW1dYVC6tzxdppk5xOYhCNzK0=
X-Google-Smtp-Source: ABdhPJwMNSfy6bFmz0+Dabi6HgIafA88yZ0BHb9FRAvnuCfanEqqNQ1GjPW0a8MU9L8duFHHHlhi3nKjo6Q=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ff20:12b0:c79e:3e6b])
 (user=pgonda job=sendgmr) by 2002:a17:903:22c4:b0:141:deda:a744 with SMTP id
 y4-20020a17090322c400b00141dedaa744mr62116188plg.25.1638991008565; Wed, 08
 Dec 2021 11:16:48 -0800 (PST)
Date:   Wed,  8 Dec 2021 11:16:40 -0800
In-Reply-To: <20211208191642.3792819-1-pgonda@google.com>
Message-Id: <20211208191642.3792819-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 1/3] selftests: sev_migrate_tests: Fix test_sev_mirror()
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

Mirrors should not be able to call LAUNCH_START. Remove the call on the
mirror to correct the test before fixing sev_ioctl() to correctly assert
on this failed ioctl.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 29b18d565cf4..fbc742b42145 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -228,9 +228,6 @@ static void sev_mirror_create(int dst_fd, int src_fd)
 static void test_sev_mirror(bool es)
 {
 	struct kvm_vm *src_vm, *dst_vm;
-	struct kvm_sev_launch_start start = {
-		.policy = es ? SEV_POLICY_ES : 0
-	};
 	int i;
 
 	src_vm = sev_vm_create(es);
@@ -241,7 +238,7 @@ static void test_sev_mirror(bool es)
 	/* Check that we can complete creation of the mirror VM.  */
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		vm_vcpu_add(dst_vm, i);
-	sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_START, &start);
+
 	if (es)
 		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 
-- 
2.34.1.400.ga245620fadb-goog

