Return-Path: <kvm+bounces-42239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB14A761F9
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFE2A167D8C
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614491EB5F0;
	Mon, 31 Mar 2025 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OnHXAiC9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B73F1E882F;
	Mon, 31 Mar 2025 08:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409464; cv=none; b=TWcS+vU4nlhDCZUvwJHbYBGtbkGem2qlqJqBZ5pPgodinJtQe+gZMRlVQpIy5TD+1sC1rmU/YNf630SF7FUtAgCXSGkpB9YoUnud04PkQM8m/+RPtEKWQ8jBGVT37Hcn/br/9kXbxxxD/VlIhz621GtIw3E8rinkP82w3r8i77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409464; c=relaxed/simple;
	bh=Cby37SG2DpHxgTqq3lgoJ+EC3eGF0uFSXmj9Op+ZdcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gTlDiOEuWsWWDc/qWPTHGl9B21poBEPKqG4XwLolt3nYXs427QUhhHxCObfHdKChy++uRpy7owlNTmQLj5lc0pFGwFqj0KZoRHAHNHGlJZ0HCetJXwn/i6L9HT79gmC0hSc2bIb2DuJxra2m2Pcnq+2HNOO33xD2JpyTAE3voJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=OnHXAiC9; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp003171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:22:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp003171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409380;
	bh=c4mcztnFt3iWZUjta5DXg4eheqI37Lh6HqidwU3OGSY=;
	h=From:To:Cc:Subject:Date:From;
	b=OnHXAiC9aSEzd0WpdrjoHSGZ04PCiEeIv62hkaEXPnx8evimLF7vpw0m7zz3VzHAt
	 hDuVc4dghG43y+jsV+a7Qfx20Ng9DHzGpu8XsE0uIkomgEmFYL/K1tnjvzIxsjKA4M
	 Jmbxizi87C0PeKt7ohivxxIv0jnlvkyUQ9sNKdDbevgpXy1tk7W9PyoTsHjecZxvs2
	 aVQVkmqox4yIzWpZCAHpOgStdzq0qcj13XEqjfbZbCPUeEsVftd405OaQn09xyGuCx
	 rSayuzUgrw2M+BWzbnfHvv62mRW+cXcdQf8/qP5CIkCNwAjzjH0U7W5kYlhj6Xy0BH
	 xAje3DGcgV+zw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 00/15] MSR refactor with new MSR instructions support
Date: Mon, 31 Mar 2025 01:22:36 -0700
Message-ID: <20250331082251.3171276-1-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Obviously the existing MSR code and the pv_ops MSR access APIs need some
love: https://lore.kernel.org/lkml/87y1h81ht4.ffs@tglx/

hpa has started a discussion about how to refactor it last October:
https://lore.kernel.org/lkml/7a4de623-ecda-4369-a7ae-0c43ef328177@zytor.com/

The consensus so far is to utilize the alternatives mechanism to eliminate
the Xen MSR access overhead on native systems and enable new MSR instructions
based on their availability.

To achieve this, a code refactor is necessary.  Initially, the MSR API usage
needs to be unified and simplified, which is addressed by patches 1 through 7.

Patches 8 and 9 introduce basic support for immediate form MSR instructions,
while patch 10 employs the immediate form WRMSRNS in VMX.

Finally, patches 11 to 15 leverage the alternatives mechanism to read and
write MSR.


H. Peter Anvin (Intel) (1):
  x86/extable: Implement EX_TYPE_FUNC_REWIND

Xin Li (Intel) (14):
  x86/msr: Replace __wrmsr() with native_wrmsrl()
  x86/msr: Replace __rdmsr() with native_rdmsrl()
  x86/msr: Simplify pmu_msr_{read,write}()
  x86/msr: Let pv_cpu_ops.write_msr{_safe}() take an u64 instead of two
    u32
  x86/msr: Replace wrmsr(msr, low, 0) with wrmsrl(msr, value)
  x86/msr: Remove MSR write APIs that take the MSR value in two u32
    arguments
  x86/msr: Remove pmu_msr_{read,write}()
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  x86/opcode: Add immediate form MSR instructions to x86-opcode-map
  KVM: VMX: Use WRMSRNS or its immediate form when available
  x86/msr: Use the alternatives mechanism to write MSR
  x86/msr: Use the alternatives mechanism to read MSR
  x86/extable: Add support for the immediate form MSR instructions
  x86/msr: Move the ARGS macros after the MSR read/write APIs

 arch/x86/coco/sev/core.c                   |   2 +-
 arch/x86/events/amd/brs.c                  |   4 +-
 arch/x86/hyperv/hv_apic.c                  |   6 +-
 arch/x86/hyperv/hv_vtl.c                   |   4 +-
 arch/x86/hyperv/ivm.c                      |   2 +-
 arch/x86/include/asm/apic.h                |   4 +-
 arch/x86/include/asm/asm.h                 |   6 +
 arch/x86/include/asm/cpufeatures.h         |  19 +-
 arch/x86/include/asm/extable_fixup_types.h |   1 +
 arch/x86/include/asm/fred.h                |   2 +-
 arch/x86/include/asm/mshyperv.h            |   2 +-
 arch/x86/include/asm/msr-index.h           |   6 +
 arch/x86/include/asm/msr.h                 | 664 ++++++++++++++++-----
 arch/x86/include/asm/paravirt.h            |  64 --
 arch/x86/include/asm/paravirt_types.h      |  11 -
 arch/x86/include/asm/switch_to.h           |   2 +-
 arch/x86/kernel/cpu/amd.c                  |   2 +-
 arch/x86/kernel/cpu/common.c               |  10 +-
 arch/x86/kernel/cpu/mce/core.c             |   6 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c  |  12 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c     |   2 +-
 arch/x86/kernel/cpu/scattered.c            |   1 +
 arch/x86/kernel/cpu/umwait.c               |   4 +-
 arch/x86/kernel/kvm.c                      |   2 +-
 arch/x86/kernel/kvmclock.c                 |   2 +-
 arch/x86/kernel/paravirt.c                 |   4 -
 arch/x86/kvm/svm/svm.c                     |  15 +-
 arch/x86/kvm/vmx/vmenter.S                 |  28 +-
 arch/x86/kvm/vmx/vmx.c                     |   4 +-
 arch/x86/lib/x86-opcode-map.txt            |   5 +-
 arch/x86/mm/extable.c                      | 186 ++++--
 arch/x86/mm/mem_encrypt_identity.c         |   4 +-
 arch/x86/xen/enlighten_pv.c                | 110 ++--
 arch/x86/xen/pmu.c                         |  43 +-
 arch/x86/xen/xen-asm.S                     |  89 +++
 arch/x86/xen/xen-ops.h                     |  12 +-
 drivers/ata/pata_cs5535.c                  |  12 +-
 drivers/ata/pata_cs5536.c                  |   6 +-
 drivers/cpufreq/acpi-cpufreq.c             |   2 +-
 drivers/cpufreq/e_powersaver.c             |   2 +-
 drivers/cpufreq/powernow-k6.c              |   8 +-
 tools/arch/x86/lib/x86-opcode-map.txt      |   5 +-
 42 files changed, 896 insertions(+), 479 deletions(-)


base-commit: 8fc8ae1aeed6dc895bf35a4797c6e770574f4612
-- 
2.49.0


