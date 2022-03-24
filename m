Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9294E64B8
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 15:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350703AbiCXOKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 10:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242905AbiCXOKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 10:10:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE717520B;
        Thu, 24 Mar 2022 07:09:17 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22ODbQZl020524;
        Thu, 24 Mar 2022 14:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=VCYWgK2DzICxTfE4eM0Pqh4cejdVHcWzb0N2kCzgV3I=;
 b=r3rL3nvCf5U+fJ1rMsjnhAWtVG8Mc/K5ukntZ3mnWhsmTOcKvd3NRiH7ulmxYamO7Xln
 CqDgtweiRzTZ3emBFWn369kP6WeydOWBnwvKJ8wWZ9CrHuAnTCFxNQb2gIIcxUaUtDC3
 gdQe7nfc96BhJkXd+kXx/NJyUGvkXaJFfGc1aMWXCQLIypUXyJzSdwMvUUu9ZDgQlvSB
 /hPDrodw0XnmnlkS9LoCDbCA4NdSRlSYQEwhz76yC2ysvoHQpSUNzOsOmx6jhjDqCm7Z
 qy2d6cGKejftDvu1h1i9t/MC2bOmqISKa2a0Cu0tzVmzZCECnnVMZWENQUwEKhmXJiEo 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0pxcvy8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 14:09:15 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22ODfMos002214;
        Thu, 24 Mar 2022 14:09:15 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0pxcvy87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 14:09:15 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22OE5bCY001243;
        Thu, 24 Mar 2022 14:09:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3ew6ta2n0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 14:09:14 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22OE9DYA18743594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 14:09:13 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21E39B206A;
        Thu, 24 Mar 2022 14:09:13 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBAC6B2067;
        Thu, 24 Mar 2022 14:09:11 +0000 (GMT)
Received: from [9.160.22.200] (unknown [9.160.22.200])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 24 Mar 2022 14:09:11 +0000 (GMT)
Message-ID: <6366d229-7820-e4a0-16fd-855f0a6be6b5@linux.ibm.com>
Date:   Thu, 24 Mar 2022 10:09:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 15/18] s390/vfio-ap: handle config changed and scan
 complete notification
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-16-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-16-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8LDg4xDmTjJFgxu5ycoxCvvh0ti6sWv7
X-Proofpoint-ORIG-GUID: zPvHPX4iwinEp55urBlUY-FT3vzEafUK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_04,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 impostorscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
...
> @@ -790,13 +788,17 @@ static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
>   
>   	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
>   	/* If the queue is assigned to the matrix mdev, unlink it. */
> -	if (q)
> +	if (q) {
>   		vfio_ap_unlink_queue_fr_mdev(q);
>   
> -	/* If the queue is assigned to the APCB, store it in @qtable. */
> -	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> -	    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
> -		hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
> +		/* If the queue is assigned to the APCB, store it in @qtable. */
> +		if (qtable) {
> +			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> +			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
> +				hash_add(qtable->queues, &q->mdev_qnode,
> +					 q->apqn);
> +		}
> +	}
>   }

This appears to be an unrelated change. Does this belong in this patch?


