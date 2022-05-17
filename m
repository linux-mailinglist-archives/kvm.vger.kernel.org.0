Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B136352A2DE
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbiEQNM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347456AbiEQNLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:11:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7653616F;
        Tue, 17 May 2022 06:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793048; x=1684329048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BSepHG6NLjphmtN4/CabMFGbJVm7iu8RDaTfkt+svNE=;
  b=C5Ontgvj0DOfXBtesznzQTh5AZyAoIt0sFNUNzOm50DRLPKO9moQXqKB
   0weefZhYF3ry5JSQeH2NyHWVezGkGAoYjFnmwDlwebvASxG8IymNKuEt4
   4vktl/hK+fxY5vjC5xkkGnLPfpy5iB3ct0//pEGkiZ3uOja4coTksru1m
   swxhBEvgJ/H/ITAhHjTsLedTySyUNlhYqYARAnIOvSVbvZjWiAi9JxsSk
   cgyQy6v2pf5fRpHBYIRf7UpilKMIUCY6g+tNWr/T8B/gp2gOe4z9T3wsI
   pPkxKbJtiKyp4Ufq1OgPhWxLnV9Y7vzZxI0Wd6Rom9fw1E17Vzzq6cw+8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="357588679"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="357588679"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844376"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:41 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 6/6] perf intel-pt: Add guest_code support
Date:   Tue, 17 May 2022 16:10:11 +0300
Message-Id: <20220517131011.6117-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517131011.6117-1-adrian.hunter@intel.com>
References: <20220517131011.6117-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A common case for KVM test programs is that the test program acts as the
hypervisor, creating, running and destroying the virtual machine, and
providing the guest object code from its own object code. In this case,
the VM is not running an OS, but only the functions loaded into it by the
hypervisor test program, and conveniently, loaded at the same virtual
addresses.

To support that, a new option "--guest-code" has been added in
previous patches.

In this patch, add support also to Intel PT.

In particular, ensure guest_code thread is set up before attempting to
walk object code or synthesize samples.

