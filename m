Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166F135CF1E
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244610AbhDLRC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 13:02:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:47810 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244072AbhDLRCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 13:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618246911; x=1649782911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=SREwCn/7PKpxf2gVwo9+N6e1u7Bhm84NejJPWzPCEhg=;
  b=d/UAtoXf/3A6naBSekLot1rHQPho/2PRTD4piwf47bOrAx2EBsEE2+Z3
   s7T47csuBSk3Zw6nObrNIQ+TexFV8mdduqOTYYIG9qVsbqw8QFBjxsGiU
   PqGlwkDKnkjEhk/YKEqAAL3bd0fPPQjj9yswqvKV6gQy6tcVRhD86c8ig
   c=;
X-IronPort-AV: E=Sophos;i="5.82,216,1613433600"; 
   d="scan'208";a="101147888"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Apr 2021 17:01:43 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 4958EA1C65;
        Mon, 12 Apr 2021 17:01:36 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Apr 2021 17:01:28 +0000
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
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v2 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Date:   Mon, 12 Apr 2021 19:00:17 +0200
Message-ID: <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618244920.git.sidcha@amazon.de>
References: <cover.1618244920.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D16UWB001.ant.amazon.com (10.43.161.17) To
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
 arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
 arch/x86/kvm/hyperv.c              | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index e6cd3fee562b..716f12be411e 100644
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
+ * Support for returning hypercall ouput block via XMM
+ * registers is available
+ */
+#define HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE		BIT(15)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1f9959aba70d..55838c266bcd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2254,6 +2254,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
 
+			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
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



