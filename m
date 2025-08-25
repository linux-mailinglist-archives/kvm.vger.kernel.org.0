Return-Path: <kvm+bounces-55698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC222B34F0B
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B9995E30C1
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF5929A9C3;
	Mon, 25 Aug 2025 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fDPPv/8n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A255271475;
	Mon, 25 Aug 2025 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756160897; cv=none; b=VXW16JGPkesDUJyObo+CH10OMq6GfbM2jPpIAXFWZfDwyAcLDPgm4tz081TJGm76JQcykkJ5jqDgS+QMk3edB7BUVF7cKsHQCdyohiMSe4HNgTW7h/W1/pqg4uiAZl3RB+b3ZQb8aiJVibGnfWlZuJtDO6pFAfqaInNtZzXnU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756160897; c=relaxed/simple;
	bh=dHdmUqC4IhVQw7Rp7lNJUpN25GaUL62rSFvt6vE7+Tk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsUrJHYluLo3Lj08cWcFOmQpVnl2R74LxBDM8nbqG1bf3nl2HXFvBsxj0Qi5/WSVZjLz/q4PfvaR+TOCVSASGdL8H9vELm045rpwGNhjVOROz35xdESs/IXGeMtHJvFjumN2Ofjvxbv2d0hSy51CmG/m/YFj38L81FJ7mvNlUnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fDPPv/8n; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PLVH40022179;
	Mon, 25 Aug 2025 22:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Mo4+QD
	lHWSnmxXYzX7QnCci4cOeWYhiTqz+K6xpHKXQ=; b=fDPPv/8nZvA2ie2Ci8A8LU
	0DECjxl8szLRT6lHthL1NZ2g5UVNSygF3hLXwh7ZPo3Uq+KM01ItuENxshPwiG2M
	2sKYDsjpqMD6ervwx11UoaLBkfGgnhnE3ynumXbWbp9yYDeo5c7/4kvFH1E9WAvf
	HQonI3sdr3U+A4XlFZaaWZUJRV/N6zP2W2t3SbhdDdu5jiYgrzMEeZ5dTo1FObfl
	bJDte4REdfaw3TSDMhIqnpSdhXjsrVU5D5oc00YNkeThbaaVHKmjHc3nSPCA11uh
	ezz93A4xkIzVtlls3/bDp/7iCCuF/uCzWETt/218gGDOaIH3u1gDVb/cef8lyytA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hpuasb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 22:28:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PKTjV2007813;
	Mon, 25 Aug 2025 22:28:10 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu876h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 22:28:10 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PMS9r133358394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 22:28:09 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C8875803F;
	Mon, 25 Aug 2025 22:28:09 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FF595804E;
	Mon, 25 Aug 2025 22:28:08 +0000 (GMT)
Received: from [9.61.255.253] (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 22:28:08 +0000 (GMT)
Message-ID: <042deeb6-864d-4f66-9031-4a4ba3214c94@linux.ibm.com>
Date: Mon, 25 Aug 2025 15:28:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] PCI: Add additional checks for flr and pm reset
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, helgaas@kernel.org,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250825171226.1602-1-alifm@linux.ibm.com>
 <20250825171226.1602-3-alifm@linux.ibm.com>
 <20250825155420.2ace4847.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250825155420.2ace4847.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX3YeFTJVTF32e
 5I5kHwgcC5/DeuTqE5KPvrvmp4qFxhd5cp3ZEVdqraLCslxFyfbENZMbgXUoVdXtEC+1N+s+owK
 KeMwmJTiTtaggCBUAKdSRinllT49TcSDN+gnZEj7oLD5PopKmw+6dSuSK7UEvq9MB3KNVsg3xZn
 tqOvDoeXkRFOq3J2Kn6NyKcGuF3Jz8osZ2vDM5ixJbcfmitXIRMBsRqyugEjut/RUPfqdgWMm7R
 yEBI2AFD1aVPIeTcdzMtrI3HZ+wN+G72jxZ2LYqeEOFR9oea3b83Dl6KzJ17pI6dz7ZCzgstJun
 167Bg8EXcgHt4mpSi5moFSCue+2+GnKjqCuVgjQ8B9F7Wb9Q6x+OCLWS1bmupMbvRbI+q+nIekV
 xym560Wq
X-Proofpoint-ORIG-GUID: L8AFYC6BMBp_9s5H0IZqkQdYk7J4m2TH
X-Proofpoint-GUID: L8AFYC6BMBp_9s5H0IZqkQdYk7J4m2TH
X-Authority-Analysis: v=2.4 cv=Ndbm13D4 c=1 sm=1 tr=0 ts=68ace37b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=P-IC7800AAAA:8 a=VnNF1IyMAAAA:8
 a=foT7BmcOsW2tIiZqzTwA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_10,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021


On 8/25/2025 2:54 PM, Alex Williamson wrote:
> On Mon, 25 Aug 2025 10:12:19 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> If a device is in an error state, then any reads of device registers can
>> return error value. Add addtional checks to validate if a device is in an
>> error state before doing an flr or pm reset.
> I think the thing we see in practice for a device that's wedged and
> returning -1 from config space is that the FLR will timeout waiting for
> a pending transaction.  So this should fix that, but should we log
> something?

I guess it makes sense to add a warn log.


>
> I'm assuming AF FLR is not needed here because we don't cache the
> offset and therefore won't find the capability when we search the chain
> for it.

Yes, based on my understanding of the when we search for the capability 
offset, we would return 0 if the config space read returns a -1 
(https://elixir.bootlin.com/linux/v6.16.3/source/drivers/pci/pci.c#L441).

>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/pci/pci.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 0dd95d782022..a07bdb287cf3 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -4560,12 +4560,17 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>>    */
>>   int pcie_reset_flr(struct pci_dev *dev, bool probe)
>>   {
>> +	u32 reg;
>> +
>>   	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>>   		return -ENOTTY;
>>   
>>   	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
>>   		return -ENOTTY;
>>   
>> +	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg))
>> +		return -ENOTTY;
>> +
>>   	if (probe)
>>   		return 0;
>>   
>> @@ -4640,6 +4645,8 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
>>   		return -ENOTTY;
>>   
>>   	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &csr);
>> +	if (PCI_POSSIBLE_ERROR(csr))
>> +		return -ENOTTY;
> Doesn't this turn out to be redundant to the test below?

Yup, I guess i was being extra cautious. Will remove the check.

Thanks
Farhan

>>   	if (csr & PCI_PM_CTRL_NO_SOFT_RESET)
>>   		return -ENOTTY;
>>   
> Thanks,
> Alex
>

