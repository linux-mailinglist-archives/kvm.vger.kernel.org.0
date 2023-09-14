Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6679FB61
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbjINFzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbjINFzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:55:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CD5C1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 22:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694670910; x=1726206910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9MGCCdUoiDevmpU0+lPz3mHlK3UnQ1h44KDnnPpX6Ow=;
  b=I4xqhbPAnp00nm5eKEFPHiJwpMZPgurFsAi/C2nrJEaQYOJLVIXozjvo
   mFgTDZ8QK7I60ZNXmS8dbHyYKUlhfz9as6Py62LG01qBpZKCSVE6ok4PO
   xaId0aVz+qwJlPCAus75ydkQyxPZBaQyxQGrLhkR2tDuI/fHiQPppexbK
   fUvgp27nhN6lGlqeYO9DdYL8tAXv0jCGDAo5/WCL4ZpklZjy/XPupxnId
   uPE41Q9jWNJH0X3o2QvVEyWS2BSdeOqXhA477x03LKgd9qjZVcbBIF0Zz
   CALkgKSVz/HwWmLLBr8MvxDwX3HltDdYZ5BFvPQ+8KSqbYCCQEGmjXlGt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="363898943"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="363898943"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:55:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859567942"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859567942"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga002.fm.intel.com with ESMTP; 13 Sep 2023 22:55:07 -0700
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com, tao1.su@linux.intel.com
Subject: [PATCH v3] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
Date:   Thu, 14 Sep 2023 13:55:04 +0800
Message-Id: <20230914055504.151365-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.

Under the x2APIC section, regarding ICR, the SDM says:

  It remains readable only to aid in debugging; however, software should
  not assume the value returned by reading the ICR is the last written
  value.

I.e. KVM basically has free reign to do whatever it wants, so long as it
doesn't confuse userspace or break KVM's ABI.

Clear bit12 so that it reads back as '0'. This approach is safer than
"do nothing" and is consistent with the case where IPI virtualization is
disabled or not supported, i.e.,

  handle_fastpath_set_x2apic_icr_irqoff() -> kvm_x2apic_icr_write()

Link: https://lore.kernel.org/all/ZPj6iF0Q7iynn62p@google.com/
Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
Changelog:

v3:
  - Correct commit message.
  - Add Chao's Reviewed-by.

v2: https://lore.kernel.org/all/20230908041115.987682-1-tao1.su@linux.intel.com/

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

base-commit: aed8aee11130a954356200afa3f1b8753e8a9482
-- 
2.34.1

