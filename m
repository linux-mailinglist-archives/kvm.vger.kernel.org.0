Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA031744AB
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 04:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgB2DJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 22:09:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:7144 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgB2DJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 22:09:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 19:09:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,498,1574150400"; 
   d="scan'208";a="232447150"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.60])
  by orsmga008.jf.intel.com with ESMTP; 28 Feb 2020 19:09:25 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Remove unnecessary brackets in kvm_arch_dev_ioctl()
Date:   Sat, 29 Feb 2020 10:52:12 +0800
Message-Id: <20200229025212.156388-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_arch_dev_ioctl(), the brackets of case KVM_X86_GET_MCE_CAP_SUPPORTED
accidently encapsulates case KVM_GET_MSR_FEATURE_INDEX_LIST and case
KVM_GET_MSRS. It doesn't affect functionality but it's misleading.

Remove unnecessary brackets and opportunistically add a "break" in the
default path.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de200663f51..e49f3e735f77 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3464,7 +3464,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
+	case KVM_X86_GET_MCE_CAP_SUPPORTED:
 		r = -EFAULT;
 		if (copy_to_user(argp, &kvm_mce_cap_supported,
 				 sizeof(kvm_mce_cap_supported)))
@@ -3496,9 +3496,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_MSRS:
 		r = msr_io(NULL, argp, do_get_msr_feature, 1);
 		break;
-	}
 	default:
 		r = -EINVAL;
+		break;
 	}
 out:
 	return r;
-- 
2.19.1

