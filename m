Return-Path: <kvm+bounces-59337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 176EEBB152E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 937D31946300
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DBC2D3217;
	Wed,  1 Oct 2025 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o65fI6Fr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01177208961;
	Wed,  1 Oct 2025 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759338736; cv=none; b=aYrTu9kWdddCqTH1+j+4NK2jClvNCY/4u4K+Ic3tNxVfXkt0qZa08/MFwZYp3WOgX/qQ2qHpxhhi/plN0IhYUY7MrNSRqz+9MQstqq/uafeVRJKFk7PYPoRWOjtLTeUcrm2qU89bMl/pFY2sBARli4ygraOtTLzbDd9GEAv2ZXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759338736; c=relaxed/simple;
	bh=34+af5IfF8veVSpDh8Qy62YfotRj59YHSDUjGOuN8fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvIyXKEOEvWRIljN00DcNsS7A7A/JZS7Zg8MPUztRt03lb6V7LL25EiTTpZT9l/zh7fnaGfG5URAZGj+fTqHnKAZTQQvV53AyxCx1pkn0yEMMCyO99xmBV+ksY/ZXhZlVwD0BWyT/0kLZoQ9+y9CXenz1bo41WU4rhGd8v7Er6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o65fI6Fr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591F8Goi031811;
	Wed, 1 Oct 2025 17:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+vB7oY
	6MwN17dyHDtLI+zfPEG2gHbxQn1oTiIwFJfPE=; b=o65fI6FrV9QJCbRTpnOymC
	NvVKAHoMM1plcGdaTDsyKb3df106qog05jSXN8ILRJtPYEUyj4hAv58ThKErCIMk
	AR2ZFji2OppeUS29MAxNViHfRDXBNGhYZP+xTxCO91NzwL/xa5CB44gk7GgWsffd
	A7rMUch/zCH2tblCXBWHWYvHsUWU4I2FTWXQh5fQ2nja4Tjfy8V/x2KeGhIZl26c
	hyhiHQswex+T5bAroGUU0X3fpkXcyN+L9uUjC2cSHyysASUFnBnQJGlz5trVizIK
	QilqvFX7liP5pGUM8b6ryxe7p6L5n9498771/072gjoaW8mynnm9XC4vJ8lDQceg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5br0bq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 17:12:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591ECEpN024198;
	Wed, 1 Oct 2025 17:12:05 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy19mwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 17:12:05 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591HC42j32244350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 17:12:04 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C807E58052;
	Wed,  1 Oct 2025 17:12:04 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 082655805A;
	Wed,  1 Oct 2025 17:12:04 +0000 (GMT)
Received: from [9.61.247.182] (unknown [9.61.247.182])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Oct 2025 17:12:03 +0000 (GMT)
Message-ID: <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
Date: Wed, 1 Oct 2025 10:12:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
To: Benjamin Block <bblock@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20251001151543.GB408411@p1gen4-pw042f0m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDIxNCBTYWx0ZWRfX/fTUB/Q0no6h
 6GMzLMz+Fy/SliM4qS9S+RJRnuOfcKiqlbNCafUyG0QB4GgKuDU142iYc4BRIvq1hZfP7xt/a7k
 CrVRVOJMimT1vkFA1mmE/nweTgApUdd/wpr96cgx1WRaeTsoRWX/ZAEiW2hetOl0H40s3hYPFyQ
 1PL9Q0Rvur3LjU4PyuooKfmNzrX69ekahGsqPHf2rnd2hXDube+jLD7OFCxKhB2cAzhfhbBzDTv
 /GIx1FKl1iOPH+DMUKK1Vy++VfJdVp31R3e8Y/tr42y/WXdNFNHH/wDhm+qcJf3Clf3U6fzkmEb
 GOEZM33fRM1YZQcYZkvA+a1ZZvk4zw1+i+O6NzaEgAtLsbsIGqt4ByfScx1rrF82HrOPB+7jpWT
 f7EBAAAggmsUeTHvA1A7RkvGgtROQA==
X-Proofpoint-GUID: 1McfUhojab5bfGNOEFYPJnj_Ovr4WebU
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=68dd60e6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=T5_8E-leH3MX88Le9nUA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 1McfUhojab5bfGNOEFYPJnj_Ovr4WebU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509260214


On 10/1/2025 8:15 AM, Benjamin Block wrote:
> On Wed, Sep 24, 2025 at 10:16:19AM -0700, Farhan Ali wrote:
>> @@ -1792,6 +1798,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>>   int pci_save_state(struct pci_dev *dev)
>>   {
>>   	int i;
>> +	u32 val;
>> +
>> +	pci_read_config_dword(dev, PCI_COMMAND, &val);
>> +	if (PCI_POSSIBLE_ERROR(val)) {
>> +		pci_warn(dev, "Device config space inaccessible, will only be partially restored\n");
>> +		return -EIO;
> Should it set `dev->state_saved` to `false`, to be on the save side?
> Not sure whether we run a risk of restoring an old, outdated state otherwise.

AFAIU if the state_saved flag was set to true then any state that we 
have saved should be valid and should be okay to be restored from. We 
just want to avoid saving any invalid data.


>
>> +	}
>> +
>>   	/* XXX: 100% dword access ok here? */
>>   	for (i = 0; i < 16; i++) {
>>   		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
>> @@ -1854,6 +1868,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
>>   
>>   static void pci_restore_config_space(struct pci_dev *pdev)
>>   {
>> +	if (!pdev->state_saved) {
>> +		pci_warn(pdev, "No saved config space, restoring BARs\n");
>> +		pci_restore_bars(pdev);
>> +		pci_write_config_word(pdev, PCI_COMMAND,
>> +				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
> Is this really something that ought to be universally enabled? I thought this
> depends on whether attached resources are IO and/or MEM?
>
> 	int pci_enable_resources(struct pci_dev *dev, int mask)
> 	{
> 		...
> 		pci_dev_for_each_resource(dev, r, i) {
> 			...
> 			if (r->flags & IORESOURCE_IO)
> 				cmd |= PCI_COMMAND_IO;
> 			if (r->flags & IORESOURCE_MEM)
> 				cmd |= PCI_COMMAND_MEMORY;
> 		}
> 		...
> 	}
>
> Also IIRC, especially on s390, we never have IO resources?
>
> 	int zpci_setup_bus_resources(struct zpci_dev *zdev)
> 	{
> 		...
> 		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> 			...
> 			/* only MMIO is supported */
> 			flags = IORESOURCE_MEM;
> 			if (zdev->bars[i].val & 8)
> 				flags |= IORESOURCE_PREFETCH;
> 			if (zdev->bars[i].val & 4)
> 				flags |= IORESOURCE_MEM_64;
> 			...
> 		}
> 		...
> 	}
>
> So I guess this would have to have some form of the same logic as in
> `pci_enable_resources()`, after restoring the BARs.
>
> Or am I missing something?

As per my understanding of the spec, setting both I/O Space and Memory 
Space should be safe. The spec also mentions if a function doesn't 
support IO/Memory space access it could hardwire the bit to zero. We 
could add the logic to iterate through all the resources and set the 
bits accordingly, but in this case trying a best effort restoration it 
should be fine?

Also I didn't see any issues testing on s390x with the NVMe, RoCE and 
NETD devices, but I could have missed something.

Thanks

Farhan


>
>> +		return;
>> +	}

