Return-Path: <kvm+bounces-43772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8DAA96162
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6BF93BC659
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8E225F7AC;
	Tue, 22 Apr 2025 08:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="coQSwlhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4AD259C82;
	Tue, 22 Apr 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310234; cv=none; b=T5afs59J7o9FiZoBQ39f2m6DuEdt7TR0oQ8jKsBU9Ta1gzNdOjQxPKxGVJGQxrQ7Qi4OBOfDiCPIR6jYyfr2Ub16axgA+WMrWI44Rhnvrg4aXrisBAb/Z+Z0rmDAePlK9wrmZHVpraDeEjFAsE7cBzMz522lZexiKZiJ06MbReY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310234; c=relaxed/simple;
	bh=biMi9f3PXjemBC7ffAX7zKHa41SsFQV4v7nPJOjJMZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jsKATJkmLypSCHJCWlYf8S/6agodmVLZX7KsNru2Ui08utlF+1cL5g5uy2f+295RQegkOkWxgbIisLQU9KPOJ98p/N2UtDrzj2TCEvcuIwb81mDpFikgrW3IdUJmGugot1ac5GHk6JbvIKFXBbAJ/yQmy61Ca7e3/Gb/+LX2J3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=coQSwlhZ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9E1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9E1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310142;
	bh=mYcTzU0oObhvxWiZx+iiw1dueV7yQ96m6ct2fgUgxlA=;
	h=From:To:Cc:Subject:Date:From;
	b=coQSwlhZKMasXch4vb9MccuN5lPE6K+czznn/cj5lrt8w3zCTLqPI3EvxgT/JXgLR
	 JyjiL4Jdfd1e6yDi2uLRF74KLb5HbAUDLx0QLG/V9QoskVA0B1JdssAt+3pkfAUH4L
	 HDOXgxSKh2KwOCizLlzk8+EehNeWtMVP7zozfQ2aTEAvuLwOKDLIJKJmFyE6XndVkg
	 iA+/X2cnKdqtk4yn7E856l7cmqtDR8XRCST0c8ZnAr47yysDHIB/AA6NA04jrNwZAr
	 EBPETFtsShEkDGlZrttN07OBL96YEQmtzFzBPc9HAWOPDwlfAZyYRr7G/9WrED437W
	 CowiWvGjoZBkA==
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
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions support
Date: Tue, 22 Apr 2025 01:21:41 -0700
Message-ID: <20250422082216.1954310-1-xin@zytor.com>
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

To achieve this, a code refactor is required:

Patch 1 relocates rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h> and
removes the inclusion of <asm/msr.h> in <asm/tsc.h>.  As a result,
<asm/msr.h> must now be explicitly included in several source files where
it was previously included implicitly through <asm/tsc.h>.

Patches 2 ~ 6 refactor the code to use the alternatives mechanism to read
PMC.

Patches 7 ~ 16 unify and simplify the MSR API definitions and usages.

Patches 17 ~ 19 add basic support for immediate form MSR instructions,
e.g., its CPU feature bit and opcode.

Patch 20 adds a new exception type to allow a function call inside an
alternative for instruction emulation to "kick back" the exception into
the alternatives pattern, possibly invoking a different exception handling
pattern there, or at least indicating the "real" location of the fault.

patches 21 and 22 refactor the code to use the alternatives mechanism to
read and write MSR.

Patches 23 ~ 34 are afterwards cleanups.


H. Peter Anvin (Intel) (1):
  x86/extable: Implement EX_TYPE_FUNC_REWIND

