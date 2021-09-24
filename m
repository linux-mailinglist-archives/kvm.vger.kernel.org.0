Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB5417898
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347521AbhIXQdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347427AbhIXQdd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hKtVvc1lFdOTkOSXhibZgANdE057zg8675JgWwxhngo=;
        b=SLmlZOY+CSx0zH52POXb6A1br+eRT7I+r4CrHayK9JyeE8/bzfQNV6CPDTcklLD82PyaJK
        lWeqIWIE8ghQlhNgWSbIdAD5JRrSUTi6nWbTRt6MKoqmQeJqgAPSinWWkQWc40j174/Bl1
        vE7wm6asiOz4kT4uoA3CT3QYrycN0Pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-fNJxlz5eM8-e4vDL8ooYwA-1; Fri, 24 Sep 2021 12:31:58 -0400
X-MC-Unique: fNJxlz5eM8-e4vDL8ooYwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72F2F802947;
        Fri, 24 Sep 2021 16:31:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0276D60E1C;
        Fri, 24 Sep 2021 16:31:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 07/31] KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:28 -0400
Message-Id: <20210924163152.289027-8-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to handle_abnormal_pfn() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 18 +++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c2d2d019634b..6821d05c0557 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3060,18 +3060,19 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
-static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-				kvm_pfn_t pfn, unsigned int access,
-				int *ret_val)
+static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+				unsigned int access, int *ret_val)
 {
 	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(pfn))) {
-		*ret_val = kvm_handle_bad_page(vcpu, gfn, pfn);
+	if (unlikely(is_error_pfn(fault->pfn))) {
+		*ret_val = kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
 		return true;
 	}
 
-	if (unlikely(is_noslot_pfn(pfn))) {
-		vcpu_cache_mmio_info(vcpu, gva, gfn,
+	if (unlikely(is_noslot_pfn(fault->pfn))) {
+		gva_t gva = fault->is_tdp ? 0 : fault->addr;
+
+		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 				     access & shadow_mmio_access_mask);
 		/*
 		 * If MMIO caching is disabled, emulate immediately without
@@ -3975,8 +3976,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (kvm_faultin_pfn(vcpu, fault, &r))
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa,
-				fault->gfn, fault->pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, fault, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 72f0b415be63..0fa7a678b907 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -893,7 +893,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (kvm_faultin_pfn(vcpu, fault, &r))
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, fault->pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, fault, walker.pte_access, &r))
 		return r;
 
 	/*
-- 
2.27.0


