Return-Path: <kvm+bounces-4212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5556980F334
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F235281D02
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B590378E96;
	Tue, 12 Dec 2023 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQUbMIsv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89F35FEFE
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 16:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AD38C433C7
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702399076;
	bh=Z82GuhPVjo2Ggsjvho7LTwzcbpktGSf6T+4mpTyUF4E=;
	h=From:To:Subject:Date:From;
	b=bQUbMIsvNlVVF0YBKjCCGs28gScOmpKhO6si8+mjqNvURHokhvZ+EaG2PjtlX5Vrm
	 kH4H6DL2RbfhNhMN83/GWaedti8bZZv9sLPxMep3n7ZWbr9g/M5KVWk1byJnDryUXW
	 MxrFHR1bmu3R8iRIfcGChRD4RoMLRw7B3MPKucUExR3NHW7hPIrko/CpjOuMMVOXjG
	 EM8x+yuTnSs96o/AHjHVg027wvcq1WrEUrlwisuyltjPkYOQT1+cV6Ouuub4k55IbH
	 JPtmzVG9U87/xgzlvTzJhaf6ucKe4/tCTjBBlFSc2wz+MK1yCuBzepHdBGZlGnZDpx
	 I0hy8iYlme2Og==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6D956C53BD1; Tue, 12 Dec 2023 16:37:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] New: High latency in KVM guests
Date: Tue, 12 Dec 2023 16:37:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernelbugs2012@joern-heissler.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

            Bug ID: 218259
           Summary: High latency in KVM guests
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: kernelbugs2012@joern-heissler.de
        Regression: No

Hello,

some of my guests are experiencing heavy latency, e.g.:

* SSH sessions get stuck, sometimes for several seconds, then continue.
* PING replies can take several seconds.
* t0 =3D time(); sleep(1); t1 =3D time(); print(t1 - t0); can show several =
seconds.
* Various services with small timeouts throw errors.
* guest system clock appears to work correctly.

Sometimes this happens once or twice an hour or not for many hours. Usually=
 the
lag is way below
a second, that's why I didn't notice it earlier.
On highly affected hosts this may happen much more often, and often in
clusters, e.g. lots of
time during a span of a few Minutes.

The affected hosts run Debian 12; until Debian 11 there was no trouble.
I git-bisected the kernel and the commit which appears to somehow cause the
trouble is:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Df47e5bbbc92f5d234bbab317523c64a65b6ac4e2

CPU model: Intel(R) Xeon(R) CPU E5-2695 v4 (See below for /proc/cpuinfo)
Host kernels:
    * Debian, linux-image-6.1.0-15-amd64 (6.1.66-1), affected
    * Debian, linux-image-6.5.0-0.deb12.4-amd64 (6.5.10-1~bpo12+1), affected
    * Vanilla, v6.7-rc5, affected
    * Vanilla, v5.17-rc3-349-gf47e5bbbc92f, first affected commit
    * Vanilla, v5.17-rc3-348-ga80ced6ea514, last non-affected commit
    * Vanilla, several other versions during bisecting
Host kernel arch: x86_64
Host RAM: 512 GiB.
Host storage: HW-Raid6 over spinning disks.
Guest: Debian 11, x86_64. Debian Kernels linux-image-5.10.0-26-amd64
(5.10.197-1) and linux-image-6.1.0-0.deb11.13-amd64 (6.1.55-1~bpo11+1).
Qemu command line: See below.
Problem does *not* go away when appending "kernel_irqchip=3Doff" to the -ma=
chine
parameter
Problem *does* go away with "-accel tcg", even though the guest becomes much
slower.

All affected guests run kubernetes with various workloads, mostly Java,
databases like postgres
und a few legacy 32 bit containers.

Best method to manually trigger the problem I found was to drain other
kubernetes nodes, causing
many pods to start at the same time on the affected guest. But even when the
initial load
settled, there's little I/O and the guest is like 80% idle, the problem sti=
ll
occurs.

The problem occurs whether the host runs only a single guest or lots of oth=
er
(non-kubernetes) guests.

Other (i.e. not kubernetes) guests don't appear to be affected, but those g=
ot
way less resources and usually less load.

