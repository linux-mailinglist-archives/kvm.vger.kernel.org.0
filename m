Return-Path: <kvm+bounces-34132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7EF9F78DE
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EB961893DC6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E47221DA2;
	Thu, 19 Dec 2024 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h4TL9T+3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E5433A4
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 09:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734601770; cv=none; b=RLTQKIKw23Jvoazm8B6E7JIQFS1lVriTnyOKs9tHq5LUuz9lTnfmYlZl05tNYQ+h/23htbxwN7BP6lSSvsOofyZGYPnXAvNJU3YP7ctuR1SyFLgfJYHoRvnVdrMpcaF5HALqS+PKH5eW80O79L5g9sxtjIYZ12hWEJmvqe7SC0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734601770; c=relaxed/simple;
	bh=A9CTubMD2lwR3nkZbRb8D5h5kZxrRjJRqHioMmUJJ7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBSNtNo6Nval3O6qFIhDxEcDbJFBH6DR81hP+KsNo6gK5rREPHXKRMv3Y1uZ28Vk5EhyFqD26wvp+8LkawvgeAfJnft3F7xu1HRdavcILSbNRC/EoXcq+WP4CiXkIGkGdOjtdRzrcUOmDgb4psF1YhY2Xl57snFTKEffue/UPIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h4TL9T+3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ3rgvU026770;
	Thu, 19 Dec 2024 09:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4tyOnx
	94HGx5TJJq3M3uxXCJy5Tm/sUw5m9l/T+1bSE=; b=h4TL9T+3VQGnVELsdlLhye
	9eFVwMMPW1JNMZGB5gHzuLwpNfwU15kiq3B1YLGLeygh6991zi3ZL6RsJJA/mcgn
	wRe7LT8E2T6wLrX5YgkKLYNIrYm78feuqbG12M13nIslPH8fxB68yM9xSA/LDWBa
	pDN/v1Wkkkj38lkh72/vrGD4U39AlMh1dyyBCmeBkI6oOCyE/gYHCS2iBg3R48S4
	hQgcEHC88+CeGUU+pFpOSIbySjUVAHfAwr3cKcF0/xK0SmKKcVbGIOxFZ/oZqlbF
	dHk3ArC/fLxzqBF91gTOz6C5TWPUeOJ8p61xaSOQG5owqyBtm1avGTrB9EJZjggQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mbyhsc13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 09:49:04 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BJ9kv7A010558;
	Thu, 19 Dec 2024 09:49:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mbyhsc10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 09:49:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ8Du49005544;
	Thu, 19 Dec 2024 09:49:03 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43hnbncj21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 09:49:02 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BJ9n2iH32375324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 09:49:02 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E981558054;
	Thu, 19 Dec 2024 09:49:01 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25A9358056;
	Thu, 19 Dec 2024 09:48:58 +0000 (GMT)
Received: from [9.39.21.210] (unknown [9.39.21.210])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Dec 2024 09:48:57 +0000 (GMT)
Message-ID: <1b5cd598-050d-4da9-902f-d8e50722b4cd@linux.ibm.com>
Date: Thu, 19 Dec 2024 15:18:56 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] ppc: Enable 2nd DAWR support on Power10 PowerNV
 machine
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, danielhb413@gmail.com,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, clg@kaod.org,
        npiggin@gmail.com, groug@kaod.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <170679877410.188422.2597832350300436754.stgit@ltc-boston1.aus.stglabs.ibm.com>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <170679877410.188422.2597832350300436754.stgit@ltc-boston1.aus.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LhOhtGNKoKBMW9RfugVLYg1-qnQ5Nfef
X-Proofpoint-GUID: 66rHflP4S7pO9qHDY1DoHQ5ZlrTQR-2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1011 phishscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412190076

Hi Shiva,

