Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34F18DA56
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCTV2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:59221 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCTV2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:50 -0400
IronPort-SDR: CmK36EZ2S252m/XyWokHDF0QY7PV2mHUfti8G6GnfJ5hIQt4aLLKMVFV+V3IBIdfm+LK1RvBqk
 mQsxL7bww1yw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:49 -0700
IronPort-SDR: /psYHx1g+8IVYAFsA9iu3enbjuQd/faOFh7s6kwrjyQYOtXQPyXC/T52b5tdM6nIKXsC5sqSLM
 Loo9dxl+P3ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224450"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:49 -0700
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
Subject: [PATCH v3 13/37] KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
Date:   Fri, 20 Mar 2020 14:28:09 -0700
Message-Id: <20200320212833.3507-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vpid_sync_vcpu_addr() to emulate the "individual address" variant of
INVVPID now that said function handles the fallback case of the (host)
CPU not supporting "individual address".

Note, the "vpid == 0" checks in the vpid_sync_*() helpers aren't
actually redundant with the "!operand.vpid" check in handle_invvpid(),
as the vpid passed to vpid_sync_vcpu_addr() is a KVM (host) controlled
value, i.e. vpid02 can be zero even if operand.vpid is non-zero.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 81bc4791d704..0c71db6fec5a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5251,11 +5251,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		if (cpu_has_vmx_invvpid_individual_addr())
-			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
-				vpid02, operand.gla);
-		else
-			vpid_sync_context(vpid02);
+		vpid_sync_vcpu_addr(vpid02, operand.gla);
 		break;
 	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
 	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
-- 
2.24.1

