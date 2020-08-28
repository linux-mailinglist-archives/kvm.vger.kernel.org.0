Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC62556F2
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgH1Iyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:54:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:49198 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgH1Iy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:54:27 -0400
IronPort-SDR: bxz6lcHUOEnzTWAn186YuaJInY+oWp5xal7UczcYH19iUxiKPbksd812NuHXe1NvMRjyNf+DlT
 sBs2l9GGPVwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136697546"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="136697546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:54:27 -0700
IronPort-SDR: c2GF2PiqdEC3O4/gAw/BnftQZg9f6IEQ6QMGh91mpdXSa9LqNKo7qdQM4LzenyeYoA9zmq73f+
 KAp9HzdqoW0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="332483523"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2020 01:54:25 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: nVMX: Simplify the initialization of nested_vmx_msrs
Date:   Fri, 28 Aug 2020 16:56:22 +0800
Message-Id: <20200828085622.8365-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nested VMX controls MSRs can be initialized by the global capability
values stored in vmcs_config.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f9664ccc003b..0c36cd664222 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7019,8 +7019,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
-					   vmx_capability.ept);
+		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
-- 
2.17.1

