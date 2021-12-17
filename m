Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC75478FBD
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbhLQPaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238256AbhLQPaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755009; x=1671291009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k1pytctA/1NzjqzonA+Gg9kC3oNIv2NNsblbfpdxUOI=;
  b=AvU13g49JH5AG2DPYTOBoswLhjT0wufpsqikZQKMsYA9PHLPw4Cr/iK9
   9C1k4XIiPMLmohLCdVZkt3tTsFFklah2zmwFn9QPLBPSXCN97RviK9YGg
   SHWIth4EyLXDI0dMhvwV0mMUZEZAVCAfnVTrTXwzKdlsn4Wv9m0XLuafx
   D2f8uQBryuGu14h8vMs1FVzs3EoJtwvRoZxj6mhyRtFi75/kYAj/emwwO
   zMiYal62JobVX8nuXiSzRGkxUJ7eP8tiRrTyRCBZd3Hv1BhK/URfWmanv
   Khzk245rrbCq4E1dokFjTzb41ZDNebl4Gl9wfJH3BpIgf+p/0C2mwe3FR
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723481"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723481"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588481"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of IA32_XFD_ERR
Date:   Fri, 17 Dec 2021 07:30:03 -0800
Message-Id: <20211217153003.1719189-24-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also disable read emulation of IA32_XFD_ERR MSR at the same point
where r/w emulation of IA32_XFD MSR is disabled. This saves one
unnecessary VM-exit in guest #NM handler, given that the MSR is
already restored with the guest value before the guest is resumed.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97a823a3f23f..b66a005f076b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -163,6 +163,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
 	MSR_IA32_XFD,
+	MSR_IA32_XFD_ERR,
 #endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
@@ -1934,6 +1935,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 static void vmx_set_xfd_passthrough(struct kvm_vcpu *vcpu)
 {
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R);
 	vcpu->arch.xfd_out_of_sync = true;
 }
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bf9d3051cd6c..0a00242a91e7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -340,7 +340,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.27.0

