Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A085313005
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhBHLCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:02:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:12408 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232724AbhBHK5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:57:34 -0500
IronPort-SDR: CNbOY0pMCjEp4sWdBD8A0m8jS09QKDZeJDve9K4MGawH+tCdxefNa0FK5KUhZ3bJi4VvnfbO5x
 NdQXhDWUeahQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="160848447"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="160848447"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:37 -0800
IronPort-SDR: 6P61UZizKkR5CojD8/MKiSjDZ6UECYyFwBCXXug/ZAWDcsmBdQf0SgH9ljgR+lTVV7e5JgEGCT
 Yku6NfzTaJrA==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374450973"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:33 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware error code
Date:   Mon,  8 Feb 2021 23:54:08 +1300
Message-Id: <3c1edb38e95843eb9bf3fcbbec6cf9bdd9b3e7b1.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

SGX driver can accurately track how enclave pages are used.  This
enables SECS to be specifically targeted and EREMOVE'd only after all
child pages have been EREMOVE'd.  This ensures that SGX driver will
never encounter SGX_CHILD_PRESENT in normal operation.

Virtual EPC is different.  The host does not track how EPC pages are
used by the guest, so it cannot guarantee EREMOVE success.  It might,
for instance, encounter a SECS with a non-zero child count.

Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
failures are expected, but only due to SGX_CHILD_PRESENT.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v3->v4:

 - Refined the commit msg, per Dave.

v2->v3:

 - Changed from 'Enclave has child' to 'SECS has child', per Jarkko.

---
 arch/x86/kernel/cpu/sgx/arch.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index dd7602c44c72..abf99bb71fdc 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -26,12 +26,14 @@
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
+ * %SGX_CHILD_PRESENT		SECS has child pages present in the EPC.
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

