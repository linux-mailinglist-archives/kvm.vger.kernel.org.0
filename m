Return-Path: <kvm+bounces-6832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F8F83A954
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 13:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4BE528D41E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096D36310F;
	Wed, 24 Jan 2024 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SZKl63VK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD9462A18;
	Wed, 24 Jan 2024 12:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706098535; cv=none; b=UWMRKElb+i+5yDwr62aKLRZyNfhuWc8PGaUvMWIAQUrgd7Kv0KiZwG13ZF98Be1rhIN4yHWh21olg2XxirX4nWqu33CHXZ4UdYRIYev5k4CgxpZSs7Vzjfp6JaoOMISB83E0xpDdsM8t/KEN3Vg8xL4Sw6MynEH5RtJaSeCjJrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706098535; c=relaxed/simple;
	bh=9/TY5HmYPm8E0G1A05/PyJFft8ngdFb+/07JFazSGiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jFjCdQz/srZZO/H0oeOdaxyunmJMVgSeQD2hz2qMWU+rNrpSLGHWvx1d38kI4PxOKQKB+ywO6NrUUWVqEaVcRTWQnEhGJ4k60ZOivIvDHbTyOiaPPRi5cDQ3Gs2JDIAsuYBzdfwy9fRkPpjJw0aYKmLG2kWqHCD9y8wwSEyn9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SZKl63VK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40OBTUQw020659;
	Wed, 24 Jan 2024 12:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h5QTFvOXySrnlCSLejUWbzN7R0IzvqRuBOyzN1TZrJI=;
 b=SZKl63VKVv1zAp3tpsPHAbpGMaWfgnKtkYZCE5Mrvsfcf2ghZM6EKRlZDJ5My8WdhKcO
 F7IM29RlDlnlQluLl+m291CjXqnI0RTROcmf5kPlIe2SE2hLGO0EDGrLHseOQEAxORHP
 HXN8ej6fAf4YfOVn3X0FRYwX6p+8uJNVIBmixyr/M0k8Ffnbc+jeK/adZ0P05ugDoEUP
 baXK5wSz7BRJd/YJ8Q+PIkGj4xsbDiE2aAjovHx49IeUSFAc389dM/NQHiNxlEAW+lEm
 BNQIuYJpC6bRtBu/Wf2N+cns6jmmXuCiy+/1gDSNCRie4sxrvaBeIBA4GpL2YEZL0cV7 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vu05gbejq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 12:14:45 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40OBFAYe027101;
	Wed, 24 Jan 2024 12:14:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vu05gbej7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 12:14:45 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40OAoCKh025653;
	Wed, 24 Jan 2024 12:14:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrsgp5mnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 12:14:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40OCEfwO21824006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 12:14:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16EB520040;
	Wed, 24 Jan 2024 12:14:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5B1220043;
	Wed, 24 Jan 2024 12:14:40 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Jan 2024 12:14:40 +0000 (GMT)
Message-ID: <f898e36f-ba02-4c52-a3be-06caac13323e@linux.ibm.com>
Date: Wed, 24 Jan 2024 13:14:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 0/4] KVM: irqchip: synchronize srcu only if needed
To: Yi Wang <up2wing@gmail.com>, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev,
        maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20240121111730.262429-1-foxywang@tencent.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240121111730.262429-1-foxywang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cbW_U5WPhzOWf19FHy2Hl1GFoRPKfTjm
X-Proofpoint-ORIG-GUID: HmjjZcFKC3F87LftISToZPyjK4682bMp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-24_06,2024-01-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 mlxlogscore=676 priorityscore=1501 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240088

Am 21.01.24 um 12:17 schrieb Yi Wang:
> From: Yi Wang <foxywang@tencent.com>
> 
> We found that it may cost more than 20 milliseconds very accidentally
> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> already.
> 
> The reason is that when vmm(qemu/CloudHypervisor) invokes
> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> might_sleep and kworker of srcu may cost some delay during this period.
> One way makes sence is setup empty irq routing when creating vm and
> so that x86/s390 don't need to setup empty/dummy irq routing.
> 
> Note: I have no s390 machine so the s390 patch has not been tested.

I just did a quick sniff and it still seems to work. No performance check etc.

