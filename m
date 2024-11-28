Return-Path: <kvm+bounces-32731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CEF9DB3B5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB07CB20AFC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637B714AD22;
	Thu, 28 Nov 2024 08:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bNhXCyPj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA081482ED;
	Thu, 28 Nov 2024 08:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732782372; cv=none; b=YNOsoeIwBNlU30UUDALfPOWNzaXUuafDB94MILD7OCByHugojtOIQJIXC75LiYJsZh9TvLVpYGwn2gDL2q90f+oAbyBymtHoITizu9n/Oho8VMNmGo88dHrVcDxJyFZypgs7PMwAPmJVqKo97TvL2Oe/i57pCtV9HbKilHIBZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732782372; c=relaxed/simple;
	bh=KnTt+gpffPYqEjoctoYO07iJ651WUQcNv09ElXMy8o4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YH84FooyBQjgWpyTij8rrulwuCz6PmZO7pQzW4bEn4XwDP8+Tw6wwIb/HGgyiW9NxRp17XniwUv/Vkije61WHOAuuIr0Nz8tF+lpzgbe+o9eP9w3UTr2mrTzDTm7hUBkYcTyG6+yVpATI8ewZJGTcXnepmu80tjTkA8tEjfoj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bNhXCyPj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AS7l41o018801;
	Thu, 28 Nov 2024 08:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+LNBbT
	HuAkFtgiCTuU90sverhmPCcJ47aBEmuxS/KC4=; b=bNhXCyPjGWz+WgeMnn7OTL
	YS5aUZBLVII24OY6ZNxQ6xn8GSxaXsWupNYTuB0R8fPkDp8QcvVDxTRKzOycxIJq
	xVEozJSawqayRTtfnbgO7H9fxa5YfrF6oNh2oh9OwJdepBP0zu9uc6hkSlpHTy8i
	kkSz8x1M4YYUFsw2RzL9fHbPoa6fRIEcWultcy8U2uZIY+CgzkUzjN9tVZxvhMT6
	5VfcpA8v7+L/u49vYQD9cPqsUeZAIV6R9OD8U1K5h3WpW8XYBY8tZYDxvlmMHSIi
	5FQUTIx0/ocupkvpCUK6guVtJ4mTGQbW1FdgcaG0ITi98VZ2JwrKJsXXfHi6j+Qg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4366ywkqrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:43 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4AS8NNNg024325;
	Thu, 28 Nov 2024 08:25:43 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4366ywkqrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AS3Drut025198;
	Thu, 28 Nov 2024 08:25:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43672ehb9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AS8PcBV53805344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Nov 2024 08:25:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E79342004F;
	Thu, 28 Nov 2024 08:25:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 854602004E;
	Thu, 28 Nov 2024 08:25:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 28 Nov 2024 08:25:37 +0000 (GMT)
Date: Thu, 28 Nov 2024 09:25:36 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Jones
 <ajones@ventanamicro.com>,
        James Houghton <jthoughton@google.com>,
        Muhammad
 Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v4 02/16] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <20241128092536.16e08a27@p-imbrenda>
In-Reply-To: <20241128005547.4077116-3-seanjc@google.com>
References: <20241128005547.4077116-1-seanjc@google.com>
	<20241128005547.4077116-3-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ShvezPq69i-LFsxNvQ_bfVQuWOYUlGqO
X-Proofpoint-ORIG-GUID: IdnUfe9YgAHZXSTT0osvIUbdYQS7wSWY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2411280063

On Wed, 27 Nov 2024 16:55:33 -0800
Sean Christopherson <seanjc@google.com> wrote:

> Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> a pointer to storage, as none of the vcpu_get_reg() usage in KVM selftests
> accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
> 64-bit value.  If a use case comes along that needs to get a register that
> is larger than 64 bits, then a utility can be added to assert success and
> take a void pointer, but until then, forcing an out param yields ugly code
> and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

