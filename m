Return-Path: <kvm+bounces-70343-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJ+HMie+hGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70343-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:58:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1CDF4DBF
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AEDB302292E
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 15:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC121413249;
	Thu,  5 Feb 2026 15:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HSuWCLqg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FRVe9mF5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFA142B750
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770307100; cv=none; b=Ik6EVF6K3tLapIpITtefxSQVVWYng5StMnZAxBT09kF+LeY8m8UM6GcFcj+QvzThNjxY+sF+pKndlneGta9hdi4nO5N1UiO6JV5VVxktkSVENNYlR3jKc8jDlJ3oaIn/nznJyckejZq5otEEvs+wz9Icms+5jRrqDyC0mVkG5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770307100; c=relaxed/simple;
	bh=/fvPzUpDUHLCfd+m6YMOUQH3DCjmOR2ccQob3Ksagr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpJ+fVltHS7b9GhiegizpaA7Vc/svVgekNbaNG73h7e5BGKFBq1W2fBy/Sf5png8mI5SmD6hgFCvsjWSZLHsO8FVUTPIL6l32YYr1dYgbBUydif0y+0XvDJGzz8XhPnROULqPfhcINSYaOiYmZ6FSthWsPj3IO4+XbOGPJTbwrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HSuWCLqg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FRVe9mF5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615EI499890430
	for <kvm@vger.kernel.org>; Thu, 5 Feb 2026 15:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=reJd7/At3u/sqytH15vAL/oA
	6cLufQfOxqNK9KuV5k4=; b=HSuWCLqgch53TzV1zbT0mlcPKlCQp7Qr4bLHE7+Y
	cNWEZhnnKeTTIXTtOG0K1tnYZB5zwCPZJdFy3wxXmTNOIqBapUAI+E1kSNggsZ+S
	M+qgKYok/LypjwqRxRmeb7a4JlLbO6X+LVc0ZWi8ZSKqzFa4GbD4ldowA4QnKEwM
	5R2Im+xhHxd2nBx2ti+HNGv7gBq3G0AAL7SnqCkirBRopRZL2MQOrsp/NTI73sfc
	L0Cgus6rjordj1lLzWhVBoiL7nLMcmdFxplw+SrMIYSiEp6cEny74WFuGYhaP9jB
	Wz7EIEBLiG6A/J8hBEyBBesMvViHFFXW+ljtr9i9sQkNRw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c4prx9kua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 15:58:19 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2b724ff60e6so982053eec.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770307099; x=1770911899; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=reJd7/At3u/sqytH15vAL/oA6cLufQfOxqNK9KuV5k4=;
        b=FRVe9mF5PdSvYcYJKOVR7M7O68IqjM34e0ZYyMEf9OMLwL0eRf/zMUUfgvjyTwcydL
         GpKGxQ0k8PLKH578GxcP4S3NI7Ox9d+CNMLRy/J3XeeyEsgs4/nNKjyynGi/A8YMzii9
         8w/brACih0N1OB6+EXyEW336LUeWBscI+Hrz0gKd51+/1DLURo2H1bcQpIFsR8VP+rMS
         cym4ICvQ8W/YUJlJ+6btTaoG7F6wq0tuDIjdoSiYvsmcCnA0T9IFTXHAre8/jMm+Qh1E
         1YdFGS7V8kbf91WtB9f/VU+XYkhUC7LvkzYFM4lIT+wObBZE41XtU0JIRS/XW0oHG6+r
         ag6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770307099; x=1770911899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reJd7/At3u/sqytH15vAL/oA6cLufQfOxqNK9KuV5k4=;
        b=B9nKJaXJUmIVRxL/tkw6eDyeirPlIxypTsTqJZVL3iWnMkvAZ9C5225mcLEMVAPzG4
         mPzCt2R1QK0FszpleIVAZ2Gp7tUHkgCXTbphZu+n6cAZLnVcbmOxSV1ZrmurH213Wk8Q
         +M0oyOtHtGCBFkWGohWChIw2woHbmIJeQyt/4XYTvp7cAUngBSW9tSGjTBN18ttp0HVz
         d7eIJ2IuFCAL1NeFip7XPJNg0tkOltu/3E1nYeDmPZRD+Tle50j+p0wjetP+30BkOrOC
         08FMEk8m60vYF5nM0ABqETfVmKIuUx1VwfObW5NSocDn/4IiSMZlFih3/qHMQ4BlQDhE
         5VXA==