>   /**
> @@ -1271,7 +1273,7 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
>    * @matrix_mdev: a mediated matrix device
>    * @kvm: reference to KVM instance
>    *
> - * Note: The matrix_dev->lock must be taken prior to calling
> + * Note: The matrix_dev->mdevs_lock must be taken prior to calling

This also seems to be unrelated.


>    * this function; however, the lock will be temporarily released while the
>    * guest's AP configuration is set to avoid a potential lockdep splat.
>    * The kvm->lock is taken to set the guest's AP configuration which, under
> @@ -1355,7 +1357,7 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>    * @matrix_mdev: a matrix mediated device
>    * @kvm: the pointer to the kvm structure being unset.
>    *
> - * Note: The matrix_dev->lock must be taken prior to calling
> + * Note: The matrix_dev->mdevs_lock must be taken prior to calling

Same here.

>    * this function; however, the lock will be temporarily released while the
>    * guest's AP configuration is cleared to avoid a potential lockdep splat.
>    * The kvm->lock is taken to clear the guest's AP configuration which, under
> @@ -1708,6 +1710,27 @@ static void vfio_ap_mdev_put_qlocks(struct ap_matrix_mdev *matrix_mdev)
>   	mutex_unlock(&matrix_dev->guests_lock);
>   }
>   
> +static bool vfio_ap_mdev_do_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
> +					  struct vfio_ap_queue *q)
> +{
> +	unsigned long apid = AP_QID_CARD(q->apqn);
> +	unsigned long apqi = AP_QID_QUEUE(q->apqn);
> +
> +	/*
> +	 * If the queue is being probed because its APID or APQI is in the
> +	 * process of being added to the host's AP configuration, then we don't
> +	 * want to filter the matrix now as the filtering will be done after
> +	 * the driver is notified that the AP bus scan operation has completed
> +	 * (see the vfio_ap_on_scan_complete callback function).
> +	 */
> +	if (test_bit_inv(apid, matrix_mdev->apm_add) ||
> +	    test_bit_inv(apqi, matrix_mdev->aqm_add))
> +		return false;
> +
> +
> +	return true;
> +}
> +
>   int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>   {
>   	struct vfio_ap_queue *q;
> @@ -1725,10 +1748,15 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>   		vfio_ap_mdev_link_queue(matrix_mdev, q);
>   		memset(apm, 0, sizeof(apm));
>   		set_bit_inv(AP_QID_CARD(q->apqn), apm);
> -		if (vfio_ap_mdev_filter_matrix(apm, q->matrix_mdev->matrix.aqm,
> -					       q->matrix_mdev))
> -			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
> +
> +		if (vfio_ap_mdev_do_filter_matrix(q->matrix_mdev, q)) {
> +			if (vfio_ap_mdev_filter_matrix(apm,
> +						q->matrix_mdev->matrix.aqm,
> +						q->matrix_mdev))
> +				vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
> +		}
>   	}
> +
>   	dev_set_drvdata(&apdev->device, q);
>   	vfio_ap_mdev_put_qlocks(matrix_mdev);
>   
> @@ -1783,10 +1811,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>   
>   		apid = AP_QID_CARD(q->apqn);
>   		apqi = AP_QID_QUEUE(q->apqn);
> -		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
> -		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
> -			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
> -			vfio_ap_mdev_hotplug_apcb(matrix_mdev);
> +
> +		/*
> +		 * If the queue is assigned to the guest's APCB, then remove
> +		 * the adapter's APID from the APCB and hot it into the guest.
> +		 */
> +		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) &&
> +		    test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm)) {
> +			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
> +			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);

It looks like this a bug fix unrelated to this patch...?

>   
> @@ -1842,3 +1875,267 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>   
>   	return ret;
>   }
> +
> +/**
> + * vfio_ap_mdev_hot_unplug_cfg - hot unplug the adapters, domains and control
> + *				 domains that have been removed from the host's
> + *				 AP configuration from a guest.
> + *
> + * @guest: the guest
> + * @aprem: the adapters that have been removed from the host's AP configuration
> + * @aqrem: the domains that have been removed from the host's AP configuration
> + * @cdrem: the control domains that have been removed from the host's AP
> + *	   configuration.
> + */
> +static void vfio_ap_mdev_hot_unplug_cfg(struct ap_matrix_mdev *matrix_mdev,
> +					unsigned long *aprem,
> +					unsigned long *aqrem,
> +					unsigned long *cdrem)
> +{
> +	bool do_hotplug = false;

__bitmap_andnot() returns an int, so I think you should use an int here.


> +	if (!bitmap_empty(aprem, AP_DEVICES)) {
> +		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.apm,
> +					    matrix_mdev->shadow_apcb.apm,
> +					    aprem, AP_DEVICES);

Also, replace the |= with an = here. This is the first assignment so no
need to do a logical OR as there is no pre-existing data to preserve.


> +	}
> +
> +	if (!bitmap_empty(aqrem, AP_DOMAINS)) {
> +		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.aqm,
> +					    matrix_mdev->shadow_apcb.aqm,
> +					    aqrem, AP_DEVICES);
> +	}
> +
> +	if (!bitmap_empty(cdrem, AP_DOMAINS))
> +		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.adm,
> +					    matrix_mdev->shadow_apcb.adm,
> +					    cdrem, AP_DOMAINS);
> +
> +	if (do_hotplug)
> +		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
> +}
> +
> +/**
> + * vfio_ap_mdev_cfg_remove - determines which guests are using the adapters,
> + *			     domains and control domains that have been removed
> + *			     from the host AP configuration and unplugs them
> + *			     from those guests.
> + *
> + * @ap_remove:	bitmap specifying which adapters have been removed from the host
> + *		config.
> + * @aq_remove:	bitmap specifying which domains have been removed from the host
> + *		config.
> + * @cd_remove:	bitmap specifying which control domains have been removed from
> + *		the host config.
> + */
...
> +/**
> + * vfio_ap_mdev_on_cfg_remove - responds to the removal of adapters, domains and
> + *				control domains from the host AP configuration
> + *				by unplugging them from the guests that are
> + *				using them.
> + */
> +static void vfio_ap_mdev_on_cfg_remove(void)
> +{
> +	int ap_remove, aq_remove, cd_remove;

These can all be replaced with a single variable, just like you did with do_add.

> +	DECLARE_BITMAP(aprem, AP_DEVICES);
> +	DECLARE_BITMAP(aqrem, AP_DOMAINS);
> +	DECLARE_BITMAP(cdrem, AP_DOMAINS);
> +	unsigned long *cur_apm, *cur_aqm, *cur_adm;
> +	unsigned long *prev_apm, *prev_aqm, *prev_adm;
> +
> +	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
> +	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
> +	cur_adm = (unsigned long *)matrix_dev->config_info.adm;
> +	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
> +	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
> +	prev_adm = (unsigned long *)matrix_dev->config_info_prev.adm;
> +
> +	ap_remove = bitmap_andnot(aprem, prev_apm, cur_apm, AP_DEVICES);
> +	aq_remove = bitmap_andnot(aqrem, prev_aqm, cur_aqm, AP_DOMAINS);
> +	cd_remove = bitmap_andnot(cdrem, prev_adm, cur_adm, AP_DOMAINS);
> +
> +	if (ap_remove || aq_remove || cd_remove)
> +		vfio_ap_mdev_cfg_remove(aprem, aqrem, cdrem);
> +}
...
> +/**
> + * vfio_ap_on_cfg_changed - handles notification of changes to the host AP
> + *			    configuration.
> + *
> + * @new_config_info: the new host AP configuration
> + * @old_config_info: the previous host AP configuration
> + */
> +void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
> +			    struct ap_config_info *old_config_info)
> +{
> +	mutex_lock(&matrix_dev->guests_lock);
> +
> +	memcpy(&matrix_dev->config_info_prev, old_config_info,
> +		       sizeof(struct ap_config_info));
> +	memcpy(&matrix_dev->config_info, new_config_info,
> +	       sizeof(struct ap_config_info));

Why are we storing old_config_info in the matrix_dev? It appears to only
be used within the functions called from right here. Why not just pass it
as an argument?

> +	vfio_ap_mdev_on_cfg_remove();
> +	vfio_ap_mdev_on_cfg_add();
> +
> +	mutex_unlock(&matrix_dev->guests_lock);
> +}