On 2/1/24 20:16, Shivaprasad G Bhat wrote:
> Extend the existing watchpoint facility from TCG DAWR0 emulation
> to DAWR1 on POWER10.
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>   target/ppc/cpu.c         |   45 ++++++++++++++++++++++++----------
>   target/ppc/cpu.h         |    8 +++++-
>   target/ppc/cpu_init.c    |   15 +++++++++++
>   target/ppc/excp_helper.c |   61 ++++++++++++++++++++++++++--------------------
>   target/ppc/helper.h      |    2 ++
>   target/ppc/machine.c     |    3 ++
>   target/ppc/misc_helper.c |   10 ++++++++
>   target/ppc/spr_common.h  |    2 ++
>   target/ppc/translate.c   |   12 +++++++++
>   9 files changed, 115 insertions(+), 43 deletions(-)
> 
> diff --git a/target/ppc/cpu.c b/target/ppc/cpu.c
> index e3ad8e0c27..d5ac9bb888 100644
> --- a/target/ppc/cpu.c
> +++ b/target/ppc/cpu.c
> @@ -130,11 +130,13 @@ void ppc_store_ciabr(CPUPPCState *env, target_ulong val)
>       ppc_update_ciabr(env);
>   }
>   
> -void ppc_update_daw0(CPUPPCState *env)
> +void ppc_update_daw(CPUPPCState *env, int rid)

Ok, so daw refers to watchpoint ...

