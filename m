Return-Path: <kvm+bounces-59566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEC8BC09A9
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A8AFB4E5645
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759A62D3A7B;
	Tue,  7 Oct 2025 08:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LIMsqHMx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1152F253F1A
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759825305; cv=none; b=OUxojDXNzdRnMmc4+PXXoTpNiQhrtIsmZI/SKb3KRF++Lya1C6lGHHniS9nP5bXrLY8iAZFxwP8oFox5DoAFF0b7fhlZ8AxZJTXdChM5ZrktzmDSvVNQqNnbbcM0/GaaJmYL6S4UQidCGx8MNX+/B8nzcmHcTYrByxyDnkNxd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759825305; c=relaxed/simple;
	bh=orAKP/AkvBxGh8qMGhixOabl+33cvLOk+vcLi/FXanY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KyWSTezW3i1h2qkZygwcWFa3LZIseutLT0eW4cVQ1y4knZrZMLjWw2ngQlU3hqElDUkqIHrQzPoTmEWS6Td5Uf6E8zjXQ8DXTQ6wwYxQPjA8juG6NWMxal2TKqP5OFvLyKio8PW4vEkH+ZvC0Qt8rGP30gRSk45RY+jrKEaCU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LIMsqHMx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596LB6rx018483;
	Tue, 7 Oct 2025 08:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VLbZ9l
	rl53cktF8fee/JmO2VF6SVh7rGt6cWw9GZJSI=; b=LIMsqHMxf0Oi1YlG7/2sj0
	5kDMsH5mn48fq0EKiuC85iWoGg3vq+EqOGH18INgVQeUZWym1croOeNdRxr0vxOx
	8toISGhF06Gb8L8U9A87iPmIZ1ZeLXKVPDsWx5h2vU4fVWejmcpa8ilC0I2ARK8R
	TNDhcGKicBKlubfK6AFAh8W3WWuoU6ytj4Tx4uocBMltKhJUnGMN87VwU4g+Uge1
	YnX7+aORI/ZSqYMJ1FQVYn40EB1SoKFuVyYodu1GcKUP2xxfvf7IdaIGTTCw6NLK
	67uUHdXucU6aqE3avSGCp3fThVN/GljiMuJegsovKxliI/FrgJC1KqqRcbhLjDvA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49jt0pdgn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:20:45 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59781Jw1015727;
	Tue, 7 Oct 2025 08:20:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49jt0pdgn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:20:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5974IXI0019627;
	Tue, 7 Oct 2025 08:20:43 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49kdwsaft4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:20:43 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5978KUbM27919040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Oct 2025 08:20:30 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B2B758052;
	Tue,  7 Oct 2025 08:20:42 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46C0058045;
	Tue,  7 Oct 2025 08:20:32 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Oct 2025 08:20:31 +0000 (GMT)
Message-ID: <43f8ed49-e4f7-4ca6-b41a-9b0fec7592c6@linux.ibm.com>
Date: Tue, 7 Oct 2025 13:50:29 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] accel/kvm: Do not expect more then KVM_PUT_FULL_STATE
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        qemu-s390x@nongnu.org, Song Gao <gaosong@loongson.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo
 <arikalo@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>, qemu-riscv@nongnu.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Chinmay Rath <rathc@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        qemu-ppc@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20251007081616.68442-1-philmd@linaro.org>
 <20251007081616.68442-2-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251007081616.68442-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XvT3+FF9 c=1 sm=1 tr=0 ts=68e4cd5d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10 a=VnNF1IyMAAAA:8
 a=KKAkSRfTAAAA:8 a=03iAlK1sdqs0WcEdBhUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=oH34dK2VZjykjzsv8OSz:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=jd6J4Gguk5HxikPWLKER:22
X-Proofpoint-ORIG-GUID: xnQ_0qJfHnIUBAlRV-3hHzVvxK1x_ndD
X-Proofpoint-GUID: hIF8Pz003LsaedGwZV756M8D2Oc0FYzs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAwOSBTYWx0ZWRfX50Mec/7F5fqw
 /a6Fo8NKgrKfcdrKfPF3P0/TXIHM02qMQxskhkidmyjb54lfmdVxzRkJ/ubkOYsnnW+3UWEJYN8
 nuZUedvWYSAWj6K8APm4mXfNsnSyjTgcyCe+s8sOleT6BmEl2B4kBjcghU86DX0nTTDR9cScwae
 cnIw1VbF0lUwnO72yRX5aPPy55T8aqUHb8X6hO+opsDHcOHxBTjx+bG96wBRGmenRxzBE2Q0U7B
 qulVyJd21f1fNb8q1rWSoX7Y6klADb10zu69TmyP7bMqCA25Yvc1YFzI2KQzO1BewHdTCgWh05n
 a0kM3kpF7bwMN7Jwxy1jLmeBjf5P6GsARUZkN9HY9vXtQGEhxHe4mHk464Q3Wd/8Z2JB2+A+teZ
 DrgsZaI2NQemJ4IAbZqwoMZ1uY+f3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040009



On 10/7/25 13:46, Philippe Mathieu-Daudé wrote:
> KVM_PUT_FULL_STATE is the higher level defined so far in

s/higher/highest ?

With that,
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

> "system/kvm.h"; do not check for more.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/loongarch/kvm/kvm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
> index e5ea2dba9da..45292edcb1c 100644
> --- a/target/loongarch/kvm/kvm.c
> +++ b/target/loongarch/kvm/kvm.c
> @@ -397,7 +397,7 @@ static int kvm_loongarch_put_csr(CPUState *cs, int level)
>                              &env->CSR_RVACFG);
>   
>       /* CPUID is constant after poweron, it should be set only once */
> -    if (level >= KVM_PUT_FULL_STATE) {
> +    if (level == KVM_PUT_FULL_STATE) {
>           ret |= kvm_set_one_reg(cs, KVM_IOC_CSRID(LOONGARCH_CSR_CPUID),
>                              &env->CSR_CPUID);
>       }
> @@ -801,7 +801,7 @@ int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
>           once = 1;
>       }
>   
> -    if (level >= KVM_PUT_FULL_STATE) {
> +    if (level == KVM_PUT_FULL_STATE) {
>           /*
>            * only KVM_PUT_FULL_STATE is required, kvm kernel will clear
>            * guest_addr for KVM_PUT_RESET_STATE

