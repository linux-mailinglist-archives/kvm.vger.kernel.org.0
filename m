Return-Path: <kvm+bounces-56961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6C1B484CE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 09:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24C46177AE0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 07:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C822E3B07;
	Mon,  8 Sep 2025 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/Q8vj/4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84173747F
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 07:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757315414; cv=none; b=sbo8UDTTzcRwxN0g42LtERLjy1Bo/lSW5s+OKMU1B8yC27sbdkPHSIKUhAZBHR62GjCyfkFGYHHuc7zv9uOaLUjYZa8hPDFp7yq/rODg5bB9RYWFAc5mMRqUUZBLwLPJsbGJ1KUx96LLhqeKblvRu4GAmRy0NL3x2Z3IeOqcUIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757315414; c=relaxed/simple;
	bh=8FlCmlxCL6D8m2hJkpBIsezgyaUhqmTLnWeImAymTfY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bfWN90GZITmHmpC5S0GRaiboY0R1BcAOgj133YmwnaQTfmk9xCi3GadYHuU6R7jvf2YrWDtnKC0Gi0CyEg6s3NmRVxC6onP9yuh2wx0GQfJdZlk2v9P2qKjJH6TzyD9DW5uC4vJpQik9bUYKhLLXCvLd2X3SeHi2uJ08YO04o9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/Q8vj/4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92519C4CEF9
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 07:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757315413;
	bh=8FlCmlxCL6D8m2hJkpBIsezgyaUhqmTLnWeImAymTfY=;
	h=From:To:Subject:Date:From;
	b=h/Q8vj/4e2NmTd26TnP/sL60XkYUbcN2ykNC0lqpeFw+Npg5dKQZEK5t9LPpYDz5s
	 8Q9HN7owqoxxbDNE5qDdn3DHLsPdcdCBVJQcqx1SU1PR+jyHLGkWYyvKpK2PYLNtpL
	 sB2khIYaUdtKwBVzDLBHtzzBrniKp7YXqkac2l8RlebDJ/bDA5Iu8le1rr8Sli/v5x
	 GyT6Nets58ax2b6uXCLpDFFg/JrgB9wwCMu+TEn6vC2PbMUQri9a4v4ClO55qXGf1d
	 PZd0SLptTV3mPfQl2aWOKtsS7qG0aWWFeeAKL5Q7CK80ipcwMItIdeTRWpeg9uT2/k
	 YwSIxatfB8mBA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8B3E6C41613; Mon,  8 Sep 2025 07:10:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220549] New: [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
Date: Mon, 08 Sep 2025 07:10:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: khushit.shah@nutanix.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220549-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220549

            Bug ID: 220549
           Summary: [KVM/VMX] Level triggered interrupts mishandled on
                    Windows w/ nested virt(Credential Guard) when using
                    split irqchip
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: khushit.shah@nutanix.com
        Regression: No

When running Windows with Credential Guard enabled and with split-irqchip,
level triggered interrupts are not properly forwarded to L2 (Credential Gua=
rd)
by L1 (Windows), instead L1 EOIs the interrupt. Which leads to extremely sl=
ow
Windows boot time. This issue is only seen on Intel + split-irqchip. Intel +
kernel-irqchip, AMD + (kernel/split)-irqchip works fine.

Qemu command used to create the vm:
/usr/libexec/qemu-kvm \
 -machine q35,accel=3Dkvm,smm=3Don,usb=3Doff,acpi=3Don,kernel-irqchip=3Dspl=
it \
 -cpu
host,+vmx,+invpcid,+ssse3,+aes,+xsave,+xsaveopt,+xgetbv1,+xsaves,+rdtscp,+t=
sc-deadline
\
 -m 20G -smp 1 \
 -boot order=3Dc,menu=3Don \
 -drive
if=3Dpflash,format=3Draw,readonly=3Don,file=3D/usr/share/OVMF/OVMF_CODE_4MB=
.secboot.fd
\
 -drive if=3Dpflash,format=3Draw,file=3D/var/lib/qemu/nvram/win_VARS.fd \
 -chardev socket,id=3Dchrtpm,path=3D/var/lib/qemu/tpm-win/sock \
 -tpmdev emulator,id=3Dtpm0,chardev=3Dchrtpm \
 -device tpm-crb,tpmdev=3Dtpm0 \
 -device ich9-usb-ehci1,id=3Dusb \
 -device ich9-usb-uhci1,masterbus=3Dusb.0,firstport=3D0 \
 -device ich9-usb-uhci2,masterbus=3Dusb.0,firstport=3D2 \
 -device ich9-usb-uhci3,masterbus=3Dusb.0,firstport=3D4 \
 -device usb-tablet,bus=3Dusb.0,port=3D1 \
 -device VGA,vgamem_mb=3D16 \
 -device ich9-ahci,id=3Dsata \
 -drive file=3D/var/log/winsrv_2022_cg.qcow2,if=3Dnone,format=3Dqcow2,id=3D=
hd0 \
 -device ide-hd,drive=3Dhd0,bus=3Dsata.0 \
 -vnc 0.0.0.0:5 \
 -serial mon:stdio

Note that usb controllers and usb devices generate the INTx interrupts hence
are important for repro, the qcow2 is Windows Server 2022 with UEFI boot and
Credential Guard. Removing kernel-irqchip=3Dsplit (using kernel-irqchip) do=
es not
lead into the issue.

Processor Information: Intel(R) Xeon(R) Gold 6348 CPU @ 2.60GHz

Kernel Info:
6.12.26-11.0s20c78r5.el9.x86_64 (bug present)
6.17.0-11.0s20c79r5.el9.x86_64 (bug present)

Config file: standard config, KVM specific config here:
https://pastebin.com/skXYQeJn

Qemu version: 9.1.0

We see the following turns of events with kernel-irqchip:
   a) A level triggered interrupt on pin 19 arrives after MMIO write from
