Return-Path: <kvm+bounces-68279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A17D29595
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CDD3303A180
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9825331A78;
	Thu, 15 Jan 2026 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gF08ylFA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="evSmiqrH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C3331206
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768521398; cv=none; b=k/UG1uP2xw1aXq5stBrdy5pbQ7PHXE8yk7u3p0W0zemk1fFOfBDCE+Ylvpi3bBSJue5SnGoEr6ACS9r2oL9sZYw7PUWbee3b6PV0/1OrMcKVRXNCkRc804UNQprZAMMYiAxnkSy7jU3SLJIgxyTRYNx/67WTfNNCALrlbe2vNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768521398; c=relaxed/simple;
	bh=QDPfz9ujw/RP1aYpy3CyZsrtxzsxbZGQiCEVPNme1oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxjrhSBNFn+SirYndqGEGyJvu9+MMTEL3kVelneetad3jWIoDwgQFEoHuSb5lhdOdyCCAtpuPrSSeFHDkzHS7NRPiYGdUsS8zkO5hys+RMg8coHhnIQvdqF+8TBZy/uBqIitbvMc3AT0KHAMdgiCGAaYpajgXyGJ6dxfvTwDDpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gF08ylFA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=evSmiqrH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FMaUKT3192458
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=irBiMr6CSbVRpYyOwfv82LqW
	psqYNDBdD+tqHLqBSZI=; b=gF08ylFAUxFHsYjFUuZnr3tqhwjYRsGlydrkv9zD
	T9KmNe4vJh1QQrR2XB3754hRbNcmNUgPRPKBjKt7fCkH2Ku+xLQcurfjxmfgbvVc
	uch+M13GWIyx8I+zqAkW3d4RB+Wr3iQ2lcIecrQFTJk8Rg/qv7ocCNt/4pcJKGCW
	oEx9KTImWDV3+otwOk3hGhbbT9aUlBO676aBU3vfqLCd3juPi4w5KToneoMMtvZQ
	1Ab7FOU9ujAcmPWLd9ENyXyg7bKINiWycPyzT6EQqxMZl/Vd8SE0tTTn67Hzi6o3
	4HNvX229swWpxSB9XVcR67SlnlUtNtZpX/xg7C1eh7CVNw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bq968g5tt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:56:36 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-123377038f9so4737796c88.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768521395; x=1769126195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=irBiMr6CSbVRpYyOwfv82LqWpsqYNDBdD+tqHLqBSZI=;
        b=evSmiqrH2Qn0ieP0LiYXGsnSkCryItWSh05OEMHrY9WO36/t+OyaM1f/GDGf5kdunZ
         CCsaU7epYpG6l1uDYj1ubLqYMCrLVzYwaetrMjRnCtWCXqxdhb+jyGHDwiySSbrcjoAd
         C+SIfTpjyumtBwdIppM2QcFIiVoQrD+bw+H0OgS1erJ1QbC+JU801skZe6U7Gerq/zIo
         G0aNqG/CGTgIj479iG3xx0PYo41g2b9KNs/CEbo9rvoNsJO5UoK12xgyyis3sKT9k5DX
         +gdCTL6X+css1B8wX6v3P/lnO1Bf43+HgtxZGfjpExZBWsVTCQx6v3Ln7GMpA/6IaApS
         gMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768521395; x=1769126195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irBiMr6CSbVRpYyOwfv82LqWpsqYNDBdD+tqHLqBSZI=;
        b=h6T5X85U7rnXw3MY6ERHuDaF8CXGep1KfB6vlWaKN3dFBtYun0K3gb7LhhMJ6rap//
         y5wnK9oue/dSScHvfkvsR2JuZQ2yiVUQkiIAmxOZ59MyA71JuOFJFHTziWF1esEKtNeu
         QyQGh7AXnJ+3sLf3QVut/STxMApttXfw8zoyOP/+KONPi8I0TUPHFErSgQakwl6d43+3
         5f80Rqytmd2qeUR+KrTxrdSNqxph3P2uMBBfb1zDEB3KnrqZW10Sa3llAKQZgqxFfZUS
         ksV6GjBvSx3SioVLQrM+zBs+Sy8KN7izxPZ2Yv7dW1AuarpnLHChXmZ8RufMqmo9Hneo
         J4kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMZcw4EgFCWV+EIZJXx/6N2lB7x2ZxfjQxBP1/4PdQ+eQQTRUzXBniOCz6qZUPkc7Lj28=@vger.kernel.org
