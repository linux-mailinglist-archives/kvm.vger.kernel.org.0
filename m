Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBF753700B
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 08:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiE2Gnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 02:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiE2Gnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 02:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E8CABF6B
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 23:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F2AAB8094F
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 06:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE2C4C3411D
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 06:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653806612;
        bh=w8oOUjTSWIrlKyGElnv+eCBRW97aijmjwkAlbQHn4PQ=;
        h=From:To:Subject:Date:From;
        b=eKb1IrqxGkgnq5uwOa2nlAGiUZxsW/iq8L3shQAIKWfKVHwRcZyId31mrKr/SAabv
         6yeQbM8vP/cL0HcdlMsThvJLRk/QP2ejwJeNTQYQGAZQAu6tKwZlYMxDVb4ndOzMDF
         flk43uz+KPGs9A4MWzbExqSFGeKkmaQQHJ0TuQa6FWnEpPuP2tGUnvypaz1ZqU/C3w
         qVPSUE5YGxT2zA0x4npTHMr/Ieosj1tIJCI0rSGzrT+8kklHTbEp22tu2Rwbhnrls2
         kevWNLQk9Dc4THGOWIsMWi+/hPhySo4d9YfS2/VbYPFjHqPUUrRBbuZkeedIoOYhlV
         joGz58XEHkTNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BCD46C05FD5; Sun, 29 May 2022 06:43:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216046] New: KVM_BUG_ON(vmx->nested.nested_run_pending,
 vcpu->kvm) when booting nested guest Windows 7 on another disk
Date:   Sun, 29 May 2022 06:43:32 +0000
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
Message-ID: <bug-216046-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216046

            Bug ID: 216046
           Summary: KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm)
                    when booting nested guest Windows 7 on another disk
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.8-200.fc35.x86_64
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

Created attachment 301072
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301072&action=3Dedit
Guest hypervisor to reproduce this bug (xz compressed)

Reproducible host configuration 1:
    CPU model: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
    Host kernel version: 5.17.8-200.fc35.x86_64

Reproducible host configuration 2:
    CPU model: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
    Host kernel version: 5.17.9

Host kernel arch: x86_64
Guest: a micro-hypervisor (called XMHF, 64-bits), which runs Windows 7 or
Windows 10 BIOS mode boot loader (32-bits).
QEMU command line: qemu-system-x86_64 -m 512M -cpu Haswell,vmx=3Dyes -enabl=
e-kvm
-serial stdio -drive media=3Ddisk,file=3Dc.img,index=3D1 -drive
media=3Ddisk,file=3Dw.img,index=3D2
This bug still exists if using -machine kernel_irqchip=3Doff
This problem cannot be tested with -accel tcg , because the guest requires
nested virtualization

How to reproduce:

1. Install Windows 7 or Windows 10 in QEMU. Use MBR and BIOS (i.e. do not u=
se
GPT and UEFI). For example, I installed Windows on a 32G disk, and it resul=
ts
in around 3 partitions: 50M, 31.5G (this is C:), 450M. Only the MBR header
(around 1 M) and the 50M disk is needed. For example,
https://drive.google.com/uc?id=3D1mLvKsPSuLbeckwcdnavnQMu8QxOwvX29 can be u=
sed to
reproduce this bug. Suppose Windows is installed in w.img.

2. Obtain c.img. c.img (8M) is uploaded at
https://drive.google.com/uc?id=3D1g3c9KMAoh_Yvb9bzSuOBMG5L-2VX6twU . It is =
also
compressed as c.img.xz and uploaded with this bug. It is built from
https://github.com/lxylxy123456/uberxmhf/tree/ab7968ed8017f4397808186252663=
6f75c80a3b7
.

3. Start QEMU using the command line above.

4. BIOS will boot the micro-hypervisor (XMHF), then XMHF boots Windows as a
guest. After a little bit see error:

error: kvm run failed Input/output error
EAX=3D00000020 EBX=3D0000ffff ECX=3D00000000 EDX=3D0000ffff
ESI=3D00000000 EDI=3D00002300 EBP=3D00000000 ESP=3D00006d8c
EIP=3D00000018 EFL=3D00000046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SMM=3D0 HLT=
=3D0
ES =3Df000 000f0000 ffffffff 00809300
CS =3Dcb00 000cb000 ffffffff 00809b00
SS =3D0000 00000000 ffffffff 00809300
DS =3D0000 00000000 ffffffff 00809300
FS =3D0000 00000000 ffffffff 00809300
GS =3D0000 00000000 ffffffff 00809300
LDT=3D0000 00000000 0000ffff 00008200
TR =3D0000 00000000 0000ffff 00008b00
GDT=3D     00000000 00000000
IDT=3D     00000000 000003ff
CR0=3D00000010 CR2=3D00000000 CR3=3D00000000 CR4=3D00000000
DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000=20
DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
EFER=3D0000000000000000
Code=3D0e 07 31 c0 b9 00 10 8d 3e 00 03 fc f3 ab 07 b8 20 00 e7 7e <cb> 0f =
1f 80
00 00 00 00 6b 76 6d 20 61 50 69 43 20 00 00 00 2d 02 00 00 d9 02 00 00 00 =
03
KVM_GET_CLOCK failed: Input/output error
Aborted (core dumped)

After doing some print debugging on "Reproducible host configuration 2", wi=
th
Linux kernel version 5.17.9, I get the call stack of this bug

QEMU: ioctl(..., KVM_RUN, ...)
  kvm_vcpu_ioctl()
    kvm_arch_vcpu_ioctl_run()
      vcpu_run()
        vcpu_enter_guest()
          vmx_handle_exit() (static_call(kvm_x86_handle_exit))
            __vmx_handle_exit()
              KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm)

That is, line 6038 in __vmx_handle_exit() is reached with
vmx->nested.nested_run_pending =3D 1

  6032          /*
  6033           * KVM should never reach this point with a pending nested
VM-Enter.
  6034           * More specifically, short-circuiting VM-Entry to emulate =
L2
due to
  6035           * invalid guest state should never happen as that means KVM
knowingly
  6036           * allowed a nested VM-Enter with an invalid vmcs12.  More
below.
  6037           */
  6038          if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
  6039                  return -EIO;

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
