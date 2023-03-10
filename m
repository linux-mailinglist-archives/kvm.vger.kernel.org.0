Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C208D6B3FCE
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 13:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCJM6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 07:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCJM5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 07:57:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74F410CEA0
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 04:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678453055; x=1709989055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p12VuYLJNsxX19MxIy7wKMWtiPL8NsSXzzzgh+Sbj0s=;
  b=icwXrQ6P+0k4Mj4UX3APu9Nepel3VzzAJdBJYcXtlaCjSn6s0p01wszu
   b4K3jf5J6JYQvnv2BOgR+dgdcjEQmdKUpzD4q/kVj1/75g4dTEtHb/HU3
   xOtdBZEwDZKm1UXKwCl5Ng48JvBCFqKE1+rE52+ouV8ZneictTKX6ByRZ
   hh2Kcl2wq/zvqDMSNEGXwz+X6fa226wqgnaxBPv/5MbnFZ1zf/HBeJkq5
   MbFFvxbOtYFY0/BldFJ9eDVx5BsYBREQZ1/9rL1S+DNNoDYdC3rwXYUOW
   V1zMvjMFi2lwTKVutqXQNqds9Mea6OQXicAGtxyg5u/4ODfApyzbxpYV5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336739899"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336739899"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="801573470"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="801573470"
Received: from sqa-gate.sh.intel.com (HELO zhihaihu-desk.tsp.org) ([10.239.48.212])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:34 -0800
From:   Robert Hoo <robert.hu@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     robert.hoo.linux@gmail.com
Subject: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc() check in vmx_set_cr4()
Date:   Fri, 10 Mar 2023 20:57:17 +0800
Message-Id: <20230310125718.1442088-3-robert.hu@intel.com>
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

Remove the unnecessary cpu_has_vmx_desc() check for emulating UMIP.

When it arrives vmx_set_cr4(), it has passed kvm_is_valid_cr4(), meaning
vmx_set_cpu_caps() has already assign X86_FEATURE_UMIP with this vcpu,
because of either host CPU has the capability or it can be emulated,

vmx_set_cpu_caps():
	if (cpu_has_vmx_desc())
		kvm_cpu_cap_set(X86_FEATURE_UMIP);

that is to say, if !boot_cpu_has(X86_FEATURE_UMIP) here,
cpu_has_vmx_desc() must be true, it should be a meaningless check here.

Signed-off-by: Robert Hoo <robert.hu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96f7c9f37afd..bec5792acffe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3437,7 +3437,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	 * guest been exposed with UMIP feature, i.e. either host has cap
 	 * of UMIP or vmx_set_cpu_caps() set it because of cpu_has_vmx_desc()
 	 */
-	if (!boot_cpu_has(X86_FEATURE_UMIP) && cpu_has_vmx_desc()) {
+	if (!boot_cpu_has(X86_FEATURE_UMIP)) {
 		if (cr4 & X86_CR4_UMIP) {
 			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 			hw_cr4 &= ~X86_CR4_UMIP;
-- 
2.31.1

