Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F68341680
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhCSHYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:44045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhCSHYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:24:04 -0400
IronPort-SDR: S761WjGnlmmAS39OgZdA19UXERHEva4zD6aERPUhYQYRZz1vq1mjux7xLWnr9NR96Wow2yOy8L
 4n0WRHezCQAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="169143687"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="169143687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:04 -0700
IronPort-SDR: SvgKwK5PnLRmOCR47dQgAEtvbMdvSMa5d6LmF5z1aNmFURg8jlschiuKLod/MqDuSUJi0H6CMC
 cXYUSMQuGFmQ==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409867"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:00 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 16/25] KVM: x86: Define new #PF SGX error code bit
Date:   Fri, 19 Mar 2021 20:23:40 +1300
Message-Id: <c42a1621eb64dac1296c25061ad3bcca52d23243.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
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
index 9bc091ecaaeb..8b1c13056768 100644
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

