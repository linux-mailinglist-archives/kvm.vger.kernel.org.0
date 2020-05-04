Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B841C3F29
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgEDP4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:56:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59925 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728873AbgEDP4E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 11:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588607763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=qfjHToR8uqa7tXot0UhNc4RMRZnM9s7plHAoZTYaT2A=;
        b=GMd86aVfAYaKFYmC5GC1Z1V9OnMKAvix+N7rIvpeRwiTFE0yc13w6lxr7MLqhpPfHhpzv4
        YqHoyJayxUKH0zheStNVYMbpkd+4Rueg8tCYiuUVI4eHF82Q9Kk3rldjE6Z/eLxx4QuPF0
        biyobl6OfDRK8hiLGtjQBrcT/Yg03cI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-U8e_kOqjMra00k7xWgOnUw-1; Mon, 04 May 2020 11:56:01 -0400
X-MC-Unique: U8e_kOqjMra00k7xWgOnUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5321D8014D5;
        Mon,  4 May 2020 15:56:00 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88B857990;
        Mon,  4 May 2020 15:55:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/3] KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
Date:   Mon,  4 May 2020 11:55:57 -0400
Message-Id: <20200504155558.401468-3-pbonzini@redhat.com>
In-Reply-To: <20200504155558.401468-1-pbonzini@redhat.com>
References: <20200504155558.401468-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index dbcf4198a9fe..6b65c75b6816 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1654,7 +1654,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 
 static u64 svm_get_dr6(struct kvm_vcpu *vcpu)
 {
-	return to_svm(vcpu)->vmcb->save.dr6;
+	return vcpu->arch.dr6;
 }
 
 static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
@@ -1673,7 +1673,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
-	vcpu->arch.dr6 = svm_get_dr6(vcpu);
+	vcpu->arch.dr6 = svm->vmcb->save.dr6;
 	vcpu->arch.dr7 = svm->vmcb->save.dr7;
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
@@ -1719,6 +1719,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
+		vcpu->arch.dr6 = svm->vmcb->save.dr6;
 		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
-- 
2.18.2


