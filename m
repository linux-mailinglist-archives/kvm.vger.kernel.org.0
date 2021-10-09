Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515404275AD
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbhJICOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244166AbhJICOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:14:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67684C061762
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:12:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso15201888ybj.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=79LIBqpnbdhRmfT7kSoV1WyIctghtEtxlcdZEfLixOI=;
        b=td6Jp/Qoz+WOt+cvb/jSNSqRd38PBqxXjUOlkCeRRmF+Xq32DT9663UFIERzbBP+7k
         sIaPHTm4Vgj+KHKuAZRxJtlQiFNwnW7Gr6Np/g8/gHiZEP/vq1b8eXJehgPH0k67g74g
         Eejc31bexmjXOP0iVOhiJxMHqh3sykybQ5VDUN0mBT1X+xmhe4U8/hRuzrlGW28cUSb9
         g22fsln1P8HNH27yLN8eZT01CH6+UAgE5LZNQQheC1aFigNp8cVDpq7HbECp3WAvt9tG
         GqRirzTAEB5G45ET1seL/TOuwe+ZOUYFxzi+NEQTSlGInnVjBGl4BhooEPA1Uoist32O
         48qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=79LIBqpnbdhRmfT7kSoV1WyIctghtEtxlcdZEfLixOI=;
        b=QFtkUTvbBYKswZu1H6t7bq6mB/dThlKRX+6zXcPKACVT6yjU/r/iG8BdOGydNZ8PF0
         y8HbQYUtrhIXihAmPwUCK24VuxFdLIaetZHqz/mMuqdIsVTVz0GOGRcmPx+y8LKolYqP
         /P/JMu8Xx1NBnMThsmVKwIur4wYEEJhLCmWX4dVAKqRcABoRBJBqIMPf5Xk2yR4M9NOa
         9NJmRYU4qU4oKVcH/+sLHJs0tpL9p/x+VM+7eq7HP4hZAg8arcVLxKoRRARU1qrLBRF3
         3Q9nR8mwsTXrYXjLx1A7XfRCDQal1vEl6nXTNY8bKn9QISmijCqL3qu7PcnmCkCEXNEc
         KknQ==
X-Gm-Message-State: AOAM531u7L8fILXSkABbL8BxkUXNTEXDRZuuahwgtI/QJIkki9ateny5
        yAuD9yfwszWoIAzgZDWdEBIN9H2579M=
X-Google-Smtp-Source: ABdhPJzWtheYwqmb2qGHXjL3MjJXvhFbgclB9eUF2EsS3ZM9JxohPV47rYshPv06U56fIG/ADzd4Ho8ZjF4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bd03:: with SMTP id f3mr6935305ybk.412.1633745566669;
 Fri, 08 Oct 2021 19:12:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:11:55 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 02/43] KVM: SVM: Ensure target pCPU is read once when
 signalling AVIC doorbell
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

Ensure vcpu->cpu is read once when signalling the AVIC doorbell.  If the
compiler rereads the field and the vCPU is migrated between the check and
writing the doorbell, KVM would signal the wrong physical CPU.

Functionally, signalling the wrong CPU in this case is not an issue as
task migration means the vCPU has exited and will pick up any pending
interrupts on the next VMRUN.  Add the READ_ONCE() purely to clean up the
code.

Opportunistically add a comment explaining the task migration behavior,
and rename cpuid=>cpu to avoid conflating the CPU number with KVM's more
common usage of CPUID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e0..208c5c71e827 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -675,10 +675,17 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	smp_mb__after_atomic();
 
 	if (avic_vcpu_is_running(vcpu)) {
-		int cpuid = vcpu->cpu;
+		int cpu = READ_ONCE(vcpu->cpu);
 
-		if (cpuid != get_cpu())
-			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpuid));
+		/*
+		 * Note, the vCPU could get migrated to a different pCPU at any
+		 * point, which could result in signalling the wrong/previous
+		 * pCPU.  But if that happens the vCPU is guaranteed to do a
+		 * VMRUN (after being migrated) and thus will process pending
+		 * interrupts, i.e. a doorbell is not needed (and the spurious)
+		 */
+		if (cpu != get_cpu())
+			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
 		put_cpu();
 	} else
 		kvm_vcpu_wake_up(vcpu);
-- 
2.33.0.882.g93a45727a2-goog