L2(CGVM) (to usb device) (not shown in above logs).
   b) Using kvm_nested_vmexit_inject the L2 exit reason (external interrupt=
) is
made visible to L1.
   c) We see an L1 enter, which immediately invokes L2 with VMRESUME.
   d) L2 services the interrupt, performs MMIO write, which de-asserts the
level triggered interrupt.
   e) Then L2 EOIs the interrupt after de-assertion -> L1 EOIs the interrup=
t.

While for split-irqchip we see the following turn of events:
  a) and b) is the same.
  c) L1 enters and EOIs immediately, without letting L2 service the interru=
pt
first. (Line never de-asserts)
  d) The interrupt gets re-inserted repeatedly -> boot crawls.
[KVM Tracepoints at the bottom ]

We probed the interrupt delivery path in both cases,  the interrupt delivery
path for both the cases is only slightly different, in the case of
kernel-irqchip, `kvm_set_irq` calls `kvm_ioapic_set_irq`, while in the case=
 of
split-irqchip, `kvm_set_irq` calls `kvm_msi_set_irq`, both paths merge on
`kvm_irq_delivery_to_apic`, we noticed all the args are same, we also probed
path taken from there in both the cases, which is kvm_irq_delivery_to_apic =
=E2=86=92
kvm_irq_delivery_to_apic_fast =E2=86=92 kvm_apic_set_irq =E2=86=92 __apic_a=
ccept_irq =E2=86=92
vmx_deliver_interrupt =E2=86=92 vmx_deliver_posted_interrupt  =E2=86=92
kvm_vcpu_trigger_posted_interrupt

On split-irqchip, subsequent interrupts take different route in
kvm_vcpu_trigger_posted_interrupt as interrupts are received while L1 (Wind=
ows)
is running on the vcpu.

We also took VMCS dumps just before kvm_enter and just after kvm_exit after=
 the
first level triggered interrupt is received, VMCS01 and VMCS12 are same just
before the L1 VMENTER after the first interrupt is delivered. We observe th=
at
for both VMCS01 and VMCS12, InterruptStatus, SVI|RVI, entry/exit informatio=
n,
pin-based/cpu-based ctrl state are the same, yet in case of kernel-irqchip,=
 L1
passes the interrupt to L2 with VMRESUME, and in case of split-irqchip perf=
orms
EOI.
[VMCS dumps at the bottom]

We also checked the last MSR reads and writes on different addresses before=
 the
first level triggered interrupt, the dump is available here:
https://pastebin.com/PckkM8pt,
Only values we see different between kernel-irqchip and split-irqchip seems=
 to
be run to run variation.

We also checked CPUID info exposed to the guest. There was only one bit cha=
nge,
specifically on func 40000001.
   A@1451335: kvm:kvm_cpuid: func 40000001 idx 0 rax 10040fb rbx 0 rcx 0 rd=
x 0,
cpuid entry found
   B@1476293: kvm:kvm_cpuid: func 40000001 idx 0 rax 100c0fb rbx 0 rcx 0 rd=
x 0,
cpuid entry found
This seems to be KVM_FEATURE_MSI_EXT_DEST_ID bit, disabling
KVM_FEATURE_MSI_EXT_DEST_ID does not change the behavior.

[3.] Keywords:
kvm,vmx,nested-virtualization,split-irqchip,windows-guest

Any pointers on this will be extremely helpful thanks!

