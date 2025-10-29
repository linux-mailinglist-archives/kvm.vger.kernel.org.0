Return-Path: <kvm+bounces-61398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB77C1B36A
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 620C45C6F88
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71BF293C4E;
	Wed, 29 Oct 2025 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gnPumJ+D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB026657B;
	Wed, 29 Oct 2025 14:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746944; cv=none; b=J9bHHkG467n7uaQBQplPkUEObcEsOJR4+1PfIMm4bKDFavEuGTLVtclbERxJBfmH86qi1tvHjAZb6NJFxP2sDwIq+s/BcxreLe5MS+UqwPY9Q35xPWojFn2Xx7/zMpvJ0JCzhaPEOdjl6G0dlOCRMBWqAAlkCM4bJsbbxrE06Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746944; c=relaxed/simple;
	bh=c1m3J+Rx9ZiZODjjT1uvIymATzO2zQNIZSr/h1PvY44=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svQFo6xK852XS5nOy1ugQ8oPOE0nVJxGkALN3dQItjkD8mKoXGslN/hQRO3ttzG4NmLJEbxJJzefibOTgMn7NiZe6iy6AeTbhl0Tawbx7cxOmiFWqa2C4IZX0ki+fqOJlfXrkcu3u+/x+7uqt9dOQwWQXUiAxCVwA33pVCUoTS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gnPumJ+D; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TBAKDx003296;
	Wed, 29 Oct 2025 14:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=olrRQO
	X7/VXsSE4nW19CzEEV62rDDGjCFrPV+IH7g/M=; b=gnPumJ+DWIFhEfL69XgFSL
	bmbfq5JjPDxZkySJ4DMmxOKwFpWjYQYMIb3cEuepcRbc6gVqGot1BA13PQ5QB9Cn
	KKmoy2+MH8a//5qDxE/1Xy5v61PWCVxjOOzSXy+e94aexQKxA5UiH60X45inO4l5
	DAej/qorUfyOI71DeilAn67GyUkW8VcJLJvJQWSq3XEDEIVJyOBdu7j6dKP/lGKt
	5X55Udd3h30J4lPZpp4b+hbVLhGgX8aFuwAuY0vLFSrrkhqY4cXgOTJHw6wNFYMl
	Qc71bY1ajhRtRuSmJyVs8qzw7RgnOSCXsnmBanBPLLDWzLoOSudnDY5a//s0oBfA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34a8kpkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 14:08:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59TDmVaG019510;
	Wed, 29 Oct 2025 14:08:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33xy3mj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 14:08:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TE8sHV41484548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 14:08:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 576AD20043;
	Wed, 29 Oct 2025 14:08:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AEA820040;
	Wed, 29 Oct 2025 14:08:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.155.153])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 29 Oct 2025 14:08:53 +0000 (GMT)
Date: Wed, 29 Oct 2025 15:07:24 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@linux.ibm.com
Subject: Re: [PATCH] KVM: s390: Add capability that forwards operation
 exceptions
Message-ID: <20251029150724.77b8fc49@p-imbrenda>
In-Reply-To: <20251029130744.6422-1-frankja@linux.ibm.com>
References: <20251029130744.6422-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=DYkaa/tW c=1 sm=1 tr=0 ts=69021ffb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=j0Gcr9eBVSwF2D00pIoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tLbxF4xlW6xspzTvyRGZfcwc9HsAy3h2
X-Proofpoint-ORIG-GUID: tLbxF4xlW6xspzTvyRGZfcwc9HsAy3h2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX5otefIdtNQAv
 bdvRxG7UKGVBfmlj4vpKdzAaHb1JAco2swXp26PCoatSVcguF4eJsSQXHv6QsQx5JXeBs9WKNnb
 e04egXNKM1McmuKCRgnkMpAcNIplIFbXMyMy2PxBOYkiWQiLscuJSV1PD1tBMN9LZJWsY01R9IW
 5j18xNLTIQRNA+fXZOMGOnl8/NyDNAtq+MvUaAV1NeQUKIZ9TVI/Sk+IJkLG8f9VbNf9PkW/RH8
 UEqlFJ5A8Ec5A98DdQzy9TBykIVGvJgXONVymU2s7O3BcY1EAsIx/PmC9WrBmiAA0jA800j+fPY
 tBqjeQpW/FCfwzweZz86BuhzaOw0XAfSjWFQUW61HmdAc10R/fmfSWCmFOVf/V5YtSj0JHUlqeu
 owJNWJ7HhqeWHhR4VxAY6Jc1OBVjQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_05,2025-10-29_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On Wed, 29 Oct 2025 13:04:11 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
