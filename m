Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91B33E35AA
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhHGNuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232398AbhHGNuG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oiDa+gBQyTuYgDJ+6BwPsCllNWskN1s5qS6Xuu490MM=;
        b=Maootbh0LNqdEo40D4a8DaDTcV6UJsWBIm2aOL+uH5/9qIXYFJU6jELM9PbNcXH+ykAf2G
        stJ5tPEa2Ct3lBL7gr6FZeAVVL/RaycfOwrfvSjW+Ye1hL790B8AK7VQAzqmDVibbS4dM7
        k6Hma/gFC/CF0w3bMqzVS6MiXT9c610=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-X1nn9FmaO3KUzAjegILKVA-1; Sat, 07 Aug 2021 09:49:48 -0400
X-MC-Unique: X1nn9FmaO3KUzAjegILKVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22710107465F;
        Sat,  7 Aug 2021 13:49:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9655727CAA;
        Sat,  7 Aug 2021 13:49:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 08/16] KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:28 -0400
Message-Id: <20210807134936.3083984-9-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to handle_abnormal_pfn() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a6366f1c4197..cec59ac2e1cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3024,18 +3024,18 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
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
+		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 				     access & shadow_mmio_access_mask);
 		/*
 		 * If MMIO caching is disabled, emulate immediately without
@@ -3904,8 +3904,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (try_async_pf(vcpu, fault))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa,
-	                        fault->gfn, fault->pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, fault, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6ead472674ad..9b90097dea22 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -882,7 +882,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (try_async_pf(vcpu, fault))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, fault->pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, fault, walker.pte_access, &r))
 		return r;
 
 	/*
-- 
2.27.0


