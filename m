Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E6979ED52
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjIMPjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjIMPjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:39:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE461990;
        Wed, 13 Sep 2023 08:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619590; x=1726155590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5G4LZtX+xtUtiEksO1ZLXcffbaNjfwIFR6ugBwICZdo=;
  b=ZIWbioSOKqbsWPHNz6O/6JpFgsTdtDZy3ADmSzgPochQx6OcRUmf89Tn
   25lClTCDj//XgFzFFbbanhNcaQNlx8N7viCLQ6jOqe51Sqcsp+v3/lmk0
   n/z8IdGtTJdoVF0BTdZN50qCcfIVNKEAiuB6eGwiDzH7E3x45RXlyAJdo
   IfdKV57HJvTKygthX/mtajc7uIpMG5ish0kWwalyXrXLnzTsPsUrisrxi
   RgodatiSz5ScIb1j81vQLRbG3pD6H0GKyUwiot27inVrxu4lleKgdptuG
   jd5ACLB7PxOQYJdyrtMCdD7RNQgKD2hNiZZYoF4ShuWSM1Mu7UrHLLEKo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030146"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030146"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852048"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852048"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:46 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 03/16] KVM: x86: Add an emulation flag for implicit system access
Date:   Wed, 13 Sep 2023 20:42:14 +0800
Message-Id: <20230913124227.12574-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an emulation flag X86EMUL_F_IMPLICIT to identify implicit system access
in instruction emulation.

Linear Address Space Separation (LASS) treats data access a supervisor-mode
access if it implicitly accessed a system data structure. The flag will be
consumed to support LASS virtualization.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/kvm_emulate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index e1fd83908334..5f9869018332 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -92,6 +92,7 @@ struct x86_instruction_info {
 #define X86EMUL_F_WRITE			BIT(0)
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_BRANCH		BIT(2)
+#define X86EMUL_F_IMPLICIT		BIT(3)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.25.1

