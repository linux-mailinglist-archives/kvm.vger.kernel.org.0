Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22734793020
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 22:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbjIEUgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 16:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243795AbjIEUgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 16:36:02 -0400
X-Greylist: delayed 4196 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Sep 2023 13:35:56 PDT
Received: from mail-4321.protonmail.ch (mail-4321.protonmail.ch [185.70.43.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410BD19A
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 13:35:56 -0700 (PDT)
Date:   Tue, 05 Sep 2023 18:07:47 +0000
Authentication-Results: mail-4321.protonmail.ch;
        dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="M33TE/6g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1693937270; x=1694196470;
        bh=NVdh9QfHm9IRSnE/4VIb082F7S4QW62u6yWEqSFZLek=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=M33TE/6g9WxxWrlzAODAdnXkZbCO4mxMSI5ex7jj/GWhJI6TqcE38fatqwGGvSBti
         bPLbVN/7U3DXqZPysPr2ByEfQ0crfj7B6ifPs8Mc5J0iyT4Hr+sOsu9UYYU6GqIMkc
         diySpOqCjyNBAQMCs0JVnOOoXbhfCO4OBLFBUD/Fx+IyzgKlHnrJlaw16HZMr3F5RD
         qOOTuPBja3bbDDpLT8CWZuVyNhg7Pxyjgdqd4ml9JoBkwdhewcdsQizhjomqnFhtOL
         /kO0ED2GkSHoQafjMH+SFrPRqZ9zAUwhm2MsOejM2oV+FKAhi8PZjkxsr3dlzxbNcp
         zQjBEkFrVEzTA==
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
Message-ID: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am having trouble booting old linux-3.10.108 x86_64 guest kernel on
qemu-2.11(+ubuntu patches) running on linux-5.10.194 x86_64 host kernel.
Same problem was observed with qemu version that shipped with Debian 11.
This problem is old regression. This type of setup worked fine on older
linux-4.x hosts but fails on linux-5.10.x hosts. I remember seeing this fai=
l
as early as year 2021. I just haven't had time to look at it earlier.

Relevant qemu parameters:
  -machine pc-1.0
  -cpu Skylake-Server-IBRS,+md-clear,+pcid,+invpcid,+ssbd,+clflushopt
  -enable-kvm
If I change CPU model to "Nehalem" then it boots OK.

KVM stuff is built-in to host kernel and my kernel boot parameters include:
  kvm-intel.ept=3D0 l1tf=3Doff kvm.ignore_msrs=3D1
so any invalid RDMSR reads should not fail because of ignore_msrs=3D1 VETO,
but at least MSR_IA32_PERF_CAPABILITIES RDMSR read does indeed fail.
=20
Below is relevent guest kernel log data captured via virtual serial port:

[    0.041453] general protection fault: 0000 [#1]=20
[    0.046166] Modules linked in:
[    0.046464] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.108 #1
[    0.046990] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.047509] task: ffff88011f069890 ti: ffff88011f06a000 task.ti: ffff880=
11f06a000
[    0.048171] RIP: 0010:[<ffffffff816d0c77>]  [<ffffffff816d0c77>] intel_p=
mu_init+0x2ee/0x7b8
[    0.048943] RSP: 0000:ffff88011f06be68  EFLAGS: 00010202
[    0.049423] RAX: 0000000000000003 RBX: 0000000000000000 RCX: 00000000000=
00345
[    0.050000] RDX: 0000000000000003 RSI: 0000000000000001 RDI: ffffffff816=
c1230
[    0.050000] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00007
[    0.050000] R10: 0000000000000000 R11: 00000001816bee00 R12: 00000000000=
00000
[    0.050000] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[    0.050000] FS:  0000000000000000(0000) GS:ffffffff81655000(0000) knlGS:=
0000000000000000
[    0.050000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.050000] CR2: ffff88011ffff000 CR3: 0000000001648000 CR4: 00000000003=
406b0
[    0.050000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    0.050000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    0.050000] Stack:
[    0.050000]  0000860300000000 0000000007300402 ffffffff816cfc3d ffffffff=
816cfc72
[    0.050000]  0000000000000000 ffffffff8101c266 0000000000000000 ffff8800=
0009b000
[    0.050000]  ffffffff81744020 ffffffff816cfc3d 0000000000000000 00000000=
00000000
[    0.050000] Call Trace:
[    0.050000]  [<ffffffff816cfc3d>] ? check_bugs+0x45/0x45
[    0.050000]  [<ffffffff816cfc72>] ? init_hw_perf_events+0x35/0x4cf
[    0.050000]  [<ffffffff8101c266>] ? set_memory_x+0x2b/0x30
[    0.050000]  [<ffffffff816cfc3d>] ? check_bugs+0x45/0x45
[    0.050000]  [<ffffffff8100032d>] ? do_one_initcall+0x73/0xfe
[    0.050000]  [<ffffffff816c9cb0>] ? kernel_init_freeable+0x53/0x180
[    0.050000]  [<ffffffff81445771>] ? rest_init+0x65/0x65
[    0.050000]  [<ffffffff81445777>] ? kernel_init+0x6/0xc9
[    0.050000]  [<ffffffff8144f987>] ? ret_from_fork+0x57/0x90
[    0.050000]  [<ffffffff81445771>] ? rest_init+0x65/0x65
[    0.050000] Code: 00 0f 46 d0 ff ce 89 15 88 05 ff ff 7e 2f 8a 54 24 04 =
b8 03 00 00 00 b9 45 03 00 00 83 e2 1f 83 fa 02 0f 4f c2 89 05 99 04 ff ff =
<0f> 32 48 c1 e2 20 89 c0 48 09 c2 48 89 15 2f 05 ff ff e8 69 e7=20
[    0.050000] RIP  [<ffffffff816d0c77>] intel_pmu_init+0x2ee/0x7b8
[    0.050000]  RSP <ffff88011f06be68>
[    0.050011] ---[ end trace 3baec0b388c1f452 ]---
[    0.050436] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b

System.map address:

ffffffff816d0989 T intel_pmu_init

Partial linux-3.10.108/arch/x86/kernel/cpu/perf_event_intel.o disassembly:

00000000000000c3 <intel_pmu_init>:             =20
  c3:   53                      push   %rbx     =20
  c4:   48 83 ec 10             sub    $0x10,%rsp
  c8:   48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # cf <intel_pm=
u_init+0xc>
[SNIP]
 398:   b8 03 00 00 00          mov    $0x3,%eax
 39d:   b9 45 03 00 00          mov    $0x345,%ecx
 3a2:   83 e2 1f                and    $0x1f,%edx
 3a5:   83 fa 02                cmp    $0x2,%edx
 3a8:   0f 4f c2                cmovg  %edx,%eax
 3ab:   89 05 00 00 00 00       mov    %eax,0x0(%rip)        # 3b1 <intel_p=
mu_init+0x2ee>
 3b1:   0f 32                   rdmsr
                                ^^^^^----------FAILS-HERE----------
 3b3:   48 c1 e2 20             shl    $0x20,%rdx
 3b7:   89 c0                   mov    %eax,%eax
 3b9:   48 09 c2                or     %rax,%rdx
 3bc:   48 89 15 00 00 00 00    mov    %rdx,0x0(%rip)        # 3c3 <intel_p=
mu_init+0x300>

Above RDMSR assembly instruction maps to this C-language source file:
linux-3.10.108/arch/x86/kernel/cpu/perf_event_intel.c line 2036:

    rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);

Full C-language source file can be viewed here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/arch/=
x86/kernel/cpu/perf_event_intel.c?h=3Dlinux-3.10.y#n2023

My understanding of this failure is that it is combination of many factors,
including:

1) Qemu version is old
2) Qemu guest CPUID flags may be "Frankenstein"=20
3) old linux-3.10.108 x86_64 kernel may be doing something questionable
4) newer host linux KVM is not always honoring RDMSR ignore_msrs=3D1 VETO

