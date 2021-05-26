Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63F0391357
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhEZJGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:06:09 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:35158 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhEZJGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 05:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622019876; x=1653555876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oV2PHEZKLJ4APlVFObfIhdSOmC4bFW7gi3vcaiKLpp8=;
  b=tGPjlgJPSUgKgg0IvJkHvgmq4abo2803kjzwhE7JgNgLkUvV4A2GxwYo
   F4X44uJd++qVuhdU9hrt/K0C9XwuYeQeHmzhvCnGtjlZUFPPxAKkvHcFE
   8rC8XPNYB7x3IC4T2R8/zhmCoHZqX3zFEttg0i7OUv9fVcZzhXj+TsotW
   w=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="116135859"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 26 May 2021 09:04:25 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 868B6A1BF0;
        Wed, 26 May 2021 09:04:23 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.93) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 09:04:14 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [PATCH v4 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Date:   Wed, 26 May 2021 11:03:56 +0200
Message-ID: <e63fc1c61dd2efecbefef239f4f0a598bd552750.1622019134.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1622019133.git.sidcha@amazon.de>
References: <cover.1622019133.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D40UWA002.ant.amazon.com (10.43.160.149) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_hv_flush_tlb() has been patched to support XMM hypercall
inputs, we can start advertising this feature to guests.

Cc: Alexander Graf <graf@amazon.com>
Cc: Evgeny Iakovlev <eyakovl@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
 arch/x86/kvm/hyperv.c              | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 27a9f08e8386..9fe4cc9c0f7d 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -52,7 +52,7 @@
  * Support for passing hypercall input parameter block via XMM
  * registers is available
  */
-#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
+#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
 /* Support for a virtual guest idle state is available */
 #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
 /* Frequency MSRs available */
@@ -61,6 +61,11 @@
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
 /* Support for debug MSRs available */
 #define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
+/*
+ * Support for returning hypercall output block via XMM
+ * registers is available
+ */
+#define HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE		BIT(15)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8fcaf3fc9c2a..09270d13053b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2235,6 +2235,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
 
+			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
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



