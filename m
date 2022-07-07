Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A299356A7D5
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbiGGQR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiGGQRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:17:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D4DF13DC8
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657210638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8sCoaxLOXpg7pnv4sV/NFcTS/eGnW5V+4PYPvvHC2M=;
        b=d/jAaL7JXr0wiMMY9j4wHH19IcfHVlYYsqg9iq1ztsne/e6HvwN+Wg7r9ImYC8lDcLFVG/
        3Jg8EW5FHwJMaVDiNQX8YGjgNZyLOt5nK+hLB3OB4bChYIKZ7TrRhKWE7mfsi10ZDOQBrK
        GwQPC6w2ROxLp9ZpqR/pmmyvstA0VcU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-3df8Gv1NMRGRwL9hfhEsCw-1; Thu, 07 Jul 2022 12:17:05 -0400
X-MC-Unique: 3df8Gv1NMRGRwL9hfhEsCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94A0C811E75;
        Thu,  7 Jul 2022 16:17:05 +0000 (UTC)
Received: from gondolin.fritz.box (unknown [10.39.192.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CF1E2166B26;
        Thu,  7 Jul 2022 16:17:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC v2 2/2] qtests/arm: add some mte tests
Date:   Thu,  7 Jul 2022 18:16:56 +0200
Message-Id: <20220707161656.41664-3-cohuck@redhat.com>
In-Reply-To: <20220707161656.41664-1-cohuck@redhat.com>
References: <20220707161656.41664-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 tests/qtest/arm-cpu-features.c | 77 ++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index 5a145273860c..466be857d391 100644
--- a/tests/qtest/arm-cpu-features.c
+++ b/tests/qtest/arm-cpu-features.c
@@ -22,6 +22,7 @@
 
 #define MACHINE     "-machine virt,gic-version=max -accel tcg "
 #define MACHINE_KVM "-machine virt,gic-version=max -accel kvm -accel tcg "
+#define MACHINE_MTE "-machine virt,gic-version=max,mte=on -accel tcg "
 #define QUERY_HEAD  "{ 'execute': 'query-cpu-model-expansion', " \
                     "  'arguments': { 'type': 'full', "
 #define QUERY_TAIL  "}}"
@@ -155,6 +156,18 @@ static bool resp_get_feature(QDict *resp, const char *feature)
     g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
 })
 
+#define resp_assert_feature_str(resp, feature, expected_value)         \
+({                                                                     \
+    QDict *_props;                                                     \
+                                                                       \
+    g_assert(_resp);                                                   \
+    g_assert(resp_has_props(_resp));                                   \
+    _props = resp_get_props(_resp);                                    \
+    g_assert(qdict_get(_props, feature));                              \
+    g_assert_cmpstr(qdict_get_try_str(_props, feature), ==,            \
+                    expected_value);                                   \
+})
+
 #define assert_feature(qts, cpu_type, feature, expected_value)         \
 ({                                                                     \
     QDict *_resp;                                                      \
@@ -165,6 +178,16 @@ static bool resp_get_feature(QDict *resp, const char *feature)
     qobject_unref(_resp);                                              \
 })
 
+#define assert_feature_str(qts, cpu_type, feature, expected_value)     \
+({                                                                     \
+    QDict *_resp;                                                      \
+                                                                       \
+    _resp = do_query_no_props(qts, cpu_type);                          \
+    g_assert(_resp);                                                   \
+    resp_assert_feature_str(_resp, feature, expected_value);           \
+    qobject_unref(_resp);                                              \
+})
+
 #define assert_set_feature(qts, cpu_type, feature, value)              \
 ({                                                                     \
     const char *_fmt = (value) ? "{ %s: true }" : "{ %s: false }";     \
@@ -176,6 +199,16 @@ static bool resp_get_feature(QDict *resp, const char *feature)
     qobject_unref(_resp);                                              \
 })
 