Thanks,
Khushit

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
KVM tracepoints in the case of kernel-irqchip:
     CPU 0/KVM  699876 [020] 18136.763622:                    kvm:kvm_set_i=
rq:
gsi 19 level 1 source 0
      CPU 0/KVM  699876 [020] 18136.763624:            kvm:kvm_apic_accept_=
irq:
apicid 0 vec 129 (Fixed|level)
      CPU 0/KVM  699876 [020] 18136.763625:           kvm:kvm_apicv_accept_=
irq:
apicid 0 vec 129 (Fixed|level)
      CPU 0/KVM  699876 [020] 18136.763626:             kvm:kvm_ioapic_set_=
irq:
pin 19 dst 0 vec 129 (Fixed|physical|level)
      CPU 0/KVM  699876 [020] 18136.763629:                    kvm:kvm_set_=
irq:
gsi 11 level 0 source 0
      CPU 0/KVM  699876 [020] 18136.763631:                kvm:kvm_pic_set_=
irq:
chip 1 pin 3 (edge|masked)
      CPU 0/KVM  699876 [020] 18136.763632:             kvm:kvm_ioapic_set_=
irq:
pin 11 dst 0 vec 255 (Fixed|physical|edge|masked)
      CPU 0/KVM  699876 [020] 18136.763633:                    kvm:kvm_set_=
irq:
gsi 11 level 0 source 0
      CPU 0/KVM  699876 [020] 18136.763634:                kvm:kvm_pic_set_=
irq:
chip 1 pin 3 (edge|masked)
      CPU 0/KVM  699876 [020] 18136.763634:             kvm:kvm_ioapic_set_=
irq:
pin 11 dst 0 vec 255 (Fixed|physical|edge|masked)
      CPU 0/KVM  699876 [020] 18136.763640:                        kvm:kvm_=
fpu:
load
      CPU 0/KVM  699876 [020] 18136.763644:       kvm:kvm_nested_vmexit_inj=
ect:
reason EXTERNAL_INTERRUPT info1 0 info2 0 int_info 80000081 int_info_err 0
      CPU 0/KVM  699876 [020] 18136.763647:                      kvm:kvm_en=
try:
vcpu 0, rip 0xfffff8489b64142c
      CPU 0/KVM  699876 [020] 18136.763651:                       kvm:kvm_e=
xit:
reason VMRESUME rip 0xfffff8489b641308 info 0 0
      CPU 0/KVM  699876 [020] 18136.763652:             kvm:kvm_nested_vmen=
ter:
rip: 0xfffff8489b641308 vmcs: 0xffffffffffffffff nested_rip: 0xfffff8031964=
b2b6
int_ctl: 0x00000000 event_inj: 0x80000081 nested_ept=3Dy nested_eptp:
0x00000001019a701e
=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94 L2 services the interrupt
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94
      CPU 0/KVM  699876 [020] 18136.763695:                       kvm:kvm_m=
mio:
mmio write len 4 gpa 0x81111024 val 0x4
      CPU 0/KVM  699876 [020] 18136.763696:                        kvm:kvm_=
fpu:
unload
      CPU 0/KVM  699876 [020] 18136.763696:             kvm:kvm_userspace_e=
xit:
reason KVM_EXIT_MMIO (6)
      CPU 0/KVM  699876 [020] 18136.763699:                    kvm:kvm_set_=
irq:
gsi 19 level 0 source 0
      CPU 0/KVM  699876 [020] 18136.763700:             kvm:kvm_ioapic_set_=
irq:
pin 19 dst 0 vec 129 (Fixed|physical|level)
      CPU 0/KVM  699876 [020] 18136.763701:                    kvm:kvm_set_=
irq:
gsi 11 level 0 source 0
      CPU 0/KVM  699876 [020] 18136.763701:                kvm:kvm_pic_set_=
irq:
chip 1 pin 3 (edge|masked)
      CPU 0/KVM  699876 [020] 18136.763702:             kvm:kvm_ioapic_set_=
irq:
pin 11 dst 0 vec 255 (Fixed|physical|edge|masked)
      CPU 0/KVM  699876 [020] 18136.763703:                    kvm:kvm_set_=
irq:
gsi 11 level 0 source 0
      CPU 0/KVM  699876 [020] 18136.763703:                kvm:kvm_pic_set_=
irq:
chip 1 pin 3 (edge|masked)
      CPU 0/KVM  699876 [020] 18136.763703:             kvm:kvm_ioapic_set_=
irq:
pin 11 dst 0 vec 255 (Fixed|physical|edge|masked)
      CPU 0/KVM  699876 [020] 18136.763705:                        kvm:kvm_=
