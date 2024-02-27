Return-Path: <kvm+bounces-10078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 46686868F96
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B172BB2585E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361CE13A255;
	Tue, 27 Feb 2024 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BW5xtU8H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B460513956D
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709035277; cv=none; b=I5cHXdnj0wF+ei16PBGfc3x+2QEaFhgKMDMzsXY3LegZu6s/Lv7Lpwd4vldhi24gQFV/hErBBtY0bOtrI0RvKXN2Lie1Yq0vKA3Ll8z+de0E5DyfgdHpgfD7HbfFzpO6gMWY6gv9pVbF0lUHbwMUgNlXidOQenV91hW0jcIPiko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709035277; c=relaxed/simple;
	bh=RCu97pjbmquch06DRuJ6mb9VcTePjrtLkt2BkIXXUqc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=U2R3ELowmyIEC14h18Grt/uzI0FboEyjNXugPBSeSxaF/bptLwi64LR6NjkYSu61Ok5E9SWj6csjcrIqTiIpz1lAv8tW6+J4bHGULl5wSa6S8cvpyTf4CTliUDtok8nE9Gh3KZoJb+eBBIXi4bS/7bmj0Sve95PT6dc2a70fhMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BW5xtU8H; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2997a92e23bso2861074a91.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 04:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709035275; x=1709640075; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+32pfY+ZxWPOpX+DNCg+oV9JCFLSfgK3vPS7O14Hloo=;
        b=BW5xtU8HVYApDix7TXgOVY8cQmEdx+09Wd8Bwu2fKPnzeeoIlglkM9jwaki1m+fB9E
         Bg8QQOCyyfSMzfY8WSl4/kwqBEsvRbZZ7sTmbgXj1NgZEwIyUtapz8l0hQrg1hO19Npi
         4tLk7r+AaCAvFMI7BPY59Nxrdp6ni9qBBVqwpXtG6rU2Gk6BtGauoLE5e2MUwoZWEI3K
         XCOHFUBA9GYqYK/V7nHbFheh9rj98X6Yv3NGWn6wIAE7R2drXEdHfrSfDKz7XCFCj+27
         7r+BSV2Shm4fO8usL5qognL1O1zKhHb6aqAQ+CfdfGttnvjBr9qG/j+BqH8PF9JU4xH/
         bc6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709035275; x=1709640075;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+32pfY+ZxWPOpX+DNCg+oV9JCFLSfgK3vPS7O14Hloo=;
        b=pb4Zt9Hxdd7NpqxTTnU6mZel1r/Rk4DAkfhTZ6rNa8nklwG/7ICteq4j9dH81OJqyW
         Xh5ObiL0uJK3HiEKbVhiC3778c+UAAprpSrTVkwUynI9WfU8P5OyOrtiFohS96SZ96Td
         6agv87miqtYoljz+hv6IKIC6AAlzNJaCbUT5yK0jmEV0p9Sj84BtxhnIZ1MfTrm8YwOh
         cM0BRhG7qpTY1QuJiP79HXBWcVz82lQ17Vn3et9vcDZXSQIvzI8mssNqCQpz3i+UHsBZ
         jZlQxeF3WeMAzjIg7b6I1RdrDXU7blxciKS+JB9EdQRX1uelbmynVnuKLvhRGMBZx3Xk
         0gsg==
X-Forwarded-Encrypted: i=1; AJvYcCXzdK14u7/YRlGLAqdrCda4QY1AVnvlXybL3gE6JFeNCbnXPRGoVNGtRgd4IG6I4pXjWRyTYe9j+hflpNTrR4J7GzBC
X-Gm-Message-State: AOJu0YywA7Rq1yU9sgIOLF12m9TSB8UgvyhvyI69T2kh625e5KJXeYxT
	yavS4nMwuoz4wj9KsA4fvqFBEDaM1K3r73CxbdqskdFdXSqt02Ar
