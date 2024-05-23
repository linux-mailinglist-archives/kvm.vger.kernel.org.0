Return-Path: <kvm+bounces-18047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CF38CD5A9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7977E28201E
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0902514BF86;
	Thu, 23 May 2024 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N9UVvaN9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB891DFF7
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474342; cv=none; b=TJXO0WWcZu47KSewMR/djjoZCkihIXvayb09wrWfkXeeRc5dfWH0w/IwPMFaunsetyRZ+aOoSLjtCtXkQLpPTd3f8CMG8sIujdZxuiGbSdxuyyV3JzCESkkYjVAJDXTBCyw2gyMf9CAS9dNO98SWDD7G6PqXivNptWvvjWGpBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474342; c=relaxed/simple;
	bh=WuPaGTIYhYa0lrEbi1ktl5zLyKUvI4hHjVWMWuH9sjA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IUHZO2x6GBxBLxTj1w+G8l5SXlTej/l8D1p1Jy3zRzkOcYUdoUKOvtOpw+q+LppKHSs2AJ20ZbRZVNs5+Dueb1trNnUDqyQTa+aIH/aFB6OeU2ObWb53Ta4qX1toeRYDdb5LzdBbtLcLQJHAwwoerLEBUlZVN11Zc8wdYHuzMpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N9UVvaN9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NEDBhR012525;
	Thu, 23 May 2024 14:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zVanIShsaKsEqSOZSk7Rv0o40KccDjs+kXnNjUAS+fs=;
 b=N9UVvaN9qSC1gM+688Ohqywor6pTeV2UfYlK42Du39ttfaQx6d6D3jf8Mocwfgibjz7f
 8gPZEZZjEEvCRcQIjGax2JHWeu4qYNJmHarwC3lLuKexOunMqDKRp/kX6AR05p7FiVOa
 VIdbGOrD9oHAMBrxT826rp6/U9d0bPa471hSTFb64PwS876U/HHxscMTAon+bOG4i0r5
 KYaoSZd0sCtaf72WohQg6oo9ZBB8dhDWcEIScU82cgTzGPOGdANBfg3xZ2bM2GC1utVV
 uoL1oRVDFqF4T4EsKREcczkucSzM8JioVQUXyBpd9h4Jy2cC5iruYhsDpM0tt75QEZ09 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya7c401ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 14:25:28 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NEPR5S000346;
	Thu, 23 May 2024 14:25:27 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya7c401ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 14:25:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44NEFdxp023469;
	Thu, 23 May 2024 14:25:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77npjgnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 14:25:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NEPMC946399900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 14:25:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AFF420043;
	Thu, 23 May 2024 14:25:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E054D20040;
	Thu, 23 May 2024 14:25:21 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 14:25:21 +0000 (GMT)
Message-ID: <66a7077c5df86d0a541237996382ae583d690a14.camel@linux.ibm.com>
Subject: Re: [PATCH v2 11/11] KVM: arm64: Get rid of the AArch32 register
 mapping code
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
        Julien Thierry
 <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>, Will Deacon <will@kernel.org>,
        Mark
 Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David
 Brazdil <dbrazdil@google.com>, kernel-team@android.com
Date: Thu, 23 May 2024 16:25:21 +0200
In-Reply-To: <20201102164045.264512-12-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
	 <20201102164045.264512-12-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dIS4mzedkeYOUhEU40jF8cSIVctJGfFw
X-Proofpoint-GUID: mDZJ3ICKHzZwW-sjSEVq4XxZ_Fr66Cxr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230099

On Mon, 2020-11-02 at 16:40 +0000, Marc Zyngier wrote:

[...]

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dfb5218137ca..3f23f7478d2a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -252,10 +252,32 @@ static int set_core_reg(struct kvm_vcpu *vcpu, cons=
t struct kvm_one_reg *reg)
>  	memcpy(addr, valp, KVM_REG_SIZE(reg->id));

I was looking at KVM_(G|S)ET_ONE_REG implementations and something looks of=
f to me here:

...

	if (off =3D=3D KVM_REG_ARM_CORE_REG(regs.pstate)) {
		u64 mode =3D (*(u64 *)valp) & PSR_AA32_MODE_MASK;
		switch (mode) {

Masking and switch over mode here...

		case PSR_AA32_MODE_USR:
			if (!kvm_supports_32bit_el0())
				return -EINVAL;
			break;
		case PSR_AA32_MODE_FIQ:
		case PSR_AA32_MODE_IRQ:
...
> =20
>  	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
> -		int i;
> +		int i, nr_reg;
> +
> +		switch (*vcpu_cpsr(vcpu)) {

...but switching over mode without masking here.
I don't know if this is as intended, but I thought I'd mention it.

> +		/*
> +		 * Either we are dealing with user mode, and only the
> +		 * first 15 registers (+ PC) must be narrowed to 32bit.
> +		 * AArch32 r0-r14 conveniently map to AArch64 x0-x14.
> +		 */
> +		case PSR_AA32_MODE_USR:
> +		case PSR_AA32_MODE_SYS:
> +			nr_reg =3D 15;
> +			break;
> +
> +		/*
> +		 * Otherwide, this is a priviledged mode, and *all* the
> +		 * registers must be narrowed to 32bit.
> +		 */
> +		default:
> +			nr_reg =3D 31;
> +			break;
> +		}
> +
> +		for (i =3D 0; i < nr_reg; i++)
> +			vcpu_set_reg(vcpu, i, (u32)vcpu_get_reg(vcpu, i));
> =20
> -		for (i =3D 0; i < 16; i++)
> -			*vcpu_reg32(vcpu, i) =3D (u32)*vcpu_reg32(vcpu, i);
> +		*vcpu_pc(vcpu) =3D (u32)*vcpu_pc(vcpu);
>  	}
>  out:
>  	return err;
> diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
> deleted file mode 100644
> index ae7e290bb017..000000000000
> --- a/arch/arm64/kvm/regmap.c
> +++ /dev/null
> @@ -1,128 +0,0 @@

[...]

> -unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
> -{
> -	unsigned long *reg_array =3D (unsigned long *)&vcpu->arch.ctxt.regs;
> -	unsigned long mode =3D *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;

There used to be masking here at least.
> -
> -	switch (mode) {
> -	case PSR_AA32_MODE_USR ... PSR_AA32_MODE_SVC:
> -		mode &=3D ~PSR_MODE32_BIT; /* 0 ... 3 */
> -		break;
> -
> -	case PSR_AA32_MODE_ABT:
> -		mode =3D 4;
> -		break;
> -
> -	case PSR_AA32_MODE_UND:
> -		mode =3D 5;
> -		break;
> -
> -	case PSR_AA32_MODE_SYS:
> -		mode =3D 0;	/* SYS maps to USR */
> -		break;
> -
> -	default:
> -		BUG();
> -	}
> -
> -	return reg_array + vcpu_reg_offsets[mode][reg_num];
> -}


