Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD78283C6A
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgJEQYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 12:24:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65392 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgJEQYs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 12:24:48 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095G3BpW173596;
        Mon, 5 Oct 2020 12:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Eoh2vfT9dbeH2XBi3EuNet7VgqhMKjndHHT9UxvicqE=;
 b=q1FOXVZM92MRhdHzv2rUkv+2zXCtoxKeuSB+5OIgRDhOPpOQzdcDUR/v1Oha239AqTkA
 yUTfGnT4GBPqECiWqtiXxvoRkFsjtmgMz2/l7KAAPrTNyLjjVyMQ3Oml3VSHUeTT+ZA+
 JiSBJ2MLL63yxEbaiGSNrILx28Ts+Soyeg8Grbv9TY8Q705ns5cwOhh1JjsWlIda7x4L
 QPseSTC3e+TKPFBOMD9JsLFrRlybeqOvRmN5gV0cfoDpqNXMXzmCl2rNgY8tJ3G4VWWe
 F41X0elvM56qzy3tf4Z2u80kRApFHPamy0pszcWw4r6kLGWhzUTh/YdZdgpvusTDiohX GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3406mprmth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:24:44 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095G3uPQ179040;
        Mon, 5 Oct 2020 12:24:43 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3406mprmt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:24:43 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095GMYvc008510;
        Mon, 5 Oct 2020 16:24:42 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 33xgx8ruvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 16:24:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095GOfIs49021280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 16:24:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66902AE05F;
        Mon,  5 Oct 2020 16:24:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FB19AE05C;
        Mon,  5 Oct 2020 16:24:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 16:24:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v10 11/16] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-12-akrowiak@linux.ibm.com>
 <20200928030147.7ee6f494.pasic@linux.ibm.com>
Message-ID: <d6ba4248-77da-4963-5653-1548ced10712@linux.ibm.com>
Date:   Mon, 5 Oct 2020 12:24:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200928030147.7ee6f494.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_11:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010050116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/20 9:01 PM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:11 -0400
> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>
>> Let's hot plug/unplug adapters, domains and control domains assigned to or
>> unassigned from an AP matrix mdev device while it is in use by a guest per
>> the following:
>>
>> * When the APID of an adapter is assigned to a matrix mdev in use by a KVM
>>    guest, the adapter will be hot plugged into the KVM guest as long as each
>>    APQN derived from the Cartesian product of the APID being assigned and
>>    the APQIs already assigned to the guest's CRYCB references a queue device
>>    bound to the vfio_ap device driver.
>>
>> * When the APID of an adapter is unassigned from a matrix mdev in use by a
>>    KVM guest, the adapter will be hot unplugged from the KVM guest.
>>
>> * When the APQI of a domain is assigned to a matrix mdev in use by a KVM
>>    guest, the domain will be hot plugged into the KVM guest as long as each
>>    APQN derived from the Cartesian product of the APQI being assigned and
>>    the APIDs already assigned to the guest's CRYCB references a queue device
>>    bound to the vfio_ap device driver.
>>
>> * When the APQI of a domain is unassigned from a matrix mdev in use by a
>>    KVM guest, the domain will be hot unplugged from the KVM guest
> Hm, I suppose this means that what your guest effectively gets may depend
> on whether assign_domain or assign_adapter is done first.
>
> Suppose we have the queues
> 0.0 0.1
> 1.0
> bound to vfio_ap, i.e. 1.1 is missing for a reason different than
> belonging to the default drivers (for what exact reason no idea).

I'm not quite sure what you mean be "we have queue". I will
assume you mean those queues are bound to the vfio_ap
device driver. The only way this could happen is if somebody
manually unbinds queue 1.1.

> Let's suppose we started with the matix containing only adapter
> 0 (0.) and domain 0 (.0).
>
> After echo 1 > assign_adapter && echo 1 > assign_domain we end up with
> matrix:
> 0.0 0.1
> 1.0 1.1
> guest_matrix:
> 0.0 0.1
> while after echo 1 > assign_domain && echo 1 > assign_adapter we end up
> with:
> matrix:
> 0.0 0.1
> 1.0 1.1
> guest_matrix:
> 0.0
> 0.1
>
> That means, the set of bound queues and the set of assigned resources do
> not fully determine the set of resources passed through to the guest.
>
> I that a deliberate design choice?

Yes, it is a deliberate choice to only allow guest access to queues
represented by queue devices bound to the vfio_ap device driver.
The idea here is to adhere to the linux device model.

