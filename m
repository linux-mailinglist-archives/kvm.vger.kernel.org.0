Return-Path: <kvm+bounces-59998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D72C6BD79E5
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71574192115A
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4362D12EB;
	Tue, 14 Oct 2025 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a9A03Fjt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCCD27E045
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 06:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760424524; cv=none; b=bOst/0rQ4GdVlvKBWeAnYjlzbAPgpYp/K0ZsyU67NN1As06l2/39OPJrCAKO+3ThZ+JF0ORz/XbC/e6utDZXsKIXTZB6V/owwuQiipDO8MEvTYSJWrN9+7vr8r5WQrLT8uz5zt20+UXzhQHM/bFyK9Cy5rCPFHe5w7ZtcthR0p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760424524; c=relaxed/simple;
	bh=R6uD0vv4Dh8D7wLaga/b4BTDzarlobI6D1H4YKycdzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMiHhHdBkaUXZBT181gAFhu8bLUB4WuaL5AcsfwQAvUVQ0jeH3r9P5YtvgkYLNb5iZ3twCeDgx0O3/GRqcYkl47c1jpCUdmzUy1ni1ZJHS14zgLNth1I56pw75oYs1JM35xfdPq9eJ4yJ+6Isu3FPMz6eUVEKpkeXR2JwiwCaJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a9A03Fjt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DKuc4j018669;
	Tue, 14 Oct 2025 06:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cmtDdC
	poYKzmvEYe3erRYMEasL9dfjy36UpVVj2XhY0=; b=a9A03FjtHXRzq5KmVaFxKp
	HClFxUwmPCeRR7FaFaT1HvG+OXBxlMN9Hupdm0sJOjADsFd2TK1SQOdottvP6UZ9
	zXbY3tPHntDrxXcPJKKzgT+xBAZoxgJKKvbJa5PVOazeqachlkPlr+GICMmFFkzC
	UAM9fQrdxjKa46jx/CmmHO5EXlEWdbGO42kltTfIwQ2qPIAKnA79YvVobIVlo8Bn
	vcVPc8tEG4ovR954Ih24Wths6p6ek/YNZ59OekhaoLGpH6pLO2gYivw5DXFVHa21
	hM4Iio6zuXPpEHC1dI6QyX/C5iX2vGam/KGekAL+aQvqqp+H5OFXBfpmxUUic9qA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qcnr4urm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 06:48:20 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59E6cW3h014169;
	Tue, 14 Oct 2025 06:48:19 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qcnr4urj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 06:48:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59E3uKM9015002;
	Tue, 14 Oct 2025 06:48:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r3sj9bs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 06:48:18 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59E6mIUI31130316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 06:48:18 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 354E158059;
	Tue, 14 Oct 2025 06:48:18 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 666065804B;
	Tue, 14 Oct 2025 06:48:14 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 06:48:14 +0000 (GMT)
Message-ID: <a8e70e2b-4511-4d7c-a95c-a02cb6e6dd0e@linux.ibm.com>
Date: Tue, 14 Oct 2025 12:18:12 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] target/ppc: Replace HOST_BIG_ENDIAN #ifdef with
 runtime if() check
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        qemu-s390x@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        Chinmay Rath <rathc@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org
References: <20251010134226.72221-1-philmd@linaro.org>
 <20251010134226.72221-13-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251010134226.72221-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M5ZA6iws c=1 sm=1 tr=0 ts=68edf234 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8
 a=hx85cXZ2z9q_8elTTL8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=oH34dK2VZjykjzsv8OSz:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=jd6J4Gguk5HxikPWLKER:22
