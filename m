Return-Path: <kvm+bounces-59567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A13AEBC0A1E
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1DE9A34CDDE
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF872571DA;
	Tue,  7 Oct 2025 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BH8dd2pj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91BC1A9FA8
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759825900; cv=none; b=qXOaPyz0cBKkJNWB+9FU6UiqMZAmfokuZffbUmsc5mJIUtKl3X1xAT1VGbwk+23XyOtzwsQ6znk9b+Hbig2Nv9sOvlgJ+k2yTWW7ci66p+pWx4aFUR6kmkCem75wxzN2L1SzWN5Vo3IOtCN6dvHicNrg9dNP6MPtyRQg6uM1Wjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759825900; c=relaxed/simple;
	bh=Z2G103WRNf0eJgFXLw8cA+FOko4uUAruokW1qjYA6+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jflln/gveiOKo88QLZbuWBlcgG/D8RVR79Cyf5u/GRjUrZkXAg+V9/KyvW4uHm+US54xy5yUFBIe60HZfl9NlO9dlJrGnwFUanWvHWy6s+FIYFnFesDcTr/OyPsS2wqtxZlnr8A5PR021IW/KAZNFL0GN7B69hNfZYVtqE8RHrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BH8dd2pj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596KjZ2c019687;
	Tue, 7 Oct 2025 08:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QoCxA3
	upJPwc3JROSyRfjTXKm9FjwOsBgO7yT79MHPw=; b=BH8dd2pjaHKB2mgS/x7Smh
	Du3SsJzilbPZDEooEN1ERRQF06L6GcNlvtnY1SWepGMiIej1TVIZYJg8J4/bHbgz
	ekts9P6GaS1ZPkmAzOAF+hg6gwfJL5nZz7SNBfuYs7wU4Js54ZBjyxp9h/7F0Dtq
	FOmM0E95toL2u/6kXydyzpJepS/FeD8JTZByl9a0KnEqBaV3muZFN+FKwQSWYtRi
	FWgSom0L1DH1BuNCxA92fN4K6U8owfwZ3tYF0Kox4kndTBpsB7deKCgK0VDaIT/I
	QVBdwz3iAxiinx/YkrOao8Y0xutnZr88N2ZH9POGZ3LO9Kw8bnb2utsVJ2nLDjPQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49ju93dv96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:31:06 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5978V6Mi005789;
	Tue, 7 Oct 2025 08:31:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49ju93dv92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:31:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5974dvvW001348;
	Tue, 7 Oct 2025 08:31:04 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49ke9y2fdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 08:31:04 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5978V3lI6358450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Oct 2025 08:31:03 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09E7E58050;
	Tue,  7 Oct 2025 08:31:03 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FC3C58052;
	Tue,  7 Oct 2025 08:30:54 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Oct 2025 08:30:54 +0000 (GMT)
Message-ID: <f1ccb5d3-03cc-4c95-9331-2131c176fd3b@linux.ibm.com>
Date: Tue, 7 Oct 2025 14:00:53 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] accel/kvm: Introduce KvmPutState enum
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        qemu-s390x@nongnu.org, Song Gao <gaosong@loongson.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo
 <arikalo@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>, qemu-riscv@nongnu.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Chinmay Rath <rathc@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        qemu-ppc@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20251007081616.68442-1-philmd@linaro.org>
 <20251007081616.68442-3-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251007081616.68442-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1CLejEvOLXsMAPhR4WMR4ncT0k5WNNLR
X-Proofpoint-ORIG-GUID: q3pf0Cg9ypKmPPaBF02Egy2LDObcGsUW
X-Authority-Analysis: v=2.4 cv=Fec6BZ+6 c=1 sm=1 tr=0 ts=68e4cfca cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10 a=KKAkSRfTAAAA:8
 a=VnNF1IyMAAAA:8 a=s3TylD3wWJY6YAG-Y_MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=oH34dK2VZjykjzsv8OSz:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=jd6J4Gguk5HxikPWLKER:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyMiBTYWx0ZWRfXxpHNF2VamO0b
 NdDDonvgy2ySEszKkOeRqDcVMTer3Ihc9DJeYIboT+wakJwrAHIjpY3AsqhwAkep93f41gIzR3F
 vRqOQG1kKpzkTXBnDMRb49ZaY6tRXkc7N24k9GJQKkFggDaO6iHAJpnLnHX+MA41Z5fvBI6XgEi
 DkVPksm56NPEgFEO36/52P+WFOhMkXSpcnHFS6h1b6+PoQqrQUHWF8bKPK/TPvjDjpY9r5EWeFs
 UPN8xwLM+kq5LDprnEjxHATyfYkoTRyzqivEXtP6eMTdJ3Vu+UQTKOvFbclThtjLbwYC+3u7f3Y
 AfcpUd7+I+npZpPH1EpV7inszZl8N/NAGCp60gtosVxlGKOtxsYI5Ac2jI6HzyDIc8KGojqF6fX
 V5ikMEi784CLx6xbMoDuDtM6jl/LVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040022



On 10/7/25 13:46, Philippe Mathieu-Daudé wrote:
> Join the 3 KVM_PUT_*_STATE definitions in a single enum.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