fpu:
load
      CPU 0/KVM  699876 [020] 18136.763705:                      kvm:kvm_en=
try:
vcpu 0, rip 0xfffff8031964a708
      CPU 0/KVM  699876 [020] 18136.763707:                       kvm:kvm_e=
xit:
reason EPT_MISCONFIG rip 0xfffff8031964a727 info 0 0
      CPU 0/KVM  699876 [020] 18136.763707:              kvm:kvm_nested_vme=
xit:
CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason EPT_MISCONFIG
rip 0xfffff8031964a727 info1 0x0000000000000000 info2 0x0000000000000000
intr_info 0x00000000 error_code 0x00000000
      CPU 0/KVM  699876 [020] 18136.763709:               kvm:kvm_emulate_i=
nsn:
0:fffff8031964a727: 8b 56 0c
      CPU 0/KVM  699876 [020] 18136.763710:                kvm:vcpu_match_m=
mio:
gva 0xffffbd0c86b8a02c gpa 0x8111102c Read GPA
      CPU 0/KVM  699876 [020] 18136.763710:                       kvm:kvm_m=
mio:
mmio unsatisfied-read len 4 gpa 0x8111102c val 0x0
      CPU 0/KVM  699876 [020] 18136.763710:                        kvm:kvm_=
fpu:
unload
      CPU 0/KVM  699876 [020] 18136.763711:             kvm:kvm_userspace_e=
xit:
reason KVM_EXIT_MMIO (6)
      CPU 0/KVM  699876 [020] 18136.763712:                        kvm:kvm_=
fpu:
load
      CPU 0/KVM  699876 [020] 18136.763713:                       kvm:kvm_m=
mio:
mmio read len 4 gpa 0x8111102c val 0xec0
      CPU 0/KVM  699876 [020] 18136.763714:                      kvm:kvm_en=
try:
vcpu 0, rip 0xfffff8031964a72a
      CPU 0/KVM  699876 [020] 18136.763716:                       kvm:kvm_e=
xit:
reason MSR_WRITE rip 0xfffff8030f62d36c info 0 0
      CPU 0/KVM  699876 [020] 18136.763717:              kvm:kvm_nested_vme=
xit:
CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason MSR_WRITE rip
0xfffff8030f62d36c info1 0x0000000000000000 info2 0x0000000000000000 intr_i=
nfo
0x00000000 error_code 0x00000000
      CPU 0/KVM  699876 [020] 18136.763719:       kvm:kvm_nested_vmexit_inj=
ect:
reason MSR_WRITE info1 0 info2 0 int_info 0 int_info_err 0
      CPU 0/KVM  699876 [020] 18136.763721:                      kvm:kvm_en=
try:
vcpu 0, rip 0xfffff8489b64142c
      CPU 0/KVM  699876 [020] 18136.763724:                       kvm:kvm_e=
xit:
reason MSR_WRITE rip 0xfffff8489b732daf info 0 0
      CPU 0/KVM  699876 [020] 18136.763725:                       kvm:kvm_a=
pic:
apic_write APIC_EOI =3D 0x0
      CPU 0/KVM  699876 [020] 18136.763725:                        kvm:kvm_=
eoi:
apicid 0 vector 129

KVM tracepoints in case of split-irqchip:
      CPU 0/KVM  655470 [011] 17156.779254:                    kvm:kvm_set_=
irq:
gsi 19 level 1 source 0
      CPU 0/KVM  655470 [011] 17156.779255:                kvm:kvm_msi_set_=
irq:
dst 0 vec 129 (Fixed|physical|level)
      CPU 0/KVM  655470 [011] 17156.779256:            kvm:kvm_apic_accept_=
irq:
apicid 0 vec 129 (Fixed|level)
      CPU 0/KVM  655470 [011] 17156.779256:           kvm:kvm_apicv_accept_=
irq:
apicid 0 vec 129 (Fixed|level)
      CPU 0/KVM  655470 [011] 17156.779263:                        kvm:kvm_=
fpu:
load
      CPU 0/KVM  655470 [011] 17156.779266:       kvm:kvm_nested_vmexit_inj=
ect:
reason EXTERNAL_INTERRUPT info1 0 info2 0 int_info 80000081 int_info_err 0
      CPU 0/KVM  655470 [011] 17156.779269:                      kvm:kvm_en=
try:
vcpu 0, rip 0xfffff80653e4142c
      CPU 0/KVM  655470 [011] 17156.779271:                       kvm:kvm_e=
xit:
reason MSR_WRITE rip 0xfffff80653f32daf info 0 0
      CPU 0/KVM  655470 [011] 17156.779272:                       kvm:kvm_a=
