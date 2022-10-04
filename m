Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F297B5F46E1
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJDPpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 11:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiJDPpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 11:45:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC39419A1;
        Tue,  4 Oct 2022 08:45:06 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294FTRt6032471;
        Tue, 4 Oct 2022 15:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zcXDf3ztco2AmTKO85GGCB+RCf/b5toXTLR6fn+MulQ=;
 b=B3nboelaERE6vxhx0kPm1MkOr9FomyySuvRycrXbJDzGJwOnukj71ZfNxzLZSs+BtscQ
 fH6yV17VZ8R/60urXjW6p8vrPWKS6F5572febbOwe+bnC4c3xUebSjPWZcT798+ICi8O
 lAxnnwWTJ5wyhsjgvlDIV+WepDjdxwYwHuXnlfs7H+IL677MWI94bQu5/woOT/tKjr5r
 tkRrjOhhYHmQiLaDwvHYy/MzGIz0Cz956xMNnzDmYV+ut/G4dWvrrXsYv0Pn8GVOFpiJ
 fCaI5IZMffsl8r9fEnFEQqUZf+TKcCDcaFFO7t9e9dXpzBQ5cFz9dSEUqIerU5XgXG7F uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2n5cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 15:45:00 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294DvgJH032256;
        Tue, 4 Oct 2022 15:44:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2n5be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 15:44:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294FZwJM027433;
        Tue, 4 Oct 2022 15:44:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3jxctj4e01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 15:44:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294FisfS53936542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 15:44:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B46214C046;
        Tue,  4 Oct 2022 15:44:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 158B64C044;
        Tue,  4 Oct 2022 15:44:54 +0000 (GMT)
