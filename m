Return-Path: <kvm+bounces-14638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB0E8A4E0E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3E2D1F2194D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 11:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045BE664AB;
	Mon, 15 Apr 2024 11:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m01cPoQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9FA4E1C9;
	Mon, 15 Apr 2024 11:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713181771; cv=none; b=tzY3x+JmqR3/Ieko0RaqODZsoJ/ttXqGv+pjGE31sOUs1nC3+0eVL/w6W3SqECNjShHvkYudF5VIzkcs6MM9D3wwxWGB+MF/p1On5PjCwG3Y/mhPmIGbew3qxobc2dF5G1VMK7a2E2Ej4RBe4B2W/2HrEkOwhnXxCluwlwmJPkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713181771; c=relaxed/simple;
	bh=1AOxoQGdL0y1YWkk65R3laOqyKK3IrrdSTK7u4d2Zr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtoVjP7F4VbMKl4y4AUKSSm0DhAzwN4M2KhMTTz2HtOWii6n4dA7ASSLZpcxVBgEag1vAJFnaxV2qmt8x0Yw729OK2M3Rz1v92qUyg/AABz3yZVq6ChNCodtCe4DR70T9RnAFwn9TsScJgVzzmGJvYBCwZiDQ5QgB+YuFpVd56s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m01cPoQ5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43F5xMSH026547;
	Mon, 15 Apr 2024 11:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yksTcyQz5NdCm7fE5UHkxvYbIpHPmZ0I6TTqMEmOh2s=;
 b=m01cPoQ5+I+dg51dtwiPS9lW/uZ00d+m2aFFjBd/K41uBeWrl2HB5VlbZWBzrenNW5jM
 xYkMP+RYvfLONrWZrWEvzLHVTgoQWRD94DQk64EDMXUapFSNFKFUPl6OjdwQ9e0fYzey
 Kq7W8AR9VbWatgV0mtSbPDrIPs8ZlRDox2ep9kuEGCwxnZt9IjUGbAw9595Ks7TD8ZQ4
 r3snJEVqlooqqcH75qaaUPU47TbjGzEU+dB0PPQxdvldFpFPYEg4hUi7Y7PfbTXzq5gY
 3KVnAzXi3ohzsNpIkzf/vdPsg0B3ytPHocgN3hpV+hsq9XuWNPELLySS07aOXBbk4ptH JA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xgmufhd0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 11:49:22 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FBnMGI000544;
	Mon, 15 Apr 2024 11:49:22 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xgmufhd0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 11:49:22 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43F8Mbtq018157;
	Mon, 15 Apr 2024 11:49:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg4csytm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 11:49:21 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43FBnGw241615800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 11:49:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CD0620040;
	Mon, 15 Apr 2024 11:49:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5F902004B;
	Mon, 15 Apr 2024 11:49:15 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Apr 2024 11:49:15 +0000 (GMT)
Message-ID: <2a4ce6bc-49cc-45b8-ba15-82eb330f409f@linux.ibm.com>
Date: Mon, 15 Apr 2024 13:49:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
To: David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
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
 <ZhgRxB9qxz90tAwy@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <bd4d940e-5710-446f-9dc5-928e67920ec6@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <bd4d940e-5710-446f-9dc5-928e67920ec6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AI57YoH12I_jlkm62ZRo3ZEH8w450S4k
X-Proofpoint-ORIG-GUID: 2CGKmVpoTAvUdLJwz9fmS5uQQ6sZ3gzN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_08,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=847
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404150077


Am 11.04.24 um 23:09 schrieb David Hildenbrand:
> On 11.04.24 18:37, Alexander Gordeev wrote:
>> On Thu, Apr 11, 2024 at 06:14:41PM +0200, David Hildenbrand wrote:
>>
>> David, Christian,
>>
>>> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>
>> Please, correct me if I am wrong, but (to my understanding) the
>> Tested-by for v2 does not apply for this version of the patch?
> 
> I thought I'd removed it -- you're absolutely, this should be dropped. Hopefully Christian has time to retest.

So I can confirm that this patch does continue fix the qemu memory consumption for a guest doing managedsave/start.
A quick check of other aspects seems to be ok. We will have more coverage on the base functionality as soon as it hits next(via Andrew) as our daily CI will pick this up for lots of KVM tests.

