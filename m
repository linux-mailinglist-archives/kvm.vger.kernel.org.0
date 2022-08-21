Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C160259B29B
	for <lists+kvm@lfdr.de>; Sun, 21 Aug 2022 09:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiHUHhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiHUHhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 03:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9D23BD0
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 00:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C0360BFE
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 07:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E88F1C433D7
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 07:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661067429;
        bh=AOEWVvNh0IyLD1RVJIQzaTC1Z348j9A8XtfoM5krQKw=;
        h=From:To:Subject:Date:From;
        b=S/BZKse1iMg3OhBOFC9sv3XPZ9xFx+GqyPBPVQFkCw6Y5aTt76w3SDiF0z+0R32jc
         +x2+vhEbRVx8e9DNQ93wephFuQ2tFO1je+RpKDpkT0xz/xYwZtzM1ORGv8MxMdtPph
         SHVuhmpcXKTDWWyMg/eOM6aFYg+hoa3UndKMJ2ZSuA/rUlsq4XE5o3bbEHwY3nhIG9
         qG4gpyM7o2nycIzDriN/oQGyjImMy3s0noCSTN/4+gXF6BQIX8Y5hUSHSqe6Q+tbp3
         N6+Eqo/x8atgo76QVs1mUo1rJ5sAin44bLG/7lp7EWdq3TfEdQvdiwVMxqgaATQdt/
         GMCDW/oo14foQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CCBCAC433E9; Sun, 21 Aug 2022 07:37:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] New: On Host, kernel errors in KVM, on guests, it shows
 CPU stalls
Date:   Sun, 21 Aug 2022 07:37:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

            Bug ID: 216388
           Summary: On Host, kernel errors in KVM, on guests, it shows CPU
                    stalls
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.19.0 / 5.19.1 / 5.19.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: nanook@eskimo.com
        Regression: No

Created attachment 301614
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301614&action=3Dedit
The configuration file used to Comile this kernel.

This behavior has persisted across 5.19.0, 5.19.1, and 5.19.2.  While the
kernel I am taking this example from is tainted (owing to using Intel
development drivers for GPU virtualization), it is also occurring on
non-tainted kernels on servers with no development or third party modules
installed.

INFO: task CPU 2/KVM:2343 blocked for more than 1228 seconds.
[207177.050049]       Tainted: G     U    I       5.19.2 #1
[207177.050050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[207177.050051] task:CPU 2/KVM       state:D stack:    0 pid: 2343 ppid:   =
  1
flags:0x00000002
[207177.050054] Call Trace:
[207177.050055]  <TASK>
[207177.050056]  __schedule+0x359/0x1400
[207177.050060]  ? kvm_mmu_page_fault+0x1ee/0x980
[207177.050062]  ? kvm_set_msr_common+0x31f/0x1060
[207177.050065]  schedule+0x5f/0x100
[207177.050066]  schedule_preempt_disabled+0x15/0x30
[207177.050068]  __mutex_lock.constprop.0+0x4e2/0x750
[207177.050070]  ? aa_file_perm+0x124/0x4f0
[207177.050071]  __mutex_lock_slowpath+0x13/0x20
[207177.050072]  mutex_lock+0x25/0x30
[207177.050075]  intel_vgpu_emulate_mmio_read+0x5d/0x3b0 [kvmgt]
[207177.050084]  intel_vgpu_rw+0xb8/0x1c0 [kvmgt]
[207177.050091]  intel_vgpu_read+0x20d/0x250 [kvmgt]
[207177.050097]  vfio_device_fops_read+0x1f/0x40
[207177.050100]  vfs_read+0x9b/0x160
[207177.050102]  __x64_sys_pread64+0x93/0xd0
[207177.050104]  do_syscall_64+0x58/0x80
[207177.050106]  ? kvm_on_user_return+0x84/0xe0
[207177.050107]  ? fire_user_return_notifiers+0x37/0x70
[207177.050109]  ? exit_to_user_mode_prepare+0x41/0x200
[207177.050111]  ? syscall_exit_to_user_mode+0x1b/0x40
[207177.050112]  ? do_syscall_64+0x67/0x80
[207177.050114]  ? irqentry_exit+0x54/0x70
[207177.050115]  ? sysvec_call_function_single+0x4b/0xa0
[207177.050116]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[207177.050118] RIP: 0033:0x7ff51131293f
[207177.050119] RSP: 002b:00007ff4ddffa260 EFLAGS: 00000293 ORIG_RAX:
0000000000000011
[207177.050121] RAX: ffffffffffffffda RBX: 00005599a6835420 RCX:
00007ff51131293f
[207177.050122] RDX: 0000000000000004 RSI: 00007ff4ddffa2a8 RDI:
0000000000000027
[207177.050123] RBP: 0000000000000004 R08: 0000000000000000 R09:
00000000ffffffff
[207177.050124] R10: 0000000000065f10 R11: 0000000000000293 R12:
0000000000065f10
[207177.050124] R13: 00005599a6835330 R14: 0000000000000004 R15:
0000000000065f10
[207177.050126]  </TASK>

     I am seeing this on Intel i7-6700k, i7-6850k, and i7-9700k platforms.

     This did not happen on 5.17 kernels, and 5.18 kernels never ran stable
enough on my platforms to actually run them for more than a few minutes.

     Likewise 6.0-rc1 has not been stable enough to run in production.  Aft=
er
less than three hours running on my workstation it locked hard with even the
magic sys-request key being unresponsive and only power cycling the machine=
 got
it back.

     The operating system in use for the host on all machines is Ubuntu 22.=
04.

     Guests vary with Ubuntu 22.04 being the most common but also Mint, Deb=
ian,
Manjaro, Centos, Fedora, ScientificLinux, Zorin, and Windows being in use.

     I see the same issue manifest on platforms running only Ubuntu guests =
as
with guests of varying operating systems.=20=20

     The configuration file I used to compile this kernel is attached.  I
compiled it with gcc 12.1.0.

     This behavior does not manifest itself instantly, typically the machine
needs to be running 3-7 days before it does.  Once it does guests keep stal=
ling
and restarting libvirtd does not help.  Only thing that seems to is a hard
reboot of the physical host.  For this reason I believe the issue lies stri=
ctly
with the host and not the guests.

     I have listed it as a severity of high since it is completely service
interrupting.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
