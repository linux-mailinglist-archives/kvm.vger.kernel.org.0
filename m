Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC703CB493
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 10:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhGPIjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 04:39:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:15663 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238334AbhGPIjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 04:39:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="210687312"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="210687312"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="460679843"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 16 Jul 2021 01:36:33 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 08/12] KVM: x86: Report XSS as an MSR to be saved if there are supported features
Date:   Fri, 16 Jul 2021 16:50:02 +0800
Message-Id: <1626425406-18582-9-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com>
References: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add MSR_IA32_XSS to the list of MSRs reported to userspace if
supported_xss is non-zero, i.e. KVM supports at least one XSS based
feature.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20210203113421.5759-2-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f2e13c9f507..c225260c949e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1299,6 +1299,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
+	MSR_IA32_XSS,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6058,6 +6059,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
 				continue;
 			break;
+		case MSR_IA32_XSS:
+			if (!supported_xss)
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.21.1