>
>> * When the domain number of a control domain is assigned to a matrix mdev
>>    in use by a KVM guest, the control domain will be hot plugged into the
>>    KVM guest.
>>
>> * When the domain number of a control domain is unassigned from a matrix
>>    mdev in use by a KVM guest, the control domain will be hot unplugged
>>    from the KVM guest.
>>
>> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 196 ++++++++++++++++++++++++++++++
>>   1 file changed, 196 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index cf3321eb239b..2b01a8eb6ee7 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -731,6 +731,56 @@ static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
>>   	}
>>   }
>>   
>> +static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
>> +					     unsigned long apid)
>> +{
>> +	DECLARE_BITMAP(aqm, AP_DOMAINS);
>> +	unsigned long apqi, apqn;
>> +
>> +	bitmap_copy(aqm, matrix_mdev->matrix.aqm, AP_DOMAINS);
>> +
>> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
>> +		if (!test_bit_inv(apqi,
>> +				  (unsigned long *) matrix_dev->info.aqm))
>> +			clear_bit_inv(apqi, aqm);
>> +
>> +		apqn = AP_MKQID(apid, apqi);
>> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
>> +			clear_bit_inv(apqi, aqm);
>> +	}
>> +
>> +	if (bitmap_empty(aqm, AP_DOMAINS))
>> +		return false;
>> +
>> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>> +	bitmap_copy(matrix_mdev->shadow_apcb.aqm, aqm, AP_DOMAINS);
>> +
>> +	return true;
>> +}
>> +
>> +static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
>> +					   unsigned long apid)
>> +{
>> +	unsigned long apqi, apqn;
>> +
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
>> +	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
>> +		return false;
>> +
>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
>> +		return vfio_ap_mdev_assign_apqis_4_apid(matrix_mdev, apid);
> Hm. Let's say we have the same situation regarding the bound queues as
> above but we start with the empty matrix, and do all the assignments
> while the guest is running.
>
> Consider the following sequence of actions.
>
> 1) echo 0 > assign_domain

matrix:            .0
guest_matrix: no APQNs

> 2) echo 1 > assign_domain

matrix:            .0, .1
guest_matrix: no APQNs

> 3) echo 1 > assign_adapter

matrix:           1.0, 1.1
guest_matrix: 1.0

> 4) echo 0 > assign_adapter

matrix:           0.0, 0.1, 1.0, 1.1
guest_matrix: 0.0, 1.0
> 5) echo 1 > unassign_adapter

matrix:           0.0, 0.1
guest_matrix: 0.0

> I understand that at 3), because
> bitmap_empty(matrix_mdev->shadow_apcb.aqm)we would end up with a shadow
> aqm containing just domain 0, as queue 1.1 ain't bound to us.

True

> Thus at the end we would have
> matrix:
> 0.0 0.1
> guest_matrix:
> 0.0

At the end I had:
matrix:            0.0, 0.1
guest_matrix: 0.0

> And if we add in an adapter 2. into the mix with the queues 2.0 and 2.1
> then after
> 6) echo 2 > assign_adapter
> we get
> Thus at the end we would have
> matrix:
> 0.0 0.1
> 2.0 2.1
> guest_matrix:
> 0.0
> 2.0
>
> This looks very quirky to me. Did I read the code wrong? Opinions?

You read the code correctly and I agree, this is a bit quirky. I would say
that after adding adapter 2, we should end up with guest matrix:
0.0, 0.1
2.0, 2.1

If you agree, I'll make the adjustment.

