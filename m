Return-Path: <kvm+bounces-37374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA1EA297E9
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F388C1886FBE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4794C1FCFF1;
	Wed,  5 Feb 2025 17:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EOHY/ok9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C791519AD;
	Wed,  5 Feb 2025 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777683; cv=none; b=iY3SRomYppIr2Bgv426ptMh6KCBugU64cuaTkyG/N4N8OJ1mlSPifp9fuKF5+QVEBSwOlpbdZ6bDyPm+4UCERgH+jf/a2zfjBtM6+ycWkgloSde7tEGh3pnCr5xNYYdo9torvTDi5OSRIdbOT6Nzblbh1Ftyr8yk39bry9IidIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777683; c=relaxed/simple;
	bh=gRDZ8QX1t+MAuID6HIGuq2knMJylgXgnKzKelQUZhXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gSnnKl80NSDNceFD/dA22fc/g3JfCWXogywJs9bMZVu/yJUrk0/XSJH0y4js9gtEdxf56lAWRAu8xS658hM/ydQsts8ZFV9np6okD/cN1NUlewNBbUpIzb3FXI6pmeHFUMryccXYtLF5OeDLezkJjXRVQnTacIxzlJNYFrHmf5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EOHY/ok9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515F1bxO001663;
	Wed, 5 Feb 2025 17:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=B1ja24
	MtE/dfzDMGymMgwVB+uiPkGyxyQVny/o4LP5Y=; b=EOHY/ok92JzaIG9OEPxJUW
	Dmr90Ndks6D4IREgjql+2e+5MosaZr4ZjvVIPeFn/IA++B75HtR7thzuMjkWYHTG
	89TkWoLQHYBV21CTPgO6U5RKLwxn1oBxdCii3I8S+ZbaMey46wkxzort1WZPUq9K
	vGK/rwbwbkugnQjETfUs2dTglG4pxzVQ5+5WKeEPtxq//2W1xx7W+0iRCpNWZHxN
	WH3fFWZwg2spWk5P9/qoCGCnDrcUXp/mnjp+ZixuoCrj+zOhGLnHr0IxG0j7vDXI
	fcqSHK4g/12ML9ai/oHqDtbPPkVMMz3gMcEgy/sEhX5O9D6+WotYQDFCgmYxTKLg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ma8yry4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 17:47:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 515FtNqd007130;
	Wed, 5 Feb 2025 17:47:57 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxayt4h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 17:47:57 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 515HltBM21758638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Feb 2025 17:47:56 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E73558056;
	Wed,  5 Feb 2025 17:47:56 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FA4258052;
	Wed,  5 Feb 2025 17:47:55 +0000 (GMT)
Received: from [9.61.82.181] (unknown [9.61.82.181])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Feb 2025 17:47:55 +0000 (GMT)
Message-ID: <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
Date: Wed, 5 Feb 2025 12:47:55 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Rorie Reyes <rreyes@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HJtPEgZxq8gYTsTa6QDXLnK6U8sHN_-Y
X-Proofpoint-GUID: HJtPEgZxq8gYTsTa6QDXLnK6U8sHN_-Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_06,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502050134




On 2/5/25 12:33 PM, Rorie Reyes wrote:
>
> On 1/13/25 11:08 AM, Alexander Gordeev wrote:
>> On Tue, Jan 07, 2025 at 01:36:45PM -0500, Rorie Reyes wrote:
>>
>> Hi Rorie, Antony,
>>
>>> Note that there are corresponding QEMU patches that will be shipped 
>>> along
>>> with this patch (see vfio-ap: Report vfio-ap configuration changes) 
>>> that
>>> will pick up the eventfd signal.
>> How this patch is synchronized with the mentioned QEMU series?
>> What is the series status, especially with the comment from Cédric Le 
>> Goater [1]?
>>
>> 1. 
>> https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
>>
>> Thanks!
>
> Hey Alex, sorry for the long delay. This patch is synchronized with 
> the QEMU series by registering an event notifier handler to process AP 
> configuration
>
> change events. This is done by queuing the event and generating a CRW. 
> The series status is currently going through a v2 RFC after 
> implementing changes
>
> requested by Cedric and Tony.
>
> Let me know if there's anything else you're concerned with
>
> Thanks!

I don't think that is what Alex was asking. I believe he is asking how 
the QEMU and kernel patch series are going to be synchronized.
Given the kernel series changes a value in vfio.h which is used by QEMU, 
the two series need to be coordinated since the vfio.h file
used by QEMU can not be updated until the kernel code is available. So 
these two sets of code have
to be merged upstream during a merge window. which is different for the 
kernel and QEMU. At least I think that is what Alex is asking.



