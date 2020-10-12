Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4120B28C402
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 23:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgJLV1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 17:27:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgJLV1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 17:27:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CL1idn114122;
        Mon, 12 Oct 2020 17:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=myU/DteIURSWurvS9ME1bVo31BjIRt1zRFBxspz4xj0=;
 b=e9EmgJVd503+ADvrOZtgS4b45IwNAgwzcjjY5Z2PfmGN14xJwfI6t+4M8RJAKPLBTzog
 9LQBmZnvpwnUOlwbOlznzvFGrnKsRKhxK/MI+Rp/xb4Gm7JJoyuDxV9GeBKLl9lG1U5n
 lE2hANGFvw7eMY9rDSezUCM0ceW9kZ1WOIIQpPU6qjSsAj7Awv5yDoHmSWCpbVsNikpc
 XEXNY1QX6BGuzHQQY3jFx0/hcpstSdYT/BfEpKKtjgiYzzSm+zFFhyktxe4TtoYXpKey
 LaSy34yO57oecF09G43mKbTXhUtoCvUiXOc7j8KWG79j35EYquych5cuN9igLDX0Wfmf UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344v8tm29h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 17:27:50 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09CL1mPX114265;
        Mon, 12 Oct 2020 17:27:50 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344v8tm299-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 17:27:50 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09CLCvpI011100;
        Mon, 12 Oct 2020 21:27:49 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3434k8tk3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 21:27:48 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09CLRjw034734578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 21:27:45 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BDA36A047;
        Mon, 12 Oct 2020 21:27:45 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5B0F6A051;
        Mon, 12 Oct 2020 21:27:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 12 Oct 2020 21:27:43 +0000 (GMT)
Subject: Re: [PATCH v10 13/16] s390/vfio-ap: handle host AP config change
 notification
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-14-akrowiak@linux.ibm.com>
 <20200928033817.20b95549.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <e5ddd1ae-0c35-0089-1d40-30157065dece@linux.ibm.com>
Date:   Mon, 12 Oct 2020 17:27:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200928033817.20b95549.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_17:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120154
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/20 9:38 PM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:13 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Implements the driver callback invoked by the AP bus when the host
>> AP configuration has changed. Since this callback is invoked prior to
>> unbinding a device from its device driver, the vfio_ap driver will
>> respond by unplugging the AP adapters, domains and control domains
>> removed from the host's AP configuration from the guests using them.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reported-by: kernel test robot <lkp@intel.com>
> Looks reasonable, but shouldn't vfio_ap_mdev_remove_queue() already
> have code that kicks the queue from the shadow at this stage?
>
> I mean if the removal is for a reason different that host config change,
> we wont update the guest_matrix or?

This patch specifically handles AP configuration change notification.
The idea behind this notification is that if a configuration change results
in one or more queues getting removed from the guest, it can be done
in bulk before each of the queues is unbound by the AP bus. That way
any cleanup (e.g., resets etc.) can be performed before the bus gets
control.

