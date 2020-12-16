Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B32DB97E
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 03:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgLPC45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 21:56:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:9465 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgLPC45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 21:56:57 -0500
IronPort-SDR: l/GbeQzpI/RUt2XvSSFs08soNGP+wKjlqV95/u4oYn6QpEbA5JVDaRcae8dzHCx+lki1hLoa4y
 DkhKje1WWsjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="175099207"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="175099207"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 18:56:02 -0800
IronPort-SDR: +VwLccgiubthbN3MImiBbjdrCD7vWyJpzM1SJMs6x1PVBVDNKi3fXXqnXmKzhl3/SuVjKXn43O
 YFZvj0pk4JnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="451538814"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2020 18:55:59 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 2/2] KVM: Expose AVX_VNNI instruction to guset
Date:   Wed, 16 Dec 2020 10:01:29 +0800
Message-Id: <20201216020129.19875-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20201216020129.19875-1-yang.zhong@intel.com>
References: <20201216020129.19875-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose AVX (VEX-encoded) versions of the Vector Neural Network
Instructions to guest.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 4] AVX_VNNI

The following instructions are available when this feature is
present in the guest.
  1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
  2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
  3. VPDPWSSD: Multiply and Add Signed Word Integers
  4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation

This instruction is currently documented in the latest "extensions"
manual (ISE). It will appear in the "main" manual (SDM) in the future.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83637a2ff605..4229b67f0a8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -433,7 +433,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.29.2.334.gfaefdd61ec

