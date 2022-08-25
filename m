Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89F5A0BFC
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 10:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiHYI4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 04:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiHYI4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 04:56:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AEBA8957;
        Thu, 25 Aug 2022 01:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661417789; x=1692953789;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WE76IHyjGNLDBHekXScu1Y9Yvmw3u3Jm3KDNzWpAI5w=;
  b=WE33CwEooipdXi4/GUCj65Y4mx7ksgKN/pXiNqQ9l8TuJpGTir2FP3Ag
   pJKMildbOpM5qd/zogL6SnvXca8iliSO0xhXlR2yjRNwOIPVp+TCEylAX
   sUonvieKwvNTfgKxoiL+i6dIuazV2s8XMardHO7b+mZnV0tt2qpRDDmjw
   u9r5HT0zSJI5TveLviNpHQNk3ZalRmbhUd3IPbF/1g9CBTIuIudvoWsd1
   CcTkC3oey3m5fyD9DjzFnwxYyASxzs+F2ciQw3bHB246lPzo7DFoIPZjG
   QhlBfoc7SAOuwK2yYSb2xuTC7GX2o2kIuD8qAuqUY+W7dM2i7Fb66YtLR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="291756597"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="291756597"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 01:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="639505149"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2022 01:56:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on PT_MODE_HOST_GUEST while host is using PT
Date:   Thu, 25 Aug 2022 16:56:23 +0800
Message-Id: <20220825085625.867763-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is one bug in KVM that can hit vm-entry failure 100% on platform
supporting PT_MODE_HOST_GUEST mode following below steps:

  1. #modprobe -r kvm_intel
  2. #modprobe kvm_intel pt_mode=1
  3. start a VM with QEMU
  4. on host: #perf record -e intel_pt//

The vm-entry failure happens because it violates the requirement stated
in Intel SDM 26.2.1.1 VM-Execution Control Fields

  If the logical processor is operating with Intel PT enabled (if
  IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
  IA32_RTIT_CTL" VM-entry control must be 0.

On PT_MODE_HOST_GUEST node, PT_MODE_HOST_GUEST is always set. Thus KVM
needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry. Currently KVM
manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit. However, it doesn't
work everytime since there is a posibility that IA32_RTIT_CTL.TraceEn is
re-enabled in PT PMI handler before vm-entry. This series tries to fix
the issue by exposing two interfaces from Intel PT driver for the purose
to stop and resume Intel PT on host. It prevents PT PMI handler from
re-enabling PT. By the way, it also fixes another issue that PT PMI
touches PT MSRs whihc leads to what KVM stores for host bemomes stale.

Xiaoyao Li (2):
  perf/x86/intel/pt: Introduce intel_pt_{stop,resume}()
  KVM: VMX: Stop/resume host PT before/after VM entry when
    PT_MODE_HOST_GUEST

 arch/x86/events/intel/pt.c      | 11 ++++++++++-
 arch/x86/include/asm/intel_pt.h |  6 ++++--
 arch/x86/kernel/crash.c         |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 11 ++++++++++-
 4 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.27.0

