Return-Path: <kvm+bounces-20765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC7891D947
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CA4A1F223E2
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163037C086;
	Mon,  1 Jul 2024 07:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bjfOkcVJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED3B7D3F5;
	Mon,  1 Jul 2024 07:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719819899; cv=none; b=f5dZ6VBpAN07nT99ElSeXbc3brOpRaZ+PL9pR4+utabihY6xwCPN6fo4Eo8M3bkBIN75g/gcVqeL5M0snzMYtc1icgeR0mAXPzfu1r7pVJz/GIAVCchQQ3JvI2bKcre/xscMEfrA+URQvXzdO+jlaY5CqB/6qeSY0RaN1dqcdZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719819899; c=relaxed/simple;
	bh=lpwAcjkhxndLvnwB5Nx6W8zptJZLhmlAq7MTrXTXmMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqUKfJawpISvntxhyiNXJ/1Esl5BWQIFvsfhzbb2zdufYB8AhJMv8sJscKUc7Pbjgf6v3J2F8K60dswzTBT1XlJa9nMQXneZTG15euiLasaYin7UY5CIJy7triaYG1ehqqZZ8T8ntCwCBESJGg/I2+ZR4L9OyqdlzxAMIkiSIIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bjfOkcVJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4617ReOT008005;
	Mon, 1 Jul 2024 07:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=l
	mhLMFgBN7xyC4nacR7O9WI9deW2eELIFTtnHom714A=; b=bjfOkcVJe20c7uBkF
	NK4yjfdliYb8sncI4Q+smGEwFwDTZRnBIP7a6juWJJAOUrigo85nEUCdnyCnPFzZ
	DqaWW3svZvPDoPtjr1zgBv8m4AnBetq1XK3j3ONN79LqEvxFV1keY9yGCvIOYYj4
	zP/LslQ646Conm3P3yHRuQ4JKugrqsCLS2p6gbVSsfkRGMDKiCUGRws0y9CbqN9/
	4iDpwpj57UmC/18L5elEq8L2lrmbTdx2lIGkjz6T0acR6wJKHcYMCLv5OfsuY6h/
	8CU7mHQ9poxGVb5gBewwb2lJyohiSPEKU7nJ3pxVC/QOe+OpruG0LxSMaXB3Fdee
	k6Abw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403q6xg67c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:44:55 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4617itw5001968;
	Mon, 1 Jul 2024 07:44:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403q6xg66h-25
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:44:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4614jujG029146;
	Mon, 1 Jul 2024 07:27:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3mnvc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 07:27:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4617RncK55378394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 07:27:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DFDD20040;
	Mon,  1 Jul 2024 07:27:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49B832004D;
	Mon,  1 Jul 2024 07:27:49 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Jul 2024 07:27:49 +0000 (GMT)
Message-ID: <513ac5d3-c0ef-4b07-bce2-84fabab9fdb7@linux.ibm.com>
Date: Mon, 1 Jul 2024 09:27:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
To: Sven Schnelle <svens@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
 <yt9do77h7ige.fsf@linux.ibm.com>
 <0d870c8d-2be8-485c-9320-4f779bccf552@linux.ibm.com>
 <yt9dfrst7ew0.fsf@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <yt9dfrst7ew0.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nx9JgP1pWB6NLL_JEwE_to5aN7ZROr4T
X-Proofpoint-ORIG-GUID: pAdbnQXLfyIqG-du5ntA9xQTLSwVBp-Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_06,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=779
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407010056


Am 01.07.24 um 09:25 schrieb Sven Schnelle:
>>>> +	vcpu->arch.sie_block->gpsw = new_psw;
>>>> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
>>>> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>>> Shouldn't the gpsw get updated with new_psw after the check? POP
>>> says "The operation
>>> is suppressed on all addressing and protection exceptions."
>>
>> Only for exception of the instruction but not for the target PSW.
>> POP says:
>>
>> The other PSW fields which are to be loaded by the
>> instruction are not checked for validity before they are
>> loaded. However, immediately after loading, a speci-
>> fication exception is recognized, and a program inter-
>> ruption occurs, when any of the following is true for
>> the newly loaded PSW
> 
> Ok, sorry for the noise.

You can repend by doing a review and send an RB or other feedback :-)

