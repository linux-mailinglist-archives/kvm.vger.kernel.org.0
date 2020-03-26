Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC271935CE
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 03:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgCZCUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 22:20:20 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39883 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbgCZCUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 22:20:20 -0400
Received: by mail-pj1-f68.google.com with SMTP id z3so1288198pjr.4;
        Wed, 25 Mar 2020 19:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=chlzOeSTKjpX1u/O2+BRSZO0t8ii9bW0UyyBajq5hnM=;
        b=m5twDoTV9KA/7pPKfQZO9JyQ1ZRYeD+yBTFfg5G2shlnHvj9NoFgm/QP+Bdq1gC59b
         ypj9t1t6FOTMhptJj+kju/leMjjOnNR3hvfKJMKXYRXJ7VsrVTFDWxkt+SQh/2+4gSOY
         MD6ZwBO9T3CJidsFAYLSnE9aa9rvG1vVrAhkHYkmLYHQGPbF/5G+eobWXAHfM9olMAXN
         iUqp7FiAYL5Rjn3Hlx97mT53n73zy8k7ut8hyq8l7E5KjOU6NwOwICP6MR/Bwx4CoDC2
         Ko0Pc75nknD0eV8Haz20LWhLVSQpf8jXjC+SpnumFXXOUAB3M2SdQ3qLgxf7OyrNcEQ4
         SM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=chlzOeSTKjpX1u/O2+BRSZO0t8ii9bW0UyyBajq5hnM=;
        b=I2Pf2BjwBB03rSQmbVGgC0Pu+q+6CmooTsf5v9D39Sq8x2ktEgG2bskU9MBgsqtdMI
         TR/vGmbnoaUbKt3sFknloYpfV9O8N8rSRinAku0QNNuu9T0t5TTMDdoAB6g6EYHqB8Kd
         vu3hfFW3WvaipRCpJBNZZXhIBMXHmHD2kBfKdBbEBTGWVrwqkl5FJQN/iWIMSUuajg5M
         J4flntxh8MPZaM1ffQ5yAqsn5yNkkv+MD7tnNUB15C/8zinUaOY4kB+GapVLH5Il1D6S
         ffsFSVLuiKrePUhpKbOdHKCbobKZEi3lfkOJTB4XvPovNuszKUG9PsGNCP1SmKpf21yp
         cC2w==
X-Gm-Message-State: ANhLgQ0aqWIkL9lOnbvUQonTfkkRqk0A41alvsjgydHSgtccz+LFGHyf
        5CaZVBWMH/OZs7UDO4kZjNV7wEQY
X-Google-Smtp-Source: ADFU+vvdhEnxm4pIe7I3EZfIRn2Gdn0pM0UX4PpkDM/D6S614eJNvjxPhju/qErO5pwntTiWgUvyJQ==
X-Received: by 2002:a17:902:d203:: with SMTP id t3mr5912082ply.291.1585189218704;
        Wed, 25 Mar 2020 19:20:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mq18sm452975pjb.6.2020.03.25.19.20.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 19:20:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/3] KVM: X86: Narrow down the IPI fastpath to single target IPI
Date:   Thu, 26 Mar 2020 10:20:01 +0800
Message-Id: <1585189202-1708-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
References: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The original single target IPI fastpath patch forgot to filter the 
ICR destination shorthand field. Multicast IPI is not suitable for 
this feature since wakeup the multiple sleeping vCPUs will extend 
the interrupt disabled time, it especially worse in the over-subscribe 
and VM has a little bit more vCPUs scenario. Let's narrow it down to 
single target IPI.

Two VMs, each is 76 vCPUs, one running 'ebizzy -M', the other 
running cyclictest on all vCPUs, w/ this patch, the avg score 
of cyclictest can improve more than 5%. (pv tlb, pv ipi, pv 
sched yield are disabled during testing to avoid the disturb).

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9232b15..50ef1c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1554,7 +1554,10 @@ EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
  */
 static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
 {
-	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) &&
+	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic))
+		return 1;
+
+	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
 		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
 		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
 
-- 
2.7.4

