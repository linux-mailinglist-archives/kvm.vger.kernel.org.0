Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27276B644D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCLJyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCLJyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C746F38EA1
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614842; x=1710150842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dDHGRUiK7tSijYbXOTVKrsVFaPGmYiJcwgj+zHjSkaM=;
  b=VEVA/R7UF+vnjlJeD/w2/8wJPlxPFU3x6Xbh8pOs7gUSN/5Hkkt/fWzD
   Fb4m8pJfXVBX5nvBG2n9W41Ld9khqAbVFSSj4R5AmkYHn5zCB9cK3fImO
   G/PkrNPVAVMKBC29PDusoydq+BlkDS7G0ddlsSkbFAMAy5GXU9t8+VlXT
   e68qbBJxbO92XMCuovAFjMMGtyYWi8ytT989oRXBW4hfp1gi9dmopWYa/
   Vlk0gbqr93BYNk7iChifA5loaiXD1C/wcC13xRzyctIMfcx/PoVSjfP2t
   bGDJgRDh4RXz6b2HVvdiSyMLFSonQD8eO+U1hxLUyOWXwgCejw3W6injf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622830"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622830"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408914"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408914"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:57 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 4/5] pkvm: arm64: Make memory reservation arch agnostic
Date:   Mon, 13 Mar 2023 02:00:47 +0800
Message-Id: <20230312180048.1778187-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not use arm specific kvm_nvhe_sym, expose a new definition pkvm_sym
for this usage.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 arch/arm64/kvm/pkvm.c             | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 2cc283feb97d..b508c7b63ff4 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,8 @@
 
 #define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
 
+#define pkvm_sym kvm_nvhe_sym
+
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf56958b1492..e787bd704043 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -13,8 +13,8 @@
 
 #include "hyp_constants.h"
 
-static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
-static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
+static struct memblock_region *hyp_memory = pkvm_sym(hyp_memory);
+static unsigned int *hyp_memblock_nr_ptr = &pkvm_sym(hyp_memblock_nr);
 
 phys_addr_t hyp_mem_base;
 phys_addr_t hyp_mem_size;
-- 
2.25.1

