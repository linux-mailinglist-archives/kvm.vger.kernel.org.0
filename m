Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8805D6127D4
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJ3GY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJ3GYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170F610A;
        Sat, 29 Oct 2022 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111048; x=1698647048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NRy7ZqKX91pWNXtRhcY8rjR1ap8KYHXHj+9Nb/db+28=;
  b=kQ0dttyudbN8Ld5PhggJCy1rtRbVqqDVsRB2xeUXpqyxIgoZNTOsbbdc
   bnC0iRsvqA77cCWKyxokXKubLB7P738Cg/yC7spRjx0KblNTNaAMuTN8m
   EnWujYbK2Epp/U6mXj6n7Ag2dJO7F+u1ym+uUQlqx9LbTgikdN4rdXqfk
   JlTlQV4qpKePYna2M4LxalAdwe7YWyseec+ENeZdKjEby0BeYxW7oC9BF
   oJjxI7/Vlp1hTU+fp/HPmy3kalMeUpUsWPiGFrg8lXn1LUwvZ8iEu1409
   IS2AUhV5JJ39X1ua6nVKQ8gzC/KridXPyp5KVILGC0ra5z7oLelaxN4kt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037144"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037144"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392948"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392948"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 032/108] KVM: x86/mmu: Make sync_page not use hard-coded 0 as the initial SPTE value
Date:   Sat, 29 Oct 2022 23:22:33 -0700
Message-Id: <adcc3484605cb460a0c00ee5673c83f32a88e6ca.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

FNAME(sync_page) in arch/x86/kvm/mmu/paging_tmpl.h assumes that the initial
shadow page table entry (SPTE) is zero.  Remove the assumption by using
SHADOW_NONPRESENT_VALUE that will be updated from 0 to non-zero value.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5ab5f94dcb6f..6db3f2b5563a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1036,7 +1036,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		/* spt[i] has initial value of shadow page table allocation */
+		if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
-- 
2.25.1

