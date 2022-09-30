Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B55F0878
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiI3KU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiI3KTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B815ED1E;
        Fri, 30 Sep 2022 03:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533140; x=1696069140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ofl4tu1tk6jjezt6ZEuGxsaoew3+Xuq9m3NoTHM2FO8=;
  b=eDNBDfd2r5gSu3o3RF2CoKUih9VIktLGECcZh4ZC6GWkFUyuSd5wOBIs
   3TRa0ruOuy5Iu2+l/a5+WTKJOpremx6k1yiF9p8Q1KH0lu2mSWmp1Cmyy
   xWtv7Dc90DIA8khkdz+sDAbbzTI8mKqvIWs+TIQLy/yM45WMNVfOsJOwU
   EqhxVOK2We65lSZydxcfq6TtQloEmze7gljB12hNJXM0D+ZAwnP50ZlUB
   Jfk7RMyFOpWM9tQlerRyWtYguHdVY1CkGyckXFUovdiek3YIHE2rKe4NM
   7WyQMWEuK3vBv27JiCqSkFnPTmI5FoDnuqNvcLowKGD77h0JrgRTsFwGv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870082"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870082"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807589"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807589"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 027/105] KVM: x86/mmu: introduce config for PRIVATE KVM MMU
Date:   Fri, 30 Sep 2022 03:17:21 -0700
Message-Id: <b9556ed61ea2d79dec4e4878266fb2190186fca5.1664530907.git.isaku.yamahata@intel.com>
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

To keep the case of non TDX intact, introduce a new config option for
private KVM MMU support.  At the moment, this is synonym for
CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The config makes it clear
that the config is only for x86 KVM MMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 25a24909375d..350a921b15cb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -131,4 +131,8 @@ config KVM_XEN
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config KVM_MMU_PRIVATE
+	def_bool y
+	depends on INTEL_TDX_HOST && KVM_INTEL
+
 endif # VIRTUALIZATION
-- 
2.25.1

