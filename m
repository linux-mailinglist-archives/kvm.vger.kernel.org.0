Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC58682F63
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjAaOf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjAaOf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:35:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C7B171E;
        Tue, 31 Jan 2023 06:35:25 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEXvqw005480;
        Tue, 31 Jan 2023 14:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xQNfqutcqXNVgp809djuyULfRWJT1C8zMC++IWkpBm4=;
 b=m9HVf/m527fqmPzIQAq8IX7P/Bte5jC15KDfQTHW80hUpo9AFc5Vij9ddomrpLAyWra/
 uDab1pIXG1ymdedwcaS6qFy7+DVJCTU9IFVJb3Jl7Ra0bEiD1BAodOsYcpGk0Ktow19/
 wHWlX+KmKBrmjCoXJif8hCbN69lmJpKX3pkpVXuRsdT/PbM4VVKn4Nu5Y1eFwrKTnloy
 NCI0qj5BKMyZY1wYgQ/HnYVguYsas0GUBCB2S7HVCAb9kgdf24ZFeMV86a+b66BkS5jn
 sCu9LtlbLKAZsV48Hjwn84i9XDZa1+jXqPk/PgzHK2RzIDjkjRLVx6OzHfSF+8F+pGYP aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf31nb60y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 14:35:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VERALm006867;
        Tue, 31 Jan 2023 14:35:19 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf31nb608-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 14:35:19 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VC0JI1007767;
        Tue, 31 Jan 2023 14:35:18 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3ncvterg5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 14:35:18 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30VEZGGj38863608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 14:35:16 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C0EB58054;
        Tue, 31 Jan 2023 14:35:16 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5BB45805C;
        Tue, 31 Jan 2023 14:35:13 +0000 (GMT)
Received: from [9.160.16.25] (unknown [9.160.16.25])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 31 Jan 2023 14:35:13 +0000 (GMT)
Message-ID: <6ec864e1-076a-6be1-9775-97ad609943bd@linux.ibm.com>
Date:   Tue, 31 Jan 2023 09:35:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Content-Language: en-US
To:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230120150528.471752-1-yi.l.liu@intel.com>
 <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bLjLOt1XGo7PTgP6xQvG5thZmD1cAerh
X-Proofpoint-GUID: _GFPqAbMfsySz869adLhKqsqALCCW1tk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301310131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/23 9:27 AM, Anthony Krowiak wrote:
> I encountered a lockdep splat while running some regression tests today (see below). I suspected it might be this patch so I reverted it, rebuilt the kernel and ran the regression tests again; this time, the test ran cleanly. It looks like this patch may not have fixed the problem for which it was intended. Here is the relevant dmesg output:
> 

Damn it, the config I used to test must not have had lockdep enabled.

It looks like the issue is that .destroy did not used to acquire the kvm lock prior to calling into vfio_file_set_kvm whereas now .release does.  This means .release expects a hierarchy of kvm->lock ...  vfio->group_lock but your .open_device does vfio->group_lock ... kvm->lock.

I can reproduce something similar for vfio_pci_zdev.

