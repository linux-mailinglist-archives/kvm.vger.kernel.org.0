Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9CB29CB3B
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373939AbgJ0VZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:25:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:56181 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373799AbgJ0VXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:54 -0400
IronPort-SDR: CS7krmnNGQSxPozfZw5e2p28Fouh+ddThmW/2Z97RCztoZE/027+AvIgf38NcR7SKfi+z2iFsD
 P+XDwbHzZlKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133713"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133713"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:52 -0700
IronPort-SDR: ywuLMY040oWwJro92QHR0lHKimxFI4iRXa/MiR2z6+0/95VIvr99RI4jC812JLXrm+GLEDHTPH
 hCpADSMoVYlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886407"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/11] KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
Date:   Tue, 27 Oct 2020 14:23:45 -0700
Message-Id: <20201027212346.23409-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip additional EPTP flushes if one fails when processing EPTPs for
Hyper-V's paravirt TLB flushing.  If _any_ flush fails, KVM falls back
to a full global flush, i.e. additional flushes are unnecessary (and
will likely fail anyways).

Continue processing the loop unless a mismatch was already detected,
e.g. to handle the case where the first flush fails and there is a
yet-to-be-detected mismatch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b7c5b2fd2c7..40a67dd45c8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -528,7 +528,15 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 			if (++nr_unique_valid_eptps == 1)
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
 
-			ret |= hv_remote_flush_eptp(tmp_eptp, range);
+			if (!ret)
+				ret = hv_remote_flush_eptp(tmp_eptp, range);
+
+			/*
+			 * Stop processing EPTPs if a failure occurred and
+			 * there is already a detected EPTP mismatch.
+			 */
+			if (ret && nr_unique_valid_eptps > 1)
+				break;
 		}
 
 		/*
-- 
2.28.0

