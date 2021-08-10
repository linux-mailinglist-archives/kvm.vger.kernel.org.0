Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3F3E84D3
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhHJUzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:55:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234415AbhHJUyj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijwNNEcllK+t5cc2Umz3Vv9vhvGF8MBG5A38UzmKycw=;
        b=dJJ6QlNkWSgA+qIj9eiCpMj2JrzkljRgnHCE0DuSXdOUTBH444CUQeVx0Kka+Cl3uSfhBA
        6kRP+yor/RdQBy0UGmf7KwkcXF9j+hxkKrhfPyTzZHOrOYecOPLZ5ZaB31CwsfzHpToB+b
        W1sDgrs+vr6Q1LItR7t+fLJ643ahowk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-Ck3ZU83qMl6GbxPIv768Nw-1; Tue, 10 Aug 2021 16:54:15 -0400
X-MC-Unique: Ck3ZU83qMl6GbxPIv768Nw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F078B3E745;
        Tue, 10 Aug 2021 20:54:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4C9421F;
        Tue, 10 Aug 2021 20:54:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 16/16] KVM: SVM: AVIC: drop unsupported AVIC base relocation code
Date:   Tue, 10 Aug 2021 23:52:51 +0300
Message-Id: <20210810205251.424103-17-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APIC base relocation is not supported anyway and won't work
correctly so just drop the code that handles it and keep AVIC
MMIO bar at the default APIC base.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 ++
 arch/x86/kvm/svm/svm.c  | 7 -------
 arch/x86/kvm/svm/svm.h  | 6 ------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 01c0e83e1b71..8052d92069e0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -197,6 +197,8 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
+
 	if (kvm_apicv_activated(svm->vcpu.kvm))
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	else
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 700bc188a650..160b10ca4f62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1316,9 +1316,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->virt_spec_ctrl = 0;
 
 	init_vmcb(vcpu);
-
-	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
-		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
@@ -2969,10 +2966,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
-	case MSR_IA32_APICBASE:
-		if (kvm_vcpu_apicv_active(vcpu))
-			avic_update_vapic_bar(to_svm(vcpu), data);
-		fallthrough;
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index aae851762b59..524d943f3efc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -503,12 +503,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
-{
-	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
-	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
-}
-
 static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-- 
2.26.3

