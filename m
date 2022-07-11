Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20F56FEA6
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiGKKPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiGKKOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:14:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE9F4A805;
        Mon, 11 Jul 2022 02:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532060; x=1689068060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhOZnrZkpdD/wEulNmHvLSUQTHGhe1tBM3jqlZF2saU=;
  b=HG72V0/J7iyV/KnFsSq+0msQCiPjMWChLUXQqDtdAjMW8caND2KKd0Ph
   oYCAbMiVJmpG7sNqxzYkdNCOV2K4PqSNUKH5T6uGZnMj2qhbrValqO1w1
   CMzlDALsX0HNQxyHXc8Vmt4OxC2g05GpfHTTvirT937OFac20ZLX+UMlP
   ahJO20pBKhpPAKlYUAH620xIobe7/9/lHZAwMqqhJ00zL2DytyC2iMXm4
   aWgP5lS/U+wmPcxsU/pUQVbNeUSrxZmMvVyrmfhH6oNlRe4o1eSIIv8I+
   v+aOJazblLS7sUvYus5ncF5tzPxdTd4LebvSbl76+yKTjcTUjGwxJ0upq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371764"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371764"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:34:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387317"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:34:01 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 35/35] perf intel-pt: Add documentation for tracing guest machine user space
Date:   Mon, 11 Jul 2022 12:32:18 +0300
Message-Id: <20220711093218.10967-36-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711093218.10967-1-adrian.hunter@intel.com>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now it is possible to decode a host Intel PT trace including guest machine
user space, add documentation for the steps needed to do it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-intel-pt.txt | 181 ++++++++++++++++++++-
 1 file changed, 177 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index 238ab9d3cb93..3dc3f0ccbd51 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -267,7 +267,7 @@ Note that, as with all events, the event is suffixed with event modifiers:
 	H	host
 	p	precise ip
 
-'h', 'G' and 'H' are for virtualization which is not supported by Intel PT.
+'h', 'G' and 'H' are for virtualization which are not used by Intel PT.
 'p' is also not relevant to Intel PT.  So only options 'u' and 'k' are
 meaningful for Intel PT.
 
@@ -1218,10 +1218,10 @@ XED
 include::build-xed.txt[]
 
 
-Tracing Virtual Machines
-------------------------
+Tracing Virtual Machines (kernel only)
+--------------------------------------
 
-Currently, only kernel tracing is supported and only with either "timeless" decoding
+Currently, kernel tracing is supported with either "timeless" decoding
 (i.e. no TSC timestamps) or VM Time Correlation. VM Time Correlation is an extra step
 using 'perf inject' and requires unchanging VMX TSC Offset and no VMX TSC Scaling.
 
