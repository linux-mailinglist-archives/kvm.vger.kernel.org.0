Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2BF412805
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbhITVaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:30:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241418AbhITV2C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 17:28:02 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KLISUx009517;
        Mon, 20 Sep 2021 17:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9kFhm53QcT7+4EfYrDgx81icFdLX/KQefo3HC8LLR7Y=;
 b=Gb+KKwodbWfDkwHeimSlv15rpP3YZM4wc4o7jqYDg49FxALkUrD5vOcmQUL87dMhi3Hg
 BQnzrEqXlHdA3JX8XNUU61ND+3Ft7SlCfHcfB8Smx2kdFRitEBNtqp8ZzRmqLiZbDapj
 oQP6fwUNfP8kmsUwIph7AkGlO5O5j9p7cIhtrJRdRHIXH652CslaQllo8+jJ2a1bZHdq
 5YNeTTpl9pF4Rxa9mfXgVN2NmCVLMX/NWvqf1dtO72y0q2DHHgyffZWVRuX7yYFmhT6n
 GvkE3rxRTH76MNR47ygIDSUVdxHjKrvJVVtuqE+d4zgI4DWHncB+1O8BfJ+hgiOfqR4t xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b723mg4kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 17:26:30 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KLKVSj021825;
        Mon, 20 Sep 2021 17:26:29 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b723mg4km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 17:26:29 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KL797j012857;
        Mon, 20 Sep 2021 21:26:28 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3b57ra1923-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 21:26:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KLQRJQ35783058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 21:26:27 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22B2B6E052;
        Mon, 20 Sep 2021 21:26:27 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D99996E056;
        Mon, 20 Sep 2021 21:26:25 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.65.75.198])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 21:26:25 +0000 (GMT)
Subject: Re: [PATCH v2] vfio/ap_ops: Add missed vfio_uninit_group_dev()
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
References: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
 <20210916125130.2db0961e.alex.williamson@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ee2a0623-84d5-8c21-cc40-de5991ff94b1@linux.ibm.com>
Date:   Mon, 20 Sep 2021 17:26:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210916125130.2db0961e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3HiD1DPH96dK5_9XMoGzanyhsqbibFYO
X-Proofpoint-ORIG-GUID: ld0Gxn_220CH0vjPVNsmK0mGqVm2gpb_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/16/21 2:51 PM, Alex Williamson wrote:
> On Fri, 10 Sep 2021 20:06:30 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> Without this call an xarray entry is leaked when the vfio_ap device is
>> unprobed. It was missed when the below patch was rebased across the
>> dev_set patch.
>>
>> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 2 ++
>>   1 file changed, 2 insertions(+)
> Hi Tony, Halil, Jason (H),
>
> Any acks for this one?  Thanks,
>
> Alex

I installed this on a test system running the latest linux
code from our library and ran our test suite. I got the
following running a simple test case that assigns some
adapters and domains to a mediated device then
starts a guest using the mdev.

[Sep20 23:19] ======================================================
[  +0.000001] WARNING: possible circular locking dependency detected
[  +0.000002] 5.15.0-rc1-10318-gac08b1c68d1b-dirty #15 Not tainted
[  +0.000002] ------------------------------------------------------
[  +0.000001] nose2/1993 is trying to acquire lock:
[  +0.000002] 00000000cf2a5520 (&new_dev_set->lock){+.+.}-{3:3}, at: 
vfio_uninit_group_dev+0x3c/0xf0 [vfio]
[  +0.000012]
               but task is already holding lock:
[  +0.000001] 00000000c84424d8 (&matrix_dev->lock){+.+.}-{3:3}, at: 
vfio_ap_mdev_remove+0x48/0xc8 [vfio_ap]
[  +0.000006]
               which lock already depends on the new lock.

[  +0.000002]
               the existing dependency chain (in reverse order) is:
[  +0.000001]
               -> #1 (&matrix_dev->lock){+.+.}-{3:3}:
[  +0.000004]        __lock_acquire+0x64c/0xc40
[  +0.000005]        reacquire_held_locks+0x134/0x228
[  +0.000002]        __lock_release+0xc6/0x338
[  +0.000002]        lock_release+0x1b0/0x298
[  +0.000001]        __mutex_unlock_slowpath+0x3a/0x2d8
[  +0.000005]        vfio_ap_mdev_unset_kvm.part.0+0xa6/0xc0 [vfio_ap]
[  +0.000003]        vfio_device_fops_release+0x64/0xe8 [vfio]
[  +0.000003]        __fput+0xae/0x288
[  +0.000005]        task_work_run+0x76/0xc0
[  +0.000005]        do_exit+0x268/0x5c0
[  +0.000005]        do_group_exit+0x48/0xc0
[  +0.000050]        __s390x_sys_exit_group+0x2e/0x30
[  +0.000002]        __do_syscall+0x1c2/0x1f0
[  +0.000004]        system_call+0x78/0xa0
[  +0.000003]
               -> #0 (&new_dev_set->lock){+.+.}-{3:3}:
