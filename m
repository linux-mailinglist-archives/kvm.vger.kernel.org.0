Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5C3576A0
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 23:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhDGVVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 17:21:32 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9952 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhDGVV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 17:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617830477; x=1649366477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xsTGeKDuyWT9psfm+ie62W9vUXSX2beUptv0qY6iZkc=;
  b=CGHXM+1D8qhfLUzL6i8sM3caqKVvh7r9yx2/Av1pjPHnvztKAxFlcl/R
   BpH9+uRdP/tB4puGH/1Dze8vWs8M/VAMTRDKjkff7kHZkqE/yTby4fpdr
   TcqttnK9XGmRGgRAYn7NnI7FcgssdBcvN3st/UjPHbUupvmV7forsLWHZ
   E=;
X-IronPort-AV: E=Sophos;i="5.82,204,1613433600"; 
   d="scan'208";a="104599060"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Apr 2021 21:21:09 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 9B8A9A2124;
        Wed,  7 Apr 2021 21:21:07 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.41) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Apr 2021 21:20:59 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Date:   Wed, 7 Apr 2021 23:19:54 +0200
Message-ID: <20210407211954.32755-5-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407211954.32755-1-sidcha@amazon.de>
References: <20210407211954.32755-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13D06UWA003.ant.amazon.com (10.43.160.13) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all extant hypercalls that can use XMM registers (based on
spec) for input/outputs are patched to support them, we can start
advertising this feature to guests.

Cc: Alexander Graf <graf@amazon.com>
Cc: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
 arch/x86/kvm/hyperv.c              | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index e6cd3fee562b..1f160ef60509 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -49,10 +49,10 @@
 /* Support for physical CPU dynamic partitioning events is available*/
 #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
 /*
- * Support for passing hypercall input parameter block via XMM
+ * Support for passing hypercall input and output parameter block via XMM
  * registers is available
  */
-#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
+#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4) | BIT(15)
 /* Support for a virtual guest idle state is available */
 #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
 /* Frequency MSRs available */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bf2f86f263f1..dd462c1d641d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2254,6 +2254,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
 
+			ent->edx |= HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



