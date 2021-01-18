Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3098C2F9832
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbhARD1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:27:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:9514 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbhARD1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:27:48 -0500
IronPort-SDR: gmKPwpTvLk5E1AzRr9ule/AVmBBsZuyQ8ULpCEtDt0UTV4C6eoVIV52PTLUzaWX5C0wMn+gUN6
 ks2vGXOITX6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="177975327"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="177975327"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:08 -0800
IronPort-SDR: cnVI9Jgv3qN2ACPBX0GvCeaQsRsu8epxUV3MJ+OrqboEOjtn9YNvEvGDg2gWnUw4H8v5dLREMl
 awAzCwCn+9Xw==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150717"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:04 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 02/26] x86/sgx: Remove a warn from sgx_free_epc_page()
Date:   Mon, 18 Jan 2021 16:26:50 +1300
Message-Id: <85da2c1ce068b77ee9f31f6de9f3a34c36c410eb.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
happen, as enclave pages are freed only at the time when encl->refcount
triggers, i.e. when both VFS and the page reclaimer have given up on
their references.

Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f6948..ebbd3b97b3d0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -605,8 +605,6 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	int ret;
 
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
 	ret = __eremove(sgx_get_epc_virt_addr(page));
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
 		return;
-- 
2.29.2

