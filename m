Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F2D3F94BB
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244315AbhH0HEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:6107 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232463AbhH0HD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:03:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045874"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045874"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553014"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:02 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: VMX: Restore host's MSR_IA32_RTIT_CTL when it's not zero
Date:   Fri, 27 Aug 2021 15:02:43 +0800
Message-Id: <20210827070249.924633-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A minor optimization to WRMSR MSR_IA32_RTIT_CTL when necessary.

Opportunistically refine the comment to call out that KVM requires
VM_EXIT_CLEAR_IA32_RTIT_CTL to expose PT to the guest.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v2:
 - Refine comments
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..5535a86aea37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1074,8 +1074,12 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
 	}
 
-	/* Reload host state (IA32_RTIT_CTL will be cleared on VM exit). */
-	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+	/*
+	 * KVM requires VM_EXIT_CLEAR_IA32_RTIT_CTL to expose PT to the guest,
+	 * i.e. RTIT_CTL is always cleared on VM-Exit.  Restore it if necessary.
+	 */
+	if (vmx->pt_desc.host.ctl)
+		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
-- 
2.27.0