X-Forwarded-Encrypted: i=1; AJvYcCUvXhJ5oBShCAKHaSX+xWc1HlXPRDpE7o7k0R89ZRfez2Z/AWKQ88ulV3ISawvmVOEiCYM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3LMklkILywS6Pi9wYC8cn42K5XhpDLvmauddCZ7HMrrY/9vox
	xF3uZaTRD3n8Pfw30hcevmVdwYzeDRNSspB4KzsSVjZa+NRIRia5PdFuWifHwbZXBI8QFpYDmpZ
	6P96AU/WAP8DWCUdO5W8Kg+HE/y5UwyO1ftmT0nY5/sEs5VmCoyz6usA=
X-Gm-Gg: AZuq6aLGXZcYmwuX/a0zvVIwS/h3fEG10qJBL1iFzTdTVTM01dmtxGW8ZFZVPKH12Fn
	psazEHoixPgdMq4ffyd9Rbnjy0K2Oz4qcM2SsOx+qWTnvD/iaMf6f4ontnDiF0si1QQ1sqan3SA
	MXqJzIQFwGpk4njgAvwzaSxG0+SiC019LeZkDBG+YfQdMoKPybBuVxhCcgUXDsmmMolSdGK+dYc
	3jyCFPWZIhhw3BGKwuFYz6RP0B0T9TIqhM1ZMeH+01qF4BrDJGuq/wA0phgGz+YMAugMq1ZoXHa
	nFBox1GQc5CEw/PUbQnt85KAOQw7QAHXbJ0PRCYX3O8tAaJ7PxX/HmUZzAGKgpxl2NjNof+Ajjb
	3z3rz/f2vt7mIAgKArGI=
X-Received: by 2002:a05:7300:cd8d:b0:2b6:fa0c:6c44 with SMTP id 5a478bee46e88-2b83291cd6dmr2805956eec.12.1770307098406;
        Thu, 05 Feb 2026 07:58:18 -0800 (PST)
X-Received: by 2002:a05:7300:cd8d:b0:2b6:fa0c:6c44 with SMTP id 5a478bee46e88-2b83291cd6dmr2805941eec.12.1770307097841;
        Thu, 05 Feb 2026 07:58:17 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832fe59fasm3427697eec.34.2026.02.05.07.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 07:58:17 -0800 (PST)
Date: Thu, 5 Feb 2026 09:58:15 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kselftest@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v6 2/2] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem
 alignment tests
Message-ID: <gcspbbvqkr7y53c4ytkqqycygkcqkiakle4aelq2z7nsnlyegl@addv4v655cbg>
References: <20260205010502.2554381-1-xujiakai2025@iscas.ac.cn>
 <20260205010502.2554381-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205010502.2554381-3-xujiakai2025@iscas.ac.cn>
X-Proofpoint-GUID: SEqVg6LnGBn_T31LY49LNd_5Tfk06i9A
X-Proofpoint-ORIG-GUID: SEqVg6LnGBn_T31LY49LNd_5Tfk06i9A
X-Authority-Analysis: v=2.4 cv=eLkeTXp1 c=1 sm=1 tr=0 ts=6984be1b cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=reGFDpqf7T0RaJXXVMIA:9
 a=CjuIK1q_8ugA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDEyMCBTYWx0ZWRfXwrVuRMKmBbsg
 U7QmF4ikKPiB/sKBwpY9n4qWh0zs3GAbtMbvFsHqgUmBIlF7f1AvSKyBjWPsYPCvV6n+zinY4Ab
 RfLndkHmeSFGgXrr38gtx+TbQnOiKyai2UqglMKnJZAFy/abjlJalS9JrNZY9ocI0AhDIt/CbBn
 bQQ/Hnx4qKIv1Jbi4hD9Xt5c6nTAGpbCS2WyXkuN6m/QwQhAeOl89/siJNtGhOTWYnBJ6Hvz7ES
 uCGN+ojiEojrVEN/nwKux4HSorIMGkbbYn+aKsq8i0k919hPz+7yZU8RNxuQYhrThb6ui+OTmj5
 LhcZvmuOJRD6sYRfFaYQCU1WSS1YlPUE/a+rnbY7wrInNdRSOdSEhcfUsoDm/MA0A/FzPamTdC0
 I37fLBMlgF2q6xTKX2Aoj1dI59cg7Ca8eepFX9/5AChpNiZE/zJGdfd6dRahQ1PNwTFEYIzz//7
 RdeKEJ9aNw3GW8tOsfw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_03,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602050120
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70343-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,qualcomm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3A1CDF4DBF
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 01:05:02AM +0000, Jiakai Xu wrote:
> Add RISC-V KVM selftests to verify the SBI Steal-Time Accounting (STA)
> shared memory alignment requirements.
> 
> The SBI specification requires the STA shared memory GPA to be 64-byte
> aligned, or set to all-ones to explicitly disable steal-time accounting.
> This test verifies that KVM enforces the expected behavior when
> configuring the SBI STA shared memory via KVM_SET_ONE_REG.
> 
> Specifically, the test checks that:
> - misaligned GPAs are rejected with -EINVAL
> - 64-byte aligned GPAs are accepted
> - INVALID_GPA correctly disables steal-time accounting
> 
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>  .../selftests/kvm/include/riscv/processor.h   |  4 +++
>  tools/testing/selftests/kvm/steal_time.c      | 33 +++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index e58282488beb3..c3551d129d2f6 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -62,6 +62,10 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t subtype,
>  						     KVM_REG_RISCV_SBI_SINGLE,		\
>  						     idx, KVM_REG_SIZE_ULONG)
>  
> +#define RISCV_SBI_STA_REG(idx)	__kvm_reg_id(KVM_REG_RISCV_SBI_STATE,	\
> +						     KVM_REG_RISCV_SBI_STA,			\
> +						     idx, KVM_REG_SIZE_ULONG)

