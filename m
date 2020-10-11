Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF59128A977
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgJKSs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 14:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbgJKSs0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Oct 2020 14:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602442105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsF90lczTHK2vP6/mcyjhD+7u2tKEKelJzv9co4ZOe0=;
        b=iTfIDWSOlZitPm7+s9iAkWpk9K/179kJrbN3CTOfI7rhcXBA1o56a0Pk/vVLLvltybLf7U
        Qkml7gbVL85VIGB8sqJHqR0dmlAxn1IoKmDns7mLB43Q8Sc50Ut4c1WwsexI4bahtBPWcr
        g9kVuM1DiWFrlB3uDXvZDINglIbscLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-yCkWrjjbM1S0wrIHsOI76g-1; Sun, 11 Oct 2020 14:48:21 -0400
X-MC-Unique: yCkWrjjbM1S0wrIHsOI76g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77F96804004;
        Sun, 11 Oct 2020 18:48:20 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14565C1DC;
        Sun, 11 Oct 2020 18:48:19 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
Subject: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
Date:   Sun, 11 Oct 2020 14:48:17 -0400
Message-Id: <20201011184818.3609-2-cavery@redhat.com>
In-Reply-To: <20201011184818.3609-1-cavery@redhat.com>
References: <20201011184818.3609-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move asid to svm->asid to allow for vmcb assignment
during svm_vcpu_run without regard to which level
guest is running.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 4 +++-
 arch/x86/kvm/svm/svm.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4e18bda19c7..619980a5d540 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1101,6 +1101,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr4 = 0;
 	}
 	svm->asid_generation = 0;
+	svm->asid = 0;
 
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
@@ -1663,7 +1664,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	}
 
 	svm->asid_generation = sd->asid_generation;
-	svm->vmcb->control.asid = sd->next_asid++;
+	svm->asid = sd->next_asid++;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
@@ -3446,6 +3447,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	sync_lapic_to_cr8(vcpu);
 
+	svm->vmcb->control.asid = svm->asid;
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..862f0d2405e8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -104,6 +104,7 @@ struct vcpu_svm {
 	struct vmcb *vmcb;
 	unsigned long vmcb_pa;
 	struct svm_cpu_data *svm_data;
+	u32 asid;
 	uint64_t asid_generation;
 	uint64_t sysenter_esp;
 	uint64_t sysenter_eip;
-- 
2.20.1

