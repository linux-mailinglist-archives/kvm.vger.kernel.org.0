Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2022C4CC627
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiCCTj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiCCTjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A402188A10
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0fNhrnmYSSzM2kO4HqFimg6xN8a7RrrkG6VQ9M4m2J4=;
        b=FBq3Ttxiw9TzNoYBhhBnguW/0DJIVC2g1rhjEvAnTQ4JgDlPbmZ4J95sFRCecamVXzEwZ4
        uo6asx6oWPC0tO6ykXcFK9YWcvco7hYGTDQlBLbkxfdyhmZ/bOd8dCzRagdDUrW4Thfx1R
        IWyaKNSWk/jfkgJZegQaCEb4Yd8OuUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-CLLFXx--OqCLUJtZ5ZbWdw-1; Thu, 03 Mar 2022 14:38:54 -0500
X-MC-Unique: CLLFXx--OqCLUJtZ5ZbWdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 087FC824FA8;
        Thu,  3 Mar 2022 19:38:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 362AF5DF2E;
        Thu,  3 Mar 2022 19:38:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 09/30] KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier change_spte
Date:   Thu,  3 Mar 2022 14:38:21 -0500
Message-Id: <20220303193842.370645-10-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Batch TLB flushes (with other MMUs) when handling ->change_spte()
notifications in the TDP MMU.  The MMU notifier path in question doesn't
allow yielding and correcty flushes before dropping mmu_lock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-9-seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 53c7987198b7..9b1d64468d95 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1226,13 +1226,12 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
  */
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush = kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
-
-	/* FIXME: return 'flush' instead of flushing here. */
-	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, range->start, 1);
-
-	return false;
+	/*
+	 * No need to handle the remote TLB flush under RCU protection, the
+	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
+	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 */
+	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 }
 
 /*
-- 
2.31.1