My reading linux-5.10.194 kernel source identified following questionable
handling ignore_msrs=3D1 VETO. This same problem appears to be present in
recently released linux-6.5 too, but so far I have not tested this
with linux-6.5.x host kernels yet.

kvm_get_msr(...)
  kvm_get_msr_ignored_check(...)
    ret =3D __kvm_get_msr(...)            // returns 1 for some invalid MSR=
s
    if (ret =3D=3D KVM_MSR_RET_INVALID) {   // checks for value 2
      if (kvm_msr_ignored_check(...))
        ret =3D 0;                        // fails to get here with ignore_=
msrs=3D1
    }

Below is my quick-and-dirty fix for that one problematic
MSR_IA32_PERF_CAPABILITIES RDMSR case. This patch does not fix
other cases where __kvm_get_msr() returns 1 for invalid MSR reads.
This patch makes guest linux-3.10.108 x86_64 Skylake boot OK.
This patch is for linux-5.10.194 but seems to apply OK to
linux-6.5 also with some offset.

--- ./arch/x86/kvm/x86.c.OLD
+++ ./arch/x86/kvm/x86.c
@@ -3518,7 +3518,7 @@
 =09=09msr_info->data =3D vcpu->arch.arch_capabilities;
 =09=09break;
 =09case MSR_IA32_PERF_CAPABILITIES:
-=09=09if (!msr_info->host_initiated &&
+=09=09if (!msr_info->host_initiated && !ignore_msrs &&
 =09=09    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
 =09=09=09return 1;
 =09=09msr_info->data =3D vcpu->arch.perf_capabilities;

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