X-Google-Smtp-Source: AGHT+IFXxSmovrSMPAM264GSNZZOlbrDS9ikZK7ZIwbjit+zTgnz6DERnJ+FuRAIjFexJXgnsrcF1Q==
X-Received: by 2002:a17:90a:6c61:b0:29a:7efc:471b with SMTP id x88-20020a17090a6c6100b0029a7efc471bmr7045048pjj.38.1709035274751;
        Tue, 27 Feb 2024 04:01:14 -0800 (PST)
Received: from localhost (110-175-163-154.tpgi.com.au. [110.175.163.154])
        by smtp.gmail.com with ESMTPSA id gx20-20020a056a001e1400b006e0949b2548sm5716490pfb.209.2024.02.27.04.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 04:01:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Feb 2024 22:01:07 +1000
Message-Id: <CZFUFVA72347.2XPCPLI34U6MX@wheely>
Cc: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
Subject: Re: [PATCH v8 1/2] ppc: Enable 2nd DAWR support on Power10 PowerNV
 machine
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <danielhb413@gmail.com>,
 <qemu-ppc@nongnu.org>, <david@gibson.dropbear.id.au>,
 <harshpb@linux.ibm.com>, <clg@kaod.org>, <groug@kaod.org>
X-Mailer: aerc 0.15.2
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com> <170679877410.188422.2597832350300436754.stgit@ltc-boston1.aus.stglabs.ibm.com>
In-Reply-To: <170679877410.188422.2597832350300436754.stgit@ltc-boston1.aus.stglabs.ibm.com>

On Fri Feb 2, 2024 at 12:46 AM AEST, Shivaprasad G Bhat wrote:
> Extend the existing watchpoint facility from TCG DAWR0 emulation
> to DAWR1 on POWER10.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  target/ppc/cpu.c         |   45 ++++++++++++++++++++++++----------
>  target/ppc/cpu.h         |    8 +++++-
>  target/ppc/cpu_init.c    |   15 +++++++++++
>  target/ppc/excp_helper.c |   61 ++++++++++++++++++++++++++--------------=
------
>  target/ppc/helper.h      |    2 ++
>  target/ppc/machine.c     |    3 ++
>  target/ppc/misc_helper.c |   10 ++++++++
>  target/ppc/spr_common.h  |    2 ++
>  target/ppc/translate.c   |   12 +++++++++
>  9 files changed, 115 insertions(+), 43 deletions(-)
>
> diff --git a/target/ppc/cpu.c b/target/ppc/cpu.c
> index e3ad8e0c27..d5ac9bb888 100644
> --- a/target/ppc/cpu.c
> +++ b/target/ppc/cpu.c
> @@ -130,11 +130,13 @@ void ppc_store_ciabr(CPUPPCState *env, target_ulong=
 val)
>      ppc_update_ciabr(env);
>  }
> =20
> -void ppc_update_daw0(CPUPPCState *env)
> +void ppc_update_daw(CPUPPCState *env, int rid)

What's rid? Register ID?

Looks pretty good I think.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