+#define assert_set_feature_str(qts, cpu_type, feature, value, _fmt)    \
+({                                                                     \
+    QDict *_resp;                                                      \
+                                                                       \
+    _resp = do_query(qts, cpu_type, _fmt, feature);                    \
+    g_assert(_resp);                                                   \
+    resp_assert_feature_str(_resp, feature, value);                    \
+    qobject_unref(_resp);                                              \
+})
+
 #define assert_has_feature_enabled(qts, cpu_type, feature)             \
     assert_feature(qts, cpu_type, feature, true)
 
@@ -412,6 +445,24 @@ static void sve_tests_sve_off_kvm(const void *data)
     qtest_quit(qts);
 }
 
+static void mte_tests_tag_memory_on(const void *data)
+{
+    QTestState *qts;
+
+    qts = qtest_init(MACHINE_MTE "-cpu max");
+
+    /*
+     * With tag memory, "mte" should default to on, and explicitly specifying
+     * either on or off should be fine.
+     */
+    assert_has_feature(qts, "max", "mte");
+
+    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
+    assert_set_feature_str(qts, "max", "mte", "on", "{ 'mte': 'on' }");
+
+    qtest_quit(qts);
+}
+
 static void pauth_tests_default(QTestState *qts, const char *cpu_type)
 {
     assert_has_feature_enabled(qts, cpu_type, "pauth");
@@ -424,6 +475,21 @@ static void pauth_tests_default(QTestState *qts, const char *cpu_type)
                  "{ 'pauth': false, 'pauth-impdef': true }");
 }
 
+static void mte_tests_default(QTestState *qts, const char *cpu_type)
+{
+    assert_has_feature(qts, cpu_type, "mte");
+
+    /*
+     * Without tag memory, mte will be off under tcg.
+     * Explicitly enabling it yields an error.
+     */
+    assert_has_feature(qts, cpu_type, "mte");
+
+    assert_set_feature_str(qts, "max", "mte", "off", "{ 'mte': 'off' }");
+    assert_error(qts, cpu_type, "mte=on requires tag memory",
+                 "{ 'mte': 'on' }");
+}
+
 static void test_query_cpu_model_expansion(const void *data)
 {
     QTestState *qts;
@@ -473,6 +539,7 @@ static void test_query_cpu_model_expansion(const void *data)
 
         sve_tests_default(qts, "max");
         pauth_tests_default(qts, "max");
+        mte_tests_default(qts, "max");
 
         /* Test that features that depend on KVM generate errors without. */
         assert_error(qts, "max",
@@ -499,6 +566,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
     if (g_str_equal(qtest_get_arch(), "aarch64")) {
         bool kvm_supports_steal_time;
         bool kvm_supports_sve;
+        bool kvm_supports_mte;
         char max_name[8], name[8];
         uint32_t max_vq, vq;
         uint64_t vls;
@@ -523,10 +591,12 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
          */
         assert_has_feature(qts, "host", "kvm-steal-time");
         assert_has_feature(qts, "host", "sve");
+        assert_has_feature(qts, "host", "mte");
 
         resp = do_query_no_props(qts, "host");
         kvm_supports_steal_time = resp_get_feature(resp, "kvm-steal-time");
         kvm_supports_sve = resp_get_feature(resp, "sve");
+        kvm_supports_mte = resp_get_feature(resp, "mte");
         vls = resp_get_sve_vls(resp);
         qobject_unref(resp);
 
@@ -592,6 +662,11 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
         } else {
             g_assert(vls == 0);
         }
+        if (kvm_supports_mte) {
+            /* If we have mte then we should be able to toggle it. */
+            assert_set_feature(qts, "host", "mte", false);
+            assert_set_feature(qts, "host", "mte", true);
+        }
     } else {
         assert_has_not_feature(qts, "host", "aarch64");
         assert_has_not_feature(qts, "host", "pmu");
@@ -630,6 +705,8 @@ int main(int argc, char **argv)
                             NULL, sve_tests_sve_off);
         qtest_add_data_func("/arm/kvm/query-cpu-model-expansion/sve-off",
                             NULL, sve_tests_sve_off_kvm);
+        qtest_add_data_func("/arm/max/query-cpu-model-expansion/tag-memory",
+                            NULL, mte_tests_tag_memory_on);
     }
 
     return g_test_run();
-- 
2.35.3

