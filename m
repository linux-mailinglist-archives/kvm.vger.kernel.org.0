Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101F519BD87
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbgDBIUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:20:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36086 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbgDBIUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 04:20:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id c23so1519428pgj.3;
        Thu, 02 Apr 2020 01:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Z8cYPNA1Nnx+ynlfYUK6Uh1qA4I2RWYXKrKRt2N0YE=;
        b=TaE3ZUOzA30XMRfT+yR0W+Dehn3OsZr2WVfVPdfJCTu+8KszJMoFO0HLFdE8Kh/inK
         MN8BLu1H0/Fu6PEudaPiSJ0m67syIyZ/1b11Nixu+Yw38bnTBJyjNFZxAe7wImsN8AP2
         JHMwMO8o68fB+5h/GxhIlpj6jfQ35JfsCI5fkOI91BC0tW9zw6FIoJI6yFZHQpp6mkJ0
         0kQUAs5UxfJ+v0aNV0oXy609R4gXnH4QYb8kNze+Uy7Re6yewZaI8RyRQNq1vXIgJHOV
         nk0jRIY3moCDne1/4HRdSGSmMr3DUb98d3voJ4pTzKG+WZ5GD0P+BKi1rkcDZGN+HRBB
         GIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Z8cYPNA1Nnx+ynlfYUK6Uh1qA4I2RWYXKrKRt2N0YE=;
        b=JerOUt5wSzhL0HinTK18R44HTwINYUhuZfrhKaPdCAdFbtCppEZ8RVV2TzYKxYF/2v
         FHdkVThlf/zeCKjqYYcpfYAx9eAiAMht1j/N4JB6bszG8uSthvV5w5NZSPinifRXs1AJ
         wcrYrFFc6HrgEizrk8KptiW9on4nObMxc/Z4QndTuU9A9bT6BxpDCi1aTfDy9uSKD2Kk
         0CbVTdMfLA2p7mBGebMPAkeBnsmZTgegqBdkOOenmJlRkO9pQQc5MZ61DAJQvzqJAGVv
         Hhi6+/zbRSPQgch0f6AKSOsUiFC3IR1xac8C3vt5DGujMTmuzOQnN/n58md4jRgAXy8t
         TDqQ==
X-Gm-Message-State: AGi0Pub3FHKEoTljxOxA8kvT5qVEeEdTJPQXiEaZQhUowio+bMNHuCi5
        dHSO1Qbp4OfctWxmPlU14dXSTAx4
X-Google-Smtp-Source: APiQypIIAufGAqI+ZirSMDqJch/Bi85bNdgeXU+O3Y0/LbEsbZ9NGBOW+SxQ8K8SjgseJLB1kGLgPw==
X-Received: by 2002:aa7:8439:: with SMTP id q25mr905932pfn.172.1585815637154;
        Thu, 02 Apr 2020 01:20:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id ci18sm3226454pjb.23.2020.04.02.01.20.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 Apr 2020 01:20:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3] KVM: X86: Filter out the broadcast dest for IPI fastpath
Date:   Thu,  2 Apr 2020 16:20:26 +0800
Message-Id: <1585815626-28370-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Except destination shorthand, a destination value 0xffffffff is used to
broadcast interrupts, let's also filter out this for single target IPI 
fastpath.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update subject and patch description

 arch/x86/kvm/lapic.c | 3 ---
 arch/x86/kvm/lapic.h | 3 +++
 arch/x86/kvm/x86.c   | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e24d405..d528bed 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -59,9 +59,6 @@
 #define MAX_APIC_VECTOR			256
 #define APIC_VECTORS_PER_REG		32
 
-#define APIC_BROADCAST			0xFF
-#define X2APIC_BROADCAST		0xFFFFFFFFul
-
 static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
 #define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index bc76860..25b77a6 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -17,6 +17,9 @@
 #define APIC_BUS_CYCLE_NS       1
 #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
 
+#define APIC_BROADCAST			0xFF
+#define X2APIC_BROADCAST		0xFFFFFFFFul
+
 enum lapic_mode {
 	LAPIC_MODE_DISABLED = 0,
 	LAPIC_MODE_INVALID = X2APIC_ENABLE,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e95950..5a645df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1559,7 +1559,8 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 
 	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
 		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
-		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
+		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
+		((u32)(data >> 32) != X2APIC_BROADCAST)) {
 
 		data &= ~(1 << 12);
 		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
-- 
2.7.4

