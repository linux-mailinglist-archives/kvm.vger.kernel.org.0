Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1895678F83E
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbjIAF7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 01:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348294AbjIAF7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 01:59:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFF310C0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693547967; x=1725083967;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t/hrJiHeoSvdETUBrJ57ogpn4shS4G0J8qmn4d9YVVs=;
  b=mPAvrH3EXIQLh9qDKtmrrxPKOqVy4bYi+SDSbjCvEAJ/6jzZgtOC5BJU
   04ew5+9uSl/4DIQuUZgoTjyOOwrZM0TZ0V+q9FZ3z509+fUwXrrmHQfFw
   dw4OL1NBPaSFEvYm3NxbWUPxklvNHvaSUa15IfQxEY6NznB8XgHI741+0
   lkxeBRHVPCyfihVhLdIFYHHkHRZnk3X90MY4SsstGptUoc/sxKq0nBDWt
   BO8tPD68LwGWjpo8JNMuMuF4/88OyQZ/YmDXpRZFy+fiTndfV3R4V7xvi
   WNKGwkEDDD5I5R1jR3Bhrg5EbtAgzlyMEOHqVbWToQ8O31ByrsITIgf2v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="356456630"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="356456630"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 22:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="739816152"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="739816152"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2023 22:59:24 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH 0/4] target/i386: add support for FRED
Date:   Thu, 31 Aug 2023 22:30:18 -0700
Message-Id: <20230901053022.18672-1-xin3.li@intel.com>
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


Xin Li (4):
  target/i386: add support for FRED in CPUID enumeration
  target/i386: mark CR4.FRED not reserved
  target/i386: enumerate VMX nested-exception support
  target/i386: add live migration support for FRED

 target/i386/cpu.c     |  7 +++++-
 target/i386/cpu.h     | 40 +++++++++++++++++++++++++++++++-
 target/i386/kvm/kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 10 ++++++++
 4 files changed, 109 insertions(+), 2 deletions(-)

-- 
2.34.1

