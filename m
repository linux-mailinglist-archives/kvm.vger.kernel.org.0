Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7F27DF88
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgI3Eep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:34:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:62136 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3Eep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:34:45 -0400
IronPort-SDR: 4Q29jt/rxga4o+qNpiIm/HZxMdOBttS4QfFMYe5/smxpCK9l4VbEckMjiPicBTLc1KAIlCfSj4
 VMqKrOM/1cpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150139301"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150139301"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:34:38 -0700
IronPort-SDR: HRN2pWgZ8qN0KdZ3U1ggSlM8pWjto+E30PZZRbC2imRsfI2rb0FmcU1m9pNRI8p6eEA9Fuk9Nm
 7yMj5uOsLdIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="338932499"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 29 Sep 2020 21:34:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Add one-off test to verify setting LA57 fails when it's unsupported
Date:   Tue, 29 Sep 2020 21:34:36 -0700
Message-Id: <20200930043436.29270-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an i386-only test to check that setting CR4.LA57 fails when 5-level
paging is not exposed to the guest.  Old versions of KVM don't intercept
LA57 by default on VMX, which means a clever guest could set LA57
without it being detected by KVM.

This test is i386-only because toggling CR4.LA57 in long mode is
illegal, i.e. won't verify the desired KVM behavior.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/Makefile.i386 |  2 +-
 x86/la57.c        | 13 +++++++++++++
 x86/unittests.cfg |  4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 x86/la57.c

diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index be9d6bc..c04e5aa 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -6,6 +6,6 @@ COMMON_CFLAGS += -mno-sse -mno-sse2
 cflatobjs += lib/x86/setjmp32.o
 
 tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
-	$(TEST_DIR)/cmpxchg8b.flat
+	$(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/x86/la57.c b/x86/la57.c
new file mode 100644
index 0000000..b537bb2
--- /dev/null
+++ b/x86/la57.c
@@ -0,0 +1,13 @@
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+
+int main(int ac, char **av)
+{
+	int vector = write_cr4_checking(read_cr4() | X86_CR4_LA57);
+	int expected = this_cpu_has(X86_FEATURE_LA57) ? 0 : 13;
+
+	report(vector == expected, "%s when CR4.LA57 %ssupported",
+	       expected ? "#GP" : "No fault", expected ? "un" : "");
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3a79151..6eb8e19 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -245,6 +245,10 @@ arch = x86_64
 file = umip.flat
 extra_params = -cpu qemu64,+umip
 
+[la57]
+file = la57.flat
+arch = i386
+
 [vmx]
 file = vmx.flat
 extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
-- 
2.28.0

