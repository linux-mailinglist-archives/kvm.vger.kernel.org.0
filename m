Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4173EA6D
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjFZStB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjFZStA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:49:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746DE3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:48:58 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35QIjmts031781;
        Mon, 26 Jun 2023 18:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bIoe9Utnt1ekspMctH6hzF6RFBItOqIBCNo7AKOGj2E=;
 b=G4dCmRTcfEeprYyR9LCrtpWrSDJmja/8ElVUXJ8wIRfdsPmU9PYdCOQupd8SPR9hBOio
 pr/QLhTj/Bf/vasDzixTn7Z6IK4hH2827DGe0pIz4zKBek9rxv0c8/Qr2EDdN8j+wr6T
 RYIa9SQ1x9Jp5f2dtIQVnzYtlzqVBxKVUMpx8F8tkckJILhOq01ZwQSC4tDodrH0TREs
 iLsR2yNuz7yb7gyTPrBaEvacqbZnGpHRQCG2F3trkQtfAXbFq19MPoRvUp26n/4AoMeR
 T8VlGte2LCptz0hD1wS8rWnmw1ajVIZHEiHhw/NOzsM5toDrzNz/PWb0Jz+XiSbY9th8 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfg82r9dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 18:48:53 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35QIjn5v031903;
        Mon, 26 Jun 2023 18:48:40 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfg82r8s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 18:48:39 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35QFTcvJ005996;
        Mon, 26 Jun 2023 18:47:56 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3rdr45mfta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jun 2023 18:47:56 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35QIltX81311442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 18:47:55 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E8F758056;
        Mon, 26 Jun 2023 18:47:55 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E59958052;
        Mon, 26 Jun 2023 18:47:50 +0000 (GMT)
Received: from [9.61.69.83] (unknown [9.61.69.83])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 26 Jun 2023 18:47:49 +0000 (GMT)
Message-ID: <53746dc5-63cb-69c0-08a9-36abc8dca0c1@linux.ibm.com>
Date:   Mon, 26 Jun 2023 14:47:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] vfio/mdev: Move the compat_class initialization to module
 init
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UFD9a73a0UjAkW56aNl2SwZyLwXYVDuc
X-Proofpoint-ORIG-GUID: vfMyFM8zujvKS6G4Buqf_xiLR5NneICS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-26_16,2023-06-26_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260171
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 6/26/23 9:36 AM, Eric Farman wrote:
> The pointer to mdev_bus_compat_class is statically defined at the top
> of mdev_core, and was originally (commit 7b96953bc640 ("vfio: Mediated
> device Core driver") serialized by the parent_list_lock. The blamed
> commit removed this mutex, leaving the pointer initialization
> unserialized. As a result, the creation of multiple MDEVs in parallel
> (such as during boot) can encounter errors during the creation of the
> sysfs entries, such as:
> 
>    [    8.337509] sysfs: cannot create duplicate filename '/class/mdev_bus'
>    [    8.337514] vfio_ccw 0.0.01d8: MDEV: Registered
>    [    8.337516] CPU: 13 PID: 946 Comm: driverctl Not tainted 6.4.0-rc7 #20
>    [    8.337522] Hardware name: IBM 3906 M05 780 (LPAR)
>    [    8.337525] Call Trace:
>    [    8.337528]  [<0000000162b0145a>] dump_stack_lvl+0x62/0x80
>    [    8.337540]  [<00000001622aeb30>] sysfs_warn_dup+0x78/0x88
>    [    8.337549]  [<00000001622aeca6>] sysfs_create_dir_ns+0xe6/0xf8
>    [    8.337552]  [<0000000162b04504>] kobject_add_internal+0xf4/0x340
>    [    8.337557]  [<0000000162b04d48>] kobject_add+0x78/0xd0
>    [    8.337561]  [<0000000162b04e0a>] kobject_create_and_add+0x6a/0xb8
>    [    8.337565]  [<00000001627a110e>] class_compat_register+0x5e/0x90
>    [    8.337572]  [<000003ff7fd815da>] mdev_register_parent+0x102/0x130 [mdev]
>    [    8.337581]  [<000003ff7fdc7f2c>] vfio_ccw_sch_probe+0xe4/0x178 [vfio_ccw]
>    [    8.337588]  [<0000000162a7833c>] css_probe+0x44/0x80
>    [    8.337599]  [<000000016279f4da>] really_probe+0xd2/0x460
>    [    8.337603]  [<000000016279fa08>] driver_probe_device+0x40/0xf0
>    [    8.337606]  [<000000016279fb78>] __device_attach_driver+0xc0/0x140
>    [    8.337610]  [<000000016279cbe0>] bus_for_each_drv+0x90/0xd8
>    [    8.337618]  [<00000001627a00b0>] __device_attach+0x110/0x190
>    [    8.337621]  [<000000016279c7c8>] bus_rescan_devices_helper+0x60/0xb0
>    [    8.337626]  [<000000016279cd48>] drivers_probe_store+0x48/0x80
>    [    8.337632]  [<00000001622ac9b0>] kernfs_fop_write_iter+0x138/0x1f0
>    [    8.337635]  [<00000001621e5e14>] vfs_write+0x1ac/0x2f8
>    [    8.337645]  [<00000001621e61d8>] ksys_write+0x70/0x100
>    [    8.337650]  [<0000000162b2bdc4>] __do_syscall+0x1d4/0x200
>    [    8.337656]  [<0000000162b3c828>] system_call+0x70/0x98
>    [    8.337664] kobject: kobject_add_internal failed for mdev_bus with -EEXIST, don't try to register things with the same name in the same directory.
>    [    8.337668] kobject: kobject_create_and_add: kobject_add error: -17
>    [    8.337674] vfio_ccw: probe of 0.0.01d9 failed with error -12
>    [    8.342941] vfio_ccw_mdev aeb9ca91-10c6-42bc-a168-320023570aea: Adding to iommu group 2
> 
> Move the initialization of the mdev_bus_compat_class pointer to the
> init path, to match the cleanup in module exit. This way the code
> in mdev_register_parent() can simply link the new parent to it,
> rather than determining whether initialization is required first.
> 
> Fixes: 89345d5177aa ("vfio/mdev: embedd struct mdev_parent in the parent data structure")
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/vfio/mdev/mdev_core.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 58f91b3bd670..ed4737de4528 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -72,12 +72,6 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>   	parent->nr_types = nr_types;
>   	atomic_set(&parent->available_instances, mdev_driver->max_instances);
>   
> -	if (!mdev_bus_compat_class) {
> -		mdev_bus_compat_class = class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class)
> -			return -ENOMEM;
> -	}
> -
>   	ret = parent_create_sysfs_files(parent);
>   	if (ret)
>   		return ret;
> @@ -251,13 +245,24 @@ int mdev_device_remove(struct mdev_device *mdev)
>   
>   static int __init mdev_init(void)
>   {
> -	return bus_register(&mdev_bus_type);
> +	int ret;
> +
> +	ret = bus_register(&mdev_bus_type);
> +	if (ret)
> +		return ret;
> +
> +	mdev_bus_compat_class = class_compat_register("mdev_bus");
> +	if (!mdev_bus_compat_class) {
> +		bus_unregister(&mdev_bus_type);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>   }
>   
>   static void __exit mdev_exit(void)
>   {
> -	if (mdev_bus_compat_class)
> -		class_compat_unregister(mdev_bus_compat_class);
> +	class_compat_unregister(mdev_bus_compat_class);
>   	bus_unregister(&mdev_bus_type);
>   }
>   
