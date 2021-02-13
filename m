Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0619A31ABC6
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBMNbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:31:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:30435 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhBMNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:30:55 -0500
IronPort-SDR: VSaFA42upYj5pAlz0zaCOKT6PF0EexoVqkjfj2+PWkTgTVqVtPiA+UOVZYVIb9V45vk7EHbEcz
 9viRkZAvcrDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="201682447"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="201682447"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:14 -0800
IronPort-SDR: Uzo5LOm0LPE8DZ3QRFkMxWq0KSliwb0k5mALwhO5P3SrrmK+6lFxQKOiZV5yGdSBpY0STh6QY1
 5iOjGDe1ADMA==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366164"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:09 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 17/26] KVM: x86: Define new #PF SGX error code bit
Date:   Sun, 14 Feb 2021 02:29:45 +1300
Message-Id: <5a661f74b783a73dc8920a6a771e222b6b11e468.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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
index 3d6616f6f6ef..9581f81e62a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -216,6 +216,7 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_BIT 3
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
+#define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 
@@ -225,6 +226,7 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
 #define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
 #define PFERR_PK_MASK (1U << PFERR_PK_BIT)
+#define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
 
-- 
2.29.2

