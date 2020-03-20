Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F84918DA70
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgCTVbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:31:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:48422 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTV2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:44 -0400
IronPort-SDR: 8ADoXOZBZ9sbKs5DrZ53e8xmwvRAfaVE9+vBdcWJs+7WucuRBXhIriCyugwWqT9+VgbB9kKSjT
 z3abJahqL+kw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:43 -0700
IronPort-SDR: TLjnP7UgaLSYWQC6iMOaDZRwfWF0pQg2+dg1q+rDS+HFP24nOzh0ehXXVRz+6SK424CAMNtl34
 AnVBwdr8GD6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224397"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 02/37] KVM: nVMX: Validate the EPTP when emulating INVEPT(EXTENT_CONTEXT)
Date:   Fri, 20 Mar 2020 14:27:58 -0700
Message-Id: <20200320212833.3507-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signal VM-Fail for the single-context variant of INVEPT if the specified
EPTP is invalid.  Per the INEVPT pseudocode in Intel's SDM, it's subject
to the standard EPT checks:

  If VM entry with the "enable EPT" VM execution control set to 1 would
  fail due to the EPTP value then VMfail(Invalid operand to INVEPT/INVVPID);

Fixes: bfd0a56b90005 ("nEPT: Nested INVEPT")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8578513907d7..f3774cef4fd4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5156,8 +5156,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	}
 
 	switch (type) {
-	case VMX_EPT_EXTENT_GLOBAL:
 	case VMX_EPT_EXTENT_CONTEXT:
+		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
+			return nested_vmx_failValid(vcpu,
+				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		fallthrough;
+	case VMX_EPT_EXTENT_GLOBAL:
 	/*
 	 * TODO: Sync the necessary shadow EPT roots here, rather than
 	 * at the next emulated VM-entry.
-- 
2.24.1

