Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD736B71CB
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 09:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCMI5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 04:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCMI44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 04:56:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B1E1F93B;
        Mon, 13 Mar 2023 01:53:43 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so10897192pjg.4;
        Mon, 13 Mar 2023 01:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678697619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IR/pZ3SxRjS6UwRu99EOH7560cmZiqvK25YsL+XfyKo=;
        b=SpYpGTZRvn85NG9r8n+lAfl/rJ8ggf9VdySJ/DvkwFbYb9nrM2eJ9nmb5f1ZWF1y3/
         2tUOTVGwHrjdkWNCax5Uoja2omVEkM2ncJ0RArXlu2XLBEsH3/p2ZyvGM2HD1c7GrLRr
         bX5oWHkBqhG+9H4olNg6iDADJnNQ6IFJ14xCk+67QGwSco74bPZuEPWQwbdtG9xv4Bte
         tt97h+xX4v1p3aDAZTEHdGIwZv/quQ/m7nHHhNZP98eFrJLSDenzyAFo2fqAIAMxkVJt
         L1kNXqY5BlJTJA2xbtTEV2+PWSrwUnUfKj5J5TwhOnlyyZbx3pP1WWFIuPj6I8GjGFBW
         t/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678697619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IR/pZ3SxRjS6UwRu99EOH7560cmZiqvK25YsL+XfyKo=;
        b=DpXIQC4y0hEpfP1+zlrXgRgVm33H/aeay1/gN2OzC1WXMkZxxUV5TdnFaiFbmdtl+l
         9amiRs3oPq8jrDqRzVfkrahlOg/mYgybqxN5EFCbA53unXsD+9A3i1Pdu/htX49q6wiJ
         LhYyH0H9ctZ5hlxFQI3incGvfg5jXv4YEjTplbzGycIzCcwsS5P12PnKQrelJV78aq/D
         pgjDMmiiBMIC2gi8C/UzD2jjxfXu+vzjkGaAoUHF+mkeMs8GMOeYo3s2axxzwyj7n6Kw
         HvsM8eGCd63LwYsbfrbO8qgjr6/wo3QeLrv4QDqy4RiFGCAxprWl87snDrCBVl2WbQpc
         u/sw==
X-Gm-Message-State: AO0yUKXwRFY1L3EDL76dM07VD71Z+IXs0HqhtVSjeSO0wgYCOm1WZAzK
        rDQ9HSGUM1OHadfRgIdEApyKDK5Hz19nzw==
X-Google-Smtp-Source: AK7set/Dgu1lrJP03RIrrG0IDqGHsJmCUfoB1AIXJpyU65D41ESFRP6U915I0LdxMKFUIGrN2PSo7Q==
X-Received: by 2002:a17:902:a512:b0:19d:1674:c04d with SMTP id s18-20020a170902a51200b0019d1674c04dmr27567274plq.61.1678697619116;
        Mon, 13 Mar 2023 01:53:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b0019ee045a2b3sm4155059plg.308.2023.03.13.01.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 01:53:38 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: selftests: Report enable_pmu module value when test is skipped
Date:   Mon, 13 Mar 2023 16:53:11 +0800
Message-Id: <20230313085311.25327-3-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313085311.25327-1-likexu@tencent.com>
References: <20230313085311.25327-1-likexu@tencent.com>
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

Running x86_64/pmu_event_filter_test or x86_64/vmx_pmu_caps_test
with enable_pmu globally disabled will report the following into:
	1..0 # SKIP - Requirement not met: use_intel_pmu() || use_amd_pmu()
or
	1..0 # SKIP - Requirement not met: kvm_cpu_has(X86_FEATURE_PDCM)
this can be confusing, so add a check on kvm.enable_pmu.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 1 +
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 253e4304bbe3..3cd5fc60717f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -768,6 +768,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu, *vcpu2 = NULL;
 	struct kvm_vm *vm;
 
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index c280ba1e6572..2933b1bd754e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -55,6 +55,7 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-- 
2.39.2

