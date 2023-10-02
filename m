Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D87B4CDD
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbjJBHw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 03:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbjJBHwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 03:52:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59994C6
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 00:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696233171; x=1727769171;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pSWoR1MlRMPnZFuNIN0WY2ctP+02pePH9fE5cmYxCCE=;
  b=DPrVq70xLaEfHgwesgSScPn06ym9ixku9FWONk1mBLsRlVp5eqwuy+dy
   u8/EpXCFDqLRCHs87HZzPLxl6WFPbNNsnriTluS1bRj6xzvp8Lf1SrOWh
   705Bax/38xSdciw4u6eoRwp2aRyhDsgwWfX1Ir9dWodgD0j/rg6a4gEao
   P2SU1kdvRwLGLD7vPVtQAk6xHseUnjJfrzyzDp8b0F8W8Wk/Cymuv0yVm
   fiUilwjjEZUkcOFp4oHATpWTWkYfHel1sOtKyL2hT6SFS9uSqL4xXozrA
   uAtGKHu3YHSibMRei6QUCx2qmgjjM+XXJupChBN88BJ/ih5rvrGG8GfMX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="361975552"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="361975552"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 00:52:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="750511621"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="750511621"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 02 Oct 2023 00:52:48 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, richard.henderson@linaro.org,
        pbonzini@redhat.com, eduardo@habkost.net, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH v2 0/4] target/i386: add support for FRED
Date:   Mon,  2 Oct 2023 00:23:09 -0700
Message-Id: <20231002072313.17603-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set adds support for the Intel flexible return and event delivery
(FRED) architecture to allow Qemu to run KVM guests with FRED enabled.

The FRED architecture defines simple new transitions that change privilege
level (ring transitions). The FRED architecture was designed with the
following goals:
1) Improve overall performance and response time by replacing event delivery
   through the interrupt descriptor table (IDT event delivery) and event
   return by the IRET instruction with lower latency transitions.
2) Improve software robustness by ensuring that event delivery establishes
   the full supervisor context and that event return establishes the full
   user context.

Search for the latest FRED spec in most search engines with this search pattern:

  site:intel.com FRED (flexible return and event delivery) specification


---
Changelog
v2:
- Add VMX nested-exception support to scripts/kvm/vmxcap (Paolo Bonzini).
- Move FRED MSRs from basic x86_cpu part to .subsections part (Weijiang Yang).


Xin Li (4):
  target/i386: add support for FRED in CPUID enumeration
  target/i386: mark CR4.FRED not reserved
  target/i386: enumerate VMX nested-exception support
  target/i386: Add get/set/migrate support for FRED MSRs

 scripts/kvm/vmxcap    |  1 +
 target/i386/cpu.c     |  7 +++++-
 target/i386/cpu.h     | 43 +++++++++++++++++++++++++++++++++-
 target/i386/kvm/kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 29 +++++++++++++++++++++++
 5 files changed, 132 insertions(+), 2 deletions(-)

-- 
2.34.1

