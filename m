Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E03E84B6
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhHJUxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234104AbhHJUxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKaEmBat6yvfB4xPadJo0vdiW2waCpjsdVZqI4Pwgdc=;
        b=J405TZv+TzXLG/MAJeBAPZUelhjGa7KOuFluKOKuKm07creGVYe/aDayKc5vzMZC/95O9p
        /xVz6pa1wtyfWAAE+Zwq8y6l/kmqnoYL1aF0IzHseCvowddspqW6U9O6iLE03MFE0nQ0Tk
        iTHAcL2Q/1H76GnuHWIXqqElFkar05s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-R1OUoqqbOFORwPnpguj8Hg-1; Tue, 10 Aug 2021 16:53:21 -0400
X-MC-Unique: R1OUoqqbOFORwPnpguj8Hg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E6001853026;
        Tue, 10 Aug 2021 20:53:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F134569CBA;
        Tue, 10 Aug 2021 20:53:15 +0000 (UTC)
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
Subject: [PATCH v4 05/16] KVM: x86/mmu: rename try_async_pf to kvm_faultin_pfn
Date:   Tue, 10 Aug 2021 23:52:40 +0300
Message-Id: <20210810205251.424103-6-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

try_async_pf is a wrong name for this function, since this code
is used when asynchronous page fault is not enabled as well.

This code is based on a patch from Sean Christopherson:
https://lkml.org/lkml/2021/7/19/2970

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index abaf8e661c61..15a396af75e7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3858,7 +3858,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
+static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
 			 bool write, bool *writable)
 {
@@ -3928,7 +3928,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
+	if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva,
 			 write, &map_writable))
 		return RET_PF_RETRY;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ee044d357b5f..f349eae69bf3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -881,7 +881,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
+	if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
 			 write_fault, &map_writable))
 		return RET_PF_RETRY;
 
-- 
2.26.3

