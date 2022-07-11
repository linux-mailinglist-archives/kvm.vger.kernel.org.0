Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CCE56D234
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiGKAcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiGKAcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 20:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BB95B6
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 17:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F068160FEA
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F5E7C341CD
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657499519;
        bh=XqkS0yQl/kPX1DWKwRqYvk8J2RT9xL2WtFOk+x+ffHY=;
        h=From:To:Subject:Date:From;
        b=WrxqFO2aJuYa5zw+3ox1w4YHXZNgqDo8ETCu7WRdI19UrelWYub3F3aKlRSr5WiWT
         BSVHgpLGXFN3VCvuXSCrvm2gWOsH0B67N8mV00FgW6u6OXM2EK6VUnBaF+7vluRLrR
         k6RwuX/VNGd3v7HBX89bvNNM9vfd8oguG3EFVD91jrh0ASkSJ5eFUlmGcXYXBsuXrJ
         GsqUA1rwOJBzfEKjMGFb9lJSH9B95lbA/U43DmywlZzfkIqAsi3kVn98BEfh5qUNL/
         qrFmSF1BK/HQ3xQj+vw0XD0c6xwwmYia4iwKeNTSf0vDlcVShf6zVIHJNWo6Awlo1L
         F3+dMyEIFXNIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 494F8CC13B8; Mon, 11 Jul 2022 00:31:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216234] New: KVM guest memory is zeroed when nested guest's REP
 INS instruction encounters page fault
Date:   Mon, 11 Jul 2022 00:31:58 +0000
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
Message-ID: <bug-216234-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216234

            Bug ID: 216234
           Summary: KVM guest memory is zeroed when nested guest's REP INS
                    instruction encounters page fault
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18.9
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

Created attachment 301384
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301384&action=3Dedit
Guest image (e.img)

CPU model: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
Host kernel version: 5.18.9
Host kernel arch: x86_64
Guest: a micro-hypervisor (called XMHF, 32-bits), which runs a real mode L2
nested guest (similar to GRUB's boot.img).
QEMU command line: qemu-system-x86_64 -m 512M -gdb tcp::2198 -smp 1 -cpu
Haswell,vmx=3Dyes -enable-kvm -serial stdio -drive media=3Ddisk,file=3De.im=
g,index=3D1
This bug still exists if using -machine kernel_irqchip=3Doff
This problem cannot be tested with -accel tcg , because the guest requires
nested virtualization

How to reproduce:

1. Download e.img (attached with this bug). Source code of this LHV image i=
s in
https://github.com/lxylxy123456/uberxmhf/tree/0596d7e0ebf89a37ca896846f1d25=
69d2c816aff
.

2. Run the QEMU command line above

3. See the following 2 lines:

EPT:    0x00008000 CS:EIP=3D0x000fa591 *0x8000=3D0x5a5a5a5a5a5a5a5a (inst 6=
7 f3 6d)
VMCALL: 0x00008000 CS:EIP=3D0x000fa594 *0x8000=3D0x0000000000000000

Expected behavior:

See the following 2 lines:

EPT:    0x00008000 CS:EIP=3D0x000fa591 *0x8000=3D0x5a5a5a5a5a5a5a5a (inst 6=
7 f3 6d)
VMCALL: 0x00008000 CS:EIP=3D0x000fa594 *0x8000=3D0x0139e8811bbe5652

Explanation

In KVM terms, KVM is L0, XMHF is L1, nested guest is L2.

The nested guest (L2) calls BIOS INT $0x13 with AH=3D0x42, which reads a di=
sk
block. The destination of the read is 0x0800:0x0000. If interested, the
assembly code is at
https://github.com/lxylxy123456/uberxmhf/blob/0596d7e0ebf89a37ca896846f1d25=
69d2c816aff/xmhf/src/xmhf-core/xmhf-runtime/xmhf-partition/arch/x86/vmx/par=
t-x86vmx-sup.S#L134
.

The default SeaBIOS used by QEMU / KVM will interact with IDE using the REP=
 INS
instruction. In my BIOS this instruction is at 0x000fa591. After this
instruction completes, 0x8000 should be filled with the data read from the =
disk
(0x0139e8811bbe5652).

The XMHF (L1)'s logic is:
* Copy the nested guest (L2) to 0x7c00
* Write 0x5a5a5a5a5a5a5a5a to 0x8000
* Initialize EPT with identity mapping, but do not map the 4K page at 0x8000
* Start the nested guest (L2)
* Receive a VMEXIT due to EPT violation at guest CS:EIP=3D0x000fa591, print=
 the
first line, identity map the 4K page at 0x8000, change the instruction at
0x000fa594 to VMCALL
* Receive a VMEXIT due to VMCALL at guest CS:EIP=3D0x000fa591, print the se=
cond
line, see that 0x8000=3D0x0000000000000000

The correct behavior is that 0x8000 is written with the data on disk, which=
 is
0x0139e8811bbe5652.

Explanation of the two lines printed by XMHF:
* 0x00008000 in the first line is Guest-physical address of the EPT exit
* 0x000fa591 in the first line is guest CS base * 16 + EIP. The second line=
 is
similar
* 0x5a5a5a5a5a5a5a5a in the first line is the first 8 bytes at address 0x80=
00,
as uint64_t. The second line is similar
* 67 f3 6d in the first line is 3 bytes at CS:EIP, in this case the instruc=
tion
is "rep insw (%dx),%es:(%edi)"
* 0x00008000 in the second line has no meaning

In vmx.c function handle_io(), looks like the I/O instruction is emulated w=
hen
the instruction starts with REP. I guess it may be related to the cause of =
this
bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
