Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF467798126
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 06:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbjIHEMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 00:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjIHEMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 00:12:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165231BD5
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 21:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694146338; x=1725682338;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Lc/GdnQX3ztlKVgGSuSToLxiNvcnsFWrnv0a5Puu6/Q=;
  b=HVnZYmWi8RZMGzR8S31VTgR/xHIFj6ZpkBSz8Ql59rtv1W2lKnXy6nP5
   gHMmkdlIICUxQRGx6j5LPg0loVdy58zg1iHJqFGXLS7q8RDtb6Ei/ai9x
   SDexBWsq1P8tyWkbDuDjtdKctVJDzP4Svroly3/dp4BsZGUPwDjjdRWg6
   7E3bZ4M+SIaplpjd2fb9IWjhh2TCSEef+/yVMstrY/4w88VuiM5R9mX5W
   ABYJtjUsTGq2xh3iEJlNaI69Fm5+o+TqQPfOMN7CfA2ZxI9GjFeBFyhuP
   +GsqN1HzE3/fqkC8Ij0gmCv+I9XQKAK4mIRs7rj5ci0Awpa3/bxiN7DKp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="380291717"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="380291717"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 21:11:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="1073130097"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="1073130097"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga005.fm.intel.com with ESMTP; 07 Sep 2023 21:11:17 -0700
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com, tao1.su@linux.intel.com
Subject: [PATCH v2] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
Date:   Fri,  8 Sep 2023 12:11:15 +0800
Message-Id: <20230908041115.987682-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.

Bit12 of ICR is different from other reserved bits(31:20, 17:16 and 13).
When bit12 is set, it will cause APIC-wirte VM-exit but not #GP. For
reading bit12 back as '0' which is a safer approach, clearing bit12 in
x2APIC mode is needed.

Although bit12 of ICR is no longer APIC_ICR_BUSY in x2APIC, keeping it
is far easier to understand what's going on, especially given that it
may be repurposed for something new.

Link: https://lore.kernel.org/all/ZPj6iF0Q7iynn62p@google.com/
Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
Changelog:

v2:
  - Drop the unnecessary alias for bit12 of ICR.
  - Add back kvm_lapic_get_reg64() that was removed by mistake.
  - Modify the commit message to make it clearer.

v1: https://lore.kernel.org/all/20230904013555.725413-1-tao1.su@linux.intel.com/
---
 arch/x86/kvm/lapic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dcd60b39e794..664d5a78b46a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2450,13 +2450,13 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
 	 * to get the upper half from ICR2.
+	 *
+	 * TODO: optimize to just emulate side effect w/o one more write
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
 		val = kvm_lapic_get_reg64(apic, APIC_ICR);
-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
-		trace_kvm_apic_write(APIC_ICR, val);
+		kvm_x2apic_icr_write(apic, val);
 	} else {
-		/* TODO: optimize to just emulate side effect w/o one more write */
 		val = kvm_lapic_get_reg(apic, offset);
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}

base-commit: a48fa7efaf1161c1c898931fe4c7f0070964233a
-- 
2.34.1

