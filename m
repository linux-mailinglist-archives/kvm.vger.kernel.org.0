Return-Path: <kvm+bounces-7965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFFB84944A
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC7121F21061
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FC0101DE;
	Mon,  5 Feb 2024 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jq/mZXry"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B555110A11;
	Mon,  5 Feb 2024 07:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707117527; cv=none; b=hZW5n4rZizC+BEkDeSjDvF8lOCX6PVY5X/gCLF3771WLFblr3kmKyLvj4ZidxFaO6X6ivX0euW3WpSaLipKRFu36W0LQ11zgOWFgbCnQzl8kGbpCKYIRogHJ6a3O6T/d4q57VPuGg7Eftr6wzuVNkdoGc9kmJp5GOTComjem9So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707117527; c=relaxed/simple;
	bh=gkdmc8lA4q8aWADtHilHVzHU5JvdhJ3Qy1IP3zrRi5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F/Uw3ngqwQy9iVGbKLMwPS4ds2kc++UxEwFdznZR+WILWxudJWyTqa0ucqU+iyO6ylzkR+7Iq0rrIds5vWZ5KXmuwcTHRd8LpCBxBbTt1esXUCt3S3yHJ2sufA4zJOae1T/h7ZK41lvfrRy2m00ZUu7nF/3swI+NskaTP2kAHRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jq/mZXry; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707117525; x=1738653525;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gkdmc8lA4q8aWADtHilHVzHU5JvdhJ3Qy1IP3zrRi5Y=;
  b=Jq/mZXrytytnI9q2YCeyxdISJMoK+ncI2ndC+9fo/fTfa1+GKJKXYTCd
   nHolw+ZenL8NqwAg+mrN8JEqFS/2hUqRn17ejg2TC3/zhqMb2mlHZY5zn
   HL0Jrrg06d/N09yzEidZdJdYTgcXaYNvPVbOUJ2D0t4EsOhBWT6g9X/eY
   oTx3L7wLDi1nM4DT/2hUXg9XEdwmKXfNd9Hdb4uUdlnLd/cXGEzzIt3r1
   QskIl2HJIL6b4ped2p6YMndQX2xQbG9uo/Ki6qcDSovSvHobtxwvrcrgD
   ttqu9hJGXNvDh9GcEafnT9dBQtzt8Fuyi+ZvKkJNU162gaUZfiywe9kUu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11110045"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11110045"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:18:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="848756"
Received: from tdspence-mobl1.amr.corp.intel.com (HELO desk) ([10.251.0.86])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:18:43 -0800
Date: Sun, 4 Feb 2024 23:18:42 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Alyssa Milburn <alyssa.milburn@intel.com>, stable@kernel.org,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v7 0/6] Delay VERW
Message-ID: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAIyKwGUC/23QzWrDMBAE4FcJOldB2tWfe+p7lBxkad0IXDvIq
 ZIQ/O5VXQo29XEG5jvMk02UE03s9fBkmUqa0jjUYF8OLJz98EE8xZoZCEAppOSRev/ghfKNR6G
 sapxpISCrg0umLt0X7J2xU23OabqO+bHoRS79LwRiDRXJBQ9dp5VoDIKJb30avu7HNFypP4bxc
 8EKrAG1AaACnXROohLBCbsP4BrQGwAroMEYNNYSod4H9B+g6hWbL4qugMcWUDWI5M0+YFYA4AY
 wP4ADYVofvI34H5jn+Rto/D88sAEAAA==
X-Mailer: b4 0.12.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

v7:
- Rebase to v6.8-rc3.
- Resolved merge conflict for X86_FEATURE_CLEAR_CPU_BUF definition, bit position
  was already taken.
