Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA032944CB
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438874AbgJTV4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:61052 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438838AbgJTV4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:18 -0400
IronPort-SDR: 4/603PfWEfhZ5laybeqqE1We1zd8wIweVt4njdDHpUgDZnoNAoiyXUD2R5hYqm44617WLVnXXh
 PyzN9g0du0Vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576333"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:17 -0700
IronPort-SDR: uo1qN6o71AM/m72sqckMJIAYB7F1zDV7Iwwwb/rIYg8mrIWLYb+95E7OlKdkRrFW1XM2GM6xsq
 2Hvo1xB5b/tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827755"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/10] KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
Date:   Tue, 20 Oct 2020 14:56:12 -0700
Message-Id: <20201020215613.8972-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
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
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a45a90d44d24..e0fea09a6e42 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -517,7 +517,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 			else
 				mismatch = true;
 
-			ret |= hv_remote_flush_eptp(tmp_eptp, range);
+			if (!ret)
+				ret = hv_remote_flush_eptp(tmp_eptp, range);
+
+			if (ret && mismatch)
+				break;
 		}
 		if (mismatch)
 			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-- 
2.28.0

