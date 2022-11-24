Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824566372DA
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 08:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKXHQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 02:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKXHPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 02:15:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0C260EB7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 23:24:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE13B826E3
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFDBEC433C1
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669274671;
        bh=ip1qJO4XOJajidLbsH+w+cpB0sfTeQ5Ey5+keHX4ZXM=;
        h=From:To:Subject:Date:From;
        b=E7fUceAtiHIgokpALTKOeXHpFvcsOlcsQAZlZWyS7X5D3x2euyQvc7HOLylDY4JD1
         APz29VXmJK3+AWxsy1dDWcuUfs9mipUnICM+2w69iw3tKQ475iyHuieRkEpap28/6R
         QK+9VJvR1rpkkl6fVD2LE8xFaFvaN67eaOfodrHEHiW0iMLxtY3oLSC+pq4XAhqypb
         m/no0sdkmclA/Q7UExVRkGd31snDgOafU839KdWemj73pTBMDvOH9U0fcT+GVZ+ipm
         1uVcg+NKrvtK8gQr/kelbRLhNDY+/Hp4ztQA0HhmPR/YTx6cQuy5x4lLG+/9EqgwZu
         TSxpt3sXnKzqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A7E9FC433E9; Thu, 24 Nov 2022 07:24:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216737] New: Call trace happens on guest after running pt vmx
 tool
Date:   Thu, 24 Nov 2022 07:24:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216737-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216737

            Bug ID: 216737
           Summary: Call trace happens on guest after running pt vmx tool
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.1.0-rc4
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiao.yang@intel.com
        Regression: No

Created attachment 303284
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303284&action=3Dedit
Guest dmesg log

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: 6.1.0-rc4
Guest OS: Red Hat Enterprise Linux 8.3 (Ootpa)
Guest kernel:5.19.0-rc8
gcc: gcc version 8.4.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: d72cf8ff

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 6d71357a

Bug Detailed Description:
There are call traces on guest after running pt vmx tool on guest.=20

Reproducing Steps:
1. Create a guest:
qemu-system-x86_64 -accel kvm -m 4096 -smp 4 -drive
file=3D/share/xvs/var/tmp-img_kvm_ptvmx_snapshot_1653283173,if=3Dnone,id=3D=
virtio-disk0
-device virtio-blk-pci,drive=3Dvirtio-disk0,bootindex=3D0  -cpu host -device
virtio-net-pci,netdev=3Dnic0,mac=3D00:98:31:f3:d3:59 -netdev
tap,id=3Dnic0,br=3Dvirbr0,helper=3D/usr/local/libexec/qemu-bridge-helper,vh=
ost=3Don
-monitor pty -daemonize -vnc :11024

2.Log into the guest and run pt_vmx_tool
./pt_vmx_tool/BAT-ipt

Actual Result:
Call trace happens on guest.

Expected Result:
No call trace happens on guest.

Call trace log:
[   54.937709] Call Trace:
[   54.938287]  <TASK>
[   54.938796]  intel_pmu_enable_bts+0x5c/0x70
[   54.939443]  bts_event_add+0x7b/0xa0
[   54.940036]  event_sched_in.isra.133.part.134+0x7a/0x1b0
[   54.940744]  ? sysvec_apic_timer_interrupt+0xab/0xc0
[   54.941428]  merge_sched_in+0x27e/0x4e0
[   54.942029]  visit_groups_merge.constprop.144+0x137/0x460
[   54.942739]  ctx_sched_in+0xcf/0x1e0
[   54.943315]  ctx_resched+0x54/0x90
[   54.943878]  event_function+0x95/0xe0
[   54.944454]  ? perf_duration_warn+0x30/0x30
[   54.945065]  remote_function+0x4a/0x60
[   54.945649]  generic_exec_single+0x64/0xa0
[   54.946244]  smp_call_function_single+0xbd/0x180
[   54.946883]  ? perf_duration_warn+0x30/0x30
[   54.947472]  ? visit_groups_merge.constprop.144+0x164/0x460
[   54.949322]  ? perf_mux_hrtimer_handler+0x330/0x330
[   54.949961]  ? perf_duration_warn+0x30/0x30
[   54.950545]  task_function_call+0x55/0x90
[   54.951109]  ? perf_swevent_get_recursion_context+0x70/0x70
[   54.951781]  event_function_call+0x96/0x120
[   54.952350]  ? perf_mux_hrtimer_handler+0x330/0x330
[   54.952975]  ? __perf_event_task_sched_in+0x5c/0x1d0
[   54.953638]  ? _perf_event_disable+0x50/0x50
[   54.954215]  ? _perf_event_disable+0x50/0x50
[   54.954788]  perf_event_for_each_child+0x37/0x80
[   54.955379]  ? _perf_event_disable+0x50/0x50
[   54.955944]  _perf_ioctl+0x1a6/0x840
[   54.956447]  ? __schedule+0x3fc/0x980
[   54.956960]  ? preempt_count_add+0x70/0xa0
[   54.957495]  ? _raw_spin_lock_irq+0x19/0x40
[   54.958035]  ? ptrace_stop+0x200/0x2a0
[   54.958543]  ? ptrace_do_notify+0x92/0xc0
[   54.959057]  perf_ioctl+0x43/0x70
[   54.959532]  __x64_sys_ioctl+0x89/0xc0
...
Please refer to the attached file for the complete dmesg information.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