X-Proofpoint-GUID: fHf2NEEVJFfyMpZiAgQ6q8vvmHbLko_x
X-Proofpoint-ORIG-GUID: 05-BtaBuDSMs2QJBNTm0MO4BqHrI9L7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDE0MCBTYWx0ZWRfXwdxVF9s9jyYp
 qNdg5l18Qdq1uQLN94UAKySNbO9faJunjcG/QxNjIvllcvpKc37RAEwCNAKQZxMFZVfkwE6xu15
 mYhZ/GYY2yFjy7VziyW/RGkzhvyx5RJEPKi5GOCsG+EyO5a6pBMKkjyA8Lf8URr7axrPxfA9YNr
 6bNKg9Tn2rvSVO1ECt/MEIYaDMArOQ/ayl9Wrktqqpv0VejW4ALpFPTyVNwWcvLwplwhGUApZsW
 mrE+wuy2rGDjJtpbgzFbC6t8kuB2Agu7kFej9w2or3rhtJTPfz8xH+MV1OAGL8fFX3mxV2bEkDW
 dE8s+D+xeHEIefhbUKsqtb1CVuB1Ylepsl93hPRkBeQWcWKiy2CHaRFQOCH2WYxPlna71y34Xpy
 O0P/V7kan2CevZVp0vyXz0fR3k5d6g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510100140



On 10/10/25 19:12, Philippe Mathieu-Daudé wrote:
> Replace compile-time #ifdef with a runtime check to ensure all code
> paths are built and tested. This reduces build-time configuration
> complexity and improves maintainability.
> 
> No functional change intended.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/ppc/arch_dump.c              |  9 ++-------
>   target/ppc/int_helper.c             | 28 ++++++++++++++--------------
>   target/ppc/kvm.c                    | 25 +++++++++----------------
>   target/ppc/translate/vmx-impl.c.inc | 14 +++++++-------
>   target/ppc/translate/vsx-impl.c.inc |  6 +++---
>   tcg/ppc/tcg-target.c.inc            | 24 ++++++++++++------------
>   6 files changed, 47 insertions(+), 59 deletions(-)
> 
> diff --git a/target/ppc/arch_dump.c b/target/ppc/arch_dump.c
> index 80ac6c3e320..5cb8dbe9a6a 100644
> --- a/target/ppc/arch_dump.c
> +++ b/target/ppc/arch_dump.c
> @@ -158,21 +158,16 @@ static void ppc_write_elf_vmxregset(NoteFuncArg *arg, PowerPCCPU *cpu, int id)
>       struct PPCElfVmxregset *vmxregset;
>       Note *note = &arg->note;
>       DumpState *s = arg->state;
> +    const int host_data_order = HOST_BIG_ENDIAN ? ELFDATA2MSB : ELFDATA2LSB;

I think the order of return values of ternary op needs to be swapped.

                             HOST_BIG_ENDIAN ? ELFDATA2LSB : ELFDATA2MSB;

Otherwise, looks fine. With that fixed:
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>


