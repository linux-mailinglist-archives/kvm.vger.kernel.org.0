Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E302640704
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiLBMmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiLBMmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:42:22 -0500
X-Greylist: delayed 364 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 04:42:21 PST
Received: from mx411.baidu.com (mx411.baidu.com [124.64.200.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A6ECD4AC0;
        Fri,  2 Dec 2022 04:42:20 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx411.baidu.com (Postfix) with ESMTP id 14D671948005B;
        Fri,  2 Dec 2022 20:36:14 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 0EBB4D9932;
        Fri,  2 Dec 2022 20:36:14 +0800 (CST)
From:   Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mlevitsk@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: fix APICv/x2AVIC disabled when vm reboot by itself
Date:   Fri,  2 Dec 2022 20:36:14 +0800
Message-Id: <1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch fixes that VM rebooting itself will cause APICv
disabled when VM is started with APICv/x2AVIC enabled.

When a VM reboot itself, The Qemu whill reset LAPIC by invoking
ioctl(KVM_SET_LAPIC, ...) to disable x2APIC mode and set APIC_ID
to its vcpuid in xAPIC mode.

That will be handled in KVM as follows:

     kvm_vcpu_ioctl_set_lapic
       kvm_apic_set_state
	  kvm_lapic_set_base  =>  disable X2APIC mode
	    kvm_apic_state_fixup
	      kvm_lapic_xapic_id_updated
	        kvm_xapic_id(apic) != apic->vcpu->vcpu_id
		kvm_set_apicv_inhibit(APICV_INHIBIT_REASON_APIC_ID_MODIFIED)
	   memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s))  => update APIC_ID

kvm_apic_set_state invokes kvm_lapic_set_base to disable x2APIC mode
firstly, but don't change APIC_ID, APIC_ID is 32 bits in x2APIC mode
and 8 bist(bit 24 ~ bit 31) in xAPIC mode. So kvm_lapic_xapic_id_updated
will set APICV_INHIBIT_REASON_APIC_ID_MODIFIED bit inhibit and disable
APICv/x2AVIC.

kvm_lapic_xapic_id_updated must be called after APIC_ID is changed.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")

Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
---
 arch/x86/kvm/lapic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d1..bf5ce86 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2722,8 +2722,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
-	} else {
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
@@ -2759,6 +2757,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	if (!apic_x2apic_mode(apic))
+		kvm_lapic_xapic_id_updated(apic);
+
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
-- 
1.8.3.1

