Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7945075021A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjGLIzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGLIzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:55:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8595B7;
        Wed, 12 Jul 2023 01:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152138; x=1720688138;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VdlbdD3uvfNfNAclvpv6o/FUkmCaohnfETFKewIjeT4=;
  b=BkUiaUCIkd4uoasnDjw2otoh3lJJlF/o/XrGG5d66KsI6JrOVA4mwOzD
   BnWfWCi88HVsijRLQV5rPR8p5KMENrmUHlmEq4tsX4lyvSPoEIcyg3n+O
   7TVavXSwXhCPHx631QppT3Tnc0LPWuGqUtfCVuT2RL+TDzq3kxVQUamnk
   c9imEl0sgh5B882avjCODEvXhigM2bKeF+nKwvoqogLgGny7+9u98Jz0A
   Oi9+juEQERTdHvjERAqq4FVq8bnekBwq9N1oYMeu1fkK1sTFZqkP1Zq/U
   sC5NexEFgAXHacmiv5A+YoCR7+sLgvTezAWPwPR4m0PMV85e6qMwZElNQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439089"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439089"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573315"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573315"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:32 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 00/10] Unify TDCALL/SEAMCALL and TDVMCALL assembly
Date:   Wed, 12 Jul 2023 20:55:14 +1200
Message-ID: <cover.1689151537.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter, Kirill, all,

This series unifies the assembly code for TDCALL/SEAMCALL and TDVMCALL.
Now all of them use one singe TDX_MODULE_CALL asm macro.  I basically
followed Peter's code here:

https://lore.kernel.org/linux-mm/20230630120650.GB2534364@hirez.programming.kicks-ass.net/

With some differences that I found during my code writing and testing.

With this series, I have verified the TDX guest can boot successfully
and the TDX module can also be initialized successfully.

The last two patches are SEAMCALL patches that are needed for TDX host
patchset.  They are not mandatory to be here though, i.e., can be in the
TDX host support series.  I put them here so we can have a complete view
how TDCALL/SEAMCALL and TDVMCALL are implemented.

Could you help to review?  Thanks in advance.

Also cc Sean/Paolo/Isaku and KVM list for TDH.VP.ENTER part.

Kai Huang (10):
  x86/tdx: Zero out the missing RSI in TDX_HYPERCALL macro
  x86/tdx: Use cmovc to save a label in TDX_MODULE_CALL asm
  x86/tdx: Move FRAME_BEGIN/END to TDX_MODULE_CALL asm macro
  x86/tdx: Make macros of TDCALLs consistent with the spec
  x86/tdx: Rename __tdx_module_call() to __tdcall()
  x86/tdx: Pass TDCALL/SEAMCALL input/output registers via a structure
  x86/tdx: Extend TDX_MODULE_CALL to support more TDCALL/SEAMCALL leafs
  x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL assembly
  x86/virt/tdx: Wire up basic SEAMCALL functions
  x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP

 arch/x86/Kconfig                  |  12 ++
 arch/x86/Makefile                 |   2 +
 arch/x86/boot/compressed/tdx.c    |  26 +++-
 arch/x86/coco/tdx/tdcall.S        | 238 +++++-------------------------
 arch/x86/coco/tdx/tdx.c           | 124 +++++++++-------
 arch/x86/include/asm/shared/tdx.h |  48 ++++--
 arch/x86/include/asm/tdx.h        |  31 ++--
 arch/x86/kernel/asm-offsets.c     |  33 ++---
 arch/x86/virt/Makefile            |   2 +
 arch/x86/virt/vmx/Makefile        |   2 +
 arch/x86/virt/vmx/tdx/Makefile    |   2 +
 arch/x86/virt/vmx/tdx/seamcall.S  |  54 +++++++
 arch/x86/virt/vmx/tdx/tdxcall.S   | 206 ++++++++++++++++++++------
 13 files changed, 431 insertions(+), 349 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S


base-commit: 94142c9d1bdf1c18027a42758ceb6bdd59a92012
-- 
2.41.0

