Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C81950FF
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 07:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgC0GYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 02:24:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36075 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgC0GYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 02:24:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id g2so3090296plo.3;
        Thu, 26 Mar 2020 23:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KxvtWHMTpXNJcpAcSzyia90JODer9a/KosglAsSw/h4=;
        b=IQ2KiKpu4ddLFmRTmWjfg249VH+ZFwyu58/9gHxJ/emZHzab338EyOXqRlgwoZmCve
         Fum5ZBGL7XnZiVeX076I66cpXM5trxBxFs4vRhRj6Mox4dqFrSe+7cpMKo5HIv4eT136
         jeTZuuJup7J9WQHAiI55O/RrY891voTXSr/u6YBxwetmd84fTEKWEPF008/aqFZUk51q
         XitBO64fN0M+X3F1P4uaPmnjDubfhKLIXZTDTGoP1vVTz6uyxCR6366oZOXFpdSrtm3o
         PGBEfqAVrKzJkPHYg81nfyMQh4xuixVMhmfRLx70zXns78Xl1TZ/kPeK1wuBoJgBjS6v
         WLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KxvtWHMTpXNJcpAcSzyia90JODer9a/KosglAsSw/h4=;
        b=Y7QZX6xDA7Z/eNg/yVFTvRrhH9tBnKWBF0YLCQGsKo0sPISgYAFmR+jdEsHl6EeqSN
         nasEUyG71mceXLKOpyvZRpubP3qb36ebNk9mNWUUJc6z6YIeiJQiXBj/OjJFoE24ErHl
         o8JbOAsR2JV1IFISQp1ZpnTBbfAe3nVBqIrkzxoYGcO1jLkTKE+HemN3meuLzdhaif2D
         IJ2lBvriw1TZJiPLLNHvqzqkX7HKGcUhWaCp31UcrBJocyEN3VM5yiRYcwju+f3PlSFX
         utlMcOOMF/KObDUnrpGzzKU+GjYFd5gR8pyqyZ6iwZUmDG+KXyqA2Z1NOf0kFwmVDJ41
         BlZQ==
X-Gm-Message-State: ANhLgQ35Bb429OdzFXYBuwGxlsnopucCRE4R4c7zGvewDK7qYqwDWgCv
        bNXY58N6gyoVSuYaNO2JcZ2+Usom
X-Google-Smtp-Source: ADFU+vvjua2b0xRBETCx8MIDDcQaAl6IilmVfMS0FYJKgP6FqbfNmkEsgcH3PEbAVcNL35CZ0lmf9A==
X-Received: by 2002:a17:90a:e289:: with SMTP id d9mr4027778pjz.172.1585290258735;
        Thu, 26 Mar 2020 23:24:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id s4sm3262078pgm.18.2020.03.26.23.24.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Mar 2020 23:24:17 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: X86: Filter the broadcast dest for IPI fastpath
Date:   Fri, 27 Mar 2020 14:23:59 +0800
Message-Id: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Except destination shorthand, a destination value 0xffffffff is used to 
broadcast interrupts, let's also filter this for single target IPI fastpath.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ---
 arch/x86/kvm/lapic.h | 3 +++
 arch/x86/kvm/x86.c   | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a38f1a8..88929b1 100644
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
index c4bb7d8..495709f 100644
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

