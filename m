Return-Path: <kvm+bounces-18908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD6D8FCFBE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDC65B29025
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BC4194A6E;
	Wed,  5 Jun 2024 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pEDUb6r5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EBE1C3D;
	Wed,  5 Jun 2024 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717593204; cv=none; b=TFvBUMttvFrjHSd46XbLY8PNlp/e6EVbpN89iKjO24Oh20pxBecvYE1tvQLFhihjOlvL7xvby8GZR8gt+WoKqJ9P0kx7GJ+aN1Ez8o6OhK7l/Hdz0RE4APloQq/Ej02xw5nhTLL8T5amOph7QhRDCHsoK5G3J1vGdRxxEauTMyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717593204; c=relaxed/simple;
	bh=lcRT+tzoPV1CArKM26q9NGMNG0h6kkT7J9Luo9A0OA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bv9hvoS4c01bgzbXoaWZTl2jDQVVehg9ptsqlO30GNghVE7Uj1MugfWf21ICzEu716q3bdjcpBA3o89uObQfHunn5khO/PXrJVJvEXl57BmjFOygaMWQ3P2XN1CkupIu+fkXhN7CZBf8i5XIJAsHOmtxFYSqRj9Jw8mcCHdCrbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pEDUb6r5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455D7Sdf019226;
	Wed, 5 Jun 2024 13:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=EwYCG4cYNmVGzMldoH8rmZ99WGkkfxZ/nkO7rj+J1CI=;
 b=pEDUb6r5h3Kq9KmN9g368eCe5Ynem6iWryLKZlisf7leTq0ncGjMmJQj72mvbLSk2bGl
 gsX1h5SQ7+Zi5k/5FrVMOdYxITaXWUugtQV7pd4gvUdoW4GX6XdpcLO5FzYascokVUhp
 hibn+RKhd84WMafZc0yjdKJABdSG0QszDVpxTffjyOGE7T5qkmyK0lSC5pmVf8qtarTY
 GYPwTgEij//EmCZAzUDWTbbsy8ySudwbDWeCF02CPZ+HdzBTQ+26k+mU0xhrtpog5flA
 9rdL7lUu4jCJq9uEuiw+KaHsgkIYeOkIfyUWOpnc9svqX1AY8Ly9MS/2c+oYfiJhx2Yh ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrm9g0ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:13:12 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455DDB0H028029;
	Wed, 5 Jun 2024 13:13:12 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrm9g0pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:13:11 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455AdLmv026592;
	Wed, 5 Jun 2024 13:13:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn44pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:13:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455DD63R53477776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:13:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84B4A2004B;
	Wed,  5 Jun 2024 13:13:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F50320040;
	Wed,  5 Jun 2024 13:13:04 +0000 (GMT)
Received: from [9.195.38.242] (unknown [9.195.38.242])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:13:03 +0000 (GMT)
Message-ID: <3dea8d70-9f04-4410-8063-d98c392c10c7@linux.ibm.com>
Date: Wed, 5 Jun 2024 18:43:02 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] KVM: PPC: Book3S HV: Add one-reg interface for
 HASHKEYR register
To: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741330411.6631.10739157625274499060.stgit@linux.ibm.com>
 <D1R0AHN2MCOS.BPHUJKSV7YSO@gmail.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <D1R0AHN2MCOS.BPHUJKSV7YSO@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FhHe7XHzQiXgt5lBSKMgmOg4mits-tmi
X-Proofpoint-GUID: 4E3K761OZvwEgk7TdIGzCeYmQTSeIE5n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=626 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406050100

On 6/4/24 11:37, Nicholas Piggin wrote:
> On Mon Jun 3, 2024 at 9:15 PM AEST, Shivaprasad G Bhat wrote:
>> The patch adds a one-reg register identifier which can be used to
>> read and set the virtual HASHKEYR for the guest during enter/exit
>> with KVM_REG_PPC_HASHKEYR. The specific SPR KVM API documentation
>> too updated.
>>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> ---
>>   Documentation/virt/kvm/api.rst            |    1 +
>>   arch/powerpc/include/uapi/asm/kvm.h       |    1 +
>>   arch/powerpc/kvm/book3s_hv.c              |    6 ++++++
>>   tools/arch/powerpc/include/uapi/asm/kvm.h |    1 +
>>   4 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 81077c654281..0c22cb4196d8 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -2439,6 +2439,7 @@ registers, find a list below:
>>     PPC     KVM_REG_PPC_PSSCR               64
>>     PPC     KVM_REG_PPC_DEC_EXPIRY          64
>>     PPC     KVM_REG_PPC_PTCR                64
>> +  PPC     KVM_REG_PPC_HASHKEYR            64
> Just looking at the QEMU side of this change made me think... AFAIKS
> we need to also set and get and migrate the HASHPKEY SPR.

Thanks Nick. I have posted the v2 with changes for HASHPKEYR

and your other suggestions at

171759276071.1480.9356137231993600304.stgit@linux.ibm.com


Regards,

Shivaprasad

>
> The hashst/hashchk test cases might be "working" by chance if the SPR
> is always zero :/
>
> Thanks,
> Nick

