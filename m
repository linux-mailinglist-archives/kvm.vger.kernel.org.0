Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8985D77CE8E
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbjHOOzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 10:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbjHOOzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 10:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F871E6B
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 07:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D9063EAE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2720FC433C8
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692111322;
        bh=IRGfJfwDMItxnyqualierd4b+UPqlvgPJShKck+SG8A=;
        h=From:To:Subject:Date:From;
        b=FJMFZQ4QFTIj4pxEHdCVnPWTlBUvXwAnDLGTjvlxMfWEZ0siQ3mu0oIPO85nG/B2O
         e2uyy33+EuVKlSJsmM+eupo3h47vOBkGC89Sfz+rv9NaWciVzltgejpQCmMzvXLgO8
         Yub4NYeyxKZ61gR/TvePZHm+vFC7Cj8Lh6fehKt+5vvqaDfrgaHvNV8xCQ+WpTLFQ9
         Tb3TuB4Y0UZcHctKfWh5OEZLcdfS/mDVDVCjmEvjFoeete9ZTMjzVYkrRz90GV2/bO
         vRXAaGbeS0+0jufBg7F8HXwIQ7Wa7r6NhWcZRwI2AzG+uWaB9Sxf1qkZHv1RUWeerJ
         CoZci8nSHVYKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0F67CC53BD3; Tue, 15 Aug 2023 14:55:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217796] New: latest Zen Inception fixes breaks nested kvm
 virtualization on AMD
Date:   Tue, 15 Aug 2023 14:55:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sonst+kernel@o-oberst.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217796-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217796

            Bug ID: 217796
           Summary: latest Zen Inception fixes breaks nested kvm
                    virtualization on AMD
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: blocking
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: sonst+kernel@o-oberst.de
        Regression: No

Hi all,

today I updated to 6.4.10 on arch linux. This broke my setup with running a=
 KVM
nested virtualization within a KVM VM. Problem seems kernel update related =
not
distribution specific since others report same issue on a totally different
setup:
https://forum.proxmox.com/threads/amd-incpetion-fixes-cause-qemu-kvm-memory=
-leak.132057/#post-581207

Issue:=20
1. Start KVM vm ("hostVM") with 60GB memory assigned -> all works.
2. within that hostVM I start a nestedVM with 5GB memory assigned.
3. Memory consumption of the quemu process within the hostVM goes beyond
available memory. Then the nestedVM gets OOM killed before even being start=
ed
using more than the 60GB + Swap.

I tried to setup fresh nestedVMs with no luck, same problem.

Reverting to an earlier kernel (6.4.7 on arch linux) lets everything work
again.

host kernel: 6.4.10-arch1 (this induces the problems, rest was unchanged)=20
hostVM kernel: 5.15.107+truenas
nestedVM kernel: 5.15.0-78-generic

Logs from the hostVM when OOM happens:

Aug 15 10:59:41 truenas kernel: CPU 0/KVM invoked oom-killer:
gfp_mask=3D0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), order=3D0, oom_score_ad=
j=3D0
Aug 15 10:59:42 truenas kernel: CPU: 9 PID: 7079 Comm: CPU 0/KVM Tainted: P=
=20=20=20=20
      OE     5.15.107+truenas #1
Aug 15 10:59:43 truenas kernel: Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS unknown 2/2/2022
Aug 15 10:59:43 truenas kernel: Call Trace:
Aug 15 10:59:43 truenas kernel:  <TASK>
Aug 15 10:59:43 truenas kernel:  dump_stack_lvl+0x46/0x5e
Aug 15 10:59:43 truenas kernel:  dump_header+0x4a/0x1f4
Aug 15 10:59:43 truenas kernel:  oom_kill_process.cold+0xb/0x10
Aug 15 10:59:43 truenas kernel:  out_of_memory+0x1bd/0x4f0
Aug 15 10:59:43 truenas kernel:  __alloc_pages_slowpath.constprop.0+0xc30/0=
xd00
Aug 15 10:59:44 truenas kernel:  __alloc_pages+0x1e9/0x220
Aug 15 10:59:44 truenas kernel:  __get_free_pages+0xd/0x40
Aug 15 10:59:44 truenas kernel:  kvm_mmu_topup_memory_cache+0x56/0x80 [kvm]
Aug 15 10:59:44 truenas kernel:  mmu_topup_memory_caches+0x39/0x70 [kvm]
Aug 15 10:59:44 truenas kernel:  direct_page_fault+0x3d9/0xbb0 [kvm]
Aug 15 10:59:44 truenas kernel:  ?
kvm_mtrr_check_gfn_range_consistency+0x61/0x120 [kvm]
Aug 15 10:59:44 truenas kernel:  kvm_mmu_page_fault+0x7a/0x730 [kvm]
Aug 15 10:59:44 truenas kernel:  ? ktime_get+0x38/0xa0
Aug 15 10:59:44 truenas kernel:  ? lock_timer_base+0x61/0x80
Aug 15 10:59:44 truenas kernel:  ? __svm_vcpu_run+0x5f/0xf0 [kvm_amd]
Aug 15 10:59:44 truenas kernel:  ? __svm_vcpu_run+0x59/0xf0 [kvm_amd]
Aug 15 10:59:44 truenas kernel:  ? __svm_vcpu_run+0xaa/0xf0 [kvm_amd]
Aug 15 10:59:44 truenas kernel:  ? load_fixmap_gdt+0x22/0x30
Aug 15 10:59:44 truenas kernel:  ? native_load_tr_desc+0x67/0x70
Aug 15 10:59:44 truenas kernel:  ? x86_virt_spec_ctrl+0x43/0xb0
Aug 15 10:59:44 truenas kernel:  kvm_arch_vcpu_ioctl_run+0xbff/0x1750 [kvm]
Aug 15 10:59:44 truenas kernel:  kvm_vcpu_ioctl+0x278/0x660 [kvm]
Aug 15 10:59:44 truenas kernel:  ? __seccomp_filter+0x385/0x5c0
Aug 15 10:59:44 truenas kernel:  __x64_sys_ioctl+0x8b/0xc0
Aug 15 10:59:44 truenas kernel:  do_syscall_64+0x3b/0xc0
Aug 15 10:59:44 truenas kernel:  entry_SYSCALL_64_after_hwframe+0x61/0xcb
Aug 15 10:59:44 truenas kernel: RIP: 0033:0x7f29eee166b7
Aug 15 10:59:45 truenas kernel: Code: Unable to access opcode bytes at RIP
0x7f29eee1668d.
Aug 15 10:59:45 truenas kernel: RSP: 002b:00007f27f35fd4c8 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
Aug 15 10:59:45 truenas kernel: RAX: ffffffffffffffda RBX: 000000000000ae80
RCX: 00007f29eee166b7
Aug 15 10:59:45 truenas kernel: RDX: 0000000000000000 RSI: 000000000000ae80
RDI: 0000000000000015
Aug 15 10:59:45 truenas kernel: RBP: 00005558a87d3f00 R08: 00005558a7e52848
R09: 00005558a827c580
Aug 15 10:59:45 truenas kernel: R10: 0000000000000000 R11: 0000000000000246
R12: 0000000000000000
Aug 15 10:59:45 truenas kernel: R13: 00005558a8298bc0 R14: 00007f27f35fd780
R15: 0000000000802000
Aug 15 10:59:45 truenas kernel:  </TASK>
Aug 15 10:59:45 truenas kernel: Mem-Info:

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
