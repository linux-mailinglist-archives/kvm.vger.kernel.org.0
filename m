Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD25E6B3FCF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 13:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCJM6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 07:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJM5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 07:57:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB62DABB4
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 04:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678453057; x=1709989057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rMqx04h0QJAAYrrLjSK/NVOJRf+mcXIyF4C+lpihzFs=;
  b=hbKlidMZdo6QnvICPMExbR55u3Xbevx3ZMwPMjmRWv3j5wsctBbEEBcO
   +22DipxLvDuS7WUW4slgJyCOJKg6OfAvAnGrbXKbX9aBJgdAoJyTMNJJg
   WCc/b/9HvFpymRiJq6iakIJiuVX3PuoujoqXLxwnQ0072rLR3Q2P4F58r
   zOiTHT+k4UZrbrSzukY7sELv16xykvSzt8zWbqngp7m40hXH0Jd26t8Qm
   YTXWgf7mUZYx61b7iVPvZ70gEfSEznzEKglyFnQJQcb0UmVoFLU7PXhMR
   OBLOWSqPjFCaghR0AoBxLQoyNZU9l2ARiWPa3K/OqVW6A25w/ME7r+sTR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336739907"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336739907"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="801573476"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="801573476"
Received: from sqa-gate.sh.intel.com (HELO zhihaihu-desk.tsp.org) ([10.239.48.212])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:35 -0800
From:   Robert Hoo <robert.hu@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     robert.hoo.linux@gmail.com
Subject: [PATCH 3/3] KVM: VMX: Use the canonical interface to read CR4.UMIP bit
Date:   Fri, 10 Mar 2023 20:57:18 +0800
Message-Id: <20230310125718.1442088-4-robert.hu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230310125718.1442088-1-robert.hu@intel.com>
References: <20230310125718.1442088-1-robert.hu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_read_cr4_bits() rather than directly read vcpu->arch.cr4, now that
we have reg cache layer and defined this wrapper.
Although, effectively for CR4.UMIP, it's the same, at present, as it's not
guest owned, in case of future changes, here better to use the canonical
interface.

Signed-off-by: Robert Hoo <robert.hu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bec5792acffe..8853853def56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5435,7 +5435,7 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
+	WARN_ON(!kvm_read_cr4_bits(vcpu, X86_CR4_UMIP));
 	return kvm_emulate_instruction(vcpu, 0);
 }
 
-- 
2.31.1

