Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE3304385
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403768AbhAZQOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:14:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:57481 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391159AbhAZJbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:31:31 -0500
IronPort-SDR: f9ykjK7GvKKWCA501BA+odjQqMLHlHXUbld6iyCpmOgDrB31UkzDt4gk7BBnsIanvWsjP5up4j
 louoXNXreAUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="166973530"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="166973530"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:30:42 -0800
IronPort-SDR: lQqlN8xrU5eUBtzX7cMfgfTeLu6fdRx3C01JLEBYcuoAeA0EIt1Vg1vfSBB1OwbVaO5s8aNwjO
 wfNcOZwWmWKA==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747502"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:30:39 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from sgx_free_epc_page()
Date:   Tue, 26 Jan 2021 22:30:18 +1300
Message-Id: <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
happen, as enclave pages are freed only at the time when encl->refcount
triggers, i.e. when both VFS and the page reclaimer have given up on
their references.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..f330abdb5bb1 100644
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

