Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0391551B313
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380302AbiEDXE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380270AbiEDW7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B214256F9E
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so2316088ybg.8
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=G/NbvGhtiyLQi7kYqoocOZcin0VQ7Ev2zOKIrEGbvEg=;
        b=PEtzywlanOhN5HCJA3Lt0CeIncOVVBKRoV0Hf2g1tEJh5BLkkMlbTy4701Ccc7S0UY
         koKKUWTdKaN61LeyvKAWsy0NnbVTrS1shF+8jndT/qCkDFahRcrUViryo9fDf5fb22F9
         1pafsRqHBmgwLFYPWTofxlLLi0Kzqg5jytBCK18RYJXkurPp5R8ZD5Wk6JKpSi5InZwZ
         fOcmpRSWdL3OqAnyUMf2GOwX6HyBtLD/ZGtvPVw+Bt4MoOZEIIiL/Kz6TlVrdfcbGY1L
         sSdMuPWn2iakz3XVTYecII7Pb+Da44akgh4pLgeZLoKQfBF6r07l6kKv27AJ/k73c4Ii
         u+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=G/NbvGhtiyLQi7kYqoocOZcin0VQ7Ev2zOKIrEGbvEg=;
        b=7/82qVzx0Z+nlCLtEGvtPrtwwp+6mUy9vtJ7KcSYzO3uyB3rjli7Qt5HnK5mYc713l
         Xj1lcB9jzYiUKYr+PZzuxO5zmdF4pr1PE3NzQDYeUWmsqMEHXaAvpyZW7t2eiHYNKdS+
         ZhugXZCa3kfrzGUs5Yx6RglndIfZFRMefUyPAuttjG40nWecJW1WutjYZHxk93xbflC3
         Dmn6RYGFQnFSxrJnBfrxVCKyNu9JSabqmPgngqQrgwOK0dxsJdcYZjGokjlb87qSpfHE
         sKaixeu7JvtIH3kSgw61V1H/wXpzYzHalASKVICmdDKwSmnhiQ6rzFHgryjBfasicvTq
         VtDg==
X-Gm-Message-State: AOAM531KpiCyU9WJjkgAoiSoP8Di7ZGGL9DeVr1rdF3xcdRXqkBruGPx
        huFZxUb5HHHmqCMQxxiGlgIwZpEk2Gk=
X-Google-Smtp-Source: ABdhPJw4vqEx1r/FPBUGl6CXjGB99bRmtBvbIU1DcpitmJiYdK1Z1DGCAz61RZcnkMRlB+o/5X+6z514Cko=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:2a52:0:b0:648:f7b4:7cb8 with SMTP id
 q79-20020a252a52000000b00648f7b47cb8mr18287580ybq.431.1651704759092; Wed, 04
 May 2022 15:52:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:55 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-110-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 109/128] KVM: selftests: Use vm_create() in tsc_scaling_sync
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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
2.36.0.464.gb9c8b46e94-goog

