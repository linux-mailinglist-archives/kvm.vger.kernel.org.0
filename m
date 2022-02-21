Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DA14BE645
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380311AbiBUQXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380191AbiBUQXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9BA327150
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1Gf8VtNAt2/Qxfp7otaTjlAdjKtIcomYYyTzHKIFnw=;
        b=NYIPySNXY9e2SYho5xWMahCXYvLxLW7EQTpj6o0iWd8oBglHopBf6dJVCS+ZGdwTC6Fhbu
        xW4/oWUBocnw+TmVlzqd3iPCBrl+XAnR743/QAy9BqCV56OdJiw9XQ35mtKRMKHcFglOWQ
        Lpwj1uzENUUwAAr9ZonEWz01yEb4MG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-K4zjalEVNS6oGDkj65wlmw-1; Mon, 21 Feb 2022 11:22:50 -0500
X-MC-Unique: K4zjalEVNS6oGDkj65wlmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 755512F4B;
        Mon, 21 Feb 2022 16:22:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16A5578AA5;
        Mon, 21 Feb 2022 16:22:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 10/25] KVM: x86/mmu: remove ept_ad field
Date:   Mon, 21 Feb 2022 11:22:28 -0500
Message-Id: <20220221162243.683208-11-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ept_ad field is used during page walk to determine if the guest PTEs
have accessed and dirty bits.  In the MMU role, the ad_disabled
bit represents whether the *shadow* PTEs have the bits, so it
would be incorrect to replace PT_HAVE_ACCESSED_DIRTY with just
!mmu->mmu_role.base.ad_disabled.

However, the similar field in the CPU mode, ad_disabled, is initialized
correctly: to the opposite value of ept_ad for shadow EPT, and zero
for non-EPT guest paging modes (which always have A/D bits).  It is
therefore possible to compute PT_HAVE_ACCESSED_DIRTY from the CPU mode,
like other page-format fields; it just has to be inverted to account
for the different polarity.

Having a CPU mode that is distinct from the MMU roles in fact would even
allow to remove PT_HAVE_ACCESSED_DIRTY macro altogether, and always use
!mmu->cpu_mode.base.ad_disabled.  I am not doing this because the macro
has a small effect in terms of dead code elimination:

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
index cc268116eb3f..996cf9b14f5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -437,7 +437,6 @@ struct kvm_mmu {
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
-	u8 ept_ad;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e539fc2c9c7..3ffa6f2bf991 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4936,7 +4936,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->shadow_root_level = level;
 
-		context->ept_ad = accessed_dirty;
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e1c2ecb4ddee..64b6f76641f0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -64,7 +64,7 @@
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
-	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
+	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_mode.base.ad_disabled)
 	#define CMPXCHG cmpxchg64
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
-- 
2.31.1


