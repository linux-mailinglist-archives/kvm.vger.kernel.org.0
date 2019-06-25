Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF9D557C5
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfFYTaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 15:30:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41330 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYTaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 15:30:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id y72so9438914pgd.8
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 12:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=859qBAVelJXV2Is7tzaJNVn6oUduWBnfv/9UY7B8H+A=;
        b=aD/AAQj8UbA5/J6e8FBsrWqnoki8klfF+qYumaHHMhVedKr4OcfNHBK64/Pr50/TYP
         R+wgczPWIlMWGcLBlyLOu4Atn0eHdoNRuHgrxAjpkb0oXgXGOiL8LVCo3bRn0kiyCGIC
         60lpsKxf5rjsqaKaZuhri5gB2fO1AUQy5CwkbZWxJVeJb/VnN401ErjFAzKMwnHPj5cc
         tW0cx7HD1d9M6dw3Ya7cng9WuAnwX5uVUZKU7HhCnPhT5UtDZjpn3JKDDugSR9CyLecZ
         u3mrwDRicduBktPnqkKHIvGYRmELVLCOYQPyrzQaqlsgwWQb81hf/Y+LnKlZEe9dmG80
         JXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=859qBAVelJXV2Is7tzaJNVn6oUduWBnfv/9UY7B8H+A=;
        b=gNx3r6OclWYkBPYljKIImXsjwnxuuBdB/uF9rjLNsFTmSNly37z5TdTxVW0i9Z0evy
         YqkZnox1BX6od7HvfeowUlS3jPvxQ+vECJfMERMEv2S1hSzN+h16kpb1GHJURt0xH8Ib
         4haZoYeVfVqj47qz/Szv3XhhrH4NKIYnTbR61RcVoMC34PiyRN+PJAaAxxwHDzCijyx9
         jQqfVJQoCv5FYmgN3s605gdfVYq9YiQjvO/yCV9YjUtmix4cCYFQT1r5u/orZoEctXZv
         fYBHud6tacrAgXoJb/OgXkxtFLSth2FebYG3j+4vbzD0qkaqN7BAsaoA4U3fhzokn41F
         fPjg==
X-Gm-Message-State: APjAAAVKmVTeUecWfWORDzzSt+IDvZ2u3fKCnrj/3UONsylrZEULudey
        0KZSDJ9Z6slrpvqoaUiIeWA=
X-Google-Smtp-Source: APXvYqxQp89Sl1+0iekIVpdq5iNl/31+6faR0grV9iKaB0+sBXrtylrvAwzUMo+VDNmUAnTS1v7Msw==
X-Received: by 2002:a65:6102:: with SMTP id z2mr39235252pgu.194.1561491004723;
        Tue, 25 Jun 2019 12:30:04 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id n184sm14916333pfn.21.2019.06.25.12.30.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:30:04 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH] x86: vmx: Consider CMCI enabled based on IA32_MCG_CAP[10]
Date:   Tue, 25 Jun 2019 05:07:56 -0700
Message-Id: <20190625120756.8781-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CMCI is enabled if IA32_MCG_CAP[10] is set. VMX tests do not respect
this condition. Fix it.

Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3731757..1776e46 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5855,6 +5855,11 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
 	return val & 0xf0;
 }
 
+static bool is_cmci_enabled(void)
+{
+	return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
+}
+
 static void virt_x2apic_mode_rd_expectation(
 	u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
 	bool apic_register_virtualization, bool virtual_interrupt_delivery,
@@ -5862,8 +5867,10 @@ static void virt_x2apic_mode_rd_expectation(
 {
 	bool readable =
 		!x2apic_reg_reserved(reg) &&
-		reg != APIC_EOI &&
-		reg != APIC_CMCI;
+		reg != APIC_EOI;
+
+	if (reg == APIC_CMCI && !is_cmci_enabled())
+		readable = false;
 
 	expectation->rd_exit_reason = VMX_VMCALL;
 	expectation->virt_fn = virt_x2apic_mode_identity;
@@ -5893,9 +5900,6 @@ static void virt_x2apic_mode_rd_expectation(
  * For writable registers, get_x2apic_wr_val() deposits the write value into the
  * val pointer arg and returns true. For non-writable registers, val is not
  * modified and get_x2apic_wr_val() returns false.
- *
- * CMCI, including the LVT CMCI register, is disabled by default. Thus,
- * get_x2apic_wr_val() treats this register as non-writable.
  */
 static bool get_x2apic_wr_val(u32 reg, u64 *val)
 {
@@ -5930,6 +5934,11 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
 		 */
 		*val = apic_read(reg);
 		break;
+	case APIC_CMCI:
+		if (!is_cmci_enabled())
+			return false;
+		*val = apic_read(reg);
+		break;
 	case APIC_ICR:
 		*val = 0x40000 | 0xf1;
 		break;
-- 
2.17.1

