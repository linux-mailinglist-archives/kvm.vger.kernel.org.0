Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBC3544656
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbiFIIlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242265AbiFIIk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:40:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA89A45A
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654763992; x=1686299992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wfp7Dysy3aMLlL3dcHfdfzKluLdCDrMv0Qk8NSN23Nc=;
  b=IpJOqbI/e8ZZ/rcjMGfK04QC38VQ5c/eWKFd+sOS5qEuQeHGkA/JJl7n
   RTwnFMZjVBVCraaODdnAlhY5rkEGKMJsbufCF3rg9NEj2VImPu9rUr/8o
   1SWiCEih7LpsDFuSMYtBTOZz15+SjSuE2dgParH/Lti0dav1Q8NK5POEs
   LquXX4o7Qb9L4otb8iAhF86/6bQg7WGaSuVLWeVamGiCbjuduKCIr/dxE
   iuAuCG45KzJHlAICraT41vy7UsO22cz3gJre3c8duJyF2pGzpQKAvCkt7
   M8p7/lbLy2zDrmAvH60547ZaDw/m5emUccADnPTm8rDWU5hwY1n62+2F2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="278355502"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278355502"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="580475503"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 01:39:51 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH 0/3] Fix up test failures induced by !enable_pmu
Date:   Thu,  9 Jun 2022 04:39:13 -0400
Message-Id: <20220609083916.36658-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When pmu is disabled via enable_pmu=0, some perf related MSRs or instructions
are not available to VM, this results into some test failures, fix them in
this series.

Patches were tested with below config:

kernel:
kvm/queue, commit 5e9402ac128b371635478fd2bb04342d4dbf0d74

qemu:
master, commit 9b1f58854959c5a9bdb347e3e04c252ab7fc9ef5

platform:
Skylake/Sapphire Rapids

Yang Weijiang (3):
  x86: Remove perf enable bit from default config
  x86: Skip running test when pmu is disabled
  x86: Skip perf related tests when pmu is disabled

 x86/msr.c       |  4 +++-
 x86/pmu_lbr.c   |  4 +++-
 x86/vmx_tests.c | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)


base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
-- 
2.31.1

