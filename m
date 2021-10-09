Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78D142762A
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbhJICQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244414AbhJICQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:16:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4745C06176A
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q193-20020a252aca000000b005ba63482993so6521284ybq.0
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=p2AXaXCXfG3zJ1FL308pQbveOpDqWTdi8iqec5R3ilA=;
        b=ghMBthmudSXs+6+p6LKZCK4H0OHszDcUTjjC8eI9oFe5NKEBgV82EMdibCOuqO9Vxj
         RdWrTXr3jIuis42ImlAoRzWDoHFdmCVkvhr7Ak9ohTH6uYw/wAChiBME+5gVCVNAgppx
         Bau/vxHhIQUy9RpDE2jA3YK9PywakgEEGvf08OG/9sd3zh0sXBu7t3verDPFwVmZOBV6
         6EvsyuVx5W4cXQ42SL97ee8aY4sDaFqLd/c+4qYy3T18FOiClCY3egvkUGNfWDUIncUQ
         g+5hQtAw8uYrvtob8ZWh/HS1msNf2yq2NMlMufCxgAu3+fQ5cHcaqEQ/AFlCCc3jp+BF
         /aSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=p2AXaXCXfG3zJ1FL308pQbveOpDqWTdi8iqec5R3ilA=;
        b=Dx4zWSs+stgV4gW6yu1dX8YoQaZiLOScqnoWmNGkKcMHRD4niCFcCGr82qh5o+8jBG
         pmIuNyYWpS0AnbamCakYjioppj73gIzA/dn/nycfccJLY1K9RSVClCVY+qZjbsOtsUr3
         vuT5tXcVpgRfOzHp89im5MTcgwv0TLorpPQr6owyfeVb578BmseX3KSn8iZc570R/V5X
         5Fbq0OCujNLgcXGQT2Liz/w5N0bH2i4CjHPLkxM33CaWwev6KdjgiIzZEyg82yj+RcpH
         5Y8WjYOXVG2QbplY8CVq5/6wUuWIJ6qF1qpLVHRf5pmSt32qazCpjDJpFcifhwF3IkSm
         6L1g==
X-Gm-Message-State: AOAM5339CDKJF4oJnppLiqmxRZeX1AzLqPywTTnvqgHC2VUN0FDdw+ZH
        Umg5ZfP7QuQp532F8wF+TZFOzvd4FYw=
X-Google-Smtp-Source: ABdhPJx6Bv/qxNdoBxYiPnsjWrMq4fbR1wONeQsZ0IiCsamqBbWFWlGuin3sFq5D1af73AaAZ7aulEVU00Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:8b06:: with SMTP id i6mr7491785ybl.427.1633745621082;
 Fri, 08 Oct 2021 19:13:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:17 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 24/43] KVM: VMX: Drop pointless PI.NDST update when blocking
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

Don't update Posted Interrupt's NDST, a.k.a. the target pCPU, in the
pre-block path, as NDST is guaranteed to be up-to-date.  The comment
about the vCPU being preempted during the update is simply wrong, as the
update path runs with IRQs disabled (from before snapshotting vcpu->cpu,
until after the update completes).

The vCPU can get preempted _before_ the update starts, but not during.
And if the vCPU is preempted before, vmx_vcpu_pi_load() is responsible
for updating NDST when the vCPU is scheduled back in.  In that case, the
check against the wakeup vector in vmx_vcpu_pi_load() cannot be true as
that would require the notification vector to have been set to the wakeup
vector _before_ blocking.

Opportunistically switch to using vcpu->cpu for the list/lock lookups,
which presumably used pre_pcpu only for some phantom preemption logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 1688f8dc535a..239e0e72a0dd 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -130,7 +130,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
  * - Store the vCPU to the wakeup list, so when interrupts happen
  *   we can find the right vCPU to wake up.
  * - Change the Posted-interrupt descriptor as below:
- *      'NDST' <-- vcpu->pre_pcpu
  *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
  * - If 'ON' is set during this process, which means at least one
  *   interrupt is posted for this vCPU, we cannot block it, in
@@ -139,7 +138,6 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
  */
 int pi_pre_block(struct kvm_vcpu *vcpu)
 {
-	unsigned int dest;
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
@@ -153,10 +151,10 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 
 	vcpu->pre_pcpu = vcpu->cpu;
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 	list_add_tail(&vcpu->blocked_vcpu_list,
-		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 
 	WARN(pi_desc->sn == 1,
 	     "Posted Interrupt Suppress Notification set before blocking");
@@ -164,21 +162,6 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	do {
 		old.control = new.control = pi_desc->control;
 
-		/*
-		 * Since vCPU can be preempted during this process,
-		 * vcpu->cpu could be different with pre_pcpu, we
-		 * need to set pre_pcpu as the destination of wakeup
-		 * notification event, then we can find the right vCPU
-		 * to wakeup in wakeup handler if interrupts happen
-		 * when the vCPU is in blocked state.
-		 */
-		dest = cpu_physical_id(vcpu->pre_pcpu);
-
-		if (x2apic_mode)
-			new.ndst = dest;
-		else
-			new.ndst = (dest << 8) & 0xFF00;
-
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
 	} while (cmpxchg64(&pi_desc->control, old.control,
-- 
2.33.0.882.g93a45727a2-goog