pic:
apic_write APIC_EOI =3D 0x0
      CPU 0/KVM  655470 [011] 17156.779272:                        kvm:kvm_=
eoi:
apicid 0 vector 129
      CPU 0/KVM  655470 [011] 17156.779273:                        kvm:kvm_=
msr:
msr_write 40000070 =3D 0x0
      CPU 0/KVM  655470 [011] 17156.779274:                        kvm:kvm_=
fpu:
unload
      CPU 0/KVM  655470 [011] 17156.779274:             kvm:kvm_userspace_e=
xit:
reason KVM_EXIT_IOAPIC_EOI (26)

VMCS dump for kernel-irqchip:
      CPU 0/KVM-251862 [019]  6384.132433: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: =3D=3D=3D=3D=3D autodump (VM-ENTER) vcpu=3D0 =
=3D=3D=3D=3D=3D
      CPU 0/KVM-251862 [019]  6384.132433: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: [CURRENT]
      CPU 0/KVM-251862 [019]  6384.132433: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMC: [CURRENT] is vmc01
      CPU 0/KVM-251862 [019]  6384.132433: bprint:               dump_vmcs:
VMCS 0xffff906388d0c000, last attempted VM-entry on CPU 19
      CPU 0/KVM-251862 [019]  6384.132433: bputs:                dump_vmcs:=
 ***
Guest State ***
      CPU 0/KVM-251862 [019]  6384.132433: bprint:               dump_vmcs:
CR0: actual=3D0x0000000080010031, shadow=3D0x0000000080010031,
gh_mask=3Dfffffffffffefff7
      CPU 0/KVM-251862 [019]  6384.132434: bprint:               dump_vmcs:
CR4: actual=3D0x00000000000422e0, shadow=3D0x00000000000422e0,
gh_mask=3Dfffffffffffef871
      CPU 0/KVM-251862 [019]  6384.132434: bprint:               dump_vmcs:=
 CR3
=3D 0x0000000101945000
      CPU 0/KVM-251862 [019]  6384.132434: bprint:               dump_vmcs:
PDPTR0 =3D 0x0000000065632001  PDPTR1 =3D 0x0000000065631001
      CPU 0/KVM-251862 [019]  6384.132434: bprint:               dump_vmcs:
PDPTR2 =3D 0x0000000065630001  PDPTR3 =3D 0x000000006562f001
      CPU 0/KVM-251862 [019]  6384.132435: bprint:               dump_vmcs:=
 RSP
=3D 0xffffe70000005fc0  RIP =3D 0xfffff8390c241308
      CPU 0/KVM-251862 [019]  6384.132435: bprint:               dump_vmcs:
RFLAGS=3D0x00000002         DR7 =3D 0x0000000000000400
      CPU 0/KVM-251862 [019]  6384.132435: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_dtsel: GDTR:                           limit=3D0x0000ffff,
base=3D0xfffff8390c0232b0
      CPU 0/KVM-251862 [019]  6384.132435: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_dtsel: IDTR:                           limit=3D0x0000ffff,
base=3D0xfffff8390c0220b0
      CPU 0/KVM-251862 [019]  6384.132435: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_sel.constprop.0: TR:   sel=3D0x0030, attr=3D0x0008b, limit=3D0x000=
00067,
base=3D0xfffff8390c123320
      CPU 0/KVM-251862 [019]  6384.132436: bprint:               dump_vmcs:
DebugCtl =3D 0x0000000000000000  DebugExceptions =3D 0x0000000000000000
      CPU 0/KVM-251862 [019]  6384.132436: bprint:               dump_vmcs:
Interruptibility =3D 00000000  ActivityState =3D 00000000
      CPU 0/KVM-251862 [019]  6384.132436: bprint:               dump_vmcs:
InterruptStatus =3D 5100
      CPU 0/KVM-251862 [019]  6384.132436: bprint:               vmx_dump_m=
srs:
MSR guest autoload:
      CPU 0/KVM-251862 [019]  6384.132436: bprint:               vmx_dump_m=
srs:
   0: msr=3D0x00000600 value=3D0x0000000000000000
      CPU 0/KVM-251862 [019]  6384.132437: bputs:                dump_vmcs:=
 ***
Host State ***
      CPU 0/KVM-251862 [019]  6384.132437: bprint:               dump_vmcs:=
 RIP
=3D 0xffffffffc0d89630  RSP =3D 0xffffb5c59424bce0
      CPU 0/KVM-251862 [019]  6384.132437: bprint:               dump_vmcs:
GDTBase=3Dfffffe3f5127d000 IDTBase=3Dfffffe0000000000
      CPU 0/KVM-251862 [019]  6384.132437: bprint:               dump_vmcs:
