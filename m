Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4B3E84CA
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhHJUyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234585AbhHJUy0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knMixSXR1OcGQkWSrlCsIpGHjIT1cMve0h4vaB7v5cc=;
        b=Qd21FIp5gZXA7GHcuLQEKIAIN1ps9Fw88722IjfsaFv60hwiKuiBIffktKn9F8wb0/fDZV
        xH0mfbBXWCgTjTPxNxbhmsNd9gHlaS+x066t21ldZkX4NQY/3SOujI/saIp4J5febknpvv
        cAAFYm47i2JajiiulHKl/MCu4c6jhYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-ZtjbB_jEPJCI7fEoqhdJ2w-1; Tue, 10 Aug 2021 16:54:01 -0400
X-MC-Unique: ZtjbB_jEPJCI7fEoqhdJ2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D0391853028;
        Tue, 10 Aug 2021 20:53:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ECC569CBA;
        Tue, 10 Aug 2021 20:53:55 +0000 (UTC)
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
Subject: [PATCH v4 14/16] KVM: SVM: move check for kvm_vcpu_apicv_active outside of avic_vcpu_{put|load}
Date:   Tue, 10 Aug 2021 23:52:49 +0300
Message-Id: <20210810205251.424103-15-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++------
 arch/x86/kvm/svm/svm.c  |  7 +++++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1def54c26259..e7728b16a46f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -940,9 +940,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -970,9 +967,6 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
@@ -989,6 +983,10 @@ static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->avic_is_running = is_run;
+
+	if (!kvm_vcpu_apicv_active(vcpu))
+		return;
+
 	if (is_run)
 		avic_vcpu_load(vcpu, vcpu->cpu);
 	else
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1da12d700436..700bc188a650 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1483,12 +1483,15 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sd->current_vmcb = svm->vmcb;
 		indirect_branch_prediction_barrier();
 	}
-	avic_vcpu_load(vcpu, cpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_put(vcpu);
+
 	svm_prepare_host_switch(vcpu);
 
 	++vcpu->stat.host_state_reload;
-- 
2.26.3

