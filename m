Return-Path: <kvm+bounces-57974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4196EB83043
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB1713BE1BF
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D79427AC4D;
	Thu, 18 Sep 2025 05:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YLxqwWzL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8F34BA5E
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 05:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173594; cv=none; b=Hgranrtsv2lw9qclE1gpbxlQktq/tdz72vNLuGAMNAOtFkh6sENGtzr5Smbnd0F464he5RKNsYKQrZQL1LaYzq2Rv0f4d82op/J+eyXPTGODu7/IT76sNosAdAA7wqdT0o0BE1ZUKXxPxBmDnMFy71sM9Zjqs2z9oRiTbSQv8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173594; c=relaxed/simple;
	bh=cTfMtqzGi8KGlab8LpIVvNVbH09+sEVBYVHuPF6ZO7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxBzMRzTCjhe9CFErOJbjI3MGd/8CZAG/MQ8KQ4ecWYt9DDAHOkC8+yaAYdnyHO65qXSwFb8HjyN4YOdnVZgZ7QGFnNx04KduGxkcBoHi653Np3DoxRZWRdLwAjHfUoxcKjFGGAlges94HEqH7dbQQRmHq3620n8KXFuBWSuq7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YLxqwWzL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HIntOn024759;
	Thu, 18 Sep 2025 05:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Tym2Fa
	rKQvNv9yqqv9Czl9QNag9MxDRdPdODoybXmBU=; b=YLxqwWzLrXfyukG8JKOrOO
	FkqMrBRTw4R52IcRrLwu5cu4MhmOYe84D/B591gOHLLv68kUmtNltnY47MvOf45D
	3qlumgIkKMqWZ3pyjD8LxcBvKmHzHx4ybA2l1jQM5FcSuDmIWj+h8Xccd3T2SGKe
	1W58wTY0HblQFxv9/JScElEynXf6pkqptCpzNFYGl8BCvvNJp6VOciy35NiA98SB
	l7jp+zzWjmKn+eHxVaTAsG3TYIRftafKzaiu4buXDkSDJocqCUFRh0VNlSHn6aeh
	T6IgztdLx+Pz0QtjKbXouyVKQO+8c/s1ifRoEdSXd4PEiqKx9CMxLOe24ilZaloA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qqqaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:33:02 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I5Vk3e007389;
	Thu, 18 Sep 2025 05:33:02 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qqqau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:33:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58I56e13005929;
	Thu, 18 Sep 2025 05:33:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxud8mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:33:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58I5Wvbb34407052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:32:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D04FB20043;
	Thu, 18 Sep 2025 05:32:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AB9D20040;
	Thu, 18 Sep 2025 05:32:54 +0000 (GMT)
Received: from [9.39.22.243] (unknown [9.39.22.243])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 05:32:54 +0000 (GMT)
Message-ID: <710a12e1-9e7f-4a4c-9d8e-a78aafef33bb@linux.ibm.com>
Date: Thu, 18 Sep 2025 11:02:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
To: Gautam Menghani <gautam@linux.ibm.com>, harshpb@linux.ibm.com,
        vaibhav@linux.ibm.com, nicholas@linux.ibm.com, rathc@linux.ibm.com,
        npiggin@gmail.com, pbonzini@redhat.com
Cc: qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250916061753.20517-1-gautam@linux.ibm.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20250916061753.20517-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fFW8kw7t1A5wOlByF8ymsS2jn7aOdjXn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX6Gq+sNE2Rdeq
 rfWEA9MPWqs+WaS1IJjM/zUItBs5BpAvLtllRxQxKFbt2yDYuNSLy1CfIq86UHNQNSQs0QGBfaK
 H/xw7TPVcqauWGJERnp2lzPgaCvmEJGzvGsPJo2ha1h5TsmoZxZiW97nqF90WSbEsLzjP5S/14U
 nXKhjlOdZRSMToXRJhdLES6Pza6Ebt68tYiH9HakqvVGGTFxAHz7IRN6FnO+HKkf2U1i1vxVlfQ
 Mc7tktCnS1zhRZuTUw82mY11DuA3pFOHssNQ5QPCpOlVgvNYw+mnDv6PDl/9F5jzQ0x3R+zHVdw
 vY409DxEJ0U0Uc7vhXAzxJjk31bvbeXA4pgaNGl+VyPAMImCNwtEcAuIRjxq7Hj2Zh85yBLvWyM
 ghaPm9KP
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cb998f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8
 a=29iC0fHVu2loanGQV3oA:9 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-GUID: el1Ndk_JHd2omE8c8RV7x8hl_22wmdxM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On 9/16/25 11:47 AM, Gautam Menghani wrote:
> Currently, on a P10 KVM guest, the mitigations seen in the output of
> "lscpu" command are different from the host. The reason for this
> behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
> hcall, QEMU does not consider the data it received from the host via the
> KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
> spapr->eff.caps[], which in turn just contain the default values set in
> spapr_machine_class_init().
>
> Fix this behaviour by making sure that h_get_cpu_characteristics()
> returns the data received from the KVM ioctl for a KVM guest.
>
> Mitigation status seen in lscpu output:
> 1. P10 LPAR (host)
> $ lscpu | grep -i mitigation
> Vulnerability Spectre v1:             Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
> Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

<snip>

> [1]: https://ozlabs.org/~anton/junkcode/null_syscall.c
>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> v1 -> v2:
> Handle the case where KVM_PPC_GET_CPU_CHAR ioctl fails
>
> v2 -> v3:
> Add the lscpu output in the patch description
>
> v3 -> v4:
> Fix QEMU CI build failure
>
>   hw/ppc/spapr_hcall.c | 10 ++++++++++
>   target/ppc/kvm.c     | 27 +++++++++++++++++++--------
>   target/ppc/kvm_ppc.h |  1 +
>   3 files changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
> index 1e936f35e4..7d695ffc93 100644
> --- a/hw/ppc/spapr_hcall.c
> +++ b/hw/ppc/spapr_hcall.c
> @@ -1415,6 +1415,16 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
>       uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
>                                                        SPAPR_CAP_CCF_ASSIST);
>   
> +    #ifdef CONFIG_KVM
> +    struct kvm_ppc_cpu_char c = kvmppc_get_cpu_chars();

Callingkvmppc_get_cpu_char() before kvm_enabled() below looks

counter intuitive. May be move it inside and handle the error checks

accordingly. I don't see any side effects of it here in this patch though.

Thanks,

Shivaprasad

> +
> +    if (kvm_enabled() && c.character) {
> +        args[0] = c.character;
> +        args[1] = c.behaviour;
> +        return H_SUCCESS;
> +    }
> +    #endif
> +
>       switch (safe_cache) {
>       case SPAPR_CAP_WORKAROUND:
>           characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 015658049e..28dcf62f58 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -93,6 +93,7 @@ static int cap_fwnmi;
>   static int cap_rpt_invalidate;
>   static int cap_ail_mode_3;
>   static int cap_dawr1;
> +static struct kvm_ppc_cpu_char cpu_chars = {0};
<snip>

