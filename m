Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020B446B7CE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhLGJsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:48:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:52335 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhLGJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:48:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323796364"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="323796364"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 01:44:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515207351"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2021 01:44:36 -0800
From:   Yi Sun <yi.sun@intel.com>
To:     yi.sun@linux.intel.com, yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH RESEND v3 1/2] x86: Build ISO images from x86/*.elf
Date:   Tue,  7 Dec 2021 17:44:31 +0800
Message-Id: <20211207094432.189576-2-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207094432.189576-1-yi.sun@intel.com>
References: <20211207094432.189576-1-yi.sun@intel.com>
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
index 461de51..99a2706 100644
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
@@ -85,5 +101,5 @@ $(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
 $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
 
 arch_clean:
-	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
+	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf $(TEST_DIR)/*.iso \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
-- 
2.27.0

