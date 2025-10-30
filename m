Return-Path: <kvm+bounces-61465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44381C1EB27
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 08:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C13218846CA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993AD335090;
	Thu, 30 Oct 2025 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJP2ABNb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E53595D
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 07:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761808237; cv=none; b=cbFrLtp8J+9M2C4HpFaWrM+/aRKxt+UtVm5K7QNhOjeuU3YdDZKr1iEefU7QXEiPiV3Lt6hn2Mu1ksY5WbmZR4eI3pIjzc76Y/jQJvOgthRjZ9m0CL395VWBmPKJRULjGBKs6whcg8FQjyXfudu8HC2DB8qrqbX3dsoZZb7aal8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761808237; c=relaxed/simple;
	bh=5JkzTi997kN0sgfmtcEiyk+iaBLxy/jKvLnj2SHB8H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WW5PzrtnEigtEEKa4VHp3OOxyeJAhG8czIuw6NehL4WXrdL2rJ28qrdnO/XHJEgurWLV3VeCcqYBUqIKa2gjfCCYnnfOhzzwPKWGVPxr3QQJ0Lvk+X5RJFYad+5VXucm1JbwE6Lo1HYGhl6HLz/r/Uy3KuDuvGs0TR7BktZGv6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJP2ABNb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761808234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WZSZHhpwvYMwWpoDKbSAMAl1z0wXtsF/edr0XL1/Ej4=;
	b=NJP2ABNbZMAdLaMVzBeMboctixbxRB3e1JHXQuaPWE2LzQESjZg+G0scu/nqCaynMqsP8O
	COiDNL5scDpM59piHx2ASfhP6iMFGSBDEHqh+JRj4c522vPLhEI6J1Aw8ZmcivSrBIrOpD
	b9+aMBxPxm5KfZLmZjh3SpuVbx8vSK0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-wb1GHe5SOUCOQ0QdOFNpVA-1; Thu, 30 Oct 2025 03:10:32 -0400
X-MC-Unique: wb1GHe5SOUCOQ0QdOFNpVA-1
X-Mimecast-MFC-AGG-ID: wb1GHe5SOUCOQ0QdOFNpVA_1761808231
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475c422fd70so7035715e9.2
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 00:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761808231; x=1762413031;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WZSZHhpwvYMwWpoDKbSAMAl1z0wXtsF/edr0XL1/Ej4=;
        b=PfhLI9MMp2qHdcff2bLiBkzrebAgPTGQCx+eq49GYnaAd8Ac1VtVDHwEteKsnxkf2R
         xRHtMXUaBi9FNhEdOrdLO672iacnK1Mkxy8GoLPGzg2D9D6jeEj3qoYBXCyctLKdyzct
         XizL+jYpJy6sSsyN2ja4XEEK5uywnK6JnTvpA3CBV6gM9zyoxO9+piuk6NDD58dP5Na5
         Lrkp+nXWdDv1pbHI5NERBJHkiy33hxs1b5LcAnEaPAhDvhuWYsnqsHu5+6N6ESz68/I5
         UnYoqAKCQr5dk8uHkzuAzr3iMZzuvNtHG4Db3mY+8qVanwWpRThDB7FcsbaNCvkbU6td
         YUAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9zXFwpDA98dRWAksv7dOBg5Jl9fmQMPFoFkP4IxsuAqVth9L5fG/m72GEsT/m+oELdUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlmicSslWxDrivX4/g+QwgbA8v3AomkQDAe2CUTKNPXMhwH0WV
	eU4tDt27851Ob4GTWQERg++JrlDKao2U/bKVlUfg32SewqHkA6nm/hYC3dAsWWAWBbnvJpczecq
	qBS+8YnnFLTXEmtSxw/dIuChcbHBtcjPD2McKPMIij/HdznXcfI9ZUGDrmbTjug==