@@ -1400,6 +1400,179 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Tracing Virtual Machines (including user space)
+-----------------------------------------------
+
+It is possible to use perf record to record sideband events within a virtual machine, so that an Intel PT trace on the host can be decoded.
+Sideband events from the guest perf.data file can be injected into the host perf.data file using perf inject.
+
+Here is an example of the steps needed:
+
+On the guest machine:
+
+Check that no-kvmclock kernel command line option was used to boot:
+
+Note, this is essential to enable time correlation between host and guest machines.
+
+ $ cat /proc/cmdline
+ BOOT_IMAGE=/boot/vmlinuz-5.10.0-16-amd64 root=UUID=cb49c910-e573-47e0-bce7-79e293df8e1d ro no-kvmclock
+
+There is no BPF support at present so, if possible, disable JIT compiling:
+
+ $ echo 0 | sudo tee /proc/sys/net/core/bpf_jit_enable
+ 0
+
+Start perf record to collect sideband events:
+
+ $ sudo perf record -o guest-sideband-testing-guest-perf.data --sample-identifier --buildid-all --switch-events --kcore -a -e dummy
+
+On the host machine:
+
+Start perf record to collect Intel PT trace:
+
+Note, the host trace will get very big, very fast, so the steps from starting to stopping the host trace really need to be done so that they happen in the shortest time possible.
+
+ $ sudo perf record -o guest-sideband-testing-host-perf.data -m,64M --kcore -a -e intel_pt/cyc/
+
+On the guest machine:
+
+Run a small test case, just 'uname' in this example:
+
+ $ uname
+ Linux
+
+On the host machine:
+
+Stop the Intel PT trace:
+
+ ^C
+ [ perf record: Woken up 1 times to write data ]
+ [ perf record: Captured and wrote 76.122 MB guest-sideband-testing-host-perf.data ]
+
+On the guest machine:
+
+Stop the Intel PT trace:
+
+ ^C
+ [ perf record: Woken up 1 times to write data ]
+ [ perf record: Captured and wrote 1.247 MB guest-sideband-testing-guest-perf.data ]
+
+And then copy guest-sideband-testing-guest-perf.data to the host (not shown here).
+
+On the host machine:
+
+With the 2 perf.data recordings, and with their ownership changed to the user.
+
+Identify the TSC Offset:
+
+ $ perf inject -i guest-sideband-testing-host-perf.data --vm-time-correlation=dry-run
+ VMCS: 0x103fc6  TSC Offset 0xfffffa6ae070cb20
+ VMCS: 0x103ff2  TSC Offset 0xfffffa6ae070cb20
+ VMCS: 0x10fdaa  TSC Offset 0xfffffa6ae070cb20
+ VMCS: 0x24d57c  TSC Offset 0xfffffa6ae070cb20
+
+Correct Intel PT TSC timestamps for the guest machine:
+
+ $ perf inject -i guest-sideband-testing-host-perf.data --vm-time-correlation=0xfffffa6ae070cb20 --force
+
+Identify the guest machine PID:
+
+ $ perf script -i guest-sideband-testing-host-perf.data --no-itrace --show-task-events | grep KVM
+       CPU 0/KVM     0 [000]     0.000000: PERF_RECORD_COMM: CPU 0/KVM:13376/13381
+       CPU 1/KVM     0 [000]     0.000000: PERF_RECORD_COMM: CPU 1/KVM:13376/13382
+       CPU 2/KVM     0 [000]     0.000000: PERF_RECORD_COMM: CPU 2/KVM:13376/13383
+       CPU 3/KVM     0 [000]     0.000000: PERF_RECORD_COMM: CPU 3/KVM:13376/13384
+
+Note, the QEMU option -name debug-threads=on is needed so that thread names
+can be used to determine which thread is running which VCPU as above. libvirt seems to use this by default.
+
+Create a guestmount, assuming the guest machine is 'vm_to_test':
+
+ $ mkdir -p ~/guestmount/13376
+ $ sshfs -o direct_io vm_to_test:/ ~/guestmount/13376
+
+Inject the guest perf.data file into the host perf.data file:
+
+Note, due to the guestmount option, guest object files and debug files will be copied into the build ID cache from the guest machine, with the notable exception of VDSO.
+If needed, VDSO can be copied manually in a fashion similar to that used by the perf-archive script.
+
+ $ perf inject -i guest-sideband-testing-host-perf.data -o inj --guestmount ~/guestmount --guest-data=guest-sideband-testing-guest-perf.data,13376,0xfffffa6ae070cb20
+
+Show an excerpt from the result.  In this case the CPU and time range have been to chosen to show interaction between guest and host when 'uname' is starting to run on the guest machine:
+
+Notes:
+
+	- the CPU displayed, [002] in this case, is always the host CPU
+	- events happening in the virtual machine start with VM:13376 VCPU:003, which shows the hypervisor PID 13376 and the VCPU number
+	- only calls and errors are displayed i.e. --itrace=ce
+	- branches entering and exiting the virtual machine are split, and show as 2 branches to/from "0 [unknown] ([unknown])"
+
+ $ perf script -i inj --itrace=ce -F+machine_pid,+vcpu,+addr,+pid,+tid,-period --ns --time 7919.408803365,7919.408804631 -C 2
+       CPU 3/KVM 13376/13384 [002]  7919.408803365:      branches:  ffffffffc0f8ebe0 vmx_vcpu_enter_exit+0xc0 ([kernel.kallsyms]) => ffffffffc0f8edc0 __vmx_vcpu_run+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803365:      branches:  ffffffffc0f8edd5 __vmx_vcpu_run+0x15 ([kernel.kallsyms]) => ffffffffc0f8eca0 vmx_update_host_rsp+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803365:      branches:  ffffffffc0f8ee1b __vmx_vcpu_run+0x5b ([kernel.kallsyms]) => ffffffffc0f8ed60 vmx_vmenter+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803461:      branches:  ffffffffc0f8ed62 vmx_vmenter+0x2 ([kernel.kallsyms]) =>                0 [unknown] ([unknown])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408803461:      branches:                 0 [unknown] ([unknown]) =>     7f851c9b5a5c init_cacheinfo+0x3ac (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408803567:      branches:      7f851c9b5a5a init_cacheinfo+0x3aa (/usr/lib/x86_64-linux-gnu/libc-2.31.so) =>                0 [unknown] ([unknown])
+       CPU 3/KVM 13376/13384 [002]  7919.408803567:      branches:                 0 [unknown] ([unknown]) => ffffffffc0f8ed80 vmx_vmexit+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803596:      branches:  ffffffffc0f6619a vmx_vcpu_run+0x26a ([kernel.kallsyms]) => ffffffffb2255c60 x86_virt_spec_ctrl+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803801:      branches:  ffffffffc0f66445 vmx_vcpu_run+0x515 ([kernel.kallsyms]) => ffffffffb2290b30 native_write_msr+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803850:      branches:  ffffffffc0f661f8 vmx_vcpu_run+0x2c8 ([kernel.kallsyms]) => ffffffffc1092300 kvm_load_host_xsave_state+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803850:      branches:  ffffffffc1092327 kvm_load_host_xsave_state+0x27 ([kernel.kallsyms]) => ffffffffc1092220 kvm_load_host_xsave_state.part.0+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803862:      branches:  ffffffffc0f662cf vmx_vcpu_run+0x39f ([kernel.kallsyms]) => ffffffffc0f63f90 vmx_recover_nmi_blocking+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803862:      branches:  ffffffffc0f662e9 vmx_vcpu_run+0x3b9 ([kernel.kallsyms]) => ffffffffc0f619a0 __vmx_complete_interrupts+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803872:      branches:  ffffffffc109cfb2 vcpu_enter_guest+0x752 ([kernel.kallsyms]) => ffffffffc0f5f570 vmx_handle_exit_irqoff+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803881:      branches:  ffffffffc109d028 vcpu_enter_guest+0x7c8 ([kernel.kallsyms]) => ffffffffb234f900 __srcu_read_lock+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803897:      branches:  ffffffffc109d06f vcpu_enter_guest+0x80f ([kernel.kallsyms]) => ffffffffc0f72e30 vmx_handle_exit+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803897:      branches:  ffffffffc0f72e3d vmx_handle_exit+0xd ([kernel.kallsyms]) => ffffffffc0f727c0 __vmx_handle_exit+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803897:      branches:  ffffffffc0f72b15 __vmx_handle_exit+0x355 ([kernel.kallsyms]) => ffffffffc0f60ae0 vmx_flush_pml_buffer+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803903:      branches:  ffffffffc0f72994 __vmx_handle_exit+0x1d4 ([kernel.kallsyms]) => ffffffffc10b7090 kvm_emulate_cpuid+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803903:      branches:  ffffffffc10b70f1 kvm_emulate_cpuid+0x61 ([kernel.kallsyms]) => ffffffffc10b6e10 kvm_cpuid+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803941:      branches:  ffffffffc10b7125 kvm_emulate_cpuid+0x95 ([kernel.kallsyms]) => ffffffffc1093110 kvm_skip_emulated_instruction+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803941:      branches:  ffffffffc109311f kvm_skip_emulated_instruction+0xf ([kernel.kallsyms]) => ffffffffc0f5e180 vmx_get_rflags+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803951:      branches:  ffffffffc109312a kvm_skip_emulated_instruction+0x1a ([kernel.kallsyms]) => ffffffffc0f5fd30 vmx_skip_emulated_instruction+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803951:      branches:  ffffffffc0f5fd79 vmx_skip_emulated_instruction+0x49 ([kernel.kallsyms]) => ffffffffc0f5fb50 skip_emulated_instruction+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803956:      branches:  ffffffffc0f5fc68 skip_emulated_instruction+0x118 ([kernel.kallsyms]) => ffffffffc0f6a940 vmx_cache_reg+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803964:      branches:  ffffffffc0f5fc11 skip_emulated_instruction+0xc1 ([kernel.kallsyms]) => ffffffffc0f5f9e0 vmx_set_interrupt_shadow+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803980:      branches:  ffffffffc109f8b1 vcpu_run+0x71 ([kernel.kallsyms]) => ffffffffc10ad2f0 kvm_cpu_has_pending_timer+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803980:      branches:  ffffffffc10ad2fb kvm_cpu_has_pending_timer+0xb ([kernel.kallsyms]) => ffffffffc10b0490 apic_has_pending_timer+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803991:      branches:  ffffffffc109f899 vcpu_run+0x59 ([kernel.kallsyms]) => ffffffffc109c860 vcpu_enter_guest+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803993:      branches:  ffffffffc109cd4c vcpu_enter_guest+0x4ec ([kernel.kallsyms]) => ffffffffc0f69140 vmx_prepare_switch_to_guest+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803996:      branches:  ffffffffc109cd7d vcpu_enter_guest+0x51d ([kernel.kallsyms]) => ffffffffb234f930 __srcu_read_unlock+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803996:      branches:  ffffffffc109cd9c vcpu_enter_guest+0x53c ([kernel.kallsyms]) => ffffffffc0f609b0 vmx_sync_pir_to_irr+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408803996:      branches:  ffffffffc0f60a6d vmx_sync_pir_to_irr+0xbd ([kernel.kallsyms]) => ffffffffc10adc20 kvm_lapic_find_highest_irr+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804010:      branches:  ffffffffc0f60abd vmx_sync_pir_to_irr+0x10d ([kernel.kallsyms]) => ffffffffc0f60820 vmx_set_rvi+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804019:      branches:  ffffffffc109ceca vcpu_enter_guest+0x66a ([kernel.kallsyms]) => ffffffffb2249840 fpregs_assert_state_consistent+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804021:      branches:  ffffffffc109cf10 vcpu_enter_guest+0x6b0 ([kernel.kallsyms]) => ffffffffc0f65f30 vmx_vcpu_run+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804024:      branches:  ffffffffc0f6603b vmx_vcpu_run+0x10b ([kernel.kallsyms]) => ffffffffb229bed0 __get_current_cr3_fast+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804024:      branches:  ffffffffc0f66055 vmx_vcpu_run+0x125 ([kernel.kallsyms]) => ffffffffb2253050 cr4_read_shadow+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804030:      branches:  ffffffffc0f6608d vmx_vcpu_run+0x15d ([kernel.kallsyms]) => ffffffffc10921e0 kvm_load_guest_xsave_state+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804030:      branches:  ffffffffc1092207 kvm_load_guest_xsave_state+0x27 ([kernel.kallsyms]) => ffffffffc1092110 kvm_load_guest_xsave_state.part.0+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804032:      branches:  ffffffffc0f660c6 vmx_vcpu_run+0x196 ([kernel.kallsyms]) => ffffffffb22061a0 perf_guest_get_msrs+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804032:      branches:  ffffffffb22061a9 perf_guest_get_msrs+0x9 ([kernel.kallsyms]) => ffffffffb220cda0 intel_guest_get_msrs+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804039:      branches:  ffffffffc0f66109 vmx_vcpu_run+0x1d9 ([kernel.kallsyms]) => ffffffffc0f652c0 clear_atomic_switch_msr+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804040:      branches:  ffffffffc0f66119 vmx_vcpu_run+0x1e9 ([kernel.kallsyms]) => ffffffffc0f73f60 intel_pmu_lbr_is_enabled+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804042:      branches:  ffffffffc0f73f81 intel_pmu_lbr_is_enabled+0x21 ([kernel.kallsyms]) => ffffffffc10b68e0 kvm_find_cpuid_entry+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804045:      branches:  ffffffffc0f66454 vmx_vcpu_run+0x524 ([kernel.kallsyms]) => ffffffffc0f61ff0 vmx_update_hv_timer+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804057:      branches:  ffffffffc0f66142 vmx_vcpu_run+0x212 ([kernel.kallsyms]) => ffffffffc10af100 kvm_wait_lapic_expire+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804057:      branches:  ffffffffc0f66156 vmx_vcpu_run+0x226 ([kernel.kallsyms]) => ffffffffb2255c60 x86_virt_spec_ctrl+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804057:      branches:  ffffffffc0f66161 vmx_vcpu_run+0x231 ([kernel.kallsyms]) => ffffffffc0f8eb20 vmx_vcpu_enter_exit+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804057:      branches:  ffffffffc0f8eb44 vmx_vcpu_enter_exit+0x24 ([kernel.kallsyms]) => ffffffffb2353e10 rcu_note_context_switch+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804057:      branches:  ffffffffb2353e1c rcu_note_context_switch+0xc ([kernel.kallsyms]) => ffffffffb2353db0 rcu_qs+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804066:      branches:  ffffffffc0f8ebe0 vmx_vcpu_enter_exit+0xc0 ([kernel.kallsyms]) => ffffffffc0f8edc0 __vmx_vcpu_run+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804066:      branches:  ffffffffc0f8edd5 __vmx_vcpu_run+0x15 ([kernel.kallsyms]) => ffffffffc0f8eca0 vmx_update_host_rsp+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804066:      branches:  ffffffffc0f8ee1b __vmx_vcpu_run+0x5b ([kernel.kallsyms]) => ffffffffc0f8ed60 vmx_vmenter+0x0 ([kernel.kallsyms])
+       CPU 3/KVM 13376/13384 [002]  7919.408804162:      branches:  ffffffffc0f8ed62 vmx_vmenter+0x2 ([kernel.kallsyms]) =>                0 [unknown] ([unknown])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804162:      branches:                 0 [unknown] ([unknown]) =>     7f851c9b5a5c init_cacheinfo+0x3ac (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804273:      branches:      7f851cb7c0e4 _dl_init+0x74 (/usr/lib/x86_64-linux-gnu/ld-2.31.so) =>     7f851cb7bf50 call_init.part.0+0x0 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804526:      branches:      55e0c00136f0 _start+0x0 (/usr/bin/uname) => ffffffff83200ac0 asm_exc_page_fault+0x0 ([kernel.kallsyms])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804526:      branches:  ffffffff83200ac3 asm_exc_page_fault+0x3 ([kernel.kallsyms]) => ffffffff83201290 error_entry+0x0 ([kernel.kallsyms])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804534:      branches:  ffffffff832012fa error_entry+0x6a ([kernel.kallsyms]) => ffffffff830b59a0 sync_regs+0x0 ([kernel.kallsyms])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804631:      branches:  ffffffff83200ad9 asm_exc_page_fault+0x19 ([kernel.kallsyms]) => ffffffff830b8210 exc_page_fault+0x0 ([kernel.kallsyms])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804631:      branches:  ffffffff830b82a4 exc_page_fault+0x94 ([kernel.kallsyms]) => ffffffff830b80e0 __kvm_handle_async_pf+0x0 ([kernel.kallsyms])
+ VM:13376 VCPU:003            uname  3404/3404  [002]  7919.408804631:      branches:  ffffffff830b80ed __kvm_handle_async_pf+0xd ([kernel.kallsyms]) => ffffffff830b80c0 kvm_read_and_reset_apf_flags+0x0 ([kernel.kallsyms])
+
+
 Tracing Virtual Machines - Guest Code
 -------------------------------------
 
-- 
2.25.1

