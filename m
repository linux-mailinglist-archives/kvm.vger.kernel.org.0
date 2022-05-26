Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3073D534987
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 05:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbiEZDyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 23:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344872AbiEZDy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 23:54:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54448BDA2A
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 20:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 192E7B81EDB
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4E17C34116
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653537263;
        bh=3MgDOKmjZcNbqsE5QzxqimmCMdVPHRC0E8qWwgoYNyA=;
        h=From:To:Subject:Date:From;
        b=F3jvwNVgEqFY/f0XHcNVDbCvySyQ8EJq7RcBgTQk2G2LVjrTEcvgK+xpFHYfTmbs1
         eTpDuLqJAjsVHzl2hZTRwsgofYvxY9rfS+u4U7F71s9bG7BDv99bhpjvO93nd/O4/j
         D78JqUrxmTk97tjjCKRK08RYxTbpt21uAOsR9tvtBFs336TKmcJ7YYVUx1xAE9Zd6Y
         /w6qgsY1pLsX3CCbiw9Dve15JJVFwmtIwbQeIIef4YviXPsnUT/CQzwBR5IH16NQ/R
         3Vn2oWmblB0Pdsv/pyLVK0c62U/7Nfn4rWP8Lmf0acqLBDaaSTqhiJhn6GOuiWM3op
         llTvBQzdNZkIg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AA768CC13AD; Thu, 26 May 2022 03:54:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] New: KVM VMX nested virtualization: VMXON does not
 check guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Thu, 26 May 2022 03:54:23 +0000
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
Message-ID: <bug-216033-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216033

            Bug ID: 216033
           Summary: KVM VMX nested virtualization: VMXON does not check
                    guest CR0 against IA32_VMX_CR0_FIXED0
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

Created attachment 301050
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301050&action=3Dedit
Guest hypervisor to reproduce this bug (xz compressed)

CPU model I am running: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
Host kernel version: 5.17.8-200.fc35.x86_64
Host kernel arch: x86_64
Guest: a hypervisor I wrote myself, 32-bits, compressed and attached as
c.img.xz.
QEMU command line: qemu-system-x86_64 -m 512M -smp 1 -cpu Haswell,vmx=3Dyes
-enable-kvm -serial stdio -drive media=3Ddisk,file=3Dc.img,index=3D1
The problem does not go away if using -machine kernel_irqchip=3Doff
Since the guest is a hypervisor, -accel tcg cannot be used (TCG does not
support nested virtualization)

Actual behavior: serial port shows:

...
CR0        =3D 0x0000000080000015
CR0 fixed0 =3D 0x0000000080000021
CR0 fixed1 =3D 0x00000000ffffffff
VMXON succeeds

Expected behaivor: serial port shows:

...
CR0        =3D 0x0000000080000015
CR0 fixed0 =3D 0x0000000080000021
CR0 fixed1 =3D 0x00000000ffffffff
[00]: unhandled exception 13 (0xd), halting!
[00]: error code: 0x00000000
[00]: state dump follows...
[00] CS:EIP ...
...

Explanation:

When the guest hypervisor starts VMX using the VMXON instruction, the guest
hypervisor's CR0 is not legal. IA32_VMX_CR0_FIXED0 =3D 0x0000000080000021. =
The
0x20 bit in this MSR is 1, which indicates that the 0x20 bit in CR0 must be=
 1
when executing VMXON. However, my hypervisor uses CR0 =3D 0x80000015 (the 0=
x20
bit is 0).

According to SDM 29.3, if "the values of CR0 and CR4 are not supported in V=
MX
operation", then a general protection exception (#GP(0)) should be raised. =
This
happens on real hardware, but not on KVM.

The relevant code in my hypervisor is:

https://github.com/lxylxy123456/uberxmhf/blob/770bdaa7afce560b9f46348bee5a0=
5e2c680de06/xmhf/src/xmhf-core/xmhf-runtime/xmhf-startup/lhv-vmx.c#L250

The pseudo code is

print the hypervisor's CR0 to serial port
print MSR value IA32_VMX_CR0_FIXED0 to serial port
print MSR value IA32_VMX_CR0_FIXED1 to serial port
sleep for 3 seconds
run VMXON instruction
If succeed, write "VMXON succeeds" to serial port.
If VMXON receives an exception, write exception details to serial port ("[0=
0]:
unhandled exception...")

To fix this bug, handle_vmon() in arch/x86/kvm/vmx/nested.c needs to be
updated. The check to CR0 and CR4 against IA32_VMX_CR0_FIXED0 etc need to be
added.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
