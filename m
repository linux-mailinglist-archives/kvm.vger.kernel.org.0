Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31819A2C8
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 02:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgDAATd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 20:19:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34194 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbgDAATd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 20:19:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id l14so4060986pgb.1;
        Tue, 31 Mar 2020 17:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Z8cYPNA1Nnx+ynlfYUK6Uh1qA4I2RWYXKrKRt2N0YE=;
        b=qV7Egt69AFSYm63oan9OEeaDZCWNVhxRplH9ijcJinhqTPrM/ZGkiqPbKmU8fTx2Yn
         sdAno83KlgvyAT7AxdzAGOzk1JBDZFky9/yTNV6jYBfe2iUy+eODWvlMPOVSNnjBr8PC
         LMsn5q0GBsIUWIEM3ZiQxfcS0Jy/9SNx2hizD27ai+aVMAX4HjQ2NEm7GFMmcoP39JC1
         Wz8pU4/8gRyBREb7ZdQolpMu9mNcr5xZBu1Qq7S5FNNRnops2NqT5ZPGwJFqNDUq7At+
         AbXqAqsdSyfWZmRrzP7bpo/12+Kw7jw+BHEhPeqQBFUeZqzqQiTYh7Eg4z4O06E92eZ5
         xEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Z8cYPNA1Nnx+ynlfYUK6Uh1qA4I2RWYXKrKRt2N0YE=;
        b=iJ6eHLI3V7OEzQZFNvPelCJ41HLIKaSlP0BWjRgikvVEQ9GyiSRlcb1JFsAwGzMCHW
         GBS5DLpJzRw3P3HpiTm/IhXqR/ffdtx7ahkressPzUsTTCr2+ZC/xHa7oTlcTXJVyDVS
         52+QKJCBK9CLj0yD2xF1w82UguvoOgSbIptm3taQLM2Y76Hnxb8UXb2FIKyv+yNzjbO/
         wMQRkTWMK40klL42k0oy0TK/vdpJ06+cg7+TWz7DaX9cpwmlECEJyy8FzZtp1K/IZ93N
         vvuk5483GiA8dxEq2sh4lfANPnCCvIMWi1MwWLlKbsMQDif3MjrSoaQ9ekKIOljRvjSz
         xbxg==
X-Gm-Message-State: ANhLgQ3wXLmIEVVv+Z1aONHd3WtjRn0ZNbgoD2mmS+RrM0cH+o6/U1Yt
        6MVnP62AgQcuvuNkhmnXW+b/zX/r
X-Google-Smtp-Source: ADFU+vuyLauhhsGiDnxRt45W7U5JB4YVBUGUkpBSElEOAwA/hE43H+Hki5xQrb+Z9SntSrnZUNFKRA==
X-Received: by 2002:aa7:9844:: with SMTP id n4mr19644750pfq.98.1585700371738;
        Tue, 31 Mar 2020 17:19:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id ci18sm206978pjb.23.2020.03.31.17.19.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 31 Mar 2020 17:19:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/2] KVM: X86: Filter out the broadcast dest for IPI fastpath
Date:   Wed,  1 Apr 2020 08:19:21 +0800
Message-Id: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
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

