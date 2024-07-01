Return-Path: <kvm+bounces-20788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E62491DCCE
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D9961F23F14
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266E114A601;
	Mon,  1 Jul 2024 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="suMTE/p2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE8514A4F1;
	Mon,  1 Jul 2024 10:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719829753; cv=none; b=RCPKCqht+ifwqAq5PkEBbL84tYH+CVmpC3BfxrlcTCypOFKwFp4WF4jFreBrlicj7dXaAi/YBiy5xtzmwhmk+oUC5HnWg8nlAeBIE0z2+QC0lYmyGpdgGF7gO8f7502O9DD40yUXvXOxivbdFbGBbJ+0zlhxeJxo+7Z4R4K6sV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719829753; c=relaxed/simple;
	bh=lEMFPPrUC0cHmGpr3ftU3GpcCOqLiJOlTrQCa48ENA0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5IvynyMa7ebDNyTKUiHAOwXrd9ggl/Gnj3PzBEJerHM1GkkyW98HOUhM/UKvszobQzMxZg8fY0XeqclgFv82dpAue7cI3CJnNV0ALcC2ZOJSMYwmxifkzCzzffl6R705Rfu6nnQkZ2n3/4ypYjNBNnaYCbySVilEXqrfzFLp8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=suMTE/p2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4618Qq4g012167;
	Mon, 1 Jul 2024 10:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	+8o0lizEjhDfi7qFIFVP/MBlWeaWENTlhhP+bCtETU0=; b=suMTE/p2RlUe0y6V
	BpkQb2WfDzB36L6QSnWdoCdNamjRiidSCo6Wh65WtEf7+zFkau8iUEa0+G+j8AIE
	UA0d6URhNJfsNctGSxnMnG6Aezf9r/Dy63nNchFVLBwkHkXk0YRcK63E8DrRL1jH
	R6B+YwzgcR0SoYjfhONatpAEHh94jNgqkFIAAnGEhNKvY6blPRiVoGV8/EQmtNxl
	ubjvYjsgJeWBr9RRL38+vu5haovTRxaFsnjVkkFxT8qfMw5xMI+vmImfvSXlUQwH
	lyETHVy3w8AN5HUt7jUDszEAnOuW7O6XfsBkcIF5HoeVV+1kXh4IDgQfInVierqH
	kEntgQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403qnfggnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:29:02 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 461AT23Y031147;
	Mon, 1 Jul 2024 10:29:02 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403qnfggnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:29:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4618GNF6029205;
	Mon, 1 Jul 2024 10:29:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3mpjy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:29:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 461AStxd54591828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 10:28:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8C4E2004D;
	Mon,  1 Jul 2024 10:28:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CBEF20043;
	Mon,  1 Jul 2024 10:28:55 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Jul 2024 10:28:55 +0000 (GMT)
Date: Mon, 1 Jul 2024 12:28:53 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
Message-ID: <20240701122853.4e0b84ce@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240628163547.2314-1-borntraeger@linux.ibm.com>
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9xrqbFvZMWd1kKx_lI9V5-W-Q5-nBxMS
X-Proofpoint-GUID: ug8aETPNPxQ8PSjpgYtCsAs4AkRUsJ1K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_08,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407010080

On Fri, 28 Jun 2024 18:35:47 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> in rare cases, e.g. for injecting a machine check we do intercept all
> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> LPSWEY was added. KVM needs to handle that as well.
> 
> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

With the whitespace error reported by Sven fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/kvm-s390.c         |  1 +
>  arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
>  arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 95990461888f..9281063636a7 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -427,6 +427,7 @@ struct kvm_vcpu_stat {
>  	u64 instruction_io_other;
>  	u64 instruction_lpsw;
>  	u64 instruction_lpswe;
> +	u64 instruction_lpswey;
>  	u64 instruction_pfmf;
>  	u64 instruction_ptff;
>  	u64 instruction_sck;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 50b77b759042..8e04c7f0c90c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -132,6 +132,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, instruction_io_other),
>  	STATS_DESC_COUNTER(VCPU, instruction_lpsw),
>  	STATS_DESC_COUNTER(VCPU, instruction_lpswe),
> +	STATS_DESC_COUNTER(VCPU, instruction_lpswey),
>  	STATS_DESC_COUNTER(VCPU, instruction_pfmf),
>  	STATS_DESC_COUNTER(VCPU, instruction_ptff),
>  	STATS_DESC_COUNTER(VCPU, instruction_sck),
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 111eb5c74784..1b326f3c3383 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -138,6 +138,21 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
>  	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
>  }
>  
> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> +{
> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> +	s64 disp1;
> +       
> +	/* The displacement is a 20bit _SIGNED_ value */
> +	disp1 = sign_extend64(((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> +			      ((vcpu->arch.sie_block->ipb & 0xff00) << 4), 19);
> +
> +	if (ar)
> +		*ar = base1;
> +
> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
> +}
> +
>  static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
>  					      u64 *address1, u64 *address2,
>  					      u8 *ar_b1, u8 *ar_b2)
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1be19cc9d73c..1a49b89706f8 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_lpswey(struct kvm_vcpu *vcpu)
> +{
> +	psw_t new_psw;
> +	u64 addr;
> +	int rc;
> +	u8 ar;
> +
> +	vcpu->stat.instruction_lpswey++;
> +
> +	if (!test_kvm_facility(vcpu->kvm, 193))
> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +
> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
> +	if (addr & 7)
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> +	if (rc)
> +		return kvm_s390_inject_prog_cond(vcpu, rc);
> +
> +	vcpu->arch.sie_block->gpsw = new_psw;
> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	return 0;
> +}
> +
>  static int handle_stidp(struct kvm_vcpu *vcpu)
>  {
>  	u64 stidp_data = vcpu->kvm->arch.model.cpuid;
> @@ -1462,6 +1492,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
>  	case 0x61:
>  	case 0x62:
>  		return handle_ri(vcpu);
> +	case 0x71:
> +		return handle_lpswey(vcpu);
>  	default:
>  		return -EOPNOTSUPP;
>  	}


