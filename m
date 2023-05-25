Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB1710E8C
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 16:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241604AbjEYOsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 10:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbjEYOsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 10:48:36 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D974D195
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 07:48:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4E521650;
        Thu, 25 May 2023 07:49:19 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8EA3F67D;
        Thu, 25 May 2023 07:48:33 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/2] option parsing: fix type of empty .argh parameter
Date:   Thu, 25 May 2023 15:48:26 +0100
Message-Id: <20230525144827.679651-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230525144827.679651-1-andre.przywara@arm.com>
References: <20230525144827.679651-1-andre.przywara@arm.com>
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

The "force-pci" and "virtio-legacy" option definitions were using '\0'
to initialise an unused ".argh" member, even though this is a string.
This triggers warnings with some compilers like clang.
Also, for some odd reason, the .argh member was not named explicitly in
the option helper macros initialisation, which made this problem harder
to locate.

Sanitise the option macros by always using designated initialisers for
each member, and use the correct empty string for the "force-pci" and
"virtio-legacy" options.

This fixes warnings (promoted to errors) when compiling with clang.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/include/arm-common/kvm-config-arch.h | 2 +-
 builtin-run.c                            | 2 +-
 include/kvm/parse-options.h              | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 87f50352e..23a74867a 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -27,7 +27,7 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		     "Specify Generic Timer frequency in guest DT to "		\
 		     "work around buggy secure firmware *Firmware should be "	\
 		     "updated to program CNTFRQ correctly*"),			\
-	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, '\0',			\
+	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, "",			\
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
diff --git a/builtin-run.c b/builtin-run.c
index 941ae0e4b..bd0d0b9c2 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -207,7 +207,7 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
 	OPT_CALLBACK_NOOPT('\0', "virtio-legacy",			\
-			   &(cfg)->virtio_transport, '\0',		\
+			   &(cfg)->virtio_transport, "",		\
 			   "Use legacy virtio transport (Deprecated:"	\
 			   " Use --virtio-transport option instead)",	\
 			   virtio_transport_parser, NULL),		\
diff --git a/include/kvm/parse-options.h b/include/kvm/parse-options.h
index b03f15124..c2e083205 100644
--- a/include/kvm/parse-options.h
+++ b/include/kvm/parse-options.h
@@ -132,7 +132,8 @@ struct option {
 	.type = OPTION_STRING,              \
 	.short_name = (s),                  \
 	.long_name = (l),                   \
-	.value = check_vtype(v, const char **), (a), \
+	.value = check_vtype(v, const char **), \
+	.argh = (a),                        \
 	.help = (h)                         \
 }
 
@@ -166,7 +167,7 @@ struct option {
 	.short_name = (s),		    \
 	.long_name = (l),		    \
 	.value = (v),			    \
-	(a),				    \
+	.argh = (a),			    \
 	.help = (h),			    \
 	.callback = (f),		    \
 	.ptr = (p),			    \
@@ -178,7 +179,7 @@ struct option {
 	.short_name = (s),		    \
 	.long_name = (l),		    \
 	.value = (v),			    \
-	(a),				    \
+	.argh = (a),			    \
 	.help = (h),			    \
 	.callback = (f),		    \
 	.flags = PARSE_OPT_NOARG,	    \
-- 
2.25.1

