Return-Path: <kvm+bounces-62727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B71AC4C288
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B3A9D4E9D60
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 07:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E012233D85;
	Tue, 11 Nov 2025 07:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdplVH3M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4084F2BB17
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 07:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762847294; cv=none; b=DjvkdGnHAUJFLQU02fSUw+3L0MiVXZTtIiz8ZGVd58spDFKUFQNQzxVugjVGJMQ4HFpV1PlA5MQcpMTVb7v06Zy8UUeHG6V0KU6PR/02CY8YrQcLZ7GVTpyKXjElsl7U5A5L/qdsRJYjMbqUxnuEoJ5XG06lh6itlr26280R/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762847294; c=relaxed/simple;
	bh=OcLSix6WhpwrU+wxdLOIy5RP+J/Z1i4yAqlx68wo7Rk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Nsib1cpoJBXfgrv9aOMApnovOWSmnTtpoVaeYUle3SZ17MC+I/Cosi57WaXDxmzVKZucafgLcvL4jhqCa3InosKDMKp+JbW+IYzHSuBb5TfevHLeAawjkRL5FLYVZ2z/2MmrqtE+PyGDbIjhlUpHOgviOK4XUz+pvef1knMjV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdplVH3M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A178C116B1
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 07:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762847291;
	bh=OcLSix6WhpwrU+wxdLOIy5RP+J/Z1i4yAqlx68wo7Rk=;
	h=From:To:Subject:Date:From;
	b=XdplVH3MZ45LIbVQ6qcxd/iMX0IBEHqnacYzUzDlnFkKN4Dc8kFGDDUmH72IU/iii
	 alEajfyorDTiHmrjnirEWdGIN0gcu0JwTtagngs6MIluBflqwJ+LmCjRX4KJHPQW5E
	 r+iB1ax0mevZF5RxEIcv9OBLdRa/XW4HY0cU9yUHtG/TDpBngQZomeipdNgTi21p/B
	 i0811qG7UWa7R0IzxEjOjnBwtiYGBEQjZp19h/7N2dQJsw6iPeOUlvI0VgRxz0/iDT
	 r9KPUKTqQzWcCoNnln2t23DVSDjDdEEswkag5fwH7Rp1RVEgLZNtC9kN6M4+/f6KQX
	 FwdxHFt0jRWVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1B924CAB787; Tue, 11 Nov 2025 07:48:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220776] New: When passthrough device to KVM guest with
 iommufd+hugepage, more hugepage are used than assigned, and DMAR error
 reported from host dmesg
Date: Tue, 11 Nov 2025 07:48:08 +0000
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
Message-ID: <bug-220776-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220776

            Bug ID: 220776
           Summary: When passthrough device to KVM guest with
                    iommufd+hugepage, more hugepage are used than
                    assigned, and DMAR error reported from host dmesg
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

kernel: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master dc77806cf3b

qemu: https://gitlab.com/qemu-project/qemu.git master 909772f0a5

Bug detail description:

When passthrough device to KVM guest with iommufd+hugepage, if 4G hugepage =
is
assigned in qemu command, but 5G+ hugepage are used by qemu process.
Meanwhile, error message reported from device driver in guest, and DMAR err=
or
reported from host dmesg.

I reproduced this issue on both Intel I210 NIC and Broadcom BCM57416 NIC:
Intel Corporation I210 Gigabit Network Connection (rev 03)
Broadcom Inc. and subsidiaries BCM57416 NetXtreme-E Dual-Media 10G RDMA
Ethernet Controller (rev 01)

Reproduce steps:=20

Create 8G 2M hugepage:
echo 4096  > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
mount -t hugetlbfs hugetlbfs /dev/hugepages -o pagesize=3D2M

Bind I210 NIC 2a:00.0 to vfio-pci:
modprobe vfio-pci
echo 0000:3e:00.0 > /sys/bus/pci/devices/0000\:2a\:00.0/driver/unbind
echo 8086 1533 > /sys/bus/pci/drivers/vfio-pci/new_id

Check host hugepage status:
[root@gnr-sp-2s-605 fchen]# cat /proc/meminfo | grep -i huge
AnonHugePages:     98304 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:    4096
HugePages_Free:     4096
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         8388608 kB

Boot Guest with I210 assigned(iommufd) and 4G hugepage:
/home/fchen/qemu/build/qemu-system-x86_64 \
    -name legacy,debug-threads=3Don \
    -machine q35 \
    -m 4G -mem-path /dev/hugepages/ \
    -accel kvm \
    -smp 4 -cpu host \
    -drive file=3D${img},if=3Dnone,id=3Dvirtio-disk0 \
    -device virtio-blk-pci,drive=3Dvirtio-disk0 \
    -monitor telnet:127.0.0.1:45454,nowait,server \
    -vnc :1 \
    -object iommufd,id=3Diommufd0 \
    -device vfio-pci,host=3D3e:00.0,iommufd=3Diommufd0 \
    -serial stdio

Error log:

Check host hugepage status after guest boot:
[root@gnr-sp-2s-605 ~]# cat /proc/meminfo | grep -i huge
AnonHugePages:    116736 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:    4096
HugePages_Free:     1408
HugePages_Rsvd:     1408
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         8388608 kB

Below guest and host dmesg error can only be captured when this NIC is
connected  with calble(IP available in host). If no cable connected in the =
NIC,
no such error, only hugepage size error can be found.
guest dmesg:
[ =C2=A0 14.713154] igb 0000:00:04.0: Detected Tx Unit Hang
[ =C2=A0 14.713154] =C2=A0 Tx Queue =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 <1>
[ =C2=A0 14.713154] =C2=A0 TDH =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0<0>
[ =C2=A0 14.713154] =C2=A0 TDT =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0<1>
[ =C2=A0 14.713154] =C2=A0 next_to_use =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<1>
[ =C2=A0 14.713154] =C2=A0 next_to_clean =C2=A0 =C2=A0 =C2=A0 =C2=A0<0>
[ =C2=A0 14.713154] buffer_info[next_to_clean]
[ =C2=A0 14.713154] =C2=A0 time_stamp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <f=
ffb9477>
[ =C2=A0 14.713154] =C2=A0 next_to_watch =C2=A0 =C2=A0 =C2=A0 =C2=A0<000000=
0015eda9d3>
[ =C2=A0 14.713154] =C2=A0 jiffies =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0<fffba4aa>
[ =C2=A0 14.713154] =C2=A0 desc.status =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<1=
b8000>
...
We can also see below error in some systems' host dmesg:
host dmesg:
[23560.951863] DMAR: DRHD: handling fault status reg 2
[23560.957541] DMAR: [DMA Write NO_PASID] Request device [3e:00.0] fault ad=
dr
0x7efef4f08000 [fault reason 0x79] SM: Read/Write permission error in
second-level paging entry

Expected result:
1. No Error in guest and host dmesg.
2. If without iommufd, the free hugepages are 2048, which means QEMU process
used 4G hugepage indeed. But now with iommufd, it used 2688(4096-1408) 2M(5=
.25G
in total) hugepages.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

