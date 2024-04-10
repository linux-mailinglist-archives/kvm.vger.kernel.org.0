Return-Path: <kvm+bounces-14122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3850389F9F4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5948F1C22A83
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD2716D4DB;
	Wed, 10 Apr 2024 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDLvmiOz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C543AB5;
	Wed, 10 Apr 2024 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759715; cv=none; b=UNlxyemeN9Jz7bXDNmfIZN/SqIIDNUA+/HZ5M4R2jcu7UFARC0pO8b1rjj7i6eyrT62QcCED0V/n1ma84IcHYHVSGWZKtda69uMxb2XPunieJFDDrhae5oCESQeFJWFahbRnkqlCr892hjimEXJ8D48vpNyzbkSUktrFV1LTKt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759715; c=relaxed/simple;
	bh=bu5zryrvjZg5XeQ1c0hruAmUMNYbobFTt4YqFwwHmaw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DOJqAp8K4dv4EUK/ASMC4UdNnBrUs4qsfYC/FOp8sHDd9fmzi0EOWQzMMta3I2vZOtNNIPIYGLVX9X/eI6MVTzGyftXM/831MFCQJpW1h/mIIDr80DEiEi4Q1tuXMTbXEKNi0JdSEt8eBkGQSPIeREovKC10JYXBf5Oxr2+rlNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDLvmiOz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759714; x=1744295714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bu5zryrvjZg5XeQ1c0hruAmUMNYbobFTt4YqFwwHmaw=;
  b=lDLvmiOzwzhgbni0B9xMVc7GoLxfqYluseHW0O3VtcSj4PD6fza5/yCy
   4SZXJ0dl7K/EI///OhRejIAnjPQ7zGr9M7h+yTK+WXNqF6ZZorblhZy5P
   ibGuPc5lhlKW3mFLtmz3gORQXFI0YpZARfZAEhp3dl/ssfjfocuxoen9F
   I6EoxjX+YGkMWiJIgXPHcJiSu0zTQuXrPFOnMaVNYfO3INdLvQAolQa+O
   r2Y1AZ1uGkpAywOjoHmEMNAZRp6yVFTSCnZe7mg6lhzPG1TpIdSpuWsGj
   XrbpUHqQzNMUT3wD51ATOizRL37vvQNHMiLJq+37C+vGuacbEB7l4Hh0k
   Q==;
X-CSE-ConnectionGUID: 5jPhN1gwR+aLd+ydztGmCg==
X-CSE-MsgGUID: 3Lod1GMbR2KKxWnt33w9Qw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837719"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837719"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:13 -0700
X-CSE-ConnectionGUID: fcsnED6kQbeRVfyTTgRyxQ==
X-CSE-MsgGUID: nfquyPURQYmat7RzkJaROw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095485"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:07 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Adam Dunlap <acdunlap@google.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	linux-doc@vger.kernel.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	x86@kernel.org
Subject: [RFC PATCH v3 00/10] Virtualize Intel IA32_SPEC_CTRL
Date: Wed, 10 Apr 2024 22:34:28 +0800
Message-Id: <20240410143446.797262-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is tagged as RFC because I want to seek your feedback on

1. the KVM<->userspace ABI defined in patch 1

I am wondering if we can allow the userspace to configure the mask
and the shadow value during guest's lifetime and do it on a vCPU basis.
this way, in conjunction with "virtual MSRs" or any other interfaces,
the usespace can adjust hardware mitigations applied to the guest during
guest's lifetime e.g., for the best performance.

2. Intel-defined virtual MSRs vs. a new interface

The situation is some other OS already adopts the Intel-defined virtual
MSRs. Given this, I am not sure whether defining a new interface is
still preferable, as it will add more complexities if we end up with two
interfaces for the same purpose.

So, I just want to reconfirm whether the suggestion remains to define a
new interface through community collaboration as suggested at [1].



Below is the cover letter:

Background
==========

Branch History Injection (BHI) is a special form of Spectre variant 2,
where an attacker may manipulate branch history before transitioning
from user to supervisor mode (or from VMX non-root/guest to root mode)
in an effort to cause an indirect branch predictor to select a specific
predictor entry for an indirect branch, and a disclosure gadget at the
predicted target will transiently execute.

