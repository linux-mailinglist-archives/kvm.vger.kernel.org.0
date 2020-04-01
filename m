Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E02E19A2CA
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 02:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgDAATg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 20:19:36 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54991 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbgDAATg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 20:19:36 -0400
Received: by mail-pj1-f68.google.com with SMTP id np9so1849979pjb.4;
        Tue, 31 Mar 2020 17:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eoc4WcS+IpjrNztXfxLlfAJ87gSgdKjixSKutVJJ1CE=;
        b=lQ27s71BVXH2TyOl0LMvsm2rIgRan8KHkwCGQNNBZtfR1LsaCe59INT0mUuhs9OWSI
         PBVylMM+8z0psmpclM9UVnxX+Jwz7lOxis+GuF4U+6/WTl0W1UE6Emhd4YgOYWxGt+xB
         XKuWPEUGiN6miTIQQV93x+fangjGyVGr93RNiO6Z4y7HKEymHMfvWyHYkuy76gW+Ympz
         XgFsmtyMWMWgNEOFXr7H1G0YS0TsvFdPmX9known1Cg7z7UIAGxBUF3ZvDfVNoNPgVq5
         VioXGco9zfLcnY0cZQGbzDanOUaoRpFSn0Io9VZVfNRXZy54vKBjucAIjsRhq9JFCsps
         NQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eoc4WcS+IpjrNztXfxLlfAJ87gSgdKjixSKutVJJ1CE=;
        b=P76JkP3PXzHeOXZEhAAk2D5kyZTUBesin8djj9/Ex/1uqyCCk5hah8isqMQhGfbMMz
         5PUuLgv2HLl173Hw2SOeImT7OWYMj5cx00aUCUfdR9pMXlEdG7xJAGiKux78U8GICAg2
         i2TFYkEGDIEr6gKMpe9GASSxIc0sAZyDc5A/ODazAX1UkL5JD6YLMN5qM8gp5z19hwsk
         71O05rWJDvaxqr2Gz8GUUYarVym8nXPQC/Q83xY09Jzj/zMtofQ6kcLu7h5TY+APTklQ
         YoTRf4+Y0EAjEdczegQSfVIchp1eoVYvScqWXy3qqjwQb7TOAF9tJtPpSP9fiFqs6zRd
         mSSA==
X-Gm-Message-State: AGi0PuZCNiP6Qf8XE8Yk5EVN+ARxrYhajr/HDOLGIF9zLTQHnR/MDhtA
        XmDFMIYPkQkt4kdZpKXkusD3uneX
X-Google-Smtp-Source: APiQypIClxoZOUUOKzzeaZHB+fxWtTwD06ya6pluh9+gP06Sgnivhgve6qRVZJRwNwaXfn5kct5O4Q==
X-Received: by 2002:a17:902:b187:: with SMTP id s7mr6822588plr.84.1585700374464;
        Tue, 31 Mar 2020 17:19:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id ci18sm206978pjb.23.2020.03.31.17.19.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 31 Mar 2020 17:19:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery status in x2apic mode
Date:   Wed,  1 Apr 2020 08:19:22 +0800
Message-Id: <1585700362-11892-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI delivery status field is not present in x2apic mode, don't need 
to clear IPI delivery status in x2apic mode.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update code comments
 * update subject and patch description

 arch/x86/kvm/lapic.c | 5 +++--
 arch/x86/kvm/x86.c   | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d528bed..5efca58 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1941,8 +1941,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 	}
 	case APIC_ICR:
-		/* No delay here, so we always clear the pending bit */
-		val &= ~(1 << 12);
+		/* Immediately clear Delivery Status in xAPIC mode */
+		if (!apic_x2apic_mode(apic))
+			val &= ~(1 << 12);
 		kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
 		kvm_lapic_set_reg(apic, APIC_ICR, val);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a645df..ececc09 100644
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

