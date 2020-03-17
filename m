Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C411878DD
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCQExL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgCQExK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:10 -0400
IronPort-SDR: TCtRZB72X1IDjSPrhNXJZJkg/ux8pkpsb+crq7RVgSwksg4fhbp2uovycvXEPjvic+xOpS5iu5
 eI5asXDuG9wQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:09 -0700
IronPort-SDR: mtrT54hH5lEWRi46NEIhK6lytmJiP5A47NNxRISpQL6ut1L9KH4JBB9ANk+aE+J8iChIb44THU
 bye3m1R2AacQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252734"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:09 -0700
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
Subject: [PATCH v2 02/32] KVM: nVMX: Validate the EPTP when emulating INVEPT(EXTENT_CONTEXT)
Date:   Mon, 16 Mar 2020 21:52:08 -0700
Message-Id: <20200317045238.30434-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
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

