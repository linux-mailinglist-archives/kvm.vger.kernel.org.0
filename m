Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC711935D2
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 03:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCZCUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 22:20:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39337 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbgCZCUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 22:20:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id b22so2110596pgb.6;
        Wed, 25 Mar 2020 19:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1a2sJiVllrGzVZRtd1vAiDbOX8dRnMrn6vYAwgDTFoY=;
        b=DbRgiRuqIuLcXZ8fLdfUERBz0+EHvUPuP4eUGh98zRY+s74lzBxZl+wjTDeR6/qvi9
         cJxZlW+ohAFZAtucAlEAZO/ih6g1/g562R8SwjbeOqI3y/eTODABR3II1Zrgq2awWUlR
         7k4TZ1pI9I2vAAvJ6gwsgMtCc2BF95I9oXpyikpwCHlLc/sCNkAb+/BaCw8jcbV4HUuS
         WfYmrFSpbhJF/Z94GUETmUym/N9h7NwxMkfOjwGO5CZWQrBZUILsd1EPy+cOG66pzGqW
         R0puReKv5IEi+S6zpWxIVMdVE3wV+jtWIyl8kD+E1oAoAHSXwxnItcPGjeSrOhZ1iv5Q
         WRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1a2sJiVllrGzVZRtd1vAiDbOX8dRnMrn6vYAwgDTFoY=;
        b=Oo1hv6mVEQIo7ADc4VsxQXsxDahlf24YY+1l38yKNdBL8eA1PTlPYTHa8mOXqGCjRd
         FMsnr3/8uPfFy0wzIvDKMTOrltPLmvr9nvd95v+2vJ1GCcf8MbnOLOzX7mEF3kjdrFuq
         kfHJ2ZByinSzGiHYyOg5VC6WeIDBp+ILQ6NmUbrj9CSHSfszmhgKXhyWBIV8pOCNSLcN
         91HbGrkoHuNK/X10oMBhrRV/KeGLoAeTkV9SWx3vHUGwhw6fV5+qCZFCj2Px1fEVpPxZ
         LGvWHu4WAu91INAKO4XbT0ZCCXtIZYqJrrtJZYxBwEBF4UQ50SvOUpbGLUaAU3roQibr
         MfXg==
X-Gm-Message-State: ANhLgQ11SewBoDCOeAivucupq0+lPVDUnU03sB6TmsS2PrZoJiFWiCup
        lahrniFSUdeQGMRJRrboxMY/EfR5
X-Google-Smtp-Source: ADFU+vvtRvfPGB6WA9/O2Bc4p+PxKAwq0jLOJDYzp/+tZCYHNS1wG2xmFSno1MPvgsR38xBzUtdXcw==
X-Received: by 2002:a63:8c56:: with SMTP id q22mr6179580pgn.154.1585189221433;
        Wed, 25 Mar 2020 19:20:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mq18sm452975pjb.6.2020.03.25.19.20.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 19:20:21 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/3] KVM: X86: Micro-optimize IPI fastpath delay
Date:   Thu, 26 Mar 2020 10:20:02 +0800
Message-Id: <1585189202-1708-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
References: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch optimizes the virtual IPI fastpath emulation sequence:

write ICR2                          send virtual IPI
read ICR2                           write ICR2
send virtual IPI         ==>        write ICR
write ICR

We can observe ~0.67% performance improvement for IPI microbenchmark
(https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/) 
on Skylake server.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 arch/x86/kvm/lapic.h | 1 +
 arch/x86/kvm/x86.c   | 6 +++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e3099c6..338de38 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1226,7 +1226,7 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-static void apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
+void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
 	struct kvm_lapic_irq irq;
 
@@ -1940,7 +1940,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
 		val &= ~(1 << 12);
-		apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
+		kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
 		kvm_lapic_set_reg(apic, APIC_ICR, val);
 		break;
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ec6fbfe..bc76860 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -95,6 +95,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
+void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50ef1c5..c4bb7d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1561,8 +1561,12 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
 		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
 
+		data &= ~(1 << 12);
+		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
 		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
-		return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
+		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR, (u32)data);
+		trace_kvm_apic_write(APIC_ICR, (u32)data);
+		return 0;
 	}
 
 	return 1;
-- 
2.7.4

