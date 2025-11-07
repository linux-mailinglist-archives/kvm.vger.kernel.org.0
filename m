Return-Path: <kvm+bounces-62274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 92953C3EA5C
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 07:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B08E4E8640
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 06:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4802A303C97;
	Fri,  7 Nov 2025 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GU9Gr9xd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF8A303A29;
	Fri,  7 Nov 2025 06:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762498046; cv=none; b=BDTM5oz9A4og+8cmmf7s7cO+iL+iRtmMqC0ZTubikvOTTxhhxk+GaR/4AgXJ39BbsywthknxERtaddEz7MYDQhJRsSiPiu8rl5ECl0kGKvVYIE0k6DwGPnuesv/afNsW4LshRvMRJZesnXKN4vKI7hFZqH4Z3nC4VbWj2z9wdzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762498046; c=relaxed/simple;
	bh=penEAhMr/GSlDiIoiSg0G2G27IVjdQw0U9mEKfgNQJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttNkaBUL0YhjqqgePSpXuASHGt9DG3lkIvmw0Z1zITUmVfAQulSA3udMlD4Lyhcw0ac0/HU+dfU53AqFZUyacyBtmywDLdpBr7S+GyaXZnrrvM5cP5/eQMv3OOWsAVJ0hA4OXnC0uasnX2R3lkyMGHl4E+ipN+4PMa+n6Y1D8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GU9Gr9xd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A73HaUm007895;
	Fri, 7 Nov 2025 06:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PLUZG9
	h6Zl8Ih1CPrIic/9f5ZXGQlni37186BXQHqzs=; b=GU9Gr9xdywoIaU432NJF72
	caoPYgvW8ADQrtHP5U0GLV9XoUb/9s/QGdS8lJb0KHjLGgIJGkRb4rKySSaE/jk8
	bNjh4NXUCnItarYVH/oxiZHK+zhYryDSOfThNYSum8wCiTThQc9KIG9WksXEDh6x
	uGVi/V8Svcp1Yusx0q51zzZVhbnBnMKHOkB70U241r8uIsiQddSttNwuW6/bpPOl
	TYx1Yyu60ksJvqNkbfqsdDNnqK0+oXVtj8JvNdJuGVzoaiMQ8NdtHiB01LQHDHYv
	n0TKspAzQvIZJZMEeeT+K9OGyD5S+Q+9sDyH1WtyWtK+C3R04eIbRKOhFM0Jzv5Q
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mrj5ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 06:47:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A76NZJJ025605;
	Fri, 7 Nov 2025 06:47:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5vht1kqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 06:47:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A76lHHl48890344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Nov 2025 06:47:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 156A92004B;
	Fri,  7 Nov 2025 06:47:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E8D820040;
	Fri,  7 Nov 2025 06:47:16 +0000 (GMT)
Received: from [9.111.44.147] (unknown [9.111.44.147])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Nov 2025 06:47:16 +0000 (GMT)
Message-ID: <a45e260a-ce8e-4145-97ce-1e1cd684f2b8@linux.ibm.com>
Date: Fri, 7 Nov 2025 07:47:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: Check alignment of BSCA header
To: Eric Farman <farman@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20251107024927.1414253-1-farman@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20251107024927.1414253-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 01UTNO2J2sEewDrfu3HEhVuYiupfJAX3
X-Authority-Analysis: v=2.4 cv=MKhtWcZl c=1 sm=1 tr=0 ts=690d95f9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=-uTLTygCCHB6PFIRPhQA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 01UTNO2J2sEewDrfu3HEhVuYiupfJAX3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwMSBTYWx0ZWRfX+8D92CdhIyE+
 ZpsvNk0mXt5G5X4DhYC2IWJ9MKLYfONM0ZM93iCd2t/RWqv4tIwev09+QnKq5aFhMLvZGyTZQoP
 3wcONxeDvVmCAUDeB38HwwTUuCU4hsqxmVhX1AN1i9HvSWGgCypJXZTm1BhWKcdYJuvnk2YDfPV
 tfqKxT3Ji/zW8KgObp4wFfrbmG02v8KlgvuH87TnfHd6Czn4whmHA5nlvaf7g+U3N//yvwKA4k6
 ode+LHUoTN5UK/jD99WxxAsx6eX1s1vl0W8MAoBsDlz6+mP2RU0OQVYUcuyE4Ocf3ri25TsgJNx
 8jwepz9iDngZO5u7l6Vq3WLnufquy/pXluSEvoTXhxOoESdyAah9L4hbfMvvin8jFWUW/QlicSI
 XHtQwewLEZLtQR04ekNMq6dSNqHWzg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010001

Am 07.11.25 um 03:49 schrieb Eric Farman:
> The VSIE code currently checks that the BSCA struct fits within
> a page, and returns a validity exception 0x003b if it doesn't.
> The BSCA is pinned in memory rather than shadowed (see block
> comment at end of kvm_s390_cpu_feat_init()), so enforcing the
> CPU entries to be on the same pinned page makes sense.
> 
> Except those entries aren't going to be used below the guest,
> and according to the definition of that validity exception only
> the header of the BSCA (everything but the CPU entries) needs to
> be within a page. Adjust the alignment check to account for that.

Right, we do not yet support sigp interpretion for vsie and the
validity is indeed defined only for bsca header alignment:
---
The SCA header crosses a 4 K-byte boundary
(VIR code 003B hex).

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


--- 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 347268f89f2f..d23ab5120888 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -782,7 +782,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   		else if ((gpa & ~0x1fffUL) == kvm_s390_get_prefix(vcpu))
>   			rc = set_validity_icpt(scb_s, 0x0011U);
>   		else if ((gpa & PAGE_MASK) !=
> -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
> +			 ((gpa + offsetof(struct bsca_block, cpu[0]) - 1) & PAGE_MASK))
>   			rc = set_validity_icpt(scb_s, 0x003bU);
>   		if (!rc) {
>   			rc = pin_guest_page(vcpu->kvm, gpa, &hpa);


