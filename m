Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473E440AB17
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 11:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhINJrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 05:47:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:24663 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhINJrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 05:47:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="201450572"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="201450572"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 02:46:23 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="543881837"
Received: from chenyi-pc.sh.intel.com ([10.239.159.135])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 02:46:21 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: Fix nested bus lock VM exit
Date:   Tue, 14 Sep 2021 17:50:41 +0800
Message-Id: <20210914095041.29764-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
VM exit, it will be directed to L1 VMM, which would cause unexpected
behavior. Therefore, handle L2's bus lock VM exits in L0 directly.

Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

---
Change log
v1->v2
- Because nested bus lock VM exit is not supported and how nested
  support would operate is uncertain. Add a brief comment to state that this
  feature is never exposed to L1 at present. (Sean)
- v1: https://lore.kernel.org/lkml/20210827085110.6763-1-chenyi.qiang@intel.com/
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..5646cc1e8d4c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5873,6 +5873,12 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return true;
+	case EXIT_REASON_BUS_LOCK:
+		/*
+		 * At present, bus lock VM exit is never exposed to L1.
+		 * Handle L2's bus locks in L0 directly.
+		 */
+		return true;
 	default:
 		break;
 	}
-- 
2.17.1

