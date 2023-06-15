Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E130D7314A7
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243843AbjFOJzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 05:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343704AbjFOJzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 05:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8BC2967
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 02:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5A9616DB
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB76EC433C0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686822877;
        bh=t/KMvIpBxzno0jtQg6hP1elsW1RPaaJZfkbnjtwWkp8=;
        h=From:To:Subject:Date:From;
        b=Nxh4Iz4wBmozo6qfUuEeU84PKl/Vxbs/TEAX8ZnZRyMnlUAvrJTjqrbtw3by2hzIC
         1J1fuEIAhNc2TFYONEd8f6yTMWy+g1RrtSRShbJbe8C6RlNOF03VOGgCMgLJLuNWLv
         KAg6dbCs/V/HqURcvQHSRdFRTo6KPkraYwRuBH+IreT/kBgNvu+MNz/J499Gx/ZlDZ
         f0WabXcBqMXB9z6m2YDGJlCe6Am4nzJsTKPmmB3nRbhTVwz5rDVROYs3vtmjE5ZtPl
         OqrTjS7AfNtCJfU2CIlljK6iC0MR7aB0wqO1IvX+VClXxV/+D2U1QbgDpWtwc9R0w1
         +66rTmcbxFeuA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DB489C53BD1; Thu, 15 Jun 2023 09:54:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] New: In KVM guest with VF of X710 NIC passthrough, the
 mac address of VF is inconsistent with it in host
Date:   Thu, 15 Jun 2023 09:54:36 +0000
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
Message-ID: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

            Bug ID: 217558
           Summary: In KVM guest with VF of X710 NIC passthrough, the mac
                    address of VF is inconsistent with it in host
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

kernel: https://git.kernel.org/pub/scm/virt/kvm/kvm.git branch: next commit:
39428f6e kernel version:6.4.0-rc2
Qemu: https://gitlab.com/qemu-project/qemu.git branch: master commit: 7efd6=
542
Host OS: CentOS stream 9
Guest OS: CentOS stream 9
CPU:
Architecture:            x86_64
Vendor ID:               GenuineIntel
  BIOS Vendor ID:        Intel(R) Corporation
  Model name:            Intel(R) Xeon(R) Platinum

Bug detail description:=20

Create VF of X710 NIC on host, create VM with VF passthrough, there is a
probability that the mac of VF in guest is inconsistent with it in host, th=
e VF
in guest gets a random mac.=20

Reproduce steps:=20

1.Create two VFs of NIC X710:

[root@spr-2s2 ~]# lspci -k -s 98:00.0
98:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for
10GbE SFP+ (rev 01)
        Subsystem: Intel Corporation Ethernet Converged Network Adapter X71=
0-2
        Kernel driver in use: i40e
        Kernel modules: i40e
[root@spr-2s2 ~]# echo 2 > /sys/bus/pci/devices/0000:98:00.0/sriov_numvfs

2. Check mac and driver of the 2 VFs

[root@spr-2s2 xf]# ip address

14: ens28f0v0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
group default qlen 1000
    link/ether 32:40:f7:6a:dc:8a brd ff:ff:ff:ff:ff:ff
    altname enp152s0f0v0
15: ens28f0v1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
group default qlen 1000
    link/ether 6e:bd:a8:ee:83:c4 brd ff:ff:ff:ff:ff:ff
    altname enp152s0f0v1

[root@spr-2s2 xf]# ethtool -i ens28f0v0
driver: iavf
version: 6.4.0-rc2
bus-info: 0000:98:02.0
[root@spr-2s2 xf]# ethtool -i ens28f0v1
driver: iavf
version: 6.4.0-rc2
bus-info: 0000:98:02.1

[root@spr-2s2 xf]# lspci -k -s 98:02.0
98:02.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 700
Series (rev 01)
        Subsystem: Intel Corporation Device 0000
        Kernel driver in use: iavf
        Kernel modules: iavf
[root@spr-2s2 xf]# lspci -k -s 98:02.1
98:02.1 Ethernet controller: Intel Corporation Ethernet Virtual Function 700
Series (rev 01)
        Subsystem: Intel Corporation Device 0000
        Kernel driver in use: iavf
        Kernel modules: iavf

3. Unbind the VFs from iavf driver and bind them to vfio-pci

[root@spr-2s2 xf]# echo 0000:98:02.0 >
/sys/bus/pci/devices/0000\:98\:02.0/driver/unbind
[root@spr-2s2 xf]# echo 0000:98:02.1 >
/sys/bus/pci/devices/0000\:98\:02.1/driver/unbind

