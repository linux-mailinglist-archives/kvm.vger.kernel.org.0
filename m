Return-Path: <kvm+bounces-71708-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBcFOdEpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71708-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:44:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 195C818D9AA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A4FF314883A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFE234E777;
	Tue, 24 Feb 2026 22:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XX7g7Ft0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Is9jJrgE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D3534BA4B
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972560; cv=none; b=siD7SyX6d/MwnfHodcMuppQlgOJrw0pfgxfEFis7sVAzEA70pMZPCZ7vl8Xu8DTPvWKLVY3ZcFhrfQ6Hcjm2+vCuSNe5hG5I9tt85TWeJMfiXj38Z71O3MBMtA9IAEx9qEShp86gmNclcLL3w5oftxgvQfjzJqQIZJpQ6pjIiTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972560; c=relaxed/simple;
	bh=7EwQ6oQQyIRq85yz5opuGyABoTjNzwzriqGwJQ6cioo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0TSMrhcTi2nVCOkasASMY60aABwUkf4++EnhEUtfT20bj71vnptdxuFR3zgIQDVFnhOsF1DkC3r8BVSuH3cXuQjyV7wthWljPPupH7Q+o956srZKPauhuUy7zCjAYJELvtxC1q3skV6aRoadyne7Dq35vJjys78zbea444IhoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XX7g7Ft0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Is9jJrgE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OL5VO52432693
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=jl3/kGLy/uiPn4E9pCww6rxR
	H2A13SEeo46Ae3ywkm8=; b=XX7g7Ft0xLvppEfCX8r7ER8OMh4f6cTzRW7dZQh4
	mdVLfHdvzZ4Jm0VmMGs8S9EI/Y4DHbe+bTNRbQ19fQMgyH5CpiCyPjfFuMxuABHD
	Y+2AuJ2RnGRO5Zuj6YZ2kw+kocvRKVcnmxMDub3GHTYW9JIwaknLrLFqaQaq33Px
	8iZomqe07aMpgVANr0o5rXVVmWycHRPgu21YvPrlx9DAxvyaACW1w0rGd/pamkWD
	e3EAoijW0pBfyEBlmqhQjggxFPHqdeLBvsYaFO/ibdLuHgqc30E8qeVAwsFxgb9w
	3GaMKCADAWcLiQ4n6lGVSB2mWQQno3Hftd5NcV706zjxgQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chekj9g38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:35:58 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2bd2a2028c5so8851400eec.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 14:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771972557; x=1772577357; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jl3/kGLy/uiPn4E9pCww6rxRH2A13SEeo46Ae3ywkm8=;
        b=Is9jJrgE3WnHdcO6sropwSKdQe95qwSAzscLMyWlRWZ0YZ3mCPTWnWpkBnwf/AHJja
         ccKfX/OK92sMVvGrWQXGLSreRWjjnqF4fnQy5GFonfOSN/cCA60qIOVhqFmEoPlbCOMn
         VH2D+zEfJyX8bJYBQQ02r8f/rNW1iGswGmcPJ0Ibj8xXBxNq+LZsn1gz/6edhOzWgGfR
         ODTI/s23Hs6Uw/sAVTvwI9Z1YWSP0EGCMDN0SW/CJSpSIWVjgN81eAy9gpIvpU67QpkF
         Ut6KAtWfw4wYuHc3SC1o4xUEG8DyHNccIFfTOsMxMjEovD+QHWwbDEBaCyzJGI/HkyRg
         qpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771972557; x=1772577357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jl3/kGLy/uiPn4E9pCww6rxRH2A13SEeo46Ae3ywkm8=;
        b=FX/pW0kaCUOOnLWWsm3lX0l29YN0ZLmt08/SILGFpxbu+AEU44wR2olXjR4NCvGu+3
         qwVUWeCdi9NE/1V+tqRx4ZalPq70ffhN+eaZzTVcnoxuYf3wTlkTJa56pldVE2Jqdmxv
         9WEizqcnIlRBKDfOL32Qo0veC9cE5PVklTgX4sqnazuV+NfidQVzTF+KowAdeLDg6RZn
         fqeT2cEOp+c5gDU61AqTgVVA+dcnM17P6vU1jkGL7ApDtG24AbK2xJiAbJ06UGsqW/tn
         NpjLowf5/Gy27WceBhvMmFK3Ym2GRWzNY9KRx6LrJdj11bkrKeE+Prup3LI/g6EFkLHV
         1wzg==
X-Forwarded-Encrypted: i=1; AJvYcCXIxT/Ij34CMAeHnuNCKbqUi3Doptatao+jGQsuqxyoJ49Ce4ytEpotewK4sFoIxd3MnAI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7rdOOWxdzCeQRrjnoegn29DDDCupt2wQWJY41qCwdVJrv6fau
	EcJ7qVIu5OC75Ybtc009N+Z0QfuP1FNw/olvX9KgwTgctC5OreObnS8e19HDotuhOcgcSxsTqps
	4IU/cmP3700QNlK2qaZ44htE9hAwiULOFPWED/T1jErmF9vX8ItLDUME=
X-Gm-Gg: ATEYQzw9TInaDU1JSwBCZ7kLGy3hbyfuJIrQr2qpRoX+pT23jxMbcmV5kVHAgthVgby
	ywpyo/hCgPSFxiWu1IvlKVZ4cNfxA1K58DVopNFQSH2LuG3LL/KQayMEdA7+ELkBFzlfSKVOtwc
	T8OZy6JBLelAZBlGjOPC/+PNNVThXrT5dT8n1lb4RMWQok/rsnU6jHpuPKSIm+iYKgcMEmzoCTl
	qJIxQ2SZcTbUQ1vgD3+m8G9oNJvw1uD3PCXqjOw6k78QREa23TzFvDrNTLKPCx6vK4lHFHzuR38
	IXHpWL7dwn47ykeIJv4N3dzvZGh82fEQ8OO/TMPDz4soznte3gmVGPxPeB2ArOablf9UP8ocmf6
	XFgjw6jGHDmtDOVEsp+ECMk1iR+Il5mU=
