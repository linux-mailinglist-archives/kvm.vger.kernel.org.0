Return-Path: <kvm+bounces-57784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82EFAB5A1C0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E0AB4851DC
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B132E8B85;
	Tue, 16 Sep 2025 20:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qalxXyue"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3912356B9;
	Tue, 16 Sep 2025 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758052856; cv=none; b=nGVqfiMYy6eMXw4qhheqAdC2uKrMjql1RYMLK1CqVcaX2YhRjTRi0sHahwPHD7V+YL7LEnbpJyQSyr1fXiKxS0ikY/Vnb/NRwxjlJgLZ0allFEB5YlTWS24wG/9PaM7g3wnhrmNgtCLzt48VDPUnh/nvGRVXpOmzn4otxpjsuUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758052856; c=relaxed/simple;
	bh=zXiOIHy9ejwvJSdfc0MFDmV+apcwnc62XAPntiwORCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XXrYk2U4eO4A3VGg3XzLs9LBkqFNb21Ng9a3R2DFKWF6oVxkDVteBzR0gTRbmTZK8I/szlZPC+i86niRZttBfvHxQetSL3uLx1ISTUedvbuziMF4S0vTPr3ikwMtpLTnC8FquTrsNOZ5MV9N+mzyvgKbadzR5thL69gCONzqpyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qalxXyue; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GCdVDu003190;
	Tue, 16 Sep 2025 20:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pxX+MR
	PFQ/scwamhTyYekj06Xy9jwdu0NhB/orGkvK0=; b=qalxXyue805dp8sROeXMEv
	feA9/IMHLIo0dnUctyHVgKkmbXlL921E/qMtMm8iITBJioeXkRFaP+7cMF4t9Lii
	hldMPJ22mSIpJE0Nb5GBr2Z/X3y0V3KNV6dt7L90xKy1PEVcUsywVZ6sWPXRqzOV
	dhetIeWkbtyMEaDpHY4CD3B+XZWjgcCQ6RlkHEe8NF6uA5SkSm/SViyMUCBxDht1
	64EMmIqFteOVsLzsfFQeiLjBEana64IhysAGt/uJ4Toar9XKygA9cqTMR9YLMhCX
	ExHGw+qXwcnVL8AQJszfAV621BJ7KSdilLayxDy8mhoRTRnsIrJEpFRlvvuHD7Fw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tjmc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 20:00:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GHkGYh027308;
	Tue, 16 Sep 2025 20:00:37 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men5nxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 20:00:37 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GK0Z8i30867826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 20:00:35 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B90805804B;
	Tue, 16 Sep 2025 20:00:35 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9AD58065;
	Tue, 16 Sep 2025 20:00:34 +0000 (GMT)
Received: from [9.61.248.85] (unknown [9.61.248.85])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 20:00:34 +0000 (GMT)
Message-ID: <d6655c44-ca97-4527-8788-94be2644c049@linux.ibm.com>
Date: Tue, 16 Sep 2025 13:00:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] PCI: Avoid saving error values for config space
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250916180958.GA1797871@bhelgaas>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250916180958.GA1797871@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c9c1e5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=mDscfjHxmXLP5G7XJkoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: t1caYAftEQESRlrEzyWB9245QaQMwIUY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX7uy6lqZco1w+
 t1kZYAYu0+hYrVc26mwhBiCdLOhuiK5LfTEc/F9t0xXll+UUqB2yCEiqdOqVBddVHMheJiusVpn
 TmIQkJ2hYe2H6xJeghrRYTppvt2eDDNKJu/hqlvN6ih7oYvnap5ZqGgBwkMAj6KgOU3tUToDBJk
 j16XLwtC1aAtP+N9MSoALqvEO7UZJd0MRro+703/AUDws13NyUmkN2nnNMJ1wWbhc9EYPc2+RsO
 ySt7E3jAtzj80gYOwsQX+I7am3ColXMkmr7dqbxpYPaHjpFw+la8afr6Drgn2vlpiYxXlpT89G3
 cSV37zi+uCgtMyEfJohd/V9NNMQZ+KJKeoiaCWpJQMYEGwyUbDGMp5C4e+wApznKiiMazPJ9R0P
 yUhslYd1
X-Proofpoint-GUID: t1caYAftEQESRlrEzyWB9245QaQMwIUY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001


On 9/16/2025 11:09 AM, Bjorn Helgaas wrote:
> On Thu, Sep 11, 2025 at 11:32:58AM -0700, Farhan Ali wrote:
>> The current reset process saves the device's config space state before
>> reset and restores it afterward. However, when a device is in an error
>> state before reset, config space reads may return error values instead of
>> valid data. This results in saving corrupted values that get written back
>> to the device during state restoration.
>>
>> Avoid saving the state of the config space when the device is in error.
>> While restoring we only restorei the state that can be restored through
>> kernel data such as BARs or doesn't depend on the saved state.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
>>   drivers/pci/pcie/aer.c |  5 +++++
>>   drivers/pci/pcie/dpc.c |  5 +++++
>>   drivers/pci/pcie/ptm.c |  5 +++++
>>   drivers/pci/tph.c      |  5 +++++
>>   drivers/pci/vc.c       |  5 +++++
>>   6 files changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index b0f4d98036cd..4b67d22faf0a 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>>   	struct pci_cap_saved_state *save_state;
>>   	u16 *cap;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring pcie state, no saved state");
>> +		return;
Hi Bjorn

Thanks for taking a look.

> Seems like a lot of messages.  If we want to warn about this, why
> don't we do it once in pci_restore_state()?

I thought providing messages about which state is not restored would be 
better and meaningful as we try to restore some of the state. But if the 
preference is to just have a single warn message in pci_restore_state 
then I can update it. (would also like to hear if Alex has any 
objections to that)

>
> I guess you're making some judgment about what things can be restored
> even when !dev->state_saved.  That seems kind of hard to maintain in
> the future as other capabilities are added.
>
> Also seems sort of questionable if we restore partial state and keep
> using the device as if all is well.  Won't the device be in some kind
> of inconsistent, unpredictable state then?
>
> Bjorn

I tried to avoid restoring state that explicitly needed to save the 
state. For some of the other capabilities, that didn't explicitly store 
the state, I tried to keep the same behavior. This is based on the 
discussion with Alex 
(https://lore.kernel.org/all/20250826094845.517e0fa7.alex.williamson@redhat.com/). 
Also AFAIU currently the dev->state_saved is set to true as long as we 
save the first 64 bytes of config space (pci_save_state), so we could 
for example fail to save the PCIe state, but while restoring can 
continue to restore other capabilities like pasid.

At the very least I would like to avoid corrupting the BAR registers and 
restore msix (arch_restore_msi_irqs) to get devices into a functional 
state after a reset. I am open to suggestions on how we can do this.

Would also like to get your feedback on patch 3 and the approach there 
of having a new flag in struct pci_slot.

Thanks
Farhan


