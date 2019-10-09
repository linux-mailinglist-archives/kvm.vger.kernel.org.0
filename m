Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48E6D17BD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfJIStC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 14:49:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39047 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIStC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 14:49:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so2192885pff.6
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 11:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5JT5BqYzWgdcUuJqlGrdUisKxLgRHHYApsGEuvTJYwE=;
        b=cxWoJdy2ZHq7VOTxRUSY/YfP9mJZf/7DjAFU4/WqQAD1iybZn2Y0M/SaR4qmuYBW9I
         bLERDLcktnoUEEcjQHz5qxF02Hs2y/oMv3TQZBky8yu3k1RifY+btYs0fgGSsRn9IQBU
         J/Bm/gIVQGosNw31tNFw4/h1hG7SRYsCZTlLqEdkoQL7G/IjEk6UyPZ+nr+bMefdVnUM
         QeoLww1TfWfqR+ZknkoW+VeeoYklsimselT+JAo8ImdAiAOykfHWRAXCRM1x+QPt64W6
         WzDpjOVHvXYz+YTdnc2NIfKTdKx7Dh08v7DdIbBMlCjfthuRohvCWFkaOs3/FF28cDMQ
         42fw==
X-Gm-Message-State: APjAAAUib04Lf7W1MtrlCPBO3JyxhRrk1+gwVI8Fe5ziFQp1z7hsT4Kt
        17wIedIqadJDeIr3cj7CQsOjzpuAJV8=
X-Google-Smtp-Source: APXvYqzbA2YcqR791W0R4HuiJWTyS2VFof6CIto1USMYTkrG6ttoyVRYL5ZJapcdIQGblVx4lWkpcA==
X-Received: by 2002:a17:90a:be15:: with SMTP id a21mr6005311pjs.52.1570646940894;
        Wed, 09 Oct 2019 11:49:00 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id q88sm6448818pjq.9.2019.10.09.11.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 11:49:00 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: vmx: Fix the check whether CMCI is supported
Date:   Wed,  9 Oct 2019 04:27:54 -0700
Message-Id: <20191009112754.36805-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The logic of figuring out whether CMCI is supported is broken, causing
the CMCI accessing tests to fail on Skylake bare-metal.

Determine whether CMCI is supported according to the maximum entries in
the LVT as encoded in the APIC version register.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/x86/apic.h  |  7 +++++++
 x86/vmx_tests.c | 10 +---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index b5bf208..a7eff63 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -70,6 +70,11 @@ static inline u32 x2apic_msr(u32 reg)
 	return APIC_BASE_MSR + (reg >> 4);
 }
 
+static inline bool apic_lvt_entry_supported(int idx)
+{
+	return GET_APIC_MAXLVT(apic_read(APIC_LVR)) >= idx;
+}
+
 static inline bool x2apic_reg_reserved(u32 reg)
 {
 	switch (reg) {
@@ -83,6 +88,8 @@ static inline bool x2apic_reg_reserved(u32 reg)
 	case 0x3a0 ... 0x3d0:
 	case 0x3f0:
 		return true;
+	case APIC_CMCI:
+		return !apic_lvt_entry_supported(6);
 	default:
 		return false;
 	}
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f4b348b..0c710cd 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5863,11 +5863,6 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
 	return val & 0xf0;
 }
 
-static bool is_cmci_enabled(void)
-{
-	return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
-}
-
 static void virt_x2apic_mode_rd_expectation(
 	u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
 	bool apic_register_virtualization, bool virtual_interrupt_delivery,
@@ -5877,9 +5872,6 @@ static void virt_x2apic_mode_rd_expectation(
 		!x2apic_reg_reserved(reg) &&
 		reg != APIC_EOI;
 
-	if (reg == APIC_CMCI && !is_cmci_enabled())
-		readable = false;
-
 	expectation->rd_exit_reason = VMX_VMCALL;
 	expectation->virt_fn = virt_x2apic_mode_identity;
 	if (virt_x2apic_mode_on && apic_register_virtualization) {
@@ -5943,7 +5935,7 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
 		*val = apic_read(reg);
 		break;
 	case APIC_CMCI:
-		if (!is_cmci_enabled())
+		if (!apic_lvt_entry_supported(6))
 			return false;
 		*val = apic_read(reg);
 		break;
-- 
2.17.1