X-Gm-Message-State: AOJu0YySgLuCTJqwka7gqwdxQLj3Lx7lCawL83sdiDpxdAxLLsdXuJvi
	bu14RNaIl7OBfV13mpB2+BaD5iZoaMvswy3pm6Xg2cV1D4CW7wuJhLNT5CxZsqiDYy4mgX0aBja
	WZejrWUE5ceAAQ5A9AA4eFhOKPng/xfddPctirhfBLihMZiAzYH3/WcA=
X-Gm-Gg: AY/fxX5z3rIftBy220W0Yb+bn9ThKCVB9HfoLRQV0148cE175TTJNtf1S9urCbTcGpR
	W08Ys2Ju0Oh2g6YsL7pWsrQhK5dj2INAQX6wGYBSKd/3XhTp0sCqTeSjCa+Uiu6Fai6EaYp2I8r
	icbWb+eNXUBB7zyhSxT/T3RwYyFGZiYlE/QI/iXlmpzaDf8IvMdtgVCUQNmNg9CRdsU9M3R33q2
	LxWujgYcKuE7r81DTEdpZ0vYC2QEDaHvy9knWt+C67itAys0D5cBVmafofW5rppuDxENEfTv2li
	JghoBvjldf6TtfFLvHxjWR6mK/kw+9lxBiG68Lcts2e4ec4HoSDiHPGcApSb3Dlxi6t9rEeQwgO
	ndxZ8gQ5AYO49h17TT0k=
X-Received: by 2002:a05:7022:6286:b0:11d:f44c:afbc with SMTP id a92af1059eb24-1244a74fb80mr1753406c88.37.1768521393925;
        Thu, 15 Jan 2026 15:56:33 -0800 (PST)
X-Received: by 2002:a05:7022:6286:b0:11d:f44c:afbc with SMTP id a92af1059eb24-1244a74fb80mr1753378c88.37.1768521393394;
        Thu, 15 Jan 2026 15:56:33 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af10c3csm879911c88.15.2026.01.15.15.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 15:56:32 -0800 (PST)
Date: Thu, 15 Jan 2026 17:56:31 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        ajones@ventanamicro.com, rkrcmar@ventanamicro.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Message-ID: <dfhacs3uppweqmw5t6gwli2iy3b7l5oj6saykogjb5qkadl4rc@bi7mvnezkd2m>
References: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
 <20260105143232.76715-3-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105143232.76715-3-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=JNg2csKb c=1 sm=1 tr=0 ts=69697eb4 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=SurXiuQvfP0cLrRCYjkA:9
 a=CjuIK1q_8ugA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-ORIG-GUID: KYgaC17z2y3Y-WsN-WXjw5RzvKkKVw7M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE5MCBTYWx0ZWRfX2WpYqEF08OOm
 xmXn8nVW4bHFv3dkD0q8gLSvi0T1MuYslJKwHgDLk+z/gDNmvGJsJu6I9B6Ii4lPrrJXgxZ+5nQ
 +8VU6+oPi5wAIx2bBF2tW24N0Z/HFl9Sjrv/PZmsMir9gZgk8V+6Gjl4TDILXBVn/7Zac3d6k/T
 akV8oUzSF1vYs0hf1kwkJ0Wzsq+VMGcnXBQUqCoQmnU+jZRvEKQ8WfKRnmpIdiG9l5c2Qj7jB2q
 NHQ71hlcCps6eUdm/obFzuI7JrttQnCNgLglcSKzlpy5YbCNQZ2PyZuJTKPX5mrHQcGeLkqbO5Y
 chcUaWal3yhDUdnRVyoJ5vrHBKvyS1xpfV6KfyfF9iP3pwjKG08n2lYKa6v6EeeTyTEDl9uomqX
 uW3l/IkPS5jD/rduKTuW7cHjNShlK2WTUN+/86Z73E8RIYcEiD7ACSjjc5/gXNxlqwGBv7L5VnZ
 ZnuQhmrQvO7eu+x2jRQ==