X-Received: by 2002:a05:7301:1e92:b0:2ba:9115:2fab with SMTP id 5a478bee46e88-2bdc31a9008mr50757eec.12.1771972557374;
        Tue, 24 Feb 2026 14:35:57 -0800 (PST)
X-Received: by 2002:a05:7301:1e92:b0:2ba:9115:2fab with SMTP id 5a478bee46e88-2bdc31a9008mr50743eec.12.1771972556842;
        Tue, 24 Feb 2026 14:35:56 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bd7dbe82desm8327254eec.20.2026.02.24.14.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 14:35:55 -0800 (PST)
Date: Tue, 24 Feb 2026 16:35:54 -0600
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
Subject: Re: [PATCH v7 3/3] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem
 alignment tests
Message-ID: <7spmby7jcusyegus2knlhb7nvnyk5c3yz4z5luu6piymj6rwsv@zgktge5bmgd5>
References: <20260213103557.3207335-1-xujiakai2025@iscas.ac.cn>
 <20260213103557.3207335-4-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213103557.3207335-4-xujiakai2025@iscas.ac.cn>
X-Authority-Analysis: v=2.4 cv=RNe+3oi+ c=1 sm=1 tr=0 ts=699e27ce cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=pGLkceISAAAA:8 a=9ujUvY2DB1qyNZ7L-csA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: Rej1acbSDqfsTfkk71yEDNAtbBoZj1hq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE5NyBTYWx0ZWRfXyK1pKEdgHVxM
 ybJMebiZGOv26q6sYN1pZZqgETg2gidxiS50AZfEvoQu6M2wdwEUax5GpmqD6goVhzg2Q7qNFLv
 BCaoDtlohJSA0LxNxFHF63BgqYmEKYKEP9VopZq279RPlQRE+j3mGZZ5nKLtAErsFX8RnjUp9jH
 Rc6TUF60TJQmv8xiLkSSkhtD6vq7cZZVR3e+EKS93CQqbgSWReWe4Zi0B9G08RbNs4sVEXD9uMf
 LHlzGWCRiEhqiWNpMLuwlQUDV97sXBgVFPgfMb5ML94sRcaIS5Xt7EA5yg89tfdcBNQhGFJuxw0
 VEyks5yP/ks2pCEqNvY6p/wxXlNtVcLwLtGER0+BaS8mQSXfq5poqUyL8LTYaVa+iGQKhKdXjO+
 9CSaT3HOLQsUP1uTaQaWK7K+Bc/ePHGik88V1sp7I8muv/EFfM6G6IXCCr99icqXna9ndhPxyAI
 fcMtPqcDGQjuD4BL6XA==
X-Proofpoint-GUID: Rej1acbSDqfsTfkk71yEDNAtbBoZj1hq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602240197
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71708-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:email,qualcomm.com:dkim,oss.qualcomm.com:dkim,reg.id:url];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 195C818D9AA
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 10:35:57AM +0000, Jiakai Xu wrote:
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
> - all-ones GPA is accepted
> 
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V6 -> V7: 
> - Removed RISCV_SBI_STA_REG() macro addition and used existing 
> KVM_REG_RISCV_SBI_STA_REG(shmem_lo) instead.
> - Refined assertion messages per review feedback.
> - Split into two patches per Andrew Jones' suggestion:
>     Refactored UAPI tests from steal_time_init() into dedicated 
>     check_steal_time_uapi() function and added empty stub for 
>     RISC-V.
>     Filled in RISC-V stub with STA alignment tests. (this patch)
> ---
>  tools/testing/selftests/kvm/steal_time.c | 26 +++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index a814f6f3f8b41..2af7fd7513d55 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -233,6 +233,7 @@ static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
>  
>  /* SBI STA shmem must have 64-byte alignment */
>  #define STEAL_TIME_SIZE		((sizeof(struct sta_struct) + 63) & ~63)
> +#define INVALID_GPA (~(u64)0)

This belongs in kvm_util_types.h

>  
>  static vm_paddr_t st_gpa[NR_VCPUS];
>  
> @@ -327,7 +328,30 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  
>  static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
>  {
> -	/* RISC-V UAPI tests will be added in a subsequent patch */
> +	struct kvm_one_reg reg;
> +	uint64_t shmem;
> +	int ret;
> +
> +	reg.id = KVM_REG_RISCV_SBI_STA_REG(shmem_lo);
> +	reg.addr = (uint64_t)&shmem;
> +
> +	/* Case 1: misaligned GPA */
> +	shmem = ST_GPA_BASE + 1;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == -1 && errno == EINVAL,
> +		    "misaligned STA shmem returns -EINVAL");
> +
> +	/* Case 2: 64-byte aligned GPA */
> +	shmem = ST_GPA_BASE;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "aligned STA shmem succeeds");
> +
> +	/* Case 3: INVALID_GPA disables STA */
> +	shmem = INVALID_GPA;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "all-ones for STA shmem succeeds");
>  }

I'd remove the 'Case 1', 'Case 2', text from the comments because it'll
be a pain to maintain when people want to add/remove test cases.

Thanks,
drew

