Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E963A35B93C
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhDLEWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:53377 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhDLEWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:15 -0400
IronPort-SDR: DPORy8tw9F92UVgArQQ9QB/y4Pt+kHFqMGDmDj0fltW4zpJLw5jBtHhQm4aYKj/rVMxzudRnz3
 uCNObwC2REhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083750"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083750"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:57 -0700
IronPort-SDR: SUTPjzhVWjdP4DPoKmYTj2YGqU707zohUtG7pX38J5/oAIAYDjDxQr0DDTLGZIh3zmPwP2GNJJ
 L4351UjT+huQ==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030353"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:54 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 02/11] KVM: x86: Define new #PF SGX error code bit
Date:   Mon, 12 Apr 2021 16:21:34 +1200
Message-Id: <e170c5175cb9f35f53218a7512c9e3db972b97a2.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Page faults that are signaled by the SGX Enclave Page Cache Map (EPCM),
as opposed to the traditional IA32/EPT page tables, set an SGX bit in
the error code to indicate that the #PF was induced by SGX.  KVM will
need to emulate this behavior as part of its trap-and-execute scheme for
virtualizing SGX Launch Control, e.g. to inject SGX-induced #PFs if
EINIT faults in the host, and to support live migration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44f893043a3c..5368ef719709 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -227,6 +227,7 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_BIT 3
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
+#define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 
@@ -236,6 +237,7 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
 #define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
 #define PFERR_PK_MASK (1U << PFERR_PK_BIT)
+#define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
 
-- 
2.30.2

