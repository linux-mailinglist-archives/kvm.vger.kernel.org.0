Return-Path: <kvm+bounces-57610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3405B58447
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E934C0A14
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874E22C375E;
	Mon, 15 Sep 2025 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IuEzKjFB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2C8277CB6;
	Mon, 15 Sep 2025 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757959986; cv=none; b=AxtvYkDkGWcMoQawS97esRCPIL2UuhwEBbXjf7Vuqrewm2p2Bnizvy7HFkVgf1f15O83icfXrTZDbVpbqRFY5kUVgU4zEQczEv3E6DViVLSDNHxLTN1xBlR/Tpe0+pyjIVkg0FTLvax0N4ozP1kFYQbWxfZkJbxTKB7x0+TR5BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757959986; c=relaxed/simple;
	bh=eKIEL/0+86b9zCNVArJjBMUykVmOw0gGLnWxa9sXinQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MuYQitLaQEn7MG4g1G/XVfTvXLkgUm9D1ajaBhXW+aoRirrSk1UxzexSa79gTlk+qVpJ84VD8l1I0+RAEK45xTEhIm0CB4Ij0r362YKbvNGlzwcaTwVguybQ1DepUiHcwlnhJLqVUs3sYWjNr1QfAVizVjtqiATbUcDsFvD+0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IuEzKjFB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDHMvM002966;
	Mon, 15 Sep 2025 18:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yZBr5S
	3BIdCU0zNthVRZh/UQ62NxgU4qZLV7GKnmFDE=; b=IuEzKjFBm/vZz/ZC5YFlSb
	GN9ozj2da4wv0VmBRSOfOYMKOZ+DNBw36iY8IiPMPebhXW7OGn38yIRzETYwuDnD
	l6CDt46IhacYf98Me3ZbSIB7t3aHNElSIY8/pPJyT9CCi6K/uH08FIaVSVuo1X8i
	uMSXq2c2o2h6yfVeBTipVfElKptW/wOqnZCovqTQLLSgdBFGhk4yQELKdPKAXRlA
	gidYncB/mVRrhPcqgcDM4ZTG6DwKsnzNIAgVHdRts/v3ltlcNH796dSiCIzERk4z
	sisMpnwDSO3oARh9OPMuc4T3PRDgzL1TbGp6tAaRFsSlUaKVzTZfcp8xQbJ7bIZw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tc1y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:13:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FG5dNS018649;
	Mon, 15 Sep 2025 18:12:59 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5m7jxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 18:12:59 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FICllF67043828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 18:12:47 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B2435805B;
	Mon, 15 Sep 2025 18:12:57 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68BC458058;
	Mon, 15 Sep 2025 18:12:56 +0000 (GMT)
Received: from [9.61.244.242] (unknown [9.61.244.242])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 18:12:56 +0000 (GMT)
Message-ID: <98a3bc6f-9b75-48cd-b09f-343831f5dcbf@linux.ibm.com>
Date: Mon, 15 Sep 2025 11:12:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] s390/pci: Store PCI error information for
 passthrough devices
To: Niklas Schnelle <schnelle@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-8-alifm@linux.ibm.com>
 <197d61dcb036c1038180acf26042b82d4320b9f2.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <197d61dcb036c1038180acf26042b82d4320b9f2.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c8572c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=HUhea7Ya2d6YH5jap20A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bDOYvmXmZhOgptyHSjlwKLTU4BjIojW8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX32mGX+p3QOaG
 6Tx5Fposyzxpe6ixJ//ku7mEYHIfCyBhWFjJOMQNPJ9KOicgswhS5+GlTVZSTndb1g+G6E/ISun
 WMv8hmeiGuqZnK92RwZvvr/yIAnU3VPjWpAQzlZEsYDygp75oyAC52CSQjpMQD6c6EppJ+7kKzl
 qaWuyh1RHvmOMeiUZAUESr/sLYXLNNHhHM59yk+9RGnVp6EiuXUGwBsbn/6z5EE4pp5MHqid7+p
 sx/DSks6p8Abkv29DLvdS7iiL0qRoIfTjUlPIC0z5df9LWWBXlEH0HA2I39C+QIi1zGmUGvdM8p
 XZrQcE4D8MlzWoAZsSkSHT2w3QyRjir4+nrq2NpuGJUIv3ta3WVFpZuIhHeTaiVMtmTwpNM/33w
 lhYNPsal