Example:

 # perf record --kcore -e intel_pt/cyc/ -- tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.280 MB perf.data ]
 # perf script --guest-code --itrace=bep --ns -F-period,+addr,+flags
 [SNIP]
   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   call                   ffffffffc13b2ff5 __vmx_vcpu_run+0x15 (vmlinux) => ffffffffc13b2f50 vmx_update_host_rsp+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   return                 ffffffffc13b2f5d vmx_update_host_rsp+0xd (vmlinux) => ffffffffc13b2ffa __vmx_vcpu_run+0x1a (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   call                   ffffffffc13b303b __vmx_vcpu_run+0x5b (vmlinux) => ffffffffc13b2f80 vmx_vmenter+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962087836:      branches:   vmentry                ffffffffc13b2f82 vmx_vmenter+0x2 (vmlinux) =>                0 [unknown] ([unknown])
   [guest/18436] 18436 [007] 10897.962087836:      branches:   vmentry                               0 [unknown] ([unknown]) =>           402c81 guest_code+0x131 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962087836:      branches:   call                             402c81 guest_code+0x131 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dba0 ucall+0x0 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962088248:      branches:   vmexit                           40dba0 ucall+0x0 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>                0 [unknown] ([unknown])
   tsc_msrs_test 18436 [007] 10897.962088248:      branches:   vmexit                                0 [unknown] ([unknown]) => ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962088248:      branches:   jmp                    ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux) => ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962088256:      branches:   return                 ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux) => ffffffffc13b3040 __vmx_vcpu_run+0x60 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962088270:      branches:   return                 ffffffffc13b30b6 __vmx_vcpu_run+0xd6 (vmlinux) => ffffffffc13b2f2e vmx_vcpu_enter_exit+0x4e (vmlinux)
 [SNIP]
   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   call                   ffffffffc13b2ff5 __vmx_vcpu_run+0x15 (vmlinux) => ffffffffc13b2f50 vmx_update_host_rsp+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   return                 ffffffffc13b2f5d vmx_update_host_rsp+0xd (vmlinux) => ffffffffc13b2ffa __vmx_vcpu_run+0x1a (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   call                   ffffffffc13b303b __vmx_vcpu_run+0x5b (vmlinux) => ffffffffc13b2f80 vmx_vmenter+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089424:      branches:   vmentry                ffffffffc13b2f82 vmx_vmenter+0x2 (vmlinux) =>                0 [unknown] ([unknown])
   [guest/18436] 18436 [007] 10897.962089424:      branches:   vmentry                               0 [unknown] ([unknown]) =>           40dba0 ucall+0x0 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962089701:      branches:   jmp                              40dc1b ucall+0x7b (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc39 ucall+0x99 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc3c ucall+0x9c (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc20 ucall+0x80 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc3c ucall+0x9c (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc20 ucall+0x80 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc37 ucall+0x97 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc50 ucall+0xb0 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
   [guest/18436] 18436 [007] 10897.962089878:      branches:   vmexit                           40dc55 ucall+0xb5 (/home/ahunter/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>                0 [unknown] ([unknown])
   tsc_msrs_test 18436 [007] 10897.962089878:      branches:   vmexit                                0 [unknown] ([unknown]) => ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089878:      branches:   jmp                    ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux) => ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089887:      branches:   return                 ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux) => ffffffffc13b3040 __vmx_vcpu_run+0x60 (vmlinux)
   tsc_msrs_test 18436 [007] 10897.962089901:      branches:   return                 ffffffffc13b30b6 __vmx_vcpu_run+0xd6 (vmlinux) => ffffffffc13b2f2e vmx_vcpu_enter_exit+0x4e (vmlinux)
 [SNIP]

 # perf kvm --guest-code --guest --host report -i perf.data --stdio | head -20

 # To display the perf.data header info, please use --header/--header-only options.
 #
 #
 # Total Lost Samples: 0
 #
 # Samples: 12  of event 'instructions'
 # Event count (approx.): 2274583
 #
 # Children      Self  Command        Shared Object         Symbol
 # ........  ........  .............  ....................  ...........................................
 #
    54.70%     0.00%  tsc_msrs_test  [kernel.vmlinux]      [k] entry_SYSCALL_64_after_hwframe
            |
            ---entry_SYSCALL_64_after_hwframe
               do_syscall_64
               |
               |--29.44%--syscall_exit_to_user_mode
               |          exit_to_user_mode_prepare
               |          task_work_run
               |          __fput

For more information about Perf tools support for Intel® Processor Trace
refer:

  https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-intel-pt.txt | 70 ++++++++++++++++++++++
 tools/perf/util/intel-pt.c                 | 20 ++++++-
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index 92532d0d3618..74370fc47246 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -1398,6 +1398,76 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Tracing Virtual Machines - Guest Code
+-------------------------------------
+
+A common case for KVM test programs is that the test program acts as the
+hypervisor, creating, running and destroying the virtual machine, and
+providing the guest object code from its own object code. In this case,
+the VM is not running an OS, but only the functions loaded into it by the
+hypervisor test program, and conveniently, loaded at the same virtual
+addresses. To support that, option "--guest-code" has been added to perf script
+and perf kvm report.
+
+Here is an example tracing a test program from the kernel's KVM selftests:
+
+ # perf record --kcore -e intel_pt/cyc/ -- tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test
+ [ perf record: Woken up 1 times to write data ]
+ [ perf record: Captured and wrote 0.280 MB perf.data ]
+ # perf script --guest-code --itrace=bep --ns -F-period,+addr,+flags
+ [SNIP]
+   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   call                   ffffffffc13b2ff5 __vmx_vcpu_run+0x15 (vmlinux) => ffffffffc13b2f50 vmx_update_host_rsp+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   return                 ffffffffc13b2f5d vmx_update_host_rsp+0xd (vmlinux) => ffffffffc13b2ffa __vmx_vcpu_run+0x1a (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962087733:      branches:   call                   ffffffffc13b303b __vmx_vcpu_run+0x5b (vmlinux) => ffffffffc13b2f80 vmx_vmenter+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962087836:      branches:   vmentry                ffffffffc13b2f82 vmx_vmenter+0x2 (vmlinux) =>                0 [unknown] ([unknown])
+   [guest/18436] 18436 [007] 10897.962087836:      branches:   vmentry                               0 [unknown] ([unknown]) =>           402c81 guest_code+0x131 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962087836:      branches:   call                             402c81 guest_code+0x131 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dba0 ucall+0x0 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962088248:      branches:   vmexit                           40dba0 ucall+0x0 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>                0 [unknown] ([unknown])
+   tsc_msrs_test 18436 [007] 10897.962088248:      branches:   vmexit                                0 [unknown] ([unknown]) => ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962088248:      branches:   jmp                    ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux) => ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962088256:      branches:   return                 ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux) => ffffffffc13b3040 __vmx_vcpu_run+0x60 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962088270:      branches:   return                 ffffffffc13b30b6 __vmx_vcpu_run+0xd6 (vmlinux) => ffffffffc13b2f2e vmx_vcpu_enter_exit+0x4e (vmlinux)
+ [SNIP]
+   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   call                   ffffffffc13b2ff5 __vmx_vcpu_run+0x15 (vmlinux) => ffffffffc13b2f50 vmx_update_host_rsp+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   return                 ffffffffc13b2f5d vmx_update_host_rsp+0xd (vmlinux) => ffffffffc13b2ffa __vmx_vcpu_run+0x1a (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089321:      branches:   call                   ffffffffc13b303b __vmx_vcpu_run+0x5b (vmlinux) => ffffffffc13b2f80 vmx_vmenter+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089424:      branches:   vmentry                ffffffffc13b2f82 vmx_vmenter+0x2 (vmlinux) =>                0 [unknown] ([unknown])
+   [guest/18436] 18436 [007] 10897.962089424:      branches:   vmentry                               0 [unknown] ([unknown]) =>           40dba0 ucall+0x0 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962089701:      branches:   jmp                              40dc1b ucall+0x7b (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc39 ucall+0x99 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc3c ucall+0x9c (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc20 ucall+0x80 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc3c ucall+0x9c (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc20 ucall+0x80 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962089701:      branches:   jcc                              40dc37 ucall+0x97 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>           40dc50 ucall+0xb0 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test)
+   [guest/18436] 18436 [007] 10897.962089878:      branches:   vmexit                           40dc55 ucall+0xb5 (/home/user/git/work/tools/testing/selftests/kselftest_install/kvm/tsc_msrs_test) =>                0 [unknown] ([unknown])
+   tsc_msrs_test 18436 [007] 10897.962089878:      branches:   vmexit                                0 [unknown] ([unknown]) => ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089878:      branches:   jmp                    ffffffffc13b2fa0 vmx_vmexit+0x0 (vmlinux) => ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089887:      branches:   return                 ffffffffc13b2fd2 vmx_vmexit+0x32 (vmlinux) => ffffffffc13b3040 __vmx_vcpu_run+0x60 (vmlinux)
+   tsc_msrs_test 18436 [007] 10897.962089901:      branches:   return                 ffffffffc13b30b6 __vmx_vcpu_run+0xd6 (vmlinux) => ffffffffc13b2f2e vmx_vcpu_enter_exit+0x4e (vmlinux)
+ [SNIP]
+
+ # perf kvm --guest-code --guest --host report -i perf.data --stdio | head -20
+
+ # To display the perf.data header info, please use --header/--header-only options.
+ #
+ #
+ # Total Lost Samples: 0
+ #
+ # Samples: 12  of event 'instructions'
+ # Event count (approx.): 2274583
+ #
+ # Children      Self  Command        Shared Object         Symbol
+ # ........  ........  .............  ....................  ...........................................
+ #
+    54.70%     0.00%  tsc_msrs_test  [kernel.vmlinux]      [k] entry_SYSCALL_64_after_hwframe
+            |
+            ---entry_SYSCALL_64_after_hwframe
+               do_syscall_64
+               |
+               |--29.44%--syscall_exit_to_user_mode
+               |          exit_to_user_mode_prepare
+               |          task_work_run
+               |          __fput
+
+
 Event Trace
 -----------
 
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index ec43d364d0de..66f23006cfff 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -192,6 +192,7 @@ struct intel_pt_queue {
 	pid_t next_tid;
 	struct thread *thread;
 	struct machine *guest_machine;
+	struct thread *guest_thread;
 	struct thread *unknown_guest_thread;
 	pid_t guest_machine_pid;
 	bool exclude_kernel;
@@ -688,6 +689,11 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
 	ptq->guest_machine = NULL;
 	thread__zput(ptq->unknown_guest_thread);
 
+	if (symbol_conf.guest_code) {
+		thread__zput(ptq->guest_thread);
+		ptq->guest_thread = machines__findnew_guest_code(machines, pid);
+	}
+
 	machine = machines__find_guest(machines, pid);
 	if (!machine)
 		return -1;
@@ -729,11 +735,16 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 	cpumode = intel_pt_nr_cpumode(ptq, *ip, nr);
 
 	if (nr) {
-		if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL ||
+		if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
 		    intel_pt_get_guest(ptq))
 			return -EINVAL;
 		machine = ptq->guest_machine;
-		thread = ptq->unknown_guest_thread;
+		thread = ptq->guest_thread;
+		if (!thread) {
+			if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL)
+				return -EINVAL;
+			thread = ptq->unknown_guest_thread;
+		}
 	} else {
 		thread = ptq->thread;
 		if (!thread) {
@@ -1300,6 +1311,7 @@ static void intel_pt_free_queue(void *priv)
 	if (!ptq)
 		return;
 	thread__zput(ptq->thread);
+	thread__zput(ptq->guest_thread);
 	thread__zput(ptq->unknown_guest_thread);
 	intel_pt_decoder_free(ptq->decoder);
 	zfree(&ptq->event_buf);
@@ -2372,6 +2384,10 @@ static int intel_pt_sample(struct intel_pt_queue *ptq)
 		ptq->sample_ipc = ptq->state->flags & INTEL_PT_SAMPLE_IPC;
 	}
 
+	/* Ensure guest code maps are set up */
+	if (symbol_conf.guest_code && (state->from_nr || state->to_nr))
+		intel_pt_get_guest(ptq);
+
 	/*
 	 * Do PEBS first to allow for the possibility that the PEBS timestamp
 	 * precedes the current timestamp.
-- 
2.25.1

