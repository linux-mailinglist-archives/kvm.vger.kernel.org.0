Return-Path: <kvm+bounces-20722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E64E91CACF
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 05:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFD3F28471D
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 03:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717D51E536;
	Sat, 29 Jun 2024 03:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AFJCntJI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF61CD23;
	Sat, 29 Jun 2024 03:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719630719; cv=none; b=HT3okd+HNvBS0b7HTomoCv9vv1y/wa6v5xPeuxknhUMMUne2PpCPupwuHP7QPin8u4zW2aM7fdpzm0EeZu+h7wK/uCCr/qOW7/AWZO81dc2hy996s65W2tDvOFQwHUM6XGwve5V6IDKyexuTHT8n80NdLfA8yis4Oq/s5w8ynRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719630719; c=relaxed/simple;
	bh=aKBpZ08My08DhyEKDoddbUnLzq8Bq3qoZ8kug1Rp6RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z11XziHsPcT6RzEr27i3QGfLvT7KRKx5gfnUROPj93smRjuWanCXFMKhduW1IY9WgoW71+A9hO5M6xukSatiuHgs9sjt9FpxVd+gsusOm00tsejOevU+ijO2wR/wYqTMuvdxo/MhnfE0PVapj/D/IxhO0ZueX2lWFHQ+LhpX/eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AFJCntJI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SF4Omr016181;
	Sat, 29 Jun 2024 03:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ierJX8/a76esET0USDctKiD3wsmNiLXmoljeau/8JK4=; b=AFJCntJIsgtVLN54
	2SbeqKfyxxbHhwmy22h9PYpGxVO/ephWNlQS+7O/4ZD3DvQtkuTPHFr2B5gCWdz2
	TtsMvkaA+qEiJX38MzVmSWvNbi/qZ4FmXvumbJT2IYWbwXizxR02lJ1ASWPeiCu8
	EJQEp1vXjhd4Mupb0u9MLpfvdHN/G7HDDUByV/y/J7aJmB5xfyQ19Qe6T/70zGFz
	WXO/+SLC05A3xQIpM+x3rifTspjfMvcqNM+w0DOoDfPMT7TwcIPhI/fzNEIrl/Me
	Bm9I5CPiArTYPdgS7uQwqddq2+vvGoowCnb9WcBTxqwAnFMPekOAWoK2Humsk3F5
	gQ+7Fg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 400gcmgrxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Jun 2024 03:11:45 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45T3BiAB023184
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Jun 2024 03:11:44 GMT
Received: from [10.48.245.152] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 28 Jun
 2024 20:11:44 -0700
Message-ID: <c867fc1f-9213-479d-afa3-8210090fd2d5@quicinc.com>
Date: Fri, 28 Jun 2024 20:11:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: PPC: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
	<npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen
 N. Rao" <naveen.n.rao@linux.ibm.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20240615-md-powerpc-arch-powerpc-kvm-v1-1-7478648b3100@quicinc.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240615-md-powerpc-arch-powerpc-kvm-v1-1-7478648b3100@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: hHbST0myN4xe-SYZsq5Y1OsqX9aqm2RG
X-Proofpoint-ORIG-GUID: hHbST0myN4xe-SYZsq5Y1OsqX9aqm2RG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_18,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406290023

On 6/15/2024 8:18 AM, Jeff Johnson wrote:
> With ARCH=powerpc, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/test-guest-state-buffer.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-pr.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-hv.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c               | 1 +
>  arch/powerpc/kvm/book3s_pr.c               | 1 +
>  arch/powerpc/kvm/test-guest-state-buffer.c | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index daaf7faf21a5..e16c096a2422 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -6519,6 +6519,7 @@ static void kvmppc_book3s_exit_hv(void)
>  
>  module_init(kvmppc_book3s_init_hv);
>  module_exit(kvmppc_book3s_exit_hv);
> +MODULE_DESCRIPTION("KVM on Book 3S (POWER7 and later) in hypervisor mode");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_MISCDEV(KVM_MINOR);
>  MODULE_ALIAS("devname:kvm");
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index a7d7137ea0c8..7c19744c43cb 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -2111,6 +2111,7 @@ void kvmppc_book3s_exit_pr(void)
>  module_init(kvmppc_book3s_init_pr);
>  module_exit(kvmppc_book3s_exit_pr);
>  
> +MODULE_DESCRIPTION("KVM on Book 3S without using hypervisor mode");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_MISCDEV(KVM_MINOR);
>  MODULE_ALIAS("devname:kvm");
> diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kvm/test-guest-state-buffer.c
> index 4720b8dc8837..10238556c113 100644
> --- a/arch/powerpc/kvm/test-guest-state-buffer.c
> +++ b/arch/powerpc/kvm/test-guest-state-buffer.c
> @@ -325,4 +325,5 @@ static struct kunit_suite guest_state_buffer_test_suite = {
>  
>  kunit_test_suites(&guest_state_buffer_test_suite);
>  
> +MODULE_DESCRIPTION("KUnit tests for Guest State Buffer APIs");
>  MODULE_LICENSE("GPL");
> 
> ---
> base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
> change-id: 20240615-md-powerpc-arch-powerpc-kvm-9267fc8b0a8b

Following up to see if anything else is needed from me. Hoping to see this in
linux-next so I can remove it from my tracking spreadsheet :)

/jeff