X-Proofpoint-GUID: KYgaC17z2y3Y-WsN-WXjw5RzvKkKVw7M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601150190

On Mon, Jan 05, 2026 at 10:32:32PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> This capability allows userspace to explicitly select the HGATP mode
> for the VM. The selected mode must be less than or equal to the max
> HGATP mode supported by the hardware. This capability must be enabled
> before creating any vCPUs, and can only be set once per VM.
> 
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  Documentation/virt/kvm/api.rst | 14 ++++++++++++++
>  arch/riscv/kvm/vm.c            | 26 ++++++++++++++++++++++++--
>  include/uapi/linux/kvm.h       |  1 +
>  3 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..9e17788e3a9d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8765,6 +8765,20 @@ helpful if user space wants to emulate instructions which are not
>  This capability can be enabled dynamically even if VCPUs were already
>  created and are running.
>  
> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
> +---------------------------------
> +
> +:Architectures: riscv
> +:Type: VM
> +:Parameters: args[0] contains the requested HGATP mode
> +:Returns: 0 on success, -EINVAL if arg[0] is outside the range of hgatp
> +          modes supported by the hardware.
> +
> +This capability allows userspace to explicitly select the HGATP mode for
> +the VM. The selected mode must be less than or equal to the maximum HGATP
> +mode supported by the hardware. This capability must be enabled before
> +creating any vCPUs, and can only be set once per VM.

I think I would prefer a KVM_CAP_RISCV_SET_MAX_GPA type of capability. The
reason is because, while one of the results of the max-gpa being set will
be to set hgatp, there may be other reasons to track the guest's maximum
physical address too and kvm userspace shouldn't need to think about each
individually.

> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 4b2156df40fc..e9275023a73a 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -202,6 +202,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VM_GPA_BITS:
>  		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>  		break;
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +#ifdef CONFIG_64BIT
> +		r = 1;
> +#else/* CONFIG_32BIT */
> +		r = 0;
> +#endif

 r = IS_ENABLED(CONFIG_64BIT) ? 1 : 0;

> +		break;
>  	default:
>  		r = 0;
>  		break;
> @@ -212,12 +219,27 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  {
> +	if (cap->flags)
> +		return -EINVAL;

add blank line

>  	switch (cap->cap) {
>  	case KVM_CAP_RISCV_MP_STATE_RESET:
> -		if (cap->flags)
> -			return -EINVAL;
>  		kvm->arch.mp_state_reset = true;
>  		return 0;
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +#ifdef CONFIG_64BIT
> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
> +			cap->args[0] > kvm_riscv_gstage_max_mode)
> +			return -EINVAL;
> +		if (kvm->arch.gstage_mode_initialized)
> +			return 0;

I think we want to return -EBUSY here and it should be documented where it
already states "...can only be set once per VM"

> +		kvm->arch.gstage_mode_initialized = true;

In the previous patch I thought we were missing this, but I see now it
means "user initialized". Let's rename it as such,

 gstage_mode_user_initialized

> +		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
> +		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
> +		kvm_info("using SV%lluX4 G-stage page table format\n",
> +			39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);
> +#endif
> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..00c02a880518 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>  #define KVM_CAP_ARM_SEA_TO_USER 245
>  #define KVM_CAP_S390_USER_OPEREXEC 246
> +#define KVM_CAP_RISCV_SET_HGATP_MODE 247
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> -- 
> 2.50.1
>

Thanks,
drew

