Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2686758FE
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjATPp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjATPpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:45:54 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3744974C;
        Fri, 20 Jan 2023 07:45:53 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KEN79w023320;
        Fri, 20 Jan 2023 15:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jP4jR2i0Vx3/CXZzjbOxmRNKOfuz0Kxez96Br8vVvcU=;
 b=QexltucWRcI0Yj7UTKuFqL4FmFx7fY41OWHAzclFDfxLerjh/pugkE7wG370ctFRF7GV
 Hxa3mgTgsU7YyReednEWeampn4jkQp3P3Gw18P8ffh9TnkRMokUtWqp1PUPAd+9luErz
 79ONCrvcAUGxdhlhO2TUz1XqZsoCCDgo66HqYdIZ1TtumeIUVETsVbrO2hM0uhd1pWm7
 SNOFBXUbvdYmhlMzIw5Op1qgyYdFLG+fgqjnOjy/8LBMBj3dEi75om4mT1WhFmraVFZ1
 vFWf0YO3bKVswbtgyN7DDkk2DGspGZDo5atyLmb5NsEMdjXz0b+6S8/A6osQZ2hOXT2J iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7tsbn9sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 15:45:46 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30KFBRG0028162;
        Fri, 20 Jan 2023 15:45:45 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7tsbn9s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 15:45:45 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30KCuOeE024991;
        Fri, 20 Jan 2023 15:45:44 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3n3m182yj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 15:45:44 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30KFjhHC8782464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 15:45:43 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 663475805F;
        Fri, 20 Jan 2023 15:45:43 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01FE95805C;
        Fri, 20 Jan 2023 15:45:41 +0000 (GMT)
Received: from [9.160.87.67] (unknown [9.160.87.67])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 15:45:40 +0000 (GMT)
Message-ID: <6eff63d8-d825-aecd-12b5-e8dbf55f4372@linux.ibm.com>
Date:   Fri, 20 Jan 2023 10:45:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Content-Language: en-US
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
 <DS0PR11MB7529B08476DF1764F1B6C007C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <DS0PR11MB7529B08476DF1764F1B6C007C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F9NWpvszn4K81JkqFp2jJcB3Ow5IH-ax
X-Proofpoint-ORIG-GUID: J8JVlc_KWGK9Nyn4DQKTYEuioeLy0duP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_09,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200148
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/23 10:08 AM, Liu, Yi L wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, January 20, 2023 11:05 PM
>>
>> Currently it is possible that the final put of a KVM reference comes from
>> vfio during its device close operation.  This occurs while the vfio group
>> lock is held; however, if the vfio device is still in the kvm device list,
>> then the following call chain could result in a deadlock:
>>
>> VFIO holds group->group_lock/group_rwsem
>>   -> kvm_put_kvm
>>    -> kvm_destroy_vm
>>     -> kvm_destroy_devices
>>      -> kvm_vfio_destroy
>>       -> kvm_vfio_file_set_kvm
>>        -> vfio_file_set_kvm
>>         -> try to hold group->group_lock/group_rwsem
>>
>> The key function is the kvm_destroy_devices() which triggers destroy cb
>> of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
>> if this path doesn't call back to vfio, this dead lock would be fixed.
>> Actually, there is a way for it. KVM provides another point to free the
>> kvm-vfio device which is the point when the device file descriptor is
>> closed. This can be achieved by providing the release cb instead of the
>> destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().
>>
>> 	/*
>> 	 * Destroy is responsible for freeing dev.
>> 	 *
>> 	 * Destroy may be called before or after destructors are called
>> 	 * on emulated I/O regions, depending on whether a reference is
>> 	 * held by a vcpu or other kvm component that gets destroyed
>> 	 * after the emulated I/O.
>> 	 */
>> 	void (*destroy)(struct kvm_device *dev);
>>
>> 	/*
>> 	 * Release is an alternative method to free the device. It is
>> 	 * called when the device file descriptor is closed. Once
>> 	 * release is called, the destroy method will not be called
>> 	 * anymore as the device is removed from the device list of
>> 	 * the VM. kvm->lock is held.
>> 	 */
>> 	void (*release)(struct kvm_device *dev);
>>
>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>> Reported-by: Alex Williamson <alex.williamson@redhat.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> More background can be found in Mathew's work.
> https://lore.kernel.org/kvm/20230114000351.115444-1-mjrosato@linux.ibm.com/T/#u
> 

Thanks Yi.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

One small nit:  There is a comment at the very end of kvm_vfio_release on the kfree(dev) that still references .destroy, this should be updated to .release



