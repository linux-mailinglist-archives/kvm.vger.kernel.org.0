Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE463A189D
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhFIPLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:11:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230482AbhFIPLM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z8tEfF90cCQlC7sdgQBkk9KeCo34hw2aVi5kPWZmQ10=;
        b=QMOrDsLqxpnrRxkbFsCWwIxK8ilqtLNldmoKPNxt7NNcVPfYs6NOYBCODQie/j07xKmF9n
        U1wwxNDmL+tu2OHFaK/83sj96q+/i3edEA/KwUhZaC45JE4QS6KfqsKxgl1QKWArUptM8K
        jgKUfz9HvfXtMwy2K86RcgSeet1gz/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-Ju7eEeNnN8e_rburR6DKbQ-1; Wed, 09 Jun 2021 11:09:16 -0400
X-MC-Unique: Ju7eEeNnN8e_rburR6DKbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17479BBEE6;
        Wed,  9 Jun 2021 15:09:15 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7BC818A9E;
        Wed,  9 Jun 2021 15:09:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC with APICv/AVIC
Date:   Wed,  9 Jun 2021 17:09:07 +0200
Message-Id: <20210609150911.1471882-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- First two patches got merged, rebase.
- Use 'enable_apicv = avic = ...' in PATCH1 [Paolo]
- Collect R-b tags for PATCH2 [Sean, Max]
- Use hv_apicv_update_work() to get out of SRCU lock [Max]
- "KVM: x86: Check for pending interrupts when APICv is getting disabled"
  added.

Original description:

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

The series can be tested with the followin hack:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9a48f138832d..65a9974f80d9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
                                           vcpu->arch.ia32_misc_enable_msr &
                                           MSR_IA32_MISC_ENABLE_MWAIT);
        }
+
+       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
+       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+       if (best) {
+               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
+               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
Vitaly Kuznetsov (4):
  KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
  KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
  KVM: x86: Check for pending interrupts when APICv is getting disabled
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
    use

 arch/x86/include/asm/kvm_host.h |  9 +++++-
 arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/avic.c         | 14 ++++-----
 arch/x86/kvm/svm/svm.c          | 22 ++++++++------
 arch/x86/kvm/svm/svm.h          |  2 --
 arch/x86/kvm/vmx/capabilities.h |  1 -
 arch/x86/kvm/vmx/vmx.c          |  2 --
 arch/x86/kvm/x86.c              | 18 ++++++++++--
 8 files changed, 86 insertions(+), 33 deletions(-)

-- 
2.31.1

