Return-Path: <kvm+bounces-14759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC58B8A6A1E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A823B21602
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A923E12B169;
	Tue, 16 Apr 2024 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="efSm+JIt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1003512A170;
	Tue, 16 Apr 2024 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713268957; cv=none; b=qs+6Lp/t4es8xR/mTx8r/p0tRQN+tUKBQOGKdHteoDv+gz3skqtNawlIWioCl79E1uODTjzRjnc7vYN7Mmc6J+UPs2WR+B6HOjYsf+8EBlyPPnQl+kx+2NSc3O1K9w1Zpl7o13kJ9x+s6tslBSzJo+vZWHHyJnD95O4/slBGnDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713268957; c=relaxed/simple;
	bh=ZWpYfz4eCT9K2GMgCPAps04fnJ+d32kW6EGhaGfLoCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mB+RDllI98riywtAjuUbNbhD+xJtc2jlnIS96FTaSkZupu6EV9Dhe1iqlEEWN4QmQcOW2j51DVwnXqOypM0raiKhzLXX4lt7Myo+hLSmgmNFwXAyRQmuhVTmz366aYQJ8zWRvzV0nh99znDzm+PImg+deDIGINKM3kMU0rwT2eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=efSm+JIt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GAScMb031904;
	Tue, 16 Apr 2024 12:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RL4SldF35NlNvMsqOFwvpvMKNHxNrohbBmlz5SARb3A=;
 b=efSm+JItYNBcGoyKi3IcXexxmeDEg0KGkbcb0KrVvHA3ComO6H83i1SwsZehZzFpptME
 diu1IoirH4sLxgs5gV2a+OlehqNnsUMziuxq2jS0w6isJyOzvrxikXZLE5rPeoexUsnL
 JAGDLFU9O9U0adFa3FI1VuikA7JRT/ECHnfkzv96gwQ1E1OJUNR2HUN7EWEekxG/zsFP
 Sw5rg8UgwDDkRPEvflR6qavz4FO1zzBa5o+0ChV5hyM4cSThjmPjlMKfkNa1IYznvX4u
 qG80nmD4zh42mpx7P1TOjTVCx9dt/kz5E+YL0TQYXIbuY2qFVoB1MHLD735YkOWzWlrN MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhqky0598-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 12:02:30 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43GC28mM004926;
	Tue, 16 Apr 2024 12:02:29 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhqky0595-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 12:02:29 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43G9drqv015506;
	Tue, 16 Apr 2024 12:02:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg5vm5sye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 12:02:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43GC2NBS40042794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 12:02:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3764D2004B;
	Tue, 16 Apr 2024 12:02:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 914B120043;
	Tue, 16 Apr 2024 12:02:22 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Apr 2024 12:02:22 +0000 (GMT)
Message-ID: <20d1d8c5-70e9-4b00-965b-918f275cfae7@linux.ibm.com>
Date: Tue, 16 Apr 2024 14:02:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
 <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <Zh4cqZkuPR9V1t1o@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rOCqEBPwxOZabIO0iThK6HIAofE6o9PZ
X-Proofpoint-ORIG-GUID: c0NOLnVFYJU1pyCLAA0PU_HqyxkdNqbp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_08,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=768 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404160074



Am 16.04.24 um 08:37 schrieb Alexander Gordeev:

>> We could piggy-back on vm_fault_to_errno(). We could use
>> vm_fault_to_errno(rc, FOLL_HWPOISON), and only continue (retry) if the rc is 0 or
>> -EFAULT, otherwise fail with the returned error.
>>
>> But I'd do that as a follow up, and also use it in break_ksm() in the same fashion.
> 
> @Christian, do you agree with this suggestion?

I would need to look into that more closely to give a proper answer. In general I am ok
with this but I prefer to have more eyes on that.
 From what I can tell we should cover all the normal cases with our CI as soon as it hits
next. But maybe we should try to create/change a selftest to trigger these error cases?

