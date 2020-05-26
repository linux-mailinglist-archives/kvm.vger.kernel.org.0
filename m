Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655481E28C2
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389571AbgEZRZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389023AbgEZRXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ni271Qqxu9oO+hVMW0dVUK78YZoqKfUPsuzcekMX40=;
        b=Z1zO2Gprx8seTT+SDuIgsQBub37k8O3VitNrRFDt+psLXoP8KDsOuMJR6g5lfUv64pw19o
        2wPMvCBZXSp1Rh4OcR3ptp8gub+BJpaYdhxPK/XPUjWFBuHpnyRa5++WdemHux1r8P2dRj
        WQIZDPElukrjENufONgXn2gT4Pd6Bcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-FJ7VxoShMUyMOCQ5T9NgXw-1; Tue, 26 May 2020 13:23:15 -0400
X-MC-Unique: FJ7VxoShMUyMOCQ5T9NgXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A6FB107ACCA;
        Tue, 26 May 2020 17:23:14 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C565810013DB;
        Tue, 26 May 2020 17:23:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 07/28] KVM: nVMX: always update CR3 in VMCS
Date:   Tue, 26 May 2020 13:22:47 -0400
Message-Id: <20200526172308.111575-8-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
an optimization, but this is only correct before the nested vmentry.
If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
already been put in guest mode, the value of CR3 will not be updated.
Remove the optimization, which almost never triggers anyway.

Fixes: 04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aedc46407b1f..7efdc3c2f7f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3085,10 +3085,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
-		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
-		if (is_guest_mode(vcpu))
-			update_guest_cr3 = false;
-		else if (!enable_unrestricted_guest && !is_paging(vcpu))
+		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			guest_cr3 = vcpu->arch.cr3;
-- 
2.26.2


