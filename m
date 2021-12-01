Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5C464A89
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 10:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348159AbhLAJ3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 04:29:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:64263 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348188AbhLAJ2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 04:28:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="299812438"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="299812438"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 01:25:27 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="500164248"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.117])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 01:25:25 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     chao.gao@intel.com, Xiaoyao.Li@intel.com, yuan.yao@intel.com
Subject: [kvm-unit-tests PATCH] x86: Remove invalid clwb test code
Date:   Wed,  1 Dec 2021 17:26:19 +0800
Message-Id: <20211201092619.60298-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When X86_FEATURE_WAITPKG(CPUID.7.0:ECX.WAITPKG[bit 5]) supported,
".byte 0x66, 0x0f, 0xae, 0xf0" sequence no longer represents clwb
instruction with invalid operand but tpause instruction with %eax
as input register.

Execute tpause with invalid input triggers #GP with below customed
qemu command line:

qemu -kernel x86/memory.flat -overcommit cpu-pm=on ...

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 x86/memory.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/x86/memory.c b/x86/memory.c
index 8f61020..351e7c0 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -67,13 +67,6 @@ int main(int ac, char **av)
 	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
 	report(ud == expected, "clwb (%s)", expected ? "ABSENT" : "present");
 
-	ud = 0;
-	/* clwb requires a memory operand, the following is NOT a valid
-	 * CLWB instruction (modrm == 0xF0).
-	 */
-	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf0");
-	report(ud, "invalid clwb");
-
 	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
 	ud = 0;
 	/* pcommit: */
-- 
2.25.1

