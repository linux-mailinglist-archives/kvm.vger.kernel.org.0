Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48174B3DB
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 17:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjGGPLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 11:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjGGPLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 11:11:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BDDF210A
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 08:11:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C6841063;
        Fri,  7 Jul 2023 08:12:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583B13F762;
        Fri,  7 Jul 2023 08:11:45 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 3/4] util: Use __pr_debug() instead of pr_info() to print debug messages
Date:   Fri,  7 Jul 2023 16:11:18 +0100
Message-ID: <20230707151119.81208-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230707151119.81208-1-alexandru.elisei@arm.com>
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pr_debug() is special, because it can be suppressed with a command line
argument, and because it needs to be a macro to capture the correct
filename, function name and line number. Display debug messages with the
prefix "Debug", to make it clear that those aren't informational messages.

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changelog:

- Added Reviewed-by.
- Changed parameter name to the pr_debug functions to be "debug" instead of
  "info".

 include/kvm/util.h |  3 ++-
 util/util.c        | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index f51f370d2b37..68d568d0fa9a 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -42,12 +42,13 @@ extern void die_perror(const char *s) NORETURN;
 extern void pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void pr_warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)));
+extern void __pr_debug(const char *debug, ...) __attribute__((format (printf, 1, 2)));
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 #define pr_debug(fmt, ...)						\
 	do {								\
 		if (do_debug_print)					\
-			pr_info("(%s) %s:%d: " fmt, __FILE__,		\
+			__pr_debug("(%s) %s:%d: " fmt, __FILE__,	\
 				__func__, __LINE__, ##__VA_ARGS__);	\
 	} while (0)
 
diff --git a/util/util.c b/util/util.c
index f59f26e1581c..7cf62edc3d34 100644
--- a/util/util.c
+++ b/util/util.c
@@ -38,6 +38,11 @@ static void info_builtin(const char *info, va_list params)
 	report(" Info: ", info, params);
 }
 
+static void debug_builtin(const char *debug, va_list params)
+{
+	report(" Debug: ", debug, params);
+}
+
 void die(const char *err, ...)
 {
 	va_list params;
@@ -74,6 +79,16 @@ void pr_info(const char *info, ...)
 	va_end(params);
 }
 
+/* Do not call directly; call pr_debug() instead. */
+void __pr_debug(const char *debug, ...)
+{
+	va_list params;
+
+	va_start(params, debug);
+	debug_builtin(debug, params);
+	va_end(params);
+}
+
 void die_perror(const char *s)
 {
 	perror(s);
-- 
2.41.0

