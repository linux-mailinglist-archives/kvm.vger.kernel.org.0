Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D2659451
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 04:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiL3DCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 22:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiL3DCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 22:02:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3AC11C3A
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 19:02:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B33A61903
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 03:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 903DEC433F0
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 03:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672369341;
        bh=aZ/paawf4oEAD1jvm3aSdE59opcZ8VYyx9SgW7XrDN4=;
        h=From:To:Subject:Date:From;
        b=dbWQFKEvZgjsuh1wdM5wnFFp+W2m8IIihW+S13rdRmKtxum5aTw5FSotuRGF6U4vx
         /SEAHpQ2/BVrQmCyELf46fa3mocAXOpC0u+8ZLLLL+fjs6yW3B5vl2CaaXEqKUhSfB
         6ogUNKruRNUWkF4vzYE3PtiCbyPkmlxP85qkJo1TulJPu2QcaeBp60aui0eaImwjtH
         eusBs43iJzNQ2nyG58iTAP4CyjQONmzWtL5GMy4S8yTPnv2FARApfAxIL6xUmd439d
         PeEo3XRtpPI7jRy7WY90NynhGqaQhGj57qjExCxFm3CDx643F8wWO0Zh2rJE4xEq/J
         c5SxctWRH/Ecw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 74BB3C43142; Fri, 30 Dec 2022 03:02:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216867] New: KVM instruction emulation breaks LOCK instruction
 atomicity when CMPXCHG fails
Date:   Fri, 30 Dec 2022 03:02:21 +0000
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
Message-ID: <bug-216867-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216867

            Bug ID: 216867
           Summary: KVM instruction emulation breaks LOCK instruction
                    atomicity when CMPXCHG fails
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.0.14-300.fc37.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ercli@ucdavis.edu
        Regression: No

Created attachment 303502
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303502&action=3Dedit
c.img.xz: Guest software to reproduce this bug (xz compressed)

Host CPU model: 11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
Host kernel version: 6.0.14-300.fc37.x86_64
Host kernel arch: x86_64
Guest: a system level software (called LHV) I wrote myself, 32-bits, compre=
ssed
and attached as c.img.xz.
QEMU command line: qemu-system-i386 -m 256M -smp 4 -enable-kvm -serial stdio
-drive media=3Ddisk,file=3Dc.img
The problem does not go away if using -machine kernel_irqchip=3Doff
The problem goes away if -accel tcg is used (also remove -enable-kvm)

Actual behavior: serial port shows a few lines, then stops. Example:

...
counts: count0  count1  count2  count0-count1+count2
counts: 1       0       1       0
counts: 2       1       1       0
counts: 3       2       1       0
counts: 4       2       3       -1
counts: 5       3       4       -2
counts: 6       3       5       -2
counts: 7       4       6       -3
counts: 8       4       7       -3
counts: 9       4       8       -3
counts: 10      5       8       -3
(no more outputs due to deadlock)

Usually the output is shorter. Sometimes only the table header.

Expected behaivor (reproducible using TCG): serial port shows:

...
counts: count0  count1  count2  count0-count1+count2
counts: 1       0       1       0
counts: 2       1       1       0
counts: 3       1       2       0
counts: 4       2       2       0
counts: 5       2       3       0
counts: 6       3       3       0
counts: 7       3       4       0
counts: 8       4       4       0
counts: 9       5       4       0
counts: 10      5       5       0
counts: 11      5       6       0
counts: 12      6       6       0
counts: 13      7       6       0
...

Explanation:

See the following for source code, line 5 - 89:

https://github.com/lxylxy123456/uberxmhf/blob/b5935eaf8aab38ce1933da1c1be22=
dcf1b992eaf/xmhf/src/xmhf-core/xmhf-runtime/xmhf-startup/lhv.c#L5

My code performs the following experiment repeatedly on 3 CPUs:

* Initially, "ptr" at address 0xb8000 (VGA memory mapped I/O) is set to 0
* CPU 0 writes 0x12345678 to ptr, then increases counter "count0".
* In an infinite loop, CPU 1 tries exchanges ptr with register EAX (contain=
s 0)
using the XCHG instruction. If CPU 1 sees 0x12345678, it increases counter
"count1".
* CPU 2's behavior is similar to CPU 1, except it increases counter "count2"
when it sees 0x12345678.

Ideally, after each experiment there should always be count1 + count2 =3D c=
ount0.
However, in KVM, there may be count1 + count2 > count0. This because CPU 0
writes 0x12345678 to ptr once, but CPU 1 and CPU 2 both get 0x12345678 in X=
CHG.
Note that XCHG instruction always implements the locking protocol.

There is also a deadlock after running the experiment a few times. However =
I am
not trying to explain it for now.

Guessed cause:

I guess that KVM emulates the XCHG instruction that accesses 0xb8000. The c=
all
stack should be:

...
 x86_emulate_instruction (arch/x86/kvm/x86.c)
  x86_emulate_insn (arch/x86/kvm/emulate.c)
   writeback (arch/x86/kvm/emulate.c)
    segmented_cmpxchg (arch/x86/kvm/emulate.c)
     emulator_cmpxchg_emulated (arch/x86/kvm/x86.c, ->cmpxchg_emulated)
      emulator_try_cmpxchg_user (arch/x86/kvm/x86.c)
       ...
        CMPXCHG instruction

Suppose CPU 2 wants to write 0 to ptr using writeback(), and expecting ptr =
to
already contain 0x13245678. However, CPU 1 changes the content of ptr to 0.=
 So
* The CMPXCHG instruction fails (clears ZF).
* emulator_try_cmpxchg_user returns 1.
* emulator_cmpxchg_emulated() returns X86EMUL_CMPXCHG_FAILED.
* segmented_cmpxchg() returns X86EMUL_CMPXCHG_FAILED.
* writeback() returns X86EMUL_CMPXCHG_FAILED.
* x86_emulate_insn() returns EMULATION_OK.

Thus, I think the root cause of this bug is that x86_emulate_insn() ignores=
 the
X86EMUL_CMPXCHG_FAILED error. The correct behavior should be retrying the
emulation using the updated value (similar to load-linked/store-conditional=
).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
