Return-Path: <kvm+bounces-15469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCAE8AC6E0
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D11A41F2162F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D60350286;
	Mon, 22 Apr 2024 08:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rzLob/TQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D04CB2E;
	Mon, 22 Apr 2024 08:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713774325; cv=none; b=MJ34zz56XbYK+BAj18TP9i6GsC3YbqOtbwcG6rmjjoRiDPkDO7Rh3apQNEYGsM8P4miH+/8eQAwcHJcehCPpuhPBHKnNUTbO1wiOLkUoxn6bsgXs/cRtFr+PGlLLe3Z5i3q28jDTBoTuqi+kzeNP3IMY93EYDVlMyUcUXnD++SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713774325; c=relaxed/simple;
	bh=PYWEB5XcFqcQrbadTHaNZROJ58P51b13sTiCpZipePc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NkpiZRtXGbJBbDBppQZmIN+QmuIHZUKgQ6thmBu+oneUrhf4wHQLsa8wZsUdg9l8y17q94c8soZ1gUWPVDm5AE1jzI6u5ViAr6X/8WboY1gwm3wLhijaGwC4PxpsvANWw7xCSqWcOqs/JDEN474jZ7KQ3z6g0p8Iu4rm0MnjfbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rzLob/TQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43M8I0If002829;
	Mon, 22 Apr 2024 08:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WOr1X0n6E/gO1vTysnwBm7+zOYMy87J+ZcChwjm69pQ=;
 b=rzLob/TQhjwXRbQ39Hen/2puBZO1HwDIEjO0+OM6Ya19x9DMMB18/1X5A2aN/3cARYTB
 VMgGJpAf764cmQxeOXsorzkvfLgis2+yGDQIgl/ANOqR9b+pNHTFwUO8ULScCxcxgaGj
 bgbFOSIDvn0zBPN0VBdBZWNhK+MBzNcniGw1O9jTWmLguQWaWUF0sU9WL38LJhH1rHfx
 PSkWJyVJvB1Jt+mUYK9Edt6Z6W7DEG4CYMdHtVJCBGDaqXwDg2/BEuB16XGCLlSPivkL
 faVSU7472er6c+K1itdg85MKuUr2ZPENHYlNJcIZZCb0lZISdybYIg2JDxR76Ttku1XX cg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnm8kr0n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:25:21 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43M8PLIR014501;
	Mon, 22 Apr 2024 08:25:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnm8kr0n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:25:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M6XvNQ023052;
	Mon, 22 Apr 2024 08:25:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1npk5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 08:25:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43M8PEfF47776030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 08:25:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CC7D2004E;
	Mon, 22 Apr 2024 08:25:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A119A20040;
	Mon, 22 Apr 2024 08:25:13 +0000 (GMT)
Received: from [9.171.27.139] (unknown [9.171.27.139])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 08:25:13 +0000 (GMT)
Message-ID: <5efcafac-2f2c-4a2e-b964-7f412c30df4a@linux.ibm.com>
Date: Mon, 22 Apr 2024 10:25:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Check kvm pointer when testing
 KVM_CAP_S390_HPAGE_1M
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240419160723.320910-2-jean-philippe@linaro.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240419160723.320910-2-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3kBDVW7K78GaUNvv5vK07XnAEqNyuHio
X-Proofpoint-ORIG-GUID: AcO6yoVd0Dp8mxPWQVXnrfcnnzf-YGlY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_05,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 spamscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404220038



Am 19.04.24 um 18:07 schrieb Jean-Philippe Brucker:
> KVM allows issuing the KVM_CHECK_EXTENSION ioctl either on the /dev/kvm
> fd or the VM fd. In the first case, kvm_vm_ioctl_check_extension() is
> called with kvm==NULL. Ensure we don't dereference the pointer in that
> case.
> 
> Fixes: 40ebdb8e59df ("KVM: s390: Make huge pages unavailable in ucontrol VMs")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

thanks applied.

> ---
> Only build-tested
> ---
>   arch/s390/kvm/kvm-s390.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5147b943a864a..7721eb522f43d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -587,7 +587,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   	case KVM_CAP_S390_HPAGE_1M:
>   		r = 0;
> -		if (hpage && !kvm_is_ucontrol(kvm))
> +		if (hpage && !(kvm && kvm_is_ucontrol(kvm)))
>   			r = 1;
>   		break;
>   	case KVM_CAP_S390_MEM_OP:

