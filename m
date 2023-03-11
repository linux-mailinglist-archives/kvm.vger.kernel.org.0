Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502BD6B570F
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCKArp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCKArI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:47:08 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB68140FE6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id p36-20020a056a000a2400b005f72df7d97bso3628918pfh.19
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yxirUIJ6f39Vff0ZETvGTfQiZcgxHh0oGFGaX9tsDZI=;
        b=XRPIim0wWTGV2xd60uJ0P6WuxE3MZzQxEFfMCa70jMiRJwRNB3XbYFH9QKNEBCIY1Z
         BnhJ1KDO89oWDnsd0TgJG8YFNllKSs5pHdzellm6llcJsDQUXYLXQhJXIrbdf+6hJF2w
         rQlUX74nH01pIXP1o7EmssYmiotFtk8bK+oHRcV78jgCmvHdIVyQjp6SzGiaR4kBzoMZ
         GNo6/2uqcUZgNWKPY13oV5XmU6cvsmBydi/zMtfPM+2m1ZO7yOzJcDbH8REarYrpoW9a
         y9BMdra+O4x92LPA2seTeXSE0c/YeYP5RvRVk6jn5IyEs2x2awfWu1J6q+20GpLJmUKm
         jnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxirUIJ6f39Vff0ZETvGTfQiZcgxHh0oGFGaX9tsDZI=;
        b=zOqrA0he491S6ZXOmsQqDGVm33yBz+pK28aT3UU9uW9x2Z511WFScpCiDxNOhJDNxj
         Bf2NJcmQldmWt7O95WEkT5j40o8k33uw4Op3RcMrGh2OwbEfShGdS4/hTJApUhOl1mBP
         RvLWDvg6nzKd4Ul/BbUCd6CsB4OLJ4fhX5t5qIVEfdRTqu3W1D+GL+GQ17rc6J1RrcnX
         QpF1Soa3WoPab6lxxMzD6EbACY9eNQniUL8TaobtNiOsNGW14pZQnmOZ5MOV5dZISuU0
         zk3thRtbgUuQbUH+xORKjz0vnMN/2EAKe2BnKYeXOwYxSOxMZeIMU4N45UC+oOyMdUMv
         7D7g==
X-Gm-Message-State: AO0yUKXr1OYk0o+7zcuVh5waTm7KTItpVkeH1QxVhV80kO3WMpAzGtwf
        FZMLUUrNwM1CQHRNIAdp7891md9C8RU=
X-Google-Smtp-Source: AK7set/X7Pw1rLmFh09E2mfLb65niXUw4qlCbyojA13IEkKsCIhgL6KkAGgfDb99/5PvYaqWXXTLLpaLtyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9319:0:b0:503:7bdf:df4b with SMTP id
 b25-20020a639319000000b005037bdfdf4bmr9772662pge.3.1678495600955; Fri, 10 Mar
 2023 16:46:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:07 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-11-seanjc@google.com>
Subject: [PATCH v3 10/21] KVM: selftests: Assert that full-width PMC writes
 are supported if PDCM=1
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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
2.40.0.rc1.284.g88254d51c5-goog

