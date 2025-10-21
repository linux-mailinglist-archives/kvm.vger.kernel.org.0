Return-Path: <kvm+bounces-60659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF11BF6163
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A843B90AE
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FDB32E698;
	Tue, 21 Oct 2025 11:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aqoLqVmm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE702F12DA
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 11:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046620; cv=none; b=TtuMZQZJ2Eofm3AsoVD8sldyocalJ3Y0D38Les1mntAsoYZKYok/hdC9SFb2ERPzyq4zNL2RY1Uxj6EOFS6zgced7eBVlk36qNwBw/vebGncgnPS+YDWdXo5iMYlB/Na9trPryJpWdr7A3l/I7uYExHH8z8uAIHYIOL9uyDm9ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046620; c=relaxed/simple;
	bh=RVRv/jecUHF17xDjX3dBRl6+LpjYKbdzGIL5GtX/H74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=An9lLFRixgeVm1fC6ux7a9J+p2rqW6nQtGrf+W7uJADExg6mAN0CkuvDe6f1Na0MxegGVoeQS519F+Zkmyq1ILza3A2/Y6mpoTy2Zn+bEC022hpfrqt3sQON6UxhUKEnu6R31/A3aydG3dzor6SaMHlwazDJ/vNQhqISCdMyQ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aqoLqVmm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L1wCNs023518;
	Tue, 21 Oct 2025 11:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qcZU/p
	N2tuV/PgXpaqeha0Av0//BrntA0yr7jG0T988=; b=aqoLqVmm2++SYMhgCXXtZC
	tzlYEP5sGUrv1l8TA5hZgs+uGmb1en5qbgBtvp0zI7gS77J9ubdjk6J9JtXDI5fY
	iVRdonBI1WsEUbUiDC+6tEx/XIy53aEuZHpvsNYcBaioWWO2jr68ey/NA1d2yqnO
	28ktreXHO5OI7w+qoPzslANhyB8RCfoYuUClWc4dgYmmElJ6+imo3wBE3PeyMz9M
	evX0Ui11enT2F2OWnqwJcwuKkNGxTYARAv6MaAKidPzE+6mIh3bxnD2k1wNVlGfQ
	US3EchpFSNm0s6N26IpQawFyGSvXp50FdtKX3FmbGTd4bAinX6CEWt+5/yPFFQ7g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vncbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:36:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59LBWdM1005627;
	Tue, 21 Oct 2025 11:36:38 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vncbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:36:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59LAqrok014650;
	Tue, 21 Oct 2025 11:36:37 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vn7s2nfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:36:37 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59LBaa0T10945382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:36:36 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3D245805C;
	Tue, 21 Oct 2025 11:36:36 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1988558093;
	Tue, 21 Oct 2025 11:36:34 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 11:36:33 +0000 (GMT)
Message-ID: <e9cd32c2-7e38-4d7f-aa97-138d53eb530d@linux.ibm.com>
Date: Tue, 21 Oct 2025 17:06:31 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] target/ppc/kvm: Remove kvmppc_get_host_serial()
 as unused
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-7-philmd@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251021084346.73671-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BE7zzDZZhZ4KivfZNgIXzhbg18U3mJqQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX7h2PyKMBnTfe
 rzyha/HZTJaKYbxtufID4zk0PGomNqAZ5Wpb51fHIV4YBpNWPZUHOZPrVAQX48x4f/+DvuTb4BM
 hQFCXxWZr9xuM/B07g2KNSTryAG2Aqwj5NP8KVx95xfufVEuEYNP1SuK0oHTqVHgEEah0MzP0Vr
 jtN4dLmLUKrGvO7MliJhztcPJwHmNpXBxnux4V2FkqbLbh7H0RlDqGw2DD3WjRdz0b8uYxD9OOx
 WZfBUkiD6FvL21hZTHSKJjZ3kvJR6cI3TDiqW6KCENlnbKJ0dLH1R01Csk+NoM9LN6PVSaBvuCB
 Y7GlvtDzPoYpdwmwNbYfXNiD7yITVBk21hMluupNILN4/GMXAnUGvWUQPFNMiDbS8sgj9yEsnnz
 K6VpqBLmZum6Ac6ZnZojZC77RJ5qHQ==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f77046 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=cvRlsbrwNaNk8C4OaOUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: sjzkwcplo6_88gfInGQk4ReUpLT_v9uY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/ppc/kvm_ppc.h | 6 ------
>   target/ppc/kvm.c     | 6 ------
>   2 files changed, 12 deletions(-)
>
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index a1d9ce9f9aa..f24cc4de3c2 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -22,7 +22,6 @@
>   uint32_t kvmppc_get_tbfreq(void);
>   uint64_t kvmppc_get_clockfreq(void);
>   bool kvmppc_get_host_model(char **buf);
> -bool kvmppc_get_host_serial(char **buf);
>   int kvmppc_get_hasidle(CPUPPCState *env);
>   int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
>   int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
> @@ -134,11 +133,6 @@ static inline bool kvmppc_get_host_model(char **buf)
>       return false;
>   }
>   
> -static inline bool kvmppc_get_host_serial(char **buf)
> -{
> -    return false;
> -}
> -
>   static inline uint64_t kvmppc_get_clockfreq(void)
>   {
>       return 0;
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index cd60893a17d..cb61e99f9d4 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -1864,12 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
>       return cached_tbfreq;
>   }
>   
> -bool kvmppc_get_host_serial(char **value)
> -{
> -    return g_file_get_contents("/proc/device-tree/system-id", value, NULL,
> -                               NULL);
> -}
> -
>   bool kvmppc_get_host_model(char **value)
>   {
>       return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
Reviewed-by: Chinmay Rath <rathc@linux.ibm.com>

