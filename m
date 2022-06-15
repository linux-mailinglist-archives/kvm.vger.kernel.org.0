Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874B854C3ED
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346568AbiFOIrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 04:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346206AbiFOIrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 04:47:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EACA4BB83
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282839; x=1686818839;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0WqBBL8dZ2gC2Ve2CzEmoOSpch5gYgXNhWvTLMyaiE0=;
  b=SeA3BA7vn+sIDThxZXZHR29BFghYiqFJ9p4Gg5YYPY7IHnDA/nSlbjur
   9OdBp56vi6C8sXJXiETE9AcU8zjgzY47kHpwfZK3lJQckk5iZeHaF43nD
   0mh8uO+uVDmNFO+2tIcHFwBjmVwRLK1MEJbw6FUhodMFI9rVt2fCFvcOx
   KVgDAB7Z2BXddG90aXVSJz91qrGtj0O1OySVscBVmIzXuGF5MnfCiOo70
   tSPXR2SG4zKeH80wpyEb6sP+9JOdYnhbRfP/rkfDxmbUXFQNw6J1A7N7U
   I15ldJ8zY3RUwHFETGaikGc31IA71ExaEGwp3/nXmPi7HyO3ykladSJP8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="342848608"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="342848608"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="558944456"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:47:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     like.xu.linux@gmail.com, jmattson@google.com, kvm@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 0/3] Fix up failures induced by !enable_pmu
Date:   Wed, 15 Jun 2022 04:46:38 -0400
Message-Id: <20220615084641.6977-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently Paolo and Like submitted fixup patches for !enable_pmu case,
this induces some test failures in kvm unit tests, fix them in this
series.

Patches were tested with below config:

kernel:
kvm/queue, commit 8baacf67c76c

qemu:
master, commit 9b1f58854959

platform:
Skylake/Sapphire Rapids

v2:
1. Check PDCM bit of CPUID(1).ecx before read PERF_CAPABILIIES msr.
2. Rebased to newer kvm unit tests master branch.

Yang Weijiang (3):
  x86: Remove perf enable bit from default config
  x86: Skip running test when pmu is disabled
  x86: Skip perf related tests when pmu is disabled

 x86/msr.c       |  4 +++-
 x86/pmu_lbr.c   | 12 +++++++++++-
 x86/vmx_tests.c | 24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)


base-commit: 610c15284a537484682adfb4b6d6313991ab954f
-- 
2.31.1

