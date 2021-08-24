Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B61B3F592E
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhHXHlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:41:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:59076 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234876AbhHXHls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:41:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="215413445"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="215413445"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402141"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:40:58 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 08/15] KVM: x86: Report XSS as an MSR to be saved if there are supported features
Date:   Tue, 24 Aug 2021 15:56:10 +0800
Message-Id: <1629791777-16430-9-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
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
index 08a58ef8bec2..2ebb05212652 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1328,6 +1328,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
+	MSR_IA32_XSS,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6238,6 +6239,10 @@ static void kvm_init_msr_list(void)
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
2.25.1

