Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1008939D835
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFGJE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231185AbhFGJEw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KKLI7uUGKW2siPFOyr6No7TYpk+ZXbhsDlMF2Cur66I=;
        b=D5PpBX1OHJHYdtnqbYPiRyg6oXKCciSORhVRxlzgrxpclbDrldbP44+8P3T9lgLiSJjqU9
        cvbIfbTfrlDcK2T/AZU7/m+CJt1U2vW4Ga2LVkbnYejkqXWFm6uLEbmw7ZUUfjqBU4T72k
        H9iIZOpMv2lDCzcPV8eJ/BlI6gjJ0gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-qkwhmSKVOxCdczRXYPTPzQ-1; Mon, 07 Jun 2021 05:02:59 -0400
X-MC-Unique: qkwhmSKVOxCdczRXYPTPzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D305B107ACCA;
        Mon,  7 Jun 2021 09:02:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B8CA1037E88;
        Mon,  7 Jun 2021 09:02:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 8/8] KVM: x86: avoid loading PDPTRs after migration when possible
Date:   Mon,  7 Jun 2021 12:02:03 +0300
Message-Id: <20210607090203.133058-9-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
a part of the migration state and are correctly
restored by those ioctls.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 arch/x86/kvm/svm/nested.c       | 3 ++-
 arch/x86/kvm/vmx/nested.c       | 3 ++-
 arch/x86/kvm/x86.c              | 3 +++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83f948bdc59a..8eb107ceb45a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -851,6 +851,12 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+
+	/*
+	 * Set when PDPTS were loaded directly by the userspace without
+	 * reading the guest memory
+	 */
+	bool pdptrs_restored_oob;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e3e5775b8f1c..0f80d68a45e1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1369,7 +1369,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (WARN_ON(!is_guest_mode(vcpu)))
 		return true;
 
-	if (!nested_npt_enabled(svm) && is_pae_paging(vcpu))
+	if (!vcpu->arch.pdptrs_restored_oob &&
+	    !nested_npt_enabled(svm) && is_pae_paging(vcpu))
 		/*
 		 * Reload the guest's PDPTRs since after a migration
 		 * the guest CR3 might be restored prior to setting the nested
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0acdda85f36a..78d6c71ab03b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3113,7 +3113,8 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	u64 hpa;
 
-	if (!nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
+	if (!vcpu->arch.pdptrs_restored_oob &&
+	    !nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
 		/*
 		 * Reload the guest's PDPTRs since after a migration
 		 * the guest CR3 might be restored prior to setting the nested
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11260e83518f..eadfc9caf500 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -815,6 +815,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	vcpu->arch.pdptrs_restored_oob = false;
+
 out:
 
 	return ret;
@@ -10113,6 +10115,7 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 
 		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 		mmu_reset_needed = 1;
+		vcpu->arch.pdptrs_restored_oob = true;
 	}
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
-- 
2.26.3

