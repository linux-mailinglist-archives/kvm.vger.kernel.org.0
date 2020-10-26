Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18B2299420
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788160AbgJZRmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1788134AbgJZRma (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603734149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRAf8EjuLOHrdC1dVgSQl9YALtlT6bu//tBLi7Rkrj8=;
        b=Zoi+rLHFeIYM33jEjOubmwyIosdFUaTKOZe7P8N0SstMz1q6zT3cNf5CjUn46eXt+hBn0E
        P7tiRu856XOJRJkZ8taOrlrP+rH6WcCqAFrnC8Kgr68X5lDm9mf2NhkMxuiM/d/PmdFT54
        TKF8euSuDpTiQipPa8dEL7hZC4Ki/1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-r_sdJvPXP9G8BP6hFMK2Cw-1; Mon, 26 Oct 2020 13:42:25 -0400
X-MC-Unique: r_sdJvPXP9G8BP6hFMK2Cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48928803637;
        Mon, 26 Oct 2020 17:42:24 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A221E62A0B;
        Mon, 26 Oct 2020 17:42:23 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com,
        sean.j.christopherson@intel.com
Subject: [PATCH v3 1/2] KVM: SVM: Track asid from vcpu_svm
Date:   Mon, 26 Oct 2020 13:42:21 -0400
Message-Id: <20201026174222.21811-2-cavery@redhat.com>
In-Reply-To: <20201026174222.21811-1-cavery@redhat.com>
References: <20201026174222.21811-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track asid from svm->asid to allow for vmcb assignment
without regard to which level guest is running.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h |  2 ++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4e18bda19c7..83b4f56883f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1101,6 +1101,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr4 = 0;
 	}
 	svm->asid_generation = 0;
+	svm->asid = 0;
 
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
@@ -1659,11 +1660,11 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		sd->flush_all_asid = true;
 	}
 
 	svm->asid_generation = sd->asid_generation;
-	svm->vmcb->control.asid = sd->next_asid++;
+	svm->asid = sd->next_asid++;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
@@ -3030,6 +3031,17 @@ static void pre_svm_run(struct vcpu_svm *svm)
 	/* FIXME: handle wraparound of asid_generation */
 	if (svm->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
+
+	if (sd->flush_all_asid) {
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		sd->flush_all_asid = false;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
+
+	if (unlikely(svm->asid != svm->vmcb->control.asid))
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+
+	svm->vmcb->control.asid = svm->asid;
 }
 
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..22832362bced 100644
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
@@ -164,6 +165,7 @@ struct svm_cpu_data {
 	int cpu;
 
 	u64 asid_generation;
+	bool flush_all_asid;
 	u32 max_asid;
 	u32 next_asid;
 	u32 min_asid;
-- 
2.20.1

