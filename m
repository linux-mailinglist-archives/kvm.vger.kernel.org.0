Return-Path: <kvm+bounces-59195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E22BFBAE20C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EC6F1892D2C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF2130AD1F;
	Tue, 30 Sep 2025 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pFZuodD1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549961BF58;
	Tue, 30 Sep 2025 17:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759251874; cv=none; b=Amy1da0+y3LSYh8rP/qqbABx1Ai6sx11NT9NZPyE0fckoLyz8495vcuTxu65omk+VoIXphG1zAASlRscjZuDn7101CXUQ732K5ujbVfdHm8+oxFAY2Ob1rYZYGZrj7HENwygZKgM9Y4RQLqncP6JKhwPCQCVjkhDSb7pSI6hnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759251874; c=relaxed/simple;
	bh=oLDwMMBM2SycPVojx4qBlYhPFKtLQeL0zXmZF2KWzeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtwjjorwf8IblQhgMQuuOiFLGf62GQQXadrCexpus/fS5nrlgi+Trt9rBGw3pveuepfBPzxdktvMGruq4bOXhl3taac+8hH++86sx531+qVVeoaRcvReQ8uin1b20hlsSAO+Dm8FsfVkFnHjC2k6MHdRuJXIOObnfDx12QNciSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pFZuodD1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UDe8Q6005411;
	Tue, 30 Sep 2025 17:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=naVZF4
	LCJN0Pw0nONp81AmhWWeyVPtnfJ+yezrIe+hY=; b=pFZuodD1zIIZTW8k7UCBKn
	sUvYBGCvUIjrQtD0Eclmi3kd0xDClYJErJU/vL5thx+LoDZiHoFAZ0lVNi1Si9kJ
	NvACKSiXv648/OnKCNLnxekcip4raZ7r5c3glHWVtNHqbfUt7GFifZZtsaoveqyG
	aneVW4fLS2C6S/Kmi1POk5GwUG3Zt+g6Ald67+bWQJD5A8Pn3sWYEfzKxlNxVF6y
	QsDaj7SRvu6RlDKum0wU0/43jUadjfdQpZOKXCeomwzhmPUS9JTbO6XbhrmtgrCy
	xiUCbWhF257Yt3CnQS7C17sKXnnTLhmgD/RJJUZR9gyzxg3X936bU+531kaKDNrQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7kuaf94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 17:04:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58UELKhY024198;
	Tue, 30 Sep 2025 17:04:27 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy147eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 17:04:27 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UH4QlP31982198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 17:04:26 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56A0458057;
	Tue, 30 Sep 2025 17:04:26 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95D0C58059;
	Tue, 30 Sep 2025 17:04:25 +0000 (GMT)
Received: from [9.61.249.240] (unknown [9.61.249.240])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Sep 2025 17:04:25 +0000 (GMT)
Message-ID: <1f5abbae-7a7d-402d-ac6e-029cdc3b0d63@linux.ibm.com>
Date: Tue, 30 Sep 2025 10:04:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/10] PCI: Add additional checks for flr reset
To: Benjamin Block <bblock@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-3-alifm@linux.ibm.com>
 <20250930100321.GB15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250930100321.GB15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68dc0d9c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=BMGjUjUgpuDZBGNCpE8A:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: PQUxSMRTqZxFM1SYDVuw5HCVqKk4fY3_
X-Proofpoint-ORIG-GUID: PQUxSMRTqZxFM1SYDVuw5HCVqKk4fY3_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX28mtSnEoDnxl
 KxFCtQ476SvG3rWv5OYoACfPQnKSIsfeesLQE+GhAvPEYCGnanMnT6ABTjG4cMzIxjVpOjF1fV+
 8s2evQfOFS5PB0JuxofJ8lG9K29XWhhQMd/SEyiQKIemwlhUgLscNPhCprNXC6eadRac1lse/9w
 JOAyq02QFx7mCJLt7hKR7bvrQGCPQqDN1Lxpi5DnzA3gQWvhgLU8bmSnQOysQM9JcnjahyYzx5u
 sPvC1ChWZ6gxJSIPQfSdNVVVdQSddlDCblA+54qytIxNNCSlSTJPY2UDZYAknHb5FzV4BVJQQM0
 THiQ3BPpu2ntAi1El7Y0O+tHd/OZ1ZJWxKPouKEcCpCLwdOUiJsz1Rgni2T/ggLCq7edjIGfAnT
 bh0K0MsdvY3UcQpXNQ7AqCskNP5kGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025


On 9/30/2025 3:03 AM, Benjamin Block wrote:
> On Wed, Sep 24, 2025 at 10:16:20AM -0700, Farhan Ali wrote:
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index a3d93d1baee7..327fefc6a1eb 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -4576,12 +4576,19 @@ EXPORT_SYMBOL_GPL(pcie_flr);
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
>> +	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg)) {
>> +		pci_warn(dev, "Device unable to do an FLR\n");
>> +		return -ENOTTY;
>> +	}
> Just thinking out loud, not sure whether it make sense, but since you already
> read an up-to-date value from the config space, would it make sense to
> pull the check above `dev->devcap & PCI_EXP_DEVCAP_FLR` below this read, and
> check on the just read `reg`?

My thinking was we could exit early if the device never had FLR 
capability (and so was not cached in devcap). This way we avoid an extra 
PCI read.


>
> Also wondering whether it makes sense to stable-tag this? We've recently seen
> "unpleasant" recovery attempts that look like this in the kernel logs:
>
>      [  663.330053] vfio-pci 0007:00:00.1: timed out waiting for pending transaction; performing function level reset anyway
>      [  664.730051] vfio-pci 0007:00:00.1: not ready 1023ms after FLR; waiting
>      [  665.830023] vfio-pci 0007:00:00.1: not ready 2047ms after FLR; waiting
>      [  667.910023] vfio-pci 0007:00:00.1: not ready 4095ms after FLR; waiting
>      [  672.070022] vfio-pci 0007:00:00.1: not ready 8191ms after FLR; waiting
>      [  680.550025] vfio-pci 0007:00:00.1: not ready 16383ms after FLR; waiting
>      [  697.190023] vfio-pci 0007:00:00.1: not ready 32767ms after FLR; waiting
>      [  730.470021] vfio-pci 0007:00:00.1: not ready 65535ms after FLR; giving up
>
> The VF here was already dead in the water at that point, so I suspect
> `pci_read_config_dword()` might have failed, and so this check would have
> failed, and we wouldn't have "wasted" the minute waiting for a FLR that was
> never going to happen anyway.
I think maybe we could? I don't think this patch fixes anything that's 
"broken" but rather improves the behavior to escalate to other reset 
method if the device is already in a bad state. I will cc stable.

Thanks

Farhan


