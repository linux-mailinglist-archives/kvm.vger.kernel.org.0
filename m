Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B051D38D6
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgENSGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:06:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727043AbgENSGG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 14:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589479564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZKjM3Ix3SA/SQ1fKkAtOWLDUKvHo8Ot55M+IlaCYbA=;
        b=D5PpJJpYr3ro/igDpj+C7C1TalucugmzCjqVszkkDHby72E+QT6Q9tLMZ3qeH+RM6fpgZL
        CtCxxZqbF6xytp5Mb5jmblLjoOWpFrZM0x1+dVcltZ/E8VSelVKvBdsqvr55ItufLvK+Qd
        2k5mZxvyo2eu6nSN1zZJAXnI8bhGiLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-qcLT1wIoNoupndlf5A0UoA-1; Thu, 14 May 2020 14:06:03 -0400
X-MC-Unique: qcLT1wIoNoupndlf5A0UoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96EC0107ACF3;
        Thu, 14 May 2020 18:06:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A2785D9CA;
        Thu, 14 May 2020 18:05:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: [PATCH RFC 4/5] KVM: x86: aggressively map PTEs in KVM_MEM_ALLONES slots
Date:   Thu, 14 May 2020 20:05:39 +0200
Message-Id: <20200514180540.52407-5-vkuznets@redhat.com>
In-Reply-To: <20200514180540.52407-1-vkuznets@redhat.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All PTEs in KVM_MEM_ALLONES slots point to the same read-only page
in KVM so instead of mapping each page upon first access we can map
everything aggressively.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 20 ++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h | 23 +++++++++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3db499df2dfc..e92ca9ed3ff5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4154,8 +4154,24 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
-			 prefault, is_tdp && lpage_disallowed);
+
+	if (likely(!(slot->flags & KVM_MEM_ALLONES) || write)) {
+		r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
+				 prefault, is_tdp && lpage_disallowed);
+	} else {
+		/*
+		 * KVM_MEM_ALLONES are 4k only slots fully mapped to the same
+		 * readonly 'allones' page, map all PTEs aggressively here.
+		 */
+		for (gfn = slot->base_gfn; gfn < slot->base_gfn + slot->npages;
+		     gfn++) {
+			r = __direct_map(vcpu, gfn << PAGE_SHIFT, write,
+					 map_writable, max_level, pfn, prefault,
+					 is_tdp && lpage_disallowed);
+			if (r)
+				break;
+		}
+	}
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 98e368788e8b..7bf0c48b858f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -789,6 +789,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
 				is_nx_huge_page_enabled();
 	int max_level;
+	gfn_t gfn;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
@@ -873,8 +874,26 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, write_fault, max_level, pfn,
-			 map_writable, prefault, lpage_disallowed);
+	if (likely(!(slot->flags & KVM_MEM_ALLONES) || write_fault)) {
+		r = FNAME(fetch)(vcpu, addr, &walker, write_fault, max_level,
+				 pfn, map_writable, prefault, lpage_disallowed);
+	} else {
+		/*
+		 * KVM_MEM_ALLONES are 4k only slots fully mapped to the same
+		 * readonly 'allones' page, map all PTEs aggressively here.
+		 */
+		for (gfn = slot->base_gfn; gfn < slot->base_gfn + slot->npages;
+		     gfn++) {
+			walker.gfn = gfn;
+			r = FNAME(fetch)(vcpu, gfn << PAGE_SHIFT, &walker,
+					 write_fault, max_level, pfn,
+					 map_writable, prefault,
+					 lpage_disallowed);
+			if (r)
+				break;
+		}
+	}
+
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.25.4