Received: from [9.171.7.248] (unknown [9.171.7.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 15:44:53 +0000 (GMT)
Message-ID: <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
Date:   Tue, 4 Oct 2022 17:44:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <YzxT6Suu+272gDvP@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WMEnCz3RLH_dJ_7yUu6bEv8fNI_snqo0
X-Proofpoint-GUID: OK1I63y0MrGguoh9XhzK4uwo6c6sjdId
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040100
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 04.10.22 um 17:40 schrieb Jason Gunthorpe:
> On Tue, Oct 04, 2022 at 05:19:07PM +0200, Christian Borntraeger wrote:
>> Am 27.09.22 um 22:05 schrieb Alex Williamson:
>>> On Mon, 26 Sep 2022 13:03:56 -0400
>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>
>>>> On 9/22/22 8:06 PM, Jason Gunthorpe wrote:
>>>>> The iommu_group comes from the struct device that a driver has been bound
>>>>> to and then created a struct vfio_device against. To keep the iommu layer
>>>>> sane we want to have a simple rule that only an attached driver should be
>>>>> using the iommu API. Particularly only an attached driver should hold
>>>>> ownership.
>>>>>
>>>>> In VFIO's case since it uses the group APIs and it shares between
>>>>> different drivers it is a bit more complicated, but the principle still
>>>>> holds.
>>>>>
>>>>> Solve this by waiting for all users of the vfio_group to stop before
>>>>> allowing vfio_unregister_group_dev() to complete. This is done with a new
>>>>> completion to know when the users go away and an additional refcount to
>>>>> keep track of how many device drivers are sharing the vfio group. The last
>>>>> driver to be unregistered will clean up the group.
>>>>>
>>>>> This solves crashes in the S390 iommu driver that come because VFIO ends
>>>>> up racing releasing ownership (which attaches the default iommu_domain to
>>>>> the device) with the removal of that same device from the iommu
>>>>> driver. This is a side case that iommu drivers should not have to cope
>>>>> with.
>>>>>
>>>>>      iommu driver failed to attach the default/blocking domain
>>>>>      WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
>>>>>      Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
>>>>>      CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
>>>>>      Hardware name: IBM 3931 A01 782 (LPAR)
>>>>>      Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
>>>>>                 R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>>>>>      Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
>>>>>                 00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
>>>>>                 00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
>>>>>                 00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
>>>>>      Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
>>>>>                             000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
>>>>>                            #000000095bb10d24: af000000            mc      0,0
>>>>>                            >000000095bb10d28: b904002a            lgr     %r2,%r10
>>>>>                             000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
>>>>>                             000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
>>>>>                             000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
>>>>>                             000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
>>>>>      Call Trace:
>>>>>       [<000000095bb10d28>] iommu_detach_group+0x70/0x80
>>>>>      ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
>>>>>       [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
>>>>>       [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
>>>>>       [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
>>>>>      pci 0004:00:00.0: Removing from iommu group 4
>>>>>       [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
>>>>>       [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
>>>>>       [<000000095be6c072>] system_call+0x82/0xb0
>>>>>      Last Breaking-Event-Address:
>>>>>       [<000000095be4bf80>] __warn_printk+0x60/0x68
>>>>>
>>>>> It indicates that domain->ops->attach_dev() failed because the driver has
>>>>> already passed the point of destructing the device.
>>>>>
>>>>> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
>>>>> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> ---
>>>>>    drivers/vfio/vfio.h      |  8 +++++
>>>>>    drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
>>>>>    2 files changed, 53 insertions(+), 23 deletions(-)
>>>>>
>>>>> v2
>>>>>    - Rebase on the vfio struct device series and the container.c series
>>>>>    - Drop patches 1 & 2, we need to have working error unwind, so another
>>>>>      test is not a problem
>>>>>    - Fold iommu_group_remove_device() into vfio_device_remove_group() so
>>>>>      that it forms a strict pairing with the two allocation functions.
>>>>>    - Drop the iommu patch from the series, it needs more work and discussion
>>>>> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
>>>>>
>>>>> This could probably use another quick sanity test due to all the rebasing,
>>>>> Alex if you are happy let's wait for Matthew.
>>>>
>>>> I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!
>>>
>>> Thanks all.  Applied to vfio next branch for v6.1.  Thanks,
>>
>> So now I have bisected this to a regression in our KVM CI for vfio-ap. Our testcase MultipleMdevAPMatrixTestCase hangs forever.
>> I see  virtnodedevd spinning 100% and "mdevctl stop --uuid=d70d7685-a1b5-47a1-bdea-336925e0a95d" seems to wait for something:
>>
>> [  186.815543] task:mdevctl         state:D stack:    0 pid: 1639 ppid:  1604 flags:0x00000001
>> [  186.815546] Call Trace:
>> [  186.815547]  [<0000002baf277386>] __schedule+0x296/0x650
>> [  186.815549]  [<0000002baf2777a2>] schedule+0x62/0x108
>> [  186.815551]  [<0000002baf27db20>] schedule_timeout+0xc0/0x108
>> [  186.815553]  [<0000002baf278166>] __wait_for_common+0xc6/0x250
>> [  186.815556]  [<000003ff800c263a>] vfio_device_remove_group.isra.0+0xb2/0x118 [vfio]
>> [  186.815561]  [<000003ff805caadc>] vfio_ap_mdev_remove+0x2c/0x198 [vfio_ap]
>> [  186.815565]  [<0000002baef1d4de>] device_release_driver_internal+0x1c6/0x288
>> [  186.815570]  [<0000002baef1b27c>] bus_remove_device+0x10c/0x198
>> [  186.815572]  [<0000002baef14b54>] device_del+0x19c/0x3e0
>> [  186.815575]  [<000003ff800d9e3a>] mdev_device_remove+0xb2/0x108 [mdev]
>> [  186.815579]  [<000003ff800da096>] remove_store+0x7e/0x90 [mdev]
>> [  186.815581]  [<0000002baea53c30>] kernfs_fop_write_iter+0x138/0x210
>> [  186.815586]  [<0000002bae98e310>] vfs_write+0x1a0/0x2f0
>> [  186.815588]  [<0000002bae98e6d8>] ksys_write+0x70/0x100
>> [  186.815590]  [<0000002baf26fe2c>] __do_syscall+0x1d4/0x200
>> [  186.815593]  [<0000002baf27eb42>] system_call+0x82/0xb0
> 
> Does some userspace have the group FD open when it stucks like this,
> eg what does fuser say?

/proc/<virtnodedevd>/fd
51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'
65272 0 lr-x------. 1 root root 64  4. Okt 17:42 21 -> anon_inode:inotify
65273 0 lr-x------. 1 root root 64  4. Okt 17:42 23 -> 'pipe:[30158]'
65274 0 lr-x------. 1 root root 64  4. Okt 17:42 25 -> 'pipe:[30159]'
51481 0 lrwx------. 1 root root 64  4. Okt 17:16 3 -> 'socket:[43590]'
65255 0 lrwx------. 1 root root 64  4. Okt 17:42 4 -> 'socket:[43591]'
65256 0 lrwx------. 1 root root 64  4. Okt 17:42 5 -> 'socket:[30947]'
65257 0 lrwx------. 1 root root 64  4. Okt 17:42 6 -> 'socket:[51483]'
65258 0 l-wx------. 1 root root 64  4. Okt 17:42 7 -> /run/virtnodedevd.pid
65259 0 lr-x------. 1 root root 64  4. Okt 17:42 8 -> 'pipe:[51484]'
65260 0 l-wx------. 1 root root 64  4. Okt 17:42 9 -> 'pipe:[51484]'

/proc/mdevctl/fd
59494 0 dr-x------. 2 root root  0  4. Okt 17:16 .
59493 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
59495 0 lrwx------. 1 root root 64  4. Okt 17:16 0 -> /dev/null
59496 0 l-wx------. 1 root root 64  4. Okt 17:16 1 -> 'pipe:[30158]'
59497 0 l-wx------. 1 root root 64  4. Okt 17:16 2 -> 'pipe:[30159]'
59498 0 l-wx------. 1 root root 64  4. Okt 17:16 3 -> /sys/devices/vfio_ap/matrix/d70d7685-a1b5-47a1-bdea-336925e0a95d/remove


