Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC963CD18F
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 12:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhGSJ2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 05:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhGSJ2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 05:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41EBE610F7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 10:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626689325;
        bh=7ZEzbq5Wz9s/1aqq/AF4AFtc0oPsEs5Q0qlF3UvtEV0=;
        h=From:To:Subject:Date:From;
        b=jEUKDJtGpInovaC6n62rgmoYou3CO6reD9/xIqc8jYxQCqlRRaCkfKWwXOb8fmh32
         kepbCjVnX4PX8CMr1vdKVULm0MpIPtCQHbchemRD6ij2V7symFBkdjwx5g4QZPARk5
         udyBLrX/yCK2vhZA6S23bFsvmB+u2TmeGEoD6cdT6xDG4r0nbWIpYSFEQrI8j/VnP5
         Dnmyuc1Pc/Dhl2dJW/YDO6c/o7RiE2PUoSuU6kGIP5rqft6wW18guE3dyMuSlO/C8E
         J0VBxNLF4PDTGy6ahbhPx+T6ITdmTM0r8nMfYJ9DdneC3ueaO4DsDbiPRcicMNTdps
         x/o/hWyuGqvMg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 38676611CE; Mon, 19 Jul 2021 10:08:45 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] New: KVM: x86/svm: The guest (#vcpu>1) can't boot up
 with QEMU "-overcommit cpu-pm=on"
Date:   Mon, 19 Jul 2021 10:08:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: like.xu.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-213781-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213781

            Bug ID: 213781
           Summary: KVM: x86/svm: The guest (#vcpu>1) can't boot up with
                    QEMU "-overcommit cpu-pm=3Don"
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.14.0-rc1+
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: like.xu.linux@gmail.com
        Regression: No

Hi,

This issue is an upstream bug and very easy to reproduce on the AMD platfor=
ms.
It was first introduced since the commit
e72436bc3a5206f95bb384e741154166ddb3202e.

The QEMU reports the the following stack:

KVM internal error. Suberror: 1
emulation failure
EAX=3D000f38b3 EBX=3D00000000 ECX=3D000002ff EDX=3D00000001
ESI=3D00000000 EDI=3D00000000 EBP=3D00000000 ESP=3D00006d88
EIP=3D000fc95a EFL=3D00000002 [-------] CPL=3D0 II=3D0 A20=3D1 SMM=3D0 HLT=
=3D0
ES =3D0010 00000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
CS =3D0008 00000000 ffffffff 00c09b00 DPL=3D0 CS32 [-RA]
SS =3D0010 00000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
DS =3D0010 00000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
FS =3D0010 00000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
GS =3D0010 00000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
LDT=3D0000 00000000 0000ffff 00008200 DPL=3D0 LDT
TR =3D0000 00000000 0000ffff 00008300 DPL=3D0 TSS16-busy
GDT=3D     000f50a0 00000037
IDT=3D     000f50de 00000000
CR0=3D00000011 CR2=3D00000000 CR3=3D00000000 CR4=3D00000000
DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000
DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
EFER=3D0000000000000000
Code=3D34 41 0f 00 e8 5b 26 ff ff c7 05 38 41 0f 00 00 00 00 00 f4 <eb> fd =
fa fc
66 b8 00 c2 00 00 8e d8 8e d0 66 bc 58 f8 00 00 e9 07 f9 66 54 66 0f b7 e4 =
66

At the buggy time, the dump_vmcb() says:

[47175.214140] SVM: VMCB 00000000a4006788, last attempted VMRUN on CPU 81
[47175.215862] SVM: VMCB Control Area:
[47175.216155] SVM: cr_read:            0010
[47175.216426] SVM: cr_write:           0110
[47175.216699] SVM: dr_read:            00ff
[47175.216939] SVM: dr_write:           00ff
[47175.217170] SVM: exceptions:         00060042
[47175.217400] SVM: intercepts:         bc4c8027 0000624f
[47175.217651] SVM: pause filter count: 0
[47175.217879] SVM: pause filter threshold:0
[47175.218107] SVM: iopm_base_pa:       0000000194674000
[47175.218342] SVM: msrpm_base_pa:      00000040857d4000
[47175.218589] SVM: tsc_offset:         ffff92710e0ed2c0
[47175.218823] SVM: asid:               1
[47175.219052] SVM: tlb_ctl:            0
[47175.219280] SVM: int_ctl:            03000200
[47175.219522] SVM: int_vector:         00000000
[47175.219753] SVM: int_state:          00000000
[47175.219981] SVM: exit_code:          00000400
[47175.220208] SVM: exit_info1:         0000000100000014
[47175.220441] SVM: exit_info2:         00000000000fc000
[47175.220684] SVM: exit_int_info:      00000000
[47175.220913] SVM: exit_int_info_err:  00000000
[47175.221140] SVM: nested_ctl:         1
[47175.221363] SVM: nested_cr3:         0000004184ca8000
[47175.221598] SVM: avic_vapic_bar:     0000000000000000
[47175.221823] SVM: ghcb:               0000000000000000
[47175.222047] SVM: event_inj:          00000000
[47175.222272] SVM: event_inj_err:      00000000
[47175.222497] SVM: virt_ext:           2
[47175.222739] SVM: next_rip:           0000000000000000
[47175.222968] SVM: avic_backing_page:  0000000000000000
[47175.223198] SVM: avic_logical_id:    0000000000000000
[47175.223425] SVM: avic_physical_id:   0000000000000000
[47175.223665] SVM: vmsa_pa:            0000000000000000
[47175.223885] SVM: VMCB State Save Area:
[47175.224105] SVM: es:   s: 0010 a: 0c93 l: ffffffff b: 0000000000000000
[47175.224342] SVM: cs:   s: 0008 a: 049b l: ffffffff b: 0000000000000000
[47175.224588] SVM: ss:   s: 0010 a: 0c93 l: ffffffff b: 0000000000000000
[47175.224817] SVM: ds:   s: 0010 a: 0c93 l: ffffffff b: 0000000000000000
[47175.225043] SVM: fs:   s: 0010 a: 0c93 l: ffffffff b: 0000000000000000
[47175.225266] SVM: gs:   s: 0010 a: 0c93 l: ffffffff b: 0000000000000000
[47175.225486] SVM: gdtr: s: 0000 a: 0000 l: 00000037 b: 00000000000f50a0
[47175.225720] SVM: ldtr: s: 0000 a: 0082 l: 0000ffff b: 0000000000000000
[47175.225939] SVM: idtr: s: 0000 a: 0000 l: 00000000 b: 00000000000f50de
[47175.226156] SVM: tr:   s: 0000 a: 0083 l: 0000ffff b: 0000000000000000
[47175.226445] SVM: cpl:            0                efer:=20=20=20=20=20=
=20=20=20
0000000000001000
[47175.226682] SVM: cr0:            0000000000000011 cr2:=20=20=20=20=20=20=
=20=20=20
0000000000000000
[47175.226900] SVM: cr3:            0000000000000000 cr4:=20=20=20=20=20=20=
=20=20=20
0000000000000000
[47175.227112] SVM: dr6:            00000000ffff0ff0 dr7:=20=20=20=20=20=20=
=20=20=20
0000000000000400
[47175.227327] SVM: rip:            00000000000fc95a rflags:=20=20=20=20=20=
=20
0000000000000002
[47175.227554] SVM: rsp:            0000000000006d88 rax:=20=20=20=20=20=20=
=20=20=20
00000000000f38b3
[47175.227768] SVM: star:           0000000000000000 lstar:=20=20=20=20=20=
=20=20
0000000000000000
[47175.227983] SVM: cstar:          0000000000000000 sfmask:=20=20=20=20=20=
=20
0000000000000000
[47175.228198] SVM: kernel_gs_base: 0000000000000000 sysenter_cs:=20
0000000000000000
[47175.228413] SVM: sysenter_esp:   0000000000000000 sysenter_eip:
0000000000000000
[47175.228641] SVM: gpat:           0007040600070406 dbgctl:=20=20=20=20=20=
=20
0000000000000000
[47175.228859] SVM: br_from:        0000000000000000 br_to:=20=20=20=20=20=
=20=20
0000000000000000
[47175.229076] SVM: excp_from:      0000000000000000 excp_to:=20=20=20=20=20
0000000000000000

You may need the target BIOS code part:

   fc940:       00 00
   fc942:       72 f3                   jb     fc937 <entry_smp+0xb>
   fc944:       8b 25 34 41 0f 00       mov    0xf4134,%esp
   fc94a:       e8 5b 26 ff ff          call   eefaa <handle_smp>
   fc94f:       c7 05 38 41 0f 00 00    movl   $0x0,0xf4138
   fc956:       00 00 00
   fc959:       f4                      hlt
   fc95a:       eb fd                   jmp    fc959 <entry_smp+0x2d>
   fc95c:       fa                      cli
   fc95d:       fc                      cld
   fc95e:       66 b8 00 c2             mov    $0xc200,%ax
   fc962:       00 00                   add    %al,(%eax)
   fc964:       8e d8                   mov    %eax,%ds
   fc966:       8e d0                   mov    %eax,%ss
   fc968:       66 bc 58 f8             mov    $0xf858,%sp
   fc96c:       00 00                   add    %al,(%eax)
   fc96e:       e9 07 f9 66 54          jmp    5476c27a
<code32flat_end+0x5466c27a>
   fc973:       66 0f b7 e4             movzww %sp,%sp
   fc977:       66 9c                   pushfw
   fc979:       fa                      cli
   fc97a:       fc                      cld

Or the code from the SeaBios:

// Entry point for QEMU smp sipi interrupts.
        DECLFUNC entry_smp
entry_smp:
        // Transition to 32bit mode.
        cli
        cld
        movl $2f + BUILD_BIOS_ADDR, %edx
        jmp transition32_nmi_off
        .code32
        // Acquire lock and take ownership of shared stack
1:      rep ; nop
2:      lock btsl $0, SMPLock
        jc 1b
        movl SMPStack, %esp
        // Call handle_smp
        calll _cfunc32flat_handle_smp - BUILD_BIOS_ADDR
        // Release lock and halt processor.
        movl $0, SMPLock
3:      hlt
        jmp 3b
        .code16

The related trace:

       CPU 1/KVM-1278472 [119] d..2 246654.769260: kvm_entry: vcpu 1, rip
0xfc95a
       CPU 1/KVM-1278472 [119] ...1 246654.769261: kvm_exit: vcpu 1 reason =
npf
rip 0xfc95a info1 0x0000000100000014 info2 0x00000000000fc000 intr_info
0x00000000 error_code 0x00000000
       CPU 1/KVM-1278472 [119] ...1 246654.769262: kvm_page_fault: address
fc000 error_code 14
       CPU 1/KVM-1278472 [119] d..2 246654.769262: kvm_entry: vcpu 1, rip
0xfc95a
       CPU 1/KVM-1278472 [119] ...1 246654.769263: kvm_exit: vcpu 1 reason =
npf
rip 0xfc95a info1 0x0000000100000014 info2 0x00000000000fc000 intr_info
0x00000000 error_code 0x00000000
       CPU 1/KVM-1278472 [119] ...1 246654.769263: kvm_page_fault: address
fc000 error_code 14
       CPU 1/KVM-1278472 [119] ...1 246654.769272: kvm_emulate_insn: 0:fc95=
a:
(prot32)
       CPU 1/KVM-1278472 [119] ...1 246654.769274: kvm_emulate_insn: 0:fc95=
a:
(prot32) failed
       CPU 1/KVM-1278472 [119] ...1 246654.769275: kvm_fpu: unload
       CPU 1/KVM-1278472 [119] ...1 246654.769275: kvm_userspace_exit: reas=
on
KVM_EXIT_INTERNAL_ERROR (17)


My early explorations:

- Instruction emulation of EIP 0xfc95a raised by (EMULTYPE_ALLOW_RETRY_PF |
EMULTYPE_PF) exited by kvm_mmu_page_fault();
- The __do_insn_fetch_bytes() is called in the x86_decode_insn() due to
svm->vmcb->control.insn_len is 0 (not sure if it's another Errata about #NP=
F);
- The X86EMUL_IO_NEEDED is returned for kvm_fetch_guest_virt();
- Please note we will have "kvm_emulate_insn: ffff0000:fff0: (real) failed"
for the tools/testing/selftests/kvm/set_memory_region_test.

Please share your understanding with me or fix it with your proposal.

Thanks,
Like Xu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