X-Proofpoint-GUID: bDOYvmXmZhOgptyHSjlwKLTU4BjIojW8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001


On 9/15/2025 4:42 AM, Niklas Schnelle wrote:
> On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
>> For a passthrough device we need co-operation from user space to recover
>> the device. This would require to bubble up any error information to user
>> space.  Let's store this error information for passthrough devices, so it
>> can be retrieved later.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h      | 28 ++++++++++
>>   arch/s390/pci/pci.c              |  1 +
>>   arch/s390/pci/pci_event.c        | 95 +++++++++++++++++++-------------
>>   drivers/vfio/pci/vfio_pci_zdev.c |  2 +
>>   4 files changed, 88 insertions(+), 38 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index f47f62fc3bfd..72e05af90e08 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -116,6 +116,31 @@ struct zpci_bus {
>>   	enum pci_bus_speed	max_bus_speed;
>>   };
>>   
>> +/* Content Code Description for PCI Function Error */
>> +struct zpci_ccdf_err {
>> +	u32 reserved1;
>> +	u32 fh;                         /* function handle */
>> +	u32 fid;                        /* function id */
>> +	u32 ett         :  4;           /* expected table type */
>> +	u32 mvn         : 12;           /* MSI vector number */
>> +	u32 dmaas       :  8;           /* DMA address space */
>> +	u32 reserved2   :  6;
>> +	u32 q           :  1;           /* event qualifier */
>> +	u32 rw          :  1;           /* read/write */
>> +	u64 faddr;                      /* failing address */
>> +	u32 reserved3;
>> +	u16 reserved4;
>> +	u16 pec;                        /* PCI event code */
>> +} __packed;
>> +
>> +#define ZPCI_ERR_PENDING_MAX 16
> 16 pending error events sounds like a lot for a single devices. This
> also means that the array alone already spans more than 2 cache lines
> (256 byte on s390x). I can't imagine that we'd ever have that many
> errors pending. This is especially true since a device already in an
> error state would be the least likely to cause more errors. We have
> seen cases of 2 errors in the past, so maybe 4 would give us good head
> room?

Yeah, I wasn't sure how much headroom did we need. As you said having 
more than 2 is rare, so 4 should give us enough room.


