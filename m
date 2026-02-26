Return-Path: <kvm+bounces-72077-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMA+McSloGk9lQQAu9opvQ
	(envelope-from <kvm+bounces-72077-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:57:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 816B11AECA4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:57:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D72E0301A404
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EE34657EC;
	Thu, 26 Feb 2026 19:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T1D30GlW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D/xdPTYe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DE14657FA
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772135828; cv=none; b=T3Vza5Q/c7QF2xPG6nkzZOWmOQHd4zxXCoW9ME5eIjnMhXwkN3JTIXThAeBTZpCzdmqKlBAdnS/h0I32/EKQ75HJ3g3oZMHlaLdM8blIHuntS9FR4SmrKRTV1ILWXZotdRenh4zhgyTFfFjVYVjrxQd82S7G+dR5xzeLrqvb970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772135828; c=relaxed/simple;
	bh=SiuvbzDLjYJ34WrOYg7+5Z9QXufJQMzvQ+vyXzqtH2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVAAjYl7Vjc0rfbnMnv2yfOzm3E7E/fi0IXt47gUFKVKhNdF8oCBR0OCh2IM0r88965mncI3Ld6oqYOt9Z2xbnaeqLV5X7Eu2P7h0FNqLqwcOT80fQZEXyiqDSTP8Lgp9Lr332wWJsa59iPAnI0GT/UsrIPaXFUxZEuAQGnyJD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T1D30GlW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D/xdPTYe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QI4cY21395110
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=e9T0r9qPbJXEHEbE1DDUwuy1
	sFl7CYMlXpPV3+ZDZi4=; b=T1D30GlWpBTy7Fw5YVU5jHPnPcoQFM1DW5bOlomS
	G7W2fA8KNbLusn4Qm442rSpHBAYDx9aibSMdsziJ2WvVDYfAFzBPzTUsWmVe6V9l
	GJIQMqvHKa3Jo052jZirdYeWDM1RqDSMEvejXg3D8uvyMSePW51AYIKrShf+bLqB
	J+Wah9TMbrRt/JKsxaHj/K2mseAquS6wmKUlP57UUI2QH1ctwHvaR4tQoU6TLcYE
	qvoVVQz5nFb28OId1e2Rd9LLXVZk1kTBuG5aClPpZFNRPg6XTy7sarFi9ObtfdLd
	PodhJWY20rkoq+08ayYZUN70ITDaGQjGrcD/9R5C9Rk4rQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cju4r0hhg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:57:04 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1273665df8fso2063016c88.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 11:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772135823; x=1772740623; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9T0r9qPbJXEHEbE1DDUwuy1sFl7CYMlXpPV3+ZDZi4=;
        b=D/xdPTYeByPqyI3xsGcdMn8rDt2MiDsnMV6PaAXrB+yZ0jqOw7VMr1IhJnUZFXIVFi
         wTSqGZidPAz2qxO5ROhknNjPF8fKgEi8svOAp2rNNwhf+WEacbcIe7l2785rCBBlvsw6
         Wb7KguC6WpMViMvewJxKc2xL6M9Wf4xjVF8WSsQFNdOa98q4h5cjXdkI1T874g49yHu0
         nz2MMaq/DJs9qD+XlyL2mWLN3nv/s2EZRlUiCDhN35vNGATBXNxpt2sfRw4OEIR4YoOP
         CS2Zg4IN5B1uK6qbRfb+NsmE6QamIxk7HViGrqR0vzIc48yk5Y6I0AKLnrRY9bzsNXDZ
         AkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772135823; x=1772740623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9T0r9qPbJXEHEbE1DDUwuy1sFl7CYMlXpPV3+ZDZi4=;
        b=anF9Ve8W21whiXi8G+viZZ5GR28h+Y5uMkSShEaxubygqwnK8iUri+vQcJ4hkk0pQd
         7F5bYOL652toEdjyyQ3Af7NfMZL9TaEp93gTtZiJ7jcFZCG7iOWGloajzqd01NuNAeYz
         7h9feP2NsiU6kyx8xvBcOMEz4f9l+tG6pV6CdPrUSPLaTi1Eu25nx4JRNUlQ2sGiaZmT
         AR7VencAygwV1yXNqWrZyGrfFbv6CRYdov/qt5YOOLzzUJg7C/8d2ci4tKWEeiJFGOKu
         PnQJDW//5/Wj3AFo2m1kjPOFxE2AbFo3s+482qdcLiZq9kNQ2Wl25L82P795OAISfjtA
         3flg==
X-Forwarded-Encrypted: i=1; AJvYcCUmnPz2oORb5KYB22M31BhxzJqb41gWg/wimjtZekwVR7lzSnZ5mqzePRQGQRo1Vz29W8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtpwkBCtu2FDRZfCcUzq444Z8DfJsypcLNgTyZz1EGVY6uicg1
	+fLVAvYOwheM0UOjlPsZsiloC+eTXmB8ZVrUKB5EHskwH6LJ/9lspA7IQiXLVB8DsSqY6sZEwBQ
	ElTEETwdgAVSGwCPsHKe62h6GfKdWVZ55QCuJRcSjLiujMSLUaYSfy0w=
X-Gm-Gg: ATEYQzyYEB302RHy4+mKAqD27iNdTmApbNTGMhupJo4hp/hCXiDOmZeQj3F8MXQhtS6
	yGewVFORoUZ74SMlm5dyIStT/phnai/A31aNaC0pRFOUmApVY2ukCtt1S/dLK/+WdH+VSlKIOi2
	+NxGmfh86E2xT9cJGT/bk+xjQi+2ab4XChRuBIkhCWuQQF6NKJVvUchQEcZTyXTs2l4v4unx6/F
	VFdVHwrNoXlxwwt+iD6KLsEoExMhNgPUOF6yggj1x9Anx11JeRBX89+LJIv1xvNLC4ZPyxVWKDT
	ncVCRN6tTNeh/ibTw2uhWYu6j1Mpl8dflNeROGjAWmQwncHkynVmzvI3aiSW1ul3wMgxnbmCH1U
	EszA4LHJem2jDeF/sSiA6qmzY9X1x72Y=
X-Received: by 2002:a05:7022:512:b0:119:e55a:9c03 with SMTP id a92af1059eb24-1278fc3bf63mr58107c88.31.1772135823060;
        Thu, 26 Feb 2026 11:57:03 -0800 (PST)
X-Received: by 2002:a05:7022:512:b0:119:e55a:9c03 with SMTP id a92af1059eb24-1278fc3bf63mr58096c88.31.1772135822464;
        Thu, 26 Feb 2026 11:57:02 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1e04361sm2885359eec.14.2026.02.26.11.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:57:01 -0800 (PST)
Date: Thu, 26 Feb 2026 13:57:00 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Albert Ou <aou@eecs.berkeley.edu>, Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v8 3/3] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem
 alignment tests
