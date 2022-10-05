Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F2E5F5AC2
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJETzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 15:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJETzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 15:55:08 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564944623F
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 12:55:07 -0700 (PDT)
Date:   Wed, 05 Oct 2022 19:54:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1664999703; x=1665258903;
        bh=ygjTo8reVx2XjO/O5ENZntwsGUDohh4oiG5NtkdsuD4=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=zaGRQr9qEBFEBjk4kZeoyQ3abMdkvaPcTzDN7KWtcWMSs7NkIK+yCuyERgHrOZ1CC
         FqN/ZpS/Fx3OHf7gsRvl1DdpEeZjunmZh9yOQ1Z2ioc/VfIuz7L+SBipcRE27anX29
         ityCVxfNAXrp6lPk9yJyhDUm7HHT2MwDB9mVACEOBHUgAc0GZoGYrB/M7/+WeWgJHA
         CTaz5OJ/DtWGv9PPQJoedKcJ1LDURNO3Tq7ZSYMJB0u/Zs+8DfX3Ou0TYvCtXdb2nT
         FPQBeFj/SJ0U6GxlSnmSK8XKIVz7z8Nhr+TSiJdlRofNpEiqfoUxSTTLXUlAclyC06
         bf8yuPgIm17nA==
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   kvmuser99 <kvmuser99@protonmail.com>
Subject: High pings when using SR-IOV w\ macvtap & virtio
Message-ID: <tlj1hWXnQMMaNewClFlGqKRaIsW8eQbW6dKlNGqGPviS-AoqJYQXoqPx6_sIOB6AzPVZuuncLtTIIUsZHerZagf9AuheA5OPwxq-MKFCrhU=@protonmail.com>
Feedback-ID: 56853544:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM Team,

I'm going to the mailing lists because I'm at a loss.=C2=A0 I have thousand=
s of Linux (CentOS 7) VMs deployed and a very small percent of them get int=
o a state when there's some amount of network IO the guests will constantly=
 clock high ping times (> 100 ms local network) and performance will suffer=
.=C2=A0 Some hosts will always clock the high ping times, other times runni=
ng a CLI speedtest will cause the condition to surface.

Rebooting the guest does not solve the issue but a reboot of the host does =
for awhile.=C2=A0 Running something such as the following helps in most cas=
es.=C2=A0 For reference eth0 is the physical interface from which all the V=
Fs come from.

=3D=3D=3D
=C2=A0 126 =C2=A0ethtool -L eth0 combined 16 <-- Arbitrary number=C2=A0=20
128 =C2=A0ethtool -L eth0 combined 4 <--- Number of CPU reserved for the ho=
st (it as previously set to this)
=3D=3D=3D

In most of the scenarios pings even to a 'bridge' interface which just hand=
les guest\host communication also shoot high even though there is low netwo=
rk IO on that particular interface.


Config is as follows

-   Queues =3D number of CPU assigned to guest
-   Affinity is enabled.
   =20

=3D=3D=3D
=C2=A0 =C2=A0 <interface type=3D'direct' trustGuestRxFilters=3D'yes'>=C2=
=A0 =C2=A0 =C2=A0 <mac address=3D'MACHERE'/>
=C2=A0 =C2=A0 =C2=A0 <source dev=3D'eth26' mode=3D'passthrough'/>
=C2=A0 =C2=A0 =C2=A0 <model type=3D'virtio'/>
=C2=A0 =C2=A0 =C2=A0 <driver name=3D'vhost' queues=3D'5'/>
=C2=A0 =C2=A0 =C2=A0 <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' s=
lot=3D'0x03' function=3D'0x0'/>
=C2=A0 =C2=A0 </interface>
=3D=3D=3D=3D=3D


=3D=3D=3D
lshw -c network -businfo
pci@0000:03:02.5 =C2=A0eth12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 network =
=C2=A0 =C2=A0 =C2=A0 =C2=A0Ethernet Virtual Function 700 Series

ip link show | grep eth12
26: eth12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mod=
e DEFAULT group default qlen 1000110: macvtap30@eth12: <BROADCAST,MULTICAST=
,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default=
 qlen 5000

=3D=3D=3D=3D

Info about the interface

=3D=3D=3D
[root@HOST~]# ethtool -k eth12Features for eth12:
rx-checksumming: on
tx-checksumming: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-checksum-ipv4: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-checksum-ip-generic: off [fixed]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-checksum-ipv6: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-checksum-fcoe-crc: off [fixed]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-checksum-sctp: on
scatter-gather: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-scatter-gather: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-tcp-segmentation: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-tcp-ecn-segmentation: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-tcp6-segmentation: on
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tx-tcp-mangleid-segmentation: on
udp-fragmentation-offload: off [fixed]
generic-segmentation-offload: on
generic-receive-offload: off
large-receive-offload: off [fixed]
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off [fixed]
receive-hashing: on
highdma: on
rx-vlan-filter: on [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: on
tx-ipip-segmentation: on
tx-sit-segmentation: on
tx-udp_tnl-segmentation: on
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
busy-poll: off [fixed]
tx-gre-csum-segmentation: on
tx-udp_tnl-csum-segmentation: on
tx-gso-partial: on
tx-sctp-segmentation: off [fixed]
rx-gro-hw: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: on
rx-udp_tunnel-port-offload: off [fixed]
=3D=3D=3D=3D


Versions
=3D=3D=3D
cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)



modinfo i40efilename: =C2=A0 =C2=A0 =C2=A0 /lib/modules/3.10.0-957.el7.x86_=
64/kernel/drivers/net/ethernet/intel/i40e/i40e.ko.xz
version: =C2=A0 =C2=A0 =C2=A0 =C2=A02.3.2-k
license: =C2=A0 =C2=A0 =C2=A0 =C2=A0GPL
description: =C2=A0 =C2=A0Intel(R) Ethernet Connection XL710 Network Driver
author: =C2=A0 =C2=A0 =C2=A0 =C2=A0 Intel Corporation, <e1000-devel@lists.s=
ourceforge.net>
retpoline: =C2=A0 =C2=A0 =C2=A0Y
rhelversion: =C2=A0 =C2=A07.6

uname -r3.10.0-957.el7.x86_64

/usr/libexec/qemu-kvm -version
QEMU emulator version 5.1.0

=3D=3D=3D=3D=3D


-kvmuser99