[  +0.000004]        check_prev_add+0xe0/0xed8
[  +0.000002]        validate_chain+0x9ca/0xde8
[  +0.000001]        __lock_acquire+0x64c/0xc40
[  +0.000002]        lock_acquire.part.0+0xec/0x258
[  +0.000002]        lock_acquire+0xb0/0x200
[  +0.000001]        __mutex_lock+0xa2/0x8f8
[  +0.000002]        mutex_lock_nested+0x32/0x40
[  +0.000002]        vfio_uninit_group_dev+0x3c/0xf0 [vfio]
[  +0.000004]        vfio_ap_mdev_remove+0x90/0xc8 [vfio_ap]
[  +0.000002]        mdev_remove+0x32/0x58 [mdev]
[  +0.000004]        __device_release_driver+0x18a/0x238
[  +0.000005]        device_release_driver+0x40/0x50
[  +0.000002]        bus_remove_device+0x110/0x1a0
[  +0.000002]        device_del+0x19c/0x3e8
[  +0.000002]        mdev_device_remove_common+0x3c/0xb0 [mdev]
[  +0.000003]        mdev_device_remove+0xac/0x100 [mdev]
[  +0.000002]        remove_store+0x78/0x90 [mdev]
[  +0.000003]        kernfs_fop_write_iter+0x13e/0x1e0
[  +0.000004]        new_sync_write+0x100/0x190
[  +0.000003]        vfs_write+0x230/0x2e0
[  +0.000002]        ksys_write+0x6c/0xf8
[  +0.000002]        __do_syscall+0x1c2/0x1f0
[  +0.000002]        system_call+0x78/0xa0
[  +0.000002]
               other info that might help us debug this:

[  +0.000002]  Possible unsafe locking scenario:

[  +0.000001]        CPU0                    CPU1
[  +0.000001]        ----                    ----
[  +0.000001]   lock(&matrix_dev->lock);
[  +0.000002] lock(&new_dev_set->lock);
[  +0.000002] lock(&matrix_dev->lock);
[  +0.000002]   lock(&new_dev_set->lock);
[  +0.000002]
                *** DEADLOCK ***

[  +0.000001] 7 locks held by nose2/1993:
[  +0.000002]  #0: 00000000b373af00 (&f->f_pos_lock){+.+.}-{3:3}, at: 
__fdget_pos+0x6a/0x80
[  +0.000007]  #1: 00000000978e4498 (sb_writers#4){.+.+}-{0:0}, at: 
ksys_write+0x6c/0xf8
[  +0.000005]  #2: 00000000b4b89490 (&of->mutex){+.+.}-{3:3}, at: 
kernfs_fop_write_iter+0x102/0x1e0
[  +0.000006]  #3: 00000000ca215210 (kn->active#215){++++}-{0:0}, at: 
sysfs_remove_file_self+0x42/0x78
[  +0.000006]  #4: 00000000cb7d85b8 (&parent->unreg_sem){++++}-{3:3}, 
at: mdev_device_remove+0x9c/0x100 [mdev]
[  +0.000005]  #5: 00000000cb188990 (&dev->mutex){....}-{3:3}, at: 
device_release_driver+0x32/0x50
[  +0.000006]  #6: 00000000c84424d8 (&matrix_dev->lock){+.+.}-{3:3}, at: 
vfio_ap_mdev_remove+0x48/0xc8 [vfio_ap]
[  +0.000005]
               stack backtrace:
[  +0.000002] CPU: 6 PID: 1993 Comm: nose2 Not tainted 
5.15.0-rc1-10318-gac08b1c68d1b-dirty #15
[  +0.000003] Hardware name: IBM 8561 T01 701 (LPAR)
[  +0.000002] Call Trace:
[  +0.000001]  [<0000000328775056>] dump_stack_lvl+0x8e/0xc8
[  +0.000003]  [<0000000327b4b648>] check_noncircular+0x168/0x188
[  +0.000003]  [<0000000327b4c708>] check_prev_add+0xe0/0xed8
[  +0.000002]  [<0000000327b4deca>] validate_chain+0x9ca/0xde8
[  +0.000002]  [<0000000327b50ec4>] __lock_acquire+0x64c/0xc40
[  +0.000002]  [<0000000327b4facc>] lock_acquire.part.0+0xec/0x258
[  +0.000002]  [<0000000327b4fce8>] lock_acquire+0xb0/0x200
[  +0.000002]  [<00000003287839d2>] __mutex_lock+0xa2/0x8f8
[  +0.000002]  [<000000032878425a>] mutex_lock_nested+0x32/0x40
[  +0.000002]  [<000003ff801c3ce4>] vfio_uninit_group_dev+0x3c/0xf0 [vfio]
[  +0.000004]  [<000003ff805e0000>] vfio_ap_mdev_remove+0x90/0xc8 [vfio_ap]
[  +0.000003]  [<000003ff802339fa>] mdev_remove+0x32/0x58 [mdev]
[  +0.000003]  [<00000003283e9c92>] __device_release_driver+0x18a/0x238
[  +0.000003]  [<00000003283e9d80>] device_release_driver+0x40/0x50
[  +0.000003]  [<00000003283e8e28>] bus_remove_device+0x110/0x1a0
[  +0.000002]  [<00000003283e2cb4>] device_del+0x19c/0x3e8
[  +0.000002]  [<000003ff8023270c>] mdev_device_remove_common+0x3c/0xb0 
[mdev]
[  +0.000003]  [<000003ff80232fcc>] mdev_device_remove+0xac/0x100 [mdev]
[  +0.000003]  [<000003ff80233220>] remove_store+0x78/0x90 [mdev]
[  +0.000003]  [<0000000327eefaae>] kernfs_fop_write_iter+0x13e/0x1e0
[  +0.000003]  [<0000000327dfa160>] new_sync_write+0x100/0x190
[  +0.000002]  [<0000000327dfd038>] vfs_write+0x230/0x2e0
[  +0.000003]  [<0000000327dfd354>] ksys_write+0x6c/0xf8
[  +0.000002]  [<00000003287787b2>] __do_syscall+0x1c2/0x1f0
[  +0.000002]  [<000000032878b178>] system_call+0x78/0xa0
[  +0.000003] INFO: lockdep is turned off.
