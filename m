Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642A053C1E1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiFCA5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbiFCAuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6626105
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n8-20020a170903110800b001636d9ff4f8so3482820plh.11
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hafZYDGgSJ5oFFeJgApxeOqZzhtoEWbmbZkm/ZFP6EY=;
        b=BFIn8Zeh62lOVKuLdHrV6z7PwDAx4rOZUpY+dQfM/te5p0aQ1pRq1+RwRcnOZm7f33
         5dDmrsa2wb6AuAeyjihZzR7u6IFXFh1qPRgXwVjPpCnUdv3vGDC7dXvzaVG2rsSn1XAF
         M6wvb31EsybnlJZtgDLHWupJQEe+MNEkEVOCejRcBy5BoT2kaSWWyGj/6jzk7l1E8BBJ
         UeAo3sy/Fi4AyibqcaCpv+6jW3RT8qn6aEipCtmAfz7yjyjrvhDsfgEO0YSfUu4V2eA3
         JeeeJImgfF3eBCsQHvf8TYWElysCJgyuCSV44I/2S7OWLtWMEG4x/gPv+ZJRtHswE2FH
         W89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hafZYDGgSJ5oFFeJgApxeOqZzhtoEWbmbZkm/ZFP6EY=;
        b=LLoDfzo/UvL8OFvGwV2lbOyXnwSG8KtddxOOOiaR46WRyN9sIxRBkURTXfUhYsFdb2
         ex4gTKVf3Bnu8iBWkFgQOTph33mEq5qlM7yl0Vd70rmIasWEZDE+CPKBCY4ngcr6NoIw
         T9F5weK7vfrXZxeL0R/NG9QeBDo8otK9OZapUCb+/TGyuALUM8nocal8ANPLQLCzuK4l
         714ffVyTIO5tqBdxUV9tKBmk+4tgDFJ+4AzkPiZbQLz2B3aQsMsIO1uOGvFjYWmOtdCW
         9AVI32R8xkh3HBiWAIhgJAwCG0wsxJZ7Xyj8AyTcqEd+mKG+OsxiE69+mFHrs9fUWNKb
         MIuw==
X-Gm-Message-State: AOAM530tfq0YeThIDD9MiDGwVZIIuRRaM1j8McIKtFEo6jnJ9iRemud8
        jBm1uJqx9uRvtdxO+QsT8BKR3yorTh0=
X-Google-Smtp-Source: ABdhPJxlapv4CHNXsH1gmdu3wws4ZOjYR5hqsK3EaxTf7Dj5cAsfititI1pTfA7PJVOVNK8dQn1EPBqDszo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:db0f:b0:166:42b5:c819 with SMTP id
 m15-20020a170902db0f00b0016642b5c819mr5582019plx.96.1654217234852; Thu, 02
 Jun 2022 17:47:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:08 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-122-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 121/144] KVM: selftests: Use vm_create() in tsc_scaling_sync
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Use vm_create() instead of vm_create_default_with_vcpus() in
tsc_scaling_sync.  The existing call doesn't create any vCPUs, and the
guest_code() entry point is set when vm_vcpu_add_default() is invoked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 2411215e7ae8..728b252597cc 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -98,7 +98,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default_with_vcpus(0, DEFAULT_STACK_PGS * NR_TEST_VCPUS, 0, guest_code, NULL);
+	vm = vm_create(DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * NR_TEST_VCPUS);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
 
 	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
-- 
2.36.1.255.ge46751e96f-goog

