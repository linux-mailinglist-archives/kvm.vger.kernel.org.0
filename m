Return-Path: <kvm+bounces-37371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 369DAA29779
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B3A5165889
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C394F200109;
	Wed,  5 Feb 2025 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TODJWYqL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EB61FF7BF;
	Wed,  5 Feb 2025 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738776797; cv=none; b=N3a3zSDXmrQ7NxzBcaCMV5blFhr6tUksYPIPPnDo+u2Wr/VvUp+G/Rrlu3hbfQ6jUEVKcIUITaHNbMsd/frMggQN9OX4Bu0P2F2TTCPwQNZxkE/yIDMtT6v3ccIqrMTbjd34AHJQEJT6K+SxWOp/JFl0Ag8WDv1GaNLOShYGNTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738776797; c=relaxed/simple;
	bh=T1HhrsryGzwODoUQ9fNCs0Ksm6/XcpNK/+ke4uXeghA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nw0mCWFBYTGXFrcirkzBd8vrlORmgGhR8ojJuq7MAUCF+5+psbLSMg8gVlw/jPotzZV0YbCXYBIUufgslpHpwYJtH7o/JmdzG7k2hdhOorNUm850qckF5QM76stg/2jmNBXj3PXRI6nmw/e/2wKDXBZf4d5qPjlTVsUS9k4wEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TODJWYqL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515F1Pv6001471;
	Wed, 5 Feb 2025 17:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VhIL2Q
	sOAwmiBgC6s5Gn49BgY1lQByvKFiCPkH87Nz0=; b=TODJWYqLbmGQK0o7FnPRFN
	ZjCUel623b/Z9ifkfNzoKuNxe/v3R+txKo7pkSN5DzLLqKusK/N1r3Rl3ne2wf5B
	uh7oyRviq8n0aTSZqG9sR1onYl84ixS7czk+nG7zusS5CIIyRKgg9mQvT9P828AI
	QojYmr+45UaBZNCukvnIIjulM4vUgFdZKsTk/l4TV7KMcMu85gT6pm2AzkZSKyIG
	5g5n3bOU2m8NkpLGI9tFZ2z0yTVAzQoXwtSP9hrkL2fa5GNEpZRnMCeyb5Pi/Ept
	vqRoYLKz7XysSDIb7SMTgojpbgHjSo4KPXWicRIQ3YyPBmXNldPwUdfI2GzQq/Xw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ma8yrvj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 17:33:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 515FDkRN016288;
	Wed, 5 Feb 2025 17:33:08 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsj5ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 17:33:08 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 515HX7la25363088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Feb 2025 17:33:07 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 221D95805A;
	Wed,  5 Feb 2025 17:33:07 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BD6258054;
	Wed,  5 Feb 2025 17:33:06 +0000 (GMT)
Received: from [9.61.244.212] (unknown [9.61.244.212])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Feb 2025 17:33:06 +0000 (GMT)
Message-ID: <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
Date: Wed, 5 Feb 2025 12:33:05 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Rorie Reyes <rreyes@linux.ibm.com>
In-Reply-To: <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yg72WmWFNUiPffcNugSC08L_uvQh1QkY
X-Proofpoint-GUID: yg72WmWFNUiPffcNugSC08L_uvQh1QkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_06,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502050134


On 1/13/25 11:08 AM, Alexander Gordeev wrote:
> On Tue, Jan 07, 2025 at 01:36:45PM -0500, Rorie Reyes wrote:
>
> Hi Rorie, Antony,
>
>> Note that there are corresponding QEMU patches that will be shipped along
>> with this patch (see vfio-ap: Report vfio-ap configuration changes) that
>> will pick up the eventfd signal.
> How this patch is synchronized with the mentioned QEMU series?
> What is the series status, especially with the comment from Cédric Le Goater [1]?
>
> 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
>
> Thanks!

Hey Alex, sorry for the long delay. This patch is synchronized with the 
QEMU series by registering an event notifier handler to process AP 
configuration

change events. This is done by queuing the event and generating a CRW. 
The series status is currently going through a v2 RFC after implementing 
changes

requested by Cedric and Tony.

Let me know if there's anything else you're concerned with

Thanks!


