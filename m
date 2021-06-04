Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8529F39B079
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 04:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFDCgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 22:36:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:4758 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhFDCgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 22:36:46 -0400
IronPort-SDR: mgl65AKahLWOwuHp/qTqlc3p4MyrkVKeTHm6a0LcLIjn41hBgFaWZtifiElzILa46nkJ9w34dp
 bNADyCRx+RAw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="204234221"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="204234221"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 19:34:57 -0700
IronPort-SDR: s1xSGeTAvEC3xgKRlzcGifRnxWMPhSg3bhFoA3nhS18xWZI2Loy1GGSw4VT6+E7Bks4vZyCXVk
 lAh5ddSO5P9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="636444349"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2021 19:34:56 -0700
From:   Yi Sun <yi.sun@intel.com>
To:     yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/2] x86: Build ISO images from x86/*.elf
Date:   Fri,  4 Jun 2021 10:34:52 +0800
Message-Id: <20210604023453.905512-1-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
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

