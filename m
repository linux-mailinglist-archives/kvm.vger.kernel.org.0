Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C847FAF0
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhL0IRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:17:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:41613 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235569AbhL0IRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 03:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640593043; x=1672129043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6gwEeKLEMbxvYxSECEpoif+ET9leBqLI2zBcqc8zWyA=;
  b=oJ7V9kHKpyZHBYPhCAYfY6GuvkD52qNhQD8932g1UdSV7PZySMb1rHuZ
   xbsVL1w7SeJmoq0GbH8iBpA8d25V+cWs1HkeE2aq4oMYCVY/sgyKZZG1/
   lZaTplBun6vJYwOczhZskpszImN9rYmdSjexOGEvfvZoVpSlmiMG6O19/
   uRxeXbv3If9iJetPLGVwZtOIsQmYRT7XXXKc8l0YFuMD6urdXliuhjLpm
   6R7AyDdDx9hy6doCGIR38478WU1bJ68/rV0KwqKPoWGzst6GGfJO/9zz5
   J7Gox8XZsFFFvV2Pe1aKDNpUsND88NJb7U0Rlw+yyO1imyBH3+BDh8a0L
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="304541632"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="304541632"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="523208037"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:17 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] KVM: x86: Use kvm_x86_ops in kvm_arch_check_processor_compat
Date:   Mon, 27 Dec 2021 16:15:08 +0800
Message-Id: <20211227081515.2088920-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211227081515.2088920-1-chao.gao@intel.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

check_processor_compatibility() is a "runtime" ops now. Use
kvm_x86_ops directly such that kvm_arch_check_processor_compat
can be called at runtime.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6411417b6871..770b68e72391 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11383,7 +11383,6 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
@@ -11391,7 +11390,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->runtime_ops->check_processor_compatibility();
+	return kvm_x86_ops.check_processor_compatibility();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.25.1

