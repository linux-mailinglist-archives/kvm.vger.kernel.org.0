Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5528252531
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 03:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHZBsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 21:48:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:48778 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHZBsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 21:48:16 -0400
IronPort-SDR: mBzo4wOnsFQOX075RgTvXVhRj6HiFu3/UWWI4+lCOPVV8m8d7mAjMkxPJo0HQC/M5tmont0S7v
 zpUjm76WoeXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="156211600"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="156211600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 18:48:14 -0700
IronPort-SDR: VxTgRoIG+wPYtPsh0xn3ZNHD+gcvoapHV7aOE6er18cHM75TLhQakQ90OMr8W7mjwlBKpXmoSd
 mbDEZIs92FOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="500074678"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2020 18:48:13 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] selftests: kvm: Fix assert failure in single-step test
Date:   Wed, 26 Aug 2020 09:55:24 +0800
Message-Id: <20200826015524.13251-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a follow-up patch to fix an issue left in commit:
98b0bf02738004829d7e26d6cb47b2e469aaba86
selftests: kvm: Use a shorter encoding to clear RAX

With the change in the commit, we also need to modify "xor" instruction
length from 3 to 2 in array ss_size accordingly to pass below check:

for (i = 0; i < (sizeof(ss_size) / sizeof(ss_size[0])); i++) {
        target_rip += ss_size[i];
        CLEAR_DEBUG();
        debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
        debug.arch.debugreg[7] = 0x00000400;
        APPLY_DEBUG();
        vcpu_run(vm, VCPU_ID);
        TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
                    run->debug.arch.exception == DB_VECTOR &&
                    run->debug.arch.pc == target_rip &&
                    run->debug.arch.dr6 == target_dr6,
                    "SINGLE_STEP[%d]: exit %d exception %d rip 0x%llx "
                    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
                    i, run->exit_reason, run->debug.arch.exception,
                    run->debug.arch.pc, target_rip, run->debug.arch.dr6,
                    target_dr6);
}

Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/testing/selftests/kvm/x86_64/debug_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index b8d14f9db5f9..2fc6b3af81a1 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -73,7 +73,7 @@ int main(void)
 	int i;
 	/* Instruction lengths starting at ss_start */
 	int ss_size[4] = {
-		3,		/* xor */
+		2,		/* xor */
 		2,		/* cpuid */
 		5,		/* mov */
 		2,		/* rdmsr */
-- 
2.17.2

