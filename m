Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5187A6B692D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjCLR7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCLR7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1F424722;
        Sun, 12 Mar 2023 10:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643887; x=1710179887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKFZMPzjQHh9fqhhO6SF0CKnH5bQaAqjiRvXpGYFYv0=;
  b=KXq+ulMCwMsA5GSQEAjjMgYfJ1uDaskpMPjwzHE6lCK7+yWeZ/Xy9UB0
   64emr9L8i5TTvjGYSvLb6mrOocMhy/leChRu4pCtixysTAgtcJnnhNaSO
   KD6jR1VIZvuG4so3ejSpmjkqxAqk+4WfC5W1VJiXaKowzxmEdLwCILtTk
   XdOpEv4ye1+L5PWu7hXvrJx7rCGUNCXh3Im9Q1GwfZx+iMdtmVll8bDRB
   K0OPARFeGEWnCmnh6WNbwb4MyCqw3y1mc1XlOwWkVe2InUK1FRNBKjAV9
   XQJ5AXN5Dj2VlqQNbgxjSXEyAKrkK5z29ml9De61RI5QzEXyEmhVKxwbe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659853"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659853"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="821690193"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="821690193"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:03 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v13 039/113] KVM: x86/mmu: Assume guest MMIOs are shared
Date:   Sun, 12 Mar 2023 10:56:03 -0700
Message-Id: <80912a430d4642acf85c454e97c8320f96e4b737.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

Current TD guest doesn't invoke MAP_GPA to convert MMIO range to shared
before accessing it. It implies that current TD guest assumes MMIOs are
shared.

When TD tries to access assigned device's MMIO as shared, an EPT violation
is raised first. kvm_mem_is_private() checks the page shared or private
attribute against the access type (shared bit in GPA). Then since no
MAP_GPA is called for the MMIO, KVM thinks the MMIO is private and refuses
shared access and doesn't set up shared EPT. Then KVM returns to TD and TD
just retries and this causes an infinite loop.

Instead of requiring guest to invoke MAP_GPA for MMIOs, assume guest MMIOs
are shared in KVM as well and don't expect explicit calls of MAP_GAP for
guest MMIOs (i.e., GPAs either have no kvm_memory_slot or are backed by
host MMIOs). So, allow shared access to guest MMIOs and move the page type
check after the corresponding pfn is available.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5883ab95ff07..ce8a896a3cfa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4314,7 +4314,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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

