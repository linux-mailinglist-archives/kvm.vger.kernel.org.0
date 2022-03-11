Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885E94D65CA
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 17:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350194AbiCKQJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 11:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349896AbiCKQI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 11:08:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F396C97E;
        Fri, 11 Mar 2022 08:07:56 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BG1ugq026895;
        Fri, 11 Mar 2022 16:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ecUC02vi9L5mXSks5iNggXwcCtt0tIzpxV2IQJfr/oc=;
 b=rtF4GM7dHwKC7NsoxsJpc4Qi0KZDl7wIuE63OD/Z76G7ZgwcF1NxCvq6tp8azqQGkqkZ
 OxMiYSEpcJeHX+zOh7LYoJyPcRnChiOMsr1U6jWArygZ52Gu405VRln83EGI1xracLKZ
 u/NUoG8ZQ1mE1o+QjLW4SLc0lERKsRl5szD3e06jsx+gNObxX2Gxal44g5JulUaCIkrO
 gf3OSySlbhZlTYdB0Mmzj3sLn/YNCFut1QB/o/xxDvt/ih76ljefg3kQ2SpXC92I6Vk+
 qUQ3hOUkSkSF2SF0oiYHkurqu0sUxWW0/kkGVW4tWRUIdZd+zXsenevP8XWY3OYS7nMV 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqtfgh5pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 16:07:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BG5ZF5025259;
        Fri, 11 Mar 2022 16:07:52 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqtfgh5pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 16:07:52 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BG3EpS030717;
        Fri, 11 Mar 2022 16:07:51 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3emgamh5mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 16:07:51 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BG7oKa20906410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 16:07:50 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32561124053;
        Fri, 11 Mar 2022 16:07:50 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA80812405E;
        Fri, 11 Mar 2022 16:07:48 +0000 (GMT)
Received: from [9.65.234.56] (unknown [9.65.234.56])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Mar 2022 16:07:48 +0000 (GMT)
Message-ID: <016b3ffe-8aaa-f29e-2a8e-217c6b97f3a1@linux.ibm.com>
Date:   Fri, 11 Mar 2022 11:07:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 10/18] s390/vfio-ap: allow hot plug/unplug of AP
 devices when assigned/unassigned
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-11-akrowiak@linux.ibm.com>
 <fcce28f2-64f7-0946-3f33-3158b7909d6b@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <fcce28f2-64f7-0946-3f33-3158b7909d6b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w8YxNFM7MKCmi8sIsEAv9qJbOBAG3CDI
X-Proofpoint-GUID: O7kD1eVd2C_Ixg7-xuKuf_d8k2i_L3zt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_06,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/22 09:26, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
>> Let's allow adapters, domains and control domains to be hot plugged
>> into and hot unplugged from a KVM guest using a matrix mdev when an
>> adapter, domain or control domain is assigned to or unassigned from
>> the matrix mdev.
>>
>> Whenever an assignment or unassignment of an adapter, domain or control
>> domain is performed, the AP configuration assigned to the matrix
>> mediated device will be filtered and assigned to the AP control block
>> (APCB) that supplies the AP configuration to the guest so that no
>> adapter, domain or control domain that is not in the host's AP
>> configuration nor any APQN that does not reference a queue device bound
>> to the vfio_ap device driver is assigned.
>>
>> After updating the APCB, if the mdev is in use by a KVM guest, it is
>> hot plugged into the guest to dynamically provide access to the 
>> adapters,
>> domains and control domains provided via the newly refreshed APCB.
>>
>> Keep in mind that the matrix_dev->guests_lock must be taken outside 
>> of the
>> matrix_mdev->kvm->lock which in turn must be taken outside of the
>> matrix_dev->mdevs_lock in order to avoid circular lock dependencies 
>> (i.e.,
>> a lockdep splat).Consequently, the locking order for hot plugging the
>> guest's APCB must be:
>>
>> matrix_dev->guests_lock => matrix_mdev->kvm->lock => 
>> matrix_dev->mdevs_lock
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 198 +++++++++++++++++++-----------
>>   1 file changed, 125 insertions(+), 73 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 623a4b38676d..4c382cd3afc7 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -317,10 +317,25 @@ static void vfio_ap_matrix_init(struct 
>> ap_config_info *info,
>>       matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   -static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +static void vfio_ap_mdev_hotplug_apcb(struct ap_matrix_mdev 
>> *matrix_mdev)
>>   {
>> +    if (matrix_mdev->kvm)
>> +        kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>> +                      matrix_mdev->shadow_apcb.apm,
>> +                      matrix_mdev->shadow_apcb.aqm,
>> +                      matrix_mdev->shadow_apcb.adm);
>> +}
>
> This function updates a kvm guest's apcb. So let's rename it to
> vfio_ap_update_apcb(). 

The idea was to indicate that the AP adapters, domains and control
domains configured in the shadow APCB are being hot plugged into
a running guest. Having said that, I can see your point. I'm not married to
the function name, but I would prefer to go with
'vfio_ap_update_guest_apcb()' to distinguish between the shadow and
the real apcb.

> You can also call this function in vfio_ap_mdev_set_kvm,
> instead of duplicating the code to call kvm_arch_crypto_set_masks().

The reason I didn't do that is because we've already verified the
matrix_mdev->kvm in kvm_arch_crypto_set_masks(). I'm not sure what
it buys us, but I'm not adverse to making the change.

