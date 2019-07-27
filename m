Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F5D776F4
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfG0Fwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfG0FwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568639"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:16 -0700
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
Subject: [RFC PATCH 20/21] x86/sgx: Export sgx_set_attribute() for use by KVM
Date:   Fri, 26 Jul 2019 22:52:13 -0700
Message-Id: <20190727055214.9282-21-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To prevent userspace from circumventing access to the PROVISIONKEY by
running an enclave in a VM, KVM will deny access to the PROVISIONKEY
unless userspace proves to KVM that it is allowed to access the key.
Export sgx_set_attribute() so that it may be used by KVM to verify an
SGX attribute file.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h             | 2 ++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 1 +
 arch/x86/kernel/cpu/sgx/main.c         | 1 +
 arch/x86/kernel/cpu/sgx/sgx.h          | 1 -
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index f0f0176b8e2f..65c9417d3a80 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -6,6 +6,8 @@
 
 struct sgx_pageinfo;
 
+int sgx_set_attribute(u64 *allowed_attributes, unsigned int attribute_fd);
+
 #if IS_ENABLED(CONFIG_KVM_INTEL)
 int sgx_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs, int *trapnr);
 int sgx_einit(void __user *sigstruct, void __user *token,
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index a1cb5f772363..1b7a05cd9d02 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2016-19 Intel Corporation.
 
 #include <asm/mman.h>
+#include <asm/sgx.h>
 #include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/file.h>
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 542427c6ae9c..68e5c704378a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -336,6 +336,7 @@ int sgx_set_attribute(u64 *allowed_attributes, unsigned int attribute_fd)
 	*allowed_attributes |= SGX_ATTR_PROVISIONKEY;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
 static void sgx_dev_release(struct device *dev)
 {
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 3f3311024bd0..fab12cc0e7c5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -96,6 +96,5 @@ void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce);
 __init int sgx_dev_init(const char *name, struct device *dev,
 			struct cdev *cdev, const struct file_operations *fops,
 			int minor);
-int sgx_set_attribute(u64 *allowed_attributes, unsigned int attribute_fd);
 
 #endif /* _X86_SGX_H */
-- 
2.22.0