X-Gm-Gg: ASbGncv3qS9LYshhCxOs5FxnWGkQkk/MZO1OPuKuFsSMPKD1lKPsjBtRVAhVRfiui4F
	hddP/5FDrEC3zmtEFmVnuEIqMIEK8Oqcm2o+ksnNyHek0QhxxjbIFn252F9Otj7JVvU9vc6z1CO
	P6ON3n6mN9u5mnkk1t6hNEufYshL5dCOi7WN5cBG98XFnm21oo2vlNwfeN1d5/Pvl0MZUuyHsUb
	li8G0OzGpQthEdyhth4Knmnt8zynhSVfSJ47PPeNb5rIiHLo2XKYguQ9boyGY8DfyZIMbWdhr2c
	8rh1YIsskJwdQnZFo3TIM7YZCc4pHjzLiuenK8df2EkBJrsc2Mde4BpAl2gshNl8cp5l06A=
X-Received: by 2002:a05:600c:348a:b0:475:dd89:ac7 with SMTP id 5b1f17b1804b1-47726701f1bmr15456465e9.1.1761808231110;
        Thu, 30 Oct 2025 00:10:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqeevsnKMe4HH8gGbFE46zbpABnU5cwtrH1X7QxmODtgnzTuLbZl4YOb6NAxOyp2kyybvicg==
X-Received: by 2002:a05:600c:348a:b0:475:dd89:ac7 with SMTP id 5b1f17b1804b1-47726701f1bmr15456195e9.1.1761808230630;
        Thu, 30 Oct 2025 00:10:30 -0700 (PDT)
Received: from [192.168.0.7] ([47.64.112.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289adaf8sm25922695e9.7.2025.10.30.00.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 00:10:30 -0700 (PDT)
Message-ID: <8c25cc75-021d-4199-96de-83e06e16a514@redhat.com>
Date: Thu, 30 Oct 2025 08:10:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Add capability that forwards operation
 exceptions
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
 borntraeger@linux.ibm.com
References: <20251029130744.6422-1-frankja@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20251029130744.6422-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/10/2025 14.04, Janosch Frank wrote:
> Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
> exceptions to user space. This also includes the 0x0000 instructions
> managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
> to emulate instructions which do not (yet) have an opcode.
> 
> While we're at it refine the documentation for
> KVM_CAP_S390_USER_INSTR0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
...
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

"which do not (yet) have an opcode" sounds a little bit weird. Maybe rather: 
"which are not (yet) implemented in the current CPU" or so?

> +This capability can be enabled dynamically even if VCPUs were already
> +created and are running.
> +
>   8. Other capabilities.
>   ======================
...
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index c7908950c1f4..420ae62977e2 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -471,6 +471,9 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.sie_block->ipa == 0xb256)
>   		return handle_sthyi(vcpu);
>   
> +	if (vcpu->kvm->arch.user_operexec)
> +		return -EOPNOTSUPP;
> +
>   	if (vcpu->arch.sie_block->ipa == 0 && vcpu->kvm->arch.user_instr0)
>   		return -EOPNOTSUPP;
>   	rc = read_guest_lc(vcpu, __LC_PGM_NEW_PSW, &newpsw, sizeof(psw_t));
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 70ebc54b1bb1..56d4730b7c41 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
>   	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_S390_USER_OPEREXEC:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -921,6 +922,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
>   			 r ? "(not available)" : "(success)");
>   		break;
> +	case KVM_CAP_S390_USER_OPEREXEC:
> +		VM_EVENT(kvm, 3, "%s", "ENABLE: CAP_S390_USER_OPEREXEC");
> +		kvm->arch.user_operexec = 1;
> +		icpt_operexc_on_all_vcpus(kvm);

Maybe check cap->flags here and return with an error if any flag is set? ... 
otherwise, if we ever add flags here, userspace cannot check whether the 
kernel accepted a flag or not.

> +		r = 0;
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
...
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

You could likely use the KVM_ONE_VCPU_TEST() macro and test_harness_run() to 
get rid of the boilerplate code here.

  Thomas


