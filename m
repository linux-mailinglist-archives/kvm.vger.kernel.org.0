Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426723517EF
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhDARnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234879AbhDARlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vyMr3QsOTroXcgjRtUdx7Du8y9HMmuw3i24kPeKgTH4=;
        b=UHSK70C492TvpRcA0lqKu2Hc6kpLnsc0ij9XZ3CSuswQW2Cxx1HgQLNitosZwepeOR9W0Y
        c5juV6oTIUabVUcJ/XP/4JSoUnhfE4xEuQKOuvUhomXLA8eUC/olmFwnDi+781bC39dLPN
        fusSJ8dfJ/3p7fkrDRZ90cdqWKjv/90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-e6V2UZJlPB-u618cERGpDg-1; Thu, 01 Apr 2021 10:39:30 -0400
X-MC-Unique: e6V2UZJlPB-u618cERGpDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D39B784B99E;
        Thu,  1 Apr 2021 14:38:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86BB45D9CA;
        Thu,  1 Apr 2021 14:38:22 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/4] KVM: x86: pending exceptions must not be blocked by an injected event
Date:   Thu,  1 Apr 2021 17:38:14 +0300
Message-Id: <20210401143817.1030695-2-mlevitsk@redhat.com>
In-Reply-To: <20210401143817.1030695-1-mlevitsk@redhat.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Injected interrupts/nmi should not block a pending exception,
but rather be either lost if nested hypervisor doesn't
intercept the pending exception (as in stock x86), or be delivered
in exitintinfo/IDT_VECTORING_INFO field, as a part of a VMexit
that corresponds to the pending exception.

The only reason for an exception to be blocked is when nested run
is pending (and that can't really happen currently
but still worth checking for).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  8 +++++++-
 arch/x86/kvm/vmx/nested.c | 10 ++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8523f60adb92..34a37b2bd486 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1062,7 +1062,13 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (block_nested_events)
+		/*
+		 * Only a pending nested run can block a pending exception.
+		 * Otherwise an injected NMI/interrupt should either be
+		 * lost or delivered to the nested hypervisor in the EXITINTINFO
+		 * vmcb field, while delivering the pending exception.
+		 */
+		if (svm->nested.nested_run_pending)
                         return -EBUSY;
 		if (!nested_exit_on_exception(svm))
 			return 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd334e4aa6db..c3ba842fc07f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3806,9 +3806,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Process any exceptions that are not debug traps before MTF.
+	 *
+	 * Note that only a pending nested run can block a pending exception.
+	 * Otherwise an injected NMI/interrupt should either be
+	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
+	 * while delivering the pending exception.
 	 */
+
 	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
-		if (block_nested_events)
+		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
@@ -3825,7 +3831,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (block_nested_events)
+		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
-- 
2.26.2

