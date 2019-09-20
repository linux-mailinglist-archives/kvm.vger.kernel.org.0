Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B914FB8E43
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 12:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437967AbfITKHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 06:07:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44437 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390997AbfITKHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 06:07:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so4157352pfn.11;
        Fri, 20 Sep 2019 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jJNUGZzD6WYdW7WfV7c4VlXWYypeskgZBi3y5u2An+c=;
        b=vcxVVEjhhAnlFY+dIZQ4WK+YE01JpIpPV6Qi2Y2N4tPD7KDM5GlHoytVeiB6OJpXTo
         IACh3vdiysSwPoF+NDiBBb8Lumc0vP5opKJRRienBLlmZ98W9iCExr42WCivypqQQOXC
         S0XpLooJJqwzUKmM508Gr6pl7EI0tArdKNXqlRkUEbjVJ3FnpoTFb/ttp9VXv4bmemTc
         /3ZkTDN3Yc+xor35jyPzN4lsu1y+xDAuf3opERIsaZ+/7L1Vg/mVghPEuO+0IRkTN2jm
         HzP1ExW4J3HsrYrKtcyVSpFhM/OSoFcVlywf7iV3DZs82k59dV3kDLd4WuIxkgTrqqfx
         uOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jJNUGZzD6WYdW7WfV7c4VlXWYypeskgZBi3y5u2An+c=;
        b=hZ5LMMAsuxUAlKv6YM53dkh+ZIpf9lP1LViS8PUQma/V6xGMj6NgcIA/JAbPHPr2Dj
         UnxnZCJ26l80lVm0Qf5vBe/p1RjFKXqob4ViDFnuHXIGX14U3mqSEFw8+wiNvHUv0A1G
         zEvtOBVHS16Px+ef4tuRaR/hewEM0sPRaCHnOefAyNkWlsxOxfCIzeOrgRBvqUG10AGh
         VLFZU8SfCTu/ZSzKQJwNv6N+8kJizXYX3mMHZpCTTUnp8rE592x/kmxdWNWWfxTrGM4m
         ms6pTw+OxTFUnF7e+G/L7cEwXqjQxsTRlF3xS0hJ2Ba4gt2bVUF8g6+hZ0qAGuggusoU
         MRpw==
X-Gm-Message-State: APjAAAW8gWqNQVqORp4uq59+aGDiDWZKZU4IfNJTpQgTVWbMPsVZPZaV
        k0WYaPVzWIETqI9kZHD68Jd1ve6w
X-Google-Smtp-Source: APXvYqx79uB+/pgIn5cFXBKIG+GHsHPmX87BRc+n28KQzU+g+ywrrhcAzHmZ2s2ssPMeUS3D/TPidQ==
X-Received: by 2002:a63:2a87:: with SMTP id q129mr14807014pgq.101.1568974050770;
        Fri, 20 Sep 2019 03:07:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i10sm1417345pfa.70.2019.09.20.03.07.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Sep 2019 03:07:29 -0700 (PDT)
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
Subject: [PATCH] KVM: LAPIC: micro-optimize fixed mode ipi delivery
Date:   Fri, 20 Sep 2019 18:07:18 +0800
Message-Id: <1568974038-13750-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After disabling mwait/halt/pause vmexits, RESCHEDULE_VECTOR and 
CALL_FUNCTION_SINGLE_VECTOR etc IPI is one of the main remaining
cause of vmexits observed in product environment which can't be 
optimized by PV IPIs. This patch is the follow-up on commit 
0e6d242eccdb (KVM: LAPIC: Micro optimize IPI latency), to optimize 
redundancy logic before fixed mode ipi is delivered in the fast 
path.

- broadcast handling needs to go slow path, so the delivery mode repair 
  can be delayed to before slow path.
- self-IPI will not be intervened by hypervisor any more after APICv is 
  introduced and the boxes support APICv are popular now. In addition, 
  kvm_apic_map_get_dest_lapic() can handle the self-IPI, so there is no 
  need a shortcut for the non-APICv case.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/irq_comm.c | 6 +++---
 arch/x86/kvm/lapic.c    | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d..aa88156 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
+	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+		return r;
+
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_lowest_prio_delivery(irq)) {
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 		irq->delivery_mode = APIC_DM_FIXED;
 	}
 
-	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
-		return r;
-
 	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 323bdca..d77fe29 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -955,11 +955,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 
 	*r = -1;
 
-	if (irq->shorthand == APIC_DEST_SELF) {
-		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
-		return true;
-	}
-
 	rcu_read_lock();
 	map = rcu_dereference(kvm->arch.apic_map);
 
-- 
2.7.4

