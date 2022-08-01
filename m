Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E8B586862
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 13:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHALpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 07:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiHALp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 07:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9873DE91
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 04:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659354327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/M4Donr8YfwNuyCnZRmV/3XmMExqO8BbX6uoQN7f69Q=;
        b=KUjrcDbUSG573XE5uP1DMBuOdAgOq8pSOU4aVL23UoapakfX3Rja0u7hLih9DKlb2FX/A+
        9D0q1Usu5lgxHJoMa9fxlyGfQtQUdU2QgBadcVY50bm8KULePFHebcD+MuvDGpsqOLwPeC
        HRuyqV2CQBCb2ZbWwW3ndNslsALuQqU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-CILmFWJ2MMqjT-ha8Fmd0w-1; Mon, 01 Aug 2022 07:45:24 -0400
X-MC-Unique: CILmFWJ2MMqjT-ha8Fmd0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 558EE85A587;
        Mon,  1 Aug 2022 11:45:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DDA840CFD0A;
        Mon,  1 Aug 2022 11:45:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: remove unused variable
Date:   Mon,  1 Aug 2022 07:45:24 -0400
Message-Id: <20220801114524.1249307-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last use of 'pfn' went away with the same-named argument to
host_pfn_mapping_level; now that the hugepage level is obtained
exclusively from the host page tables, kvm_mmu_zap_collapsible_spte
does not need to know host pfns at all.

Fixes: a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e1317325e1f..4236a28b9be5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6416,13 +6416,11 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	u64 *sptep;
 	struct rmap_iterator iter;
 	int need_tlb_flush = 0;
-	kvm_pfn_t pfn;
 	struct kvm_mmu_page *sp;
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		sp = sptep_to_sp(sptep);
-		pfn = spte_to_pfn(*sptep);
 
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
-- 
2.31.1

