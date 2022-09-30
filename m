Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2875F087E
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiI3KUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiI3KTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAE915348B;
        Fri, 30 Sep 2022 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533141; x=1696069141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fKKqQjm5zfL/HnoTp2AqWyipBAMJR5631mTIwmgWhU8=;
  b=Ef2VwB7btbQ1w2tdap38oieQAHDnMmwCXfTFWVnNxxkvNLOtHepF0Zmx
   t7VtYI43VGtJQjX8QAxDje9GDKGkIIWWHguS/P5dV2fYcYbsMFfUAxJ/H
   kvV8+2BpQ1FQqeUABddzUFCIIOk8gRAui02F9cWOiW6+3AjXYJnnZYw+F
   OmW1MWIwGXLoguHG3LovMrsBgf7nML1mtxDL+uteGBzFVpmpPNjuidcYa
   hS4kECcZSbM4+ktKB2rCFTXkujsqWAcCvlUUy1f4FdjUgP5twss8mGmCl
   BEfhG1KtMqJsytlgPUoUya84EFJ1KP33WUVEnoHNCt6H5OUy4m84nuIVC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870086"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870086"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807603"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807603"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 031/105] KVM: x86/mmu: Make sync_page not use hard-coded 0 as the initial SPTE value
Date:   Fri, 30 Sep 2022 03:17:25 -0700
Message-Id: <79ca03ac97aa28df839f8818a4486407bc71c605.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 39e0205e7300..4586de2cfe57 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1036,7 +1036,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		/* spt[i] has initial value of shadow page table allocation */
+		if (sp->spt[i] != SHADOW_NONPRESENT_VALUE)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
-- 
2.25.1

