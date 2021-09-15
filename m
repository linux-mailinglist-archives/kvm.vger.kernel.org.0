Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C592B40C68C
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhIONmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 09:42:08 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20764 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhIONmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 09:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1631713249; x=1663249249;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9SyFPUNj7I5Ph0+cJPH2EJBPGqn85KC6XI4O4pHXcoY=;
  b=ljZJ+Ia3cLVUEnnLa2/m5HoFAa1YeVHD9Pm+OZw6zUwCYgWsBjHYFJGE
   c6wu6Gw+wFq+f3c5KCzvgdfi6jImVk3mDqptM+p1kTbn5mwDCeoakataw
   eYmGPAyif8M0SP79TGsdmBuvvV95BW/kLoMGvHRjwsH0o3DFlQB+EoBj4
   Y=;
X-IronPort-AV: E=Sophos;i="5.85,295,1624320000"; 
   d="scan'208";a="137451068"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 15 Sep 2021 13:40:38 +0000
Received: from EX13D07EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com (Postfix) with ESMTPS id 65A0741661;
        Wed, 15 Sep 2021 13:40:37 +0000 (UTC)
Received: from dev-dsk-faresx-1b-818bcd8f.eu-west-1.amazon.com (10.43.161.176)
 by EX13D07EUA003.ant.amazon.com (10.43.165.176) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 15 Sep 2021 13:40:31 +0000
From:   Fares Mehanna <faresx@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Fares Mehanna <faresx@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
Date:   Wed, 15 Sep 2021 13:39:50 +0000
Message-ID: <20210915133951.22389-1-faresx@amazon.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D24UWB002.ant.amazon.com (10.43.161.159) To
 EX13D07EUA003.ant.amazon.com (10.43.165.176)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel PMU MSRs is in msrs_to_save_all[], so add AMD PMU MSRs to have a
consistent behavior between Intel and AMD when using KVM_GET_MSRS,
KVM_SET_MSRS or KVM_GET_MSR_INDEX_LIST.

We have to add legacy and new MSRs to handle guests running without
X86_FEATURE_PERFCTR_CORE.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..14bc21fb698c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1332,6 +1332,13 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
+	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
+	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
+	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
+	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
+	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



