Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B37217AE
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjFDO2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjFDO2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:28:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4379D1B3;
        Sun,  4 Jun 2023 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685888894; x=1717424894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i02sIAR4vLVzsYL8kGeXSe6ihrYDcMMqEDivPNIfYZ0=;
  b=bqh57uhcSYlJDtIbPpTCzkePaX+UpRwfYNVcyhQxsx9qORZZ/QWX5UuY
   FEWd0ka3Y8ZvPa68qrblKlaye3MGwP9U7VRvvp1ZiSOjwQOHov/HCDhF1
   3rrnot36sikWGmg7eQ2k3NhpjIF0UElIa+n60RsRKW8aLbGC1Ma/qm9Pz
   c1+2/EcxUK7okPw2kkIHS+0Z0u6hd0l2t5LH5wBqmoI+INBebTE+e/uXX
   TO/7A2lj0stSaG7cd1RSqByJuIgQu1TvN9EmBW33MGPDA6RahTpOmMODr
   bVBjywzJkyXNtutW+04R5oi1O14doOFDgfrCoAlumq4YFfy0Qhel7uNeB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683426"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683426"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501014"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501014"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:08 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 03/20] x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
Date:   Mon,  5 Jun 2023 02:27:16 +1200
Message-Id: <cee2f2664aac3c5314896c6d14cba50f2617c0e5.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX capable platforms are locked to X2APIC mode and cannot fall back to
the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.

Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---

v10 -> v11:
 - Added David's Reviewed-by.

v9 -> v10:
 - No change.

v8 -> v9:
 - Added Dave's Reviewed-by.

v7 -> v8: (Dave)
 - Only make INTEL_TDX_HOST depend on X86_X2APIC but removed other code
 - Rewrote the changelog.

v6 -> v7:
 - Changed to use "Link" for the two lore links to get rid of checkpatch
   warning.

---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 191587f75810..f0f3f1a2c8e0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1957,6 +1957,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on X86_X2APIC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
-- 
2.40.1

