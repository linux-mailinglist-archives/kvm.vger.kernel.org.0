Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4B327B22
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhCAJtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:49:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:62394 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234154AbhCAJq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:46:58 -0500
IronPort-SDR: ygObrp1Lk2XrS9O4ei6AFAy4gKCcjxvcrZX7mDSVYCeNmIgTs9C96BanlWZf2y20K4PXbBNOT0
 6Wi1/h20rPoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="271409584"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="271409584"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:46:17 -0800
IronPort-SDR: +fnb+iqs/pCcwPUO8ugtvD6G3QSsn0aDB9mwopYTCWfdSK8BQPyn2PEDJQGA3oxbMjtKIqkPW4
 NX6TGop2KEqg==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267604"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:46:13 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 16/25] KVM: x86: Define new #PF SGX error code bit
Date:   Mon,  1 Mar 2021 22:45:49 +1300
Message-Id: <066d2b8c78c81c9f92873f7ed03420484efc5404.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
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
index 0cf71ff2b2e5..aa6b5146eafe 100644
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
2.29.2

