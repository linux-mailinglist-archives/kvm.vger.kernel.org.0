Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C301878E3
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgCQEz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:55:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgCQExK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:10 -0400
IronPort-SDR: tmaYWY7KkIGopAakRUkOxRUpQrDzxbo99Y8gJMXWszT+2dhKfkQo3dCxWJ3XkQqAwlqjvwejy3
 tqwnaytxMXFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:10 -0700
IronPort-SDR: IklKnvC6wqKzieCvjvs1tgX1OlXfcm8VOIO1vC+UD1HTSFlGOMWaojs59yR/FpDAFTzbkM+Vtf
 W0xKJWfcG9Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252740"
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
Subject: [PATCH v2 03/32] KVM: nVMX: Invalidate all EPTP contexts when emulating INVEPT for L1
Date:   Mon, 16 Mar 2020 21:52:09 -0700
Message-Id: <20200317045238.30434-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
changes to the EPT tables managed by L1 need to be recognized, and
relying on KVM to always flush L2's EPTP context on nested VM-Enter is
dangerous.

Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
TLB flush if necessary, e.g. if L1 has never entered L2 then there is
nothing to be done.

Nuking all L2 roots is overkill for the single-context variant, but it's
the safe and easy bet.  A more precise zap mechanism will be added in
the future.  Add a TODO to call out that KVM only needs to invalidate
affected contexts.

Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f3774cef4fd4..9624cea4ed9f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5160,12 +5160,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+		/* TODO: sync only the target EPTP context. */
 		fallthrough;
 	case VMX_EPT_EXTENT_GLOBAL:
-	/*
-	 * TODO: Sync the necessary shadow EPT roots here, rather than
-	 * at the next emulated VM-entry.
-	 */
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
+				   KVM_MMU_ROOTS_ALL);
 		break;
 	default:
 		BUG_ON(1);
-- 
2.24.1

