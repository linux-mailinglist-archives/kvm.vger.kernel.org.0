Return-Path: <kvm+bounces-27070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8793D97BB44
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 13:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301E61F218E2
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 11:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2452F17D8A2;
	Wed, 18 Sep 2024 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CF3rwbbR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64316291E;
	Wed, 18 Sep 2024 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726657534; cv=none; b=N3fP9xr3AFojQt9cfDJ8LquZKYsKntmf0dLFvtkKorg8/3t+yGLWu0bw37SveqYxqr9xjYmSa6I44TJNDApBedlgnMuNgbHfqHYfvavwnw8d4N3xGqENzqxGPh8wpkfsWR7c8tY2kJ4S9ZCh7oCZ6unnbS9M5PRxIkIFri9i/sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726657534; c=relaxed/simple;
	bh=9t3OAceTohJNR3rbaNRKDmZtKLb4HHsoUHivTw8xleE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KUuMnAYatp+mfbbhmT9gCfdPYev52xIKX4oUQC6dra/abiQ9U7fngUFB0AYnZQtv5YIw2W3OMEFriHteAlRl44cNmI4zkcYpB7FZg2p4sB5Z2yewYU1eUrqj9ELMlvykPdOi8++DTFokEWbB3m4Zetym8X8B2wBt9+eagfuqgDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CF3rwbbR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48IATTu7022492;
	Wed, 18 Sep 2024 11:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=N
	9feMmW4qdwDHDayFvLhM8+dbQJ8kqMay3PbdRyLpk4=; b=CF3rwbbRYLlRV1MMM
	QjFjza/n84lcpckYgJNOfV8vkHW6tHRnV4TW37F11fmsnox1KIfbJmlINZ5VNm34
	r2SHNaIfbh1SlO3h2r+kIwj0eIxW5I7adJ5uenKQTBkAbeEG5e4rdFWSxTa7oLEu
	m9KCjFwIbRW/izErOMSm/QhjtAEURax551wHHVJy0gxOUt3mGD1ybSRvCEWScVKv
	oAMjIt9E0rV+irassYb6o0O7XQU/JvCF1Zm+a22plvg8qdso6EJjweJ2qv23+1dy
	vnR/AMNrI3AFqzrPGzf0glkjO2Sd60Mjjm+qpK56EgyreGXRZ+UGCuxIGo9mLIwe
	MPhXg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3uddcsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 11:03:15 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48IB3E1a028476;
	Wed, 18 Sep 2024 11:03:14 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3uddcsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 11:03:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48I7qequ025033;
	Wed, 18 Sep 2024 11:03:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nq1n2c6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 11:03:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48IB376r51773752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 11:03:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 358722004E;
	Wed, 18 Sep 2024 11:03:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 192152004B;
	Wed, 18 Sep 2024 11:03:07 +0000 (GMT)
Received: from [9.152.224.192] (unknown [9.152.224.192])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Sep 2024 11:03:07 +0000 (GMT)
Message-ID: <1583718b-43fd-4285-8392-936bb0ac89f2@linux.ibm.com>
Date: Wed, 18 Sep 2024 13:03:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] KVM: s390: gaccess: check if guest address is in
 memslot
To: Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240917151904.74314-1-nrb@linux.ibm.com>
 <20240917151904.74314-2-nrb@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240917151904.74314-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E6T3wFwg2t9eSYMsUJ0XZ57laoNfodjU
X-Proofpoint-ORIG-GUID: xnXcJ9l5hM75A7ihwQU7OIGqDCjpJiVk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_09,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=877
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409180069



Am 17.09.24 um 17:18 schrieb Nico Boehr:
> @@ -985,6 +988,10 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   		gra += fragment_len;
>   		data += fragment_len;
>   	}
> +
> +	if (rc > 0)
> +		vcpu->arch.pgm.code = rc;


This will work but using trans_exc might be more future proof I guess?
Otherwise this looks good with the nits fixed.

