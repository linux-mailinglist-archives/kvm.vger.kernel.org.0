Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382687142D8
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjE2EZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjE2EYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:24:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB371737;
        Sun, 28 May 2023 21:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334154; x=1716870154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QSJUl/UEPqdnzZy+hiBrlByUnOkcTkL1Gi8Agd/4FZY=;
  b=VPIZ807MeA2MvMgSQZHjtXeE1sgDXm600fL275gbkNG1zY1l5W+Ze2t/
   4vmQIHyf1zDVX/VvPnhNRdsxv6WXD4xqsZbBhBdc9DKtDM+fD5er0cC6i
   J9M6YYwBOBYMWipchwk1tVnQvG+6Nss2oltkyfyZNwQwQML2OkEHSg421
   0wnyFuQbURGhlmOvj/CR/gl4FYjZs8kqJWtk7LPeotp87QHZCUEA1EBH1
   7MF8YljGPlNcSob21GJr7ATEzcIoKkxtZA3/atAVTw4lTdevwqIY6oM8i
   nrNmJTGS461YQWC8XZzeShYmK+cDj9UEdKd6SjMclTH4WQZf/g4Lettm0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334965944"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334965944"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784256"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784256"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v14 039/113] KVM: x86/mmu: Assume guest MMIOs are shared
Date:   Sun, 28 May 2023 21:19:21 -0700
Message-Id: <d70cedd8bcb806f6c4e31db5944f5c07467f63fe.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

Guest TD doesn't necessarily invoke MAP_GPA to convert the virtual MMIO
range to shared before accessing it.  When TD tries to access the virtual
device's MMIO as shared, an EPT violation is raised first.
kvm_mem_is_private() checks whether the GFN is shared or private.  If
MAP_GPA is not called for the GPA, KVM thinks the GPA is private and
refuses shared access, and doesn't set up shared EPT entry.  The guest
can't make progress.

Instead of requiring the guest to invoke MAP_GPA for regions of virtual
MMIOs assume regions of virtual MMIOs are shared in KVM as well (i.e., GPAs
either have no kvm_memory_slot or are backed by host MMIOs). So that guests
can access those MMIO regions.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 544df394b085..a7bf0cecabc2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4395,7 +4395,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
+	/*
+	 * !fault->slot means MMIO.  Don't require explicit GPA conversion for
+	 * MMIO because MMIO is assigned at the boot time.
+	 */
+	if (fault->slot &&
+	    fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
 		return kvm_do_memory_fault_exit(vcpu, fault);
 
 	if (fault->is_private)
-- 
2.25.1

