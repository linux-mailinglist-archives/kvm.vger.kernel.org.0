Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4412EF0F0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfKDXAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387414AbfKDXAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 18:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aseh8jCVnCf+xASp3Iq7VvtjdXkhAmuUdvYEt6eYMGc=;
        b=iOHEWTkIk8twVtgLhL/djg5tsTYl1FFnT3dPtsWoBTKjCqD3mSnGjWse6VggcONFmbsFL9
        oDpXrJqM9qvWz8A+4Xz/dOkuxVPk67jCz5S78LD8pdLElwmg3aHqykXrqb6A6Og/NUHUxb
        EEHjTpAhU6VEpKnbhWITGr3HHnzRcYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-GA1gpvOINZuDeunO9zBc4Q-1; Mon, 04 Nov 2019 18:00:12 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2BE81005509;
        Mon,  4 Nov 2019 23:00:11 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 460DB5D6D4;
        Mon,  4 Nov 2019 23:00:09 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 09/13] KVM: monolithic: x86: drop the kvm_pmu_ops structure
Date:   Mon,  4 Nov 2019 17:59:57 -0500
Message-Id: <20191104230001.27774-10-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: GA1gpvOINZuDeunO9zBc4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup after the structure was finally left completely unused.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/pmu.h              | 20 --------------------
 arch/x86/kvm/pmu_amd.c          | 15 ---------------
 arch/x86/kvm/svm.c              |  1 -
 arch/x86/kvm/vmx/pmu_intel.c    | 15 ---------------
 arch/x86/kvm/vmx/vmx.c          |  2 --
 6 files changed, 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 2ddc61fdcd09..9cb18d3ffbe1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1345,9 +1345,6 @@ struct kvm_x86_ops {
 =09=09=09=09=09   gfn_t offset, unsigned long mask);
 =09int (*write_log_dirty)(struct kvm_vcpu *vcpu);
=20
-=09/* pmu operations of sub-arch */
-=09const struct kvm_pmu_ops *pmu_ops;
-
 =09/*
 =09 * Architecture specific hooks for vCPU blocking due to
 =09 * HLT instruction.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 82f07e3492df..c74d4ab30f66 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -36,23 +36,6 @@ extern void kvm_x86_pmu_refresh(struct kvm_vcpu *vcpu);
 extern void kvm_x86_pmu_init(struct kvm_vcpu *vcpu);
 extern void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu);
=20
-struct kvm_pmu_ops {
-=09unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-=09=09=09=09    u8 unit_mask);
-=09unsigned (*find_fixed_event)(int idx);
-=09bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
-=09struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
-=09struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
-=09=09=09=09=09  u64 *mask);
-=09int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
-=09bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
-=09int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
-=09int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
-=09void (*refresh)(struct kvm_vcpu *vcpu);
-=09void (*init)(struct kvm_vcpu *vcpu);
-=09void (*reset)(struct kvm_vcpu *vcpu);
-};
-
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 =09struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
@@ -138,7 +121,4 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
=20
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
-
-extern struct kvm_pmu_ops intel_pmu_ops;
-extern struct kvm_pmu_ops amd_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 7ea588023949..1b09ae337516 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -300,18 +300,3 @@ void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu)
 =09=09pmc->counter =3D pmc->eventsel =3D 0;
 =09}
 }
-
-struct kvm_pmu_ops amd_pmu_ops =3D {
-=09.find_arch_event =3D kvm_x86_pmu_find_arch_event,
-=09.find_fixed_event =3D kvm_x86_pmu_find_fixed_event,
-=09.pmc_is_enabled =3D kvm_x86_pmu_pmc_is_enabled,
-=09.pmc_idx_to_pmc =3D kvm_x86_pmu_pmc_idx_to_pmc,
-=09.msr_idx_to_pmc =3D kvm_x86_pmu_msr_idx_to_pmc,
-=09.is_valid_msr_idx =3D kvm_x86_pmu_is_valid_msr_idx,
-=09.is_valid_msr =3D kvm_x86_pmu_is_valid_msr,
-=09.get_msr =3D kvm_x86_pmu_get_msr,
-=09.set_msr =3D kvm_x86_pmu_set_msr,
-=09.refresh =3D kvm_x86_pmu_refresh,
-=09.init =3D kvm_x86_pmu_init,
-=09.reset =3D kvm_x86_pmu_reset,
-};
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4ce102f6f075..0021e11fd1fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7290,7 +7290,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init=
 =3D {
=20
 =09.sched_in =3D kvm_x86_sched_in,
=20
-=09.pmu_ops =3D &amd_pmu_ops,
 =09.deliver_posted_interrupt =3D kvm_x86_deliver_posted_interrupt,
 =09.dy_apicv_has_pending_interrupt =3D kvm_x86_dy_apicv_has_pending_interr=
upt,
 =09.update_pi_irte =3D kvm_x86_update_pi_irte,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2fa9ae5acde1..9bd062a8516a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -359,18 +359,3 @@ void kvm_x86_pmu_reset(struct kvm_vcpu *vcpu)
 =09pmu->fixed_ctr_ctrl =3D pmu->global_ctrl =3D pmu->global_status =3D
 =09=09pmu->global_ovf_ctrl =3D 0;
 }
-
-struct kvm_pmu_ops intel_pmu_ops =3D {
-=09.find_arch_event =3D kvm_x86_pmu_find_arch_event,
-=09.find_fixed_event =3D kvm_x86_pmu_find_fixed_event,
-=09.pmc_is_enabled =3D kvm_x86_pmu_pmc_is_enabled,
-=09.pmc_idx_to_pmc =3D kvm_x86_pmu_pmc_idx_to_pmc,
-=09.msr_idx_to_pmc =3D kvm_x86_pmu_msr_idx_to_pmc,
-=09.is_valid_msr_idx =3D kvm_x86_pmu_is_valid_msr_idx,
-=09.is_valid_msr =3D kvm_x86_pmu_is_valid_msr,
-=09.get_msr =3D kvm_x86_pmu_get_msr,
-=09.set_msr =3D kvm_x86_pmu_set_msr,
-=09.refresh =3D kvm_x86_pmu_refresh,
-=09.init =3D kvm_x86_pmu_init,
-=09.reset =3D kvm_x86_pmu_reset,
-};
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87e5d7276ea4..222467b2040e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7897,8 +7897,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init=
 =3D {
 =09.pre_block =3D kvm_x86_pre_block,
 =09.post_block =3D kvm_x86_post_block,
=20
-=09.pmu_ops =3D &intel_pmu_ops,
-
 =09.update_pi_irte =3D kvm_x86_update_pi_irte,
=20
 #ifdef CONFIG_X86_64