We don't need this because...

> +
>  bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
>  
>  static inline bool __vcpu_has_isa_ext(struct kvm_vcpu *vcpu, uint64_t isa_ext)
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 8edc1fca345ba..30b98d1b601c3 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -209,6 +209,7 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  
>  /* SBI STA shmem must have 64-byte alignment */
>  #define STEAL_TIME_SIZE		((sizeof(struct sta_struct) + 63) & ~63)
> +#define INVALID_GPA (~(u64)0)
>  
>  static vm_paddr_t st_gpa[NR_VCPUS];
>  
> @@ -301,6 +302,34 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  	pr_info("\n");
>  }
>  
> +static void test_riscv_sta_shmem_alignment(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_one_reg reg;
> +	uint64_t shmem;
> +	int ret;
> +
> +	reg.id = RISCV_SBI_STA_REG(0);

...here we should use KVM_REG_RISCV_SBI_STA_REG(shmem_lo)

> +	reg.addr = (uint64_t)&shmem;
> +
> +	/* Case 1: misaligned GPA */
> +	shmem = ST_GPA_BASE + 1;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == -1 && errno == EINVAL,
> +		    "misaligned STA shmem should return -EINVAL");

remove the word 'should'

"misaligned STA shmem returns -EINVAL"

> +
> +	/* Case 2: 64-byte aligned GPA */
> +	shmem = ST_GPA_BASE;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "aligned STA shmem should succeed");

same comment about 'should'

> +
> +	/* Case 3: INVALID_GPA disables STA */
> +	shmem = INVALID_GPA;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "INVALID_GPA should disable STA successfully");

We're not testing that STA was successfully disabled, only that all-ones
input doesn't generate an error. So the message should be along the lines
of "all-ones for STA shmem succeeds"

> +}
> +
>  #endif
>  
>  static void *do_steal_time(void *arg)
> @@ -369,6 +398,10 @@ int main(int ac, char **av)
>  	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
>  	ksft_set_plan(NR_VCPUS);
>  
> +#ifdef __riscv
> +	test_riscv_sta_shmem_alignment(vcpus[0]);
> +#endif

We like to try to avoid #ifdefs in common functions by providing stubs for
architectures that don't need them [yet]. So we should rename this to
something more generic, like

 check_steal_time_uapi()

and then call it for all architectures. Actually the other architectures
can already make use of it since both x86 and arm64 do uapi tests in
their steal_time_init() functions and that's not really the right
place to do that. I suggest creating another patch that first moves those
tests into new functions (check_steal_time_uapi()) which only needs to
be called once for vcpu[0] outside the vcpu loop, as you do here. In
that patch check_steal_time_uapi() will be a stub for riscv. Then in 
a second patch fill in that stub with the tests above.

Thanks,
drew

> +
>  	/* Run test on each VCPU */
>  	for (i = 0; i < NR_VCPUS; ++i) {
>  		steal_time_init(vcpus[i], i);
> -- 
> 2.34.1
> 

