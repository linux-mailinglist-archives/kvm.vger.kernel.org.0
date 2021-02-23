Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A041E3223D2
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 02:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBWBss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 20:48:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:61186 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhBWBss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 20:48:48 -0500
IronPort-SDR: 7FhznoiHTqU5i/ixzuUKyErezaQgRbIjVK3/13WowIu1j9V2K6gFQLjj4w11wXNaU6YCyDUOHQ
 yA1o0NOvamGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="204074435"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="204074435"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 17:47:02 -0800
IronPort-SDR: TnqcXWgI8AzeQoutJT/a0nG3o/Kg5Ru5L7vxJfg/4eMqupzJMgW45FmjKX22B5H/C6J3AOQRzV
 Cj9N5heluTNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="423349289"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga004.fm.intel.com with ESMTP; 22 Feb 2021 17:46:59 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: vmx/pmu: Fix dummy check if lbr_desc->event is created
Date:   Tue, 23 Feb 2021 09:39:57 +0800
Message-Id: <20210223013958.1280444-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If lbr_desc->event is successfully created, the intel_pmu_create_
guest_lbr_event() will return 0, otherwise it will return -ENOENT,
and then jump to LBR msrs dummy handling.

Fixes: 1b5ac3226a1a ("KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d1df618cb7de..d6a5fe19ff09 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -320,7 +320,7 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
 		return false;
 
-	if (!lbr_desc->event && !intel_pmu_create_guest_lbr_event(vcpu))
+	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu))
 		goto dummy;
 
 	/*
-- 
2.29.2

