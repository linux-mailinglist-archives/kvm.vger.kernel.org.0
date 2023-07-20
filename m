Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2F75A4A4
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 05:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjGTDKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 23:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjGTDJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 23:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3282A212C
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 20:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9AD611A0
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 03:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABBA7C433CA
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 03:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689822588;
        bh=f64csE9wqHK18JreMut/RgKUAQsknncFZul9/vrSg1M=;
        h=From:To:Subject:Date:From;
        b=j6KqS2wwlsdNG4v0PmjlvQ8p7lnienWonNHQawCQI1jojjlcvF9dOW63PpKXKbmQG
         kOh5NWa+Bzx4FQ8xEw92lKlSxA35kV00eCP70VU3VVjiGY/czbjDdUgQbsmYbB/LaL
         Nx0ULW6BapWkkHOIU+Lu5cF6zWedLDo/c0MjsjTeQ8TNTmX6k6rV1yVMt8SM3nf3KW
         L+p7fGyIm4SXxHQdlWSz5/nUZ/W8zCc6nslq1u0TKszb65QKUBq2ezu4eXXjYqFJjr
         roPG35uHOTLaah30xZluY0d8eG5gGSngtCTkfm2oXMaeU8BvuQUSY6+Pz2o/sXA91U
         fgiibnf+kPyeA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9021AC53BD2; Thu, 20 Jul 2023 03:09:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217688] New: Guest call trace during boot
Date:   Thu, 20 Jul 2023 03:09:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217688-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217688

            Bug ID: 217688
           Summary: Guest call trace during boot
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: farrah.chen@intel.com
        Regression: No

Environment:

Host/guest kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
fdf0eaf11452d72945af3 6.5.0-rc2
Qemu: https://gitlab.com/qemu-project/qemu.git master 361d5397
Host/Guest OS: CentOS Stream 9
Platform: SPR/CLX

Bug detail description:=20

Create VM:
qemu-system-x86_64 -accel kvm -smp 8 -m 8192 -cpu host -machine q35 -drive
file=3Dcentos9.qcow2,if=3Dnone,id=3Dvirtio-disk0 -device
virtio-blk-pci,drive=3Dvirtio-disk0,bootindex=3D0 -daemonize -vnc :3 -device
virtio-net-pci,netdev=3Dnic0,mac=3D00:b9:f9:b2:90:72 -netdev
tap,id=3Dnic0,br=3Dvirbr0,helper=3D/usr/local/libexec/qemu-bridge-helper,vh=
ost=3Don

When VM boot, we can see below Call trace:

[    0.387684] Key type asymmetric registered
[    0.388161] Asymmetric key parser 'x509' registered
[    0.388717] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor
246)
[    0.389580] io scheduler mq-deadline registered
[    0.390097] io scheduler kyber registered
[    0.391265] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.392143] unchecked MSR access error: RDMSR from 0xe2 at rIP:
0xffffffffab090378 (native_read_msr+0x8/0x40)
[    0.393213] Call Trace:
[    0.393539]  <TASK>
[    0.393824]  ? ex_handler_msr+0x128/0x140
[    0.394327]  ? fixup_exception+0x89/0x340
[    0.394798]  ? exc_general_protection+0xdc/0x3d0
[    0.395325]  ? asm_exc_general_protection+0x26/0x30
[    0.395873]  ? __pfx_intel_idle_init+0x10/0x10
[    0.396384]  ? native_read_msr+0x8/0x40
[    0.396834]  intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
[    0.397492]  ? __pfx_intel_idle_init+0x10/0x10
[    0.397997]  intel_idle_vminit.isra.0+0xee/0x1d0
[    0.398517]  do_one_initcall+0x45/0x220
[    0.398971]  do_initcalls+0xac/0x130
[    0.399400]  kernel_init_freeable+0x128/0x1e0
[    0.399896]  ? __pfx_kernel_init+0x10/0x10
[    0.400374]  kernel_init+0x1a/0x1c0
[    0.400790]  ret_from_fork+0x31/0x50
[    0.401219]  ? __pfx_kernel_init+0x10/0x10
[    0.401692]  ret_from_fork_asm+0x1b/0x30
[    0.402151] RIP: 0000:0x0
[    0.402492] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[    0.403190] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX:
0000000000000000
[    0.404035] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[    0.404891] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[    0.405680] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[    0.406440] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[    0.407193] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[    0.407950]  </TASK>
[    0.408755] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.409622] ACPI: button: Power Button [PWRF]
[    0.410369] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.411138] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a
16550A
[    0.412241] Non-volatile memory driver v1.3
[    0.412727] Linux agpgart interface v0.103
......

Can be reproduced on latest commit bfa3037d828050 of this mainline linux.gi=
t.
And no such issue on host.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