for the s390 part:

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .../selftests/kvm/aarch64/aarch32_id_regs.c   | 10 +--
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
>  .../selftests/kvm/aarch64/hypercalls.c        |  6 +-
>  .../selftests/kvm/aarch64/no-vgic-v3.c        |  2 +-
>  .../testing/selftests/kvm/aarch64/psci_test.c |  6 +-
>  .../selftests/kvm/aarch64/set_id_regs.c       | 18 ++---
>  .../kvm/aarch64/vpmu_counter_access.c         | 19 +++---
>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +-
>  .../selftests/kvm/lib/aarch64/processor.c     |  8 +--
>  .../selftests/kvm/lib/riscv/processor.c       | 66 +++++++++----------
>  .../testing/selftests/kvm/riscv/arch_timer.c  |  2 +-
>  .../testing/selftests/kvm/riscv/ebreak_test.c |  2 +-
>  .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
>  tools/testing/selftests/kvm/s390x/resets.c    |  2 +-
>  tools/testing/selftests/kvm/steal_time.c      |  3 +-
>  15 files changed, 78 insertions(+), 78 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> index 8e5bd07a3727..447d61cae4db 100644
> --- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> @@ -97,7 +97,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
>  		uint64_t reg_id = raz_wi_reg_ids[i];
>  		uint64_t val;
>  
> -		vcpu_get_reg(vcpu, reg_id, &val);
> +		val = vcpu_get_reg(vcpu, reg_id);
>  		TEST_ASSERT_EQ(val, 0);
>  
>  		/*
> @@ -106,7 +106,7 @@ static void test_user_raz_wi(struct kvm_vcpu *vcpu)
>  		 */
>  		vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
>  
> -		vcpu_get_reg(vcpu, reg_id, &val);
> +		val = vcpu_get_reg(vcpu, reg_id);
>  		TEST_ASSERT_EQ(val, 0);
>  	}
>  }
> @@ -126,14 +126,14 @@ static void test_user_raz_invariant(struct kvm_vcpu *vcpu)
>  		uint64_t reg_id = raz_invariant_reg_ids[i];
>  		uint64_t val;
>  
> -		vcpu_get_reg(vcpu, reg_id, &val);
> +		val = vcpu_get_reg(vcpu, reg_id);
>  		TEST_ASSERT_EQ(val, 0);
>  
>  		r = __vcpu_set_reg(vcpu, reg_id, BAD_ID_REG_VAL);
>  		TEST_ASSERT(r < 0 && errno == EINVAL,
>  			    "unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
>  
> -		vcpu_get_reg(vcpu, reg_id, &val);
> +		val = vcpu_get_reg(vcpu, reg_id);
>  		TEST_ASSERT_EQ(val, 0);
>  	}
>  }
> @@ -144,7 +144,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
>  {
>  	uint64_t val, el0;
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> +	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
>  
>  	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
>  	return el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY;
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index ff7a949fc96a..c7fb55c9135b 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -501,7 +501,7 @@ void test_single_step_from_userspace(int test_cnt)
>  		TEST_ASSERT(ss_enable, "Unexpected KVM_EXIT_DEBUG");
>  
>  		/* Check if the current pc is expected. */
> -		vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
> +		pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
>  		TEST_ASSERT(!test_pc || pc == test_pc,
>  			    "Unexpected pc 0x%lx (expected 0x%lx)",
>  			    pc, test_pc);
> @@ -583,7 +583,7 @@ int main(int argc, char *argv[])
>  	uint64_t aa64dfr0;
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
> +	aa64dfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
>  	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
>  		       "Armv8 debug architecture not supported.");
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
> index 9d192ce0078d..ec54ec7726e9 100644
> --- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
> +++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
> @@ -173,7 +173,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
>  		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
>  
>  		/* First 'read' should be an upper limit of the features supported */
> -		vcpu_get_reg(vcpu, reg_info->reg, &val);
> +		val = vcpu_get_reg(vcpu, reg_info->reg);
>  		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
>  			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx",
>  			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
> @@ -184,7 +184,7 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
>  			"Failed to clear all the features of reg: 0x%lx; ret: %d",
>  			reg_info->reg, errno);
>  
> -		vcpu_get_reg(vcpu, reg_info->reg, &val);
> +		val = vcpu_get_reg(vcpu, reg_info->reg);
>  		TEST_ASSERT(val == 0,
>  			"Expected all the features to be cleared for reg: 0x%lx", reg_info->reg);
>  
> @@ -214,7 +214,7 @@ static void test_fw_regs_after_vm_start(struct kvm_vcpu *vcpu)
>  		 * Before starting the VM, the test clears all the bits.
>  		 * Check if that's still the case.
>  		 */
> -		vcpu_get_reg(vcpu, reg_info->reg, &val);
> +		val = vcpu_get_reg(vcpu, reg_info->reg);
>  		TEST_ASSERT(val == 0,
>  			"Expected all the features to be cleared for reg: 0x%lx",
>  			reg_info->reg);
> diff --git a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> index 58304bbc2036..ebd70430c89d 100644
> --- a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> +++ b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> @@ -164,7 +164,7 @@ int main(int argc, char *argv[])
>  	uint64_t pfr0;
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &pfr0);
> +	pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
>  	__TEST_REQUIRE(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), pfr0),
>  		       "GICv3 not supported.");
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index eaa7655fefc1..0ab7d5a24482 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -111,8 +111,8 @@ static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
>  {
>  	uint64_t obs_pc, obs_x0;
>  
> -	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &obs_pc);
> -	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> +	obs_pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
> +	obs_x0 = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.regs[0]));
>  
>  	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
>  		    "unexpected target cpu pc: %lx (expected: %lx)",
> @@ -152,7 +152,7 @@ static void host_test_cpu_on(void)
>  	 */
>  	vcpu_power_off(target);
>  
> -	vcpu_get_reg(target, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
> +	target_mpidr = vcpu_get_reg(target, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
>  	vcpu_args_set(source, 1, target_mpidr & MPIDR_HWID_BITMASK);
>  	enter_guest(source);
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index a79b7f18452d..25ba7d382196 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -346,7 +346,7 @@ static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
>  	uint64_t mask = ftr_bits->mask;
>  	uint64_t val, new_val, ftr;
>  
> -	vcpu_get_reg(vcpu, reg, &val);
> +	val = vcpu_get_reg(vcpu, reg);
>  	ftr = (val & mask) >> shift;
>  
>  	ftr = get_safe_value(ftr_bits, ftr);
> @@ -356,7 +356,7 @@ static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
>  	val |= ftr;
>  
>  	vcpu_set_reg(vcpu, reg, val);
> -	vcpu_get_reg(vcpu, reg, &new_val);
> +	new_val = vcpu_get_reg(vcpu, reg);
>  	TEST_ASSERT_EQ(new_val, val);
>  
>  	return new_val;
> @@ -370,7 +370,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
>  	uint64_t val, old_val, ftr;
>  	int r;
>  
> -	vcpu_get_reg(vcpu, reg, &val);
> +	val = vcpu_get_reg(vcpu, reg);
>  	ftr = (val & mask) >> shift;
>  
>  	ftr = get_invalid_value(ftr_bits, ftr);
> @@ -384,7 +384,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
>  	TEST_ASSERT(r < 0 && errno == EINVAL,
>  		    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
>  
> -	vcpu_get_reg(vcpu, reg, &val);
> +	val = vcpu_get_reg(vcpu, reg);
>  	TEST_ASSERT_EQ(val, old_val);
>  }
>  
> @@ -576,7 +576,7 @@ static void test_clidr(struct kvm_vcpu *vcpu)
>  	uint64_t clidr;
>  	int level;
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1), &clidr);
> +	clidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1));
>  
>  	/* find the first empty level in the cache hierarchy */
>  	for (level = 1; level < 7; level++) {
> @@ -601,7 +601,7 @@ static void test_ctr(struct kvm_vcpu *vcpu)
>  {
>  	u64 ctr;
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
> +	ctr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0));
>  	ctr &= ~CTR_EL0_DIC_MASK;
>  	if (ctr & CTR_EL0_IminLine_MASK)
>  		ctr--;
> @@ -617,7 +617,7 @@ static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
>  	test_clidr(vcpu);
>  	test_ctr(vcpu);
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
> +	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
>  	val++;
>  	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), val);
>  
> @@ -630,7 +630,7 @@ static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encodin
>  	size_t idx = encoding_to_range_idx(encoding);
>  	uint64_t observed;
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding), &observed);
> +	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
>  	TEST_ASSERT_EQ(test_reg_vals[idx], observed);
>  }
>  
> @@ -665,7 +665,7 @@ int main(void)
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
>  	/* Check for AARCH64 only system */
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> +	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
>  	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
>  	aarch64_only = (el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index f9c0c86d7e85..f16b3b27e32e 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -440,8 +440,7 @@ static void create_vpmu_vm(void *guest_code)
>  		       "Failed to create vgic-v3, skipping");
>  
>  	/* Make sure that PMUv3 support is indicated in the ID register */
> -	vcpu_get_reg(vpmu_vm.vcpu,
> -		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> +	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
>  	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), dfr0);
>  	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
>  		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
> @@ -484,7 +483,7 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
>  	create_vpmu_vm(guest_code);
>  	vcpu = vpmu_vm.vcpu;
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
> +	pmcr_orig = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
>  	pmcr = pmcr_orig;
>  
>  	/*
> @@ -493,7 +492,7 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
>  	 */
>  	set_pmcr_n(&pmcr, pmcr_n);
>  	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
>  
>  	if (expect_fail)
>  		TEST_ASSERT(pmcr_orig == pmcr,
> @@ -521,7 +520,7 @@ static void run_access_test(uint64_t pmcr_n)
>  	vcpu = vpmu_vm.vcpu;
>  
>  	/* Save the initial sp to restore them later to run the guest again */
> -	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
> +	sp = vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1));
>  
>  	run_vcpu(vcpu, pmcr_n);
>  
> @@ -572,12 +571,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
>  		 * Test if the 'set' and 'clr' variants of the registers
>  		 * are initialized based on the number of valid counters.
>  		 */
> -		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
> +		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id));
>  		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
>  			    "Initial read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
>  			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
>  
> -		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
> +		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id));
>  		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
>  			    "Initial read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
>  			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
> @@ -589,12 +588,12 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
>  		 */
>  		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), max_counters_mask);
>  
> -		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
> +		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id));
>  		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
>  			    "Read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
>  			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
>  
> -		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
> +		reg_val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id));
>  		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
>  			    "Read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx",
>  			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
> @@ -625,7 +624,7 @@ static uint64_t get_pmcr_n_limit(void)
>  	uint64_t pmcr;
>  
>  	create_vpmu_vm(guest_code);
> -	vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +	pmcr = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
>  	destroy_vpmu_vm();
>  	return get_pmcr_n(pmcr);
>  }
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index bc7c242480d6..287a3ec06df4 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -702,11 +702,13 @@ static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t va
>  
>  	return __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
>  }
> -static inline void vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
> +static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
>  {
> -	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
> +	uint64_t val;
> +	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
>  
>  	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
> +	return val;
>  }
>  static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
>  {
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 698e34f39241..7ba3aa3755f3 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -281,8 +281,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
>  	 */
>  	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
>  
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
> -	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
> +	sctlr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1));
> +	tcr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1));
>  
>  	/* Configure base granule size */
>  	switch (vm->mode) {
> @@ -360,8 +360,8 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
>  {
>  	uint64_t pstate, pc;
>  
> -	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate), &pstate);
> -	vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
> +	pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
> +	pc = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc));
>  
>  	fprintf(stream, "%*spstate: 0x%.16lx pc: 0x%.16lx\n",
>  		indent, "", pstate, pc);
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index 6ae47b3d6b25..dd663bcf0cc0 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -221,39 +221,39 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
>  {
>  	struct kvm_riscv_core core;
>  
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(mode), &core.mode);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &core.regs.pc);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.ra), &core.regs.ra);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.sp), &core.regs.sp);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.gp), &core.regs.gp);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.tp), &core.regs.tp);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t0), &core.regs.t0);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t1), &core.regs.t1);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t2), &core.regs.t2);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s0), &core.regs.s0);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s1), &core.regs.s1);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a0), &core.regs.a0);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a1), &core.regs.a1);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a2), &core.regs.a2);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a3), &core.regs.a3);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a4), &core.regs.a4);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a5), &core.regs.a5);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a6), &core.regs.a6);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a7), &core.regs.a7);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s2), &core.regs.s2);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s3), &core.regs.s3);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s4), &core.regs.s4);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s5), &core.regs.s5);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s6), &core.regs.s6);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s7), &core.regs.s7);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s8), &core.regs.s8);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s9), &core.regs.s9);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s10), &core.regs.s10);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s11), &core.regs.s11);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t3), &core.regs.t3);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t4), &core.regs.t4);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t5), &core.regs.t5);
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t6), &core.regs.t6);
> +	core.mode = vcpu_get_reg(vcpu, RISCV_CORE_REG(mode));
> +	core.regs.pc = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc));
> +	core.regs.ra = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.ra));
> +	core.regs.sp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.sp));
> +	core.regs.gp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.gp));
> +	core.regs.tp = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.tp));
> +	core.regs.t0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t0));
> +	core.regs.t1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t1));
> +	core.regs.t2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t2));
> +	core.regs.s0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s0));
> +	core.regs.s1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s1));
> +	core.regs.a0 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a0));
> +	core.regs.a1 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a1));
> +	core.regs.a2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a2));
> +	core.regs.a3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a3));
> +	core.regs.a4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a4));
> +	core.regs.a5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a5));
> +	core.regs.a6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a6));
> +	core.regs.a7 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.a7));
> +	core.regs.s2 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s2));
> +	core.regs.s3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s3));
> +	core.regs.s4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s4));
> +	core.regs.s5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s5));
> +	core.regs.s6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s6));
> +	core.regs.s7 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s7));
> +	core.regs.s8 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s8));
> +	core.regs.s9 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s9));
> +	core.regs.s10 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s10));
> +	core.regs.s11 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.s11));
> +	core.regs.t3 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t3));
> +	core.regs.t4 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t4));
> +	core.regs.t5 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t5));
> +	core.regs.t6 = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.t6));
>  
>  	fprintf(stream,
>  		" MODE:  0x%lx\n", core.mode);
> diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
> index 2c792228ac0b..9e370800a6a2 100644
> --- a/tools/testing/selftests/kvm/riscv/arch_timer.c
> +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> @@ -93,7 +93,7 @@ struct kvm_vm *test_vm_create(void)
>  		vcpu_init_vector_tables(vcpus[i]);
>  
>  	/* Initialize guest timer frequency. */
> -	vcpu_get_reg(vcpus[0], RISCV_TIMER_REG(frequency), &timer_freq);
> +	timer_freq = vcpu_get_reg(vcpus[0], RISCV_TIMER_REG(frequency));
>  	sync_global_to_guest(vm, timer_freq);
>  	pr_debug("timer_freq: %lu\n", timer_freq);
>  
> diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> index 0e0712854953..cfed6c727bfc 100644
> --- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
> +++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> @@ -60,7 +60,7 @@ int main(void)
>  
>  	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
>  
> -	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
> +	pc = vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc));
>  	TEST_ASSERT_EQ(pc, LABEL_ADDRESS(sw_bp_1));
>  
>  	/* skip sw_bp_1 */
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index f299cbfd23ca..f45c0ecc902d 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -608,7 +608,7 @@ static void test_vm_events_overflow(void *guest_code)
>  
>  	vcpu_init_vector_tables(vcpu);
>  	/* Initialize guest timer frequency. */
> -	vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency), &timer_freq);
> +	timer_freq = vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency));
>  	sync_global_to_guest(vm, timer_freq);
>  
>  	run_vcpu(vcpu);
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> index 357943f2bea8..b58f75b381e5 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -61,7 +61,7 @@ static void test_one_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t value)
>  {
>  	uint64_t eval_reg;
>  
> -	vcpu_get_reg(vcpu, id, &eval_reg);
> +	eval_reg = vcpu_get_reg(vcpu, id);
>  	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
>  }
>  
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index a8d3afa0b86b..cce2520af720 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -269,9 +269,8 @@ static void guest_code(int cpu)
>  static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
>  {
>  	uint64_t id = RISCV_SBI_EXT_REG(KVM_RISCV_SBI_EXT_STA);
> -	unsigned long enabled;
> +	unsigned long enabled = vcpu_get_reg(vcpu, id);
>  
> -	vcpu_get_reg(vcpu, id, &enabled);
>  	TEST_ASSERT(enabled == 0 || enabled == 1, "Expected boolean result");
>  
>  	return enabled;


