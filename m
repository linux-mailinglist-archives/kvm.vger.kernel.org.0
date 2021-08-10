Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E083E84CD
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhHJUyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234382AbhHJUyc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5GwAOytc+alDuVkjvMgicVVPcMLI/NAgXu8uD1zrA4=;
        b=bCWeSPU7dArND6nJWsWHXx/rU3PGkUVFElWDYdKxV2FsVLza47Rmlo/ASFc1Kb8DUAXS3E
        gL4cq47eQtwzwhEPoKMk5tU5xJY5yYQZ3O3pS1HtXMcmJt04Lmg3Og6aBm6CHVppBoSepF
        k6eoF7WP8v1C2+6bAACBsMGbxwl9jIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-pN1pLpUkO8OwbVdo5CHfOg-1; Tue, 10 Aug 2021 16:54:08 -0400
X-MC-Unique: pN1pLpUkO8OwbVdo5CHfOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFD831853026;
        Tue, 10 Aug 2021 20:54:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0B98620DE;
        Tue, 10 Aug 2021 20:53:59 +0000 (UTC)
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
Subject: [PATCH v4 15/16] KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC
Date:   Tue, 10 Aug 2021 23:52:50 +0300
Message-Id: <20210810205251.424103-16-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible to have the following scenario:

1. AVIC is disabled by svm_refresh_apicv_exec_ctrl
2. svm_vcpu_blocking calls avic_vcpu_put which does nothing
3. svm_vcpu_unblocking enables the AVIC (due to KVM_REQ_APICV_UPDATE)
   and then calls avic_vcpu_load
4. warning is triggered in avic_vcpu_load since
   AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK was never cleared

While it is possible to just remove the warning, it seems to be more robust
to fully disable/enable AVIC in svm_refresh_apicv_exec_ctrl by calling the
avic_vcpu_load/avic_vcpu_put

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e7728b16a46f..01c0e83e1b71 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -651,6 +651,11 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
+	if (activated)
+		avic_vcpu_load(vcpu, vcpu->cpu);
+	else
+		avic_vcpu_put(vcpu);
+
 	svm_set_pi_irte_mode(vcpu, activated);
 }
 
-- 
2.26.3

