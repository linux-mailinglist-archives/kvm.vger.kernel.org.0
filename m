Return-Path: <kvm+bounces-35012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CADEA08AF1
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15AED169355
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711B820967C;
	Fri, 10 Jan 2025 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="REzazV1e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DD1ADFE4;
	Fri, 10 Jan 2025 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500206; cv=none; b=HG0tTLmUAXQ+H5njAGXp7upQvEuwsY6w3O45CNLiT6C3hYnPJgpM5td/qLTWZDrL8JMGkkwrzElEwoCJL/TKSdAjmENpukkDu0f183RFc50EKvVdH5+nMTqai+qPLHKwsOTX79tAwAL1p5q/q3gAHDiLRRikgCzn64BIcKatveE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500206; c=relaxed/simple;
	bh=xaHN7GWYpt4R+X2qZ8qNWkZmEPbdjynrDmF3DtjZ0Xk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oBKTD4F5u4kYaDEOKc9ZioKdE5dr5vKw6egitPFjlaPnJ6FxnTJJfeptIy1LvO2dbHbG9AXxrWoaFZ4ZIR5qP/H5K5/Nq2QaO6dPlSq6Iy4dxm5L/bcy7A4GBKBYkVuMQyBpy9Q/LkuSArdB0SMppk0ja4Jc2aHCkaWnYYWcPLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=REzazV1e; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A0t0Ws010436;
	Fri, 10 Jan 2025 09:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IEV40G
	+cJBq5cts/Z6I0eqe+nmDed+StMjFKMxusyKE=; b=REzazV1eLqIq2IAkYiLmJq
	uUHGHg6BiYDwsZHVd+aRnjMNDk6g2RFzwfLJ/UULatHD9BTQLrQrL4FD6L9BVjVz
	VEOh4jpUFQuYnsskQI3/GfV2qSM5B/ST4ixrdimLao6qRPi0hTIGmG0M3hczNGsj
	0UPCdIv8hfk0brhV0KCvbklaomjvrrTKbb8M2e/CYNH4rDvPkx2AfH0R7q8JCmuB
	MP9Qj6XT7UyZVDO9BI6Etna/oarT+CbRp6yDA1gRlW3hGcnRZYkK1/zCBDrBaK16
	3lxupdQwuheQ/fLe2H7ZfI3/jdIHF7wzeSrXRBw4qAjzs+TIJBR8g3XnpdsOvAqg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442fx5c143-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 09:09:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50A8g5wl008970;
	Fri, 10 Jan 2025 09:09:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq09kd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 09:09:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50A99ro948103768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:09:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8DEF20043;
	Fri, 10 Jan 2025 09:09:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1E5520040;
	Fri, 10 Jan 2025 09:09:52 +0000 (GMT)
Received: from [9.152.224.86] (unknown [9.152.224.86])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 09:09:52 +0000 (GMT)
Message-ID: <ffcb7b9b-d1ac-473f-afeb-c31ff6bc3429@de.ibm.com>
Date: Fri, 10 Jan 2025 10:09:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/13] KVM: s390: wrapper for KVM_BUG
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-2-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250108181451.74383-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xKTqCVcZgNAvKzALPoRwTii1JwIJ3z6o
X-Proofpoint-ORIG-GUID: xKTqCVcZgNAvKzALPoRwTii1JwIJ3z6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=630 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100074

Am 08.01.25 um 19:14 schrieb Claudio Imbrenda:
> Wrap the call to KVM_BUG; this reduces code duplication and improves
> readability.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