[root@spr-2s2 xf]# modprobe vfio-pci
[root@spr-2s2 xf]# lspci -n -s 98:02.0
98:02.0 0200: 8086:154c (rev 01)
[root@spr-2s2 xf]# echo 8086 154c > /sys/bus/pci/drivers/vfio-pci/new_id
[root@spr-2s2 xf]# lspci -k -s 98:02.0
98:02.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 700
Series (rev 01)
        Subsystem: Intel Corporation Device 0000
        Kernel driver in use: vfio-pci
        Kernel modules: iavf
[root@spr-2s2 xf]# lspci -k -s 98:02.1
98:02.1 Ethernet controller: Intel Corporation Ethernet Virtual Function 700
Series (rev 01)
        Subsystem: Intel Corporation Device 0000
        Kernel driver in use: vfio-pci
        Kernel modules: iavf

4.Create guest with these 2 VFs passthrough

qemu-system-x86_64 -accel kvm -m 4096 -cpu host -drive
file=3Dcentos9.qcow2,if=3Dnone,id=3Dvirtio-disk0 -device
virtio-blk-pci,drive=3Dvirtio-disk0,bootindex=3D0 -smp 4 -device
vfio-pci,host=3D98:02.0 -net none -device vfio-pci,host=3D98:02.1 -net none
-daemonize -vnc :5

5. Check the mac and ip address of the these 2 VFs in guest

[root@localhost ~]# ip ad
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group
default qlen 1000
    link/ether c2:4e:37:99:fc:ff brd ff:ff:ff:ff:ff:ff
    altname enp0s4
    inet 192.168.111.27/20 brd 192.168.111.255 scope global dynamic
noprefixroute ens4
       valid_lft 278sec preferred_lft 278sec
    inet6 fe80::ac6c:bd39:6513:d29/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group
default qlen 1000
    link/ether 6e:bd:a8:ee:83:c4 brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    inet 192.168.111.26/20 brd 192.168.111.255 scope global dynamic
noprefixroute ens5
       valid_lft 276sec preferred_lft 276sec
    inet6 fe80::7a32:aa2c:c2ee:8d5d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

The mac of VF1 in host is 32:40:f7:6a:dc:8a, but it in guest is
c2:4e:37:99:fc:ff, VF2 gets the same mac 6e:bd:a8:ee:83:c4

The guest dmesg about iavf:

[    3.516623] iavf: Intel(R) Ethernet Adaptive Virtual Function Network Dr=
iver
[    3.517302] Copyright (c) 2013 - 2018 Intel Corporation.
[    3.588858] ppdev: user-space parallel port driver
[    3.590703] iavf 0000:00:04.0: Invalid MAC address 00:00:00:00:00:00, us=
ing
random
[    3.592382] iavf 0000:00:04.0: Multiqueue Enabled: Queue pair count =3D 4
[    3.593697] iavf 0000:00:05.0: Multiqueue Enabled: Queue pair count =3D 4
[    3.594086] iavf 0000:00:04.0: MAC address: c2:4e:37:99:fc:ff
[    3.595297] iavf 0000:00:04.0: GRO is enabled
[    3.595932] iavf 0000:00:05.0: MAC address: 6e:bd:a8:ee:83:c4
[    3.596503] iavf 0000:00:05.0: GRO is enabled
[    3.598333] iavf 0000:00:04.0 ens4: renamed from eth0
[    3.606666] XFS (vda2): Mounting V5 Filesystem
8736b23e-ddde-4cca-9166-2623d2e57e5a
[    3.606987] iavf 0000:00:05.0 ens5: renamed from eth1
[    3.614474] XFS (vda2): Ending clean mount
[    3.692511] RPC: Registered named UNIX socket transport module.
[    3.693055] RPC: Registered udp transport module.
[    3.693665] RPC: Registered tcp transport module.
[    3.694243] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.125995] iavf 0000:00:04.0 ens4: NIC Link is Up Speed is 10 Gbps Full
Duplex
[    4.126628] IPv6: ADDRCONF(NETDEV_CHANGE): ens4: link becomes ready
[    4.158025] iavf 0000:00:05.0 ens5: NIC Link is Up Speed is 10 Gbps Full
Duplex
[    4.158648] IPv6: ADDRCONF(NETDEV_CHANGE): ens5: link becomes ready

Currect Result:

There is a probability that the mac of VF in guest is inconsistent with it =
in
host

Expected Result

When passthrough NIC VF to guest, the VF in guest should always get the same
mac as it in host.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
