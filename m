Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EB4478FB8
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbhLQPaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238247AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+lLK4UqLTW8dKnWDYMWJ8zGKlRHYspG68U7ZipxVqg4=;
  b=XzH/fg/Ze3ElHRJ4XqcP1xwtCyuQvg/afNSSFf8wunnO1hTTlYCXxlmA
   GZBjlrtzVOgA7BDyLboncL3vpcz71c3XhyCRmEZvI1mrIvjwKvsTMMfvN
   X5hZcVTxXBxSdoW3n/8H8FVIOxS8zyNomTRyTPXNs5rFs5r2DbeGsErk1
   uf/oFeBm5dsNBmQp9a/FphLW1J869Um76GzI/D7uvVUA9Js4z3fUCLJZE
   h4AbWxoaAYxv7nVpk0c2IB/ROeYVNbDgl5Fwu+A2yNGhUc/QkrLaIx52m
   K0ixyf89dzrmxL3v6TOSQVkJEcWqKhdniy3ftHL0q2hfsH4fSpxDT2leI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723474"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723474"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588472"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 20/23] docs: kvm: Add KVM_GET_XSAVE2
Date:   Fri, 17 Dec 2021 07:30:00 -0800
Message-Id: <20211217153003.1719189-21-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

Update the api doc with the new KVM_GET_XSAVE2 ioctl, which is used
when KVM_CAP_XSAVE2 is negotiated with the userspace. KVM_SET_XSAVE
ioctl is re-used when KVM_CAP_XSAVE2 is used. The kvm_xsave struct
is updated to support data size larger that the legacy hardcoded 4KB.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 Documentation/virt/kvm/api.rst | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb5671ca2dba..0f4ed2d4aea6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1566,15 +1566,18 @@ otherwise it will return EBUSY error.
 
   struct kvm_xsave {
 	__u32 region[1024];
+	__u32 extra[0];
   };
 
 This ioctl would copy current vcpu's xsave struct to the userspace.
+Application should use KVM_GET_XSAVE2 if xsave states are larger than
+4KB.
 
 
 4.43 KVM_SET_XSAVE
 ------------------
 
-:Capability: KVM_CAP_XSAVE
+:Capability: KVM_CAP_XSAVE and KVM_CAP_XSAVE2
 :Architectures: x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_xsave (in)
@@ -1585,9 +1588,12 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
 
   struct kvm_xsave {
 	__u32 region[1024];
+	__u32 extra[0];
   };
 
 This ioctl would copy userspace's xsave struct to the kernel.
+Application can use this ioctl for xstate buffer in any size
+returned from KVM_CHECK_EXTENSION(KVM_CAP_XSAV2).
 
 
 4.44 KVM_GET_XCRS
@@ -5507,6 +5513,27 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
+4.42 KVM_GET_XSAVE2
+------------------
+
+:Capability: KVM_CAP_XSAVE2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_xsave (out)
+:Returns: 0 on success, -1 on error
+
+
+::
+
+  struct kvm_xsave {
+	__u32 region[1024];
+	__u32 extra[0];
+  };
+
+This ioctl would copy current vcpu's xsave struct to the userspace.
+Application can use this ioctl for xstate buffer in any size
+returned from KVM_CHECK_EXTENSION(KVM_CAP_XSAV2).
+
 5. The kvm_run structure
 ========================
 
-- 
2.27.0

