Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933CF478FA9
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhLQPaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238206AbhLQPaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755005; x=1671291005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5YKjhTcj/ohmi9omLNbhnFUXVRZVAw/Npu93/co/edI=;
  b=hBMxTzlaV5cC3MDogQpD+3ycxudZOyKzsQm5fnFbDJ0YtYSYCASzS/6O
   c3FpBVeHGXRjegV5+AL0rtHblr/m6dyQ/9Tlxiqqejx+CLdfeHfpSyWGb
   RDnWiCHdK6U2qeBdoZApPexMN8fuSxxhoph8YLCKbW8CVgDd2MBi3O5A+
   36eW6JllBN0xGnsIFz4NPXWG73cXg/mi5eJR2CgwBYl6/tZ5kx3oNy1NM
   ZqFAx30YclRB/0PX9g698hZQZ/qEAMk7eEaE3AOyJq4I/q9T3imAlFxLd
   igqDNuppaVnov6WdmvODh2oVctLwS7RAO8HdjaBSjXcCrPbVaXC5Hvebv
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723434"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723434"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588400"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:04 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 04/23] kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID
Date:   Fri, 17 Dec 2021 07:29:44 -0800
Message-Id: <20211217153003.1719189-5-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_CPUID should not include any dynamic xstates in
CPUID[0xD] if they have not been requested with prctl. Otherwise
a process which directly passes KVM_GET_SUPPORTED_CPUID to
KVM_SET_CPUID2 would now fail even if it doesn't intend to use a
dynamically enabled feature. Userspace must know that prctl is
required and allocate >4K xstate buffer before setting any dynamic
bit.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 Documentation/virt/kvm/api.rst | 4 ++++
 arch/x86/kvm/cpuid.c           | 9 ++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..eb5671ca2dba 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1684,6 +1684,10 @@ userspace capabilities, and with user requirements (for example, the
 user may wish to constrain cpuid to emulate older hardware, or for
 feature consistency across a cluster).
 
+Permissions must be set via prctl() for dynamically-enabled XSAVE
+features before calling this ioctl. Otherwise those feature bits are
+excluded.
+
 Note that certain capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may
 expose cpuid features (e.g. MONITOR) which are not supported by kvm in
 its default configuration. If userspace enables such capabilities, it
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 148003e26cbb..4855344091b8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -812,11 +812,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
-	case 0xd:
-		entry->eax &= supported_xcr0;
+	case 0xd: {
+		u64 guest_perm = xstate_get_guest_group_perm();
+
+		entry->eax &= supported_xcr0 & guest_perm;
 		entry->ebx = xstate_required_size(supported_xcr0, false);
 		entry->ecx = entry->ebx;
-		entry->edx &= supported_xcr0 >> 32;
+		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
 		if (!supported_xcr0)
 			break;
 
@@ -863,6 +865,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
+	}
 	case 0x12:
 		/* Intel SGX */
 		if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
-- 
2.27.0