>
>
>
>
>> +static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +{
>> +    DECLARE_BITMAP(shadow_adm, AP_DOMAINS);
>> +
>> +    bitmap_copy(shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
>>       bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
>>              (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
>> +
>> +    return !bitmap_equal(shadow_adm, matrix_mdev->shadow_apcb.adm,
>> +                 AP_DOMAINS);
>>   }
>
> your variable, shadow_adm, should be named original_adm. Since it 
> represents
> the original value before filtering. This makes the intent much more 
> clear.
> Same goes for the vars in vfio_ap_mdev_filter_matrix().

Makes sense, but I think I'll go with prev_shadow_apm, prev_shadow_aqm and
prev_shadow_adm. That seems more accurate since these are not the original
copies of the bitmaps, but copies of the previous versions prior to 
filtering.

>
> ...
>> +/**
>> + * vfio_ap_mdev_get_locks - acquire the locks required to 
>> assign/unassign AP
>> + *                adapters, domains and control domains for an mdev in
>> + *                the proper locking order.
>> + *
>> + * @matrix_mdev: the matrix mediated device object
>> + */
>> +static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +    /* Lock the mutex required to access the KVM guest's state */
>> +    mutex_lock(&matrix_dev->guests_lock);
>> +
>> +    /* If a KVM guest is running, lock the mutex required to 
>> plug/unplug the
>> +     * AP devices passed through to the guest
>> +     */
>> +    if (matrix_mdev->kvm)
>> +        mutex_lock(&matrix_mdev->kvm->lock);
>> +
>> +    /* The lock required to access the mdev's state */
>> +    mutex_lock(&matrix_dev->mdevs_lock);
>> +}
>
> Simplifying the cdoe, and removing duplication by moving the locking 
> code to a
> function is probably a good thing. But I don't feel like this belongs 
> to this
> particular patch. In general, a patch should only do one thing, and 
> ideally that
> one thing should be as small as reasonably possible. This makes the 
> patch easier
> to read and to review.
>
> I feel like, as much as possible, you should refactor the locking in a 
> series
> of patches that are all kept together. Ideally, they would be a patch 
> series
> completely separate from dynamic ap. After all, this series is already 
> at 18
> patches. :)

I'm going to have to disagree, this locking scheme makes no sense outside of
this series. It is only necessary because we now update a guest's APCB
whenever an adapter, domain or control domain is assigned or unassigned,
when a queue device is probed or removed and when the vfio_ap driver is
notified that the host's AP configuration has changed.

Prior to this series, a guest's APCB was updated only when the vfio_ap
driver was notified that the KVM pointer was set or cleared, so it was
only necessary to ensure the kvm->lock is taken before the matrix_dev->lock
in the functions that handle the VFIO_GROUP_NOTIFY_SET_KVM group
notification event. Prior to this, a patch series to introduce the 
matrix_dev->guests lock
would make no sense because it is not needed to enforce the locking 
order in those
functions listed in the previous paragraph because we didn't update the 
guest's
APCB in those functions.

>
> ...
>>   /**
>>    * assign_adapter_store - parses the APID from @buf and sets the
>>    * corresponding bit in the mediated matrix device's APM
>> @@ -649,17 +723,9 @@ static ssize_t assign_adapter_store(struct 
>> device *dev,
>>       int ret;
>>       unsigned long apid;
>>       DECLARE_BITMAP(apm, AP_DEVICES);
>> -
>>       struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>>   -    mutex_lock(&matrix_dev->guests_lock);
>> -    mutex_lock(&matrix_dev->mdevs_lock);
>> -
>> -    /* If the KVM guest is running, disallow assignment of adapter */
>> -    if (matrix_mdev->kvm) {
>> -        ret = -EBUSY;
>> -        goto done;
>> -    }
>> +    vfio_ap_mdev_get_locks(matrix_mdev);
>>         ret = kstrtoul(buf, 0, &apid);
>>       if (ret)
>> @@ -671,8 +737,6 @@ static ssize_t assign_adapter_store(struct device 
>> *dev,
>>       }
>>         set_bit_inv(apid, matrix_mdev->matrix.apm);
>> -    memset(apm, 0, sizeof(apm));
>> -    set_bit_inv(apid, apm);
>>         ret = vfio_ap_mdev_validate_masks(matrix_mdev);
>
> It looks like you moved the memset() and set_bit_inv() to be closer to 
> where
> "apm" is used, namely, the call to vfio_ap_mdev_filter_matrix(). Any 
> reason you
> cannot move it down under the call to vfio_ap_mdev_link_adapter()? 
> That would
> get it even closer to where it is used.

I didn't move it to be closer to where it is used, I moved it because it 
was not
necessary to do the memset/set_bit_inv when not necessary to do so. Having
said that, it can definitely be moved after the vfio_ap_mdev_link_adapter().

>
> Also, I think renaming apm to apm_delta or apm_diff makes sense here. 
> After all,
> it is the difference between the original apm, and the new apm. The 
> new apm
> has an extra bit for the newly added adapter. Do I have that right? If 
> so, I
> think renaming the variable will make the code clearer.

The purpose of this bitmap is to limit the filtering to the new APID 
being assigned
because there is no need to do filtering of adapters already assigned; 
so, it is not
really a new apm per se. It might be more accurate to call it new_apid 
or new_apids,
although there will only be one bit set in the bitmap.

>
>
> Both of the above comments also apply to assign_domain_store().

Ditto on the responses.