I adjusted several qemu parameters, e.g. pass-through host cpu, different s=
mp
layout (2
sockets, 4 cores each, 2 threads each), remove memory balloon, add I/O-thre=
ad
for the disk, set
latest supported machine type. None of those resolved the problem.

There are no kernel logs in the host or the guest, and no userspace logs in=
 the
host.

AMD hosts with SSDs seem to be less severely affected, but they still are.

Sadly I couldn't think of any good way to trigger the problem on say a blank
Debian guest.

If I can provide additional information or can run additional tests, please=
 let
me know!

Many thanks in advance!
J=C3=B6rn Heissler

---------

/usr/bin/qemu-system-x86_64
-name guest=3Dk8s-worker6,debug-threads=3Don
-S
-object
{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/var/lib/libv=
irt/qemu/domain-1-k8s-worker6/master-key.aes"}
-machine pc-i440fx-3.1,usb=3Doff,dump-guest-core=3Doff,memory-backend=3Dpc.=
ram
-accel kvm
-cpu qemu64
-m 131072
-object {"qom-type":"memory-backend-ram","id":"pc.ram","size":137438953472}
-overcommit mem-lock=3Doff
-smp 16,sockets=3D16,cores=3D1,threads=3D1
-uuid 2c220b5b-9d0a-4d41-a13e-cd78c5551b35
-no-user-config
-nodefaults
-chardev socket,id=3Dcharmonitor,fd=3D30,server=3Don,wait=3Doff
-mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol
-rtc base=3Dutc
-no-shutdown
-boot menu=3Don,strict=3Don
-device {"driver":"piix3-usb-uhci","id":"usb","bus":"pci.0","addr":"0x1.0x2=
"}
-blockdev
{"driver":"host_device","filename":"/dev/vg-kvm/k8s-worker6_root","node-nam=
e":"libvirt-1-storage","cache":{"direct":true,"no-flush":false},"auto-read-=
only":true,"discard":"unmap"}
-blockdev
{"node-name":"libvirt-1-format","read-only":false,"cache":{"direct":true,"n=
o-flush":false},"driver":"raw","file":"libvirt-1-storage"}
-device
{"driver":"virtio-blk-pci","bus":"pci.0","addr":"0x4","drive":"libvirt-1-fo=
rmat","id":"virtio-disk0","bootindex":1,"write-cache":"on"}
-netdev {"type":"tap","fd":"32","vhost":true,"vhostfd":"34","id":"hostnet0"}
-device
{"driver":"virtio-net-pci","netdev":"hostnet0","id":"net0","mac":"52:54:00:=
e7:56:ae","bus":"pci.0","addr":"0x3"}
-chardev pty,id=3Dcharserial0
-device
{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}
-audiodev {"id":"audio1","driver":"none"}
-vnc 127.0.0.1:0,audiodev=3Daudio1
-device {"driver":"cirrus-vga","id":"video0","bus":"pci.0","addr":"0x2"}
-incoming defer
-device
{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.0","addr":"0x5"}
-sandbox
on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcecontrol=3D=
deny
-msg timestamp=3Don

---------

processor       : 71
vendor_id       : GenuineIntel
cpu family      : 6
model           : 79
model name      : Intel(R) Xeon(R) CPU E5-2695 v4 @ 2.10GHz
stepping        : 1
microcode       : 0xb000040
cpu MHz         : 3300.000
cache size      : 46080 KB
physical id     : 1
siblings        : 36
core id         : 27
cpu cores       : 18
apicid          : 119
initial apicid  : 119
fpu             : yes
fpu_exception   : yes
cpuid level     : 20
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch
cpuid_fault epb cat_l3 cdp_l3 invpcid_single pti intel_ppin ssbd ibrs ibpb
stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1=
 hle
avx2 smep bmi2 erms invpcid rtm cqm rdt_a rdseed adx smap intel_pt xsaveopt
cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm ida arat pln pts
md_clear flush_l1d
vmx flags       : vnmi preemption_timer posted_intr invvpid ept_x_only ept_=
ad
ept_1gb flexpriority apicv tsc_offset vtpr mtf vapic ept vpid
unrestricted_guest vapic_reg vid ple shadow_vmcs pml
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf=
 mds
swapgs taa itlb_multihit mmio_stale_data
bogomips        : 4199.23
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

