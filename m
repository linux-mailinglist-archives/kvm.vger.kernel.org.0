Return-Path: <kvm+bounces-41362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB51A66A93
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C3303B8D8E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB1A1DE8B7;
	Tue, 18 Mar 2025 06:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmAUG3f0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA5E46426;
	Tue, 18 Mar 2025 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279751; cv=none; b=mqy835bngdJVwjhCw13Ml1gGkKQwAwOHFPrj5rH0fjO4wSXcoa6Uk6NceysMN9ox+KKEzwRgN0eX1zNzoiu01YWfxcIQrVB3FfuekSfCNDigHv5GC67Bp0aw+hYs0qwwI/4yqftVoBRvokN7KoRlocxsBrZB4KrL1WYVu1aCsbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279751; c=relaxed/simple;
	bh=rOHbCLNwUuQ0MCHqcCbere0AhcqH/e8hZR21LTzO8A0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WYzXSZ/hTL/pUyaQzjS9qOwKRYsYwlFp/AQ/Lim4SXxT3Gz0Ut5aOX1oCtvWPKcdUCnL/SXXH7IzYSHlOEf4CslJqPW4JhB+BViDIJKXW2XKQmoXW604GHlWkQS0A9r9obCR+J1t4POMfJMjmv+NlQhw7DO2/mHy0ksSLM2toTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmAUG3f0; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742279750; x=1773815750;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=rOHbCLNwUuQ0MCHqcCbere0AhcqH/e8hZR21LTzO8A0=;
  b=XmAUG3f0vcISBCVMSirEIp/FYaxKEryvtSex0VR1kJ8QJtLKSIsGVpsR
   NlMutFFw5JZsSTcXMhqTRJzUGhbfLdBKGSmWeINdTT70vbPBPvJLJD+ew
   JjcQNfBhC7KjJ8HvTkokPfjaL06jcAGJtY9ZidVvhHlk9f/5NfDDK0psY
   qjDrcHpAEaebpn4c8tqKx9/Hn1OJYwc9Ypt4Gh+5WtLJQ0V2bkMTYf7X9
   6ZSSmoEZC3+xQY4X5DM9XjNK57sxYjiLHWwabv0uThIma+kvrBs0sHfUn
   wJvv0DWKnl4Spvwx77dQv2kFRZVQu7cuJ9aI9f90gW4glfpp1YpNJyZxK
   g==;
X-CSE-ConnectionGUID: yNSKG1e/RDGpErUcYbPnyw==
X-CSE-MsgGUID: z54N1lnIR3OUyOgc1Msm1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53613407"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53613407"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:49 -0700
X-CSE-ConnectionGUID: PYYJ/dY/T1OFBLqUorXGGg==
X-CSE-MsgGUID: ENPWH/G0SvKEh5EGg2Rb5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="153147525"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.109.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:47 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/4] KVM: TDX: Cleanup the kvm_x86_ops structure for
 vmx/tdx
Date: Tue, 18 Mar 2025 00:35:05 -0600
Message-Id: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABkU2WcC/4WNQQ6CMBQFr0K6tqa/QEFW3sMQUstHmkBLWmwwh
 LtbiAtXupyXzLyVeHQaPamSlTgM2mtrIvBTQlQvzQOpbiMTznjOUgAaArpRFlQNKM1zapZSNHb
 yVAmOOcOsAC5ItCeHnV6O8q2O3Gs/W/c6jgLs6/9mAMrohd8RuxJEK7qrNjMOZ2XH/eLjp799l
 mZClRxAMvXl19u2vQHGs+GJ/gAAAA==
X-Change-ID: 20250311-vverma7-cleanup_x86_ops-c62e50e47126
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Binbin Wu <binbin.wu@linxu.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2999;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=rOHbCLNwUuQ0MCHqcCbere0AhcqH/e8hZR21LTzO8A0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOk3RcxsZddvSPTw+tnjZnqy3KRuVlqK1kWBgiUPV750P
 rlI7dmKjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzE34Dhf+Zp5ddbvC4G8Sau
 0fz4/npMeqfpB51r3y9qPWeYevzTZR+GP9xhnN+Xz3gwc36oySK1WreH99KK179Yqd8ZHHtBbyL
 HL1YA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

This is a cleanup that should follow the initial TDX base support (i.e.
not an immediate fix needed for kvm-coco-queue).

Patch 1 is a precursory fix for a build warning/error found when
manually testing the CONFIG_INTEL_TDX_HOST=n case.

For Patches 2-4:

In [1], Sean points out that the kvm_x86_ops structure and its
associated helpers and wrappers can be cleaned up a lot by -

1. Putting the wrappers under CONFIG_KVM_INTEL_TDX, and
2. Defining the helpers with macros that switch between the tdx and
   non-tdx case, as well as NULL out the TDX-only stubs when needed.

This cleans up the generated code by completely removing trampolines
that would otherwise be left behind in the CONFIG_KVM_INTEL_TDX=n case.

[1]: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/

For example, looking at vt_refresh_apicv_exec_ctrl(), before this cleanup,
when CONFIG_KVM_INTEL_TDX=n, the following asm is generated:

0000000000036490 <vt_refresh_apicv_exec_ctrl>:
   36490:       f3 0f 1e fa             endbr64
   36494:       e8 00 00 00 00          call   36499 <vt_refresh_apicv_exec_ctrl+0x9>
                        36495: R_X86_64_PLT32   __fentry__-0x4
   36499:       e9 00 00 00 00          jmp    3649e <vt_refresh_apicv_exec_ctrl+0xe>
                        3649a: R_X86_64_PLT32   vmx_refresh_apicv_exec_ctrl-0x4
   3649e:       66 90                   xchg   %ax,%ax

But with these patches, it goes away completely.

These patches have been tested with TDX kvm-unit-tests, booting a Linux
TD, TDX enhanced KVM selftests, and building and examining the generated
assembly (or lack thereof) with both CONFIG_KVM_INTEL_TDX=y and
CONFIG_KVM_INTEL_TDX=n

Based on a patch by Sean Christopherson <seanjc@google.com>

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v2:
- Collect review tags (Binbin)
- Add a new patch (patch 1) as a precursor that fixes a build problem
- Squash the config change into patch 4 that converts ops to macros to
avoid breaking the build when CONFIG_KVM_INTEL_TDX=n (Binbin)
- Link to v1: https://lore.kernel.org/r/20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com

---
Vishal Verma (4):
      KVM: TDX: Fix definition of tdx_guest_nr_guest_keyids()
      KVM: VMX: Move apicv_pre_state_restore to posted_intr.c
      KVM: VMX: Make naming consistent for kvm_complete_insn_gp via define
      KVM: VMX: Clean up and macrofy x86_ops

 arch/x86/include/asm/tdx.h     |   2 +-
 arch/x86/kvm/vmx/posted_intr.h |   1 +
 arch/x86/kvm/vmx/tdx.h         |   2 +-
 arch/x86/kvm/vmx/x86_ops.h     |  68 +-------------
 arch/x86/kvm/vmx/main.c        | 204 ++++++++++++++++++++---------------------
 arch/x86/kvm/vmx/posted_intr.c |   8 ++
 6 files changed, 114 insertions(+), 171 deletions(-)
---
base-commit: 85c9490bbed74b006a614e542da404a55ff5938f
change-id: 20250311-vverma7-cleanup_x86_ops-c62e50e47126

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