>> +struct zpci_ccdf_pending {
>> +	size_t count;
>> +	int head;
>> +	int tail;
>> +	struct zpci_ccdf_err err[ZPCI_ERR_PENDING_MAX];
>> +};
>> +
>>   /* Private data per function */
>>   struct zpci_dev {
>>   	struct zpci_bus *zbus;
>> @@ -191,6 +216,8 @@ struct zpci_dev {
>>   	struct iommu_domain *s390_domain; /* attached IOMMU domain */
>>   	struct kvm_zdev *kzdev;
>>   	struct mutex kzdev_lock;
>> +	struct zpci_ccdf_pending pending_errs;
>> +	struct mutex pending_errs_lock;
>>   	spinlock_t dom_lock;		/* protect s390_domain change */
>>   };
>>
> --- snip ---
>
>> -
>>   /* Content Code Description for PCI Function Availability */
>>   struct zpci_ccdf_avail {
>>   	u32 reserved1;
>> @@ -76,6 +59,41 @@ static bool is_driver_supported(struct pci_driver *driver)
>>   	return true;
>>   }
>>   
>> +static void zpci_store_pci_error(struct pci_dev *pdev,
>> +				 struct zpci_ccdf_err *ccdf)
>> +{
>> +	struct zpci_dev *zdev = to_zpci(pdev);
>> +	int i;
>> +
>> +	mutex_lock(&zdev->pending_errs_lock);
>> +	if (zdev->pending_errs.count >= ZPCI_ERR_PENDING_MAX) {
>> +		pr_err("%s: Cannot store PCI error info for device",
>> +				pci_name(pdev));
>> +		mutex_unlock(&zdev->pending_errs_lock);
> I think the error message should state that the maximum number of
> pending error events has been queued. As with the ZPI_ERR_PENDING_MAX I
> really don't think we would reach this even at 4 vs 16 max pending but
> if we do I agree that having the first couple of errors saved is
> probably nice for analysis.

Ack, will change the error message.


>
>> +		return;
>> +	}
>> +
>> +	i = zdev->pending_errs.tail % ZPCI_ERR_PENDING_MAX;
>> +	memcpy(&zdev->pending_errs.err[i], ccdf, sizeof(struct zpci_ccdf_err));
>> +	zdev->pending_errs.tail++;
>> +	zdev->pending_errs.count++;
> With tail being int this would be undefined behavior if it ever
> overflowed. Since the array is of fixed length that is always smaller
> than 256 how about making tail, head, and count u8. The memory saving
> doesn't matter but at least overflow becomes well defined.

Yeah, this makes sense, will update this.


>
>> +	mutex_unlock(&zdev->pending_errs_lock);
>> +}
>> +
>> +void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +
>> +	mutex_lock(&zdev->pending_errs_lock);
>> +	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
>> +	if (zdev->pending_errs.count)
>> +		pr_err("%s: Unhandled PCI error events count=%zu",
>> +				pci_name(pdev), zdev->pending_errs.count);
> I think this could be a zpci_dbg(). That way you also don't need the
> pci_get_slot() which is also buggy as it misses a pci_dev_put(). The
> message also doesn't seem useful for the user. As I understand it this
> would happen if a vfio-pci user dies without handling all the error
> events but then vfio-pci will also reset the slot on closing of the
> fds, no? So the device will get reset anyway.

Right, the device will reset anyway. But I wanted to at least give an 
indication to the user that some events were not handled correctly. 
Maybe pr_err is a little extreme, so can convert to a warn? This should 
be rare as well behaving applications shouldn't do this. I am fine with 
zpci_dbg as well, its just the kernel needs to be in debug mode for us 
to get this info.

>
>> +	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));
> If this goes wrong and we subsequently crash or take a live memory dump
> I'd prefer to have bread crumbs such as the errors that weren't cleaned
> up. Wouldn't it be enough to just set the count to zero and for debug
> the original count will be in s390dbf.

I think setting count to zero should be enough, but I am wary about 
keeping stale state around. How about just logging the count that was 
not handled, in s390dbf? I think we already dump the ccdf in s390df if 
we get any error event. So it should be enough for us to trace back the 
unhandled error events?

> Also maybe it would make sense
> to pull the zdev->mediated_recovery clearing in here?

I would like to keep the mediated_recovery flag separate from just 
cleaning up the errors. The flag gets initialized when we open the vfio 
device and so having the flag cleared on close makes it easier to track 
this IMHO.


