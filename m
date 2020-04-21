Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC54B1B2062
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgDUHxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 03:53:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:22871 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUHxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 03:53:31 -0400
IronPort-SDR: 5NjhHUOTgKNrBIiT1EBnXQuYriaeSBQsfCYcePhDexH5EYbLgOso9wnyBv73E+EH4jT+2K2F3B
 ITjSV+xszyHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 00:53:29 -0700
IronPort-SDR: wG2o5a7z29Kq5M7cL4rwWui9yGD7c9HunpERaZVFwWrC9ACMkKpq4/VjibYGS2uAGL2Nz+fZFw
 GMUcMQ+TfcmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="245611201"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2020 00:53:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 1/2] KVM: nVMX: Drop a redundant call to vmx_get_intr_info()
Date:   Tue, 21 Apr 2020 00:53:27 -0700
Message-Id: <20200421075328.14458-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200421075328.14458-1-sean.j.christopherson@intel.com>
References: <20200421075328.14458-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop nested_vmx_l1_wants_exit()'s initialization of intr_info from
vmx_get_intr_info() that was inadvertantly introduced along with the
caching mechanism.  EXIT_REASON_EXCEPTION_NMI, the only consumer of
intr_info, populates the variable before using it.

Fixes: bb53120d67cdb ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f228339cd0a0..995c319cc7ad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5691,8 +5691,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
  */
 static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u32 intr_info;
 
 	switch (exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
-- 
2.26.0