- Resolved merge conflict with 1e4d3001f59f ("x86/entry: Harden
  return-to-user") and c516213726fb ("x86/entry: Optimize common_interrupt_return()").

v6: https://lore.kernel.org/r/20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com
- Simplify FB_CLEAR checks in vmx_update_fb_clear_dis() and the comment. (Sean)

v5: https://lore.kernel.org/r/20240111-delay-verw-v5-0-a3b234933ea6@linux.intel.com
- Added comment to SYM_CODE_START_NOALIGN(mds_verw_sel) explaining VERW
  operand is in code segment so that VERW at works with KPTI. (Josh/Borislav).
- Fixed changelog for patch 1/6. (Borislav)
- Clarify CLEAR_CPU_BUFFERS macro documentation. (Josh)
- KVM: Move the check to skip FB_CLEAR_CTRL optimization for guests when
  X86_FEATURE_CLEAR_CPU_BUF is set. (Josh)
- Rebased to v6.7

v4: https://lore.kernel.org/all/20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com/
- Fill unused part of mds_verw_sel cacheline with int3. (Andrew)
- Fix the formatting in documentation (0-day).
- s/inspite/in spite/ (Sean).
- Explicitly skip FB_CLEAR optimization when MDS affected (Sean).

v3: https://lore.kernel.org/r/20231025-delay-verw-v3-0-52663677ee35@linux.intel.com
- Use .entry.text section for VERW memory operand. (Andrew/PeterZ)
- Fix the duplicate header inclusion. (Chao)

v2: https://lore.kernel.org/r/20231024-delay-verw-v2-0-f1881340c807@linux.intel.com
- Removed the extra EXEC_VERW macro layers. (Sean)
- Move NOPL before VERW. (Sean)
- s/USER_CLEAR_CPU_BUFFERS/CLEAR_CPU_BUFFERS/. (Josh/Dave)
- Removed the comments before CLEAR_CPU_BUFFERS. (Josh)
- Remove CLEAR_CPU_BUFFERS from NMI returning to kernel and document the
  reason. (Josh/Dave)
- Reformat comment in md_clear_update_mitigation(). (Josh)
- Squash "x86/bugs: Cleanup mds_user_clear" patch. (Nikolay)
- s/GUEST_CLEAR_CPU_BUFFERS/CLEAR_CPU_BUFFERS/. (Josh)
- Added a patch from Sean to use CFLAGS.CF for VMLAUNCH/VMRESUME
  selection. This facilitates a single CLEAR_CPU_BUFFERS location for both
  VMLAUNCH and VMRESUME. (Sean)

v1: https://lore.kernel.org/r/20231020-delay-verw-v1-0-cff54096326d@linux.intel.com

Hi,

Legacy instruction VERW was overloaded by some processors to clear
micro-architectural CPU buffers as a mitigation of CPU bugs. This series
moves VERW execution to a later point in exit-to-user path. This is
needed because in some cases it may be possible for kernel data to be
accessed after VERW in arch_exit_to_user_mode(). Such accesses may put
data into MDS affected CPU buffers, for example:

  1. Kernel data accessed by an NMI between VERW and return-to-user can
     remain in CPU buffers (since NMI returning to kernel does not
     execute VERW to clear CPU buffers).
  2. Alyssa reported that after VERW is executed,
     CONFIG_GCC_PLUGIN_STACKLEAK=y scrubs the stack used by a system
     call. Memory accesses during stack scrubbing can move kernel stack
     contents into CPU buffers.
  3. When caller saved registers are restored after a return from
     function executing VERW, the kernel stack accesses can remain in
     CPU buffers(since they occur after VERW).

Although these cases are less practical to exploit, moving VERW closer
to ring transition reduces the attack surface.

Overview of the series:

Patch 1: Prepares VERW macros for use in asm.
Patch 2: Adds macros to 64-bit entry/exit points.
Patch 3: Adds macros to 32-bit entry/exit points.
Patch 4: Enables the new macros.
Patch 5: Uses CFLAGS.CF for VMLAUNCH/VMRESUME selection.
Patch 6: Adds macro to VMenter.

Below is some performance data collected on a Skylake client
compared with previous implementation:

Baseline: v6.6-rc5

| Test               | Configuration          | v1   | v3   |
| ------------------ | ---------------------- | ---- | ---- |
| build-linux-kernel | defconfig              | 1.00 | 1.00 |
| hackbench          | 32 - Process           | 1.02 | 1.06 |
| nginx              | Short Connection - 500 | 1.01 | 1.04 |

Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: Alyssa Milburn <alyssa.milburn@linux.intel.com>
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: antonio.gomez.iglesias@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: tony.luck@intel.com
To: ak@linux.intel.com
To: tim.c.chen@linux.intel.com
To: Andrew Cooper <andrew.cooper3@citrix.com>
To: Nikolay Borisov <nik.borisov@suse.com>

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
Pawan Gupta (5):
      x86/bugs: Add asm helpers for executing VERW
      x86/entry_64: Add VERW just before userspace transition
      x86/entry_32: Add VERW just before userspace transition
      x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key
      KVM: VMX: Move VERW closer to VMentry for MDS mitigation

Sean Christopherson (1):
      KVM: VMX: Use BT+JNC, i.e. EFLAGS.CF to select VMRESUME vs. VMLAUNCH

 Documentation/arch/x86/mds.rst       | 38 +++++++++++++++++++++++++-----------
 arch/x86/entry/entry.S               | 22 +++++++++++++++++++++
 arch/x86/entry/entry_32.S            |  3 +++
 arch/x86/entry/entry_64.S            | 11 +++++++++++
 arch/x86/entry/entry_64_compat.S     |  1 +
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/entry-common.h  |  1 -
 arch/x86/include/asm/nospec-branch.h | 29 +++++++++++++++------------
 arch/x86/kernel/cpu/bugs.c           | 15 ++++++--------
 arch/x86/kernel/nmi.c                |  3 ---
 arch/x86/kvm/vmx/run_flags.h         |  7 +++++--
 arch/x86/kvm/vmx/vmenter.S           |  9 ++++++---
 arch/x86/kvm/vmx/vmx.c               | 20 +++++++++++++++----
 13 files changed, 115 insertions(+), 46 deletions(-)
---
base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
change-id: 20231011-delay-verw-d0474986b2c3

Best regards,
-- 
Thanks,
Pawan



