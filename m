Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21E3790FA4
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 03:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350342AbjIDBgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 21:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350278AbjIDBgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 21:36:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0811BF2
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 18:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693791362; x=1725327362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RoFlc4JBC10OMuq/moZm50NnjJ1GpnDjtaFUFC+K/N8=;
  b=Qbusm095FOmnf0H6f8ANlsXRDQh57pALa3xBrMawSK7RJpKCeSRDGjxV
   qtKEg+hfq/8ff20g9iZm1t6RgJFV2KGyFvDVMgBsVXZIRycLCA7ziDlVu
   8DUtDxRhBXVvK2bxkbQHCTtj01GmsPME3fDv8zVV/StjDMuTrItCb91BN
   U3sZWxoVxbjit6NFGGeTyeE70IWmXWsxNgQfSpFaKKa38XAsA6JjvsP+0
   XiqtiXDJBGJfy/P7VSaD0JgFv4XgjYkB95IuFEkd8/XbN1vd+m2fDrP12
   IJqiQ0XV3WEM38Y3FAheRB/sYTWPX8pxnoIlloCiOKrAYsKLCvEOsF6ei
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="407493240"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="407493240"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 18:36:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="743764797"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="743764797"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2023 18:35:59 -0700
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com, tao1.su@linux.intel.com
Subject: [PATCH 1/2] x86/apic: Introduce X2APIC_ICR_UNUSED_12 for x2APIC mode
Date:   Mon,  4 Sep 2023 09:35:54 +0800
Message-Id: <20230904013555.725413-2-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904013555.725413-1-tao1.su@linux.intel.com>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to SDM, bit12 of ICR is no longer BUSY bit but UNUSED bit in
x2APIC mode, which is the only difference of lower ICR between xAPIC and
x2APIC mode. To avoid ambiguity, introduce X2APIC_ICR_UNUSED_12 for
x2APIC mode.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/include/asm/apicdef.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 4b125e5b3187..ea2725738b81 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -78,6 +78,7 @@
 #define		APIC_INT_LEVELTRIG	0x08000
 #define		APIC_INT_ASSERT		0x04000
 #define		APIC_ICR_BUSY		0x01000
+#define		X2APIC_ICR_UNUSED_12	0x01000
 #define		APIC_DEST_LOGICAL	0x00800
 #define		APIC_DEST_PHYSICAL	0x00000
 #define		APIC_DM_FIXED		0x00000
-- 
2.34.1