> [  579.471402] hades[1099]: Start test run
> [  579.473486] hades[1099]: Start 'tests.test_vfio_ap.VfioAPAssignMdevToGuestTest.runTest' test
> [  579.505804] vfio_ap matrix: MDEV: Registered
> [  579.604024] vfio_ap_mdev 529654a9-bea4-461a-b64d-9d9c63df0deb: Adding to iommu group 0
> 
> [  585.043898] ======================================================
> [  585.043900] WARNING: possible circular locking dependency detected
> [  585.043902] 6.2.0-rc6-00057-g41c03ba9beea-dirty #18 Not tainted
> [  585.043904] ------------------------------------------------------
> [  585.043905] CPU 0/KVM/1173 is trying to acquire lock:
> [  585.043907] 000000008cfb24b0 (&group->group_lock){+.+.}-{3:3}, at: vfio_file_set_kvm+0x50/0x68 [vfio]
> [  585.043919]
>                but task is already holding lock:
> [  585.043920] 00000000b2960ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_device_release+0x4a/0xb8 [kvm]
> [  585.043960]
>                which lock already depends on the new lock.
> 
> [  585.043962]
>                the existing dependency chain (in reverse order) is:
> [  585.043963]
>                -> #3 (&kvm->lock){+.+.}-{3:3}:
> [  585.043967]        __lock_acquire+0x3e2/0x750
> [  585.043974]        lock_acquire.part.0+0xe2/0x250
> [  585.043977]        lock_acquire+0xac/0x1d0
> [  585.043980]        __mutex_lock+0x9e/0x868
> [  585.043985]        mutex_lock_nested+0x32/0x40
> [  585.043988]        vfio_ap_mdev_open_device+0x9a/0x198 [vfio_ap]
> [  585.043991]        vfio_device_open+0x122/0x168 [vfio]
> [  585.043995]        vfio_device_open_file+0x64/0x120 [vfio]
> [  585.043999]        vfio_group_fops_unl_ioctl+0xd4/0x1e0 [vfio]
> [  585.044002]        __s390x_sys_ioctl+0xc0/0x100
> [  585.044007]        do_syscall+0xee/0x118
> [  585.044032]        __do_syscall+0xd2/0x120
> [  585.044035]        system_call+0x82/0xb0
> [  585.044037]
>                -> #2 (&matrix_dev->guests_lock){+.+.}-{3:3}:
> [  585.044041]        __lock_acquire+0x3e2/0x750
> [  585.044044]        lock_acquire.part.0+0xe2/0x250
> [  585.044047]        lock_acquire+0xac/0x1d0
> [  585.044049]        __mutex_lock+0x9e/0x868
> [  585.044052]        mutex_lock_nested+0x32/0x40
> [  585.044054]        vfio_ap_mdev_open_device+0x8c/0x198 [vfio_ap]
> [  585.044057]        vfio_device_open+0x122/0x168 [vfio]
> [  585.044060]        vfio_device_open_file+0x64/0x120 [vfio]
> [  585.044064]        vfio_group_fops_unl_ioctl+0xd4/0x1e0 [vfio]
> [  585.044068]        __s390x_sys_ioctl+0xc0/0x100
> [  585.044070]        do_syscall+0xee/0x118
> [  585.044072]        __do_syscall+0xd2/0x120
> [  585.044074]        system_call+0x82/0xb0
> [  585.044076]
>                -> #1 (&new_dev_set->lock){+.+.}-{3:3}:
> [  585.044080]        __lock_acquire+0x3e2/0x750
> [  585.044082]        lock_acquire.part.0+0xe2/0x250
> [  585.044085]        lock_acquire+0xac/0x1d0
> [  585.044088]        __mutex_lock+0x9e/0x868
> [  585.044090]        mutex_lock_nested+0x32/0x40
> [  585.044093]        vfio_device_open+0x3e/0x168 [vfio]
> [  585.044096]        vfio_device_open_file+0x64/0x120 [vfio]
> [  585.044100]        vfio_group_fops_unl_ioctl+0xd4/0x1e0 [vfio]
> [  585.044104]        __s390x_sys_ioctl+0xc0/0x100
> [  585.044106]        do_syscall+0xee/0x118
> [  585.044108]        __do_syscall+0xd2/0x120
> [  585.044110]        system_call+0x82/0xb0
> [  585.044112]
>                -> #0 (&group->group_lock){+.+.}-{3:3}:
> [  585.044115]        check_prev_add+0xd4/0xf10
> [  585.044118]        validate_chain+0x698/0x8e8
> [  585.044120]        __lock_acquire+0x3e2/0x750
> [  585.044123]        lock_acquire.part.0+0xe2/0x250
> [  585.044125]        lock_acquire+0xac/0x1d0
> [  585.044128]        __mutex_lock+0x9e/0x868
> [  585.044130]        mutex_lock_nested+0x32/0x40
> [  585.044133]        vfio_file_set_kvm+0x50/0x68 [vfio]
> [  585.044137]        kvm_vfio_release+0x5e/0xf8 [kvm]
> [  585.044156]        kvm_device_release+0x90/0xb8 [kvm]
> [  585.044175]        __fput+0xaa/0x2a0
> [  585.044180]        task_work_run+0x76/0xd0
> [  585.044183]        do_exit+0x248/0x538
> [  585.044186]        do_group_exit+0x40/0xb0
> [  585.044188]        get_signal+0x614/0x698
> [  585.044192]        arch_do_signal_or_restart+0x58/0x370
> [  585.044195]        exit_to_user_mode_loop+0xe8/0x1b8
> [  585.044200]        exit_to_user_mode_prepare+0x164/0x190
> [  585.044203]        __do_syscall+0xd2/0x120
> [  585.044205]        system_call+0x82/0xb0
> [  585.044207]
>                other info that might help us debug this:
> 
> [  585.044209] Chain exists of:
>                  &group->group_lock --> &matrix_dev->guests_lock --> &kvm->lock
> 
> [  585.044213]  Possible unsafe locking scenario:
> 
> [  585.044214]        CPU0                    CPU1
> [  585.044216]        ----                    ----
> [  585.044217]   lock(&kvm->lock);
> [  585.044219] lock(&matrix_dev->guests_lock);
> [  585.044221] lock(&kvm->lock);
> [  585.044223]   lock(&group->group_lock);
> [  585.044225]
>                 *** DEADLOCK ***
> 
> [  585.044227] 1 lock held by CPU 0/KVM/1173:
> [  585.044228]  #0: 00000000b2960ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_device_release+0x4a/0xb8 [kvm]
> [  585.044251]
>                stack backtrace:
> [  585.044253] CPU: 3 PID: 1173 Comm: CPU 0/KVM Not tainted 6.2.0-rc6-00057-g41c03ba9beea-dirty #18
> [  585.044256] Hardware name: IBM 8561 T01 772 (LPAR)
> [  585.044257] Call Trace:
> [  585.044258]  [<000000011a818936>] dump_stack_lvl+0x8e/0xc8
> [  585.044261]  [<0000000119aca3f2>] check_noncircular+0x132/0x158
> [  585.044264]  [<0000000119acba44>] check_prev_add+0xd4/0xf10
> [  585.044267]  [<0000000119accf18>] validate_chain+0x698/0x8e8
> [  585.044270]  [<0000000119ace70a>] __lock_acquire+0x3e2/0x750
> [  585.044273]  [<0000000119acf682>] lock_acquire.part.0+0xe2/0x250
> [  585.044276]  [<0000000119acf89c>] lock_acquire+0xac/0x1d0
> [  585.044279]  [<000000011a823c66>] __mutex_lock+0x9e/0x868
> [  585.044282]  [<000000011a824462>] mutex_lock_nested+0x32/0x40
> [  585.044285]  [<000003ff7fbcd6a0>] vfio_file_set_kvm+0x50/0x68 [vfio]
> [  585.044289]  [<000003ff7feacab6>] kvm_vfio_release+0x5e/0xf8 [kvm]
> [  585.044308]  [<000003ff7fea6d58>] kvm_device_release+0x90/0xb8 [kvm]
> [  585.044328]  [<0000000119dbb83a>] __fput+0xaa/0x2a0
> [  585.044331]  [<0000000119a67c66>] task_work_run+0x76/0xd0
> [  585.044333]  [<0000000119a3ec18>] do_exit+0x248/0x538
> [  585.044335]  [<0000000119a3f0c8>] do_group_exit+0x40/0xb0
> [  585.044338]  [<0000000119a50dec>] get_signal+0x614/0x698
> [  585.044340]  [<00000001199ea030>] arch_do_signal_or_restart+0x58/0x370
> [  585.044343]  [<0000000119b0bb50>] exit_to_user_mode_loop+0xe8/0x1b8
> [  585.044346]  [<0000000119b0bd84>] exit_to_user_mode_prepare+0x164/0x190
> [  585.044349]  [<000000011a818d2a>] __do_syscall+0xd2/0x120
> [  585.044351]  [<000000011a82c462>] system_call+0x82/0xb0
> [  585.044354] INFO: lockdep is turned off.
> [  610.595528] vfio_ap_mdev 529654a9-bea4-461a-b64d-9d9c63df0deb: Removing from iommu group 0
> [  610.604408] vfio_ap matrix: MDEV: Unregistering
> [  610.826074] hades[1099]: Stop 'tests.test_vfio_ap.VfioAPAssignMdevToGuestTest.runTest'
> 
> On 1/20/23 10:05 AM, Yi Liu wrote:
>> Currently it is possible that the final put of a KVM reference comes from
>> vfio during its device close operation.  This occurs while the vfio group
>> lock is held; however, if the vfio device is still in the kvm device list,
>> then the following call chain could result in a deadlock:
>>
>> VFIO holds group->group_lock/group_rwsem
>>    -> kvm_put_kvm
>>     -> kvm_destroy_vm
>>      -> kvm_destroy_devices
>>       -> kvm_vfio_destroy
>>        -> kvm_vfio_file_set_kvm
>>         -> vfio_file_set_kvm
>>          -> try to hold group->group_lock/group_rwsem
>>
>> The key function is the kvm_destroy_devices() which triggers destroy cb
>> of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
>> if this path doesn't call back to vfio, this dead lock would be fixed.
>> Actually, there is a way for it. KVM provides another point to free the
>> kvm-vfio device which is the point when the device file descriptor is
>> closed. This can be achieved by providing the release cb instead of the
>> destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().
>>
>>     /*
>>      * Destroy is responsible for freeing dev.
>>      *
>>      * Destroy may be called before or after destructors are called
>>      * on emulated I/O regions, depending on whether a reference is
>>      * held by a vcpu or other kvm component that gets destroyed
>>      * after the emulated I/O.
>>      */
>>     void (*destroy)(struct kvm_device *dev);
>>
>>     /*
>>      * Release is an alternative method to free the device. It is
>>      * called when the device file descriptor is closed. Once
>>      * release is called, the destroy method will not be called
>>      * anymore as the device is removed from the device list of
>>      * the VM. kvm->lock is held.
>>      */
>>     void (*release)(struct kvm_device *dev);
>>
>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>> Reported-by: Alex Williamson <alex.williamson@redhat.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   virt/kvm/vfio.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>> index 495ceabffe88..e94f3ea718e5 100644
>> --- a/virt/kvm/vfio.c
>> +++ b/virt/kvm/vfio.c
>> @@ -336,7 +336,7 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
>>       return -ENXIO;
>>   }
>>   -static void kvm_vfio_destroy(struct kvm_device *dev)
>> +static void kvm_vfio_release(struct kvm_device *dev)
>>   {
>>       struct kvm_vfio *kv = dev->private;
>>       struct kvm_vfio_group *kvg, *tmp;
>> @@ -363,7 +363,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
>>   static struct kvm_device_ops kvm_vfio_ops = {
>>       .name = "kvm-vfio",
>>       .create = kvm_vfio_create,
>> -    .destroy = kvm_vfio_destroy,
>> +    .release = kvm_vfio_release,
>>       .set_attr = kvm_vfio_set_attr,
>>       .has_attr = kvm_vfio_has_attr,
>>   };

