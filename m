Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848AE46BEE8
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbhLGPOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:14:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:53832 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238832AbhLGPNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237536539"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237536539"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290184"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:10:11 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 17/19] docs: virt: api.rst: Document the new KVM_{G, S}ET_XSAVE2 ioctls
Date:   Tue,  7 Dec 2021 19:03:57 -0500
Message-Id: <20211208000359.2853257-18-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Document the detailed information of the new KVM_{G, S}ET_XSAVE2 ioctls.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 Documentation/virt/kvm/api.rst | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..39dfd867e429 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1569,6 +1569,8 @@ otherwise it will return EBUSY error.
   };
 
 This ioctl would copy current vcpu's xsave struct to the userspace.
+Application should use KVM_GET_XSAVE2 if xsave states are larger than
+4KB.
 
 
 4.43 KVM_SET_XSAVE
@@ -1588,6 +1590,8 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
   };
 
 This ioctl would copy userspace's xsave struct to the kernel.
+Application should use KVM_SET_XSAVE2 if xsave states are larger than
+4KB.
 
 
 4.44 KVM_GET_XCRS
@@ -7484,3 +7488,46 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_GET_XSAVE2
+-------------------
+
+:Capability: KVM_CAP_XSAVE2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_xsave2 (in)
+:Returns: 0 on success, -1 on error
+
+
+::
+
+  struct kvm_xsave2 {
+	__u32 size;
+	__u8 state[0];
+  };
+
+This ioctl is used for copying current vcpu's xsave struct to the
+userspace when xsave state size is larger than 4KB. Application code
+should set the 'size' member which indicates the size of xsave state
+and KVM copies the xsave state into the 'state' region.
+
+8.36 KVM_SET_XSAVE2
+-------------------
+
+:Capability: KVM_CAP_XSAVE2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_xsave2 (out)
+:Returns: 0 on success, -1 on error
+
+
+::
+
+  struct kvm_xsave2 {
+	__u32 size;
+	__u8 state[0];
+  };
+
+This ioctl is used for copying userspace's xsave struct to the kernel
+when xsave size is larger than 4KB. Application code should set the
+'size' member which indicates the size of xsave state.
