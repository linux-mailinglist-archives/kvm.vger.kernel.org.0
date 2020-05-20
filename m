Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E091DBB47
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgETRX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728099AbgETRWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=v/fUARAthG/wKTNhu7AC326un8WX6UyBf3/Gu9fdswg=;
        b=cKMNm7XhCuBi+uvtBoUypNwwTYurkCffssnz0n6pQspKBKt7CGuq3QI93qGKLfAr7ax/VZ
        9s194XgTY2kR11Mp9C6SBTelEFiRyvO6itIqM6Y/9EA8z/64qvB6EXiMZ4caTlq52xmpgv
        chC5g1V+asWEUsfQN55UplFyndsyq3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-4FNQ00w-O_u5cmoec9ypVA-1; Wed, 20 May 2020 13:22:08 -0400
X-MC-Unique: 4FNQ00w-O_u5cmoec9ypVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 555208463A3;
        Wed, 20 May 2020 17:22:07 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6E7170461;
        Wed, 20 May 2020 17:22:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 17/24] KVM: nSVM: do all MMU switch work in init/uninit functions
Date:   Wed, 20 May 2020 13:21:38 -0400
Message-Id: <20200520172145.23284-18-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the kvm_mmu_reset_context calls to nested_svm_init_mmu_context and
nested_svm_uninit_mmu_context, so that the state of the MMU is consistent
with the vcpu->arch.mmu and vcpu->arch.walk_mmu state.  Remove an
unnecessary kvm_mmu_load, which can wait until the first vcpu_run.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 024e27bebba3..54a3384a60f8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -90,12 +90,17 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu->shadow_root_level = vcpu->arch.tdp_level;
 	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
+
+	/* Guest paging mode is active - reset mmu */
+	kvm_mmu_reset_context(vcpu);
 }
 
 static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
+
+	kvm_mmu_reset_context(vcpu);
 }
 
 void recalc_intercepts(struct vcpu_svm *svm)
@@ -277,9 +282,6 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
-	/* Guest paging mode is active - reset mmu */
-	kvm_mmu_reset_context(&svm->vcpu);
-
 	svm_flush_tlb(&svm->vcpu);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
@@ -573,8 +575,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
-	kvm_mmu_reset_context(&svm->vcpu);
-	kvm_mmu_load(&svm->vcpu);
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
-- 
2.18.2


