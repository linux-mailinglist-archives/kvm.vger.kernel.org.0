Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D279E193BF7
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgCZJfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:35:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:52518 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgCZJfZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585215324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=1O6NIR68kH3OijxL9QZfbmw0zgfeuNupKwN4iXBrHhI=;
        b=XXub59Q5F6+bhycvujtpvsev9h7INPdwSmYl8FzLkCDVnmmc6Ym+w5vVFunAdB7R1M3xuU
        dQ1zBacdCFonod0zBN3c3EUlXm4W4WzT60DMXdUQS7BzbW+t+XNSGQ5x0w7qB4JuE3MdR8
        lEmtUmZ6yQV3DU0l3JoN/q3xyL6ybXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-NOKHm7gRMPK9MB14xIIOdg-1; Thu, 26 Mar 2020 05:35:20 -0400
X-MC-Unique: NOKHm7gRMPK9MB14xIIOdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51F988010E8;
        Thu, 26 Mar 2020 09:35:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A82FB9CA3;
        Thu, 26 Mar 2020 09:35:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 2/3] KVM: x86: cleanup kvm_inject_emulated_page_fault
Date:   Thu, 26 Mar 2020 05:35:15 -0400
Message-Id: <20200326093516.24215-3-pbonzini@redhat.com>
In-Reply-To: <20200326093516.24215-1-pbonzini@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reconstruct the kvm_mmu to be used for page fault injection, we
can simply use fault->nested_page_fault.  This matches how
fault->nested_page_fault is assigned in the first place by
FNAME(walk_addr_generic).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 6 ------
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 arch/x86/kvm/x86.c             | 7 +++----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e26c9a583e75..6250e31ac617 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4353,12 +4353,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 	return kvm_read_cr3(vcpu);
 }
 
-static void inject_page_fault(struct kvm_vcpu *vcpu,
-			      struct x86_exception *fault)
-{
-	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
-}
-
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access, int *nr_present)
 {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1ddbfff64ccc..ae646acf6703 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -812,7 +812,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
 		if (!prefault)
-			inject_page_fault(vcpu, &walker.fault);
+			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64ed6e6e2b56..522905523bf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -614,12 +614,11 @@ EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
+	struct kvm_mmu *fault_mmu;
 	WARN_ON_ONCE(fault->vector != PF_VECTOR);
 
-	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
-		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
-	else
-		vcpu->arch.mmu->inject_page_fault(vcpu, fault);
+	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu : vcpu->arch.walk_mmu;
+	fault_mmu->inject_page_fault(vcpu, fault);
 
 	return fault->nested_page_fault;
 }
-- 
2.18.2


