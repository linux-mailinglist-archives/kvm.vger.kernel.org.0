Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541C03A5854
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 14:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhFMMtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 08:49:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:40833 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhFMMtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 08:49:40 -0400
IronPort-SDR: Xnh/JsDakQSzb3sNRQzTbDhDiyymf0G2zKqFXGfKFfuuOiBWnUJcvR/KQSmmRsE2eL4w2dF+ui
 pNQhpfkpaHfQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10013"; a="227158359"
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="227158359"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2021 05:47:39 -0700
IronPort-SDR: pByYOUl8OyeCceHPExXLVBDmFh9lLxMTjm8C0sO+2FeR7EB267B8K1fA6F2EqTn+thyS3EJ9vL
 9rlvIEWrBSGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="487109870"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2021 05:47:38 -0700
From:   Yi Sun <yi.sun@intel.com>
To:     nadav.amit@gmail.com, yi.sun@intel.com, kvm@vger.kernel.org
Cc:     gordon.jin@intel.com
Subject: [PATCH v3 1/2] x86: Build ISO images from x86/*.elf
Date:   Sun, 13 Jun 2021 20:47:23 +0800
Message-Id: <20210613124724.1850051-2-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210613124724.1850051-1-yi.sun@intel.com>
References: <20210613124724.1850051-1-yi.sun@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of tool grub-mkresure to wrap x86/*.elf in ISO images.
VMM could load test cases just like a CD-ROM, which could
extend usage of those cases.

Refine Makefile to clean *.iso when running 'make clean'.

Signed-off-by: Yi Sun <yi.sun@intel.com>

diff --git a/lib/grub/grub.cfg b/lib/grub/grub.cfg
new file mode 100644
index 0000000..b287cf4
--- /dev/null
+++ b/lib/grub/grub.cfg
@@ -0,0 +1,7 @@
+set timeout=0
+set default=0
+
+menuentry "my os" {
+    multiboot /boot/kernel.bin
+    boot
+}
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 52bb7aa..62eea51 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -50,6 +50,22 @@ FLATLIBS = lib/libcflat.a
 	$(OBJCOPY) -O elf32-i386 $^ $@
 	@chmod a-x $@
 
+grub_cfg := lib/grub/grub.cfg
+
+elf_files := $(wildcard ./x86/*.elf)
+iso_files := $(patsubst %.elf,%.iso,$(elf_files))
+
+%.iso: %.elf
+	@echo "Creating ISO for case: $(notdir $<)"
+	@rm -rf build/isofiles
+	@mkdir -p build/isofiles/boot/grub
+	@cp $< build/isofiles/boot/kernel.bin
+	@cp $(grub_cfg) build/isofiles/boot/grub
+	@grub-mkrescue -o $@ build/isofiles 2> /dev/null
+
+iso: $(iso_files)
+	echo "All ISO created successfully!"
+
 tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/smptest.flat  \
                $(TEST_DIR)/realmode.flat $(TEST_DIR)/msr.flat \
@@ -81,5 +97,5 @@ $(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
 $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
 
 arch_clean:
-	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
+	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf $(TEST_DIR)/*.iso \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
-- 
2.27.0

