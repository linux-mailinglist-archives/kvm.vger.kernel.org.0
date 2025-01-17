Return-Path: <kvm+bounces-35773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFE1A14F68
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93C023A299D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7301FF61A;
	Fri, 17 Jan 2025 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="boK+Cd72"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5293E1FF1C7;
	Fri, 17 Jan 2025 12:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737117733; cv=none; b=IULMl8Ei5b4JV+Ey6yIb4/3uBmjlMZVYOQNUqVCcClGlwg3h9ufe93LAwZWZNbFmQjN2lTxQ0HRFctSWDTmNrDIE6R0iS/cdUPiPzp2Ew8FkakZmJOe8fDN49ahefD5p6fBTJ5kQa4XfR6xZAWrOH6T7W4nk5u/WD2czmJMxWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737117733; c=relaxed/simple;
	bh=4yH8LGXOQppH0h6FR5miXCsRMIVxDu3yPBokh1FntIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ktHc1lno4Z5LjcRI82rCkh9UQ1oUC4SZDd1hHDkluNKEmk7sS927HEXHimg2Th7LKRxp3jc0nUNsQyTzNbcNuaYB2Nu4TuFZlhxsmn4QfuSTtnIlKIC2yPEXJTPSnRXkg9jDIegDX/ziXK+SXxkK5OEXBxGZQS4z6PRlO74zi3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=boK+Cd72; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H85gib000511;
	Fri, 17 Jan 2025 12:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=slmim3
	/EVblJ7Nj7b+GnMu8L1UljDsW47itiMWbN6WA=; b=boK+Cd72Kos6b2GxmLPS2H
	COT4xBohNCZHgLlTr0Z7JfEEdTUNY9OW1uOIGbzYsBWj7DHgM42KRBffGXpL07i3
	QugsWWiijqYm8dc3hKjgJZmBhWdnJrhNuy1XytpMHi5aSaR31km2SPuLHnhQbrDD
	onYQy6r8/G8maX21H+TarZQ7VjGDjLcvD8tJ1ofvpH315cLAR93mPG8RQXcVpuq7
	HZszdbckFDHvZwjtuo1nxkqiC7hbUBujvlHtCYJOZWeagRBTWR57rA9lyKmfzKvV
	vnJ9JTzp4PrwzBo4EAOTmJBefPV6rrMJ/MCHiiOwZrTLS2fANb+vdv3gzeN3f6Gg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3h620-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:42:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HB0ONt001089;
	Fri, 17 Jan 2025 12:42:08 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456kanmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:42:08 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HCg6Uw63570270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 12:42:06 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FEDA5805B;
	Fri, 17 Jan 2025 12:42:06 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4138C58058;
	Fri, 17 Jan 2025 12:42:05 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 12:42:05 +0000 (GMT)
Message-ID: <99bc2df0-ffd2-4aaa-b658-de5ac3a77b40@linux.ibm.com>
Date: Fri, 17 Jan 2025 07:42:04 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: freude@linux.ibm.com
Cc: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        pasic@linux.ibm.com, jjherne@linux.ibm.com, alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <45d553cd050334029a6d768dc6639433@linux.ibm.com>
 <d1b36877-14ea-4110-84c1-941defc8d3a2@linux.ibm.com>
 <105ff0df576ac86c1cd2edd4e1a6478c@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <105ff0df576ac86c1cd2edd4e1a6478c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EPHsWAj3XFcK4PFZ8T_OumlNyaUKoIxz
X-Proofpoint-GUID: EPHsWAj3XFcK4PFZ8T_OumlNyaUKoIxz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170100




On 1/17/25 3:30 AM, Harald Freudenberger wrote:
> On 2025-01-16 17:46, Anthony Krowiak wrote:
>>>
>>> Rorie, this is to inform listeners on the host of the guest.
>>> The guest itself already sees this "inside" with uevents triggered
>>> by the AP bus code.
>>>
>>> Do you have a consumer for these events?
>>
>> There is a series of QEMU patches that register a notification 
>> handler for this
>> event. When that handler gets called, it generates and queues a CRW 
>> to the guest
>> indicating there is event information pending which will cause the AP 
>> bus driver
>> to get notified of the AP configuration change via its ap_bus_cfg_chg
>> notifier call.
>>
>> The QEMU series can be seen at:
>> https://lore.kernel.org/qemu-devel/7171c479-5cb4-4748-ba37-da4cf2fac35b@linux.ibm.com/T/ 
>>
>>
>>
>> Kind regards,
>> A Krowiak
>
> Ok, so this way the AP bus of the guest finally get's it's config 
> change callback invoked :-)

Yes, and it happens pretty quickly; at least in the test environment.