>
>> +
>> +	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS) {
>> +		apqn = AP_MKQID(apid, apqi);
>> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
>> +			return false;
>> +	}
>> +
>> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>> +
>> +	return true;
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
>> @@ -792,12 +842,42 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   	}
>>   	set_bit_inv(apid, matrix_mdev->matrix.apm);
>>   	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
>> +	if (vfio_ap_mdev_assign_guest_apid(matrix_mdev, apid))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>>   }
>>   static DEVICE_ATTR_WO(assign_adapter);
>>   
>> +static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
>> +					     unsigned long apid)
>> +{
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>> +		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
>> +			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>> +
>> +			/*
>> +			 * If there are no APIDs assigned to the guest, then
>> +			 * the guest will not have access to any queues, so
>> +			 * let's also go ahead and unassign the APQIs. Keeping
>> +			 * them around may yield unpredictable results during
>> +			 * a probe that is not related to a host AP
>> +			 * configuration change (i.e., an AP adapter is
>> +			 * configured online).
>> +			 */
> I don't quite understand this comment. Clearing out the other mask when
> the one becomes empty, does allow us to recover the full possible guest
> matrix in the scenario described above. I don't see any shadow
> manipulation in the probe handler at this stage. Are we maybe
> talking about the same effect as I described for assign?

Patch 15/16 is for the probe.

>
> Regards,
> Halil
>
>> +			if (bitmap_empty(matrix_mdev->shadow_apcb.apm,
>> +					 AP_DEVICES))
>> +				bitmap_clear(matrix_mdev->shadow_apcb.aqm, 0,
>> +					     AP_DOMAINS);
>> +
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /**
>>    * unassign_adapter_store
>>    *
>> @@ -834,12 +914,64 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>   	mutex_lock(&matrix_dev->lock);
>>   	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>>   	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
>> +	if (vfio_ap_mdev_unassign_guest_apid(matrix_mdev, apid))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>>   }
>>   static DEVICE_ATTR_WO(unassign_adapter);
>>   
>> +static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
>> +					     unsigned long apqi)
>> +{
>> +	DECLARE_BITMAP(apm, AP_DEVICES);
>> +	unsigned long apid, apqn;
>> +
>> +	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
>> +		if (!test_bit_inv(apid,
>> +				  (unsigned long *) matrix_dev->info.apm))
>> +			clear_bit_inv(apqi, apm);
>> +
>> +		apqn = AP_MKQID(apid, apqi);
>> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
>> +			clear_bit_inv(apid, apm);
>> +	}
>> +
>> +	if (bitmap_empty(apm, AP_DEVICES))
>> +		return false;
>> +
>> +	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
>> +	bitmap_copy(matrix_mdev->shadow_apcb.apm, apm, AP_DEVICES);
>> +
>> +	return true;
>> +}
>> +
>> +static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
>> +					   unsigned long apqi)
>> +{
>> +	unsigned long apid, apqn;
>> +
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
>> +	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
>> +		return false;
>> +
>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
>> +		return vfio_ap_mdev_assign_apids_4_apqi(matrix_mdev, apqi);
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
>> +		apqn = AP_MKQID(apid, apqi);
>> +		if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn))
>> +			return false;
>> +	}
>> +
>> +	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
>> +
>> +	return true;
>> +}
>> +
>>   /**
>>    * assign_domain_store
>>    *
>> @@ -901,12 +1033,41 @@ static ssize_t assign_domain_store(struct device *dev,
>>   	}
>>   	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>>   	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
>> +	if (vfio_ap_mdev_assign_guest_apqi(matrix_mdev, apqi))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>>   }
>>   static DEVICE_ATTR_WO(assign_domain);
>>   
>> +static bool vfio_ap_mdev_unassign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
>> +					     unsigned long apqi)
>> +{
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>> +		if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
>> +			clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
>> +
>> +			/*
>> +			 * If there are no APQIs assigned to the guest, then
>> +			 * the guest will not have access to any queues, so
>> +			 * let's also go ahead and unassign the APIDs. Keeping
>> +			 * them around may yield unpredictable results during
>> +			 * a probe that is not related to a host AP
>> +			 * configuration change (i.e., an AP adapter is
>> +			 * configured online).
>> +			 */
>> +			if (bitmap_empty(matrix_mdev->shadow_apcb.aqm,
>> +					 AP_DOMAINS))
>> +				bitmap_clear(matrix_mdev->shadow_apcb.apm, 0,
>> +					     AP_DEVICES);
>> +
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>>   
>>   /**
>>    * unassign_domain_store
>> @@ -944,12 +1105,28 @@ static ssize_t unassign_domain_store(struct device *dev,
>>   	mutex_lock(&matrix_dev->lock);
>>   	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>>   	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
>> +	if (vfio_ap_mdev_unassign_guest_apqi(matrix_mdev, apqi))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>>   }
>>   static DEVICE_ATTR_WO(unassign_domain);
>>   
>> +static bool vfio_ap_mdev_assign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
>> +					   unsigned long domid)
>> +{
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>> +		if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
>> +			set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
>> +
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /**
>>    * assign_control_domain_store
>>    *
>> @@ -984,12 +1161,29 @@ static ssize_t assign_control_domain_store(struct device *dev,
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	set_bit_inv(id, matrix_mdev->matrix.adm);
>> +	if (vfio_ap_mdev_assign_guest_cdom(matrix_mdev, id))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>>   }
>>   static DEVICE_ATTR_WO(assign_control_domain);
>>   
>> +static bool
>> +vfio_ap_mdev_unassign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
>> +				 unsigned long domid)
>> +{
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
>> +		if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
>> +			clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
>> +
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /**
>>    * unassign_control_domain_store
>>    *
>> @@ -1024,6 +1218,8 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	clear_bit_inv(domid, matrix_mdev->matrix.adm);
>> +	if (vfio_ap_mdev_unassign_guest_cdom(matrix_mdev, domid))
>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
> u

