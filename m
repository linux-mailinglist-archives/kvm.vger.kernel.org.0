Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED663BA00A
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhGBLvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:24 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:32972 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhGBLvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:23 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7BA1822982;
        Fri,  2 Jul 2021 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQFJfMtJ7d44u/Eg9demA0543TOxxcunVlC/ArZcDv0=;
        b=o4x9NiSgX+HD1y+cGs/NAtT0HAa569xMwAnQBHAA5HKhlnRdlykHhBczJHNXLbMZ1xG6Uy
        bYECwfUOYzpioSUoN/tgTr5/bYGhP9JbITbGLjRUQ1gvUYUMoRI0P24FtzV09AoG/xW63b
        Q9ixPWR0fbsQJ5pyEpOs3MkaxxUwwE0=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1C24B11C84;
        Fri,  2 Jul 2021 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQFJfMtJ7d44u/Eg9demA0543TOxxcunVlC/ArZcDv0=;
        b=o4x9NiSgX+HD1y+cGs/NAtT0HAa569xMwAnQBHAA5HKhlnRdlykHhBczJHNXLbMZ1xG6Uy
        bYECwfUOYzpioSUoN/tgTr5/bYGhP9JbITbGLjRUQ1gvUYUMoRI0P24FtzV09AoG/xW63b
        Q9ixPWR0fbsQJ5pyEpOs3MkaxxUwwE0=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id SOhgBSL93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:50 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 6/6] x86: Disable some breaking tests for EFI and modify vmexit test
Date:   Fri,  2 Jul 2021 13:48:20 +0200
Message-Id: <20210702114820.16712-7-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable some tests from building on EFI. These fail early, and need some
adaptation (eg. inline asm changes / AP initialization / memory
reclamation from EFI).

Eg, asyncpf: runs out of memory since the allocator only uses the largest
  EFI_CONVENTIONAL_MEMORY block.
hyperv_*: untested with EFI.
vmexit: breaks since test arg passing isn't enabled - enable it except for
  pci-* cases since iomem needs more fixups.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/Makefile.common | 21 +++++++++++----------
 x86/vmexit.c        |  7 +++++++
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 98d8de9..b995a67 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,17 +62,18 @@ FLATLIBS = lib/libcflat.a
 	@chmod a-x $@
 
 tests-flatonly = $(TEST_DIR)/realmode.$(out) $(TEST_DIR)/eventinj.$(out)		\
-		$(TEST_DIR)/smap.$(out) $(TEST_DIR)/umip.$(out)
-
-tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
-		$(TEST_DIR)/smptest.$(out) $(TEST_DIR)/msr.$(out)			\
-		$(TEST_DIR)/hypercall.$(out) $(TEST_DIR)/sieve.$(out)			\
-		$(TEST_DIR)/kvmclock_test.$(out) $(TEST_DIR)/s3.$(out)			\
+		$(TEST_DIR)/smap.$(out) $(TEST_DIR)/umip.$(out)				\
+		$(TEST_DIR)/kvmclock_test.$(out) $(TEST_DIR)/hypercall.$(out)		\
+		$(TEST_DIR)/init.$(out)							\
+		$(TEST_DIR)/asyncpf.$(out) $(TEST_DIR)/hyperv_synic.$(out)		\
+		$(TEST_DIR)/hyperv_stimer.$(out) $(TEST_DIR)/hyperv_connections.$(out)
+
+tests-common = $(TEST_DIR)/tsc.$(out) $(TEST_DIR)/smptest.$(out)			\
+		$(TEST_DIR)/msr.$(out) $(TEST_DIR)/sieve.$(out)				\
+		$(TEST_DIR)/sieve.$(out) $(TEST_DIR)/s3.$(out)				\
 		$(TEST_DIR)/pmu.$(out) $(TEST_DIR)/setjmp.$(out)			\
-		$(TEST_DIR)/tsc_adjust.$(out) $(TEST_DIR)/asyncpf.$(out)		\
-		$(TEST_DIR)/init.$(out) $(TEST_DIR)/hyperv_synic.$(out)			\
-		$(TEST_DIR)/hyperv_stimer.$(out) $(TEST_DIR)/hyperv_connections.$(out)	\
-		$(TEST_DIR)/tsx-ctrl.$(out)
+		$(TEST_DIR)/tsc_adjust.$(out) $(TEST_DIR)/tsx-ctrl.$(out)		\
+		$(TEST_DIR)/vmexit.$(out)
 
 ifneq ($(CONFIG_EFI),y)
 tests-common += $(tests-flatonly)
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 999babf..4062f7a 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -560,6 +560,12 @@ static void enable_nx(void *junk)
 
 static bool test_wanted(struct test *test, char *wanted[], int nwanted)
 {
+#ifdef CONFIG_EFI
+	if (strcmp(test->name, "pci-io") == 0 || strcmp(test->name, "pci-mem") == 0 )
+		return false;
+
+	return true;
+#else
 	int i;
 
 	if (!nwanted)
@@ -570,6 +576,7 @@ static bool test_wanted(struct test *test, char *wanted[], int nwanted)
 			return true;
 
 	return false;
+#endif
 }
 
 int main(int ac, char **av)
-- 
2.30.2

