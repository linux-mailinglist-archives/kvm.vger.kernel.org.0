Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C224E44FC
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiCVRZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbiCVRY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:24:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFC114038
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d145-20020a621d97000000b004f7285f67e8so11698748pfd.2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A2OVfh4jna2fjjys5QzYhnEURgOUCehkINqKA/XnhEE=;
        b=KK7kUh3po8iC/Gm8apsdZvHGwC1JoIeebfUmsd/3SXEXyatzCijqZAmSwSo6wwadQH
         JUKCVydqn3ltAAGTyC80LbVyLW1FzvlGwyIlxEf6cCtgoTXMZIWqAvGZEt/PWFG05BDV
         6N59RPQ2Q4dFqq6szU3GV7VdmcqvLQP/2TW+f8JXDd6D4U4H2kLMbutw3kgNL6jTyUTf
         4UOiHjqC8Qo/CiH3tTGaxh4UcmX6VbQ4gf9SS23L0BRckdawkCrzGuk2Xfy5FTsg9Zz/
         v4a5McWHyEyw3XQFNDidhoJ4MG36QM+fzberYvyLcayIyCdHWe51dJ7Iu1XuF3EpPI9I
         8Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A2OVfh4jna2fjjys5QzYhnEURgOUCehkINqKA/XnhEE=;
        b=oW8Ajw9pmaoUkiWdooFG66m/YD108XHYdZgcDK8MspuSOY8/33cd8IAI7VsaTll2LE
         OaU9vCOuWjZqTCO+pGRJwFBBIO0VzGRbeJyUobIExoNI3hVAjrF0+3IeSr684gombLgQ
         qoCQ4lqueF5M7oDttmfPT7rikH6Jnz1A2YW8fQqEBI1SCTdSqLJjcSAGoI55uDkXrWEh
         VCM3A6AMPBIjchvsQBDht+zJ++qRkKLjX795u0TTovzL4u4kROZcMxb4r1t08UXKRYVH
         ApNemQeEdTyFotUDxi2Ph/5ofG7/GG67sG+XB57BYlf2gd1LvOKO6J5RUWLUNgUM0V5N
         /u5w==
X-Gm-Message-State: AOAM53283bWZjzxAeXt5TCsZa+zWVqQQRL2xkpLAXDxQlpk3AS33odIf
        kv2QKm79xNx+sQLALfXVa23pAVVCWgcF9i4oy0MdmYjRPJ2i/1cZNOi/h4wx7b0XFkVGsDr9LPi
        VF+jIbg13Ux7FVEfUIDIGOq3qPGn1WLpCzknfY2+2j2JqvRKGYeioJsTWlPZbz3k=
X-Google-Smtp-Source: ABdhPJxPCzEWdiZmf1k/k9aSVDd11Orxgxmcb/v81+3NychWWnJaU5A7hAIzcW0g2gazih+FM+9T5Lwo3MaotA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr102565pjb.1.1647969805974; Tue, 22 Mar
 2022 10:23:25 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:23:17 -0700
In-Reply-To: <20220322172319.2943101-1-ricarkol@google.com>
Message-Id: <20220322172319.2943101-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220322172319.2943101-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
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

Add is_cpu_online() utility function: a wrapper for
"/sys/devices/system/cpu/cpu%d/online".

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..14084dc4e152 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+bool is_cpu_online(int pcpu);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..81950e6b6d10 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -334,3 +334,19 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+bool is_cpu_online(int pcpu)
+{
+	char p[128];
+	FILE *fp;
+	int ret;
+
+	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);
+	fp = fopen(p, "r");
+	if (!fp)
+		return false;
+	assert(fscanf(fp, "%d ", &ret) == 1);
+	fclose(fp);
+
+	return !!ret;
+}
-- 
2.35.1.894.gb6a874cedc-goog

