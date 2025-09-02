Return-Path: <kvm+bounces-56532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1333CB3F5BB
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9CD4840C1
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 06:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDE32E541F;
	Tue,  2 Sep 2025 06:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sA29OAw6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A3A2E3B11
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756795318; cv=none; b=d88oYZHqqS7NuQSzKNexpW97S6DS3siPRFYbWW5znt4q2j2GYezHuHgyUbodisc0uU430FgqM3X6p7ZT3UgK4SurdLfXcuuYP9kAgCgJf6DmZtX1nRHhHSsX44DKJuDBcXHzKsbiXqL/pYY0LrJcrjKQKI4QedziLpVT73ZrL8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756795318; c=relaxed/simple;
	bh=BCcUXxWs1hTS0rQ0F4/roa+LsWBDh68NVZrUSXF4vtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBx9gm0CpjBAXbzYgHb5jcKMBlc+owfkVicnJLOh5H+fUhtEm5g34E3Mps8xtArPv4GJvzcV8Ox7GHh3GTNXn7rawb7qDa+mDtpFaMEBDZO4KS5BBYnE2VY+n8IYApyVTHsidmpWw+r+r5J5fmg5t13yUig61pYp3dyPc4fqagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sA29OAw6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5821Nn4J032738;
	Tue, 2 Sep 2025 06:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NGd6BH
	CBuHiyle4mL3ZucAvGhpB8BxGvdT/kvMzuoTI=; b=sA29OAw6rKkSVQJLMR41h2
	YgIZmNpS9UqCT2yaBtcFPrcIyWOrlBDNCE/5Hk9wT2pGjMGIeUoJ5n0UzBNDS5oU
	j1eeXBu9q+pFY/48yN9vT7BM5ajn109gYR0lHc55teOCM9s5HCd0sv6Kj4eRDCE+
	YdCcJy6x/vEKLNAjS83U1X8q9EykLg5aVze4jRBDvKGz8NA2GglCvZgbAp/rWP/j
	xzYj//qBaCUAum/5C0PUt1Cex8iEwhMFOd7z2opY1kYC4Nc3aaA2eAivtZnUfKp1
	y5GKzVF0EDBLTSX+dXSetySvt3oZBOhIi9ETigXadY36wLcQZ06HDpE7XSU+lYPQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48uswd4nh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 06:41:27 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5826b0VP031126;
	Tue, 2 Sep 2025 06:41:26 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48uswd4ngx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 06:41:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5824tpS3019412;
	Tue, 2 Sep 2025 06:41:25 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48vd4ms65g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 06:41:25 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5826fO3N35389726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Sep 2025 06:41:24 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1AA758067;
	Tue,  2 Sep 2025 06:41:23 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED5305805B;
	Tue,  2 Sep 2025 06:41:19 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Sep 2025 06:41:19 +0000 (GMT)
Message-ID: <a359291c-e174-42db-a917-6a6146d280c0@linux.ibm.com>
Date: Tue, 2 Sep 2025 12:11:18 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] target/ppc/kvm: Avoid using alloca()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
        Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
References: <20250901132626.28639-1-philmd@linaro.org>
 <20250901132626.28639-2-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20250901132626.28639-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PeP/hjhd c=1 sm=1 tr=0 ts=68b69197 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=f7IdgyKtn90A:10 a=KKAkSRfTAAAA:8
 a=VnNF1IyMAAAA:8 a=tysFKKUIYcnshjHjJ6EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX7EGTCbxtoasi
 nnZA1huCUTIdgB47YWbQ0vIL4D/qW8+d+2T747U22pW4K5yGoLtJCX8bE7Wv5cNEZd1D2fwTx8s
 eSgMAUdcBVZ52UURkF9PGZYELgy6xoyf6UrM2SytYTPW1CdESsDih1zGG1tdaNb6Xt7y8lUGEWc
 VNwq9x9AVCHYfT28PVhZLHHGT2h38EZxsTYk2sYGif5kOU1S+AEEOR+YnVs7+2FFJu7FRskkFEO
 U6nhmNrn1yFSfwBHMW4zWy4zkpt1x4PjbUk+dxbLRP1K9wfP0E3LAZYAH7K6z/I4A6LfoDaV8/J
 59FhDUnVKj6nk7t2NPNXAMR5bR+c8K/c6pTSg1legk8UocBVwaul+feCAjKk3EqUatj4W3s4aER
 btrnp29R
X-Proofpoint-GUID: Qh0_1u-TOwhESZhLjjSxZ-sdMkOYSHnk
X-Proofpoint-ORIG-GUID: Ypq3pWnr6O9XAEJVymGjn3gl1jdUPYIO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034



On 9/1/25 18:56, Philippe Mathieu-Daudé wrote:
> kvmppc_load_htab_chunk() is used for migration, thus is not
> a hot path. Use the heap instead of the stack, removing the
> alloca() call.
> 
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/ppc/kvm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index d145774b09a..937b9ee986d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2760,11 +2760,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
>   int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                              uint16_t n_valid, uint16_t n_invalid, Error **errp)
>   {
> -    struct kvm_get_htab_header *buf;
>       size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
>       ssize_t rc;
>   
> -    buf = alloca(chunksize);
>       buf->index = index;
>       buf->n_valid = n_valid;
>       buf->n_invalid = n_invalid;

Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

