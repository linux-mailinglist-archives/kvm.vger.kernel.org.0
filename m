Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FD1C6F0A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgEFLLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:11:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21589 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728245AbgEFLKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 07:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=J5YAMEUHkfZ5kHL/nUnWCxxSKh3Vel9Az4vNA1KvsdM=;
        b=L1vxTenwIvx75GXrjrDc9277GdLEMvpkIvfHHI9wkSUzn37hP2NFkYwrKoY2cBN/oVsS8a
        oteIwPpSeSUJMd28p33dFenStBWYGgz0sT23FtICcTsWl6oyDpZzwU6IxR9DRUzGC/EBUx
        CsB3Zu5/+WNknvtoGDDIwCyZoW++6Hc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-JXdafKoHNkWqUaPE2slMdA-1; Wed, 06 May 2020 07:10:47 -0400
X-MC-Unique: JXdafKoHNkWqUaPE2slMdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388918014C1;
        Wed,  6 May 2020 11:10:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4CB25C1D4;
        Wed,  6 May 2020 11:10:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 6/9] KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
Date:   Wed,  6 May 2020 07:10:31 -0400
Message-Id: <20200506111034.11756-7-pbonzini@redhat.com>
In-Reply-To: <20200506111034.11756-1-pbonzini@redhat.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that the current value of DR6 is always available in vcpu->arch.dr6,
so that the get_dr6 callback can just access vcpu->arch.dr6 and becomes
redundant.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f6aeefeb55..5627004e077e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1674,7 +1674,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 
 static u64 svm_get_dr6(struct kvm_vcpu *vcpu)
 {
-	return to_svm(vcpu)->vmcb->save.dr6;
+	return vcpu->arch.dr6;
 }
 
 static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
@@ -1693,7 +1693,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
-	vcpu->arch.dr6 = svm_get_dr6(vcpu);
+	vcpu->arch.dr6 = svm->vmcb->save.dr6;
 	vcpu->arch.dr7 = svm->vmcb->save.dr7;
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
@@ -1739,6 +1739,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
+		vcpu->arch.dr6 = svm->vmcb->save.dr6;
 		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
-- 
2.18.2


