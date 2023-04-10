Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5E46DC6EA
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDJMud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 08:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDJMu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 08:50:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2E761B1;
        Mon, 10 Apr 2023 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681131023; x=1712667023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ff+CccVwXXrczPNnTRbmV+x1z43wLG9Logfb8NFVoXs=;
  b=RC9Udjbv8bSVSlzdFcUHcb+7aJlwa/zwEeyCBv7iSiXF1/SDqUpafwEe
   v70iYJcGcmkos0AGXpU1fZjEZZQ9otsXSIhoeMTEalFCqaRsAIRkpRT/m
   1ylo68Xyo42tKP3U1IcZsHzep4cZ4HY9PjfeaayrlHbgq1HHhmPlL/ZQZ
   oHJ5QrLHO28R7Y8BWtkrUGzqMYeFk9hWicukrMQqgXdspuYIMtgeXXZLF
   mg/BIhKKqnzLJae3v4WwBWx/y/mzt4Er+vEjlLX6qNx1p1NKrAP6wma/Z
   TcsxaPYTwX+Zf3NqJImtfcFQxgrcMWR5GEgR/kRcr+7f9+3jUPnEySkyb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="371183495"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="371183495"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 05:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="638455267"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="638455267"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2023 05:50:21 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoyao.li@intel.com
Subject: [PATCH 1/2] KVM: VMX: Use kvm_read_cr4() to get cr4 value
Date:   Mon, 10 Apr 2023 08:50:16 -0400
Message-Id: <20230410125017.1305238-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410125017.1305238-1-xiaoyao.li@intel.com>
References: <20230410125017.1305238-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly use vcpu->arch.cr4 is not recommended since it gets stale value
if the cr4 is not available.

Use kvm_read_cr4() instead to ensure correct value.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7bf14abdba1..befa2486836b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3431,7 +3431,7 @@ static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	unsigned long old_cr4 = vcpu->arch.cr4;
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
 	 * Pass through host's Machine Check Enable value to hw_cr4, which
-- 
2.34.1

