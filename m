Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3303A46CA89
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbhLHB65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243425AbhLHB6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:43 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA8FC0698C6
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y68-20020a626447000000b004a2b2d0c39eso681364pfb.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Os9t3PK/1Q6X8L88GHE3qfHjmqX2bj+Lj4P7zobea20=;
        b=GxPab2eAQ1zR+MIC7R4aaig3jil5DsGkCS9yQ8q4Z79CpuJL+SET/SFcCSTqFKGfUK
         gGth0HAhK64hi3UbzwTDtSKi+AFgbtNUffEN1ZBuN/woQ+e3eq0NNOmE2fMddj5+Uvyn
         A+fMa6DuJe95mkeMtBC1Djxf47VoYGT5YM9xlACTrUurxDi85vj+PbL3wpS8I6/hgUNP
         720meHO9QbRwhUZavuQwNn52WMtS9s80CfHoA6jU1f4ho66MvnR/Mj0+HL5BL2QpcfrG
         BQdDB1WB7G/IyCqL+oej6dueC+ctxa3Zk2OpwuNceFfyhWzVb8GwDbKw+FK2tGjukM5P
         0CZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Os9t3PK/1Q6X8L88GHE3qfHjmqX2bj+Lj4P7zobea20=;
        b=w7yBbhqBfprfTfgZjhpLOdyLqrLLdV22lcND6F2Ni/3csFypqIG1EpLp2IMH3tnrqv
         X/WF8B+dKVVgPTYbPIJMJTuwQMwoMh7HgoimFAZ/54FK4uqSJPZuR4WrRn/XdtCjFUH4
         bD/2OPND/rr2hg5JXNFzUjvO0Jy0go/yZTKG+TO9HU600TIHlgzoxTLkntbQvXl+kapb
         qUw0sF30bnJrNcH//azuH5uj7deJ4G7E0wkOLeHyXs/qGMPKYzlH4F8mdlYqwICGBtEm
         OuedjyYYEMXNrVkohwCox/LNaflO1YNEhM5t/m6M3eyHEZbdHlGznM+Mc4b+JWBdjwDh
         khMQ==
X-Gm-Message-State: AOAM533SbzZE3RGUgZ1Gw9ARFbrUTEsntE8jFFm5sVefSJp51qxKVtqD
        pimjDraGF4kZWrY8QTbuK3xuVOB1ifg=
X-Google-Smtp-Source: ABdhPJxsMsSxtywu0s/1ig+ARF1hrT3HXASsf4sf2qoyLew9jB7OXnpi43IqnpO+NMpFJVnL2vJImWV0uqk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a4d:: with SMTP id
 lb13mr3543900pjb.97.1638928510003; Tue, 07 Dec 2021 17:55:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:24 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 14/26] KVM: SVM: Skip AVIC and IRTE updates when loading
 blocking vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother updating the Physical APIC table or IRTE when loading a vCPU
that is blocking, i.e. won't be marked IsRun{ning}=1, as the pCPU is
queried if and only if IsRunning is '1'.  If the vCPU was migrated, the
new pCPU will be picked up when avic_vcpu_load() is called by
svm_vcpu_unblocking().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dc0cbe500106..0c6dfd85b3bb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -974,7 +974,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
 	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
-	bool is_blocking = kvm_vcpu_is_blocking(vcpu);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -985,24 +984,25 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
+	/*
+	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
+	 * is being scheduled in after being preempted.  The CPU entries in the
+	 * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
+	 * If the vCPU was migrated, its new CPU value will be stuffed when the
+	 * vCPU unblocks.
+	 */
+	if (kvm_vcpu_is_blocking(vcpu))
+		return;
+
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-
-	/*
-	 * Don't mark the vCPU as running if its blocking, i.e. if the vCPU is
-	 * preempted after svm_vcpu_blocking() but before KVM voluntarily
-	 * schedules out the vCPU.
-	 */
-	if (!is_blocking)
-		entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
+	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, !is_blocking);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1011,8 +1011,12 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+
+	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+		return;
+
+	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
@@ -1043,5 +1047,6 @@ void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+
 	avic_set_running(vcpu, true);
 }
-- 
2.34.1.400.ga245620fadb-goog

