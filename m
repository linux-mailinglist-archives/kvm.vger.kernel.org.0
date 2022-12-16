Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451864E8D8
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 10:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiLPJth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 04:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLPJtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 04:49:33 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A8047325
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 01:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671184172; x=1702720172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3Jy3D579A34GePYyODHwk6V2pW+lPabCZCjPITSW0do=;
  b=JngNkG5EOE/9L7nxnmZKen1t0ElJ6fGqw/CCjJLsjlvW7ko9ekQ2IMdl
   BmaTvuuRUgoQuzy7YFqdCauQVVmC3DLQPve9M7naOHJAreI7NLBk4kx1N
   NGlGGhNIUvXrXKk8PB10f8n2XMnNQ20WqtVScMYuGwP8GyKfywLJbwXsU
   IZssoyO4pnZMY23mkjtRgPgb6Y2N3KjkGhjh4F0nJvvJYaZgsfQCr0zz+
   Jz14ePGhxZkrP3VwvxN8MZxhyIwA5h5Ca/xsjo2MLFykCmHqI7phPOvcM
   bJfoDME3lFRF7VMbtzgtaY+P/VCrgoRpuG48j1CDMR+bJmYpaytUhq6w0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="299270066"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="299270066"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 01:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="649752693"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="649752693"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga002.jf.intel.com with ESMTP; 16 Dec 2022 01:49:28 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: [PATCH v4 0/2] KVM: MMU: Use 'INVALID_GPA' and 'INVALID_GFN' properly
Date:   Fri, 16 Dec 2022 16:59:26 +0800
Message-Id: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pacth 1 adds a new definition, 'INVALID_GFN', so that GFN
values can use it, instead of the 'GPA_INVALID'.

Pacth 2 makes the definition of 'INVALID_GPA' shared by
different archs.

Both are tested by rebuilding KVM for x86 and for ARM64.

---
V4:
- Put the addition of 'INVALID_GFN' into a seperate patch.
V3:
- Added 'INVALID_GFN' and use it.
v2:
- Renamed 'GPA_INVALID' to 'INVALID_GPA' and modify _those_ users. 
v1:
https://lore.kernel.org/lkml/20221209023622.274715-1-yu.c.zhang@linux.intel.com/

Yu Zhang (2):
  KVM: MMU: Introduce 'INVALID_GFN' and use it for GFN values
  KVM: MMU: Make the definition of 'INVALID_GPA' common

 arch/arm64/include/asm/kvm_host.h                  |  4 ++--
 arch/arm64/kvm/hypercalls.c                        |  2 +-
 arch/arm64/kvm/pvtime.c                            |  8 ++++----
 arch/x86/include/asm/kvm_host.h                    |  2 --
 arch/x86/kvm/xen.c                                 | 14 +++++++-------
 include/linux/kvm_types.h                          |  3 ++-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  4 ++--
 7 files changed, 18 insertions(+), 19 deletions(-)

-- 
2.25.1