Also, keep in mind that an unbind can take place for reasons other than
an AP configuration change:
1. Manual unbind of a queue
2. Deconfiguration of an adapter
3. Adapter is broken (e.g., CHECKSTOP)
If the queue is being unbound as a result of an AP configuration
change, the vfio_ap_remove_queue() function will ignore the
unbind because it has already been handled by this on_config_changed
callback prior to the unbind operation (see patch 15/16).
>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |   5 +-
>>   drivers/s390/crypto/vfio_ap_ops.c     | 147 ++++++++++++++++++++++++--
>>   drivers/s390/crypto/vfio_ap_private.h |   7 +-
>>   3 files changed, 146 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index aae5b3d8e3fa..ea0a7603e886 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -115,9 +115,11 @@ static int vfio_ap_matrix_dev_create(void)
>>   
>>   	/* Fill in config info via PQAP(QCI), if available */
>>   	if (test_facility(12)) {
>> -		ret = ap_qci(&matrix_dev->info);
>> +		ret = ap_qci(&matrix_dev->config_info);
>>   		if (ret)
>>   			goto matrix_alloc_err;
>> +		memcpy(&matrix_dev->config_info_prev, &matrix_dev->config_info,
>> +		       sizeof(struct ap_config_info));
>>   	}
>>   
>>   	mutex_init(&matrix_dev->lock);
>> @@ -177,6 +179,7 @@ static int __init vfio_ap_init(void)
>>   	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
>>   	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
>>   	vfio_ap_drv.ids = ap_queue_ids;
>> +	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
>>   
>>   	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
>>   	if (ret) {
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 2b01a8eb6ee7..e002d556abab 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -347,7 +347,9 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   	}
>>   
>>   	matrix_mdev->mdev = mdev;
>> -	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> +	vfio_ap_matrix_init(&matrix_dev->config_info, &matrix_mdev->matrix);
>> +	vfio_ap_matrix_init(&matrix_dev->config_info,
>> +			    &matrix_mdev->shadow_apcb);
>>   	hash_init(matrix_mdev->qtable);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>> @@ -526,8 +528,8 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
>>   		 * If the APID is not assigned to the host AP configuration,
>>   		 * we can not assign it to the guest's AP configuration
>>   		 */
>> -		if (!test_bit_inv(apid,
>> -				  (unsigned long *)matrix_dev->info.apm)) {
>> +		if (!test_bit_inv(apid, (unsigned long *)
>> +				  matrix_dev->config_info.apm)) {
>>   			clear_bit_inv(apid, shadow_apcb->apm);
>>   			continue;
>>   		}
>> @@ -540,7 +542,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
>>   			 * guest's AP configuration
>>   			 */
>>   			if (!test_bit_inv(apqi, (unsigned long *)
>> -					  matrix_dev->info.aqm)) {
>> +					  matrix_dev->config_info.aqm)) {
>>   				clear_bit_inv(apqi, shadow_apcb->aqm);
>>   				continue;
>>   			}
>> @@ -594,7 +596,7 @@ static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
>>   	int napm, naqm;
>>   	struct ap_matrix shadow_apcb;
>>   
>> -	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
>> +	vfio_ap_matrix_init(&matrix_dev->config_info, &shadow_apcb);
>>   	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
>>   	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
>>   
>> @@ -741,7 +743,7 @@ static bool vfio_ap_mdev_assign_apqis_4_apid(struct ap_matrix_mdev *matrix_mdev,
>>   
>>   	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
>>   		if (!test_bit_inv(apqi,
>> -				  (unsigned long *) matrix_dev->info.aqm))
>> +				  (unsigned long *)matrix_dev->config_info.aqm))
>>   			clear_bit_inv(apqi, aqm);
>>   
>>   		apqn = AP_MKQID(apid, apqi);
>> @@ -764,7 +766,7 @@ static bool vfio_ap_mdev_assign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
>>   	unsigned long apqi, apqn;
>>   
>>   	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
>> -	    !test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm))
>> +	    !test_bit_inv(apid, (unsigned long *)matrix_dev->config_info.apm))
>>   		return false;
>>   
>>   	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
>> @@ -931,8 +933,8 @@ static bool vfio_ap_mdev_assign_apids_4_apqi(struct ap_matrix_mdev *matrix_mdev,
>>   	bitmap_copy(apm, matrix_mdev->matrix.apm, AP_DEVICES);
>>   
>>   	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
>> -		if (!test_bit_inv(apid,
>> -				  (unsigned long *) matrix_dev->info.apm))
>> +		if (!test_bit_inv(apid, (unsigned long *)
>> +				  matrix_dev->config_info.apm))
>>   			clear_bit_inv(apqi, apm);
>>   
>>   		apqn = AP_MKQID(apid, apqi);
>> @@ -955,7 +957,7 @@ static bool vfio_ap_mdev_assign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
>>   	unsigned long apid, apqn;
>>   
>>   	if (!vfio_ap_mdev_has_crycb(matrix_mdev) ||
>> -	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm))
>> +	    !test_bit_inv(apqi, (unsigned long *)matrix_dev->config_info.aqm))
>>   		return false;
>>   
>>   	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
>> @@ -1702,7 +1704,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>>   void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>>   {
>>   	struct vfio_ap_queue *q;
>> -	int apid, apqi;
>> +	unsigned long apid, apqi;
>>   
> Unrelated?

Yes, I'll remove it.

>
>>   	mutex_lock(&matrix_dev->lock);
>>   	q = dev_get_drvdata(&queue->ap_dev.device);
>> @@ -1727,3 +1729,126 @@ bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>>   
>>   	return in_use;
>>   }
>> +
>> +/**
>> + * vfio_ap_mdev_unassign_apids
>> + *
>> + * @matrix_mdev: The matrix mediated device
>> + *
>> + * @aqm: A bitmap with 256 bits. Each bit in the map represents an APID from 0
>> + *	 to 255 (with the leftmost bit corresponding to APID 0).
>> + *
>> + * Unassigns each APID specified in @aqm that is assigned to the shadow CRYCB
>> + * of @matrix_mdev. Returns true if at least one APID is unassigned; otherwise,
>> + * returns false.
>> + */
>> +static bool vfio_ap_mdev_unassign_apids(struct ap_matrix_mdev *matrix_mdev,
>> +					unsigned long *apm_unassign)
>> +{
>> +	unsigned long apid;
>> +	bool unassigned = false;
>> +
>> +	/*
>> +	 * If the matrix mdev is not in use by a KVM guest, return indicating
>> +	 * that no APIDs have been unassigned.
>> +	 */
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>> +		return false;
>> +
>> +	for_each_set_bit_inv(apid, apm_unassign, AP_DEVICES) {
>> +		unassigned |= vfio_ap_mdev_unassign_guest_apid(matrix_mdev,
>> +							       apid);
>> +	}
> I guess, we could accomplish the unassign with operations operating on
> full bitmaps (without looping over bits), but I have no strong opinion
> here.

Yes we can and will.

>
>> +
>> +	return unassigned;
>> +}
>> +
>> +/**
>> + * vfio_ap_mdev_unassign_apqis
>> + *
>> + * @matrix_mdev: The matrix mediated device
>> + *
>> + * @aqm: A bitmap with 256 bits. Each bit in the map represents an APQI from 0
>> + *	 to 255 (with the leftmost bit corresponding to APQI 0).
>> + *
>> + * Unassigns each APQI specified in @aqm that is assigned to the shadow CRYCB
>> + * of @matrix_mdev. Returns true if at least one APQI is unassigned; otherwise,
>> + * returns false.
>> + */
>> +static bool vfio_ap_mdev_unassign_apqis(struct ap_matrix_mdev *matrix_mdev,
>> +					unsigned long *aqm_unassign)
>> +{
>> +	unsigned long apqi;
>> +	bool unassigned = false;
>> +
>> +	/*
>> +	 * If the matrix mdev is not in use by a KVM guest, return indicating
>> +	 * that no APQIs have been unassigned.
>> +	 */
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>> +		return false;
>> +
>> +	for_each_set_bit_inv(apqi, aqm_unassign, AP_DOMAINS) {
>> +		unassigned |= vfio_ap_mdev_unassign_guest_apqi(matrix_mdev,
>> +							       apqi);
>> +	}
>> +
>> +	return unassigned;
>> +}
>> +
>> +void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
>> +			    struct ap_config_info *old_config_info)
>> +{
>> +	bool unassigned;
>> +	int ap_remove, aq_remove;
>> +	struct ap_matrix_mdev *matrix_mdev;
>> +	DECLARE_BITMAP(apm_unassign, AP_DEVICES);
>> +	DECLARE_BITMAP(aqm_unassign, AP_DOMAINS);
>> +
>> +	unsigned long *cur_apm, *cur_aqm, *prev_apm, *prev_aqm;
>> +
>> +	if (matrix_dev->flags & AP_MATRIX_CFG_CHG) {
>> +		WARN_ONCE(1, "AP host configuration change already reported");
>> +		return;
>> +	}
>> +
>> +	memcpy(&matrix_dev->config_info, new_config_info,
>> +	       sizeof(struct ap_config_info));
>> +	memcpy(&matrix_dev->config_info_prev, old_config_info,
>> +	       sizeof(struct ap_config_info));
>> +
>> +	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
>> +	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
>> +	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
>> +	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
>> +
>> +	ap_remove = bitmap_andnot(apm_unassign, prev_apm, cur_apm, AP_DEVICES);
>> +	aq_remove = bitmap_andnot(aqm_unassign, prev_aqm, cur_aqm, AP_DOMAINS);
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	matrix_dev->flags |= AP_MATRIX_CFG_CHG;
>> +
>> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +		if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>> +			continue;
>> +
>> +		unassigned = false;
>> +
>> +		if (ap_remove)
>> +			if (bitmap_intersects(matrix_mdev->shadow_apcb.apm,
>> +					      apm_unassign, AP_DEVICES))
>> +				if (vfio_ap_mdev_unassign_apids(matrix_mdev,
>> +								apm_unassign))
> This can be done with a single "if".
>
> if (A)
> 	if (B)
> 		if (C)
> 			D;
>
> should be equivalent with
> if (A && B && C)
> 	D;
> and your wouldn't end up that deep indentation. It is a style thing,
> so unless regulated by the official coding style, it is up to you :)

