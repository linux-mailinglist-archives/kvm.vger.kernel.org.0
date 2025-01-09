Return-Path: <kvm+bounces-34911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2ED0A07601
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49DDC188A54C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 12:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDD7217F40;
	Thu,  9 Jan 2025 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b3Sq0z43"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583BE201036;
	Thu,  9 Jan 2025 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736426779; cv=none; b=KeDCkPGvokEAgOQhNc/OW4PNfRPEDNu09MnO2UItbA2XjbDfoO0w9JG5ToZwfAyP+WbCvnIsI3TbwYSFtC3SCCekkuphVe4KFfh3UnWJqq3/LsURDkOIuow9NV8JpHvLKbi4RBrVjWuIrRGtIdDg/zaRhC2UbUUobRK8qIbPXm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736426779; c=relaxed/simple;
	bh=j2CE2Y91XKecOh58FJvtZ5SuiU2eLyYo376QUQeon+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oiOuEj2GORcnyX0OhxU4wBuuWsg4wPtcPCo0RB0tlwJkjEX1eM+q5ApsqRh8ZeMUhiN5BfAMD1fUQbkRVpcDNyz/+twQHtp4j7UJMKXWcpFbm/NZETbzNuhqPjcHvkigxqalVj4q8dIGf4u41/BsIn1Sg2r3orff5rCZFThk1oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b3Sq0z43; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5093qgBW005387;
	Thu, 9 Jan 2025 12:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=97bkXi
	fslOtTC1kl5LWTFFdoPCRtBIA5SCpeLno+weQ=; b=b3Sq0z43T3Lcrbv7FsI1jl
	Ih5xi/qJN/GJen/JYIxdDu1K+Y7yzZ1A5g0z7tkhWqi9RPhtBAAwaIEJuD7BM82/
	qOcm3L3mJEeKDpf+JYthlURCL24gW5xlvghR/RPHYylz7a8xNULeqhR9L9Cwqru4
	/oAgfX9q4/eNR1SIEyhHu6ameFyujFhCG1Q6109yKndjUb0TQzlHqxJbAjjwvjMk
	OpsiIY3h70t7Yld8SppdWrg40/ULj+CeJC3IxjOEF7XDSL6dkvGxFCZSJ0fy1PTb
	mqFveIYVmUZ3OsDSBvbBrNX6k85Z9NqYm65g86tMmI8qKtgAyn9NGiXQUoZlWtSg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4426xca4mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 12:46:14 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 509CkEdr014939;
	Thu, 9 Jan 2025 12:46:14 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4426xca4ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 12:46:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 509A61Fu026167;
	Thu, 9 Jan 2025 12:46:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj12cthn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 12:46:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 509CkBNt48627976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jan 2025 12:46:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A630D20043;
	Thu,  9 Jan 2025 12:46:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BD842004E;
	Thu,  9 Jan 2025 12:46:11 +0000 (GMT)
Received: from [9.152.224.86] (unknown [9.152.224.86])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Jan 2025 12:46:11 +0000 (GMT)
Message-ID: <9c04640c-9739-4d5f-aba0-1c12c4c38497@linux.ibm.com>
Date: Thu, 9 Jan 2025 13:46:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
To: Brendan Jackman <jackmanb@google.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c8qUK1kYbuU2Fqgi3IBkbxaN4GjIHY4k
X-Proofpoint-ORIG-GUID: 8dGaRh2WJzNhVaN4NhIkuCeSb2U-LSE0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=876 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501090099


Am 20.12.24 um 15:07 schrieb Brendan Jackman:
> This is used for VMs, so add it. It depends on FUSE_FS for the
> implementation.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

I think this makes sense given the usecases of make kvm_config.
As of today we select 9pfs and virtiofs is clearly the better choice.

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   kernel/configs/kvm_guest.config | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/configs/kvm_guest.config b/kernel/configs/kvm_guest.config
> index d0877063d925cd6db3136c9efd175669c1317131..86abe9de33bb2378ba0f7d46dbe4d84b49835506 100644
> --- a/kernel/configs/kvm_guest.config
> +++ b/kernel/configs/kvm_guest.config
> @@ -33,3 +33,5 @@ CONFIG_SCSI_LOWLEVEL=y
>   CONFIG_SCSI_VIRTIO=y
>   CONFIG_VIRTIO_INPUT=y
>   CONFIG_DRM_VIRTIO_GPU=y
> +CONFIG_FUSE_FS=y
> +CONFIG_VIRTIO_FS=y
> 
> ---
> base-commit: eabcdba3ad4098460a376538df2ae36500223c1e
> change-id: 20241220-kvm-config-virtiofs-64031a11144f
> 
> Best regards,


