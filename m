Return-Path: <kvm+bounces-44263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE642A9C15C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DA9B1BA775E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB1523BD0F;
	Fri, 25 Apr 2025 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OejYNbDT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842B1F4CBE;
	Fri, 25 Apr 2025 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570140; cv=none; b=aX+JuNQ6QEb3v8JXMmxBrPsHO1c/giOWZpPYZmu6y1CCc8dX9u1tgbH8kHETqHgwAhN9T0oEY/xM/f9oLO3GbOQjcDbQa9P7DdgR25te5PiGvMS/3SVOxu0Xt6iXnA3bkikD+fPiIPKd+QgbZYFuGkD/X3Jtr3e2c8hQl9THXxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570140; c=relaxed/simple;
	bh=liDUQDCfZ7sS2+A9Y4oQMwKEWewLI+4MU2cKShAXLtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HABkjjfTsWA5Fzwvhvk15wc4eAfc8lfgwLsMIhAOuuNlqM2yFBCK2L8F2Tr9onDH8mtSqXLZwDdUBBZ9Hywg16L1c865VihFaWynfnVn8xi9ZIbzp8dC5BkaTnI11Qf3tSSgj7FJymaRvcJaQcNx8pbw3zQgRdH+NvSRDFuGkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=OejYNbDT; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5O2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:34:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5O2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570089;
	bh=A3b4ITZaTfXzMfE8P3NClf2sv8WJ6sa7JySmuA7pbdY=;
	h=From:To:Cc:Subject:Date:From;
	b=OejYNbDTNY7z9B258k3ak9TmvMyUbUpawFr8lLCTkwYMVfGb8YqhUrp3Z4KHs5fPj
	 my80ixwryjSADjgtbLLeYGt0L3yHPJEv3Wau8PPmxGKQDdPwP1Xvbht7Gu2n9NaQOW
	 r9knRf/PcJ8xVurhtr9sRPFMNKKB8w/PmJDV/lYlJLHUotF+ugc+6Wg/XheAMKDeDu
	 coOtH3LvRC/W3UtUcStNjIBjhI6NBGI5cYFWcYvObfXwETuZisb5epS8DGpWpQdwKV
	 ZzSnCgUoos8Ps6ZQ2mJ4kAjz3ZUWe34m74SdH0VpP2V6mtcW/fmnQms4X8fzOFGbzo
	 5n2xdLpTmFqxA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
Subject: [PATCH v3 00/14] MSR code cleanup part one
Date: Fri, 25 Apr 2025 01:34:23 -0700
Message-ID: <20250425083442.2390017-1-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch set is the first part of the patch set:

  MSR refactor with new MSR instructions support

@ https://lore.kernel.org/lkml/20250422082216.1954310-1-xin@zytor.com/T/#m5a34be7d4ed55f0baca965cb65452a08e9ad7c8a


It's getting *WAY* too big, and whether to zap the pv_ops MSR APIs is
still under argument.  Dave Hansen suggested to focus on rename stuff
first, most of which he acked.

Jürgen Groß also gave his RBs to most of the Xen MSR cleanup patches.

So here comes the first MSR cleanup patch set with version 3.


This patch series is based on:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/msr


Xin Li (Intel) (14):
  x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
  x86/msr: Remove rdpmc()
  x86/msr: Rename rdpmcl() to rdpmc()
  x86/msr: Convert the rdpmc() macro into an always inline function
  x86/msr: Return u64 consistently in Xen PMC read functions
  x86/msr: Convert __wrmsr() uses to native_wrmsr{,q}() uses
  x86/msr: Add the native_rdmsrq() helper
  x86/msr: Convert __rdmsr() uses to native_rdmsrq() uses
  x86/xen/msr: Remove calling native_{read,write}_msr{,_safe}() in
    pmu_msr_{read,write}()
  x86/xen/msr: Remove pmu_msr_{read,write}()
  x86/xen/msr: Remove the error pointer argument from set_seg()
  x86/pvops/msr: refactor pv_cpu_ops.write_msr{,_safe}()
  x86/msr: Replace wrmsr(msr, low, 0) with wrmsrq(msr, low)
  x86/msr: Change the function type of native_read_msr_safe()

 arch/x86/coco/sev/core.c                      |   2 +-
 arch/x86/events/amd/brs.c                     |   4 +-
 arch/x86/events/amd/uncore.c                  |   2 +-
 arch/x86/events/core.c                        |   2 +-
 arch/x86/events/intel/core.c                  |   4 +-
 arch/x86/events/intel/ds.c                    |   2 +-
 arch/x86/events/msr.c                         |   3 +
 arch/x86/events/perf_event.h                  |   1 +
 arch/x86/events/probe.c                       |   2 +
 arch/x86/hyperv/hv_apic.c                     |   6 +-
 arch/x86/hyperv/hv_vtl.c                      |   4 +-
 arch/x86/hyperv/ivm.c                         |   3 +-
 arch/x86/include/asm/apic.h                   |   4 +-
 arch/x86/include/asm/fred.h                   |   1 +
 arch/x86/include/asm/microcode.h              |   2 +
 arch/x86/include/asm/mshyperv.h               |   3 +-
 arch/x86/include/asm/msr.h                    | 130 +++++-------------
 arch/x86/include/asm/paravirt.h               |  57 ++++----
 arch/x86/include/asm/paravirt_types.h         |  10 +-
 arch/x86/include/asm/suspend_32.h             |   1 +
 arch/x86/include/asm/suspend_64.h             |   1 +
 arch/x86/include/asm/switch_to.h              |   4 +-
 arch/x86/include/asm/tsc.h                    |  76 +++++++++-
 arch/x86/kernel/cpu/amd.c                     |   2 +-
 arch/x86/kernel/cpu/common.c                  |  10 +-
 arch/x86/kernel/cpu/mce/core.c                |   6 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  25 ++--
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   2 +-
 arch/x86/kernel/cpu/umwait.c                  |   4 +-
 arch/x86/kernel/fpu/xstate.h                  |   1 +
 arch/x86/kernel/hpet.c                        |   1 +
 arch/x86/kernel/kvm.c                         |   2 +-
 arch/x86/kernel/kvmclock.c                    |   2 +-
 arch/x86/kernel/process_64.c                  |   1 +
 arch/x86/kernel/trace_clock.c                 |   2 +-
 arch/x86/kernel/tsc_sync.c                    |   1 +
 arch/x86/kvm/svm/svm.c                        |  34 ++---
 arch/x86/kvm/vmx/vmx.c                        |   4 +-
 arch/x86/lib/kaslr.c                          |   2 +-
 arch/x86/mm/mem_encrypt_identity.c            |   5 +-
 arch/x86/realmode/init.c                      |   1 +
 arch/x86/xen/enlighten_pv.c                   |  58 ++++----
 arch/x86/xen/pmu.c                            |  69 +++-------
 arch/x86/xen/xen-ops.h                        |   5 +-
 drivers/acpi/processor_perflib.c              |   1 +
 drivers/acpi/processor_throttling.c           |   3 +-
 drivers/cpufreq/amd-pstate-ut.c               |   2 +
 drivers/hwmon/hwmon-vid.c                     |   4 +
 drivers/net/vmxnet3/vmxnet3_drv.c             |   4 +
 drivers/platform/x86/intel/pmc/cnp.c          |   1 +
 .../intel/speed_select_if/isst_if_common.c    |   1 +
 drivers/platform/x86/intel/turbo_max_3.c      |   1 +
 52 files changed, 284 insertions(+), 294 deletions(-)


base-commit: a5447e92e169dafaf02fd653500105c7186d7128
-- 
2.49.0


