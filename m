Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0932653C305
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbiFCAuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240529AbiFCArS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1EF37BDC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:34 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i4-20020a17090a718400b001e09f0af976so3515110pjk.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+G2Mc4uEcLEuvE511QGrYZMpWnJKj8uJhsUqAFoxTaU=;
        b=EBLFg8LOEt1v0b5uPUhfA/B0DzhK9G1oKVuAkjEz231j2/rvpCjYbhxnr5eI2uTCpm
         EVEtevDkYmRjSs5HF+28JrrFY0iKWrPfZ9x5CTRqrRtdYei/6tMu2a6rUh3bNERJV6gJ
         1opPS19FyXErT41xNTCistoenSWK/CKJVUXomQrc6xnNx/7ZJKQX1GL4oQh97/2KvITt
         mMG+/ajz7BdHnzsaaFTE/YhdbcT2hljQpifggYUYszNeoNQ75aGvYDdcPvwCASW0hs7X
         06vz263LGPlW61tCaUdpNrcnXU99u2H8Kc2tPNMudf1BnUY9icW3l0Eva7EA3eyNFRQp
         PChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+G2Mc4uEcLEuvE511QGrYZMpWnJKj8uJhsUqAFoxTaU=;
        b=UuPDFrqsl3J+NLWyCOPFFpNjR18tQFUEakBEpbf/zQ8b79rTfs6i60XXRQf+x5/mgp
         ObRazBSlBWnzS6nXU3Atp5uD68J4w5Sxy/cYMzRySQAUYNHV3G0BAExDitnMIEEDN9/G
         bYat+c7xOPXl+2y2Llrgj8Cd6YENVcIocAZnpOH6VZ73bUeyXUNsTUV68uCNS5lwKxNU
         msErwTdbihGCoTBupYU/hPkjn8lj01EI2j+9hKDXXJxr51d8XstlNHtJPiXfH/dOMZEI
         RixLxhw9i3K9PWzs8mLxZagaJAo0mtnrwSrIF8aSL0Fl+vXvvObtm0NX7uztsriA93bR
         G2Zg==
X-Gm-Message-State: AOAM5330FwTliczFZ6ggO2nSXKZAKPMC+w6awm+NHHssFdaL8M9CBYX/
        jg5+6qHhpAakuLFbqCPSj/8VcNFS41o=
X-Google-Smtp-Source: ABdhPJweTcqTwf2ATxClTWmQRZJVLDRFJGLzBz9z4YK5OB+B7IeRWYC2yi9kbkHYoqLThNSOHLiFf9AQvjU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3841:b0:1e2:f16a:a117 with SMTP id
 nl1-20020a17090b384100b001e2f16aa117mr27262446pjb.130.1654217193862; Thu, 02
 Jun 2022 17:46:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:45 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-99-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 098/144] KVM: selftests: Make arm64's guest_get_vcpuid()
 declaration arm64-only
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the declaration of guest_get_vcpuid() to include/aarch64/processor.h,
it is implemented and used only by arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 2 ++
 tools/testing/selftests/kvm/include/kvm_util_base.h     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 59ece9d4e0d1..4d2d474b6874 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -207,4 +207,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res);
 
+uint32_t guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc54e920383..d94b6083d678 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -707,6 +707,4 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
-uint32_t guest_get_vcpuid(void);
-
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
-- 
2.36.1.255.ge46751e96f-goog