Xin Li (Intel) (33):
  x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
  x86/msr: Remove rdpmc()
  x86/msr: Rename rdpmcl() to rdpmcq()
  x86/msr: Convert rdpmcq() into a function
  x86/msr: Return u64 consistently in Xen PMC read functions
  x86/msr: Use the alternatives mechanism to read PMC
  x86/msr: Convert __wrmsr() uses to native_wrmsr{,q}() uses
  x86/msr: Convert a native_wrmsr() use to native_wrmsrq()
  x86/msr: Add the native_rdmsrq() helper
  x86/msr: Convert __rdmsr() uses to native_rdmsrq() uses
  x86/msr: Remove calling native_{read,write}_msr{,_safe}() in
    pmu_msr_{read,write}()
  x86/msr: Remove pmu_msr_{read,write}()
  x86/xen/msr: Remove the error pointer argument from set_reg()
  x86/msr: refactor pv_cpu_ops.write_msr{_safe}()
  x86/msr: Replace wrmsr(msr, low, 0) with wrmsrq(msr, low)
  x86/msr: Change function type of native_read_msr_safe()
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  x86/opcode: Add immediate form MSR instructions
  x86/extable: Add support for immediate form MSR instructions
  x86/msr: Utilize the alternatives mechanism to write MSR
  x86/msr: Utilize the alternatives mechanism to read MSR
  x86/extable: Remove new dead code in ex_handler_msr()
  x86/mce: Use native MSR API __native_{wr,rd}msrq()
  x86/msr: Rename native_wrmsrq() to native_wrmsrq_no_trace()
  x86/msr: Rename native_wrmsr() to native_wrmsr_no_trace()
  x86/msr: Rename native_write_msr() to native_wrmsrq()
  x86/msr: Rename native_write_msr_safe() to native_wrmsrq_safe()
  x86/msr: Rename native_rdmsrq() to native_rdmsrq_no_trace()
  x86/msr: Rename native_rdmsr() to native_rdmsr_no_trace()
  x86/msr: Rename native_read_msr() to native_rdmsrq()
  x86/msr: Rename native_read_msr_safe() to native_rdmsrq_safe()
  x86/msr: Move the ARGS macros after the MSR read/write APIs
  x86/msr: Convert native_rdmsr_no_trace() uses to
    native_rdmsrq_no_trace() uses

 arch/x86/boot/startup/sme.c                   |   5 +-
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
 arch/x86/hyperv/ivm.c                         |   7 +-
 arch/x86/include/asm/apic.h                   |   4 +-
 arch/x86/include/asm/asm.h                    |   6 +
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/extable_fixup_types.h    |   1 +
 arch/x86/include/asm/fred.h                   |   3 +-
 arch/x86/include/asm/microcode.h              |  10 +-
 arch/x86/include/asm/mshyperv.h               |   3 +-
 arch/x86/include/asm/msr.h                    | 637 ++++++++++++------
 arch/x86/include/asm/paravirt.h               |  78 ---
 arch/x86/include/asm/paravirt_types.h         |  13 -
 arch/x86/include/asm/sev-internal.h           |   9 +-
 arch/x86/include/asm/spec-ctrl.h              |   2 +-
 arch/x86/include/asm/suspend_32.h             |   1 +
 arch/x86/include/asm/suspend_64.h             |   1 +
 arch/x86/include/asm/switch_to.h              |   4 +-
 arch/x86/include/asm/tsc.h                    |  76 ++-
 arch/x86/kernel/cpu/amd.c                     |   2 +-
 arch/x86/kernel/cpu/common.c                  |  10 +-
 arch/x86/kernel/cpu/mce/core.c                |  61 +-
 arch/x86/kernel/cpu/microcode/amd.c           |  10 +-
 arch/x86/kernel/cpu/microcode/core.c          |   4 +-
 arch/x86/kernel/cpu/microcode/intel.c         |   8 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  25 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   2 +-
 arch/x86/kernel/cpu/scattered.c               |   1 +
 arch/x86/kernel/cpu/umwait.c                  |   4 +-
 arch/x86/kernel/fpu/xstate.h                  |   1 +
 arch/x86/kernel/hpet.c                        |   1 +
 arch/x86/kernel/kvm.c                         |   2 +-
 arch/x86/kernel/kvmclock.c                    |   2 +-
 arch/x86/kernel/paravirt.c                    |   5 -
 arch/x86/kernel/process_64.c                  |   1 +
 arch/x86/kernel/trace_clock.c                 |   2 +-
 arch/x86/kernel/tsc_sync.c                    |   1 +
 arch/x86/kvm/svm/svm.c                        |  34 +-
 arch/x86/kvm/vmx/vmx.c                        |  12 +-
 arch/x86/lib/kaslr.c                          |   2 +-
 arch/x86/lib/x86-opcode-map.txt               |   5 +-
 arch/x86/mm/extable.c                         | 181 +++--
 arch/x86/realmode/init.c                      |   1 +
 arch/x86/xen/enlighten_pv.c                   | 112 ++-
 arch/x86/xen/pmu.c                            |  63 +-
 arch/x86/xen/xen-asm.S                        | 113 ++++
 arch/x86/xen/xen-ops.h                        |  14 +-
 drivers/acpi/processor_perflib.c              |   1 +
 drivers/acpi/processor_throttling.c           |   3 +-
 drivers/cpufreq/amd-pstate-ut.c               |   2 +
 drivers/hwmon/hwmon-vid.c                     |   4 +
 drivers/net/vmxnet3/vmxnet3_drv.c             |   6 +-
 .../intel/speed_select_if/isst_if_common.c    |   1 +
 drivers/platform/x86/intel/turbo_max_3.c      |   1 +
 tools/arch/x86/lib/x86-opcode-map.txt         |   5 +-
 64 files changed, 988 insertions(+), 605 deletions(-)


base-commit: f30a0c0d2b08b355c01392538de8fc872387cb2b
-- 
2.49.0