Here is an idea to restructure things... consider combining logic from
vfio_ap_mdev_on_cfg_remove and vfio_ap_mdev_on_cfg_add with
vfio_ap_on_cfg_changed. This makes vfio_ap_on_cfg_changed() longer but
it eliminates some duplicated code and gets rid of both
vfio_ap_mdev_on_cfg_remove and vfio_ap_mdev_on_cfg_add.
note: Untested... :)

void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
			    struct ap_config_info *old_config_info)
{
	DECLARE_BITMAP(changed_adapters, AP_DEVICES);
	DECLARE_BITMAP(changed_domains, AP_DOMAINS);
	DECLARE_BITMAP(changed_cdoms, AP_DOMAINS);
	unsigned long *cur_apm, *cur_aqm, *cur_adm;
	unsigned long *prev_apm, *prev_aqm, *prev_adm;

	cur_apm = (unsigned long *)new_config_info->apm;
	cur_aqm = (unsigned long *)new_config_info->aqm;
	cur_adm = (unsigned long *)new_config_info->adm;
	prev_apm = (unsigned long *)old_config_info->apm;
	prev_aqm = (unsigned long *)old_config_info->.aqm;
	prev_adm = (unsigned long *)old_config_info->adm;

	mutex_lock(&matrix_dev->guests_lock);
	
	/* Handle host configuration removals */
	bitmap_andnot(changed_adapters, prev_apm, cur_apm, AP_DEVICES);
	bitmap_andnot(changed_domains, prev_aqm, cur_aqm, AP_DOMAINS);
	bitmap_andnot(changed_cdoms, prev_adm, cur_adm, AP_DOMAINS);

	if (changed_adapters || changed_domains || changed_cdoms)
		vfio_ap_mdev_cfg_remove(aprem, aqrem, cdrem);

	bitmap_clear(changed_adapters, 0, AP_DEVICES);
	bitmap_clear(changed_domains, 0, AP_DOMAINS);
	bitmap_clear(changed_cdoms, 0, AP_DOMAINS);

	/* Handle host configuration additions */
	bitmap_andnot(changed_adapters, cur_apm, prev_apm, AP_DEVICES);
	bitmap_andnot(changed_domains, cur_aqm, prev_aqm, AP_DOMAINS);
	bitmap_andnot(changed_cdoms, cur_adm, prev_adm, AP_DOMAINS);

	if (changed_adapters || changed_domains || changed_cdoms) {
		vfio_ap_mdev_cfg_add(apm_add, aqm_add, adm_add);
	}
	mutex_unlock(&matrix_dev->guests_lock);
}

Not sure if where I put the locking is 100% correct. We could do a
lock/unlock around each call to vfio_ap_mdev_cfg_{remove|add} but
there is probablyt no point to that, right?

Also, a side effect of these changes is that matrix_dev->config_info
is no longer updated. I guess we either would need to update it here
or update it wherever it was originally updated before this patrch.

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
