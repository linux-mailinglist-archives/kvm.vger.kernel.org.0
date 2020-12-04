Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803202CF241
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 17:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgLDQtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 11:49:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11460 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgLDQtK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 11:49:10 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4G7CZd024856;
        Fri, 4 Dec 2020 11:48:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mIqVGrqJOK8eIvKWm19nm07II6oqvK7qpYDmwO4E6is=;
 b=RdDp6PAmW+iKFDCX96Z+Rnqwpt9hJ9b8nWBFnmxt839E95nyjIbIYsvKT5jF81ubEjXc
 XgfxtaThneVsV/Om3WJn1EadcSB1INUVEEvdNeY/mwr4dDRlrJ+8LPv2SOg6q5lDTjyL
 NSNX7SyLfDAj7tHBXdsWGpcSS/iAD+9i7hUKZDe1C0F2O/pL1j5oQWJgsQI7XWnnRAZ+
 ZA5dJr1F/1liWBqgiyAZs5baAuPFKp7dCjCLUOpYzZzudr38EYlamR8dn0OPVQ/nXiQM
 TG9+muXL9qy/wVIoGiIbLOXxQuy40NrUchvjz2BSHRXpzOUYdpOvWriRSinhBi70WERi CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357prrcj3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 11:48:27 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4GmLeP179200;
        Fri, 4 Dec 2020 11:48:27 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357prrcj3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 11:48:27 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4GRbbW002376;
        Fri, 4 Dec 2020 16:48:26 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3569xuy9f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 16:48:26 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4GmPDd59769214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 16:48:25 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ACA1B2065;
        Fri,  4 Dec 2020 16:48:25 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DDB8B2064;
        Fri,  4 Dec 2020 16:48:25 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.195.249])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 16:48:24 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <a5a613ef-4c74-ad68-46bd-7159fbafef47@linux.ibm.com>
Date:   Fri, 4 Dec 2020 11:48:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201203185514.54060568.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_05:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=3 mlxscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/3/20 12:55 PM, Halil Pasic wrote:
> On Wed,  2 Dec 2020 18:41:01 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The vfio_ap device driver registers a group notifier with VFIO when the
>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
>> and calls the kvm_get_kvm() function to increment its reference counter.
>> When the notifier is called to make notification that the KVM pointer has
>> been set to NULL, the driver should clean up any resources associated with
>> the KVM pointer and decrement its reference counter. The current
>> implementation does not take care of this clean up.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Do we need a Fixes tag? Do we need this backported? In my opinion
> this is necessary since the interrupt patches.

I'll put in a fixes tag:
Fixes: 258287c994de (s390: vfio-ap: implement mediated device open callback)

Yes, this should probably be backported.

>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>>   1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..eeb9c9130756 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>   	return NOTIFY_DONE;
>>   }
>>   
>> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> I don't like the name. The function does more that put_kvm. Maybe
> something  like _disconnect_kvm()?
Since the vfio_ap_mdev_set_kvm() function is called by the
notifier when the KVM pointer is set, how about:

vfio_ap_mdev_unset_kvm()

for when the KVM pointer is nullified?

>
>> +{
>> +	if (matrix_mdev->kvm) {
>> +		(matrix_mdev->kvm);
>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> to take more care?
>
> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> kvm->arch.crypto.crycb.
>
>> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>> +		kvm_put_kvm(matrix_mdev->kvm);
>> +		matrix_mdev->kvm = NULL;
>> +	}
>> +}
>> +
>>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   				       unsigned long action, void *data)
>>   {
>> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>>   
>>   	if (!data) {
>> -		matrix_mdev->kvm = NULL;
>> +		vfio_ap_mdev_put_kvm(matrix_mdev);
> The lock question was already raised.
>
> What are the exact circumstances under which this branch can be taken?
>
>>   		return NOTIFY_OK;
>>   	}
>>   
>> @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>>   	mutex_lock(&matrix_dev->lock);
>> -	if (matrix_mdev->kvm) {
>> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>> -		vfio_ap_mdev_reset_queues(mdev);
>> -		kvm_put_kvm(matrix_mdev->kvm);
>> -		matrix_mdev->kvm = NULL;
>> -	}
>> +	vfio_ap_mdev_put_kvm(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

