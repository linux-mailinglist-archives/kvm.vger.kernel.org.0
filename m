Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514E7195102
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 07:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgC0GYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 02:24:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41175 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgC0GYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 02:24:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so3078011plr.8;
        Thu, 26 Mar 2020 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cRB5KVU8flbbfiX95l71SFIi4ntzX1dMuUx4bGKIqDM=;
        b=cVo+9E2hHHRzQHJTWVEneSorc4gh9x0wMNISSKyll0TgdUKFvleZWSCIJNhP9KwSY6
         pD6NKX/jpUy7sC2+4sLF/8DGSlzbTD+vjcXpAjR1Br1DzizBmxRKXUl9Qqf9B9WYyOat
         slO66rM94qBoF7sFEhJTg+DdZAYZnaRXEkEW127twNx9xaaAiSnYjvm1e1urhxN1xqoe
         1zi2u8RQaru0JXV1/avx70S3OrKfH6yoF8ctyh4dMkckkXuba9yK/rRXHcUTjgOqCT/N
         CBQWAwVv8Fy5m5fC7/M8Yi+tVXC/gWavMsQAYQnlVG3fKaX2mfQ3ctcILa/8bjkGnHpI
         y8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cRB5KVU8flbbfiX95l71SFIi4ntzX1dMuUx4bGKIqDM=;
        b=MUAAwku6ho2uxrxQUA5oNoqSMWBZxgEIt4+U53SoAcl2n41vYEsoMF3tlvIFS7+tsc
         ZL2D7lRtiaygHlviTW5PmUNF8jIpReSzGENBLUP9hnrzsQ9LR7DtbRIrc15kwJC2k7bI
         9IFtTTZuRvc0gFkcmWMAh85qjYFX5s4lhSJXR0PjLH2ySf1HrVJnXtx7gBgLiKFy1/9T
         2bePy6qsUBekcydlZFgg+a37qWxzCiV3umJsMc9mTEBFKOyPksyaZNIfTVI6aeofzopv
         fudri/zPRTjI+X1Jw+w1PcVO4Ud62JGKWbBT8VtIaLLl+w5RwKoLLK03CL9YZk2mbWlF
         vkyw==
X-Gm-Message-State: ANhLgQ3Ar1QteT8+9SmMhywyp7gWfdSXcU9mRKcgZIpHByCv0E1UXQee
        a5mAb7NoqqC1AbhsiGt43meCRyjz
X-Google-Smtp-Source: ADFU+vvXH26lmdQRHFtBd+cuhZLOY5ZhXl22R1Eq+0NX6XXjJAaO7iMU8+CBm698yNjV7POVcp3pjw==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr4195876pjj.25.1585290261458;
        Thu, 26 Mar 2020 23:24:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id s4sm3262078pgm.18.2020.03.26.23.24.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Mar 2020 23:24:21 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/2] KVM: LAPIC: Don't need to clear IPI delivery status for x2apic
Date:   Fri, 27 Mar 2020 14:24:00 +0800
Message-Id: <1585290240-18643-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
References: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI delivery status field is not present for x2apic, don't need 
to clear IPI delivery status for x2apic.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 arch/x86/kvm/x86.c   | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 88929b1..f6d69e2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1942,7 +1942,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	}
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
-		val &= ~(1 << 12);
+		if (!apic_x2apic_mode(apic))
+			val &= ~(1 << 12);
 		kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
 		kvm_lapic_set_reg(apic, APIC_ICR, val);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 495709f..6ced0e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1562,7 +1562,6 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
 		((u32)(data >> 32) != X2APIC_BROADCAST)) {
 
-		data &= ~(1 << 12);
 		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
 		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
 		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR, (u32)data);
-- 
2.7.4

