Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13C3500750
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiDNHnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbiDNHmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 408DA5677F
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F1yCsxHZou/Mo1AiUvg/mXxT+ZuQee/RSzG0HIGGWL8=;
        b=RJTpJRqmJ9uyAYV5qReqJUIlpdVakpSHbjwM+2c7yQeaGUnW265uYHo02yR7KxpEUy0o9W
        RKOjvFj9W1259qdgXe9DmPmLZxGQNeoHBdlldX51sFalXOhl0Y8wHiGHEiIFa5QOo8+HBm
        cuT+zfHPj2tfTLl1HvLeai2DjE+F+s4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-UkSJX4qpPSy2PxcdlNNEbA-1; Thu, 14 Apr 2022 03:40:03 -0400
X-MC-Unique: UkSJX4qpPSy2PxcdlNNEbA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7CB2833973;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AEFE41D40E;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 09/22] KVM: x86/mmu: remove ept_ad field
Date:   Thu, 14 Apr 2022 03:39:47 -0400
Message-Id: <20220414074000.31438-10-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

In fact, now that the CPU mode is distinct from the MMU roles, it would
even be possible to remove PT_HAVE_ACCESSED_DIRTY macro altogether, and
use !mmu->cpu_role.base.ad_disabled instead.  I am not doing this because
the macro has a small effect in terms of dead code elimination:

   text	   data	    bss	    dec	    hex
 103544	  16665	    112	 120321	  1d601    # as of this patch
 103746	  16665	    112	 120523	  1d6cb    # without PT_HAVE_ACCESSED_DIRTY

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/mmu/mmu.c          | 1 -
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50edf52a3ef6..a299236cfde5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -442,7 +442,6 @@ struct kvm_mmu {
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
-	u8 ept_ad;
 	bool direct_map;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ba452df8e67..fddc8a3237b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4964,7 +4964,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->shadow_root_level = level;
 
-		context->ept_ad = accessed_dirty;
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 56544c542d05..298e502286cf 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -63,7 +63,7 @@
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
-	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
+	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
 	#ifdef CONFIG_X86_64
 	#define CMPXCHG "cmpxchgq"
 	#endif
-- 
2.31.1


