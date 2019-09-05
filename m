Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33202A9AA8
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 08:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbfIEG0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 02:26:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38958 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731359AbfIEG0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 02:26:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id bd8so779437plb.6;
        Wed, 04 Sep 2019 23:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PasM8GCX7mEGAVRsf1zB0IrqtOMIBNlDj4wL+XfNBQQ=;
        b=kRp8zzhOm5SwgB5xlXbVKho0JVc6ZWWmJPaXU3biT8N/Z1tGE/7OpGVVuQ2bNJoZYU
         tx0B6NC7jaChCi/dEexhFFmcodCd/ZbF52yx+bmH8oUkuLE/IasxU2DjjMLI4XmluW9Y
         834BzA1UwGTqG/YmBHYjZJ0XtRv9rI5yshrUIdfxMgBNYu43lU84IR+3F+5AzzrZmJvH
         /RXzxHdyF9zzvPmPWFyjIqR7YbmFRhHNE32i6jqzZTCpw0CL1VyffHLBJjO6Y/hllGzn
         1ZBrJepkYMUmS7HaN6/oT/ywknBpthdrSskr7gW9zA6DVgX5WRtT90Xe4H7sgY48V8io
         Dqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PasM8GCX7mEGAVRsf1zB0IrqtOMIBNlDj4wL+XfNBQQ=;
        b=Fiq/jkFkycJBAP7bzksAq1r7uxE5gPimD/DesiI+ngLMzV+9s/koeWkcBQvgJeHB3G
         3nNrj5vsFqpJPBs1LVtbm4PccfozQ/Lcs5X3lgYd0PFZGLe2MUCAc85PgqZ17oYQ24yv
         SnuMzny30XhGesi+8Nrs8u1G23qb5lTysykposJQjahBurcbI+Xpa9nI4jv4BTrxBwI5
         k1JfrWd97lsG2GnJUmd32Mlp9iHaMWXVJkTMgykNLqbmXECwo4hDjQ9YDzhm3OKQJf0d
         S9QM2ky4/tlfIkYMM+OYRmma9a9SJG8ToJTEZU8lpCujMD0PV3A8c4hq1rwhshriN5F0
         wuuQ==
X-Gm-Message-State: APjAAAVfOQyHSqJZSMGOv6ljaJL4v+DckudvR9APJefEMAJtXQiBrwsO
        LkiQQ4ChjAwSO2oDsiN3FBtd1MtO
X-Google-Smtp-Source: APXvYqz4fC9DNjfuhuH7Hjj+nAevfg1kox4DNRRwCcn4H7thFDoDqy4ad16301wTifH750eAd6bD5g==
X-Received: by 2002:a17:902:a983:: with SMTP id bh3mr1616757plb.311.1567664793115;
        Wed, 04 Sep 2019 23:26:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d69sm1102941pfd.175.2019.09.04.23.26.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 23:26:32 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 1/2] KVM: LAPIC: Micro optimize IPI latency
Date:   Thu,  5 Sep 2019 14:26:27 +0800
Message-Id: <1567664788-10249-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch optimizes the virtual IPI emulation sequence:

write ICR2                     write ICR2
write ICR                      read ICR2
read ICR            ==>        send virtual IPI
read ICR2                      write ICR
send virtual IPI

It can reduce kvm-unit-tests/vmexit.flat IPI testing latency(from sender
send IPI to sender receive the ACK) from 3319 cycles to 3203 cycles on
SKylake server.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 12ade70..34fd299 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1200,10 +1200,8 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-static void apic_send_ipi(struct kvm_lapic *apic)
+static void apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
-	u32 icr_low = kvm_lapic_get_reg(apic, APIC_ICR);
-	u32 icr_high = kvm_lapic_get_reg(apic, APIC_ICR2);
 	struct kvm_lapic_irq irq;
 
 	irq.vector = icr_low & APIC_VECTOR_MASK;
@@ -1940,8 +1938,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	}
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
-		kvm_lapic_set_reg(apic, APIC_ICR, val & ~(1 << 12));
-		apic_send_ipi(apic);
+		val &= ~(1 << 12);
+		apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
+		kvm_lapic_set_reg(apic, APIC_ICR, val);
 		break;
 
 	case APIC_ICR2:
-- 
2.7.4

