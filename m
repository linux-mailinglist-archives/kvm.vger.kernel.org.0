Return-Path: <kvm+bounces-46968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 626B3ABB71E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 10:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADE1D1898F5F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A502269D0A;
	Mon, 19 May 2025 08:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NCdLB13W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E921F1507;
	Mon, 19 May 2025 08:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747643111; cv=none; b=SCZ/d7dPD3SfZr9PwVmNrRtuPHjbWjTBbg5RykYK7r2IJBRtd+Fit2RAIldznuKCmjYsCWyBlvhBB6aselyWmyMwEbufp4D0Hz9I6d2D7/2XiMeXj/fxIjjSJmN+YwCbzdUdlPluxC6+V5oK3/w3XIYN6hNvDd2r3w49XS0vd/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747643111; c=relaxed/simple;
	bh=0VBOy+NVqaw0DEXJq/gyBScgHs9sRVM2+ZA7swkr91E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltGcSFBeZrRn0y6lUKY0YFwmaJ7K5na/kuyARSFsuTaQWan3K37vFlFqhwPpvGqr8qCiaepATV64aWWUOFm7CLuecDuInRSGvViAzjiaQjl2H32onDNkc7V56yllcuh1iwOKyIhyYLQaHpOHvghb+C5o9xEQfFI681dYj4FkPME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NCdLB13W; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54IKkW55027411;
	Mon, 19 May 2025 08:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BL4+z0
	uoYL14uPZ63eAU5FNl7XeygzOSxQmcHZOa3+w=; b=NCdLB13W1tNRtJ2pJdm/Ta
	MNfhjKxwvcPCXPhFZYIGk6JYDl8keJUcZmpV9C474bI9OBnmYNcJsWId5Sw8m6Xo
	SkPjrn185lwDr445Knm7KuqSFBV0E2N78e8HfKyZNd5zELUPEIgxhHhQsr7h6o5Z
	qBQs70/n0dzzOGL1lVVTf8JpWMNZkBa20oC5+QJ6YvgFLaKDfBvVz+s8G8QuGhok
	9gwpPDzetwJGMG7y3O3TdmnyMSDRU4fPn1W4GZCCPqGMn5qffnEybF8LBviW3I40
	rQbZuv30QPey2p2QXwCuIInJestbkOow2e4tJ0ledUQX5SD88Vsn62KOCDFmnyzw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qgs2u820-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:25:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54J7H1gY007347;
	Mon, 19 May 2025 08:25:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q70k5fyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 08:25:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54J8P2TM23134858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 08:25:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6C012024E;
	Mon, 19 May 2025 08:25:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5F372024C;
	Mon, 19 May 2025 08:25:01 +0000 (GMT)
Received: from [9.87.154.8] (unknown [9.87.154.8])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 08:25:01 +0000 (GMT)
Message-ID: <0cffcc15-1e75-4d6c-92d8-dd0158c912ba@de.ibm.com>
Date: Mon, 19 May 2025 10:25:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/5] KVM: s390: remove unneeded srcu lock
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
 <20250514163855.124471-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250514163855.124471-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z/fsHGRA c=1 sm=1 tr=0 ts=682aeae3 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=YHDewuclEeiYcwmWqesA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDA3NiBTYWx0ZWRfX6vl3rz7pxhjs mYPhtmwWa+gJpWU78TFSEwMi7PQOu6kiqaADIPmTOQ+/N5WieVGsn6yusXPbO8e3p/QAD2m0i6P r+FBAYBI+VI8JGIlO09YHGM/hjN38fZ+3dxuNKC2c4i6wX4kGN4BjfcjAqRomwMoy/zSBTzn5BB
 GOxjAPRXiKd2xEaej0TtMxiMeNuO4Gr95KxRkERbqI6UhGNY7kIL7B7VN9qW0A5CcLJuvcz80Hp cz8RdX4UhF+sCpLEVH7fAOh5/wEgqSWl2hHUR7XxKj70X05fbhxfuhILwoLCGZ6OTARYhPA17i3 D18RhGH+7wyEjdOLW1YA/owg7tpbZhOOcGkVwKbXNqFzUrmzQgWKBhQi3UwVEx4f1OPbuI4YedQ
 CHqoSV7J0/URmJYBR7EcyyYBmMYWC5la/l9so37f0WHHkxOt9dYZDr+WRLtrAxH0q2c13T0s
X-Proofpoint-ORIG-GUID: t-7vBzlRe2fFy7hDop-zZKlMmt76tChE
X-Proofpoint-GUID: t-7vBzlRe2fFy7hDop-zZKlMmt76tChE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=969
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190076

Am 14.05.25 um 18:38 schrieb Claudio Imbrenda:
> All paths leading to handle_essa() already hold the kvm->srcu.
You could add
since commit 800c1065c320 ("KVM: s390: Lock kvm->srcu at the appropriate places").

> Remove unneeded srcu locking from handle_essa().
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>



> ---
>   arch/s390/kvm/priv.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1a49b89706f8..758cefb5bac7 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -1297,12 +1297,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
>   		/* Retry the ESSA instruction */
>   		kvm_s390_retry_instr(vcpu);
>   	} else {
> -		int srcu_idx;
> -
>   		mmap_read_lock(vcpu->kvm->mm);
> -		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>   		i = __do_essa(vcpu, orc);
> -		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
>   		mmap_read_unlock(vcpu->kvm->mm);
>   		if (i < 0)
>   			return i;


