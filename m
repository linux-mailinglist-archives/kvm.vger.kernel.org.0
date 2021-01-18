Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA12F9835
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbhARD2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:28:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:9511 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbhARD2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:04 -0500
IronPort-SDR: Hw54pXySJkBHp0ta6ZO3AC4Oy95DgUzpXW8leZ+ylv9jCRvJwmMRQBrzNflsYchcDpkIuQfhnt
 5BlKxhy0B9Kg==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="177975336"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="177975336"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:15 -0800
IronPort-SDR: FUpiJ7pIQRFLgovY9Q/mB3ZzGPvR1PXhPIUTB7h6ntRvZWYNmahB2L8zK/QTkArAE5LwaaHBwO
 8sA6I4bCbE5A==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150738"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:12 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware error code
Date:   Mon, 18 Jan 2021 16:26:52 +1300
Message-Id: <9638853bc880d5699e01bdf14b37814e2b08065f.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

SGX virtualization requires to allocate "raw" EPC and use it as "virtual
EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
track how EPC pages are used in VM, e.g. (de)construction of enclaves,
so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
knowledge of which pages are SECS with non-zero child counts.

Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
failures are expected, but only due to SGX_CHILD_PRESENT.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Change title to reflect hardware error code.

---
 arch/x86/kernel/cpu/sgx/arch.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index dd7602c44c72..56b0f8ae3f92 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -26,12 +26,14 @@
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
+ * %SGX_CHILD_PRESENT		Enclave has child pages present in the EPC.
  * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
 	SGX_NOT_TRACKED			= 11,
+	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_UNMASKED_EVENT		= 128,
 };
-- 
2.29.2