Message-ID: <ywgpwvhzvtkmhw26exwwam5hfo5euhiewbrzyzh2uzkls2rkbe@g7p5kxnhtgso>
References: <20260226083234.634716-1-xujiakai2025@iscas.ac.cn>
 <20260226083234.634716-4-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226083234.634716-4-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4MiBTYWx0ZWRfX89PYGETVXpIf
 k1XeRg4sxLDkFMUqn6YXEyffeRsBMIuXYEqGdD9WxB0jeuC81AgkwP1BoU0u9VMFoHoWegf7xiV
 gkzS1I9MtexzUn4st6vvMO2exbPI0BsEcKOQFmwCKQPvqjkI63lsHuc33qITtdtbTeumGzBNbGd
 jGuQQyTBh8pxFYWEVMMEYFIgxKPrHckzmCjRO9zzEYKyYXWrNCUGGfYis4E7z3fM/i3BUHAuro1
 8HcsMyvVwAB8yUyI0jW2RZ5vKX8d0iSicAY93dvEsHEvKg2KS8jnqjEsU8YjsekIyIcQ7eoSzLK
 WUGI6KkXybXKxVPw8d+ig9oeTClyIuIHw2EO9sWARJt0MkH9ZTJDXBhYiFA/PaKOijsU+L81yNX
 csHdzMUDikuwnM6N2I/QHKfeK+QQAvvrzMvQ3+9pviVdm7p6Vq3rBwYkLY+F8DJQxeCZ72YledO
 VQ4SjXr5KCT/GXy89bw==
X-Proofpoint-GUID: sG9aRY9gCTCTfx1GB-Mgds82gigZumJm
X-Authority-Analysis: v=2.4 cv=KZzfcAYD c=1 sm=1 tr=0 ts=69a0a590 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=pGLkceISAAAA:8 a=xMjqbsr0sL_NellN6QoA:9 a=CjuIK1q_8ugA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-ORIG-GUID: sG9aRY9gCTCTfx1GB-Mgds82gigZumJm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602260182
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72077-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,qualcomm.com:dkim,reg.id:url];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 816B11AECA4
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 08:32:34AM +0000, Jiakai Xu wrote:
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
> V7 -> V8: Moved INVALID_GPA definition to kvm_util_types.h.
>           Removed comments in RISC-V check_steal_time_uapi().
>           Corrected reg.id assignment for SBI STA.
> V6 -> V7: Removed RISCV_SBI_STA_REG() macro addition and used existing
>            KVM_REG_RISCV_SBI_STA_REG(shmem_lo) instead.
>           Refined assertion messages per review feedback.
>           Split into two patches per Andrew Jones' suggestion:
>            Refactored UAPI tests from steal_time_init() into dedicated
>             check_steal_time_uapi() function and added empty stub for
>             RISC-V.
>            Filled in RISC-V stub with STA alignment tests. (this patch)
> ---
>  .../selftests/kvm/include/kvm_util_types.h    |  4 +++
>  tools/testing/selftests/kvm/steal_time.c      | 25 +++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
> index ec787b97cf184..90567f8243fe9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_types.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
> @@ -17,4 +17,8 @@
>  typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
>  typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
>  
> +#if defined(__riscv)

Why this #if ? INVALID_GPA is common to all architectures (see
include/linux/kvm_types.h). That's why I suggested putting it in this
shared header.

> +#define INVALID_GPA (~(uint64_t)0)
> +#endif
> +
>  #endif /* SELFTEST_KVM_UTIL_TYPES_H */
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 6f77df4deaad3..e90aad9561ff7 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -324,6 +324,31 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  
>  static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_one_reg reg;
> +	uint64_t shmem;
> +	int ret;
> +
> +	reg.id = KVM_REG_RISCV |
> +			 KVM_REG_SIZE_ULONG |
> +			 KVM_REG_RISCV_SBI_STATE |
> +			 KVM_REG_RISCV_SBI_STA |
> +			 KVM_REG_RISCV_SBI_STA_REG(shmem_lo);
> +	reg.addr = (uint64_t)&shmem;
> +
> +	shmem = ST_GPA_BASE + 1;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == -1 && errno == EINVAL,
> +		    "misaligned STA shmem returns -EINVAL");
> +
> +	shmem = ST_GPA_BASE;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "aligned STA shmem succeeds");
> +
> +	shmem = INVALID_GPA;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +	TEST_ASSERT(ret == 0,
> +		    "all-ones for STA shmem succeeds");
>  }
>  
>  #endif
> -- 
> 2.34.1
>

Thanks,
drew

