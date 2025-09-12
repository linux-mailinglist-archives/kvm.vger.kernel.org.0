Return-Path: <kvm+bounces-57426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 695C0B55572
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FCBC3A0FE4
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD1C326D53;
	Fri, 12 Sep 2025 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dFO7o4Jr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD69322DCB;
	Fri, 12 Sep 2025 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757697592; cv=none; b=L8XW86OYpN8ySek9Z0Odo+iyaDLiJxWnY226BhxwGpXukZbTJsJMn2WNIb+nMjEQlskCSkeufXyN/P25qFkZeinG4e9kQ5SoJtR7tcXBwZuJy8uQkwmCij2RF5+5IzT7w6L7V9enHoQENxhWgQO5OBda9vI+KptnofZhfhcnyPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757697592; c=relaxed/simple;
	bh=00HX9sqjgT4jmdcgIww/3ZL9wYzYI6eaFGABQQpNLAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqeeEU5Ms6rxDpCAEn4lvlzT+s/1iQoMWOLOf1LLNNBb3ZJ9rCZSLSZI3pJRcqI+V39eMGQ+fNkqNKI4ENc6GwjCgdtCsZFux/HAyOUK9KF0zYYGPds7XhsyT13LdTbX22P7jY1CEKjnfu5W+D4YUuHWYswTgAIpKdyV6Ea/Ao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dFO7o4Jr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CCE2qw021580;
	Fri, 12 Sep 2025 17:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fiIx/Z
	JNeAb9F68r3duUyfRYcjT0+OWFNHbeLAbi7oM=; b=dFO7o4JruHIHlPSUIXaFq6
	PDLOFnRzTANp7kD/SqrpS61okxJwEHsei7nxYoo88HpouH6shbieX/iCyq0BCMps
	K7ZaJQCOF1bGOCy4yGcqCOETHMYcKvx+769NHP47DiFHWsizdIlfvatWSX8qXH6N
	7V691pL7QbLzNHncmTGmrE+DVYF/w6Eedr6weJjIgf+PGPSeQaQxyVKOcbgZTGfO
	W0STz+cNLo356vXl++ycb7gC/2kw5idaenhZNd4MCFRt6nnt10uzUjRNLlOM8WmN
	WBnK8nXGxKm45C1H0fiJnGDx+nn4+kyet9y8iKAYBkR98RoimDhYLGyjj4I7HGQA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bctbh1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 17:19:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58CE39QB010618;
	Fri, 12 Sep 2025 17:19:45 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910snc064-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 17:19:45 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58CHJiwR34013516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 17:19:44 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DEA858045;
	Fri, 12 Sep 2025 17:19:44 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2841158050;
	Fri, 12 Sep 2025 17:19:43 +0000 (GMT)
Received: from [9.61.247.49] (unknown [9.61.247.49])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 17:19:43 +0000 (GMT)
Message-ID: <422d6b1d-d2be-4f78-a973-05a4316e62f3@linux.ibm.com>
Date: Fri, 12 Sep 2025 10:19:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
To: Benjamin Block <bblock@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
 <20250912122300.GA15517@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250912122300.GA15517@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfXyAVuyl4UwphV
 /rHE/UiZes6adQoZiInzo+nKaXL/cb/l9CcxXLMhxhkMAIrNkNwW0DaQ1gUnOVpDDpUDNx86Z2a
 Ujm12zsl80VSmOTEJhCVeRIZgzLDy85V/BHtxK16PkTOwRGvZlxaUTyes783wMVtQT01PW1si0e
 woIO8M3jkIBkBOs7Gda1tgZ2Ip54/E75DeNcfbpkXfentA3oDp+1Nzo6ovhje+a/9/40PUwmegy
 4ySY+hhAeHcKfMTAY6gRp0OI2ENkV8/15lQfirvqyX+ZdWqnrT0VSaChlybiyBEB1fuj/4hUcd2
 MCWLgIz6hiYLW/BJg1vwLOBNn/f9jO2Yt+S9GNlXelud8WkaG8GFURm3ebrS27hMovEXTWUALJf
 F4HHaw2w
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c45632 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=xhFoRCAMrjWxjyH1ee0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mJC4DuTeUBBLdGGLQoJxiGrhFaD83tmC
X-Proofpoint-ORIG-GUID: mJC4DuTeUBBLdGGLQoJxiGrhFaD83tmC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010


On 9/12/2025 5:23 AM, Benjamin Block wrote:
> On Thu, Sep 11, 2025 at 11:33:00AM -0700, Farhan Ali wrote:
>> On s390 systems, which use a machine level hypervisor, PCI devices are
>> always accessed through a form of PCI pass-through which fundamentally
>> operates on a per PCI function granularity. This is also reflected in the
>> s390 PCI hotplug driver which creates hotplug slots for individual PCI
>> functions. Its reset_slot() function, which is a wrapper for
>> zpci_hot_reset_device(), thus also resets individual functions.
>>
>> Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot object
>> to multifunction devices. This approach worked fine on s390 systems that
>> only exposed virtual functions as individual PCI domains to the operating
>> system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
>> s390 supports exposing the topology of multifunction PCI devices by
>> grouping them in a shared PCI domain. When attempting to reset a function
>> through the hotplug driver, the shared slot assignment causes the wrong
>> function to be reset instead of the intended one. It also leaks memory as
>> we do create a pci_slot object for the function, but don't correctly free
>> it in pci_slot_release().
>>
>> Add a flag for struct pci_slot to allow per function PCI slots for
>> functions managed through a hypervisor, which exposes individual PCI
>> functions while retaining the topology.
>>
>> Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> Stable tag?
> Reseting the wrong PCI function sounds bad enough.

That's a fair point. This is definitely broken for NETD devices 
(https://www.ibm.com/docs/en/linux-on-systems?topic=express-direct-mode). 
Will cc stable.

Thanks
Farhan


