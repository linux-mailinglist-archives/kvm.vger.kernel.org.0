Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD18BB57B
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbfIWNf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:57 -0400
Received: from foss.arm.com ([217.140.110.172]:42404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbfIWNf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BB6015A2;
        Mon, 23 Sep 2019 06:35:55 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 88CD73F694;
        Mon, 23 Sep 2019 06:35:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 15/16] kvmtool: Make the size@addr option parser globally visible
Date:   Mon, 23 Sep 2019 14:35:21 +0100
Message-Id: <1569245722-23375-16-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm architecture is going to allow the user to specify the size and
address of various memory regions. Let's make the function to parse
size@addr options globally visible, because we will be using it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c     | 29 ++++++++++++++++++-----------
 include/kvm/kvm.h |  2 ++
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 757ede4ac0d1..70ece3754644 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -131,37 +131,44 @@ static u64 parse_addr(char **next)
 	return ((u64)1) << shift;
 }
 
-static int mem_parser(const struct option *opt, const char *arg, int unset)
+void kvm__parse_size_addr_option(const char *p, u64 *size, u64 *addr)
 {
-	struct kvm_config *cfg = opt->value;
-	const char *p = arg;
 	char *next;
-	u64 size, addr = INVALID_MEM_ADDR;
+
+	*addr = INVALID_MEM_ADDR;
 
 	/* Parse memory size. */
-	size = strtoll(p, &next, 0);
+	*size = strtoll(p, &next, 0);
 	if (next == p)
 		die("Invalid memory size");
 
-	size *= parse_size(&next);
+	*size *= parse_size(&next);
 
 	if (*next == '\0')
-		goto out;
+		return;
 	else
 		p = next + 1;
 
-	addr = strtoll(p, &next, 0);
+	*addr = strtoll(p, &next, 0);
 	if (next == p)
 		die("Invalid memory address");
 
+	*addr *= parse_addr(&next);
+}
+
+static int mem_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm_config *cfg = opt->value;
+	const char *p = arg;
+	u64 size, addr;
+
+	kvm__parse_size_addr_option(p, &size, &addr);
+
 #ifndef ARCH_SUPPORT_CFG_RAM_BASE
 	if (addr != INVALID_MEM_ADDR)
 		die("Specifying the memory address not supported by the architecture");
 #endif
 
-	addr *= parse_addr(&next);
-
-out:
 	cfg->ram_base = addr;
 	cfg->ram_size = size;
 
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 8787a92b4dbb..a93e30d1a320 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -192,4 +192,6 @@ static inline void kvm__set_thread_name(const char *name)
 	prctl(PR_SET_NAME, name);
 }
 
+void kvm__parse_size_addr_option(const char *p, u64 *size, u64 *addr);
+
 #endif /* KVM__KVM_H */
-- 
2.7.4

