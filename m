Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9B6AFFAA
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCHHaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCHH36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:29:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ECC8C966
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 23:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678260596; x=1709796596;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aFLFLAl4fwoRHvcw3VD+7hg149BfPnHhzpq1o8viOjw=;
  b=i9Zp+68KPqioHHgfyg5Rgyjmk8g2bGNj7SD9kp8bWpNVjP2Xqm//sm0t
   FVSbY+yyFBxFMvgu5QZTvhCx6NBvA9rG5W5/GMrpTX8OBkux/0KXU7Jej
   O43YzxSxknYJgmtpP8f0SWRVi6o5gUJ48VIkDWY+AV+ZCKvATg58vDy00
   gGcoV1eebHgMNCHrh4Py9GNh0SRXte+VXBdN8hDd7GdBKMfVCiLZufwyT
   3ADzIeUQxD5gtQwYSMZxXIXgdp0Q+n044Jpv6s+BXNvfT49fxyiRoFD5j
   49mlJf72cWCb4RVXwPTFs9hyG6hI1RSdqHzKuROf1BmL2hJN5OXO0Ld+t
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="334801668"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="334801668"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:29:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922676037"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="922676037"
Received: from sqa-gate.sh.intel.com (HELO zhihaihu-desk.tsp.org) ([10.239.48.212])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:29:45 -0800
From:   Robert Hoo <robert.hu@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     robert.hoo.linux@gmail.com
Subject: [PATCH] KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()
Date:   Wed,  8 Mar 2023 15:29:36 +0800
Message-Id: <20230308072936.1293101-1-robert.hu@intel.com>
X-Mailer: git-send-email 2.31.1
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

From: Robert Hoo <robert.hu@linux.intel.com>

If !guest_cpuid_has(vcpu, X86_FEATURE_PCID), CR4.PCIDE would have been in
vcpu->arch.cr4_guest_rsvd_bits and failed earlier kvm_is_valid_cr4() check.
Remove this meaningless check.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
===Test==
kvm-unit-test pcid cases (pcid-asymmetric, pcid-disabled, pcid-enabled)
passed.
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..96b3c510fdde 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1174,9 +1174,6 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	if ((cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE)) {
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
-			return 1;
-
 		/* PCID can not be enabled when cr3[11:0]!=000H or EFER.LMA=0 */
 		if ((kvm_read_cr3(vcpu) & X86_CR3_PCID_MASK) || !is_long_mode(vcpu))
 			return 1;

base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.31.1

