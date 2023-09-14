Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74079FBE5
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbjING2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjING2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6BF7;
        Wed, 13 Sep 2023 23:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672922; x=1726208922;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M7ns64vYoImAeD+UE1w6RYJ6zUnzFhLLgpBhZoZphFE=;
  b=OD8FkFY6rr5mvlLUOZFES6Yfk3riKMzZADmcfdbBIQEyHJpJWm4Eoa/n
   dDnKkM79HsyJNCis/hSHI+NaHVV1xEMG5MfH5aed9b3TigtWi2SgF0tTa
   Yr11HdAQ4SboCJthZ7UJ0PUYSA2NhErpTRO0BGcegRvfV+dx9PzVPsxhC
   VDUgy6uRyIB0qo7CCRHoZeYqZ75yjyX7+vJkzI6kc8cq9YGXMb8AcbsA4
   Jj0OIWoeF3ZEqcRqFtmLJU2QAL7AZ9UQgxVKvhq3HyXbYN3RIjR3fxSkV
   /1rzqD+6MxLoQgKaTk9jp8hGDZfmC8w5TycJFvyNGTTHtfezQK8/QVKjL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672432"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672432"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937975"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937975"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 0/8] Introduce CET supervisor xstate support
Date:   Wed, 13 Sep 2023 23:23:26 -0400
Message-Id: <20230914032334.75212-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, x86 maintainers,

Please review this series for CET virtualization enabling, the series is
considered as a necessary part for supporting guest CET. See related
discussion here [*].

Thanks!

----------------------------------------------------------------------------

CET supervisor state, i.e., IA32_PL{0,1,2}_SSP, are xsave-managed MSRs,
it can be opt-in via IA32_XSS[bit 12]. Currently host supervisor shadow
stack are not enabled and the feature bit is not set. But from KVM usage
perspective, enabling host CET supervisor state is required for guest CET
supervisor MSRs management. The benefits are: 1) No need to manually save/
restore the 3 MSRs when vCPU is switched in/out. 2) Omit manually saving/
reloading the MSRs at VM-Exit/VM-Entry. 3) Make guest CET user mode and
supervisor mode states managed within current FPU framework in consistent
manners.

This series tries to:
1) Fix issues resulted from CET virtualizaiton enabling and CET usage in guest. 
2) Add CET supervisor xstate support in kernel.
3) Introduce kernel dynamic xfeature set for CET supervisor state optimization.
4) Change guest fpstate settings to hold kernel dynamic xfeatures.

For guest fpstate, we have xstate_bv[12] == xcomp_bv[12] == 1 in xstate_header,
and CET supervisor mode state are saved/reloaded when xsaves/xrstors runs
on fpstate area.
For non-guest fpstate we have xstate_bv[12] == xcomp_bv[12] == 0, then HW can
optimize xsaves/xrstors operations.


Basic tests done (based on v6.6-rc1 kernel tree):
1. selftests: x86:amx_64/test_fpu, kvm: amx_test,smm_test,state_test etc.
2. Guest launch with IA32_PL{0,1,2}_SSP read/write in host/guest kernel.
3. Guest live migration tests.

No perceivable issues (mainly dmesg) are found in both host and guest during
above tests.

Patch1: Fix a potential CET xstate dependency issue in guest kernel.
Patch2: Fix an inconsistent size issue in guest fpstate allocation.
Patch3: Introduce CET supervisor xstate support.
Patch4: Introduce kernel dynamic xfeature set for optimization.
Patch5: Remove kernel dynamic xfeatures from normal fpstate.
Patch6: Opt-in kernel dynamic xfeatures when resize guest xsave area.
Patch7: Include kernel dynamic xfetures when allocate guest xsave area.
Patch8: Check unexpected/invalid fpstate settings before fire xsave.

[*]: https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/  


Yang Weijiang (8):
  x86/fpu/xstate: Manually check and add XFEATURE_CET_USER xstate bit
  x86/fpu/xstate: Fix guest fpstate allocation size calculation
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce kernel dynamic xfeature set
  x86/fpu/xstate: Remove kernel dynamic xfeatures from kernel default_features
  x86/fpu/xstate: Opt-in kernel dynamic bits when calculate guest xstate size
  x86/fpu/xstate: Tweak guest fpstate to support kernel dynamic xfeatures
  x86/fpu/xstate: WARN if normal fpstate contains kernel dynamic xfeatures

 arch/x86/include/asm/fpu/types.h  | 14 ++++++--
 arch/x86/include/asm/fpu/xstate.h |  6 ++--
 arch/x86/kernel/fpu/core.c        | 56 ++++++++++++++++++++++++++-----
 arch/x86/kernel/fpu/xstate.c      | 49 ++++++++++++++++++++++++---
 arch/x86/kernel/fpu/xstate.h      |  5 +++
 5 files changed, 112 insertions(+), 18 deletions(-)

-- 
2.27.0

