Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D827E669164
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 09:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbjAMInW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 03:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbjAMInM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 03:43:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2C9718BC
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 00:43:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 602A0B820AD
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 08:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0581CC433D2
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673599381;
        bh=VWqFn2nrQ1VOr4bktq8hfDgfkve6UGFejZrigHJqfmY=;
        h=From:To:Subject:Date:From;
        b=TGpT7gep9UQMVbpoplrQJjgP1B/+xsavkDM1hDJrObiPOUqfNBuWc51lNU9r2E0Sp
         ohHHqUKfkH844mMsTE9Y3tkXSqkunOvlKKuMZJMhWhzhg/HdRrtwluzIojh7wotAuH
         NE0cyVWk9kRzKnlqHYKsqwCcLFnA3y6HI1W9Uj0OD1hBa1LlgxguOnmC5z85h/F87R
         J0NpvG92XJqWKn8C6IvmxgYdbOtm/2jghr9ku3HykdZ54jU4/LadlNS2FounzYbc3T
         gaSGBIVNsXEdO9apCL78If0d4DZx2+JOrz0C4xcwkIPCmKmRdEiCDCo2nL6TCeobx/
         8we5tnPKoU+FQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E3690C43144; Fri, 13 Jan 2023 08:43:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216923] New: kvm-unit-test pmu_pebs is skipped on SPR
Date:   Fri, 13 Jan 2023 08:43:00 +0000
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
Message-ID: <bug-216923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216923

            Bug ID: 216923
           Summary: kvm-unit-test pmu_pebs is skipped on SPR
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
Platform: Intel(R) Xeon(R) Platinum 8487C (Sapphire Rapids)
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

kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: 7cefda524604fe1138333315ce06224d4d864dab

Bug Detailed Description:
kvm-unit-test pmu_pebs is skipped on the linux 6.1 release kernel on Sapphi=
re
Rapids. PEBS should be supported on SPR. However, the kvm-unit-test pmu_peb=
s is
skipped on SPR with linux 6.1 release kernel. In addition, kvm-unit-test
pmu_pebs can pass on Ice Lake rather than being skipped.=20


Reproducing Steps:

git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
cd kvm-unit-tests
./configure
make standalone
cd tests
./pmu_pebs

Actual Result:
BUILD_HEAD=3D7cefda52
timeout -k 1s --foreground 90s /usr/local/bin/qemu-system-x86_64 --no-reboot
-nodefaults -device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=
=3D0x4
-vnc none -serial stdio -device pci-testdev -machine accel=3Dkvm -kernel
/tmp/tmp.6qzCjJnrIy -smp 1 -cpu host,migratable=3Dno # -initrd
/tmp/tmp.yEVIxAWSsB
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 =3D 80010011
cr3 =3D 1007000
cr4 =3D 20
PMU version: 2
SKIP: PEBS not enumerated in PERF_CAPABILITIES
SUMMARY: 1 tests, 1 skipped
SKIP pmu_pebs (1 tests, 1 skipped)


Expected Result:
pmu_pebs successfully executed

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
