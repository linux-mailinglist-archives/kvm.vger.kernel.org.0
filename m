Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8650A42765D
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244607AbhJICSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244151AbhJICSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:18:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A328C061367
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:14:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x15-20020a056902102f00b005ba71cd7dbfso4955201ybt.8
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EO1DdjrhtpmWzjh1EvgBT+lYKJFtXbnNZvFnyTdrLr4=;
        b=SgQ6bc6sO/D2BDTT6qtx0WAi/ReMNLqD/ixklFc6XJsme6RvEAyibaoCcZ+6xQ5OkI
         ktC+f/9gaqy4GxqOHggOKkREje58nPcOr+Pu+vPxOlkYQMNw78hFOqCmgpg1tqeYBceP
         M02XL4PQM1TiYW71SKXsn2Ur2YlXd0iyCAEhOd4fAvr/JazoIpUsKNmjyf0Ni6JCCcKO
         7pxB0Pn+7ZUH5KunCEUOb6F/O+SJ9Gms308Iz4L/bVBrKppOYhyW2loCqRXdzIS5KBo7
         R+hLo/RYtlg4VS+ZdP6EH23BDWdpgqinGPjzLjDVYfoK7og0eyFX+gDYPLeJnrZbmP2N
         MJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EO1DdjrhtpmWzjh1EvgBT+lYKJFtXbnNZvFnyTdrLr4=;
        b=vBXETyHZyNPSmGl3Ba5r61ha8EFBwso4fUF471yNU4iicgLFSmucasS3vLUo93o7FP
         sx1FeR6itDtvYeQNvDqWpQSDbvRF4jUvRwDwu+XwTyTgeTzOXzWxr1LTc3knp/2lhJ2m
         Ga1fZHzLFBOO/FWMOQAqTBrqZ1845v3C04/Bg0IDD4e0bLT4nEW9I5FD2Ohj7ktbxS/L
         D4twqk290sRJEFBqEXOFPDXO3CHA1xWsg4OxgSoQmgi9BLqTd6TwZWpKVsHbdPFWCl+g
         FCKNkxjhvamFbO88y0gG3OWg/lAM2H3JV+rqWDENBTNiS/lFqOaaHXsHJUVifBDJy/E1
         1r4g==
X-Gm-Message-State: AOAM532G9MTFtyEUucRXEuyyCK8cnlUApkGpDt2/x4bu0nNEMSUSIMlE
        KDXig4sSvRdcczeNUsLs1DVe+iFUCpU=
X-Google-Smtp-Source: ABdhPJxzzIeOZb6NcqAHHKw15hpgOp6kx7Tgw+3WfUCiAT/0ER9Qq3B+94h2kbS9kEsVCOMb8KmVqa9KyAg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:22d7:: with SMTP id i206mr7801852ybi.355.1633745652715;
 Fri, 08 Oct 2021 19:14:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:30 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-38-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running on
 vCPU load (with APICv)
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always mark the AVIC as "running" on vCPU load when the AVIC is enabled and
drop the vcpu_blocking/unblocking hooks that toggle "running".  There is no
harm in keeping the flag set for a wee bit longer when a vCPU is blocking,
i.e. between the start of blocking and being scheduled out.  At worst, an
agent in the host will unnecessarily signal the doorbell, but that's
already the status quo in KVM as the "running" flag is set the entire time
a vCPU is loaded, not just when it's actively running the guest.

In addition to simplifying the code, keeping the "running" flag set longer
can reduce the number of VM-Exits due to incomplete IPI delivery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 53 +++++++++++++----------------------------
 arch/x86/kvm/svm/svm.c  |  8 -------
 arch/x86/kvm/svm/svm.h  |  3 ---
 3 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b43b05610ade..213f5223f63e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -967,6 +967,15 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/* TODO: Document why the unblocking path checks for updates. */
+	if (kvm_vcpu_is_blocking(vcpu) &&
+	    kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
+		kvm_vcpu_update_apicv(vcpu);
+
+		if (!kvm_vcpu_apicv_active(vcpu))
+			return;
+	}
+
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -974,19 +983,21 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
+	/*
+	 * Unconditionally mark the AVIC as "running", even if the vCPU is in
+	 * kvm_vcpu_block().  kvm_vcpu_check_block() will detect pending IRQs
+	 * and bail out of the block loop, and if not, avic_vcpu_put() will
+	 * set the AVIC back to "not running" when the vCPU is scheduled out.
+	 */
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	if (svm->avic_is_running)
-		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
-					svm->avic_is_running);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1001,33 +1012,3 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
-
-/*
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->avic_is_running = is_run;
-
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-}
-
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-	avic_set_running(vcpu, false);
-}
-
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
-		kvm_vcpu_update_apicv(vcpu);
-	avic_set_running(vcpu, true);
-}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89077160d463..a1ca5707f2c8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1433,12 +1433,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
-	/* We initialize this flag to true to make sure that the is_running
-	 * bit would be set the first time the vcpu is loaded.
-	 */
-	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
-		svm->avic_is_running = true;
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
@@ -4597,8 +4591,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = svm_vcpu_blocking,
-	.vcpu_unblocking = svm_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f5b01bbee29..652d71acfb6c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -169,7 +169,6 @@ struct vcpu_svm {
 	u32 dfr_reg;
 	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
-	bool avic_is_running;
 
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
@@ -529,8 +528,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
-void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
-void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-- 
2.33.0.882.g93a45727a2-goog