I will simplify it.

>
>
>> +					unassigned = true;
>> +		if (aq_remove)
>> +			if (bitmap_intersects(matrix_mdev->shadow_apcb.aqm,
>> +					      aqm_unassign, AP_DOMAINS))
>> +				if (vfio_ap_mdev_unassign_apqis(matrix_mdev,
>> +								aqm_unassign))
>> +					unassigned = true;
>> +
>> +		if (unassigned)
>> +			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>> +	}
>> +	mutex_unlock(&matrix_dev->lock);
>> +}
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 055bce6d45db..fc8629e28ad3 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -40,10 +40,13 @@
>>   struct ap_matrix_dev {
>>   	struct device device;
>>   	atomic_t available_instances;
>> -	struct ap_config_info info;
>> +	struct ap_config_info config_info;
>> +	struct ap_config_info config_info_prev;
>>   	struct list_head mdev_list;
>>   	struct mutex lock;
>>   	struct ap_driver  *vfio_ap_drv;
>> +	#define AP_MATRIX_CFG_CHG (1UL << 0)
>> +	unsigned long flags;
>>   };
>>   
>>   extern struct ap_matrix_dev *matrix_dev;
>> @@ -108,5 +111,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
>>   void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
>>   
>>   bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
>> +void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
>> +			    struct ap_config_info *old_config_info);
>>   
>>   #endif /* _VFIO_AP_PRIVATE_H_ */