>  {
>      CPUState *cs =3D env_cpu(env);
> -    target_ulong deaw =3D env->spr[SPR_DAWR0] & PPC_BITMASK(0, 60);
> -    uint32_t dawrx =3D env->spr[SPR_DAWRX0];
> +    int spr_dawr =3D !rid ? SPR_DAWR0 : SPR_DAWR1;
> +    int spr_dawrx =3D !rid ? SPR_DAWRX0 : SPR_DAWRX1;
> +    target_ulong deaw =3D env->spr[spr_dawr] & PPC_BITMASK(0, 60);
> +    uint32_t dawrx =3D env->spr[spr_dawrx];
>      int mrd =3D extract32(dawrx, PPC_BIT_NR(48), 54 - 48);
>      bool dw =3D extract32(dawrx, PPC_BIT_NR(57), 1);
>      bool dr =3D extract32(dawrx, PPC_BIT_NR(58), 1);
> @@ -144,9 +146,9 @@ void ppc_update_daw0(CPUPPCState *env)
>      vaddr len;
>      int flags;
> =20
> -    if (env->dawr0_watchpoint) {
> -        cpu_watchpoint_remove_by_ref(cs, env->dawr0_watchpoint);
> -        env->dawr0_watchpoint =3D NULL;
> +    if (env->dawr_watchpoint[rid]) {
> +        cpu_watchpoint_remove_by_ref(cs, env->dawr_watchpoint[rid]);
> +        env->dawr_watchpoint[rid] =3D NULL;
>      }
> =20
>      if (!dr && !dw) {
> @@ -166,28 +168,45 @@ void ppc_update_daw0(CPUPPCState *env)
>          flags |=3D BP_MEM_WRITE;
>      }
> =20
> -    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr0_watchpoint);
> +    cpu_watchpoint_insert(cs, deaw, len, flags, &env->dawr_watchpoint[ri=
d]);
>  }
> =20
>  void ppc_store_dawr0(CPUPPCState *env, target_ulong val)
>  {
>      env->spr[SPR_DAWR0] =3D val;
> -    ppc_update_daw0(env);
> +    ppc_update_daw(env, 0);
>  }
> =20
> -void ppc_store_dawrx0(CPUPPCState *env, uint32_t val)
> +static void ppc_store_dawrx(CPUPPCState *env, uint32_t val, int rid)
>  {
>      int hrammc =3D extract32(val, PPC_BIT_NR(56), 1);
> =20
>      if (hrammc) {
>          /* This might be done with a second watchpoint at the xor of DEA=
W[0] */
> -        qemu_log_mask(LOG_UNIMP, "%s: DAWRX0[HRAMMC] is unimplemented\n"=
,
> -                      __func__);
> +        qemu_log_mask(LOG_UNIMP, "%s: DAWRX%d[HRAMMC] is unimplemented\n=
",
> +                      __func__, rid);
>      }
> =20
> -    env->spr[SPR_DAWRX0] =3D val;
> -    ppc_update_daw0(env);
> +    env->spr[!rid ? SPR_DAWRX0 : SPR_DAWRX1] =3D val;
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
> +    env->spr[SPR_DAWR1] =3D val;
> +    ppc_update_daw(env, 1);
> +}
> +
> +void ppc_store_dawrx1(CPUPPCState *env, uint32_t val)
> +{
> +    ppc_store_dawrx(env, val, 1);
>  }
> +
>  #endif
>  #endif
> =20
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index f8101ffa29..18dcc438ea 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1236,7 +1236,7 @@ struct CPUArchState {
>  #if defined(TARGET_PPC64)
>      ppc_slb_t slb[MAX_SLB_ENTRIES]; /* PowerPC 64 SLB area */
>      struct CPUBreakpoint *ciabr_breakpoint;
> -    struct CPUWatchpoint *dawr0_watchpoint;
> +    struct CPUWatchpoint *dawr_watchpoint[2];
>  #endif
>      target_ulong sr[32];   /* segment registers */
>      uint32_t nb_BATs;      /* number of BATs */
> @@ -1549,9 +1549,11 @@ void ppc_store_sdr1(CPUPPCState *env, target_ulong=
 value);
>  void ppc_store_lpcr(PowerPCCPU *cpu, target_ulong val);
>  void ppc_update_ciabr(CPUPPCState *env);
>  void ppc_store_ciabr(CPUPPCState *env, target_ulong value);
> -void ppc_update_daw0(CPUPPCState *env);
> +void ppc_update_daw(CPUPPCState *env, int rid);
>  void ppc_store_dawr0(CPUPPCState *env, target_ulong value);
>  void ppc_store_dawrx0(CPUPPCState *env, uint32_t value);
> +void ppc_store_dawr1(CPUPPCState *env, target_ulong value);
> +void ppc_store_dawrx1(CPUPPCState *env, uint32_t value);
>  #endif /* !defined(CONFIG_USER_ONLY) */
>  void ppc_store_msr(CPUPPCState *env, target_ulong value);
> =20
> @@ -1737,9 +1739,11 @@ void ppc_compat_add_property(Object *obj, const ch=
ar *name,
>  #define SPR_PSPB              (0x09F)
>  #define SPR_DPDES             (0x0B0)
>  #define SPR_DAWR0             (0x0B4)
> +#define SPR_DAWR1             (0x0B5)
>  #define SPR_RPR               (0x0BA)
>  #define SPR_CIABR             (0x0BB)
>  #define SPR_DAWRX0            (0x0BC)
> +#define SPR_DAWRX1            (0x0BD)
>  #define SPR_HFSCR             (0x0BE)
>  #define SPR_VRSAVE            (0x100)
>  #define SPR_USPRG0            (0x100)
> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> index 23eb5522b6..c901559859 100644
> --- a/target/ppc/cpu_init.c
> +++ b/target/ppc/cpu_init.c
> @@ -5131,6 +5131,20 @@ static void register_book3s_207_dbg_sprs(CPUPPCSta=
te *env)
>                          KVM_REG_PPC_CIABR, 0x00000000);
>  }
> =20
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
>  static void register_970_dbg_sprs(CPUPPCState *env)
>  {
>      /* Breakpoints */
> @@ -6473,6 +6487,7 @@ static void init_proc_POWER10(CPUPPCState *env)
>      /* Common Registers */
>      init_proc_book3s_common(env);
>      register_book3s_207_dbg_sprs(env);
> +    register_book3s_310_dbg_sprs(env);
> =20
>      /* Common TCG PMU */
>      init_tcg_pmu_power8(env);
> diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
> index 2ec6429e36..32eba7f725 100644
> --- a/target/ppc/excp_helper.c
> +++ b/target/ppc/excp_helper.c
> @@ -3314,39 +3314,46 @@ bool ppc_cpu_debug_check_watchpoint(CPUState *cs,=
 CPUWatchpoint *wp)
>  {
>  #if defined(TARGET_PPC64)
>      CPUPPCState *env =3D cpu_env(cs);
> +    bool wt, wti, hv, sv, pr;
> +    uint32_t dawrx;
> +
> +    if ((env->insns_flags2 & PPC2_ISA207S) &&
> +        (wp =3D=3D env->dawr_watchpoint[0])) {
> +        dawrx =3D env->spr[SPR_DAWRX0];
> +    } else if ((env->insns_flags2 & PPC2_ISA310) &&
> +               (wp =3D=3D env->dawr_watchpoint[1])) {
> +        dawrx =3D env->spr[SPR_DAWRX1];
> +    } else {
> +        return false;
> +    }
> =20
> -    if (env->insns_flags2 & PPC2_ISA207S) {
> -        if (wp =3D=3D env->dawr0_watchpoint) {
> -            uint32_t dawrx =3D env->spr[SPR_DAWRX0];
> -            bool wt =3D extract32(dawrx, PPC_BIT_NR(59), 1);
> -            bool wti =3D extract32(dawrx, PPC_BIT_NR(60), 1);
> -            bool hv =3D extract32(dawrx, PPC_BIT_NR(61), 1);
> -            bool sv =3D extract32(dawrx, PPC_BIT_NR(62), 1);
> -            bool pr =3D extract32(dawrx, PPC_BIT_NR(62), 1);
> -
> -            if ((env->msr & ((target_ulong)1 << MSR_PR)) && !pr) {
> -                return false;
> -            } else if ((env->msr & ((target_ulong)1 << MSR_HV)) && !hv) =
{
> -                return false;
> -            } else if (!sv) {
> +    wt =3D extract32(dawrx, PPC_BIT_NR(59), 1);
> +    wti =3D extract32(dawrx, PPC_BIT_NR(60), 1);
> +    hv =3D extract32(dawrx, PPC_BIT_NR(61), 1);
> +    sv =3D extract32(dawrx, PPC_BIT_NR(62), 1);
> +    pr =3D extract32(dawrx, PPC_BIT_NR(62), 1);
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
>                  return false;
>              }
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
>              }
> -
> -            return true;
>          }
>      }
> +
> +    return true;
>  #endif
> =20
>      return false;
> diff --git a/target/ppc/helper.h b/target/ppc/helper.h
> index 86f97ee1e7..0c008bb725 100644
> --- a/target/ppc/helper.h
> +++ b/target/ppc/helper.h
> @@ -28,6 +28,8 @@ DEF_HELPER_2(store_pcr, void, env, tl)
>  DEF_HELPER_2(store_ciabr, void, env, tl)
>  DEF_HELPER_2(store_dawr0, void, env, tl)
>  DEF_HELPER_2(store_dawrx0, void, env, tl)
> +DEF_HELPER_2(store_dawr1, void, env, tl)
> +DEF_HELPER_2(store_dawrx1, void, env, tl)
>  DEF_HELPER_2(store_mmcr0, void, env, tl)
>  DEF_HELPER_2(store_mmcr1, void, env, tl)
>  DEF_HELPER_3(store_pmc, void, env, i32, i64)
> diff --git a/target/ppc/machine.c b/target/ppc/machine.c
> index 203fe28e01..082712ff16 100644
> --- a/target/ppc/machine.c
> +++ b/target/ppc/machine.c
> @@ -325,7 +325,8 @@ static int cpu_post_load(void *opaque, int version_id=
)
>          /* Re-set breaks based on regs */
>  #if defined(TARGET_PPC64)
>          ppc_update_ciabr(env);
> -        ppc_update_daw0(env);
> +        ppc_update_daw(env, 0);
> +        ppc_update_daw(env, 1);
>  #endif
>          /*
>           * TCG needs to re-start the decrementer timer and/or raise the
> diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
> index a9d41d2802..54e402b139 100644
> --- a/target/ppc/misc_helper.c
> +++ b/target/ppc/misc_helper.c
> @@ -214,6 +214,16 @@ void helper_store_dawrx0(CPUPPCState *env, target_ul=
ong value)
>      ppc_store_dawrx0(env, value);
>  }
> =20
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
>  /*
>   * DPDES register is shared. Each bit reflects the state of the
>   * doorbell interrupt of a thread of the same core.
> diff --git a/target/ppc/spr_common.h b/target/ppc/spr_common.h
> index 8a9d6cd994..c987a50809 100644
> --- a/target/ppc/spr_common.h
> +++ b/target/ppc/spr_common.h
> @@ -162,6 +162,8 @@ void spr_write_cfar(DisasContext *ctx, int sprn, int =
gprn);
>  void spr_write_ciabr(DisasContext *ctx, int sprn, int gprn);
>  void spr_write_dawr0(DisasContext *ctx, int sprn, int gprn);
>  void spr_write_dawrx0(DisasContext *ctx, int sprn, int gprn);
> +void spr_write_dawr1(DisasContext *ctx, int sprn, int gprn);
> +void spr_write_dawrx1(DisasContext *ctx, int sprn, int gprn);
>  void spr_write_ureg(DisasContext *ctx, int sprn, int gprn);
>  void spr_read_purr(DisasContext *ctx, int gprn, int sprn);
>  void spr_write_purr(DisasContext *ctx, int sprn, int gprn);
> diff --git a/target/ppc/translate.c b/target/ppc/translate.c
> index 049f636927..ac2a53f3b8 100644
> --- a/target/ppc/translate.c
> +++ b/target/ppc/translate.c
> @@ -593,6 +593,18 @@ void spr_write_dawrx0(DisasContext *ctx, int sprn, i=
nt gprn)
>      translator_io_start(&ctx->base);
>      gen_helper_store_dawrx0(tcg_env, cpu_gpr[gprn]);
>  }
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
>  #endif /* defined(TARGET_PPC64) && !defined(CONFIG_USER_ONLY) */
> =20
>  /* CTR */