>   {
>       CPUState *cs = env_cpu(env);
> -    target_ulong deaw = env->spr[SPR_DAWR0] & PPC_BITMASK(0, 60);
> -    uint32_t dawrx = env->spr[SPR_DAWRX0];
> +    int spr_dawr = !rid ? SPR_DAWR0 : SPR_DAWR1;
> +    int spr_dawrx = !rid ? SPR_DAWRX0 : SPR_DAWRX1;

We can avoid un-necessary negation here by exchanging the order of 
registers.

> +    target_ulong deaw = env->spr[spr_dawr] & PPC_BITMASK(0, 60);
> +    uint32_t dawrx = env->spr[spr_dawrx];
>       int mrd = extract32(dawrx, PPC_BIT_NR(48), 54 - 48);
>       bool dw = extract32(dawrx, PPC_BIT_NR(57), 1);
>       bool dr = extract32(dawrx, PPC_BIT_NR(58), 1);
> @@ -144,9 +146,9 @@ void ppc_update_daw0(CPUPPCState *env)
>       vaddr len;
>       int flags;
>   
> -    if (env->dawr0_watchpoint) {
> -        cpu_watchpoint_remove_by_ref(cs, env->dawr0_watchpoint);
> -        env->dawr0_watchpoint = NULL;
> +    if (env->dawr_watchpoint[rid]) {
> +        cpu_watchpoint_remove_by_ref(cs, env->dawr_watchpoint[rid]);
> +        env->dawr_watchpoint[rid] = NULL;
>       }
>   
>       if (!dr && !dw) {
> @@ -166,28 +168,45 @@ void ppc_update_daw0(CPUPPCState *env)
>           flags |= BP_MEM_WRITE;
>       }
>   
> -    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr0_watchpoint);
> +    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr_watchpoint[rid]);
>   }
>   
>   void ppc_store_dawr0(CPUPPCState *env, target_ulong val)
>   {
>       env->spr[SPR_DAWR0] = val;
> -    ppc_update_daw0(env);
> +    ppc_update_daw(env, 0);
>   }
>   
> -void ppc_store_dawrx0(CPUPPCState *env, uint32_t val)
> +static void ppc_store_dawrx(CPUPPCState *env, uint32_t val, int rid)
>   {
>       int hrammc = extract32(val, PPC_BIT_NR(56), 1);
>   
>       if (hrammc) {
>           /* This might be done with a second watchpoint at the xor of DEAW[0] */
> -        qemu_log_mask(LOG_UNIMP, "%s: DAWRX0[HRAMMC] is unimplemented\n",
> -                      __func__);
> +        qemu_log_mask(LOG_UNIMP, "%s: DAWRX%d[HRAMMC] is unimplemented\n",
> +                      __func__, rid);
>       }
>   
> -    env->spr[SPR_DAWRX0] = val;
> -    ppc_update_daw0(env);
> +    env->spr[!rid ? SPR_DAWRX0 : SPR_DAWRX1] = val;

        env->spr[rid ? SPR_DAWRX1 : SPR_DAWRX0] = val;

> +    ppc_update_daw(env, rid);
> +}
> +
> +void ppc_store_dawrx0(CPUPPCState *env, uint32_t val)
> +{
> +    ppc_store_dawrx(env, val, 0);
> +}
> +
> +void ppc_store_dawr1(CPUPPCState *env, target_ulong val)
> +{
> +    env->spr[SPR_DAWR1] = val;
> +    ppc_update_daw(env, 1);
> +}
> +
> +void ppc_store_dawrx1(CPUPPCState *env, uint32_t val)
> +{
> +    ppc_store_dawrx(env, val, 1);
>   }
> +
>   #endif
>   #endif
>   
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index f8101ffa29..18dcc438ea 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1236,7 +1236,7 @@ struct CPUArchState {
>   #if defined(TARGET_PPC64)
>       ppc_slb_t slb[MAX_SLB_ENTRIES]; /* PowerPC 64 SLB area */
>       struct CPUBreakpoint *ciabr_breakpoint;
> -    struct CPUWatchpoint *dawr0_watchpoint;
> +    struct CPUWatchpoint *dawr_watchpoint[2];
>   #endif
>       target_ulong sr[32];   /* segment registers */
>       uint32_t nb_BATs;      /* number of BATs */
> @@ -1549,9 +1549,11 @@ void ppc_store_sdr1(CPUPPCState *env, target_ulong value);
>   void ppc_store_lpcr(PowerPCCPU *cpu, target_ulong val);
>   void ppc_update_ciabr(CPUPPCState *env);
>   void ppc_store_ciabr(CPUPPCState *env, target_ulong value);
> -void ppc_update_daw0(CPUPPCState *env);
> +void ppc_update_daw(CPUPPCState *env, int rid);
>   void ppc_store_dawr0(CPUPPCState *env, target_ulong value);
>   void ppc_store_dawrx0(CPUPPCState *env, uint32_t value);
> +void ppc_store_dawr1(CPUPPCState *env, target_ulong value);
> +void ppc_store_dawrx1(CPUPPCState *env, uint32_t value);
>   #endif /* !defined(CONFIG_USER_ONLY) */
>   void ppc_store_msr(CPUPPCState *env, target_ulong value);
>   
> @@ -1737,9 +1739,11 @@ void ppc_compat_add_property(Object *obj, const char *name,
>   #define SPR_PSPB              (0x09F)
>   #define SPR_DPDES             (0x0B0)
>   #define SPR_DAWR0             (0x0B4)
> +#define SPR_DAWR1             (0x0B5)
>   #define SPR_RPR               (0x0BA)
>   #define SPR_CIABR             (0x0BB)
>   #define SPR_DAWRX0            (0x0BC)
> +#define SPR_DAWRX1            (0x0BD)
>   #define SPR_HFSCR             (0x0BE)
>   #define SPR_VRSAVE            (0x100)
>   #define SPR_USPRG0            (0x100)
> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> index 23eb5522b6..c901559859 100644
> --- a/target/ppc/cpu_init.c
> +++ b/target/ppc/cpu_init.c
> @@ -5131,6 +5131,20 @@ static void register_book3s_207_dbg_sprs(CPUPPCState *env)
>                           KVM_REG_PPC_CIABR, 0x00000000);
>   }
>   
> +static void register_book3s_310_dbg_sprs(CPUPPCState *env)
> +{
> +    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        &spr_read_generic, &spr_write_dawr1,
> +                        KVM_REG_PPC_DAWR1, 0x00000000);
> +    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        SPR_NOACCESS, SPR_NOACCESS,
> +                        &spr_read_generic, &spr_write_dawrx1,
> +                        KVM_REG_PPC_DAWRX1, 0x00000000);
> +}
> +
>   static void register_970_dbg_sprs(CPUPPCState *env)
>   {
>       /* Breakpoints */
> @@ -6473,6 +6487,7 @@ static void init_proc_POWER10(CPUPPCState *env)
>       /* Common Registers */
>       init_proc_book3s_common(env);
>       register_book3s_207_dbg_sprs(env);
> +    register_book3s_310_dbg_sprs(env);
>   
>       /* Common TCG PMU */
>       init_tcg_pmu_power8(env);
> diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
> index 2ec6429e36..32eba7f725 100644
> --- a/target/ppc/excp_helper.c
> +++ b/target/ppc/excp_helper.c
> @@ -3314,39 +3314,46 @@ bool ppc_cpu_debug_check_watchpoint(CPUState *cs, CPUWatchpoint *wp)
>   {
>   #if defined(TARGET_PPC64)
>       CPUPPCState *env = cpu_env(cs);
> +    bool wt, wti, hv, sv, pr;
> +    uint32_t dawrx;
> +
> +    if ((env->insns_flags2 & PPC2_ISA207S) &&
> +        (wp == env->dawr_watchpoint[0])) {
> +        dawrx = env->spr[SPR_DAWRX0];
> +    } else if ((env->insns_flags2 & PPC2_ISA310) &&
> +               (wp == env->dawr_watchpoint[1])) {
> +        dawrx = env->spr[SPR_DAWRX1];
> +    } else {
> +        return false;
> +    }
>   
> -    if (env->insns_flags2 & PPC2_ISA207S) {
> -        if (wp == env->dawr0_watchpoint) {
> -            uint32_t dawrx = env->spr[SPR_DAWRX0];
> -            bool wt = extract32(dawrx, PPC_BIT_NR(59), 1);
> -            bool wti = extract32(dawrx, PPC_BIT_NR(60), 1);
> -            bool hv = extract32(dawrx, PPC_BIT_NR(61), 1);
> -            bool sv = extract32(dawrx, PPC_BIT_NR(62), 1);
> -            bool pr = extract32(dawrx, PPC_BIT_NR(62), 1);
> -
> -            if ((env->msr & ((target_ulong)1 << MSR_PR)) && !pr) {
> -                return false;
> -            } else if ((env->msr & ((target_ulong)1 << MSR_HV)) && !hv) {
> -                return false;
> -            } else if (!sv) {
> +    wt = extract32(dawrx, PPC_BIT_NR(59), 1);
> +    wti = extract32(dawrx, PPC_BIT_NR(60), 1);
> +    hv = extract32(dawrx, PPC_BIT_NR(61), 1);
> +    sv = extract32(dawrx, PPC_BIT_NR(62), 1);
> +    pr = extract32(dawrx, PPC_BIT_NR(62), 1);
> +
> +    if ((env->msr & ((target_ulong)1 << MSR_PR)) && !pr) {
> +        return false;
> +    } else if ((env->msr & ((target_ulong)1 << MSR_HV)) && !hv) {
> +        return false;
> +    } else if (!sv) {
> +        return false;
> +    }
> +
> +    if (!wti) {
> +        if (env->msr & ((target_ulong)1 << MSR_DR)) {
> +            if (!wt) {
>                   return false;

This if check could be avoided by just doing a return wt ?

>               }
> -
> -            if (!wti) {
> -                if (env->msr & ((target_ulong)1 << MSR_DR)) {
> -                    if (!wt) {
> -                        return false;
> -                    }
> -                } else {
> -                    if (wt) {
> -                        return false;
> -                    }
> -                }
> +        } else {
> +            if (wt) {
> +                return false;
>               }

Similarly, here if-check can be avoided by just doing a return !wt ?

Rest looks good to me. With suggested changes,

Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

> -
> -            return true;
>           }
>       }
> +
> +    return true;


>   #endif
>   
>       return false;
> diff --git a/target/ppc/helper.h b/target/ppc/helper.h
> index 86f97ee1e7..0c008bb725 100644
> --- a/target/ppc/helper.h
> +++ b/target/ppc/helper.h
> @@ -28,6 +28,8 @@ DEF_HELPER_2(store_pcr, void, env, tl)
>   DEF_HELPER_2(store_ciabr, void, env, tl)
>   DEF_HELPER_2(store_dawr0, void, env, tl)
>   DEF_HELPER_2(store_dawrx0, void, env, tl)
> +DEF_HELPER_2(store_dawr1, void, env, tl)
> +DEF_HELPER_2(store_dawrx1, void, env, tl)
>   DEF_HELPER_2(store_mmcr0, void, env, tl)
>   DEF_HELPER_2(store_mmcr1, void, env, tl)
>   DEF_HELPER_3(store_pmc, void, env, i32, i64)
> diff --git a/target/ppc/machine.c b/target/ppc/machine.c
> index 203fe28e01..082712ff16 100644
> --- a/target/ppc/machine.c
> +++ b/target/ppc/machine.c
> @@ -325,7 +325,8 @@ static int cpu_post_load(void *opaque, int version_id)
>           /* Re-set breaks based on regs */
>   #if defined(TARGET_PPC64)
>           ppc_update_ciabr(env);
> -        ppc_update_daw0(env);
> +        ppc_update_daw(env, 0);
> +        ppc_update_daw(env, 1);
>   #endif
>           /*
>            * TCG needs to re-start the decrementer timer and/or raise the
> diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
> index a9d41d2802..54e402b139 100644
> --- a/target/ppc/misc_helper.c
> +++ b/target/ppc/misc_helper.c
> @@ -214,6 +214,16 @@ void helper_store_dawrx0(CPUPPCState *env, target_ulong value)
>       ppc_store_dawrx0(env, value);
>   }
>   
> +void helper_store_dawr1(CPUPPCState *env, target_ulong value)
> +{
> +    ppc_store_dawr1(env, value);
> +}
> +
> +void helper_store_dawrx1(CPUPPCState *env, target_ulong value)
> +{
> +    ppc_store_dawrx1(env, value);
> +}
> +
>   /*
>    * DPDES register is shared. Each bit reflects the state of the
>    * doorbell interrupt of a thread of the same core.
> diff --git a/target/ppc/spr_common.h b/target/ppc/spr_common.h
> index 8a9d6cd994..c987a50809 100644
> --- a/target/ppc/spr_common.h
> +++ b/target/ppc/spr_common.h
> @@ -162,6 +162,8 @@ void spr_write_cfar(DisasContext *ctx, int sprn, int gprn);
>   void spr_write_ciabr(DisasContext *ctx, int sprn, int gprn);
>   void spr_write_dawr0(DisasContext *ctx, int sprn, int gprn);
>   void spr_write_dawrx0(DisasContext *ctx, int sprn, int gprn);
> +void spr_write_dawr1(DisasContext *ctx, int sprn, int gprn);
> +void spr_write_dawrx1(DisasContext *ctx, int sprn, int gprn);
>   void spr_write_ureg(DisasContext *ctx, int sprn, int gprn);
>   void spr_read_purr(DisasContext *ctx, int gprn, int sprn);
>   void spr_write_purr(DisasContext *ctx, int sprn, int gprn);
> diff --git a/target/ppc/translate.c b/target/ppc/translate.c
> index 049f636927..ac2a53f3b8 100644
> --- a/target/ppc/translate.c
> +++ b/target/ppc/translate.c
> @@ -593,6 +593,18 @@ void spr_write_dawrx0(DisasContext *ctx, int sprn, int gprn)
>       translator_io_start(&ctx->base);
>       gen_helper_store_dawrx0(tcg_env, cpu_gpr[gprn]);
>   }
> +
> +void spr_write_dawr1(DisasContext *ctx, int sprn, int gprn)
> +{
> +    translator_io_start(&ctx->base);
> +    gen_helper_store_dawr1(tcg_env, cpu_gpr[gprn]);
> +}
> +
> +void spr_write_dawrx1(DisasContext *ctx, int sprn, int gprn)
> +{
> +    translator_io_start(&ctx->base);
> +    gen_helper_store_dawrx1(tcg_env, cpu_gpr[gprn]);
> +}
>   #endif /* defined(TARGET_PPC64) && !defined(CONFIG_USER_ONLY) */
>   
>   /* CTR */
> 
> 

