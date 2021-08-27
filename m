Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69833F9670
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 10:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244673AbhH0IuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 04:50:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:17767 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244510AbhH0IuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 04:50:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="198163521"
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="198163521"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 01:49:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="528239385"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 01:49:23 -0700
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
Subject: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
Date:   Fri, 27 Aug 2021 16:51:10 +0800
Message-Id: <20210827085110.6763-1-chenyi.qiang@intel.com>
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
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..754f53cf0f7a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return true;
+	case EXIT_REASON_BUS_LOCK:
+		return true;
 	default:
 		break;
 	}
-- 
2.17.1

