Return-Path: <kvm+bounces-10773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3FD86FC57
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52FCA281764
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F62224E0;
	Mon,  4 Mar 2024 08:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ttxTsu8s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BD01CF87;
	Mon,  4 Mar 2024 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709541904; cv=none; b=Dz87TtjZPrQCwCZPHFItqw7Rh0o1GoKcFET7+F6o/UXYXpHwWYZhGR/JbqYy3FJKop7q74Ft44qdnh2KDgbeYAag0RlGbzEEp0MGb+Voas15Sj0R58bqA3y3jRu8YS4YEoRdSJqPUuE3T8/ozEQRBVNyefvi9GLdexK+3EP28yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709541904; c=relaxed/simple;
	bh=JhB4Fh9f7VvgJNGyZfbeDV7AOMGQoX5j923ICfzc/9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHwoAG4aU3sdffIfaHcEUiCbfhra2IzkV/pl9bdTBQ706sj4bJhyj+rHm/Y/mEVRrZYI1JyikXYE+yX1HKvmbVx+/XN6wpMitqPXUFFindxnCcI8T9xmYzD6MjrykP9J0DJLCYqHmUqqudhkAww3CT6/1w86lRl8a0gpMyzYIfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ttxTsu8s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42485sdS016778;
	Mon, 4 Mar 2024 08:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7O3j5hB0PmnlMQWPyOx/F6kZdTYfEGLQUK+PqYy6Occ=;
 b=ttxTsu8sOoSi8pLAQ/HWBCHvC8ODtPBwvYVGXrGbxxecx/SFCKseyGNLuwizNuwJR3l0
 xA8KUxaneZ1yoSwJW20AWpKDzvITxe2pEGyraunHqxFL69VsWcHgPMWZMIemjgUeFZGF
 qvY0BX2hdCBQD/6pzamJhj69+q/ASMXFm4JXYC72AX5EE51dnhjyjJX+wEqbsSgrI0PE
 JFDBLNd2Rbkm6x+/r6ItFsg8V/zxwR1UFSavPYUb5j7bvPgvHStaBT1zIevFauXD+nVw
 WUduYgVa+GjpDY6RgZOq3dVpQ1wwa6tOr/u5nenD5qz1Bi2xUwHztaK9XpDJdteU76+o Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wnafy0u2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 08:45:00 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4248Bl5c004654;
	Mon, 4 Mar 2024 08:45:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wnafy0u2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 08:45:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42477bA2026212;
	Mon, 4 Mar 2024 08:44:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wmfenfdm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 08:44:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4248irsk43712880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Mar 2024 08:44:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE18C20040;
	Mon,  4 Mar 2024 08:44:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6D3F20043;
	Mon,  4 Mar 2024 08:44:52 +0000 (GMT)
Received: from [9.179.29.223] (unknown [9.179.29.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Mar 2024 08:44:52 +0000 (GMT)
Message-ID: <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
Date: Mon, 4 Mar 2024 09:44:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host intercepts
To: David Hildenbrand <david@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
 <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q-faGH8MRRb-NEBinXG1H99z4wZ6YX_o
X-Proofpoint-GUID: 82YXLDNHXmBEZ8e5v0pvQFFJzrJ8n8hy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_04,2024-03-01_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxlogscore=629 bulkscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040066



Am 04.03.24 um 09:35 schrieb David Hildenbrand:
> On 01.03.24 21:43, Eric Farman wrote:
>> It's possible that SIE exits for work that the host needs to perform
>> rather than something that is intended for the guest.
>>
>> A Linux guest will ignore this intercept code since there is nothing
>> for it to do, but a more robust solution would rewind the PSW back to
>> the SIE instruction. This will transparently resume the guest once
>> the host completes its work, without the guest needing to process
>> what is effectively a NOP and re-issue SIE itself.
> 
> I recall that 0-intercepts are valid by the architecture. Further, I recall that there were some rather tricky corner cases where avoiding 0-intercepts would not be that easy.
> 
> Now, it's been a while ago, and maybe I misremember. SoI'm trusting people with access to documentation can review this.

Yes, 0-intercepts are allowed, and this also happens when LPAR has an exit.
So this patch is not necessary, the question is if this would be an valuable optimization?

