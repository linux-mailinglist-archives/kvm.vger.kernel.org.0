Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44C9666024
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjAKQPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 11:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjAKQP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 11:15:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E613F20
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 08:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673453676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7U3BISuSPwAWuMpwLqgxRRbJoso0xAD3vBoILCXk1A=;
        b=Y10270rgFHPQNRYR4MhYYt7D/mgVoXHPWD2pMwPf1kvtC7lXLnFzJUbuOGEJGhsE3OhZEG
        QzNTdeljSx/Tj7fD7hSC52q+Jun/KMeBvQIGSiX6JAxELgBYm8h+pKyIHsuYwbxzEdgENv
        hoIVAoDDOXLVxaDM+Ics/3tCSCrnPdA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-VmhDB6ldPOS3ANR5C0iavw-1; Wed, 11 Jan 2023 11:13:30 -0500
X-MC-Unique: VmhDB6ldPOS3ANR5C0iavw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F6D51C08797;
        Wed, 11 Jan 2023 16:13:30 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.195.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E00A52026D68;
        Wed, 11 Jan 2023 16:13:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v4 2/2] qtests/arm: add some mte tests
Date:   Wed, 11 Jan 2023 17:13:17 +0100
Message-Id: <20230111161317.52250-3-cohuck@redhat.com>
In-Reply-To: <20230111161317.52250-1-cohuck@redhat.com>
References: <20230111161317.52250-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 tests/qtest/arm-cpu-features.c | 76 ++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index 5a145273860c..e264d2178a8b 100644
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
@@ -516,6 +583,13 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
         assert_set_feature(qts, "host", "pmu", false);
         assert_set_feature(qts, "host", "pmu", true);
 
+        /*
+         * Unfortunately, there's no easy way to test whether this instance
+         * of KVM supports MTE. So we can only assert that the feature
+         * is present, but not whether it can be toggled.
+         */
+        assert_has_feature(qts, "host", "mte");
+
         /*
          * Some features would be enabled by default, but they're disabled
          * because this instance of KVM doesn't support them. Test that the
@@ -630,6 +704,8 @@ int main(int argc, char **argv)
                             NULL, sve_tests_sve_off);
         qtest_add_data_func("/arm/kvm/query-cpu-model-expansion/sve-off",
                             NULL, sve_tests_sve_off_kvm);
+        qtest_add_data_func("/arm/max/query-cpu-model-expansion/tag-memory",
+                            NULL, mte_tests_tag_memory_on);
     }
 
     return g_test_run();
-- 
2.39.0

