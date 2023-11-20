Return-Path: <kvm+bounces-2044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 689BA7F0EC4
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 10:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2464A2821DF
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 09:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BFC10A26;
	Mon, 20 Nov 2023 09:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tKA8L0Ht"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D010C9;
	Mon, 20 Nov 2023 01:16:17 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AK9856m028497;
	Mon, 20 Nov 2023 09:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nFdUQj9AOSWjewm5RoNwJqldd5TNj4Jn1ns4UszwmWo=;
 b=tKA8L0HtOsZTqJUF9W3VdlYvUM7Q//vFm0sTzInVZj30FoPhQv2NOguJ87s9ieoJFoJ6
 OP5Qd3q5p4NQ0IPT9bhDKJnhVkNEvJa7mXTBcvwf8PCYkfXqBfynm5wvzP81/In0BxV/
 09rJAfg/Sbj8JCc/oB855pWUM59XfLbD8fjqT5ltiLPGFKsyF/STG2TV5GSm19OJbs/A
 oUJ3xG7Jnz/WTg5Y0RknfcEq0gpBPyD8oZUEWSr0k7aUkl6dIuadAVUfKvY5rHw3CJpL
 Wzp/22n/qZKCZ+aE+mCKOEUfPAhMotTgp08FXbudcOV3GArT/ZeE0T8HJi131FBQaRXS Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ug4j786v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Nov 2023 09:16:15 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AK9C3w7009295;
	Mon, 20 Nov 2023 09:16:15 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ug4j786uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Nov 2023 09:16:15 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AK7KEUt028315;
	Mon, 20 Nov 2023 09:16:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uf7ksregr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Nov 2023 09:16:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AK9GBpj22414022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Nov 2023 09:16:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72B452004B;
	Mon, 20 Nov 2023 09:16:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E39620040;
	Mon, 20 Nov 2023 09:16:11 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Nov 2023 09:16:11 +0000 (GMT)
Message-ID: <f18f6993-17e8-cab4-6a7f-059f669fc890@linux.ibm.com>
Date: Mon, 20 Nov 2023 10:16:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] s390/vfio-ap: fix sysfs status attribute for AP queue
 devices
Content-Language: en-US
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20231108201135.351419-1-akrowiak@linux.ibm.com>
 <17ef8d76-5dec-46a3-84e1-1b92fadd27b0@linux.ibm.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <17ef8d76-5dec-46a3-84e1-1b92fadd27b0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _2cgNhOm5HEippqYDl7vFdPrSsc1x0a7
X-Proofpoint-GUID: luzmibklj_XTsQxEiYDY84TR7F4tgQ5o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_07,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=920 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311200061

Am 08.11.23 um 21:21 schrieb Tony Krowiak:
> Christian,
> Can this be pushed with the Acks by Halil and Harald?


[...]

>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
>> Acked-by: Harald Freudenberger <freude@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>

I think this can go via the s390 tree as well. Alexander do you want to take it?

