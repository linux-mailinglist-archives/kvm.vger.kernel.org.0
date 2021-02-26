Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B3326281
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhBZMQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:16:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:15306 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhBZMPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:15:44 -0500
IronPort-SDR: /g/LaYKwvNqUJ+Csdu/YZfMTp6KRF8UUqVqTtK8kq7Xp/txqHqeRkTqCFvbwTxo3rt0GOJcjVG
 Kl3fiAxEb5Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="249915869"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="249915869"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:14:54 -0800
IronPort-SDR: UMWrUsRjUISrsKcQmZxGv+ld0tdyie+vxgoQtz1Rk24vqp3XlRJwPUIj5zghWgLgu8ydSffZW+
 dEQx/hKDa+7Q==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420377"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:14:51 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 04/25] x86/sgx: Add SGX_CHILD_PRESENT hardware error code
Date:   Sat, 27 Feb 2021 01:14:30 +1300
Message-Id: <856b5aed1249224cfb9e4367eda62b2976626c54.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
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

Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
the SGX virtualization driver to handle recoverable EREMOVE errors when
saniziting EPC pages after they are freed.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
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

