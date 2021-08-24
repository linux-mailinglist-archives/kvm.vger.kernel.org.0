Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3366E3F5CD9
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhHXLJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:09:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:3702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236706AbhHXLJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:09:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204423835"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204423835"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="493501638"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2021 04:08:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: VMX: Restore host's MSR_IA32_RTIT_CTL when it's not zero
Date:   Tue, 24 Aug 2021 19:07:39 +0800
Message-Id: <20210824110743.531127-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210824110743.531127-1-xiaoyao.li@intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A minor optimation to WRMSR MSR_IA32_RTIT_CTL when necessary.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..e0a9460e4dab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1075,7 +1075,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	}
 
 	/* Reload host state (IA32_RTIT_CTL will be cleared on VM exit). */
-	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+	if (vmx->pt_desc.host.ctl)
+		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
-- 
2.27.0

