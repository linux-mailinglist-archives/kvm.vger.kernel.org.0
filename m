Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B02F665146
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 02:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjAKBwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 20:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjAKBwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 20:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E887B6163
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 17:52:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A15FCB81A6A
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 500AEC433D2
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673401962;
        bh=PRWRQlu7g9TlSoF6FCBN42YjmVN43cRAI7cKQ9me5i4=;
        h=From:To:Subject:Date:From;
        b=FU41P0tZJq52v7fjVevCt/AEvAb4IwjyJXGlCn3XYfe2/fJ46UzgeTx7tYyWm/hNL
         eExTiz95iCx1svYo94VmisGr0DsOFTk3j+s5WSPIYzOCqc0NnPnNZe9Fg53P/5H60S
         OQorXAZh4SV0iXCxhOBTnG32+yyCSbD8ty4doTDfOVR+8INCwOhhLPD4xXgYlisEue
         JFvaNwfW0SaXeR/HzKyOUT+LOCpun/9A8Z5pR9YTOryeyRhdKHNgxBHwix8Dqv4J+y
         e9reAZkM6MajDlY0dJZ1pZxhhppy+KPYcN8xSX4TyoQ0bs6SI91rpZb47fHj/uURX9
         51R2Bz4mNGgyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3969BC43141; Wed, 11 Jan 2023 01:52:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216910] New: Test Assertion failure in kvm selftest rseq_test
Date:   Wed, 11 Jan 2023 01:52:41 +0000
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
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216910-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216910

            Bug ID: 216910
           Summary: Test Assertion failure in kvm selftest rseq_test
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.1
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

Environment:
Processor: Intel(R) Xeon(R) Platinum 8487C (Sapphire Rapids)
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 9 (Ootpa)
Host kernel: Linux 6.1 release
gcc: gcc (GCC) 11.2.1 20220127 (Red Hat 11.2.1-9)
Host kernel source:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Branch: master
Commit: 830b3c68

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 5204b499

Bug Detailed Description:
Test assertion failure happens in kvm selftest rseq_test on the linux 6.1
release kernel.=20

=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
=C2=A0 rseq_test.c:268: i > (NR_TASK_MIGRATIONS / 2)
=C2=A0 pid=3D867071 tid=3D867071 errno=3D4 - Interrupted system call
=C2=A0 =C2=A0 =C2=A01 =C2=A00x000000000040281d: main at rseq_test.c:268
=C2=A0 =C2=A0 =C2=A02 =C2=A00x00007f8ef9444e4f: ?? ??:0
=C2=A0 =C2=A0 =C2=A03 =C2=A00x00007f8ef9444efb: ?? ??:0
=C2=A0 =C2=A0 =C2=A04 =C2=A00x00000000004028b4: _start at ??:?
=C2=A0 Only performed 2511 KVM_RUNs, task stalled too much?


Reproducing Steps:

git clone=C2=A0https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/lin=
ux.git
cd linux && git checkout v6.1 && make headers_install
cd tools/testing/selftests/kvm && make
./rseq_test

Actual Result:
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
=C2=A0 rseq_test.c:268: i > (NR_TASK_MIGRATIONS / 2)
=C2=A0 pid=3D867071 tid=3D867071 errno=3D4 - Interrupted system call
=C2=A0 =C2=A0 =C2=A01 =C2=A00x000000000040281d: main at rseq_test.c:268
=C2=A0 =C2=A0 =C2=A02 =C2=A00x00007f8ef9444e4f: ?? ??:0
=C2=A0 =C2=A0 =C2=A03 =C2=A00x00007f8ef9444efb: ?? ??:0
=C2=A0 =C2=A0 =C2=A04 =C2=A00x00000000004028b4: _start at ??:?
=C2=A0 Only performed 2511 KVM_RUNs, task stalled too much?


Expected Result:
Successfully executed

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
