Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C30693C8F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBMCxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBMCxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF3AFF0D
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhzdc6EJT0N0Bv1boe7/qcEnx6KstP3OPe2f+kkOVWo=;
        b=AfweUPDnPY6XgziB34UQcXPZj5e8URg1wA25pgvblcnEIkkrkrnWczAvbHqtR4bfdJua2+
        xqu0HvKV8mIeSJf3+GDNdT4sTM1o7kdWcQrthNmLgWCb5Q1uk1H7e6x3xXKlmyWylA6MmK
        0pSDtiaWJat2XST26eVcHE7gpGMwWZ0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-eBGu6I0WM0CQKW3WXC5u-A-1; Sun, 12 Feb 2023 21:52:16 -0500
X-MC-Unique: eBGu6I0WM0CQKW3WXC5u-A-1
Received: by mail-wm1-f70.google.com with SMTP id p14-20020a05600c468e00b003e0107732f4so5447877wmo.1
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhzdc6EJT0N0Bv1boe7/qcEnx6KstP3OPe2f+kkOVWo=;
        b=I94hFoUXnmYl6G4ZXe2vOqX2jsoIa/dNytrwah7vIndql/zC6+8ST0VcZ1efA5EmPs
         eJ30QflldeCdgJNeXMrrTUYpccHRnOlkjOwuhnTBbykE+WvtaDKQOWBwqAYigqTCNiGf
         NPytGp7CLrIVTYr4Qfx2/St/pjAVISBVm57T0BzLhYzVYPBRhA1dD8V2R2s03AHd+QC6
         x6NcHFanQzRyfW2C2Sr7EnmENqA8lCR7PnlcTS+DO1PBBtmAVGFxa+lRhABeZ3RRra54
         UcfRpN2cFNYeg90T3feWE6B70MrxvqOWBDvo6qwafP4iJELX+axksH6q7/1yaYvQqsH5
         guOw==
X-Gm-Message-State: AO0yUKXTCb+VotFjAxFJnDTWXFjENT4wsaOYMDrSPa0a/+UNeoQEF5Rl
        qfz6nJ+RETGh4Xw5RgCQeautAXjURnE8TR+GR2+BSM0+J2i68bBZlDGK8tmLrIo1VsmFhKhUD/f
        EEBhmwvpWMAbm
X-Received: by 2002:a5d:510a:0:b0:2c4:682:5639 with SMTP id s10-20020a5d510a000000b002c406825639mr14015586wrt.1.1676256734875;
        Sun, 12 Feb 2023 18:52:14 -0800 (PST)
X-Google-Smtp-Source: AK7set+ySICMoIh7WndZxB4dnwWB0jeRG+Uwzsjss38R+0TpSubmPvyNgw0nsv+woiBXYf14m4kEaw==
X-Received: by 2002:a5d:510a:0:b0:2c4:682:5639 with SMTP id s10-20020a5d510a000000b002c406825639mr14015573wrt.1.1676256734607;
        Sun, 12 Feb 2023 18:52:14 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id s12-20020a5d510c000000b002c55bbeefc2sm398643wrt.22.2023.02.12.18.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:14 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        ling xu <ling1.xu@intel.com>, Zhou Zhao <zhou.zhao@intel.com>,
        Jun Jin <jun.i.jin@intel.com>
Subject: [PULL 13/22] Update bench-code for addressing CI problem
Date:   Mon, 13 Feb 2023 03:51:41 +0100
Message-Id: <20230213025150.71537-14-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ling xu <ling1.xu@intel.com>

Unit test code is in test-xbzrle.c, and benchmark code is in xbzrle-bench.c
for performance benchmarking. we have modified xbzrle-bench.c to address
CI problem.

Signed-off-by: ling xu <ling1.xu@intel.com>
Co-authored-by: Zhou Zhao <zhou.zhao@intel.com>
Co-authored-by: Jun Jin <jun.i.jin@intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 tests/bench/xbzrle-bench.c | 469 +++++++++++++++++++++++++++++++++++++
 tests/unit/test-xbzrle.c   |  39 ++-
 tests/bench/meson.build    |   6 +
 3 files changed, 509 insertions(+), 5 deletions(-)
 create mode 100644 tests/bench/xbzrle-bench.c