To mitigate BHI attacks, the kernel may use the hardware mitigation, i.e.,
BHI_DIS_S or resort to a SW loop, i.e., the BHB-clearing sequence, when the
hardware mitigation is not supported.


Problem
=======

However, the SW loop is effective on pre-SPR parts but not on SPR and
future parts. This creates a mitigation effectiveness problem for virtual
machines:

  Migrating a guest using the SW loop on a pre-SPR part to parts where
  the SW loop is ineffective (e.g., a SPR or future part) makes the
  guest become vulnerable to BHI.

[For bare-metal, it isn't a problem. because parts on which the SW loop
is ineffective always support BHI_DIS_S, which is a more preferable
mitigation than the SW loop.]


Solution
========
This series proposes QEMU+KVM to deploy BHI_DIS_S using "virtualize
IA32_SPEC_CTRL" for the guest if the SW loop is ineffective on the host.

  Note that: "virtualize IA32_SPEC_CTRL" allows the VMM to prevent the
  guest from changing some bits of IA32_SPEC_CTRL MSR w/o intercepting
  guest's writes to the MSR.


This solution leads to a new problem:

  Deploying BHI_DIS_S for the guest may cause unnecessary performance loss
  if the guest is using other mitigations for BHI or doesn't care BHI
  attacks at all.

To overcome this unnecessary performance loss, we want to allow the guest
to opt out of BHI_DIS_S in this case. the idea is to let the guest report
whether it is using the SW loop to KVM/QEMU. Then KVM/QEMU won't deploy
BHI_DIS_S for the guest if the SW loop isn't in use.

Intel defines a set of para-virtualized MSRs [2] for guests to report
software mitigation status. This series emulates the para-virtualized
MSRs in KVM.

Overall, the series has two parts:
1. patch 1-3: Define the KVM ABI for userspace VMMs (e.g., QEMU) to deploy
   hardware mitigations for the guest to solve the mitigation effectivenss
   problem when migrating guests across parts w/ different microarchitecture.

2. patch 4-10: Emulate virtual MSRs so that the guest can report software
   mitigation status to avoid the unnecessary performance loss.

[1] https://lore.kernel.org/all/ZH9kwlg2Ac9IER7Y@google.com/
[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html#inpage-nav-4


Chao Gao (4):
  KVM: VMX: Cache IA32_SPEC_CTRL_SHADOW field of VMCS
  KVM: nVMX: Enable SPEC_CTRL virtualizaton for vmcs02
  KVM: VMX: Cache force_spec_ctrl_value/mask for each vCPU
  KVM: VMX: Advertise MITI_ENUM_RETPOLINE_S_SUPPORT

Daniel Sneddon (1):
  KVM: VMX: Virtualize Intel IA32_SPEC_CTRL

Pawan Gupta (2):
  x86/bugs: Use Virtual MSRs to request BHI_DIS_S
  x86/bugs: Use Virtual MSRs to request RRSBA_DIS_S

Zhang Chen (3):
  KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM support
  KVM: VMX: Advertise MITIGATION_CTRL support
  KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT

 Documentation/virt/kvm/api.rst     |  39 +++++++
 arch/x86/include/asm/kvm_host.h    |   4 +
 arch/x86/include/asm/msr-index.h   |  24 +++++
 arch/x86/include/asm/vmx.h         |   5 +
 arch/x86/include/asm/vmxfeatures.h |   2 +
 arch/x86/kernel/cpu/bugs.c         |  33 ++++++
 arch/x86/kernel/cpu/common.c       |   1 +
 arch/x86/kernel/cpu/cpu.h          |   1 +
 arch/x86/kvm/svm/svm.c             |   3 +
 arch/x86/kvm/vmx/capabilities.h    |   5 +
 arch/x86/kvm/vmx/nested.c          |  30 ++++++
 arch/x86/kvm/vmx/vmx.c             | 162 +++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  21 +++-
 arch/x86/kvm/x86.c                 |  49 ++++++++-
 arch/x86/kvm/x86.h                 |   1 +
 include/uapi/linux/kvm.h           |   4 +
 16 files changed, 376 insertions(+), 8 deletions(-)


base-commit: 2c71fdf02a95b3dd425b42f28fd47fb2b1d22702
-- 
2.39.3