CR0=3D0000000080050033 CR3=3D0000000183c24001 CR4=3D0000000000772ef0
      CPU 0/KVM-251862 [019]  6384.132437: bprint:               dump_vmcs:=
 PAT
=3D 0x0407050600070106
      CPU 0/KVM-251862 [019]  6384.132437: bprint:               vmx_dump_m=
srs:
MSR host autoload:
      CPU 0/KVM-251862 [019]  6384.132438: bprint:               vmx_dump_m=
srs:
   0: msr=3D0x00000600 value=3D0xfffffe3f51297000
      CPU 0/KVM-251862 [019]  6384.132438: bputs:                dump_vmcs:=
 ***
Control State ***
      CPU 0/KVM-251862 [019]  6384.132438: bprint:               dump_vmcs:
CPUBased=3D0xb5a26dfa SecondaryExec=3D0x821217eb TertiaryExec=3D0x000000000=
0000010
      CPU 0/KVM-251862 [019]  6384.132438: bprint:               dump_vmcs:
PinBased=3D0x000000ff EntryControls=3D000053ff ExitControls=3D000befff
      CPU 0/KVM-251862 [019]  6384.132438: bprint:               dump_vmcs:
ExceptionBitmap=3D000600c2 PFECmask=3D00000000 PFECmatch=3D00000000
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:
VMEntry: intr_info=3D00000000 errcode=3D00000000 ilen=3D00000000
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:
VMExit: intr_info=3D00000000 errcode=3D00000000 ilen=3D00000003
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:=
=20=20=20=20
    reason=3D00000018 qualification=3D0000000000000000
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:
IDTVectoring: info=3D00000000 errcode=3D00000000
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:=
 TSC
Offset =3D 0xfffff447b4a645a1
      CPU 0/KVM-251862 [019]  6384.132439: bprint:               dump_vmcs:=
 TSC
Multiplier =3D 0x0001000000000000
      CPU 0/KVM-251862 [019]  6384.132440: bprint:               dump_vmcs:
SVI|RVI =3D 51|00
      CPU 0/KVM-251862 [019]  6384.132440: bprint:               dump_vmcs:=
 TPR
Threshold =3D 0x00
      CPU 0/KVM-251862 [019]  6384.132440: bprint:               dump_vmcs:
APIC-access addr =3D 0x000000024ea83000
      CPU 0/KVM-251862 [019]  6384.132440: bprint:               dump_vmcs:
virt-APIC addr =3D 0x00000046212ed000
      CPU 0/KVM-251862 [019]  6384.132440: bprint:               dump_vmcs:
PostedIntrVec =3D 0xf2
      CPU 0/KVM-251862 [019]  6384.132441: bprint:               dump_vmcs:=
 EPT
pointer =3D 0x00000040a0db305e
      CPU 0/KVM-251862 [019]  6384.132441: bprint:               dump_vmcs:=
 PLE
Gap=3D00000080 Window=3D00001000
      CPU 0/KVM-251862 [019]  6384.132441: bprint:               dump_vmcs:
Virtual processor ID =3D 0x0011
      CPU 0/KVM-251862 [019]  6384.132441: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: [VMCS12]
      CPU 0/KVM-251862 [019]  6384.132441: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   ENTRY_INTR_INFO=3D0xd1 ENTRY_LEN=3D0  EXIT_REASON=3D0x1
EXIT_INTR_INFO=3D0x80000051 EXIT_INTR_ERR=3D0
      CPU 0/KVM-251862 [019]  6384.132442: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   IDT_VEC_INFO=3D0 IDT_VEC_ERR=3D0 EXIT_LEN=3D0x3 VMX_IN=
SN_INFO=3D0
      CPU 0/KVM-251862 [019]  6384.132442: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   GUEST_INTR_STATUS=3D0 TPR_THRESH=3D0 VAPIC=3D0x1166880=
00
PIDESC=3D0 PINV=3D0
      CPU 0/KVM-251862 [019]  6384.132442: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   EOI_EXIT_BITMAPS: [0]=3D0 [1]=3D0 [2]=3D0 [3]=3D0
      CPU 0/KVM-251862 [019]  6384.132442: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   PINBASED=3D0x3f CPU_BASED=3D0xb6206dfa CPU_BASED2=3D0x=
1010ae
VM_ENTRY_CTRL=3D0x13ff VM_EXIT_CTRL=3D0x3efff
      CPU 0/KVM-251862 [019]  6384.132443: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   RIP=3D0xfffff8012b5f50c2 RSP=3D0xfffffc8791b29fd0
