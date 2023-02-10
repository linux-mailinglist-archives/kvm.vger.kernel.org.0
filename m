Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541C4691582
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjBJAdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjBJAch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:37 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D304033450
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:08 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id ji6-20020a170903324600b00199420887b0so2114027plb.3
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=10uKcoMTK28X3E6OqIDW92Whbuau4E38iHBvczmXRls=;
        b=MZeQazzohpr5oaGhqxIEXxmz0jCJ0cHmRJPQ0SIOXmyBLoDECqha+kpA6s1C1Bhy9p
         k3O08BXn1tpXk7S5rlcTaAvA9zW2TexG6vazpseFgKRCfnitg5/zcZ/nSJg1WtbZzTkg
         Yu44+/OUxJbpiq/XAJVns+9eEsVeQCMwh1PAvAJk3bBM987HJUrO4gt0ERZ2hh08Wku3
         BxVJP36jWUgAaJEvT3GdUuiadDVtaP8FksFcjrIJuc8J5c97HzZpSCyUy7BnA4GyhnVV
         WSZbPxnQ8CjoZzKYe2jo/lrngLsZ7NcuE3QG7NXDzn33FACLthp4Oo93JMMqf8WGfJpS
         6cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=10uKcoMTK28X3E6OqIDW92Whbuau4E38iHBvczmXRls=;
        b=SZVn1OKFw5OXfx9nKR1b9B5PoTjLS2e8D5F1UDzDZxqn3C1KGlVhEiWNPpN422Owr0
         mTNX92arIHGeax4r1OK9CMK4gmtdqgbxc6AFSx7vIqnaDCTIct2LR3vNJhjdPydq4Gxj
         OyHL+RpDvThOdyqBPJPf1c1YK4SebCJg4wNpZxe6y/NHd7ClT2GLkCCM8Wdafv5WUtTm
         3TJwurDfmXGjzNMJTmZJMPyBnKQPCt/0IKjIATi8LUBxmxSVqN1v5JdZfJ+SrVXrjjD4
         3dx6pJvyqdiZj/RIfOyMQVLyLwrb0NXVTM8/WJkQNe0Oh941bFIVAJLdVuY0mc1OWN6k
         8/eg==
X-Gm-Message-State: AO0yUKVFkNTfryV+RMypaPL/oCnAuZCfFaDXeX8BHI8+kTZl2cH/0XiD
        d1Y/VE90R8foZBHTiIcvlXCwFddKXQc=
X-Google-Smtp-Source: AK7set8Jw6V2MxGOotIz0pRSdH5xedZQlon3S3K/ISQNTXhngC4VubA3Pf6Mz2P4HC+7/kvZjPqPBJaD274=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:53c6:0:b0:58d:a84a:190b with SMTP id
 h189-20020a6253c6000000b0058da84a190bmr2946268pfb.48.1675989128046; Thu, 09
 Feb 2023 16:32:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:37 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-11-seanjc@google.com>
Subject: [PATCH v2 10/21] KVM: selftests: Assert that full-width PMC writes
 are supported if PDCM=1
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

KVM emulates full-width PMC writes in software, assert that KVM reports
full-width writes as supported if PERF_CAPABILITIES is supported.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index c3b0738e361b..035470b38400 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -110,6 +110,9 @@ int main(int argc, char *argv[])
 	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
 	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
 
+	TEST_ASSERT(host_cap.full_width_write,
+		    "Full-width writes should always be supported");
+
 	test_basic_perf_capabilities(host_cap);
 	test_fungible_perf_capabilities(host_cap);
 	test_immutable_perf_capabilities(host_cap);
-- 
2.39.1.581.gbfd45094c4-goog