> exceptions to user space. This also includes the 0x0000 instructions
> managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
> to emulate instructions which do not (yet) have an opcode.
> 
> While we're at it refine the documentation for
> KVM_CAP_S390_USER_INSTR0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> This is based on the api documentation ordering fix that's in our next
> branch.
> 
> ---
>  Documentation/virt/kvm/api.rst                |  17 ++-
>  arch/s390/include/asm/kvm_host.h              |   1 +
>  arch/s390/kvm/intercept.c                     |   3 +
>  arch/s390/kvm/kvm-s390.c                      |   7 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../selftests/kvm/s390/user_operexec.c        | 140 ++++++++++++++++++
>  7 files changed, 169 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/s390/user_operexec.c
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 72b2fae99a83..67837207dc9b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7820,7 +7820,7 @@ where 0xff represents CPUs 0-7 in cluster 0.
>  :Architectures: s390
>  :Parameters: none
>  
> -With this capability enabled, all illegal instructions 0x0000 (2 bytes) will
> +With this capability enabled, the illegal instruction 0x0000 (2 bytes) will
>  be intercepted and forwarded to user space. User space can use this
>  mechanism e.g. to realize 2-byte software breakpoints. The kernel will
>  not inject an operating exception for these instructions, user space has
> @@ -8703,6 +8703,21 @@ This capability indicate to the userspace whether a PFNMAP memory region
>  can be safely mapped as cacheable. This relies on the presence of
>  force write back (FWB) feature support on the hardware.
>  
> +7.45 KVM_CAP_S390_USER_OPEREXEC
> +----------------------------
> +
> +:Architectures: s390
> +:Parameters: none
> +
> +When this capability is enabled KVM forwards all operation exceptions
> +that it doesn't handle itself to user space. This also includes the
> +0x0000 instructions managed by KVM_CAP_S390_USER_INSTR0. This is
> +helpful if user space wants to emulate instructions which do not (yet)
> +have an opcode.
> +
> +This capability can be enabled dynamically even if VCPUs were already
> +created and are running.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 22cedcaea475..1e4829c70216 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -648,6 +648,7 @@ struct kvm_arch {
>  	int user_sigp;
>  	int user_stsi;
>  	int user_instr0;
> +	int user_operexec;
>  	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
>  	wait_queue_head_t ipte_wq;
>  	int ipte_lock_count;
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index c7908950c1f4..420ae62977e2 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -471,6 +471,9 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.sie_block->ipa == 0xb256)
>  		return handle_sthyi(vcpu);
>  
> +	if (vcpu->kvm->arch.user_operexec)
> +		return -EOPNOTSUPP;
> +
>  	if (vcpu->arch.sie_block->ipa == 0 && vcpu->kvm->arch.user_instr0)
>  		return -EOPNOTSUPP;
>  	rc = read_guest_lc(vcpu, __LC_PGM_NEW_PSW, &newpsw, sizeof(psw_t));
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 70ebc54b1bb1..56d4730b7c41 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_S390_DIAG318:
>  	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_S390_USER_OPEREXEC:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -921,6 +922,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
>  			 r ? "(not available)" : "(success)");
>  		break;
> +	case KVM_CAP_S390_USER_OPEREXEC:
> +		VM_EVENT(kvm, 3, "%s", "ENABLE: CAP_S390_USER_OPEREXEC");
> +		kvm->arch.user_operexec = 1;
> +		icpt_operexc_on_all_vcpus(kvm);
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab020..8ab07396ce3b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -963,6 +963,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
>  #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
>  #define KVM_CAP_GUEST_MEMFD_FLAGS 244
> +#define KVM_CAP_S390_USER_OPEREXEC 245
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 148d427ff24b..87e429206bb8 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -194,6 +194,7 @@ TEST_GEN_PROGS_s390 += s390/debug_test
>  TEST_GEN_PROGS_s390 += s390/cpumodel_subfuncs_test
>  TEST_GEN_PROGS_s390 += s390/shared_zeropage_test
>  TEST_GEN_PROGS_s390 += s390/ucontrol_test
> +TEST_GEN_PROGS_s390 += s390/user_operexec
>  TEST_GEN_PROGS_s390 += rseq_test
>  
>  TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
> diff --git a/tools/testing/selftests/kvm/s390/user_operexec.c b/tools/testing/selftests/kvm/s390/user_operexec.c
> new file mode 100644
> index 000000000000..714906c1d12a
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/s390/user_operexec.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Test operation exception forwarding.
> + *
> + * Copyright IBM Corp. 2025
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include "kselftest.h"
> +#include "kvm_util.h"
> +#include "test_util.h"
> +#include "sie.h"
> +
> +#include <linux/kvm.h>
> +
> +static void guest_code_instr0(void)
> +{
> +	asm(".word 0x0000");
> +}
> +
> +static void test_user_instr0(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int rc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_instr0);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void guest_code_user_operexec(void)
> +{
> +	asm(".word 0x0807");
> +}
> +
> +static void test_user_operexec(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int rc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
> +
> +	kvm_vm_free(vm);
> +
> +	/*
> +	 * Since user_operexec is the superset it can be used for the
> +	 * 0 instruction.
> +	 */
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_instr0);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +/* combine user_instr0 and user_operexec */
> +static void test_user_operexec_combined(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int rc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
> +
> +	kvm_vm_free(vm);
> +
> +	/* Reverse enablement order */
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
> +	TEST_ASSERT_EQ(0, rc);
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
> +	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +/*
> + * Run all tests above.
> + *
> + * Enablement after VCPU has been added is automatically tested since
> + * we enable the capability after VCPU creation.
> + */
> +static struct testdef {
> +	const char *name;
> +	void (*test)(void);
> +} testlist[] = {
> +	{ "instr0", test_user_instr0 },
> +	{ "operexec", test_user_operexec },
> +	{ "operexec_combined", test_user_operexec_combined},
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int idx;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_USER_INSTR0));
> +
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(testlist));
> +	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
> +		testlist[idx].test();
> +		ksft_test_result_pass("%s\n", testlist[idx].name);
> +	}
> +	ksft_finished();
> +}