> ---
>   include/system/kvm.h       | 16 +++++++++-------
>   target/i386/kvm/kvm.c      |  6 +++---
>   target/loongarch/kvm/kvm.c |  4 ++--
>   target/mips/kvm.c          |  6 +++---
>   target/ppc/kvm.c           |  2 +-
>   target/riscv/kvm/kvm-cpu.c |  2 +-
>   target/s390x/kvm/kvm.c     |  2 +-
>   7 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index 4fc09e38910..8f9eecf044c 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -340,14 +340,16 @@ int kvm_arch_process_async_events(CPUState *cpu);
>   
>   int kvm_arch_get_registers(CPUState *cpu, Error **errp);
>   
> -/* state subset only touched by the VCPU itself during runtime */
> -#define KVM_PUT_RUNTIME_STATE   1
> -/* state subset modified during VCPU reset */
> -#define KVM_PUT_RESET_STATE     2
> -/* full state set, modified during initialization or on vmload */
> -#define KVM_PUT_FULL_STATE      3
> +typedef enum kvm_put_state {
> +    /* state subset only touched by the VCPU itself during runtime */
> +    KVM_PUT_RUNTIME_STATE = 1,
> +    /* state subset modified during VCPU reset */
> +    KVM_PUT_RESET_STATE = 2,
> +    /* full state set, modified during initialization or on vmload */
> +    KVM_PUT_FULL_STATE = 3,
> +} KvmPutState;
>   
> -int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp);
> +int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp);
>   
>   int kvm_arch_get_default_type(MachineState *ms);
>   
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6a3a1c1ed8e..d06f55938cd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3911,7 +3911,7 @@ static void kvm_init_msrs(X86CPU *cpu)
>       assert(kvm_buf_set_msrs(cpu) == 0);
>   }
>   
> -static int kvm_put_msrs(X86CPU *cpu, int level)
> +static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>   {
>       CPUX86State *env = &cpu->env;
>       int i;
> @@ -5031,7 +5031,7 @@ static int kvm_get_apic(X86CPU *cpu)
>       return 0;
>   }
>   
> -static int kvm_put_vcpu_events(X86CPU *cpu, int level)
> +static int kvm_put_vcpu_events(X86CPU *cpu, KvmPutState level)
>   {
>       CPUState *cs = CPU(cpu);
>       CPUX86State *env = &cpu->env;
> @@ -5274,7 +5274,7 @@ static int kvm_get_nested_state(X86CPU *cpu)
>       return ret;
>   }
>   
> -int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
>   {
>       X86CPU *x86_cpu = X86_CPU(cpu);
>       int ret;
> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
> index 45292edcb1c..32cd7c5d003 100644
> --- a/target/loongarch/kvm/kvm.c
> +++ b/target/loongarch/kvm/kvm.c
> @@ -325,7 +325,7 @@ static int kvm_loongarch_get_csr(CPUState *cs)
>       return ret;
>   }
>   
> -static int kvm_loongarch_put_csr(CPUState *cs, int level)
> +static int kvm_loongarch_put_csr(CPUState *cs, KvmPutState level)
>   {
>       int ret = 0;
>       CPULoongArchState *env = cpu_env(cs);
> @@ -763,7 +763,7 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
>       return ret;
>   }
>   
> -int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
>   {
>       int ret;
>       static int once;
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 450947c3fa5..912cd5dfa0e 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -590,7 +590,7 @@ static void kvm_mips_update_state(void *opaque, bool running, RunState state)
>       }
>   }
>   
> -static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
> +static int kvm_mips_put_fpu_registers(CPUState *cs, KvmPutState level)
>   {
>       CPUMIPSState *env = cpu_env(cs);
>       int err, ret = 0;
> @@ -749,7 +749,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
>   }
>   
>   
> -static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
> +static int kvm_mips_put_cp0_registers(CPUState *cs, KvmPutState level)
>   {
>       CPUMIPSState *env = cpu_env(cs);
>       int err, ret = 0;
> @@ -1177,7 +1177,7 @@ static int kvm_mips_get_cp0_registers(CPUState *cs)
>       return ret;
>   }
>   
> -int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
>   {
>       CPUMIPSState *env = cpu_env(cs);
>       struct kvm_regs regs;
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 2521ff65c6c..cd60893a17d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -907,7 +907,7 @@ int kvmppc_put_books_sregs(PowerPCCPU *cpu)
>       return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS, &sregs);
>   }
>   
> -int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
>   {
>       PowerPCCPU *cpu = POWERPC_CPU(cs);
>       CPUPPCState *env = &cpu->env;
> diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
> index 187c2c9501e..75ca3fb9fd9 100644
> --- a/target/riscv/kvm/kvm-cpu.c
> +++ b/target/riscv/kvm/kvm-cpu.c
> @@ -1369,7 +1369,7 @@ int kvm_riscv_sync_mpstate_to_kvm(RISCVCPU *cpu, int state)
>       return 0;
>   }
>   
> -int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
>   {
>       int ret = 0;
>   
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 491cc5f9756..916dac1f14e 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -468,7 +468,7 @@ static int can_sync_regs(CPUState *cs, int regs)
>   #define KVM_SYNC_REQUIRED_REGS (KVM_SYNC_GPRS | KVM_SYNC_ACRS | \
>                                   KVM_SYNC_CRS | KVM_SYNC_PREFIX)
>   
> -int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
> +int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
>   {
>       CPUS390XState *env = cpu_env(cs);
>       struct kvm_fpu fpu = {};