RFLAGS=3D0x40213 INTR_STATE=3D0 ACTV=3D0
      CPU 0/KVM-251862 [019]  6384.132443: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   CR0=3D0x80050033 CR3=3D0x119167000 CR4=3D0x352ef8
EPTP=3D0x1019ab01e
      CPU 0/KVM-251862 [019]  6384.132443: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

VMCS dump for split-irqchip,
      CPU 0/KVM-453395 [001] 12461.840701: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: =3D=3D=3D=3D=3D autodump (VM-ENTER) vcpu=3D0 =
=3D=3D=3D=3D=3D
      CPU 0/KVM-453395 [001] 12461.840702: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: [CURRENT]
      CPU 0/KVM-453395 [001] 12461.840702: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMC: [CURRENT] is vmc01
      CPU 0/KVM-453395 [001] 12461.840702: bprint:               dump_vmcs:
VMCS 0xffff906904c87000, last attempted VM-entry on CPU 1
      CPU 0/KVM-453395 [001] 12461.840702: bputs:                dump_vmcs:=
 ***
Guest State ***
      CPU 0/KVM-453395 [001] 12461.840702: bprint:               dump_vmcs:
CR0: actual=3D0x0000000080010031, shadow=3D0x0000000080010031,
gh_mask=3Dfffffffffffefff7
      CPU 0/KVM-453395 [001] 12461.840702: bprint:               dump_vmcs:
CR4: actual=3D0x00000000000422e0, shadow=3D0x00000000000422e0,
gh_mask=3Dfffffffffffef871
      CPU 0/KVM-453395 [001] 12461.840703: bprint:               dump_vmcs:=
 CR3
=3D 0x0000000101944000
      CPU 0/KVM-453395 [001] 12461.840703: bprint:               dump_vmcs:
PDPTR0 =3D 0x0000000065632001  PDPTR1 =3D 0x0000000065631001
      CPU 0/KVM-453395 [001] 12461.840703: bprint:               dump_vmcs:
PDPTR2 =3D 0x0000000065630001  PDPTR3 =3D 0x000000006562f001
      CPU 0/KVM-453395 [001] 12461.840703: bprint:               dump_vmcs:=
 RSP
=3D 0xffffe70000005fc0  RIP =3D 0xfffff808b8441308
      CPU 0/KVM-453395 [001] 12461.840703: bprint:               dump_vmcs:
RFLAGS=3D0x00000002         DR7 =3D 0x0000000000000400
      CPU 0/KVM-453395 [001] 12461.840704: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_dtsel: GDTR:                           limit=3D0x0000ffff,
base=3D0xfffff808b82232b0
      CPU 0/KVM-453395 [001] 12461.840704: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_dtsel: IDTR:                           limit=3D0x0000ffff,
base=3D0xfffff808b82220b0
      CPU 0/KVM-453395 [001] 12461.840704: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_sel.constprop.0: TR:   sel=3D0x0030, attr=3D0x0008b, limit=3D0x000=
00067,
base=3D0xfffff808b8323320
      CPU 0/KVM-453395 [001] 12461.840704: bprint:               dump_vmcs:
DebugCtl =3D 0x0000000000000000  DebugExceptions =3D 0x0000000000000000
      CPU 0/KVM-453395 [001] 12461.840704: bprint:               dump_vmcs:
Interruptibility =3D 00000000  ActivityState =3D 00000000
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               dump_vmcs:
InterruptStatus =3D 5100
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               vmx_dump_m=
srs:
MSR guest autoload:
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               vmx_dump_m=
srs:
   0: msr=3D0x00000600 value=3D0x0000000000000000
      CPU 0/KVM-453395 [001] 12461.840705: bputs:                dump_vmcs:=
 ***
Host State ***
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               dump_vmcs:=
 RIP
=3D 0xffffffffc0d89630  RSP =3D 0xffffb5c5a0117ce0
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               dump_vmcs:
GDTBase=3Dfffffe5a3972e000 IDTBase=3Dfffffe0000000000
      CPU 0/KVM-453395 [001] 12461.840705: bprint:               dump_vmcs:
CR0=3D0000000080050033 CR3=3D0000000109cee003 CR4=3D0000000000772ef0
      CPU 0/KVM-453395 [001] 12461.840706: bprint:               dump_vmcs:=
 PAT
=3D 0x0407050600070106
      CPU 0/KVM-453395 [001] 12461.840706: bprint:               vmx_dump_m=
srs:
MSR host autoload:
      CPU 0/KVM-453395 [001] 12461.840706: bprint:               vmx_dump_m=
srs:
   0: msr=3D0x00000600 value=3D0xfffffe5a39748000
      CPU 0/KVM-453395 [001] 12461.840706: bputs:                dump_vmcs:=
 ***
