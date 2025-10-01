Return-Path: <kvm+bounces-59363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAC0BB16FD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 20:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EA361920497
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 18:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6F22D3EF1;
	Wed,  1 Oct 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ps7x5FCI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466FE258EF0;
	Wed,  1 Oct 2025 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341720; cv=none; b=XuxPebwFLkWlqzvblWhhTzibftXflV7XvP3crWMLKV2V1Bjfr681dSR086IkcHd3eAUHS/32uu+Ix7Saq/raUlNcB6rxB5vqdw6OWKhW3Wh4dKzmBCFM8SxlzOTd+RAbcImidYr4BiyBPfh5bv/CBTC2j+Pr7yjgZMZk/2WUfwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341720; c=relaxed/simple;
	bh=OZTt/xPPJXX+7TnJZBoKo37mlN/sUWHl7tztDTk/5Iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpMBUNo0l7d2yLnF+fm6M8dW2Qx6AJN+VdrK72/SDvooIASctYsW87qoL48AlTA2Ude7UpfQupPaSG7hmkdRFaqLXfQl8t4dErTOvn/j21K/UZOM2xh54yOws5aG7dAf5cMEcgFhcNWXn4W9GTB5ZsADMFbZtpkCZY98eEWeF0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ps7x5FCI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591AauF2018941;
	Wed, 1 Oct 2025 18:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YuggLZ
	X5iMXvtB6YQ9ETrPfHB3UZ2uFjZQlbGISsB5A=; b=ps7x5FCIAm81ZrYqN1SCpX
	Fwu/yJWw6zILHk/+JiTKeK8NUHWJt07e5X9NQQBmw0wbqMrdVIuSYexghvc8QUMj
	YbtpliRWpQJ/3nJbXbvKxjNnDTMz2hNO57HMsVF1BruUiLa6SDC3I3jnQvigiyL1
	BjG8JW8bTZgmvBNkbmS1aefDL0aSrz46EDkwB3f7AYrSN18fD/LOc6sxP5Swrq4F
	5nxq7dUis/Ta67hLi0rtaZ/QA/YynLMHZVZTTHSPUV/SosWB24IWdNhqJshub4Ik
	LYWFDracWf+KT78WTQqhGS2yy5w7HUSjOK7NcA7Qe3imaGujcLPzbRknwn4P1Yag
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n81262-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:01:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591GwL6P024151;
	Wed, 1 Oct 2025 18:01:51 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy19v5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 18:01:51 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591I1cSF24445610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 18:01:38 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A22A458067;
	Wed,  1 Oct 2025 18:01:49 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8849F5805F;
	Wed,  1 Oct 2025 18:01:48 +0000 (GMT)
Received: from [9.61.247.182] (unknown [9.61.247.182])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Oct 2025 18:01:48 +0000 (GMT)
Message-ID: <a4c448b2-6909-4efb-b41d-396ea8ececd3@linux.ibm.com>
Date: Wed, 1 Oct 2025 11:01:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific resource/bus
 address translation
To: Benjamin Block <bblock@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-5-alifm@linux.ibm.com>
 <2d049d60868c0f61e53e70a73881f8674368537a.camel@linux.ibm.com>
 <20251001160415.GC408411@p1gen4-pw042f0m>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20251001160415.GC408411@p1gen4-pw042f0m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OjM4jqVCkUZIXqsN743-_l4_-nJXb7Th
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX87MJU4BoLddX
 N6TC4yhszZJHvAXE2CA9JgcyUio9K1GzaP6XX8BB7rnwwkV1oNm/YXQ2+ZdTI5uxuDDUcjgEfi7
 eOYEHSMR4FZ8ufZnTfcSc5hhHLYLoXXSUP5RpHWk5+8fIZ40kbQCJpsb1OHL0MkVauSI7BdyuP0
 BN/nLFI012nbswP4Sqd2nq1VyMsztm+9P+yzptR76G/oww93PGL0ZE2dwndre1U9h8uslkvAOOy
 GEcjMUQE+suRuQn/aGMm/yzoEVWNY5laQLO/U3I6zndQzuSl/+YUFa2rlss7A0rzV9Wp2zr8bnp
 JduLWYpJdI3CtRA6AgqH8MDodxKwbAB8ynHUKgj9x2R7smp+QehAfqgtf7ihxHvm2E36P0YxxbY
 10halkeAeAuNIkzh1kwVp+o1sZ2FcQ==
X-Proofpoint-GUID: OjM4jqVCkUZIXqsN743-_l4_-nJXb7Th
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68dd6c91 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=q6S6Oyswo6crDdrvCj4A:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025


On 10/1/2025 9:04 AM, Benjamin Block wrote:
> On Thu, Sep 25, 2025 at 12:54:07PM +0200, Niklas Schnelle wrote:
>> On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
>>> +void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
>>> +			     struct resource *res)
>>> +{
>>> +	struct zpci_bus *zbus = bus->sysdata;
>>> +	struct zpci_bar_struct *zbar;
>>> +	struct zpci_dev *zdev;
>>> +
>>> +	region->start = res->start;
>>> +	region->end = res->end;
>> When we don't find a BAR matching the resource this would become the
>> region used. I'm not sure what a better value would be if we don't find
>> a match though and that should hopefully not happen in sensible uses.
>> Also this would keep the existing behavior so seems fine.
> I was wondering the same things, but I guess it matches what happens elsewhere
> as well, if no match is found
>
> 	void __weak pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
> 				     struct resource *res)
> 	{
> 		...
> 		resource_size_t offset = 0;
>
> 		resource_list_for_each_entry(window, &bridge->windows) {
> 			if (resource_contains(window->res, res)) {
> 				offset = window->offset;
> 				break;
> 			}
> 		}
>
> 		region->start = res->start - offset;
> 		region->end = res->end - offset;
> 	}
>
> So I guess that is fine.
>
> The thing I'm also unclear on is whether it is OK to "throw out" this whole
> logic about `resource_contains(window->res, res)` here and
> `region_contains(&bus_region, region)` in the other original function?
> I mean, the original function don't search for perfect matches, but also
> matches where are contained in a given resource/region, which is different
> from what we do here. Are we OK with not doing that at all?

I had thought about doing the range check, similar to 
resource_contains/region_contains rather than doing exact checks. But I 
think the way we expose the topology of the devices, the offset in our 
(s390x) case is zero. So I thought it should be safe to just doing exact 
match and might help us catch any issues if its not exact.

Thanks

Farhan


