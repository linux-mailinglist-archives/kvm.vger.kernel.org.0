Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9704A98AF
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358710AbiBDL5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358577AbiBDL5b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KpW0MeScL9+nni+CpA1MY2/RDHQVdxcrB5fLNku5iQQ=;
        b=HWfj79+ql/SPlTZjsWRwSoBZ6+dW/BuvULB5ShDpXfZx1iAvZ4DN9NbV9+gr2psPbmYCNO
        7YXNua2lJ+eRPMihJBunWv3p/YnrtfHli7kGUjOG7BU2+4+iMG93Hh52JBnT/jE4eZ/wAs
        gv20yGaXpEI0TrYR66LNsQzS4rEwRL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-klwgJG1wOd2VnCfCSUvipg-1; Fri, 04 Feb 2022 06:57:27 -0500
X-MC-Unique: klwgJG1wOd2VnCfCSUvipg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58E83190B2A1;
        Fri,  4 Feb 2022 11:57:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEFA46E202;
        Fri,  4 Feb 2022 11:57:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 12/23] KVM: MMU: remove ept_ad field
Date:   Fri,  4 Feb 2022 06:57:07 -0500
Message-Id: <20220204115718.14934-13-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The similar field in the CPU role, ad_disabled, is initialized to the
opposite value for shadow EPT, and left zero for "normal" EPT because
guest page tables always have A/D bits.  So, read it from the CPU role,
like other page-format fields; it just has to be inverted to account
for the different polarity.

In the MMU role, instead, the ad_disabled bit is set according to
shadow_accessed_mask, so it would have been incorrect to replace
PT_HAVE_ACCESSED_DIRTY with just !mmu->mmu_role.base.ad_disabled.
However, with the separation of CPU and MMU roles, we might even get
rid of the PT_HAVE_ACCESSED_DIRTY macro altogether.  I am not doing this
because the macro has a small effect in terms of dead code elimination:

   text	   data	    bss	    dec	    hex
 103544	  16665	    112	 120321	  1d601    # as of this patch
 103746	  16665	    112	 120523	  1d6cb    # without PT_HAVE_ACCESSED_DIRTY

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/mmu/mmu.c          | 1 -
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 427ee486309c..795b345361c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -436,7 +436,6 @@ struct kvm_mmu {
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
-	u8 ept_ad;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74789295f922..d6b5d8c1c0dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4915,7 +4915,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->shadow_root_level = level;
 
-		context->ept_ad = accessed_dirty;
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b9f472f27077..1b5c7d03f94b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -64,7 +64,7 @@
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
-	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
+	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
 	#define CMPXCHG cmpxchg64
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
-- 
2.31.1


