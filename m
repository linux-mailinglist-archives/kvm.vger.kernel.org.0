Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3422BAB026
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbfIFBaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:30:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39308 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732899AbfIFBaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:30:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id s12so3170929pfe.6;
        Thu, 05 Sep 2019 18:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PasM8GCX7mEGAVRsf1zB0IrqtOMIBNlDj4wL+XfNBQQ=;
        b=Zs5mXO3t1tXqEJq3xTtO8EL2rTiUMUX4xV/WUnYDObiV+cMcP+jE5nDcCcB3EWyXed
         Tn+EwRV8aavfIHIqTUTrfG7D8cD4UU10FUoUfZ5dY5Nx9syOyQOgLzZaaM5zAZ98YoEB
         3gdboRk0UeB6FHt/y6CVBt+cdLF/8JyJVgrP8DOH6cfSdEIYUnhfmDJttCqGrIZvOC80
         L8bbrsvs2JB/ULTgiHwTRcf3vDrVTlmjpvRLl+55ft45V000O5tZvk4UlEgWB08zEwlW
         3RqJy7Tl4THVmszYLc7hDEYZuZI5PgFDxc2XQ/Hv5mfCzYA6CgvYUhQz/s+rkjtAIRm/
         X1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PasM8GCX7mEGAVRsf1zB0IrqtOMIBNlDj4wL+XfNBQQ=;
        b=RGKJEMSTopNS7lVDgl3s9N/vURrdaw2rPXlIl30qDstIBFHZZY9eGPy+17n+QJDdy+
         S3xLwHjnIeehtBVvNRNx6PPzVFMj73DHV5qKcKYHCtzGEemRCgPwUTfVZTzE0fZfW1ev
         OBhTEfsF1bX66vm0RWzYLPAvQiyR6iF0bdDBba/Mo8eEShMgtFfk4jF8KOQImspqV6hx
         70CZgqzti3xAl1/6/SmsATbA7sPUi9uop4tHFlczESyfkm25LW/i9rqPNUnlOgexHjZs
         DsQ1vdA33nk+FGykKaxcFQtW/L2An7I+usHbiCTvzIAFolGhETjX58gNiSYeAPIjqR9Y
         ukfQ==
X-Gm-Message-State: APjAAAWhxi+zQDhFaU+DbuHfnzIGcKnORYvSqHhrKimpdpSz2hlEPsGB
        g7D6sfUmQLRRDc37S1SxYQPEVTeD
X-Google-Smtp-Source: APXvYqzzP253JQWcY/nY6IUQxjGomgk/V63k7jg1IqIl/TjGVPhFJPQAf+Ly7VYSe4JWYElKoJBMBA==
X-Received: by 2002:a17:90a:c38d:: with SMTP id h13mr7332714pjt.115.1567733420667;
        Thu, 05 Sep 2019 18:30:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g11sm3332294pgu.11.2019.09.05.18.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 18:30:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 3/5] KVM: LAPIC: Micro optimize IPI latency
Date:   Fri,  6 Sep 2019 09:30:02 +0800
Message-Id: <1567733404-7759-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
References: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
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