> +    const bool needs_byteswap = s->dump_info.d_endian == host_data_order;
>   
>       note->hdr.n_type = cpu_to_dump32(s, NT_PPC_VMX);
>       vmxregset = &note->contents.vmxregset;
>       memset(vmxregset, 0, sizeof(*vmxregset));
>   
>       for (i = 0; i < 32; i++) {
> -        bool needs_byteswap;
>           ppc_avr_t *avr = cpu_avr_ptr(&cpu->env, i);
>   
> -#if HOST_BIG_ENDIAN
> -        needs_byteswap = s->dump_info.d_endian == ELFDATA2LSB;
> -#else
> -        needs_byteswap = s->dump_info.d_endian == ELFDATA2MSB;
> -#endif
> -
>           if (needs_byteswap) {
>               vmxregset->avr[i].u64[0] = bswap64(avr->u64[1]);
>               vmxregset->avr[i].u64[1] = bswap64(avr->u64[0]);
> diff --git a/target/ppc/int_helper.c b/target/ppc/int_helper.c
> index ef4b2e75d60..0c6f5b2e519 100644
> --- a/target/ppc/int_helper.c
> +++ b/target/ppc/int_helper.c
> @@ -1678,13 +1678,13 @@ void helper_vslo(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
>   {
>       int sh = (b->VsrB(0xf) >> 3) & 0xf;
>   
> -#if HOST_BIG_ENDIAN
> -    memmove(&r->u8[0], &a->u8[sh], 16 - sh);
> -    memset(&r->u8[16 - sh], 0, sh);
> -#else
> -    memmove(&r->u8[sh], &a->u8[0], 16 - sh);
> -    memset(&r->u8[0], 0, sh);
> -#endif
> +    if (HOST_BIG_ENDIAN) {
> +        memmove(&r->u8[0], &a->u8[sh], 16 - sh);
> +        memset(&r->u8[16 - sh], 0, sh);
> +    } else {
> +        memmove(&r->u8[sh], &a->u8[0], 16 - sh);
> +        memset(&r->u8[0], 0, sh);
> +    }
>   }
>   
>   #if HOST_BIG_ENDIAN
> @@ -1898,13 +1898,13 @@ void helper_vsro(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
>   {
>       int sh = (b->VsrB(0xf) >> 3) & 0xf;
>   
> -#if HOST_BIG_ENDIAN
> -    memmove(&r->u8[sh], &a->u8[0], 16 - sh);
> -    memset(&r->u8[0], 0, sh);
> -#else
> -    memmove(&r->u8[0], &a->u8[sh], 16 - sh);
> -    memset(&r->u8[16 - sh], 0, sh);
> -#endif
> +    if (HOST_BIG_ENDIAN) {
> +        memmove(&r->u8[sh], &a->u8[0], 16 - sh);
> +        memset(&r->u8[0], 0, sh);
> +    } else {
> +        memmove(&r->u8[0], &a->u8[sh], 16 - sh);
> +        memset(&r->u8[16 - sh], 0, sh);
> +    }
>   }
>   
>   void helper_vsumsws(CPUPPCState *env, ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 2521ff65c6c..c00d29ce2c8 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -651,13 +651,13 @@ static int kvm_put_fp(CPUState *cs)
>               uint64_t *fpr = cpu_fpr_ptr(env, i);
>               uint64_t *vsrl = cpu_vsrl_ptr(env, i);
>   
> -#if HOST_BIG_ENDIAN
> -            vsr[0] = float64_val(*fpr);
> -            vsr[1] = *vsrl;
> -#else
> -            vsr[0] = *vsrl;
> -            vsr[1] = float64_val(*fpr);
> -#endif
> +            if (HOST_BIG_ENDIAN) {
> +                vsr[0] = float64_val(*fpr);
> +                vsr[1] = *vsrl;
> +            } else {
> +                vsr[0] = *vsrl;
> +                vsr[1] = float64_val(*fpr);
> +            }
>               reg.addr = (uintptr_t) &vsr;
>               reg.id = vsx ? KVM_REG_PPC_VSR(i) : KVM_REG_PPC_FPR(i);
>   
> @@ -728,17 +728,10 @@ static int kvm_get_fp(CPUState *cs)
>                                           strerror(errno));
>                   return ret;
>               } else {
> -#if HOST_BIG_ENDIAN
> -                *fpr = vsr[0];
> +                *fpr = vsr[!HOST_BIG_ENDIAN];
>                   if (vsx) {
> -                    *vsrl = vsr[1];
> +                    *vsrl = vsr[HOST_BIG_ENDIAN];
>                   }
> -#else
> -                *fpr = vsr[1];
> -                if (vsx) {
> -                    *vsrl = vsr[0];
> -                }
> -#endif
>               }
>           }
>       }
> diff --git a/target/ppc/translate/vmx-impl.c.inc b/target/ppc/translate/vmx-impl.c.inc
> index 92d6e8c6032..ca9cf1823d4 100644
> --- a/target/ppc/translate/vmx-impl.c.inc
> +++ b/target/ppc/translate/vmx-impl.c.inc
> @@ -134,9 +134,9 @@ static void gen_mtvscr(DisasContext *ctx)
>   
>       val = tcg_temp_new_i32();
>       bofs = avr_full_offset(rB(ctx->opcode));
> -#if HOST_BIG_ENDIAN
> -    bofs += 3 * 4;
> -#endif
> +    if (HOST_BIG_ENDIAN) {
> +        bofs += 3 * 4;
> +    }
>   
>       tcg_gen_ld_i32(val, tcg_env, bofs);
>       gen_helper_mtvscr(tcg_env, val);
> @@ -1528,10 +1528,10 @@ static void gen_vsplt(DisasContext *ctx, int vece)
>   
>       /* Experimental testing shows that hardware masks the immediate.  */
>       bofs += (uimm << vece) & 15;
> -#if !HOST_BIG_ENDIAN
> -    bofs ^= 15;
> -    bofs &= ~((1 << vece) - 1);
> -#endif
> +    if (!HOST_BIG_ENDIAN) {
> +        bofs ^= 15;
> +        bofs &= ~((1 << vece) - 1);
> +    }
>   
>       tcg_gen_gvec_dup_mem(vece, dofs, bofs, 16, 16);
>   }
> diff --git a/target/ppc/translate/vsx-impl.c.inc b/target/ppc/translate/vsx-impl.c.inc
> index 00ad57c6282..8e5c75961f4 100644
> --- a/target/ppc/translate/vsx-impl.c.inc
> +++ b/target/ppc/translate/vsx-impl.c.inc
> @@ -1642,9 +1642,9 @@ static bool trans_XXSPLTW(DisasContext *ctx, arg_XX2_uim *a)
>       tofs = vsr_full_offset(a->xt);
>       bofs = vsr_full_offset(a->xb);
>       bofs += a->uim << MO_32;
> -#if !HOST_BIG_ENDIAN
> -    bofs ^= 8 | 4;
> -#endif
> +    if (!HOST_BIG_ENDIAN) {
> +        bofs ^= 8 | 4;
> +    }
>   
>       tcg_gen_gvec_dup_mem(MO_32, tofs, bofs, 16, 16);
>       return true;
> diff --git a/tcg/ppc/tcg-target.c.inc b/tcg/ppc/tcg-target.c.inc
> index b8b23d44d5e..61aa77f5454 100644
> --- a/tcg/ppc/tcg-target.c.inc
> +++ b/tcg/ppc/tcg-target.c.inc
> @@ -3951,9 +3951,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
>               tcg_out_mem_long(s, 0, LVEBX, out, base, offset);
>           }
>           elt = extract32(offset, 0, 4);
> -#if !HOST_BIG_ENDIAN
> -        elt ^= 15;
> -#endif
> +        if (!HOST_BIG_ENDIAN) {
> +            elt ^= 15;
> +        }
>           tcg_out32(s, VSPLTB | VRT(out) | VRB(out) | (elt << 16));
>           break;
>       case MO_16:
> @@ -3964,9 +3964,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
>               tcg_out_mem_long(s, 0, LVEHX, out, base, offset);
>           }
>           elt = extract32(offset, 1, 3);
> -#if !HOST_BIG_ENDIAN
> -        elt ^= 7;
> -#endif
> +        if (!HOST_BIG_ENDIAN) {
> +            elt ^= 7;
> +        }
>           tcg_out32(s, VSPLTH | VRT(out) | VRB(out) | (elt << 16));
>           break;
>       case MO_32:
> @@ -3977,9 +3977,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
>           tcg_debug_assert((offset & 3) == 0);
>           tcg_out_mem_long(s, 0, LVEWX, out, base, offset);
>           elt = extract32(offset, 2, 2);
> -#if !HOST_BIG_ENDIAN
> -        elt ^= 3;
> -#endif
> +        if (!HOST_BIG_ENDIAN) {
> +            elt ^= 3;
> +        }
>           tcg_out32(s, VSPLTW | VRT(out) | VRB(out) | (elt << 16));
>           break;
>       case MO_64:
> @@ -3991,9 +3991,9 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
>           tcg_out_mem_long(s, 0, LVX, out, base, offset & -16);
>           tcg_out_vsldoi(s, TCG_VEC_TMP1, out, out, 8);
>           elt = extract32(offset, 3, 1);
> -#if !HOST_BIG_ENDIAN
> -        elt = !elt;
> -#endif
> +        if (!HOST_BIG_ENDIAN) {
> +            elt = !elt;
> +        }
>           if (elt) {
>               tcg_out_vsldoi(s, out, out, TCG_VEC_TMP1, 8);
>           } else {

