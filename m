Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76C8695D7B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjBNIt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjBNItp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:49:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9BE1D936;
        Tue, 14 Feb 2023 00:49:43 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gd1so3663584pjb.1;
        Tue, 14 Feb 2023 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlEay2KekcluULkM2aY9GsNqvKMbxc6zn+AXy38vrsQ=;
        b=VfoWzIelLWZQjbABnEY77qXMSoK9tnMmRZv5UnbSZPb4TuxTn5rDoNtXbKyL1xzNJG
         zKBha3O5S8Qvcw/PPjtNOYVqYbjBxr1o3BLl4LFDuNLj53ckKR8EzYvGwwe2/Lq3zoxe
         W4tALUFWdvfB2HS5aGdhX102KtOb9cV9V7MCtPF5LHo+oyH/jn+HQoLPVGRQxp7qErdr
         r+lJMCSUN5snHb/5CZM2YQ3388XfcTsk4Qx2BmFqUvGOO6pss1gWzk7Nj3XuaBfcmURj
         tf+15XTOAlq9LZ6krxNalAvuru4pNjcsqpKs6dpohba79JmtdrHMZTUgQ+uHT/NeWJqU
         bohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlEay2KekcluULkM2aY9GsNqvKMbxc6zn+AXy38vrsQ=;
        b=5PG+Gg2s58NuxfxQEtfPr6foF5iUWVLoMUbtobcO2ylVsmtmeLXLM44jAdnNMi4ALi
         IeFXvk68bm4eNEPIA3lH3+VGuI4TTaBKcjyLzqqW+AwhLxohNHk052U+BvrFEzdhGkee
         28zsg4crJvNsEwuCGmkNmYRyvVL6spNcGZnMMauGBbsUTeIGK3tX8Tx4ryvLDltCL4aA
         x7jPwXu2t6jwRHH8PoecHxeDcOCUCdqx2EyK1/zyoa/6537vWc4J6AvS5eZMOLTzKMmr
         dvoxjJFZcrk7cgHnC85wf1QXsS978pMnznZ2nmP66eUAFFj4oRr6V2BfJjsoulHf2Kh5
         fD5Q==
X-Gm-Message-State: AO0yUKUE8eDF/uG8eGX2pLhfCTbtxLd6On9vRVohDBfjqiKzXDSIKHXR
        22qvaPBIal+JFt18wgdWA82mHxeQKBtb0LrWCZw=
X-Google-Smtp-Source: AK7set8UU060qhhYPuBy73ZRzQXfRBYHgq/CUKBxg8chLALi8zQdZpkdLjfr0E6sqCN10uGUf3otKw==
X-Received: by 2002:a17:90b:4a82:b0:233:a890:2c1d with SMTP id lp2-20020a17090b4a8200b00233a8902c1dmr1690945pjb.16.1676364583429;
        Tue, 14 Feb 2023 00:49:43 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o9-20020a17090a3d4900b00233b1da232csm6549475pjf.41.2023.02.14.00.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 00:49:43 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Report enable_pmu module value when test is skipped
Date:   Tue, 14 Feb 2023 16:49:20 +0800
Message-Id: <20230214084920.59787-3-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214084920.59787-1-likexu@tencent.com>
References: <20230214084920.59787-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Running x86_64/pmu_event_filter_test with enable_pmu globally disabled
will report the following skipping prompt:
	1..0 # SKIP - Requirement not met: use_intel_pmu() || use_amd_pmu()
this can be confusing, so add a check on enable_pmu.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bad7ef8c5b92..070bc8a60a7f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -771,6 +771,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
 	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
 
-- 
2.39.1

