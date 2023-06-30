Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52539743CCF
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjF3NcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjF3Nb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:31:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 316001FD8
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 06:31:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E9A6D75;
        Fri, 30 Jun 2023 06:32:41 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45D473F64C;
        Fri, 30 Jun 2023 06:31:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: [PATCH RESEND kvmtool 4/4] Add --loglevel argument for the run command
Date:   Fri, 30 Jun 2023 14:31:34 +0100
Message-ID: <20230630133134.65284-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630133134.65284-1-alexandru.elisei@arm.com>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
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

Add --loglevel command line argument, with the possible values of 'error',
'warning', 'info' or 'debug' to control what messages kvmtool displays. The
argument functions similarly to the Linux kernel parameter, when lower
verbosity levels hide all message with a higher verbosity (for example,
'warning' hides info and debug messages, allows warning and error
messsages).

The default level is 'info', to match the current behaviour. --debug has
been kept as a legacy option, which might be removed in the future.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c      | 32 ++++++++++++++++++++++++++++----
 include/kvm/util.h |  9 +++++++--
 util/util.c        |  9 +++++++++
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 79d031777c26..2e4378819f00 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -58,8 +58,7 @@
 __thread struct kvm_cpu *current_kvm_cpu;
 
 static int  kvm_run_wrapper;
-
-bool do_debug_print = false;
+int loglevel = LOGLEVEL_INFO;
 
 static const char * const run_usage[] = {
 	"lkvm run [<options>] [<kernel image>]",
@@ -146,6 +145,27 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int loglevel_parser(const struct option *opt, const char *arg, int unset)
+{
+	if (strcmp(opt->long_name, "debug") == 0) {
+		loglevel = LOGLEVEL_DEBUG;
+		return 0;
+	}
+
+	if (strcmp(arg, "debug") == 0)
+		loglevel = LOGLEVEL_DEBUG;
+	else if (strcmp(arg, "info") == 0)
+		loglevel = LOGLEVEL_INFO;
+	else if (strcmp(arg, "warning") == 0)
+		loglevel = LOGLEVEL_WARNING;
+	else if (strcmp(arg, "error") == 0)
+		loglevel = LOGLEVEL_ERROR;
+	else
+		die("Unknown loglevel: %s", arg);
+
+	return 0;
+}
+
 #ifndef OPT_ARCH_RUN
 #define OPT_ARCH_RUN(...)
 #endif
@@ -215,6 +235,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 		     VIRTIO_TRANS_OPT_HELP_SHORT,		        \
 		     "Type of virtio transport",			\
 		     virtio_transport_parser, NULL),			\
+	OPT_CALLBACK('\0', "loglevel", NULL, "[error|warning|info|debug]",\
+			"Set the verbosity level", loglevel_parser, NULL),\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
@@ -241,8 +263,10 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 		     vfio_device_parser, kvm),				\
 									\
 	OPT_GROUP("Debug options:"),					\
-	OPT_BOOLEAN('\0', "debug", &do_debug_print,			\
-			"Enable debug messages"),			\
+	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
+			"Enable debug messages (deprecated, use "	\
+			"--loglevel=debug instead)",			\
+			loglevel_parser, NULL),				\
 	OPT_BOOLEAN('\0', "debug-single-step", &(cfg)->single_step,	\
 			"Enable single stepping"),			\
 	OPT_BOOLEAN('\0', "debug-ioport", &(cfg)->ioport_debug,		\
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 6920ce2630ad..e9d63c184752 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -32,7 +32,10 @@
 #endif
 #endif
 
-extern bool do_debug_print;
+#define LOGLEVEL_ERROR		0
+#define LOGLEVEL_WARNING	1
+#define LOGLEVEL_INFO		2
+#define LOGLEVEL_DEBUG		3
 
 #define PROT_RW (PROT_READ|PROT_WRITE)
 #define MAP_ANON_NORESERVE (MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE)
@@ -45,9 +48,11 @@ extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void __pr_debug(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
+extern int loglevel;
+
 #define pr_debug(fmt, ...)						\
 	do {								\
-		if (do_debug_print)					\
+		if (loglevel >= LOGLEVEL_DEBUG)				\
 			__pr_debug("(%s) %s:%d: " fmt, __FILE__,	\
 				__func__, __LINE__, ##__VA_ARGS__);	\
 	} while (0)
diff --git a/util/util.c b/util/util.c
index e3b36f67f899..962e8d4edb21 100644
--- a/util/util.c
+++ b/util/util.c
@@ -56,6 +56,9 @@ void pr_err(const char *err, ...)
 {
 	va_list params;
 
+	if (loglevel < LOGLEVEL_ERROR)
+		return;
+
 	va_start(params, err);
 	error_builtin(err, params);
 	va_end(params);
@@ -65,6 +68,9 @@ void pr_warning(const char *warn, ...)
 {
 	va_list params;
 
+	if (loglevel < LOGLEVEL_WARNING)
+		return;
+
 	va_start(params, warn);
 	warn_builtin(warn, params);
 	va_end(params);
@@ -74,6 +80,9 @@ void pr_info(const char *info, ...)
 {
 	va_list params;
 
+	if (loglevel < LOGLEVEL_INFO)
+		return;
+
 	va_start(params, info);
 	info_builtin(info, params);
 	va_end(params);
-- 
2.41.0

