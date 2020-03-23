Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D6D18EE5E
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 04:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCWDOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 23:14:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:48945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgCWDOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 23:14:44 -0400
IronPort-SDR: D+SUi+ScOd4EWjNJV9zfNrG2J7LkDbdxkHvei6HqWPR3ETukzbVe47aCKvxGS0zwsrmvFf9SCB
 9ITVmyBh9Ozw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:14:44 -0700
IronPort-SDR: uYur9/pt0qTm1pCiSl2Gb8z6WaZ27QWwAxqe0ET2NSe31lYk6CKbczLb2jDBKy4p6igdDvkzTZ
 9acOqk7HrLcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="292453701"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.161])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Mar 2020 20:14:42 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 3/3] target/i386: Tell why guest exits to user space due to #AC
Date:   Mon, 23 Mar 2020 10:56:58 +0800
Message-Id: <20200323025658.4540-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200323025658.4540-1-xiaoyao.li@intel.com>
References: <20200323025658.4540-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tell why guest exits from kvm to user space due to #AC, so user knows
what happened.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 411402aa29fa..36bc1485d478 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -4464,8 +4464,15 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = -1;
         break;
     case KVM_EXIT_EXCEPTION:
-        fprintf(stderr, "KVM: exception %d exit (error code 0x%x)\n",
-                run->ex.exception, run->ex.error_code);
+        if (run->ex.exception == AC_VECTOR) {
+            fprintf(stderr, "Guest encounters an #AC due to split lock. Because "
+                    "guest doesn't expect this split lock #AC (it doesn't set "
+                    "msr_test_ctrl.split_lock_detect) and host sets "
+                    "split_lock_detect=fatal, guest has to be killed.\n");
+        } else {
+            fprintf(stderr, "KVM: exception %d exit (error code 0x%x)\n",
+                    run->ex.exception, run->ex.error_code);
+        }
         ret = -1;
         break;
     case KVM_EXIT_DEBUG:
-- 
2.20.1