>
>> +	mutex_unlock(&zdev->pending_errs_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(zpci_cleanup_pending_errors);
>> +
>>   static pci_ers_result_t zpci_event_notify_error_detected(struct pci_dev *pdev,
>>   							 struct pci_driver *driver)
>>   {
>> @@ -169,7 +187,8 @@ static pci_ers_result_t zpci_event_do_reset(struct pci_dev *pdev,
>>    * and the platform determines which functions are affected for
>>    * multi-function devices.
>>    */
>> -static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
>> +static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev,
>> +							  struct zpci_ccdf_err *ccdf)
>>   {
>>   	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
>>   	struct zpci_dev *zdev = to_zpci(pdev);
>> @@ -188,13 +207,6 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
>>   	}
>>   	pdev->error_state = pci_channel_io_frozen;
>>   
>> -	if (needs_mediated_recovery(pdev)) {
>> -		pr_info("%s: Cannot be recovered in the host because it is a pass-through device\n",
>> -			pci_name(pdev));
>> -		status_str = "failed (pass-through)";
>> -		goto out_unlock;
>> -	}
>> -
>>   	driver = to_pci_driver(pdev->dev.driver);
>>   	if (!is_driver_supported(driver)) {
>>   		if (!driver) {
>> @@ -210,12 +222,22 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
>>   		goto out_unlock;
>>   	}
>>   
>> +	if (needs_mediated_recovery(pdev))
>> +		zpci_store_pci_error(pdev, ccdf);
>> +
>>   	ers_res = zpci_event_notify_error_detected(pdev, driver);
>>   	if (ers_result_indicates_abort(ers_res)) {
>>   		status_str = "failed (abort on detection)";
>>   		goto out_unlock;
>>   	}
>>   
>> +	if (needs_mediated_recovery(pdev)) {
>> +		pr_info("%s: Recovering passthrough device\n", pci_name(pdev));
> I'd say technically we're not recovering the device here but rather
> leaving it alone so user-space can take over the recovery. Maybe this
> could be made explicit in the message. Something like:
>
> ""%s: Leaving recovery of pass-through device to user-space\n"
>
Sure, will update

Thanks
Farhan


>
>> +		ers_res = PCI_ERS_RESULT_RECOVERED;
>> +		status_str = "in progress";
>> +		goto out_unlock;
>> +	}
>> +
>>   	if (ers_res != PCI_ERS_RESULT_NEED_RESET) {
>>   		ers_res = zpci_event_do_error_state_clear(pdev, driver);
>>   		if (ers_result_indicates_abort(ers_res)) {
>> @@ -258,25 +280,20 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
>>    * @pdev: PCI function for which to report
>>    * @es: PCI channel failure state to report
>>    */
>> -static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es)
>> +static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es,
>> +				  struct zpci_ccdf_err *ccdf)
>>   {
>>   	struct pci_driver *driver;
>>   
>>   	pci_dev_lock(pdev);
>>   	pdev->error_state = es;
>> -	/**
>> -	 * While vfio-pci's error_detected callback notifies user-space QEMU
>> -	 * reacts to this by freezing the guest. In an s390 environment PCI
>> -	 * errors are rarely fatal so this is overkill. Instead in the future
>> -	 * we will inject the error event and let the guest recover the device
>> -	 * itself.
>> -	 */
>> +
>>   	if (needs_mediated_recovery(pdev))
>> -		goto out;
>> +		zpci_store_pci_error(pdev, ccdf);
>>   	driver = to_pci_driver(pdev->dev.driver);
>>   	if (driver && driver->err_handler && driver->err_handler->error_detected)
>>   		driver->err_handler->error_detected(pdev, pdev->error_state);
>> -out:
>> +
>>   	pci_dev_unlock(pdev);
>>   }
>>   
>> @@ -312,6 +329,7 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
>>   	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
>>   	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
>>   
>> +
>>   	if (!pdev)
> Nit, stray empty line.
>
>>   		goto no_pdev;
>>   
>> @@ -322,12 +340,13 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
>>   		break;
>>   	case 0x0040: /* Service Action or Error Recovery Failed */
>>   	case 0x003b:
>> -		zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
>> +		zpci_event_io_failure(pdev, pci_channel_io_perm_failure, ccdf);
>>   		break;
>>   	default: /* PCI function left in the error state attempt to recover */
>> -		ers_res = zpci_event_attempt_error_recovery(pdev);
>> +		ers_res = zpci_event_attempt_error_recovery(pdev, ccdf);
>>   		if (ers_res != PCI_ERS_RESULT_RECOVERED)
>> -			zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
>> +			zpci_event_io_failure(pdev, pci_channel_io_perm_failure,
>> +					ccdf);
>>   		break;
>>   	}
>>   	pci_dev_put(pdev);
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index a7bc23ce8483..2be37eab9279 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -168,6 +168,8 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   
>>   	zdev->mediated_recovery = false;
>>   
>> +	zpci_cleanup_pending_errors(zdev);
>> +
>>   	if (!vdev->vdev.kvm)
>>   		return;
>>   