diff --git a/tests/bench/xbzrle-bench.c b/tests/bench/xbzrle-bench.c
new file mode 100644
index 0000000000..8848a3a32d
--- /dev/null
+++ b/tests/bench/xbzrle-bench.c
@@ -0,0 +1,469 @@
+/*
+ * Xor Based Zero Run Length Encoding unit tests.
+ *
+ * Copyright 2013 Red Hat, Inc. and/or its affiliates
+ *
+ * Authors:
+ *  Orit Wasserman  <owasserm@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+#include "qemu/osdep.h"
+#include "qemu/cutils.h"
+#include "../migration/xbzrle.h"
+
+#if defined(CONFIG_AVX512BW_OPT)
+#define XBZRLE_PAGE_SIZE 4096
+static bool is_cpu_support_avx512bw;
+#include "qemu/cpuid.h"
+static void __attribute__((constructor)) init_cpu_flag(void)
+{
+    unsigned max = __get_cpuid_max(0, NULL);
+    int a, b, c, d;
+    is_cpu_support_avx512bw = false;
+    if (max >= 1) {
+        __cpuid(1, a, b, c, d);
+         /* We must check that AVX is not just available, but usable.  */
+        if ((c & bit_OSXSAVE) && (c & bit_AVX) && max >= 7) {
+            int bv;
+            __asm("xgetbv" : "=a"(bv), "=d"(d) : "c"(0));
+            __cpuid_count(7, 0, a, b, c, d);
+           /* 0xe6:
+            *  XCR0[7:5] = 111b (OPMASK state, upper 256-bit of ZMM0-ZMM15
+            *                    and ZMM16-ZMM31 state are enabled by OS)
+            *  XCR0[2:1] = 11b (XMM state and YMM state are enabled by OS)
+            */
+            if ((bv & 0xe6) == 0xe6 && (b & bit_AVX512BW)) {
+                is_cpu_support_avx512bw = true;
+            }
+        }
+    }
+    return ;
+}
+
+struct ResTime {
+    float t_raw;
+    float t_512;
+};
+
+
+/* Function prototypes
+int xbzrle_encode_buffer_avx512(uint8_t *old_buf, uint8_t *new_buf, int slen,
+                                uint8_t *dst, int dlen);
+*/
+static void encode_decode_zero(struct ResTime *res)
+{
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    int i = 0;
+    int dlen = 0, dlen512 = 0;
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
+
+    for (i = diff_len; i > 0; i--) {
+        buffer[1000 + i] = i;
+        buffer512[1000 + i] = i;
+    }
+
+    buffer[1000 + diff_len + 3] = 103;
+    buffer[1000 + diff_len + 5] = 105;
+
+    buffer512[1000 + diff_len + 3] = 103;
+    buffer512[1000 + diff_len + 5] = 105;
+
+    /* encode zero page */
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    dlen = xbzrle_encode_buffer(buffer, buffer, XBZRLE_PAGE_SIZE, compressed,
+                       XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    g_assert(dlen == 0);
+
+    t_start512 = clock();
+    dlen512 = xbzrle_encode_buffer_avx512(buffer512, buffer512, XBZRLE_PAGE_SIZE,
+                                       compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    g_assert(dlen512 == 0);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(buffer);
+    g_free(compressed);
+    g_free(buffer512);
+    g_free(compressed512);
+
+}
+
+static void test_encode_decode_zero_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_zero(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("Zero test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+
+static void encode_decode_unchanged(struct ResTime *res)
+{
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    int i = 0;
+    int dlen = 0, dlen512 = 0;
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
+
+    for (i = diff_len; i > 0; i--) {
+        test[1000 + i] = i + 4;
+        test512[1000 + i] = i + 4;
+    }
+
+    test[1000 + diff_len + 3] = 107;
+    test[1000 + diff_len + 5] = 109;
+
+    test512[1000 + diff_len + 3] = 107;
+    test512[1000 + diff_len + 5] = 109;
+
+    /* test unchanged buffer */
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    dlen = xbzrle_encode_buffer(test, test, XBZRLE_PAGE_SIZE, compressed,
+                                XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    g_assert(dlen == 0);
+
+    t_start512 = clock();
+    dlen512 = xbzrle_encode_buffer_avx512(test512, test512, XBZRLE_PAGE_SIZE,
+                                       compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    g_assert(dlen512 == 0);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(test);
+    g_free(compressed);
+    g_free(test512);
+    g_free(compressed512);
+
+}
+
+static void test_encode_decode_unchanged_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_unchanged(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("Unchanged test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+
+static void encode_decode_1_byte(struct ResTime *res)
+{
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc(XBZRLE_PAGE_SIZE);
+    int dlen = 0, rc = 0, dlen512 = 0, rc512 = 0;
+    uint8_t buf[2];
+    uint8_t buf512[2];
+
+    test[XBZRLE_PAGE_SIZE - 1] = 1;
+    test512[XBZRLE_PAGE_SIZE - 1] = 1;
+
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    dlen = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+                       XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    g_assert(dlen == (uleb128_encode_small(&buf[0], 4095) + 2));
+
+    rc = xbzrle_decode_buffer(compressed, dlen, buffer, XBZRLE_PAGE_SIZE);
+    g_assert(rc == XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test, buffer, XBZRLE_PAGE_SIZE) == 0);
+
+    t_start512 = clock();
+    dlen512 = xbzrle_encode_buffer_avx512(buffer512, test512, XBZRLE_PAGE_SIZE,
+                                       compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    g_assert(dlen512 == (uleb128_encode_small(&buf512[0], 4095) + 2));
+
+    rc512 = xbzrle_decode_buffer(compressed512, dlen512, buffer512,
+                                 XBZRLE_PAGE_SIZE);
+    g_assert(rc512 == XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test512, buffer512, XBZRLE_PAGE_SIZE) == 0);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(buffer);
+    g_free(compressed);
+    g_free(test);
+    g_free(buffer512);
+    g_free(compressed512);
+    g_free(test512);
+
+}
+
+static void test_encode_decode_1_byte_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_1_byte(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("1 byte test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+
+static void encode_decode_overflow(struct ResTime *res)
+{
+    uint8_t *compressed = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *test512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    int i = 0, rc = 0, rc512 = 0;
+
+    for (i = 0; i < XBZRLE_PAGE_SIZE / 2 - 1; i++) {
+        test[i * 2] = 1;
+        test512[i * 2] = 1;
+    }
+
+    /* encode overflow */
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    rc = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+                              XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    g_assert(rc == -1);
+
+    t_start512 = clock();
+    rc512 = xbzrle_encode_buffer_avx512(buffer512, test512, XBZRLE_PAGE_SIZE,
+                                     compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    g_assert(rc512 == -1);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(buffer);
+    g_free(compressed);
+    g_free(test);
+    g_free(buffer512);
+    g_free(compressed512);
+    g_free(test512);
+
+}
+
+static void test_encode_decode_overflow_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_overflow(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("Overflow test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+
+static void encode_decode_range_avx512(struct ResTime *res)
+{
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *test512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    int i = 0, rc = 0, rc512 = 0;
+    int dlen = 0, dlen512 = 0;
+
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1006);
+
+    for (i = diff_len; i > 0; i--) {
+        buffer[1000 + i] = i;
+        test[1000 + i] = i + 4;
+        buffer512[1000 + i] = i;
+        test512[1000 + i] = i + 4;
+    }
+
+    buffer[1000 + diff_len + 3] = 103;
+    test[1000 + diff_len + 3] = 107;
+
+    buffer[1000 + diff_len + 5] = 105;
+    test[1000 + diff_len + 5] = 109;
+
+    buffer512[1000 + diff_len + 3] = 103;
+    test512[1000 + diff_len + 3] = 107;
+
+    buffer512[1000 + diff_len + 5] = 105;
+    test512[1000 + diff_len + 5] = 109;
+
+    /* test encode/decode */
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    dlen = xbzrle_encode_buffer(test, buffer, XBZRLE_PAGE_SIZE, compressed,
+                                XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    rc = xbzrle_decode_buffer(compressed, dlen, test, XBZRLE_PAGE_SIZE);
+    g_assert(rc < XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test, buffer, XBZRLE_PAGE_SIZE) == 0);
+
+    t_start512 = clock();
+    dlen512 = xbzrle_encode_buffer_avx512(test512, buffer512, XBZRLE_PAGE_SIZE,
+                                       compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    rc512 = xbzrle_decode_buffer(compressed512, dlen512, test512, XBZRLE_PAGE_SIZE);
+    g_assert(rc512 < XBZRLE_PAGE_SIZE);
+    g_assert(memcmp(test512, buffer512, XBZRLE_PAGE_SIZE) == 0);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(buffer);
+    g_free(compressed);
+    g_free(test);
+    g_free(buffer512);
+    g_free(compressed512);
+    g_free(test512);
+
+}
+
+static void test_encode_decode_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_range_avx512(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("Encode decode test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+
+static void encode_decode_random(struct ResTime *res)
+{
+    uint8_t *buffer = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *test = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *buffer512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    uint8_t *compressed512 = g_malloc(XBZRLE_PAGE_SIZE);
+    uint8_t *test512 = g_malloc0(XBZRLE_PAGE_SIZE);
+    int i = 0, rc = 0, rc512 = 0;
+    int dlen = 0, dlen512 = 0;
+
+    int diff_len = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1);
+    /* store the index of diff */
+    int dirty_index[diff_len];
+    for (int j = 0; j < diff_len; j++) {
+        dirty_index[j] = g_test_rand_int_range(0, XBZRLE_PAGE_SIZE - 1);
+    }
+    for (i = diff_len - 1; i >= 0; i--) {
+        buffer[dirty_index[i]] = i;
+        test[dirty_index[i]] = i + 4;
+        buffer512[dirty_index[i]] = i;
+        test512[dirty_index[i]] = i + 4;
+    }
+
+    time_t t_start, t_end, t_start512, t_end512;
+    t_start = clock();
+    dlen = xbzrle_encode_buffer(test, buffer, XBZRLE_PAGE_SIZE, compressed,
+                                XBZRLE_PAGE_SIZE);
+    t_end = clock();
+    float time_val = difftime(t_end, t_start);
+    rc = xbzrle_decode_buffer(compressed, dlen, test, XBZRLE_PAGE_SIZE);
+    g_assert(rc < XBZRLE_PAGE_SIZE);
+
+    t_start512 = clock();
+    dlen512 = xbzrle_encode_buffer_avx512(test512, buffer512, XBZRLE_PAGE_SIZE,
+                                       compressed512, XBZRLE_PAGE_SIZE);
+    t_end512 = clock();
+    float time_val512 = difftime(t_end512, t_start512);
+    rc512 = xbzrle_decode_buffer(compressed512, dlen512, test512, XBZRLE_PAGE_SIZE);
+    g_assert(rc512 < XBZRLE_PAGE_SIZE);
+
+    res->t_raw = time_val;
+    res->t_512 = time_val512;
+
+    g_free(buffer);
+    g_free(compressed);
+    g_free(test);
+    g_free(buffer512);
+    g_free(compressed512);
+    g_free(test512);
+
+}
+
+static void test_encode_decode_random_avx512(void)
+{
+    int i;
+    float time_raw = 0.0, time_512 = 0.0;
+    struct ResTime res;
+    for (i = 0; i < 10000; i++) {
+        encode_decode_random(&res);
+        time_raw += res.t_raw;
+        time_512 += res.t_512;
+    }
+    printf("Random test:\n");
+    printf("Raw xbzrle_encode time is %f ms\n", time_raw);
+    printf("512 xbzrle_encode time is %f ms\n", time_512);
+}
+#endif
+
+int main(int argc, char **argv)
+{
+    g_test_init(&argc, &argv, NULL);
+    g_test_rand_int();
+    #if defined(CONFIG_AVX512BW_OPT)
+    if (likely(is_cpu_support_avx512bw)) {
+        g_test_add_func("/xbzrle/encode_decode_zero", test_encode_decode_zero_avx512);
+        g_test_add_func("/xbzrle/encode_decode_unchanged",
+                        test_encode_decode_unchanged_avx512);
+        g_test_add_func("/xbzrle/encode_decode_1_byte", test_encode_decode_1_byte_avx512);
+        g_test_add_func("/xbzrle/encode_decode_overflow",
+                        test_encode_decode_overflow_avx512);
+        g_test_add_func("/xbzrle/encode_decode", test_encode_decode_avx512);
+        g_test_add_func("/xbzrle/encode_decode_random", test_encode_decode_random_avx512);
+    }
+    #endif
+    return g_test_run();
+}
diff --git a/tests/unit/test-xbzrle.c b/tests/unit/test-xbzrle.c
index ef951b6e54..547046d093 100644
--- a/tests/unit/test-xbzrle.c
+++ b/tests/unit/test-xbzrle.c
@@ -16,6 +16,35 @@
 
 #define XBZRLE_PAGE_SIZE 4096
 
+int (*xbzrle_encode_buffer_func)(uint8_t *, uint8_t *, int,
+     uint8_t *, int) = xbzrle_encode_buffer;
+#if defined(CONFIG_AVX512BW_OPT)
+#include "qemu/cpuid.h"
+static void __attribute__((constructor)) init_cpu_flag(void)
+{
+    unsigned max = __get_cpuid_max(0, NULL);
+    int a, b, c, d;
+    if (max >= 1) {
+        __cpuid(1, a, b, c, d);
+         /* We must check that AVX is not just available, but usable.  */
+        if ((c & bit_OSXSAVE) && (c & bit_AVX) && max >= 7) {
+            int bv;
+            __asm("xgetbv" : "=a"(bv), "=d"(d) : "c"(0));
+            __cpuid_count(7, 0, a, b, c, d);
+           /* 0xe6:
+            *  XCR0[7:5] = 111b (OPMASK state, upper 256-bit of ZMM0-ZMM15
+            *                    and ZMM16-ZMM31 state are enabled by OS)
+            *  XCR0[2:1] = 11b (XMM state and YMM state are enabled by OS)
+            */
+            if ((bv & 0xe6) == 0xe6 && (b & bit_AVX512BW)) {
+                xbzrle_encode_buffer_func = xbzrle_encode_buffer_avx512;
+            }
+        }
+    }
+    return ;
+}
+#endif
+
 static void test_uleb(void)
 {
     uint32_t i, val;
@@ -54,7 +83,7 @@ static void test_encode_decode_zero(void)
     buffer[1000 + diff_len + 5] = 105;
 
     /* encode zero page */
-    dlen = xbzrle_encode_buffer(buffer, buffer, XBZRLE_PAGE_SIZE, compressed,
+    dlen = xbzrle_encode_buffer_func(buffer, buffer, XBZRLE_PAGE_SIZE, compressed,
                        XBZRLE_PAGE_SIZE);
     g_assert(dlen == 0);
 
@@ -78,7 +107,7 @@ static void test_encode_decode_unchanged(void)
     test[1000 + diff_len + 5] = 109;
 
     /* test unchanged buffer */
-    dlen = xbzrle_encode_buffer(test, test, XBZRLE_PAGE_SIZE, compressed,
+    dlen = xbzrle_encode_buffer_func(test, test, XBZRLE_PAGE_SIZE, compressed,
                                 XBZRLE_PAGE_SIZE);
     g_assert(dlen == 0);
 
@@ -96,7 +125,7 @@ static void test_encode_decode_1_byte(void)
 
     test[XBZRLE_PAGE_SIZE - 1] = 1;
 
-    dlen = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+    dlen = xbzrle_encode_buffer_func(buffer, test, XBZRLE_PAGE_SIZE, compressed,
                        XBZRLE_PAGE_SIZE);
     g_assert(dlen == (uleb128_encode_small(&buf[0], 4095) + 2));
 
@@ -121,7 +150,7 @@ static void test_encode_decode_overflow(void)
     }
 
     /* encode overflow */
-    rc = xbzrle_encode_buffer(buffer, test, XBZRLE_PAGE_SIZE, compressed,
+    rc = xbzrle_encode_buffer_func(buffer, test, XBZRLE_PAGE_SIZE, compressed,
                               XBZRLE_PAGE_SIZE);
     g_assert(rc == -1);
 
@@ -152,7 +181,7 @@ static void encode_decode_range(void)
     test[1000 + diff_len + 5] = 109;
 
     /* test encode/decode */
-    dlen = xbzrle_encode_buffer(test, buffer, XBZRLE_PAGE_SIZE, compressed,
+    dlen = xbzrle_encode_buffer_func(test, buffer, XBZRLE_PAGE_SIZE, compressed,
                                 XBZRLE_PAGE_SIZE);
 
     rc = xbzrle_decode_buffer(compressed, dlen, test, XBZRLE_PAGE_SIZE);
diff --git a/tests/bench/meson.build b/tests/bench/meson.build
index 279a8fcc33..7477a1f401 100644
--- a/tests/bench/meson.build
+++ b/tests/bench/meson.build
@@ -3,6 +3,12 @@ qht_bench = executable('qht-bench',
                        sources: 'qht-bench.c',
                        dependencies: [qemuutil])
 
+if have_system
+xbzrle_bench = executable('xbzrle-bench',
+                       sources: 'xbzrle-bench.c',
+                       dependencies: [qemuutil,migration])
+endif
+
 executable('atomic_add-bench',
            sources: files('atomic_add-bench.c'),
            dependencies: [qemuutil],
-- 
2.39.1

