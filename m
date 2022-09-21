Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A975C049F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiIUQuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiIUQuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:50:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2498644568;
        Wed, 21 Sep 2022 09:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663778731; x=1695314731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=laXgAb+WMN2z204oCnwMZwdSHX27n7WQtFDeOEih/Gg=;
  b=jCM1/VheGGE+iXYOTfgpB6UoTsgvG+BydYn/x3ASM8KvZd5Xv8muGbza
   Nzi/3Jhlev63vwn0ASZQU9fqX2bDAnrguVQM6Y3MRZxQws7BK2JBWbkIw
   NYsLkNo/Gk1Zk10uuGWeJ5V3uqhnT1RShFaW2SaTYjO5G0cd8Hrp3X0SP
   aGL/W5wY5xZljJkr3QqdkHxf3VJfjPTkqqrF1L/YAIn4f+Ouhqp8HQJhg
   BhX2M6rI2TXVUff0NTXfzHorsLySWtvr6JzwTIjchYy6W3kxPvgho64ap
   L3LDtZe45+z7nts2XKKk/Sbrqn901hYXK9HqKr7sTdLQgYw9GjVyvVIno
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300044908"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300044908"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 09:45:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="948227885"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2022 09:45:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com,
        kan.liang@linux.intel.com
Cc:     xiaoyao.li@intel.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH v2 0/3] KVM: VMX: Fix VM entry failure on PT_MODE_HOST_GUEST while host is using PT
Date:   Thu, 22 Sep 2022 00:45:18 +0800
Message-Id: <20220921164521.2858932-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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

On PT_MODE_HOST_GUEST node, vm-entry load RTIT is always set. Thus KVM
needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry. Currently KVM
manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit. However, it doesn't
work everytime since there is a posibility that IA32_RTIT_CTL.TraceEn is
re-enabled in PT PMI handler before vm-entry.

This series tries to fix the issue by exposing and calling perf driver
API to stop host PT event (if any) before vm-entry and resume PT event
after vm-exit. Perf API can prevent PT PMI handler from re-enabling PT.

By the way, drop the save/restore of PT MSRs of host because the resume
of PT event after vm-exit doesn't rely on the previous value of PT MSRs.

Changes in v1:
 - Export perf_event_{en,dis}able_local() and pt_get_curr_event() for KVM to
   stop/resume PT event; (Suggested-by Wang, Wei W <wei.w.wang@intel.com>)
 - Drop the save/restore of host PT MSRs.

v1: https://lore.kernel.org/all/20220825085625.867763-1-xiaoyao.li@intel.com/

Xiaoyao Li (3):
  perf/core: Expose perf_event_{en,dis}able_local()
  perf/x86/intel/pt: Introduce and export pt_get_curr_event()
  KVM: VMX: Stop/resume host PT before/after VMX transition when
    PT_MODE_HOST_GUEST

 arch/x86/events/intel/pt.c        |  8 ++++++++
 arch/x86/include/asm/perf_event.h |  2 ++
 arch/x86/kvm/vmx/vmx.c            | 31 +++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h            |  2 +-
 include/linux/perf_event.h        |  1 +
 kernel/events/core.c              |  7 +++++++
 6 files changed, 32 insertions(+), 19 deletions(-)

-- 
2.27.0

