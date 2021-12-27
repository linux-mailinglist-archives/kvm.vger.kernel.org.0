Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDD347FAF8
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhL0IRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:17:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:31646 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235620AbhL0IRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 03:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640593069; x=1672129069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BmPh+jIgxcTIdvBnq8DhbVnkozm0iynu2KVv6M+ZfSE=;
  b=T71aAlRVsUiXswIEczSYUOEKffjne3laiqMe614EuiqDkGhkHeFH+ifs
   d17yzzJ0UGuxGav2B1MPzZo9K+m7doy8CkBSsMu2ErFeL0phAXanI1R5U
   c651ErLNOSg9rDwbS29GpaVJFTjFL5T+Zzpq5Z3Om3LWHaSiU1daV5EVJ
   KPcvPTWDzQXe/FHTgucnhdUsejjfN9pGzKz5QOro5kMnsWAYDC4nNV3uQ
   EDotMTl2zI5HWLywOVpxjNQDD1DCq88Ij8tgQ+uvjfh6NQua64iCY1+ub
   2421VWegdUKt4gLK+L35vSLCDRSWS8EfqpCstZCB/N6+2vPakyrNH49Z3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221182107"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="221182107"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="523208173"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:44 -0800
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
Subject: [PATCH 5/6] KVM: x86: Remove WARN_ON in kvm_arch_check_processor_compat
Date:   Mon, 27 Dec 2021 16:15:11 +0800
Message-Id: <20211227081515.2088920-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211227081515.2088920-1-chao.gao@intel.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_check_processor_compat() needn't be called with interrupt
disabled, as it only reads some CRs/MSRs which won't be clobbered
by interrupt handlers or softirq.

What really needed is disabling preemption. No additional check is
added because if CONFIG_DEBUG_PREEMPT is enabled, smp_processor_id()
(right above the WARN_ON()) can help to detect any violation.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa09c8792134..a80e3b0c11a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11384,8 +11384,6 @@ int kvm_arch_check_processor_compat(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
-	WARN_ON(!irqs_disabled());
-
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
-- 
2.25.1

