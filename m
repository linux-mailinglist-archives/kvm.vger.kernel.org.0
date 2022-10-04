Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27075F49F7
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJDT7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 15:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJDT7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 15:59:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A60769F58
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 12:59:32 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294J63hi004696;
        Tue, 4 Oct 2022 19:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PDQRuYMnRkv1V49WV6yaklwNm+Zl3VjLVJ1M2m8X6k4=;
 b=pwb4g29uSvvUQKt5WoYHO6xDasl7/+AvE9lmZ44miiV6rIz0n9O4fbNHZLu4uP0/xDmt
 jXM6/ZE6Fu/Vbap5QC285riBreI/g5QQTo3GxMICUijiuDjqLxTGFVG/FkYK/CjhJxT9
 f6Si1F4vQ3iwbdQSPm4hNyOBUlVjNoy8nRJ3Os71XRJcC0qY3RAHbV1fa9HhR/utwAgm
 DGeSol4Z1xujHcTByh5HRz4X/BGHvJY//6uuJAzAl1WQXDAWCiP4V8mJLR89hhPs34Z4
 r/fwJpx1fuWVztnJjGRtC1eCk3uMBeabgwaMq6nlVVkPNZeEhx+ESc9GPMPzxtGWQ/Ev jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0fcappj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 19:59:25 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294J6BVu005595;
        Tue, 4 Oct 2022 19:59:24 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0fcapphu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 19:59:24 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294JpFIF015984;
        Tue, 4 Oct 2022 19:59:23 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3jxd69vpd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 19:59:23 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294JxMC74784742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 19:59:22 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E8E458061;
        Tue,  4 Oct 2022 19:59:20 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E8535807D;
        Tue,  4 Oct 2022 19:59:19 +0000 (GMT)
Received: from [9.77.144.104] (unknown [9.77.144.104])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 19:59:19 +0000 (GMT)
Message-ID: <051b7348-92d3-3528-3d29-4c9da1153d4e@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:59:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
In-Reply-To: <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yk-TnLH-xbeznm99IgtH9PG1Bn63boM8
X-Proofpoint-ORIG-GUID: kbKxf5L5DVFB7xC2ELiCmS3kr6HW0blr
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040127
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/22 1:03 PM, Matthew Rosato wrote:
> On 9/22/22 8:06 PM, Jason Gunthorpe wrote:
>> The iommu_group comes from the struct device that a driver has been bound
>> to and then created a struct vfio_device against. To keep the iommu layer
>> sane we want to have a simple rule that only an attached driver should be
>> using the iommu API. Particularly only an attached driver should hold
>> ownership.
>>
>> In VFIO's case since it uses the group APIs and it shares between
>> different drivers it is a bit more complicated, but the principle still
>> holds.
>>
>> Solve this by waiting for all users of the vfio_group to stop before
>> allowing vfio_unregister_group_dev() to complete. This is done with a new
>> completion to know when the users go away and an additional refcount to
>> keep track of how many device drivers are sharing the vfio group. The last
>> driver to be unregistered will clean up the group.
>>
>> This solves crashes in the S390 iommu driver that come because VFIO ends
>> up racing releasing ownership (which attaches the default iommu_domain to
>> the device) with the removal of that same device from the iommu
>> driver. This is a side case that iommu drivers should not have to cope
>> with.
>>
>>    iommu driver failed to attach the default/blocking domain
>>    WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
>>    Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
>>    CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
>>    Hardware name: IBM 3931 A01 782 (LPAR)
>>    Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
>>               R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>>    Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
>>               00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
>>               00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
>>               00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
>>    Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
>>                           000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
>>                          #000000095bb10d24: af000000            mc      0,0
>>                          >000000095bb10d28: b904002a            lgr     %r2,%r10
>>                           000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
>>                           000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
>>                           000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
>>                           000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
>>    Call Trace:
>>     [<000000095bb10d28>] iommu_detach_group+0x70/0x80
>>    ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
>>     [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
>>     [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
>>     [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
>>    pci 0004:00:00.0: Removing from iommu group 4
>>     [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
>>     [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
>>     [<000000095be6c072>] system_call+0x82/0xb0
>>    Last Breaking-Event-Address:
>>     [<000000095be4bf80>] __warn_printk+0x60/0x68
>>
>> It indicates that domain->ops->attach_dev() failed because the driver has
>> already passed the point of destructing the device.
>>
>> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
>> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>  drivers/vfio/vfio.h      |  8 +++++
>>  drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
>>  2 files changed, 53 insertions(+), 23 deletions(-)
>>
>> v2
>>  - Rebase on the vfio struct device series and the container.c series
>>  - Drop patches 1 & 2, we need to have working error unwind, so another
>>    test is not a problem
>>  - Fold iommu_group_remove_device() into vfio_device_remove_group() so
>>    that it forms a strict pairing with the two allocation functions.
>>  - Drop the iommu patch from the series, it needs more work and discussion
>> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
>>
>> This could probably use another quick sanity test due to all the rebasing,
>> Alex if you are happy let's wait for Matthew.
>>
> 
> I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!
> 

Hmm, there's more going on with this patch besides the issues with -ap and -ccw.  While it does indeed resolve the crashes I had been seeing, I just now noticed that I see monotonically increasing iommu group IDs (implying we are not calling iommu_group_release as much as we should be) when running the same testscase that would previously trigger the occasional crash (host device is powered off):

e.g. before this patch I would see:
[  156.735855] pci 0003:00:00.0: Removing from iommu group 3
[  160.299238] pci 0003:00:00.0: Adding to iommu group 3
[  182.185975] pci 0003:00:00.0: Removing from iommu group 3
[  185.770472] pci 0003:00:00.0: Adding to iommu group 3
[  188.065652] pci 0003:00:00.0: Removing from iommu group 3
[  191.590985] pci 0003:00:00.0: Adding to iommu group 3


And now after this patch I see:
[  115.091093] pci 0003:00:00.0: Removing from iommu group 3
[  118.653818] pci 0003:00:00.0: Adding to iommu group 5
[  139.721061] pci 0003:00:00.0: Removing from iommu group 5
[  143.281589] pci 0003:00:00.0: Adding to iommu group 6
[  162.651073] pci 0003:00:00.0: Removing from iommu group 6
[  166.212440] pci 0003:00:00.0: Adding to iommu group 7

