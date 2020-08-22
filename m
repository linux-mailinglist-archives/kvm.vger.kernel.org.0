Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3724E672
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgHVIq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Aug 2020 04:46:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgHVIqz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Aug 2020 04:46:55 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07M8X2NR070835
        for <kvm@vger.kernel.org>; Sat, 22 Aug 2020 04:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : from : subject
 : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=aebO1AEz5Y4iv14O44y6TGomlwHUh6VEtAU/ECiLH0s=;
 b=fsrqbQQoWm5QySb125pyU4hthgt9Yj9yxkzpsQkDmMtgSBVGrGdJ4OZWNtndEImIx3RL
 qghGsc8GLYDC3bYfUNlm9l/ufWPpYxYVhHLWRkUDk8WkBi7P5ukQOib1v16FmX2YqDve
 ru9kNkenhZZjOEhdQQl6lxvMsIopwetoNLU8g6rYJ3X2dxdnquRDUIP3zeEkI5ZrLMvU
 rE8a/Nr49lAk3psAnZoSnQAIK8w3672xui7/3n+yHaV3+9gPqDrDoO0j7Idc7ZVFKmvr
 VmzCwQLzNXHe9fEQxbttqim3zDnw3/kHLFXnyR/O83PyWCjoySbwibPrmX/FLwOPWyiW oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332yehgpmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 22 Aug 2020 04:46:54 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07M8h83j131678
        for <kvm@vger.kernel.org>; Sat, 22 Aug 2020 04:46:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332yehgpm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 Aug 2020 04:46:54 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07M8hWxp008176;
        Sat, 22 Aug 2020 08:46:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk687e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 Aug 2020 08:46:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07M8ko9c29098442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Aug 2020 08:46:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29737A404D;
        Sat, 22 Aug 2020 08:46:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D28DAA4040;
        Sat, 22 Aug 2020 08:46:49 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.31.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 22 Aug 2020 08:46:49 +0000 (GMT)
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Subject: vfio-pci regression on x86_64 and Kernel v5.9-rc1
Message-ID: <6d0a5da6-0deb-17c5-f8f5-f8113437c2d6@linux.ibm.com>
Date:   Sat, 22 Aug 2020 10:46:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_06:2020-08-21,2020-08-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008220090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Hi Cornelia,

yesterday I wanted to test a variant of Matthew's patch for our detached VF
problem on an x86_64 system, to make sure we don't break anything there.
However I seem to have stumbled over a vfio-pci regression in v5.9-rc1
(without the patch), it works fine on 5.8.1. 
I haven't done a bisect yet but will as soon as I get to it.

The problem occurs immediately when attaching or booting a KVM VM with
a vfio-pci pass-through. With virsh I get:

% sudo virsh start ubuntu20.04
[sudo] password for XXXXXX:
error: Failed to start domain ubuntu20.04
error: internal error: qemu unexpectedly closed the monitor: 2020-08-22T08:21:12.663319Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
2020-08-22T08:21:12.663344Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
2020-08-22T08:21:12.663360Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
2020-08-22T08:21:12.667207Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
2020-08-22T08:21:12.667265Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: vfio 0000:03:10.2: failed to setup container for group 54: memory listener initialization failed: Region pc.ram: vfio_dma_map(0x55ceedea1610, 0x0, 0xa0000, 0x7efcc7e00000) = -12 (Cannot allocate memory)

and in dmesg:

[  379.368222] VFIO - User Level meta-driver version: 0.3
[  379.435459] ixgbe 0000:03:00.0 enp3s0: VF Reset msg received from vf 1
[  379.663384] cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or net_cls activation
[  379.764947] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
[  379.764972] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
[  379.764989] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
[  379.768836] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
[  379.979310] ixgbevf 0000:03:10.2: enabling device (0000 -> 0002)
[  379.979505] ixgbe 0000:03:00.0 enp3s0: VF Reset msg received from vf 1
[  379.992624] ixgbevf 0000:03:10.2: 2e:7a:3e:95:5d:be
[  379.992627] ixgbevf 0000:03:10.2: MAC: 1
[  379.992629] ixgbevf 0000:03:10.2: Intel(R) 82599 Virtual Function
[  379.993594] ixgbevf 0000:03:10.2 enp3s0v1: renamed from eth1
[  380.043490] ixgbevf 0000:03:10.2: NIC Link is Up 1 Gbps
[  380.045081] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0v1: link becomes ready

This does not seem to be device related, I initially tried with
a VF of an Intel 82599 10 Gigabit NIC but also tried other
physical PCI devices. I also initially tried increasing the ulimit
but looking at the code it seems the limit is actually 9663676416 bytes
so that should be plenty.

Simply rebooting into v5.8.1 (official Arch Linux Kernel but that's
pretty much exactly Greg's stable series and I based my config on its config)
fixes the issue and the same setup works perfectly.
In most documentation people only use Intel boxes for pass-through
so I should mention that this is a AMD Ryzen 9 3900X
with Starship/Matisse IOMMU and my Kernel command line contains
"amd_iommu=on iommu=pt".
Does any of this ring a bell for you or do we definitely need
a full bisect or any other information?

Best regards,
Niklas Schnelle
