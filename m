Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB707770A
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfG0Fxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:40958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfG0FwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568581"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 01/21] x86/sgx: Add defines for SGX device minor numbers
Date:   Fri, 26 Jul 2019 22:51:54 -0700
Message-Id: <20190727055214.9282-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add defines to track the minor numbers for each SGX device in
preparation for moving the helper code and provisioning device to the
common subsystem, and in preparation for adding a third device, i.e. a
virtual EPC device.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/driver.h | 1 -
 arch/x86/kernel/cpu/sgx/driver/main.c   | 9 +++++----
 arch/x86/kernel/cpu/sgx/sgx.h           | 4 ++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index da60839b133a..6ce18c766a5a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -15,7 +15,6 @@
 #include "../encls.h"
 #include "../sgx.h"
 
-#define SGX_DRV_NR_DEVICES	2
 #define SGX_EINIT_SPIN_COUNT	20
 #define SGX_EINIT_SLEEP_COUNT	50
 #define SGX_EINIT_SLEEP_TIME	20
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index bb7f1932529f..a2506a49c95a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -211,7 +211,7 @@ int __init sgx_drv_init(void)
 	if (ret)
 		return ret;
 
-	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
+	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_MAX_NR_DEVICES, "sgx");
 	if (ret < 0)
 		goto err_bus;
 
@@ -238,12 +238,13 @@ int __init sgx_drv_init(void)
 	}
 
 	ret = sgx_dev_init("sgx/enclave", &sgx_encl_dev, &sgx_encl_cdev,
-			   &sgx_encl_fops, 0);
+			   &sgx_encl_fops, SGX_ENCL_DEV_MINOR);
 	if (ret)
 		goto err_chrdev_region;
 
 	ret = sgx_dev_init("sgx/provision", &sgx_provision_dev,
-			   &sgx_provision_cdev, &sgx_provision_fops, 1);
+			   &sgx_provision_cdev, &sgx_provision_fops,
+			   SGX_PROV_DEV_MINOR);
 	if (ret)
 		goto err_encl_dev;
 
@@ -277,7 +278,7 @@ int __init sgx_drv_init(void)
 	put_device(&sgx_encl_dev);
 
 err_chrdev_region:
-	unregister_chrdev_region(sgx_devt, SGX_DRV_NR_DEVICES);
+	unregister_chrdev_region(sgx_devt, SGX_MAX_NR_DEVICES);
 
 err_bus:
 	bus_unregister(&sgx_bus_type);
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index c9276d4b6ffe..4e2c3ce94f63 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -89,4 +89,8 @@ void sgx_free_page(struct sgx_epc_page *page);
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
+#define SGX_ENCL_DEV_MINOR	0
+#define SGX_PROV_DEV_MINOR	1
+#define SGX_MAX_NR_DEVICES	2
+
 #endif /* _X86_SGX_H */
-- 
2.22.0