Control State ***
      CPU 0/KVM-453395 [001] 12461.840706: bprint:               dump_vmcs:
CPUBased=3D0xb5a26dfa SecondaryExec=3D0x821217eb TertiaryExec=3D0x000000000=
0000010
      CPU 0/KVM-453395 [001] 12461.840706: bprint:               dump_vmcs:
PinBased=3D0x000000ff EntryControls=3D000053ff ExitControls=3D000befff
      CPU 0/KVM-453395 [001] 12461.840707: bprint:               dump_vmcs:
ExceptionBitmap=3D000600c2 PFECmask=3D00000000 PFECmatch=3D00000000
      CPU 0/KVM-453395 [001] 12461.840707: bprint:               dump_vmcs:
VMEntry: intr_info=3D00000000 errcode=3D00000000 ilen=3D00000000
      CPU 0/KVM-453395 [001] 12461.840707: bprint:               dump_vmcs:
VMExit: intr_info=3D00000000 errcode=3D00000000 ilen=3D00000003
      CPU 0/KVM-453395 [001] 12461.840707: bprint:               dump_vmcs:=
=20=20=20=20
    reason=3D00000018 qualification=3D0000000000000000
      CPU 0/KVM-453395 [001] 12461.840708: bprint:               dump_vmcs:
IDTVectoring: info=3D00000000 errcode=3D00000000
      CPU 0/KVM-453395 [001] 12461.840708: bprint:               dump_vmcs:=
 TSC
Offset =3D 0xffffe9399281aa53
      CPU 0/KVM-453395 [001] 12461.840708: bprint:               dump_vmcs:=
 TSC
Multiplier =3D 0x0001000000000000
      CPU 0/KVM-453395 [001] 12461.840708: bprint:               dump_vmcs:
SVI|RVI =3D 51|00
      CPU 0/KVM-453395 [001] 12461.840708: bprint:               dump_vmcs:=
 TPR
Threshold =3D 0x00
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:
APIC-access addr =3D 0x000000012e1ad000
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:
virt-APIC addr =3D 0x0000004605554000
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:
PostedIntrVec =3D 0xf2
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:=
 EPT
pointer =3D 0x00000001bdfa805e
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:=
 PLE
Gap=3D00000080 Window=3D00001000
      CPU 0/KVM-453395 [001] 12461.840709: bprint:               dump_vmcs:
Virtual processor ID =3D 0x0011
      CPU 0/KVM-453395 [001] 12461.840710: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: [VMCS12]
      CPU 0/KVM-453395 [001] 12461.840710: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   ENTRY_INTR_INFO=3D0xd1 ENTRY_LEN=3D0  EXIT_REASON=3D0x1
EXIT_INTR_INFO=3D0x80000051 EXIT_INTR_ERR=3D0
      CPU 0/KVM-453395 [001] 12461.840710: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   IDT_VEC_INFO=3D0 IDT_VEC_ERR=3D0 EXIT_LEN=3D0x5 VMX_IN=
SN_INFO=3D0
      CPU 0/KVM-453395 [001] 12461.840710: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   GUEST_INTR_STATUS=3D0 TPR_THRESH=3D0 VAPIC=3D0x1166870=
00
PIDESC=3D0 PINV=3D0
      CPU 0/KVM-453395 [001] 12461.840711: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   EOI_EXIT_BITMAPS: [0]=3D0 [1]=3D0 [2]=3D0 [3]=3D0
      CPU 0/KVM-453395 [001] 12461.840711: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   PINBASED=3D0x3f CPU_BASED=3D0xb6206dfa CPU_BASED2=3D0x=
1010ae
VM_ENTRY_CTRL=3D0x13ff VM_EXIT_CTRL=3D0x3efff
      CPU 0/KVM-453395 [001] 12461.840711: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   RIP=3D0xfffff8035aff73fc RSP=3D0xffffc18d6b729f58
RFLAGS=3D0x40246 INTR_STATE=3D0 ACTV=3D0
      CPU 0/KVM-453395 [001] 12461.840711: bprint:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
vmx_dump_01_02_12:   CR0=3D0x80050033 CR3=3D0x11912e000 CR4=3D0x352ef8
EPTP=3D0x1019aa01e
      CPU 0/KVM-453395 [001] 12461.840711: bputs:=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
vmx_dump_01_02_12: KVM/VMX: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The full VMCS dumps + kvm tracepoints near the first level triggered interr=
upt
for kernel-irqchip are here: https://pastebin.com/2tnN6Xfy, and for
split-irqchip are here: https://pastebin.com/K1BKZYvv

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

