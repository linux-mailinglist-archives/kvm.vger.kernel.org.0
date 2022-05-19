Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75FC52E0E8
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 01:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbiESXxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiESXxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 19:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B571128174
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BFF0B82944
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 23:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD1B5C34114
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 23:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653004398;
        bh=5y3kG79cgm+2BWkGSkjlBs9ipPlJTH5/AhD2/3APqdg=;
        h=From:To:Subject:Date:From;
        b=Ak9QLq1vFzQ4+fTyLa5zy+UqBexaSYL2bS2eFluMoOpvKBJcuAtE+Ycb849ZKCabF
         dBxEiHyCaolN3kDuXZ+8F9HOqxZ014aHMhgmSCIsz8jV6G1MOV4MMdJWEKTlxcbWaw
         +2Dcc3gI+OzsTwsTVMKPnz9Eo351+IxMZAjzCg4f56A1gqcUe2XeZyWSpPxNpfA8Rp
         2aAZnt9ZUpYV+BhSkM0JBe9bf6W0N5txfS1aTzStF70db52XIUwyXqvezLbN7y+BqA
         /qUi4RlwijqWo1w8y6DCU0o/1dx0PsEXThx8YTkrZ2UqX27O1RCgv5M8FcDFvvLEnx
         /UT/kSttvi/xw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C203FCC13B2; Thu, 19 May 2022 23:53:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216002] New: When a break point is set, nested virtualization
 sees "kvm_queue_exception: Assertion `!env->exception_has_payload' failed."
Date:   Thu, 19 May 2022 23:53:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216002-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216002

            Bug ID: 216002
           Summary: When a break point is set, nested virtualization sees
                    "kvm_queue_exception: Assertion
                    `!env->exception_has_payload' failed."
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.6-200.fc35.x86_64
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ercli@ucdavis.edu
        Regression: No

Created attachment 301001
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301001&action=3Dedit
Archive file that contains 1.img and 2.img

One configuration that reproduces this bug:
CPU model: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
Host kernel version: 5.17.6-200.fc35.x86_64
Host kernel arch: x86_64
Guest: I am running a microhypervisor called XMHF. It is 32-bits. I am using
the microhypervisor to launch a nested guest OS I wrote myself, called LHV.
This bug still exists if using -machine kernel_irqchip=3Doff
It is impossible to test this bug with -accel tcg, because TCG does not sup=
port
nested virtualization.

How to reproduce:

This bug happens when the guest is debugged. So first start GDB:
gdb --ex 'target remote :::1234' --ex 'hb *0' --ex c
The command above will simply set a break point in the guest. The address of
the break point (0 in this case) is arbitrary

Then, in another shell, run QEMU:
qemu-system-i386 -m 512M -gdb tcp::1234 -smp 2 -cpu Haswell,vmx=3Dyes -enab=
le-kvm
-serial stdio -drive media=3Ddisk,file=3D1.img,index=3D1 -drive
media=3Ddisk,file=3D2.img,index=3D2

1.img and 2.img are attached as a.tar.xz in this bug report. If interested,
1.img's source code is
https://github.com/lxylxy123456/uberxmhf/tree/a8610d2f9e69263c014b5e48270e4=
2690b73b85d
. 2.img's source code is
https://github.com/lxylxy123456/uberxmhf/tree/10afe107cbeadb1c4dbe7f9b8e41c=
2a50c47bda5
.

After running QEMU and GDB above, XMHF and LHV will print a lot of messages=
 in
the serial port:

...
CPU #0: vcpu_vaddr_ptr=3D0x01e06080, esp=3D0x01e11000
CPU #1: vcpu_vaddr_ptr=3D0x01e06540, esp=3D0x01e15000
BSP(0x00): Rallying APs...
BSP(0x00): APs ready, doing DRTM...
LAPIC base and status=3D0xfee00900
Sending INIT IPI to all APs...

Then I see an assertion error:

qemu-system-i386: ../target/i386/kvm/kvm.c:645: kvm_queue_exception: Assert=
ion
`!env->exception_has_payload' failed.

Expected result: KVM should not crash. The behavior should be the same as if
only the QEMU runs (i.e. GDB does not run)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
